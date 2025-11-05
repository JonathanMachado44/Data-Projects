SELECT word, COUNT(*) AS frequency
FROM (
    SELECT 
        LOWER(
            TRIM(
                BOTH ',' FROM 
                TRIM(BOTH '.' FROM
                TRIM(BOTH '!' FROM
                TRIM(BOTH '?' FROM
                SUBSTRING_INDEX(SUBSTRING_INDEX(description, ' ', n.n), ' ', -1)
                ))))
        ) AS word
    FROM ticket_data
    CROSS JOIN (
        SELECT a.N + b.N * 10 + 1 AS n
        FROM 
        (SELECT 0 N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 
         UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
        (SELECT 0 N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 
         UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b
    ) n
    WHERE n.n <= 15  -- checks first 15 words of each description
) x
WHERE word NOT IN (
    'the','and','a','an','for','to','of','in','on','my','is','it','i','you','we','have',
    'with','this','that','be','as','are','at','by','from','or','if','but','they','his',
    'her','he','she','all','can','will','not','so','was','were','had','has','do','does',
    'did','please','thanks','thank','hi','hello','aloha','dear','kindly','regards','new',
    'need','want','would','could','should','also','last','today','yesterday','tomorrow',
    'there','here','which','what','when','where','who','how','our','us','them','their',
    'may','might','must','shall','also','just','any','some','many','most','such','very',
    'more','less','over','under','again','already','still','yet','ever','never','always',
    'sometimes','often','usually','almost','quite','really','seem','seems','seemed'
)
AND LENGTH(word) > 3  -- remove very short words
GROUP BY word
ORDER BY frequency DESC
LIMIT 10;