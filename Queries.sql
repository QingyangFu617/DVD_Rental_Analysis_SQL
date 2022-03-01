/*Query1 -query used for first insight*/
WITH sub AS
	(SELECT c.name AS cate_name, r.rental_id AS rental_id
		FROM category c
		JOIN film_category f
		ON c.category_id = f.category_id
		JOIN film fm
		ON fm.film_id = f.film_id
		JOIN inventory AS i
		ON i.film_id = fm.film_id
		JOIN rental AS r
		ON r.inventory_id = i.inventory_id
		WHERE name = 'Animation' OR name = 'Children' OR name ='Classics' OR name = 'Comedy' OR name ='Family' OR name = 'Music'
)
SELECT cate_name, COUNT(*)
FROM sub
GROUP BY 1
ORDER BY 2 DESC;

/*Query2 -query used for first insight*/
WITH sub2 AS (SELECT category_name, NTILE(4) OVER (ORDER BY rental_duration) AS quartile
	FROM (SELECT c.name AS category_name, fm.rental_duration AS rental_duration
	FROM category c
	JOIN film_category fc
	ON c.category_id = fc.category_id
	JOIN film fm
	ON fm.film_id = fc.film_id
	WHERE name = 'Animation' OR name = 'Children' OR name ='Classics' OR name = 'Comedy' OR name ='Family' OR name = 'Music') sub
	)

SELECT category_name, quartile, COUNT(*) AS number_of_film
FROM sub2

GROUP BY 1,2
ORDER BY 1,2;

/*Query3 -query used for first insight*/
SELECT s.store_id,
		DATE_PART('month',r.rental_date) AS month, DATE_PART('year',r.rental_date) AS year,
		COUNT (*) AS rental_count
FROM staff s
JOIN rental r
ON s.staff_id=r.staff_id
JOIN store store
ON store.store_id=s.store_id

GROUP BY 1,2,3
ORDER BY 4 DESC;

/*Query4 -query used for first insight*/

SELECT DATE_TRUNC('month', p.payment_date) pay_mon, c.first_name || ' '|| c.last_name AS fullname, COUNT(*), SUM(p.amount)
FROM payment p
JOIN customer c
ON p.customer_id = c.customer_id
WHERE c.customer_id IN (
	SELECT  id
	FROM (SELECT c.customer_id id, c.first_name || ' '|| c.last_name AS name,  SUM(p.amount)
				FROM customer c
				JOIN payment p
				ON p.customer_id = c.customer_id
				GROUP BY 1,2
				ORDER BY 3 DESC
				LIMIT 10) sub
				)
GROUP BY  1,2
ORDER BY 2,1;
