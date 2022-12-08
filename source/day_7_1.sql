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
smallest_sums AS (
  SELECT id, name, sum(size) AS total
  FROM nodes
  WHERE type = 'd'
  GROUP BY id, name
  HAVING SUM(size) <= 100000
)
SELECT SUM(total) AS answer FROM smallest_sums
;