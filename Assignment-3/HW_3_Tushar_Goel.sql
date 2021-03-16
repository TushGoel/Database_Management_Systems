CREATE SCHEMA twitter_x;

USE twitter_x;

-- User Table 
-- Note: Visibility = 1 meaning user is visible, otherwise hidden
-- Note: Org_Status = 1 meaning user-id belongs to organization, otherwise it is individual
CREATE TABLE IF NOT EXISTS User_Table (
  User_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  User_name VARCHAR(50) NOT NULL,
  Twitter_handle VARCHAR(60) NOT NULL,
  Email_address VARCHAR(50) NOT NULL,
  User_Password VARCHAR(20) NOT NULL,
  Short_profile VARCHAR(255) NULL,
  Visibility TINYINT NOT NULL,
  Org_Status TINYINT NOT NULL
  );
  ALTER TABLE User_Table AUTO_INCREMENT=1;


-- Nest Table
CREATE TABLE IF NOT EXISTS Nest_Table (
  Nest_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  Nest_name VARCHAR(30) UNIQUE NOT NULL,
  Created_by INT NOT NULL,
  FOREIGN KEY (Created_by) REFERENCES User_Table(User_id)
  );  
  ALTER TABLE Nest_Table AUTO_INCREMENT=100;

  
-- Tweet Table
-- If Tweet_id has corresponding Non-Nullable Nest_id Column that means it is a Nest_Message not a Broadcast message
-- On the other hand, if Nest_id column is Null corresponding to that Tweet_id, then the Tweet is a broadcast tweet.  
CREATE TABLE IF NOT EXISTS Tweet_Table (
  Tweet_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  Tweet_Message VARCHAR(160) NOT NULL,
  User_id INT NOT NULL,
  Nest_id INT NULL,
  Time_Stamp DATETIME NOT NULL,
  FOREIGN KEY (User_id) REFERENCES User_Table(User_id),
  FOREIGN KEY (Nest_id) REFERENCES Nest_Table(Nest_id)
  );
  ALTER TABLE Tweet_Table AUTO_INCREMENT=1000;

  
-- Hashtag Table 
-- Our Hashtag_Name are not case-sensitive that is #NEU or #neu or #NeU are all considered as same. 
CREATE TABLE IF NOT EXISTS Hashtag_table (
  Hashtag_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  Hashtag_name VARCHAR(50) NOT NULL UNIQUE
  );
ALTER TABLE Hashtag_Table AUTO_INCREMENT=10000;


-- Nest Members Table
CREATE TABLE IF NOT EXISTS Nest_Members (
  Nest_id INT NOT NULL,
  Belongs_to INT NOT NULL,
  FOREIGN KEY (Nest_id) REFERENCES Nest_Table(Nest_id),
  FOREIGN KEY (Belongs_to) REFERENCES User_Table(User_id)
  );


-- Hashtag-Tweet Table
CREATE TABLE IF NOT EXISTS Hashtag_Tweet_Table (
  Hashtag_id INT NOT NULL,
  Tweet_id INT NOT NULL,
  FOREIGN KEY (Hashtag_id) REFERENCES Hashtag_table(Hashtag_id),
  FOREIGN KEY (Tweet_id) REFERENCES Tweet_Table(Tweet_id)
  );


-- Follow Table
CREATE TABLE IF NOT EXISTS Follow_table (
Profile_id INT NOT NULL,
Follow_id INT NOT NULL,
  FOREIGN KEY (Profile_id) REFERENCES User_table (User_id),
  FOREIGN KEY (Follow_id) REFERENCES User_table (User_id)
  );  
  
  
-- Liked Tweets Table
CREATE TABLE IF NOT EXISTS Liked_Tweets (
  Tweet_id INT NOT NULL,
  Liked_by INT NOT NULL,
  FOREIGN KEY (Tweet_id) REFERENCES Tweet_Table(Tweet_id),
  FOREIGN KEY (Liked_by) REFERENCES User_Table(User_id)
  );

  
