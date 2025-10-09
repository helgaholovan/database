USE A01;

SELECT full_name AS person_name, 'Автор' AS role
FROM Authors

UNION

SELECT name AS person_name, 'Читач' AS role
FROM Readers;
