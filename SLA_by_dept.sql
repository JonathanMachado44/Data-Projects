SELECT
    COALESCE(NULLIF(department, ''), 'Unassigned') AS department,
    COUNT(*) AS total_tickets,
    SUM(CASE WHEN closed_at <= due_by_at THEN 1 ELSE 0 END) AS tickets_within_sla,
    ROUND(SUM(CASE WHEN closed_at <= due_by_at THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS percent_within_sla
FROM (
    SELECT
        STR_TO_DATE(CONCAT(closed_date, ' ', closed_time), '%c/%e/%Y %H:%i:%s') AS closed_at,
        STR_TO_DATE(CONCAT(due_date, ' ', due_time), '%c/%e/%Y %H:%i:%s') AS due_by_at,
        department
    FROM ticket_data
    WHERE closed_date IS NOT NULL
) t
GROUP BY COALESCE(NULLIF(department, ''), 'Unassigned')
ORDER BY percent_within_sla DESC;