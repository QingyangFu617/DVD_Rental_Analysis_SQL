# SQL DVD Rental Analysis
Here are the detail of the project, as well as the database I used in this project.

https://www.postgresqltutorial.com/postgresql-sample-database/

～～～sql
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
~~~
