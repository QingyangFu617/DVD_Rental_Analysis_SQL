# SQL DVD Rental Analysis
Here are the detail of the project, as well as the database I used in this project.

https://www.postgresqltutorial.com/postgresql-sample-database/


**Q1:What is the total number of rent-out per category?**

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


**Q2 How can stores maximize their profit by arranging the type of movies?**
~~~~sql
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
~~~~
<img width="443" alt="image" src="https://user-images.githubusercontent.com/100692852/156180317-5df4bd69-dddb-48c4-87ec-be8b8a8d3f64.png">

In this graph, all the films are equally divided into four levels based on their rental duration, and each table represents a different type of film. 
Animation has 22 rent that falls into Duration Level 1, which is the greatest compared to other film types. For Comedy, most of the film's rental duration is in Level 1. Similarly, there are 20 Family films in Duration Level 3. And for children's movies, 18 films are in Level 2.
To maximize the profit, we should increase the number of Animation, Comedy, and children types, since most of the film has level 1 and level 2 rental duration. And slightly reduce Family and Classic type. 


**Question 3 What is the number of rent-out in different stores?**
~~~~sql
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
~~~~

<img width="411" alt="image" src="https://user-images.githubusercontent.com/100692852/156506372-5b275033-58d0-4de0-9d8b-1c38f7840bb8.png">

This graph collected data for the number of films rent-out in different stores per month. The rental count increases slightly from May to June 2005 in both stores and then increases dramatically to around 3200 in July. After the peak, the rent-out number decreased sharply to nearly 100 in February 2006.
There might be a periodical trend in film rent-out. The rental count reaches the peak in the summer; this is probably because kids are on summer vacation and movie rentals are way up.


**Question 4: What is the trend of payment amount and number of orders in top 10 customers? And Why?**
~~~~sql
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
~~~~

<img width="358" alt="image" src="https://user-images.githubusercontent.com/100692852/156181950-09c0f333-4e1a-47ee-97df-bec5880b3bef.png">


The two graphs show the payment amount trend and the number of orders per month.
The top 10 customer shows a similar trend in both graphs, which increases in the first two months and peaks in April 2007. After that, both the payment amount and the number of orders decrease sharply to nearly 0.  
 We only have the date of May 2007 for four customers among the top 10. Other data are not available. This may be because the data was collected at the beginning of May when many consumers had not yet made their orders.