-- Populating the User_Table
INSERT INTO User_Table 
(User_name, Twitter_handle, Email_address, User_Password, Short_profile, Visibility, Org_Status)  
VALUES 
('Amy', '@Amy', 'amy@gmail.com', 'aaa123***', 'Hi! This is Amy.', '1', '0'),
('Benny', '@Benny', 'benny@gmail.com', 'bbb123***', 'Hi! This is Benny.', '1', '0'),
('Chandler', '@Chandler', 'chandler@hotmail.com', 'ccc123***', 'Hi! This is Chandler.', '1', '0'),
('Diana', '@Diana', 'diana@outlook.com', 'ddd123***', 'Hi! This is Diana.', '1', '0'),
('Elena', '@Elena', 'elena@yahoo.com', 'eee123***', 'Hi! This is Elena.', '1', '0'),
('Federico', '@Federico', 'federico@hotmail.com', 'fff123***', 'Hi! This is Federico.', '1', '0'),
('Giovani', '@Giovani', 'giovani@hotmail.com', 'ggg123***', 'Hi! This is Giovani.', '1', '0'),
('Helena', '@Helena', 'helena@gmail.com', 'hhh123***', 'Hi! This is Helena.', '1', '0'),
('Isabella', '@Isabella', 'isabella@outlook.com', 'iii123***', 'Hi! This is Isabella.', '0', '0'),
('Joey', '@Joey', 'joey@gmail.com', 'jjj123***', 'Hi! This is Joey.', '1', '0'),
('Kathy', '@Kathy', 'kathy@hotmail.com', 'kkk123***', 'Hi! This is Kathy.', '1', '1'),
('Leena', '@Leena', 'leena@gmail.com', 'lll123***', 'Hi! This is Leena.', '1', '0'),
('Monica', '@Monica', 'monica@outlook.com', 'mmm123***', 'Hi! This is Monica.', '0', '0'),
('Nina', '@Nina', 'nina@gmail.com', 'nnn123***', 'Hi! This is Nina.', '1', '0'),
('Oliver', '@Oliver', 'oliver@gmail.com', 'ooo123***', 'Hi! This is Oliver.', '1', '0'),
('Paul', '@Paul', 'paul@hotmail.com', 'ppp123***', 'Hi! This is Paul.', '1', '0'),
('Quincy', '@Quincy', 'quincy@gmail.com', 'qqq123***', 'Hi! This is Quincy.', '0', '0'),
('Rachel', '@Rachel', 'rachel@outlook.com', 'rrr123***', 'Hi! This is Rachel.', '1', '0'),
('Sam', '@Sam', 'sam@gmail.com', 'sss123***', 'Hi! This is Sam.', '1', '0'),
('Tabia', '@Tabia', 'tabia@outlook.com', 'ttt123***', 'Hi! This is Tabia.', '1', '0'),
('Ursula', '@Ursula', 'ursula@hotmail.com', 'uuu123***', 'Hi! This is Ursula.', '1', '0'),
('Victoria', '@victoria', 'Victoria@gmail.com', 'vvv123***', 'Hi! This is Victoria.', '0', '0'),
('William', '@William', 'william@outlook.com', 'www123***', 'Hi! This is William.', '1', '0'),
('Xavier', '@Xavier', 'xavier@hotmail.com', 'xxx123***', 'Hi! This is Xavier.', '1', '0'),
('Yasmine', '@Yasmine', 'yasmine@gmail.com', 'yyy123***', 'Hi! This is Yasmine.', '1', '0'),
('Abhay', '@abhay', 'abhay1990@gmail.com', 'abhay123', 'Sunday fundays > snowboarding Electric guitar < acoustic guitar', '1' , '0'),
('Bhavi', '@bhavi', 'bhavi2000@gmail.com', 'bhavi_2000', 'My family. Blood is thicker than water and all that', '0' , '0'),
('Tushar', '@tushar', 'tushar1995@gmail.com','tushar1234', 'Hi I am an ambivert person', '1' , '1'),
('Vipul', '@vipul', 'vipul1996@gmail.com', 'vipul_3244', 'Hi I am an ambivert person', '1' , '0'),
('Paras', '@paras', 'paras456@gmail.com', 'paras_1000', 'Hi I am an introvert person', '1' , '1'),
('Prikshit', '@prikG', 'prikG1997@gmail.com', 'prikG_1173', 'Hi I am an introvert person', '1', '0'),
('Pranika', '@pranika', 'pranika1998@gmail.com', 'pranika_1998', 'Hi I am an extrovert person', '0' , '0'),
('Lakshay', '@lakshay', 'lakshay1999@gmail.com', 'lakshay_1999', 'Hi I am an ambivert person', '1' , '0'),
('Pulkit', '@pulkit', 'pulkit1999@gmail.com', 'pulkit_1999', 'Hi I am an extrovert person', '0', '1'),
('Rushit', '@rushit', 'rushit2000@gmail.com', 'rushit_2000', 'Hi I am an introvert person', '0' , '0'),
('Aseem', '@aseem', 'aseem1988@gmail.com', 'aseem_1988', 'Hi I am an extrovert person', '1' , '0'),
('Aayush', '@aayush', 'aayush1991@gmail.com', 'aayush_1991', 'Hi I am an ambivert person', '1' , '0'),
('Arsh', '@arsh', 'arsh1993@gmail.com', 'arsh_1993', 'Hi I am an extrovert person', '1' , '0'),
('Payal', '@payal', 'payal1994@gmail.com', 'payal_1994', 'Hi I am an extrovert person', '0' , '0'),
('Tejinder', '@tejinder', 'tejinder1961@gmail.com', 'tejinder_1961', 'Hi I am an ambivert person', '0' , '1'),
('Atul', '@atul', 'atul1962@gmail.com', 'atul_1962', 'Hi I am an introvert person', '0' , '0'),
('Sneh', '@sneh', 'sneh1965@gmail.com', 'sneh_1965', 'Hi I am an extrovert person', '1' , '1'),
('Krishan', '@krishan', 'krishan1965@gmail.com', 'krishan_1965', 'Hi I am an ambivert person', '1' , '1'),
('Madhvi', '@madhvi', 'madhvi1968@gmail.com', 'madhvi_1968', 'Hi I am an introvert person', '0' , '0'),
('Radhika', '@radhika', 'radhika1972@gmail.com', 'radhika_1972', 'Hi I am an extrovert person', '1', '0'),
('Astha', '@astha', 'astha1996@gmail.com', 'astha_1996', 'Hi I am an extrovert person', '0' , '0'),
('Tanvi', '@tanvi', 'tanvi1996@gmail.com', 'tanvi_1996', 'Hi I am an ambivert person', '1' , '0'),
('Angel', '@angel', 'angel1998@gmail.com', 'angel_1998', 'Hi I am an extrovert person', '1' , '0'),
('Vaibhav', '@vaibhav', 'vaibhav1995@gmail.com', 'vaibhav_1995', 'Hi I am an extrovert person', '1' , '0'),
('Vedant', '@vedant', 'vedant1996@gmail.com', 'vedant_1996', 'Hi I am an introvert person', '1' , '0'),
('Vandana', '@vandana', 'vandana1996@gmail.com', 'vandana_1996', 'Hi I am an ambivert person', '1' , '0'),
('Arnish', '@arnish', 'arnish1996@gmail.com', 'arnish_1996', 'Hi I am an ambivert person', '0' , '0'),
('Vanshika', '@vanshika', 'vanshika1994@gmail.com', 'vanshika_1994', 'Hi I am an extrovert person', '0' , '0'),
('Himanshu', '@himanshu', 'himanshu1994@gmail.com', 'himanshu_1994', 'Hi I am an introvert person', '0' , '0'),
('Vidit', '@vidit', 'vidit1995@gmail.com', 'vidit_1995', 'Hi I am an extrovert person', '0' , '0'),
('Neeraj', '@neeraj', 'neeraj1993@gmail.com', 'neeraj_1993', 'Hi I am an ambivert person', '1' , '0');

