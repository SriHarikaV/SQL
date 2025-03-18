
""" crosstab function is used for  transform or pivot data from rows into columns."""

select country
, coalesce(gold, 0) as gold
, coalesce(silver, 0) as silver
, coalesce(Bronze, 0) as Bronze

from crosstab ('select nr.region as country, medal, count(1) as total_medals
	from OLYMPICS_HISTORY oh 
	join OLYMPICS_HISTORY_noc_regions nr on nr.noc = oh.noc
	where medal <> ''NA''
	group by nr.region, medal
	order by nr.region, medal',
	'values (''Bronze''), (''Gold''), (''Silver'')')
  as result(country varchar, bronze bigint, gold bigint, silver bigint)
order by gold desc, silver desc, Bronze desc;
