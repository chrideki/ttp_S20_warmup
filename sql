-- Another clever use of SUBQUERIES

-- EXAMPLE: What is the average customer lifetime spending?
-- Does this work?
SELECT AVG(SUM(amount))
FROM payment
GROUP BY customer_id; --NOPE! "ERROR:  aggregate function calls cannot be nested"
--TRY THIS
SELECT AVG(total)
FROM (SELECT SUM(amount) as total 
	  FROM payment 
	  GROUP BY customer_id) as customer_totals; --NICE! 
-- IMPORTANT! NOTICE THE ALIAS AT THE END. THIS IS NECESSARY WHEN THE SUBQUERY
-- IS IN THE FROM CLAUSE

--OR do the above with a CTE:
WITH customer_totals as ( --start of CTE
SELECT SUM(amount) as total 
FROM payment 
GROUP BY customer_id) --end of CTE
SELECT AVG(total)
FROM customer_totals;

-- YOUR TURN: what is the average of the amount of stock each store has in their inventory? (Use inventory table)
SELECT store_id, AVG(amount_of_stock) as avg_amount_of_stock
FROM (SELECT film_id, store_id, COUNT(inventory_id) as amount_of_stock
        FROM inventory
        GROUP BY film_id, store_id) as amount_per_film
GROUP BY store_id; 

-- YOUR TURN: What is the average customer lifetime spending, for each staff member?
-- HINT: you can work off the example
SELECT staff_id, AVG(lifetime_spending) as avg_customer_lifetime_spending
FROM (SELECT SUM(amount) as lifetime_spending, staff_id
      FROM payment
      GROUP BY customer_id, staff_id) as spending_per_customer
GROUP BY staff_id; 

--YOUR TURN: 
--What is the average number of films we have per genre (category)?
SELECT AVG(film_per_genre)
FROM (SELECT category_id, COUNT(film_id) as film_per_genre
      FROM film_category
      GROUP BY category_id) as film_per_category;