SELECT * FROM User_Table;


-- Populating the Nest Table
INSERT INTO Nest_Table
(Nest_name, Created_by)  
VALUES 
('That Better Team', '26'),
('Huskies', '26'),
('Recreational Hazard', '27'),
('The Big Egos', '28'),
('We Got the Runs', '30'),
( 'Menace to Sobriety', '32'),
('The HUMAN Targets', '33'),
('Backhanded Compliments', '34'),
('Son of Pitch', '34'),
('Fargo Woodchippers', '35'),
('The Has-Beens', '40'),
('do not stop believin', '43'),
('Awkward Armadillos', '45'),
('Netflix and Chill', '49'),
('Chunky Monkees', '49'),
('Civil Disobedients', '50'),
('Two Birds, One Phone', '22'),
('The Uncalled Four', '13'),
('Through Thick and Thin', '21'),
('Birds of a Feather', '4'),
('Flock Together', '10'),
('Fantastic 4', '3'),
('Dream Team', '22'),
('Pen Pals', '11'),
('Great Mates', '2'),
('The Three Amigos', '1'),
('Eye to Eye, Ear to Ear', '9'),
('Chamber of Secrets', '18'),
('The Herd', '6'),
('Colony of Weirdos', '13'),
('Walkie Talkies', '19'),
('Like Glue', '15');
        
SELECT * FROM Nest_Table;


