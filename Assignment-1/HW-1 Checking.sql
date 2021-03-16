show databases;
use banking;
-- show tables;
-- select education, count(education), min(balance), max(balance), avg(balance)
-- from loan
-- -- where approved='yes'
-- group by education
-- order by education;
select education as 'EDUCATION',
count(education) AS 'NUMBER OF APPLICANTS',
min(balance) as 'MIN BALANCE' , 
max(balance) as 'MAX BALANCE', 
avg(balance) as 'AVERAGE BALANCE',
count(case when approved like 'Yes' then 1 end)  as 'APPROVED',
count(case when approved like 'No' then 1 end) as 'REJECTED',
count(case when approved like 'Yes' then 1 end) / count(education) as 'APPROVAL PROBALILTY'
from loan
group by education;
