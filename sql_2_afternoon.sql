/* Joins */

SELECT * FROM invoice_line 
WHERE unit_price > .99

SELECT i.invoice_date, i.total, c.first_name, c.last_name
FROM invoice i
JOIN customer c ON i.customer_id = c.customer_id

SELECT c.first_name, c.last_name, e.first_name, e.last_name
FROM customer c
JOIN employee e ON c.support_rep_id = e.employee_id;

SELECT a.title, ar.name
FROM album a 
JOIN artist ar ON a.artist_id = ar.artist_id;

SELECT pt.track_id FROM
playlist_track pt
JOIN playlist p ON p.playlist_id = pt.playlist_id
WHERE p.name = 'Music'

SELECT t.name FROM 
track t
JOIN playlist_track pt ON pt.track_id = t.track_id
WHERE pt.playlist_id = 5;

SELECT t.name, p.name FROM 
track t
JOIN playlist_track pt ON t.track_id = pt.track_id
JOIN playlist p ON pt.playlist_id = p.playlist_id

SELECT t.name, a.title FROM
track t
JOIN album a ON t.album_id = a.album_id
JOIN genre g ON t.genre_id = g.genre_id
WHERE g.name = 'Alternative & Punk'

SELECT t.name, t.genre_id, a.title, ar.name FROM
track t
JOIN genre g ON t.genre_id = g.genre_id
JOIN album a ON t.album_id = a.album_id
JOIN artist ar ON a.artist_id = ar.artist_id
JOIN playlist_track pt ON t.track_id = pt.track_id
JOIN playlist p ON p.playlist_id = pt.playlist_id
WHERE p.name = 'Music'


/* Nested */

SELECT * FROM invoice
WHERE invoice_id IN (
  SELECT invoice_id FROM invoice_line WHERE unit_price > .99
);

SELECT * from playlist_track
WHERE playlist_id IN (
  SELECT playlist_id FROM playlist WHERE name = 'Music'
);
  
SELECT name FROM track 
WHERE track_id IN (
  SELECT track_id FROM playlist_track WHERE playlist_id = 5
);

SELECT * from track 
WHERE genre_id IN (
  SELECT genre_id FROM genre WHERE name = 'Comedy'
);

SELECT * from track
WHERE album_id IN (
  SELECT album_id FROM album WHERE title = 'Fireball'
);

SELECT * from track
WHERE album_id IN (
  SELECT album_id from
  album WHERE artist_id IN (
    SELECT artist_id FROM artist WHERE name = 'Queen'
  )
);


/* Updating Rows */

UPDATE customer
SET fax = null
WHERE fax IS NOT null;

UPDATE customer
SET company = 'Self'
WHERE company IS null;

UPDATE customer
SET last_name = 'Thompson'
WHERE first_name = 'Julia' AND last_name = 'Barnett'

UPDATE customer
SET support_rep_id = 4
WHERE email = 'luisrojas@yahoo.cl'

UPDATE track
SET composer = 'The darkness around us'
WHERE composer IS null
AND genre_id = (SELECT genre_id FROM genre WHERE name = 'Metal');


/* Group by */

SELECT COUNT(*), g.name
FROM genre g
JOIN track t ON t.genre_id = g.genre_id
GROUP BY g.name;

SELECT COUNT(*), g.name
FROM genre g
JOIN track t ON g.genre_id = t.genre_id
WHERE g.name = 'Pop' OR g.name = 'Rock'
GROUP BY g.name

SELECT ar.name, COUNT(*)
FROM artist ar
JOIN album al ON ar.artist_id = al.artist_id
GROUP BY ar.name;


/* Use Distinct */

SELECT DISTINCT composer
FROM track;

SELECT DISTINCT billing_postal_code
FROM invoice;

SELECT DISTINCT company
from customer;


/* Delete Rows */

DELETE FROM practice_delete
WHERE type = 'bronze';

DELETE FROM practice_delete
WHERE type = 'silver';

DELETE FROM practice_delete
WHERE value = 150;


/* eCommerce Simulation */

CREATE TABLE users (id SERIAL PRIMARY KEY, name TEXT, email TEXT);

CREATE TABLE products (id SERIAL PRIMARY KEY, name TEXT, price INT);

CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  quantity INT,
  products_id INT REFERENCES products(id),
  users_id INT REFERENCES users(id)
)

SELECT p.name, o.quantity
FROM products p
JOIN orders o ON p.id = o.products_id
WHERE o.id = 1

SELECT * FROM orders;

SELECT SUM(p.price * o.quantity) 
FROM products p
JOIN orders o ON p.id = o.products_id
WHERE o.id = 2

SELECT * from orders
WHERE users_id = 1

SELECT COUNT(*), u.id
FROM users u
JOIN orders o ON o.users_id = u.id
GROUP BY u.id



SELECT SUM(p.price * o.quantity) 
FROM products p
JOIN orders o ON p.id = o.products_id
WHERE o.users_id = 2