-- Populating the Tweet_Table
-- The DATETIME type is used for values that contain both date and time parts. 
-- MySQL retrieves and displays DATETIME values in 'YYYY-MM-DD hh:mm:ss' format. 
-- The supported range is '1000-01-01 00:00:00' to '9999-12-31 23:59:59'.
INSERT INTO Tweet_Table
(Tweet_Message, User_id, Nest_id, Time_Stamp)  
VALUES 
('Hola! #NEW#hi #hello #NeU #Husky', '1', '100', '2019-06-19 00:00:00'),
('Dracarys says fire fire fire!! #GOT', '1', NULL, '2019-06-18 00:10:00'),
('Hello! #hi #hello #NEU #Husky', '1', NULL, '2019-06-18 10:00:00'),
('Hello! #hello #NEU #Husky', '1', NULL, '2019-06-17 00:00:59'),
('Hello! #NEU #Husky', '1', NULL, '2019-06-17 01:01:01'),
('#NEU', '1', NULL, '2019-06-16 21:00:00'),
('#NEU', '1', NULL, '2019-06-15 22:30:00'),
('I am just a normal message', '3', '103', '2019-06-15 00:00:00'),
('#ShareACoke', '4', '104', '2019-06-18 10:01:01'),
('#IceBucketChallenge', '1', NULL, '2019-06-14 01:01:11'),
('#DontKillNedStark', '5', '105', '2019-06-18 02:11:12'),
('', '7', '106', '2019-06-13 02:11:12'),
('#StickEmWithAPointyEnd', '8', '107', '2019-06-13 02:11:12'),
('#NEU #Husky New to Boston', '6', NULL, '2019-06-20 03:23:12'),
('No Hashtags', '10', '107', '2019-06-12 03:23:12'),
('#HaShtaG', '12', '108', '2019-06-12 12:00:00'),
('#TweetFromTheSeat', '11', '109', '2019-06-11 12:01:15'),
('I love dogs #PetsAtWork', '13', '101', '2019-06-11 23:59:59'),
('husky lover', '9', '110', '2019-06-10 20:56:47'),
(' I love pizza #pizzaLove#WorldPizzaDay', '14', NULL, '2019-06-09 19:33:30'),
('SpookyNight #StarryNight', '15', '112', '2019-06-08 04:02:43'),
('Vincent Van Gogh #FAn #StarryNight#Artist#CutOffEAR', '16', NULL, '2019-06-07 15:56:19'),
('#', '17', '114', '2019-06-06 07:11:20'),
('#Summer#flowers#warmth', '18', NULL, '2019-06-05 22:47:09'),
('#JustDoIt #Nike Sneakers #NEU #Husky', '19', NULL, '2019-06-04 21:09:11'),
('!!!!!!!!!', '20', '101', '2019-06-03 20:07:17'),
(':)', '21', '112', '2019-06-02 16:53:53'),
('#smoorthiebowl#fruits#foodlove#feelinghealthy', '22', NULL, '2019-06-01 09:01:59'),
('#beauty#kindness#bliss', '22', '102', '2019-05-30 11:00:00'),
('friendsForever', '23', '101', '2019-05-29 19:44:56'),
('#minimalism #NEU #Husky', '2', '102', '2019-05-28 00:33:08'),
('#ShareaCoke—Coca Cola', '31', '122', '2019-05-27 00:00:00'),
('#PutACanOnIt—Red Bull', '40', '123', '2019-05-26 00:01:00'),
('#TweetFromTheSeat—Charmin', '52', '116', '2019-05-25 10:01:00'),
('#OreoHorrorStories—Oreo', '43', '115', '2019-05-24 10:01:00'),
('#WantAnR8—Audi', '42', '130', '2019-05-23 20:00:30'),
('#NationalFriedChickenDay—KFC', '30', '129', '2019-05-22 20:58:37'),
( '#CollegeIn5Words—Denny’s Diner', '33', '127', '2019-05-21 20:58:59'),
('#LikeAGirl by Always #ShareACoke by Coca-Cola', '44', NULL, '2019-05-20 20:58:59'),
('#PutACanOnIt; Red Bull’s Improv campaign Go reds', '29', '118', '2019-05-19 21:01:01'),
('#SMWiDubai: Social Media Week Dubai’s Exemplary', '32', '119', '2019-05-18 21:03:00'),
('Audi’s magnanimous launch with #WantAnR8 #MyCalvins by Calvin Klein', '37', '120', '2019-05-17 21:58:00'),
('Charmin’s unconventional take with #TweetFromTheSeat', '47', '123', '2019-05-17 23:00:00'),
('The Iconic #IceBucketChallenge', '49', '128', '2019-05-16 23:00:05'),
('#NationalFriedChickenDay; KFC’s take', '28', '119', '2019-05-15 23:05:00'),
('Always’ #LikeAGirl', '30', '120', '2019-05-14 10:00:00'),
('The #IceBucketChallenge campaign did two things in droves. It raised awareness about ALS', '45', '130', '2019-05-13 13:12:12'),
('When he was slated to appear in TNT’s show Legends, TNT used the hashtag #DontKillSeanBean', '50', '129', '2019-05-12 14:01:01'),
('Esurance’s #EsuranceSave30', '34', '126', '2019-05-11 20:01:10'),
( 'To counteract the creepiness #CaughtOnDropCam to encourage users to share hilarious videos.', '25', '126', '2019-05-10 21:19:44'),
('DiGiorno’s #DigiorNoYouDidn’t', '26', '122', '2019-05-09 21:19:44'),
('Calvin Klein’s #MyCalvins got a ton of engagement without offering anything in return', '28', '119', '2019-05-09 23:59:59'),
('#TweetFromTheSeat', '5', NULL, '2019-06-18 10:10:00'),
('#neu', '2', '102', '2019-03-28 00:33:50'),
('#NEU', '3', '102', '2019-03-28 00:33:58'),
('#NeU', '2', '100', '2019-03-28 00:33:59'),
('#NEU', '4', '112', '2019-03-28 10:33:58'),
('#neu', '5', '112', '2019-03-28 10:33:59'),
('#NEU', '4', '120', '2019-03-28 11:33:58'),
('#neU', '5', '123', '2019-03-28 11:33:59');

SELECT * FROM Tweet_Table;


