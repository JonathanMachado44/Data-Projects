WITH created_tickets AS (
    SELECT
        DATE_FORMAT(STR_TO_DATE(CONCAT(created_date, ' ', created_time), '%c/%e/%Y %H:%i:%s'), '%Y-%m') AS month,
        COUNT(*) AS tickets_created
    FROM ticket_data
    WHERE created_date IS NOT NULL
    GROUP BY DATE_FORMAT(STR_TO_DATE(CONCAT(created_date, ' ', created_time), '%c/%e/%Y %H:%i:%s'), '%Y-%m')
),
closed_tickets AS (
    SELECT
        DATE_FORMAT(STR_TO_DATE(CONCAT(closed_date, ' ', closed_time), '%c/%e/%Y %H:%i:%s'), '%Y-%m') AS month,
        COUNT(*) AS tickets_closed
    FROM ticket_data
    WHERE closed_date IS NOT NULL
    GROUP BY DATE_FORMAT(STR_TO_DATE(CONCAT(closed_date, ' ', closed_time), '%c/%e/%Y %H:%i:%s'), '%Y-%m')
)
SELECT
    c.month,
    c.tickets_created,
    COALESCE(cl.tickets_closed, 0) AS tickets_closed,
    (c.tickets_created - COALESCE(cl.tickets_closed, 0)) AS monthly_difference,
    SUM(c.tickets_created - COALESCE(cl.tickets_closed, 0)) OVER (ORDER BY c.month) AS running_backlog
FROM created_tickets c
LEFT JOIN closed_tickets cl ON c.month = cl.month
ORDER BY c.month;