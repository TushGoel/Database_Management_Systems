-- CS5200 HW4: Books that will change your life
-- Instructions: Run the script "hw4_library_setup.sql" in a ROOT connection
-- This will create a new schema called "library"
-- Write a query that answers each question below.
-- Save this file as HW4_YourFullName.sql and submit to Blackboard

-- Questions 1-12 are 8 points each. Question 13 is worth 4 points.

USE library;

-- 1. Which book(s) are Science Fiction books written in the 1960's?
-- List title, author, and year of publication
-- Ans-1
SELECT title AS 'Book_Title', Author, year AS 'Year_Of_Publication'
FROM 
book JOIN genre USING(genre_id)
WHERE year BETWEEN 1960 AND 1969 AND genre_name='Science Fiction';


-- 2. Which users have borrowed no books?
-- Give name and city they live in
-- Write the query in two ways, once by selecting from only one table
-- and using a subquery, and again by joining two tables together.
-- Ans-2
-- (a) Method using subquery (4 points)
SELECT user_name AS 'User', city
FROM user
WHERE user_id NOT IN (SELECT user_id 
FROM borrow);

-- (b) Method using a join (4 points)
SELECT user_name AS 'User', city
FROM user u LEFT JOIN borrow b USING (user_id)
WHERE b.user_id IS NULL;


-- 3. How many books were borrowed by each user in each month?
-- Your table should have three columns: user_name, month, num_borrowed
-- You may ignore users that didn't borrow any books and months in which no books were borrowed.
-- Sort by name, then month
-- The month(date) function returns the month number (1,2,3,...12) of a given date. This is adequate for output.
-- Ans-3
SELECT user_name AS 'User', 
MONTH(borrow_dt) AS 'Month', 
COUNT(user_id) AS 'Num_borrowed'
FROM user JOIN borrow USING(user_id)
GROUP BY user_id, MONTH
ORDER BY user_name, MONTH;


-- 4. How many times was each book checked out?
-- Output the book's title, genre name, and the number of times it was checked out, and whether the book is still in circulation
-- Include books never borrowed
-- Order from most borrowed to least borrowed
-- Ans-4
SELECT title AS 'Book_title', 
genre_name AS 'Book_Genre', 
COUNT(borrow_dt) AS 'No_of_times_checked_out', in_circulation
FROM borrow RIGHT JOIN book USING(book_id)
JOIN genre USING(genre_id)
GROUP BY book_id
ORDER BY No_of_times_checked_out DESC;


-- 5. How many times did each user return a book late?
-- Include users that never returned a book late or never even borrowed a book
-- Sort by most number of late returns to least number of late returns (regardless of HOW late the returns were.)
-- Ans-5
SELECT user_name AS 'User',
SUM(CASE WHEN return_dt > due_dt THEN 1 ELSE 0 END) AS 'Late_return'
FROM 
user LEFT JOIN borrow USING(user_id)
LEFT JOIN book USING (book_id)
GROUP BY user_id
ORDER BY Late_return DESC;


-- 6. How many books of each genre where published after 1950?
-- Include genres that are not represented by any book in our catalog
-- as well as genres for which there are books but none published after 1950.
-- Sort output by number of titles in each genre (most to least)
-- Ans-6
SELECT genre_name AS 'Book_Genre', 
COUNT(title) AS 'No_of_Books'
FROM genre g LEFT JOIN book b ON (g.genre_id=b.genre_id AND b.year>1950)
GROUP BY g.genre_id
ORDER BY No_of_Books DESC;


-- 7. For each genre, compute a) the number of books borrowed and b) the average
-- number of days borrowed. 
-- Includes books never borrowed and genres with no books
-- and in these cases, show zeros instead of null values.
-- Round the averages to one decimal point
-- Sort output in descending order by average
-- Helpful functions: ROUND, IFNULL, DATEDIFF
-- Ans-7
SELECT genre_name AS 'Book_Genre', 
COUNT(br.book_id) AS 'No_of_books_borrowed ', 
IFNULL(ROUND(SUM(DATEDIFF(return_dt,borrow_dt)) / (COUNT(br.book_id)),1),0) AS 'Avg_days_borrowed'
FROM borrow br RIGHT JOIN book b USING(book_id)
RIGHT JOIN genre g USING(genre_id)
GROUP BY g.genre_id
ORDER BY Avg_days_borrowed DESC;