-- Populating the Hashtag Table
INSERT INTO Hashtag_Table
(Hashtag_name)  
VALUES 
('#ShareaCoke'),
('#PutACanOnIt'),
('#TweetFromTheSeat'),
('#OreoHorrorStories'),
('#WantAnR8'),
('#NationalFriedChickenDay'),
('#LikeAGirl'),
('#CollegeIn5Words'),
('#SMWiDubai'),
('#MyCalvins'),
('#IceBucketChallenge'),
('#DontKillSeanBean'),
('#EsuranceSave30'),
('#CaughtOnDropCam'),
('#DigiorNoYouDidn’t'),
('#NEW'),
('#hi'), 
('#hello'),
('#NEU'),
('#Husky'),
('#GOT'),
('#DontKillNedStark'),
('#StickEmWithAPointyEnd'),
('#HaShtaG'),
('#PetsAtWork'),
('#pizzaLove'),
('#WorldPizzaDay'),
('#StarryNight'),
('#FAn'),
('#Artist'),
('#CutOffEAR'),
('#'),
('#Summer'),
('#flowers'),
('#warmth'),
('#JustDoIt'), 
('#Nike'),
('#smoorthiebowl'),
('#fruits'),
('#foodlove'),
('#feelinghealthy'),
('#beauty'),
('#kindness'),
('#bliss'),
('#minimalism');

SELECT * FROM Hashtag_Table
ORDER BY Hashtag_id;


-- Populating Nest_Members Table
INSERT INTO Nest_Members 
(Nest_id, Belongs_to)  
VALUES 
('101', '1'), ('101', '56'), ('101', '25'), ('101', '30'), ('101', '33'),
('102', '1'),
('103', '44'), ('103', '48'),
('104', '22'), ('104', '23'), ('104', '44'),
('105', '50'), ('105', '51'), ('105', '52'), ('105', '53'), ('105', '54'),
('106', '1'), ('106', '2'), ('106', '4'), ('106', '5'), ('106', '6'), ('106', '8'), ('106', '9'), ('106', '10'),
('108', '5'), ('108', '6'), ('108', '8'), ('108', '9'), ('108', '10'), ('108', '11'), ('108', '12'), ('108', '14'),
('109', '2'), ('109', '12'), ('109', '20'), ('109', '22'),
('110', '5'), ('110', '15'), ('110', '55'),
('111', '4'),  ('111', '14'), ('111', '40'), ('111', '44'),
('112', '12'),
('113', '5'), ('113', '15'), ('113', '18'), ('113', '19'), ('113', '26'), ('113', '55'), 
('114', '10'), ('114', '20'), ('114', '40'), ('114', '50'),
('115', '11'), ('115', '22'), ('115', '44'), ('115', '55'),
('116', '1'), ('116', '12'),
('118','22'), ('118','23'), ('118','29'), ('118','31'), 
('119','21'), ('119','25'), ('119','28'), ('119','30'),   
('120','21'), ('120','28'), ('120','30'),
('121','18'), ('121','21'), ('121','22'), ('121','25'), ('121','28'), ('121','31'),  
('122','18'), 
('123','30'), 
('124','18'),
('125','22'), 
('126','22'), ('126','24'), ('126','30'),
('127','20'), ('127','21'), ('127','23'), ('127','26'), ('127','28'), ('127','31'), ('127','32'),
('128','19'), ('128','22'), ('128','23'), ('128','24'), ('128','27'), ('128','30'), ('128','32'),  
('129','28'), 
('130','20'), ('130','22'), ('130','26'), ('130','27'), ('130','30'),
('131','18'), ('131','20'), ('131','22'), ('131','25'), ('131','27'), ('131','29'), ('131','31') ;

SELECT * FROM Nest_Members;


-- Populating the Hashtag_Tweet_table
INSERT INTO Hashtag_Tweet_Table 
(Hashtag_id, Tweet_id) 
VALUES 
('10015', '1000'), ('10016', '1000'), ('10017', '1000'), ('10018', '1000'), ('10019', '1000'),
('10020', '1001'),
('10016', '1002'), ('10017', '1002'), ('10018', '1002'), ('10019', '1002'),
('10017', '1003'), ('10018', '1003'),  ('10019', '1003'), 
('10018', '1004'), ('10019', '1004'), 
('10018', '1005'),
('10018', '1006'),
('10000', '1008'), 
('10010', '1009'), 
('10021', '1010'),
('10022', '1012'),
('10018', '1013'), ('10019', '1013'),
('10023', '1015'),
('10002', '1016'), 
('10024', '1017'),
('10025', '1019'), ('10026', '1019'), 
('10027', '1020'),
('10028', '1021'), ('10027', '1021'), ('10029', '1021'), ('10030', '1021'),
('10031', '1022'), 
('10032', '1023'), ('10033', '1023'), ('10034', '1023'),
('10035', '1024'), ('10036', '1024'), ('10018', '1024'), ('10019', '1024'),
('10037', '1027'), ('10038', '1027'), ('10039', '1027'), ('10040', '1027'),
('10041', '1028'), ('10042', '1028'), ('10043', '1028'), 
('10044', '1030'), ('10018', '1030'), ('10019', '1030'),
('10000', '1031'),
('10001', '1032'),
('10002', '1033'), 
('10003', '1034'),
('10004', '1035'),
('10005', '1036'), 
('10007', '1037'),
('10006', '1038'), ('10000', '1038'),
('10001', '1039'),
('10008', '1040'),
('10004', '1041'), ('10009', '1041'), 
('10002', '1042'),
('10010', '1043'),
('10005', '1044'),
('10006', '1045'),
('10000', '1046'),
('10011', '1047'),
('10012', '1048'),
('10013', '1049'),
('10014', '1050'),
('10009', '1051'), 
('10002', '1052'),
('10018', '1053'),
('10018', '1054'),
('10018', '1055'),
('10018', '1056'),
('10018', '1057'),
('10018', '1058'),
('10018', '1059');
               
