USE be8;

CREATE UNIQUE INDEX idx_unique_name
ON FILM (name);

SELECT * 
FROM FILM
WHERE name = 'MOVIE C';