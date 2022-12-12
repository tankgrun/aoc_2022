DROP TABLE IF EXISTS tree;
CREATE TABLE tree(x INT, y INT, value INT);

DROP TABLE IF EXISTS input;
CREATE TABLE input(id SERIAL, line TEXT);
\COPY input(line) FROM 'input/day8.txt';

-- parse input and build up node table
DO $$
DECLARE
  line_number INT;
  col_number INT;
  tree_line TEXT;
  tree TEXT;
BEGIN
  line_number = 1;
  FOR tree_line IN
    SELECT trim(line) FROM input ORDER BY id
  LOOP
    col_number = 1;
    FOREACH tree IN ARRAY regexp_split_to_array(tree_line,'') LOOP
      INSERT INTO tree(x,y,value)
      VALUES (col_number, line_number, tree::INT);
      col_number = col_number + 1;
    END LOOP;
    line_number = line_number + 1;
  END LOOP;
END;
$$;
