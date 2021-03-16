use banking;

show tables;

select *
from loan;

select education, min(balance), round(avg(balance),2) as 'Average Balance', count(*)
from loan
where balance> 4
group by education
group by education
having avg(balance)>1000;

select *
from loan
where balance like '%8%';