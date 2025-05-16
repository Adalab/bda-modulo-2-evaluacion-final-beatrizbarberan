-- https://github.com/Adalab/bda-modulo-2-evaluacion-final-beatrizbarberan

USE sakila;

-- 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.
SELECT DISTINCT title
FROM film;

-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".
SELECT title, rating -- Podría no mostrarse rating en el resultado (se ha puesto a efectos de comprobación)
FROM film
WHERE rating = 'PG-13';
 
/*  3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en 
su descripción. */
SELECT title, description
FROM film
WHERE description LIKE '%amazing%'; -- En sql no diferencia entre mayúsculas y minúsculas, en python sí

-- 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.
SELECT title, length
FROM film
WHERE length>120 -- Como el enunciado indica mayor, no incluyo las de 120 minutos exactamente, sino a partir de 121
ORDER BY length;
 
/* 5. Encuentra los nombres de todos los actores, muestralos en una sola columna que se llame 
nombre_actor y contenga nombre y apellido.*/
SELECT CONCAT(first_name, " ", last_name) actor_name
FROM actor;

-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.
SELECT first_name, last_name
FROM actor
WHERE last_name LIKE '%Gibson%';

-- 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.
SELECT actor_id, first_name -- Podría no mostrarse actor_id en el resultado (se ha puesto a efectos de comprobación)
FROM actor
WHERE actor_id BETWEEN 10 AND 20; -- Me incluye el 10 y el 20 en la respuesta

-- 8. Encuentra el título de las películas en la tabla film que no tengan clasificacion "R" ni "PG-13".
SELECT title, rating -- Podría no mostrarse rating en el resultado (se ha puesto a efectos de comprobación)
FROM film
WHERE rating NOT IN ('R', 'PG-13')
ORDER BY rating;
 
/* 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la 
clasificación junto con el recuento. */
SELECT rating, COUNT(film_id)
FROM film
GROUP BY rating;

/* 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su 
nombre y apellido junto con la cantidad de películas alquiladas. */
SELECT COUNT(r.inventory_id), r.customer_id, c.first_name, c.last_name
FROM rental r
JOIN customer c
ON r.customer_id = c.customer_id
GROUP BY r.customer_id;

/* 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la 
categoría junto con el recuento de alquileres. */
SELECT COUNT(r.inventory_id) AS total_rented_films, c.name AS category_name
FROM rental r
LEFT JOIN inventory i ON r.inventory_id = i.inventory_id
LEFT JOIN film_category fc ON i.film_id = fc.film_id
LEFT JOIN CATEGORY C ON fc.category_id = c.category_id
GROUP BY c.name;

/* 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y 
muestra la clasificación junto con el promedio de duración. */
SELECT DISTINCT rating, AVG(length)
FROM film
GROUP BY rating;

-- 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".
SELECT a.first_name, a.last_name, f.title -- Podría no mostrarse f.title en el resultado (se ha puesto a efectos de comprobación)
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id 
WHERE f.title = 'Indian Love';

-- 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.
SELECT title, description
FROM film
WHERE description LIKE 'dog %' OR description LIKE '% dog %' OR description LIKE 'cat %' OR description LIKE '% cat %'; -- He añadido los espacios para que dog y cat no formen parte de otra palabra (aunque al parecer no se daba el caso).

-- 15. Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor.
SELECT a.first_name, a.last_name
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
WHERE fa.actor_id IS NULL;
-- La respuesta es "No, no hay ningún actor/actriz que no aparezca en ninguna película. Todos los actores/actrices de la tabla aparecen en alguna película."
 
-- 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.
SELECT title, release_year -- Podría no mostrarse release_year en el resultado (se ha puesto a efectos de comprobación)
FROM film
WHERE release_year BETWEEN 2005 AND 2010; -- Curiosamente todas las películas de esta tabla se estrenaron en 2006
 
-- 17. Encuentra el título de todas las películas que son de la misma categoría que "Family". 
-- (Entiendo que quiere decir que son de la categoría Family, porque no hay ninguna película que se llame así)
SELECT f.title, c.name -- Podría no mostrarse category.name en el resultado (se ha puesto a efectos de comprobación)
FROM film f
LEFT JOIN film_category fc ON f.film_id = fc.film_id
LEFT JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Family';
 
-- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.
SELECT a.first_name, a.last_name, COUNT(fa. film_id) AS number_of_films
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
HAVING  number_of_films > 10
ORDER BY number_of_films;
  
/* 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la 
tabla film.*/
SELECT title, rating, length
FROM film
WHERE rating = 'R' AND length>120
ORDER BY length;

/* 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 
minutos y muestra el nombre de la categoría junto con el promedio de duración. */
SELECT c.name AS category_name, AVG(f.length) AS length_average -- Podría no mostrarse length_average en el resultado (se ha puesto a efectos de comprobación)
FROM film f
LEFT JOIN film_category fc ON f.film_id = fc.film_id
LEFT JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
HAVING length_average>120
ORDER BY length_average;

/* 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor 
junto con la cantidad de películas en las que han actuado. */
SELECT a.first_name, COUNT(fa. film_id) AS number_of_films
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
HAVING  number_of_films>5
ORDER BY number_of_films;

/* 22. Encuentra el título de todas las películas que fueron alquiladas durante más de 5 días. Utiliza una 
subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona 
las películas correspondientes. Pista: Usamos DATEDIFF para calcular la diferencia entre una 
fecha y otra, ej: DATEDIFF(fecha_inicial, fecha_final) */
SELECT DISTINCT f.title
FROM (
	SELECT rental_id, DATEDIFF(return_date,rental_date) AS rental_days, return_date, rental_date
	FROM rental
	WHERE DATEDIFF(return_date,rental_date) > 5
	ORDER BY rental_days
	) AS newtable
JOIN rental r ON newtable.rental_id = r.rental_id
JOIN inventory i ON i.inventory_id = r.inventory_id
JOIN film f ON f.film_id = i.film_id; 

/* 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la 
categoría "Horror". Utiliza una subconsulta para encontrar los actores que han actuado en 
películas de la categoría "Horror" y luego exclúyelos de la lista de actores.*/
SELECT a.first_name, a.last_name
FROM actor a
WHERE a.actor_id NOT IN (
	SELECT fa.actor_id
    FROM film_actor fa
    WHERE fa.film_id IN (
		SELECT fc.film_id
        FROM film_category fc
        WHERE fc.category_id = (
			SELECT c.category_id 
            FROM category c 
            WHERE c.name = 'Horror')));

/* 24. BONUS: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 
minutos en la tabla film con subconsultas.*/
SELECT title, length
FROM film 
WHERE film_id IN (
	SELECT film_id 
	FROM film_category 
	WHERE category_id = (
		SELECT category_id 
		FROM category 
		WHERE name = 'Comedy'))
AND length > 180
ORDER BY length;

/* 25. BONUS: Encuentra todos los actores que han actuado juntos en al menos una película. La 
consulta debe mostrar el nombre y apellido de los actores y el número de películas en las que 
han actuado juntos. Pista: Podemos hacer un JOIN de una tabla consigo misma, poniendole un 
alias diferente */

-- BUENO pero sin nombres
SELECT 
	fa1.actor_id,
	fa2.actor_id,
    COUNT(fa1.film_id) AS shared_films
FROM 
    film_actor fa1,
    film_actor fa2
WHERE fa2.actor_id > fa1.actor_id
AND fa1.film_id = fa2.film_id
GROUP BY fa1.actor_id, fa2.actor_id;


--  NO FUNCIONA. INTENTO BUENO con nombres
SELECT 
	fa1.actor_id, CONCAT(a1.first_name, " ", a1.last_name) main, 
	fa2.actor_id, CONCAT(a2.first_name, " ", a2.last_name) mate,
    COUNT(fa1.film_id) AS shared_films
FROM actor a1
JOIN film_actor fa1 ON a1.actor_id = fa1.actor_id
JOIN film_actor fa2 ON fa1.actor_id = fa2.actor_id
JOIN actor a2 ON fa2.actor_id = a2.actor_id
WHERE fa2.actor_id > fa1.actor_id
AND fa1.film_id = fa2.film_id
GROUP BY fa1.actor_id, fa2.actor_id;

