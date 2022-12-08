DROP TABLE IF EXISTS node;
CREATE TABLE node(id SERIAL PRIMARY KEY, name TEXT, size INT, parent INT, type CHAR);

ALTER TABLE node ADD CONSTRAINT fk_parent FOREIGN KEY (parent) REFERENCES node(id);
-- a little check: file names should be unique at each level
ALTER TABLE node ADD CONSTRAINT name_per_parent_unique UNIQUE(parent, name);

DROP TABLE IF EXISTS input;
CREATE TABLE input(id SERIAL, line TEXT);
\COPY input(line) FROM 'input/day7.txt';


-- parse input and build up node table
DO $$
DECLARE
  current_node int;
  terminal_line text;
BEGIN
  FOR terminal_line IN 
    SELECT trim(line) FROM input ORDER BY id
  LOOP
    IF terminal_line = '$ cd /' THEN
      -- setup root node
      INSERT INTO node (name, type) VALUES ('/','d') RETURNING id INTO current_node;
    ELSIF terminal_line = '$ ls' THEN
      -- do nothing
    ELSIF terminal_line = '$ cd ..' THEN
      -- set current node to parent of current node
      SELECT parent into current_node FROM node WHERE id = current_node;
    ELSIF substr(terminal_line,1,4) = '$ cd' THEN
      -- set current_node to dir
      SELECT id INTO current_node 
      FROM node 
      WHERE parent = current_node 
      AND name = substr(terminal_line,6);
    ELSIF split_part(terminal_line,' ', 1) = 'dir' THEN
      -- add a directory with current directory as parent
      INSERT INTO node (name, parent, type) VALUES (split_part(terminal_line,' ', 2), current_node, 'd');
    ELSE
      -- add file to node
      INSERT INTO node(name, parent, size, type)
      VALUES (split_part(terminal_line,' ', 2), current_node, (split_part(terminal_line,' ', 1))::INT, 'f');
    END IF;
  END LOOP;
END; 
$$;
