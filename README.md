# SQL DVD Rental Analysis
Here are the detail of the project, as well as the database I used in this project.

https://www.postgresqltutorial.com/postgresql-sample-database/


Q1:What is the total number of rent-out per category?

~~~~sql
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
~~~~

<img width="324" alt="image" src="https://user-images.githubusercontent.com/100692852/156179903-bba34484-2a00-47f1-8af1-c8671688f7c7.png">

In this graph, the rent-out data are collected. A total of 350 films are collected by category. Animation (1166) and Family (1096) film rentals are the highest, followed by Children (945), classics (939), and Comedy (941). Music (830) films are the lowest among others.
So we can conclude that animation and family movies are the most popular and music movies are very sluggish in terms of rentals.