-- ⚠️ No he llegado a conseguir resolverlo, a continuación algunas pruebas:

SELECT 
	a1.actor_id AS main_id, a1.first_name AS main_name, a1.last_name AS main_surname, 
	a2.actor_id AS mate_id, a2.first_name AS mate_name, a2.last_name AS mate_surname,
    COUNT(fa1.film_id) AS shared_films
FROM 
	actor a1, 
	actor a2,
    film_actor fa1,
    film_actor fa2
WHERE a1.actor_id IN (SELECT fa1.actor_id FROM film_actor fa1)
AND a2.actor_id IN (SELECT fa2.actor_id FROM film_actor fa2)
AND a2.actor_id > a1.actor_id
AND fa1.film_id = fa2.film_id
GROUP BY a1.actor_id, a2.actor_id;

-- ⚠️ 0 rows returned
SELECT 
	a1.actor_id AS main,
	a2.actor_id AS mate,
    COUNT(fa1.film_id) AS shared_films
FROM actor a1
JOIN film_actor fa1 ON a1.actor_id = fa1.actor_id
JOIN film_actor fa2 ON fa1.actor_id = fa2.actor_id
JOIN actor a2 ON fa2.actor_id = a2.actor_id
WHERE a2.actor_id > a1.actor_id
AND fa1.film_id = fa2.film_id
GROUP BY a1.actor_id, a2.actor_id;

SELECT 
	a1.actor_id,
	a2.actor_id,
    COUNT(fa1.film_id) AS shared_films
FROM actor a1
JOIN actor a2 ON a1.actor_id = a2.actor_id
JOIN film_actor fa1 ON a1.actor_id = fa1.actor_id
JOIN film_actor fa2 ON a2.actor_id = fa2.actor_id
WHERE a2.actor_id > a1.actor_id
AND fa1.film_id = fa2.film_id
GROUP BY a1.actor_id, a2.actor_id, fa1.film_id
LIMIT 3;


SELECT 
	a1.actor_id,
	a2.actor_id,
    COUNT(fa1.film_id) AS shared_films
FROM actor a1
JOIN actor a2 ON a1.actor_id < a2.actor_id
JOIN film_actor fa1 ON a2.actor_id = fa1.actor_id
JOIN film_actor fa2 ON fa1.actor_id = fa2.actor_id
GROUP BY a1.actor_id, a2.actor_id;

SELECT 
	CONCAT(a1.first_name, " ", a1.last_name) main, CONCAT(a2.first_name, " ", a2.last_name) mate,
    COUNT(fa1.film_id) AS shared_films
FROM actor a1
JOIN actor a2 ON a1.actor_id < a2.actor_id
JOIN film_actor fa1 ON a2.actor_id = fa1.actor_id
JOIN film_actor fa2 ON fa1.actor_id = fa2.actor_id
GROUP BY a1.actor_id, a2.actor_id;

SELECT concat(a.first_name," ",a.last_name) AS actor1 ,  concat(a2.first_name," ",a2.last_name) actor2, COUNT(DISTINCT fa1.film_id) AS 'Total films together'
	FROM actor a
		INNER JOIN film_actor fa1 ON a.actor_id = fa1.actor_id
		INNER JOIN film_actor fa2 ON fa1.film_id = fa2.film_id AND fa1.actor_id > fa2.actor_id
		INNER JOIN actor a2 ON fa2.actor_id = a2.actor_id
		GROUP BY a.actor_id, a.first_name, a.last_name, a2.actor_id, a2.first_name, a2.last_name
		HAVING COUNT(DISTINCT fa1.film_id) >= 1;




-- Este esquema inicial con los primeros pasos no da error
SELECT 
	a1.actor_id AS main_id, a1.first_name AS main_name, a1.last_name AS main_surname, 
	a2.actor_id AS mate_id, a2.first_name AS mate_name, a2.last_name AS mate_surname
FROM 
	actor a1, 
	actor a2
WHERE a1.actor_id IN (2,3)
AND a2.actor_id IN (2,3,4,5)
AND a2.actor_id > a1.actor_id;


