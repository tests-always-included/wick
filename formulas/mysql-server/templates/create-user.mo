--
-- The first FLUSH PRIVILEGES works around this bug
-- http://bugs.mysql.com/bug.php?id=28331
--
DELETE FROM user WHERE User = '{{username}}';
FLUSH PRIVILEGES;
CREATE USER '{{username}}'@'{{host}}';
SET PASSWORD FOR '{{username}}'@'{{host}}' = PASSWORD("{{password}}");
FLUSH PRIVILEGES;
