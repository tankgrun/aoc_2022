\i source/day_8_prepare.sql

WITH distance_left AS (
  SELECT viewpoint.x,
    viewpoint.y,
    COALESCE(MIN(viewpoint.x - blocker.x),viewpoint.x - 1) AS distance
  FROM tree AS viewpoint
  LEFT JOIN tree AS blocker
  ON blocker.value >= viewpoint.value
  AND viewpoint.y = blocker.y
  AND blocker.x < viewpoint.x
  GROUP BY viewpoint.x, viewpoint.y
),
distance_right AS (
  SELECT viewpoint.x,
    viewpoint.y,
    COALESCE(MIN(blocker.x - viewpoint.x), 99 - viewpoint.x) AS distance
  FROM tree AS viewpoint
  LEFT JOIN tree AS blocker
  ON blocker.value >= viewpoint.value
  AND viewpoint.y = blocker.y
  AND blocker.x > viewpoint.x
  GROUP BY viewpoint.x, viewpoint.y
),
distance_up AS (
  SELECT viewpoint.x,
    viewpoint.y,
    COALESCE(MIN(viewpoint.y - blocker.y), viewpoint.y - 1) AS distance
  FROM tree AS viewpoint
  LEFT JOIN tree AS blocker
  ON blocker.value >= viewpoint.value
  AND viewpoint.x = blocker.x
  AND blocker.y < viewpoint.y
  GROUP BY viewpoint.x, viewpoint.y
)
, distance_down AS (
  SELECT viewpoint.x,
    viewpoint.y,
    COALESCE(MIN(blocker.y - viewpoint.y), 99 - viewpoint.y) AS distance
  FROM tree AS viewpoint
  LEFT JOIN tree AS blocker
  ON blocker.value >= viewpoint.value
  AND viewpoint.x = blocker.x
  AND blocker.y > viewpoint.y
  GROUP BY viewpoint.x, viewpoint.y
)
SELECT MAX(l.distance * r.distance * u.distance * d.distance) AS answer
FROM distance_left l
JOIN distance_right r ON l.x = r.x AND l.y = r.y
JOIN distance_up u ON l.x = u.x AND l.y= u.y
JOIN distance_down d ON l.x = d.x AND l.y = d.y
;