SELECT * FROM Hashtag_Tweet_Table;


INSERT INTO Follow_table (Profile_id, Follow_id)  
VALUES 
('1', '2'), ('1','4'), ('1','29'), ('1','31'), ('1','39'), ('1','41'), ('1','43'), ('1','47'), ('1','53'), ('1','55'), 
('2','1'), ('2','6'), ('2', '10'), ('2', '11'), ('2','30'), ('2','32'), ('2','34'), ('2','36'), ('2','42'), ('2','40'), ('2','44'), ('2','46'), ('2','48'), ('2','52'), ('2','54'), ('2','56'),
('3','4'), ('3','6'), ('3', '13'), ('3', '18'), ('3', '20'), ('3','30'), ('3','33'), ('3','36'), ('3','45'), ('3','51'), ('3','52'), ('3','54'), 
('4','3'), ('4','29'), ('4','32'), ('4','40'), ('4','48'), ('4', '50'), ('4', '51'), ('4', '52'), ('4', '53'), ('4','56'), 
('5','3'), ('5', '15'), ('5', '17'), ('5','30'), ('5', '40'), ('5','45'), ('5', '50'), ('5','55'), ('5', '56'),
('6', '20'), ('6', '21'), ('6', '22'), ('6', '23'), ('6', '24'), ('6', '25'), ('6','29'), ('6','30'), ('6','31'), ('6','36'), ('6','42'), ('6','48'), 
('7', '1'), ('7','29'), ('7','42'), ('7','49'), ('7','54'), 
('8', '1'), ('8', '2'), ('8','32'), ('8','40'), ('8','48'), ('8','54'), 
('9','3'), ('9', '11'), ('9', '22'), ('9', '31'), ('9','33'), ('9','45'), 
('10', '9'), ('10', '19'), ('10', '29'), ('10','30'), ('10','40'), 
('11','2'), ('11', '30'), ('11', '31'), ('11', '33'), ('11', '36'), ('11','44'), ('11','55'),
('12', '1'), ('12', '6'), ('12','18'), ('12','28'), ('12', '36'), ('12','48'), 
('14','4'), ('14','7'), ('14', '41'), ('14', '43'), ('14', '44'), ('14', '46'), ('14', '47'), ('14', '49'), ('14','52'), ('14','56'),
('15', '1'), ('15','5'), ('15','30'), ('15','45'), 
('16', '11'), ('16','32'), ('16', '51'), 
('17', '11'), ('17','34'), ('17','51'), ('17', '52'), 
('18','6'), ('18','9'), ('18','36'), ('18', '53'), ('18', '54'), ('18', '55'), 
('19', '42'), ('19', '43'), ('19', '44'), ('19', '45'), ('19', '46'), 
('20', '1'), ('20', '2'), ('20', '3'), ('20', '4'), ('20', '5'), ('20', '6'), ('20','10'), ('20','40'),
('21','2'), ('21','7'), ('21', '20'), ('21', '21'), ('21', '22'), ('21', '23'), ('21', '24'), ('21', '25'), ('21', '26'), ('21','42'),
('22','1'), ('22','2'), ('22','11'), ('22','44'),
('24','4'), ('24','6'), ('24', '11'), ('24','12'), ('24', '22'), ('24', '33'), ('24','48'),
('25','5'), ('25', '9'), ('25', '19'), ('25', '29'), 
('26', '30'), ('26', '31'), ('26', '33'), ('26', '36'), ('26','52'),
('27','9'), ('27', '18'), ('27', '28'), ('27', '48'), ('27','54'),
('28','7'), ('28','14'), ('28','32'), ('28', '41'), ('28', '43'), ('28', '44'), ('28', '46'), ('28', '47'), ('29', '49'), ('28','56'), 
('29', '1'), 
('30', '10'), ('30', '11'), ('30','15'), ('30','53'),
('31','2'), ('31', '13'), ('31', '18'), ('31', '20'), 
('32','1'), ('32','16'), ('32', '50'), ('32', '51'), ('32', '52'), ('32', '53'), 
('33','3'), ('33','11'), ('33', '15'), ('33', '17'), ('33', '40'), ('33', '50'), ('33', '56'), 
('34','4'), ('34','17'), ('34', '20'), ('34', '21'), ('34', '22'), ('34', '23'), ('34', '24'), ('34', '25'), 
('35', '1'), 
('36','6'), ('36', '11'), ('36','12'), ('36','18'), ('36', '51'), 
('38','19'), ('38', '53'), ('38', '54'), ('38', '55'), 
('39', '42'), ('39', '43'), ('39', '44'), ('39', '45'), ('9', '46'), 
('40', '1'), ('40', '2'), ('40', '3'), ('40', '4'), ('40', '5'), ('40', '6'), ('40','10'), ('40','20'),
('41', '20'), ('41', '21'), ('41', '22'), ('41', '23'), ('41', '24'), ('41', '25'), ('41', '26'),
('41','1'), ('41','2'), ('41','43'), ('41','47'),
('42','1'), ('42','6'), ('42','7'), ('42','14'), ('42', '19'), ('42', '21'), ('42', '23'), ('42', '25'),
('43','3'), ('43', '11'), ('43', '12'), ('43', '13'), ('43', '14'), ('43', '15'), ('43', '16'), 
('44','4'), ('44','11'), ('44','22'), ('44', '42'), ('44', '43'), ('44', '44'), ('44', '45'), ('44', '46'), 
('45','15'), ('45', '53'), ('45', '54'), ('45', '55'),
('46', '11'), ('46', '51'), ('46', '52'), 
('47', '1'), ('47', '11'), 
('48','12'), ('48','16'), ('48','24'), ('48', '56'), 
('50','10'), ('50', '11'), ('50', '12'), ('50', '13'), ('50', '14'), ('50', '15'), ('50', '16'), ('50','25'),
('51','2'), ('51','17'), ('51', '42'), ('51', '43'), ('51', '44'), ('51', '45'), ('51', '46'),
('52','1'), ('52','26'), ('52', '53'), ('52', '54'), ('52', '55'), 
('53', '3'), ('53', '11'), ('53', '51'), ('53','52'), 
('54', '1'), ('54','4'), ('54','7'), ('54','9'), ('54', '11'), ('54','18'), 
('55','5'), ('55','11'),
('56', '1'), ('56','28');
        
