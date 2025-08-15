-- 1
SELECT * 
FROM film
WHERE length_min > 100;

-- 2
SELECT *
FROM film
WHERE length_min > (SELECT AVG(length_min) FROM film);

-- 3
SELECT * 
FROM film
WHERE name LIKE 't%';

-- 4
SELECT * 
FROM film
WHERE name LIKE '%a%';

-- 5
SELECT COUNT(id) 
FROM film
WHERE country_code = 'US';

-- 6
SELECT MAX(length_min), MIN(length_min)
FROM film;

-- 7
SELECT type
FROM film
GROUP BY type;

-- 8 
SELECT film_id, MAX(DATE(start_time)) - MIN(DATE(start_time)) AS distance
FROM screening
GROUP BY film_id;

-- 9 
SELECT name, screening.room_id, screening.start_time
FROM film
JOIN screening 
ON film.id = screening.film_id
WHERE film_id = 1;

-- 10
SELECT *
FROM screening
WHERE start_time >= '2022-05-24' AND start_time < '2022-05-26';

-- 10.1 
SELECT *
FROM film
WHERE id NOT IN (SELECT film_id FROM screening);

-- 11
SELECT booking_id, customer_id, customer.first_name, customer.last_name
FROM reserved_seat
JOIN booking
ON reserved_seat.booking_id = booking.id
JOIN customer
ON booking.customer_id = customer.id
GROUP BY booking_id, customer_id, customer.first_name, customer.last_name
HAVING COUNT(booking_id) >= 2;

-- 12
SELECT DISTINCT room_id
FROM screening
GROUP BY room_id, DATE(start_time)
HAVING COUNT(DISTINCT film_id >= 2);

-- 13 
SELECT room_id, total_film
FROM (
	SELECT room_id, COUNT(DISTINCT film_id) AS total_film
	FROM screening
	GROUP BY room_id
) AS t
WHERE total_film = (
	SELECT MIN(total_film)
    FROM (
	SELECT COUNT(DISTINCT film_id) AS total_film
	FROM screening
	GROUP BY room_id
) AS x);

-- 14 
SELECT * 
FROM film
WHERE id NOT IN (
	SELECT DISTINCT film_id 
	FROM booking
	JOIN screening
	ON booking.screening_id = screening.id);
    
-- 15 
SELECT DISTINCT film_id
FROM screening
WHERE room_id = 7;

-- 16
SELECT film_id
FROM (
	SELECT film_id, DATE(start_time) AS date_time 
	FROM screening
	GROUP BY film_id, DATE(start_time)) AS t
GROUP BY film_id
HAVING COUNT(film_id) = 7
ORDER BY film_id DESC;

-- 17
SELECT DISTINCT film_id, length_min
FROM screening
JOIN film 
ON screening.film_id = film.id
WHERE DATE(start_time) = '2022-05-28';

-- 18. 1
SELECT *
FROM film
WHERE length_min > (SELECT AVG(length_min) FROM film); 

-- 18. 2
SELECT *
FROM film
WHERE length_min < (SELECT AVG(length_min) FROM film);

-- 19
SELECT room_id, COUNT(room_id)
FROM seat
GROUP BY room_id
LIMIT 1;


-- 20
WITH count_seat AS (
	SELECT room_id, COUNT(room_id) AS total_seat
	FROM seat
	GROUP BY room_id
)  

SELECT room_id, total_seat
FROM count_seat
WHERE total_seat > (SELECT AVG(total_seat) FROM count_seat);

-- 21
SELECT id
FROM seat
WHERE id NOT IN (
	SELECT seat_id
	FROM booking
	JOIN reserved_seat
	ON booking.id = reserved_seat.booking_id
	WHERE screening_id = (SELECT screening_id FROM booking WHERE id = 1))
AND room_id = (
	SELECT room_id
    FROM screening
    WHERE id = (SELECT screening_id FROM booking WHERE id = 1))
;

-- 22
SELECT film_id, COUNT(film_id) AS total_screening
FROM screening
GROUP BY film_id
HAVING COUNT(film_id) > 10
ORDER BY total_screening;

-- 23
SELECT DATE(start_time) AS date_time, COUNT(booking.id) AS total_booking
FROM booking
JOIN screening
ON booking.screening_id = screening.id
GROUP BY DATE(start_time);

-- 24
WITH count_seat AS (
	SELECT room_id, COUNT(room_id) AS total_seat
	FROM seat
	GROUP BY room_id
)  

SELECT screening_id, film_id, screening.room_id, COUNT(booking.id) / total_seat * 100 AS rate
FROM booking
JOIN screening
ON booking.screening_id = screening.id
JOIN count_seat
ON screening.room_id = count_seat.room_id
GROUP BY screening_id, film_id, screening.room_id
ORDER BY rate DESC;

-- 25
WITH count_seat AS (
	SELECT room_id, COUNT(room_id) AS total_seat
	FROM seat
	GROUP BY room_id
),
rate_table AS ( 
	SELECT screening_id, film_id, screening.room_id, COUNT(booking.id) / total_seat * 100 AS rate
	FROM booking
	JOIN screening
	ON booking.screening_id = screening.id
	JOIN count_seat
	ON screening.room_id = count_seat.room_id
	GROUP BY screening_id, film_id, screening.room_id
	ORDER BY rate DESC
)

SELECT * 
FROM rate_table
WHERE rate > (SELECT AVG(rate) FROM rate_table);

-- 26