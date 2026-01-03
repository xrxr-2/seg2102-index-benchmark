SELECT stockcode, COUNT(*) AS frequency
FROM online_retail_clean
GROUP BY stockcode
ORDER BY frequency DESC
LIMIT 10;

SELECT stockcode, COUNT(*) AS frequency
FROM online_retail_clean
GROUP BY stockcode
HAVING COUNT(*) BETWEEN 5 AND 20
ORDER BY frequency ASC
LIMIT 10;

SELECT
    MIN(cnt) AS min_freq,
    MAX(cnt) AS max_freq,
    AVG(cnt) AS avg_freq
FROM (
    SELECT stockcode, COUNT(*) AS cnt
    FROM online_retail_clean
    GROUP BY stockcode
) t;
