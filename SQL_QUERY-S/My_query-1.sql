"""Identify the sport which was played in all summer olympics"""
with t1 as 
	(select name, count(1) as total_medals
	from OLYMPICS_HISTORY
	where medal = 'Gold'
	group by name
	order by count (1) desc),
t2 as
	(select *, dense_rank() over(order by total_medals desc ) as rnk
	from t1)
select *
from t2
where rnk <= 5;