SELECT Follow_id, COUNT(Profile_id)
FROM Follow_table
GROUP BY Follow_id
ORDER BY Follow_id;


-- Populating Liked_Tweets Table 
INSERT INTO Liked_Tweets
(Tweet_id, Liked_by)
VALUES
('1002', '44'),
('1003', '23'), ('1003', '44'),
('1005', '51'), ('1005', '53'), ('1005', '54'),
('1006', '1'), ('1006', '2'), ('1006', '5'), ('1006', '8'), ('1006', '10'),
('1010', '5'), ('1010', '8'), ('1010', '10'), ('1010', '11'), ('1010', '12'),
('1011', '12'), ('1011', '20'),
('1012', '1'), ('1012', '25'), ('1012', '30'),
('1013', '5'), ('1013', '15'), ('1013', '55'),
('1015', '12'),
('1017', '20'), ('1017', '50'),
('1020', '1'), ('1020', '25'), ('1020', '33'), 
('1021', '12'),
('1023', '1'),
('1024', '1'), ('1024', '25'), ('1024', '30'),
('1025', '1'),
('1026', '18'), 
('1027', '30'),
('1028', '1'),
('1029', '11'), ('1029', '44'),
('1030', '20'), ('1030', '26'), ('1030', '27'),
('1031', '28'),
('1032', '20'), ('1032', '21'), ('1032', '26'), ('1032', '31'),
('1034', '22'), ('1034', '29'),
('1035', '21'), ('1035', '28'),
('1036', '28'),
('1037', '30'),
('1038', '19'), ('1038', '23'), ('1038', '27'),
('1039', '21'), ('1039', '25'),
('1040','21'),
('1041','20'), ('1041','30'),
('1042','28'),
('1043','24'),
('1044','22'), ('1044','24'), ('1044','30'),
('1045','18'),
('1046','21'), ('1046','30'),
('1001','8'), ('1001','42'), ('1001','41'), ('1001','2'), ('1001','12'), ('1001','22'),
('1004','8'), ('1004','54'), ('1004','37'), ('1004','22'), ('1004','32'),
('1008','42'), ('1008','18'), ('1008','12'), ('1008','2'),
('1016','48'),
('1019','38'),
('1022','44'),
('1033','2'), ('1033','11');

SELECT * FROM Liked_Tweets;


-- PART-C 
-- (a) a) For each user, count the number of followers. Don’t include followers with a hidden
-- profile. Rank in descending order by the number of followers. Include users that have
-- no followers. Output the user’s handle and the number of followers.

-- ANS-(a)
-- Sub-query
SELECT User_id 
FROM User_table 
WHERE Visibility='1';

-- Main-query
SELECT User_id, Twitter_handle, SUM(CASE WHEN Profile_id IN (SELECT User_id 
FROM User_table 
WHERE Visibility='1') THEN 1 ELSE 0 END) AS 'No_Of_Followers' 
FROM User_table LEFT JOIN Follow_table ON (User_table.User_id=Follow_table.Follow_id)
GROUP BY User_id
ORDER BY No_Of_Followers DESC;


