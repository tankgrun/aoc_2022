\i source/day_7_prepare.sql

WITH RECURSIVE nodes AS (
  -- files
  SELECT id, name, size, parent, type
    FROM node
    WHERE size IS NOT NULL
  UNION ALL
  -- recursive part-adding up
    SELECT node.id, node.name, nodes.size, node.parent, node.type
    FROM nodes JOIN node ON nodes.parent = node.id
),
totals_per_dir AS (
  SELECT id, name, sum(size) AS total
  FROM nodes
  WHERE type = 'd'
  GROUP BY id, name
  )
, totals_with_grand_total AS (
  SELECT id, name, total, MAX(total) OVER () AS grand_total
  FROM totals_per_dir
  )
SELECT total AS answer
FROM totals_with_grand_total
WHERE total >= 30000000 - (70000000 - grand_total)
ORDER BY total ASC LIMIT 1
;