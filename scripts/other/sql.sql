SELECT
nginxdate,
	nginxtime
FROM
	(
		SELECT
			nginxdate,
			nginxtime
		FROM
			visitor
		WHERE
			serverid = '3'
		ORDER BY
			visitors
	) AS a
GROUP BY
	a.nginxdate
ORDER BY nginxdate desc