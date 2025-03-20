""" Identify which country won the most gold, most silver and most bronze medals in each olympic games. """
WITH temp AS (
    SELECT 
        substring(games_country, 1, position(' - ' in games_country) - 1) AS games,
        substring(games_country, position('- ' in games_country) + 2) AS country,
        COALESCE(gold, 0) AS gold,
        COALESCE(silver, 0) AS silver,
        COALESCE(bronze, 0) AS bronze
    FROM crosstab(
        'SELECT concat(games, '' - '', nr.region) AS games_country, medal, count(1) AS total_medals
         FROM OLYMPICS_HISTORY oh 
         JOIN OLYMPICS_HISTORY_noc_regions nr ON nr.noc = oh.noc
         WHERE medal <> ''NA''
         GROUP BY games, nr.region, medal
         ORDER BY games, nr.region, medal',
        'VALUES (''Bronze''), (''Gold''), (''Silver'')'
    ) AS result(games_country VARCHAR, bronze BIGINT, gold BIGINT, silver BIGINT)
    ORDER BY games_country
)

SELECT DISTINCT 
    games,
    concat(
        first_value(country) OVER(PARTITION BY games ORDER BY gold DESC),
        ' - ',
        first_value(gold) OVER(PARTITION BY games ORDER BY gold DESC)
    ) AS gold,
    concat(
        first_value(country) OVER(PARTITION BY games ORDER BY silver DESC),
        ' - ',
        first_value(silver) OVER(PARTITION BY games ORDER BY silver DESC)
    ) AS silver,
    concat(
        first_value(country) OVER(PARTITION BY games ORDER BY bronze DESC),
        ' - ',
        first_value(bronze) OVER(PARTITION BY games ORDER BY bronze DESC)
    ) AS bronze
FROM temp
ORDER BY games;