-- (b) For one user, list the five most recent tweets by any other user that your chosen user
-- follows. (This is known as the user’s “home timeline.”) Output the handle of the user
-- that posted the tweet, the tweet text, and the tweet timestamp. Do not include nest
-- tweets in your output.

-- Ans-(b)
-- We choose User number 20 who is following number of other users
-- Displaying asked data of chosen user no.20's timeline 
-- Sub-query
SELECT Profile_id, Follow_id
FROM Follow_table
WHERE Profile_id='20';

-- Main-query
SELECT Twitter_handle, Tweet_Message, Time_Stamp 
FROM User_table JOIN Tweet_table using (User_id)
WHERE Tweet_table.User_id IN (SELECT Follow_id
FROM Follow_table
WHERE Profile_id='20') AND Tweet_table.Nest_id IS NULL AND  Visibility='1'
ORDER BY Time_Stamp DESC
LIMIT 5;


-- c) What are the most popular “trending” hashtags by organizations over the last 30 days?
-- Output the hashtag and the number of times it occurred in any tweet in the last 30 days.
-- It doesn’t matter whether the tweet was a broadcast tweet or a private nest tweet.
-- Rank by number of occurrences in descending order.

-- Ans-(c)
-- Firstly we filter out Hashtags tweeted by the organisations in last 30 days only,
-- Then we find the trending, I mean how many times they were used in totality.
-- Sub-query
SELECT Hashtag_name, Hashtag_Tweet_Table.Hashtag_id, Org_Status 
FROM 
User_table JOIN Tweet_table ON (User_table.user_id=Tweet_table.User_id)
		   JOIN Hashtag_Tweet_Table ON (Tweet_table.Tweet_id=Hashtag_Tweet_Table.Tweet_id)
           JOIN Hashtag_Table ON (Hashtag_Tweet_Table.Hashtag_id=Hashtag_Table.Hashtag_id)
WHERE Org_Status='1' AND Visibility = '1' AND DATEDIFF(NOW(), Time_Stamp) < 30
GROUP BY Hashtag_name
ORDER BY Hashtag_Tweet_Table.Hashtag_id;

-- Main-query
SELECT Hashtag_name, COUNT(Hashtag_Tweet_Table.Hashtag_id) as 'Hashtags_Repetition'
FROM Hashtag_Table JOIN Hashtag_Tweet_Table using (Hashtag_id) 
WHERE Hashtag_Tweet_Table.Hashtag_id IN 
(SELECT  Hashtag_Tweet_Table.Hashtag_id
FROM 
User_table JOIN Tweet_table using (User_id)
		   JOIN Hashtag_Tweet_Table using (Tweet_id)
           JOIN Hashtag_Table using (Hashtag_id)
WHERE Org_Status='1' AND Visibility = '1' AND DATEDIFF(NOW(), Time_Stamp) < 30)
GROUP BY Hashtag_name
ORDER BY Hashtags_Repetition DESC;


-- d) As a twitter data scientist, you are interested in analyzing nest size distribution.
-- Generate a table that displays the number of nests (N) having (M) members. Sort your
-- results by number of members. For example, suppose 3 nests have 2 members, 1 nest
-- has 10 members, and 6 nests have 5 members.

-- Ans-(d)
-- This query is counting users who are hidden as members
-- Assuming the hidden members as a part of nest and counting them in total members count.
-- Creator of the group is considered as its member 
-- Sub-query
SELECT Nest_table.Nest_id, (COUNT(Belongs_to)+1) AS 'No_of_Members'
FROM 
Nest_table LEFT JOIN Nest_members using (Nest_id)
GROUP BY Nest_id;

-- Main-query
SELECT COUNT(Nest_id) as 'No_of_Nests', No_of_Members
FROM (
SELECT Nest_table.Nest_id, (COUNT(Belongs_to)+1) AS 'No_of_Members'
FROM Nest_table LEFT JOIN Nest_members using (Nest_id)
GROUP BY Nest_table.Nest_id) Temp
GROUP BY No_of_Members
ORDER BY No_of_Members DESC;


-- e) Suppose a user wanted to join a nest and is interested in finding groups who post
-- tweets about a particular hashtag, say #NEU. Find the top five nests whose tweets have
-- mentioned the hashtag #NEU the most often. Include the title of the nest and the
-- number of tweets mentioning #NEU. Ignore tweets that were publicly broadcast.

-- Ans-(e)
-- Main-query
SELECT Nest_table.Nest_Name as 'Nest_Name', Hashtag_name as 'Hashtag', COUNT(Nest_table.Nest_id) AS 'No_of_Tweets'
FROM 
Nest_table JOIN Tweet_table using (Nest_id)
JOIN Hashtag_tweet_table using (Tweet_id)
JOIN Hashtag_table using (Hashtag_id)
JOIN User_table using (User_id)
WHERE Hashtag_name = '#NEU' AND Visibility = '1'
GROUP BY Nest_Name
ORDER BY No_of_Tweets DESC
LIMIT 5;