-- 8. List all pairs of books published within 10 years of each other
-- Don't include the book with itself
-- Only list (X,Y) pairs where X was published earlier
-- Output the two titles, and the years they were published, the number of years apart they were published
-- Order pairs from those published closest together to farthest
-- Ans-8
SELECT x.title, x.year, y.title, y.year, ABS(x.year-y.year) AS 'Years_published_apart'
FROM book x JOIN book y ON 
(x.title<>y.title 
AND x.year-y.year BETWEEN -10 AND 0)
ORDER BY Years_published_apart;


-- 9. Assuming books are returned completely read,
-- Rank the users from fastest to slowest readers (pages per day)
-- include users that borrowed no books (report reading rate as 0.0)
-- Ans-9
SELECT user_name AS 'User', 
IFNULL(SUM(pages),0) AS 'Total_pages_read', 
IFNULL(SUM(DATEDIFF(return_dt,borrow_dt)),0) AS 'Total_days_taken',
IFNULL(ROUND((SUM(pages)/SUM(DATEDIFF(return_dt,borrow_dt))),1),0.0) AS 'Reading_rate'
FROM 
book JOIN borrow USING(book_id)
RIGHT JOIN user USING(user_id)
GROUP BY user_id
ORDER BY Reading_rate DESC;


-- 10. How many books of each genre were checked out by John?
-- Sort descending by number of books checked out in each genre category.
-- Only include genres where at least two books of that genre were checked out.  
-- (Count each time the book was checked out even if the same book was checked out
-- by John more than once.)
-- Ans-10

SELECT genre_name AS 'Book_Genre', 
COUNT(borrow_dt) AS 'No_of_books_checked_out'
FROM borrow JOIN book USING(book_id)
JOIN genre USING(genre_id)
WHERE user_id IN (SELECT user_id FROM user WHERE user_name='John')
GROUP BY genre_name
HAVING No_of_books_checked_out >= 2
ORDER BY No_of_books_checked_out DESC;


-- 11. On average how many books are borrowed per user?
-- Output two averages in one row: one average that includes users that
-- borrowed no books, and one average that excludes users that borrowed no books
-- Ans-11
SELECT 
ROUND((COUNT(book_id)/COUNT(DISTINCT user.user_id)),2) AS 'All_Users_Average',
ROUND((COUNT(book_id)/COUNT(DISTINCT borrow.user_id)),2) AS 'Only_Borrowed_Users_Average'
FROM borrow RIGHT JOIN user USING(user_id);


-- 12. How much does each user owe the library. Include users owing nothing
-- Factor in the 10 cents per day fine for late returns and how much they have already paid the library
-- HINTS: 
--     The DATEDIFF function takes two dates and counts the number of dates between them
--     The IF function, used in a SELECT clause, might also be helpful.  IF(condition, result_if_true, result_if_false)
--     IF functions can be used inside aggregation functions!
-- Ans-12
SELECT user_name AS 'User', 
Total_fine, IFNULL(Fine_Paid,0) AS 'Fine_Paid', 
IFNULL((Total_fine-Fine_Paid),0)  AS 'Fine_owed'
FROM 
(SELECT user.user_id, user_name,
SUM(CASE WHEN return_dt>due_dt THEN (0.10*DATEDIFF(return_dt,due_dt)) ELSE 0 END) AS 'Total_Fine'
FROM borrow RIGHT JOIN user USING(user_id)
GROUP BY user_id) AS Fine_Amount 
LEFT JOIN
(SELECT user_id, SUM(amount) AS 'Fine_Paid'
FROM payment
GROUP BY user_id) AS Fine_Payment 
USING (user_id)
ORDER BY Fine_owed DESC;


-- 13. (4 points) Which books will change your life?
-- Answer: All books. 
-- Select all books.
-- ANS-13
SELECT DISTINCT title AS 'Books', author
FROM book
ORDER BY book_id;

