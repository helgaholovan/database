USE A01;

WITH Favorite AS (
    SELECT 
        r.name AS reader_name,
        r.favorite_genre
    FROM Readers r
    WHERE r.age > 25
)
SELECT 
    b.title AS book_title,
    a.full_name AS author,
    g.genre_name AS genre,
    p.publisher_name AS publisher,
    f.reader_name,
    COUNT(b.book_id) AS book_count
FROM Books b
JOIN Authors a 
    ON b.author_name = a.full_name
JOIN Genres g 
    ON b.genre_name = g.genre_name
JOIN Publishers p 
    ON b.publisher_name = p.publisher_name
JOIN Favorite f 
    ON g.genre_name = f.favorite_genre
WHERE b.publication_year > (
    SELECT AVG(publication_year)
    FROM Books
)
GROUP BY 
    b.title,
    b.author_name, 
    g.genre_name, 
    p.publisher_name,
    f.reader_name
HAVING COUNT(b.book_id) > 0
ORDER BY COUNT(b.book_id) DESC
LIMIT 5;