\i source/day_8_prepare.sql

WITH forest AS (
  SELECT x,
    y,
    value,
    min(x) OVER () AS min_x,
    max(x) OVER () AS max_x,
    min(y) OVER () AS min_y,
    max(y) OVER () as max_y
  FROM tree
)
SELECT COUNT(*) AS answer
FROM forest AS a
WHERE x = min_x OR x = max_x -- tree is on left or right edge
OR y = min_y OR y = max_y  -- tree is on top or down edge
OR value > (SELECT max(value) FROM tree WHERE a.x < x AND a.y = y) -- tree can be seen from the left
OR value > (SELECT max(value) FROM tree WHERE a.x > x AND a.y = y) -- tree can be seen from the right
OR value > (SELECT max(value) FROM tree WHERE a.y < y AND a.x = x) -- tree can be seen from the top
OR value > (SELECT max(value) FROM tree WHERE a.y > y AND a.x = x) -- tree can be seen from the bottom
;