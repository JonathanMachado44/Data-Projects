SELECT
    CASE 
        WHEN department IS NULL OR TRIM(department) = '' THEN 'Unassigned' 
        ELSE department 
    END AS department,
    ROUND(AVG(TIMESTAMPDIFF(HOUR,
        STR_TO_DATE(CONCAT(created_date, ' ', created_time), '%c/%e/%Y %H:%i:%s'),
        STR_TO_DATE(CONCAT(closed_date, ' ', closed_time), '%c/%e/%Y %H:%i:%s')
    )), 2) AS avg_resolution_hours,
    COUNT(*) AS ticket_count
FROM ticket_data
WHERE closed_date IS NOT NULL
GROUP BY
    CASE 
        WHEN department IS NULL OR TRIM(department) = '' THEN 'Unassigned' 
        ELSE department 
    END
ORDER BY avg_resolution_hours DESC;