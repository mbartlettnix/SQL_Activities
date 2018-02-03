-- 1a. Display the first and last names of all actors from the table actor. 
USE sakila; 
SELECT first_name, last_name FROM actor; 

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name. 
 
SELECT UPPER(CONCAT(first_name," ", last_name)) AS Actor_Name FROM actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
 
SELECT actor_id, first_name, last_name FROM actor
WHERE first_name = 'Joe'; 

-- 2b. Find all actors whose last name contain the letters GEN:

SELECT first_name, last_name FROM actor
WHERE last_name LIKE '%g%' OR last_name LIKE '%e%' OR last_name LIKE'%n%';

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT first_name, last_name FROM actor
WHERE last_name LIKE '%l%' OR last_name LIKE '%i%' 
ORDER BY last_name, first_name;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country From country 
WHERE country IN ('Afghanistan','Bangladesh','China');

-- 3a. Add a middle_name column to the table actor. Position it between first_name and last_name. Hint: you will need to specify the data type.
ALTER TABLE actor 
ADD middle_name VARCHAR(60) AFTER first_name; 

-- 3b. You realize that some of these actors have tremendously long last names. Change the data type of the middle_name column to blobs.
ALTER TABLE actor
MODIFY COLUMN middle_name blob;

-- 3c. Now delete the middle_name column.
ALTER TABLE actor 
DROP COLUMN middle_name;


-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT DISTINCT last_name, count(*) FROM actor GROUP BY last_name;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT DISTINCT last_name, count(*) FROM actor 
GROUP BY last_name
HAVING count(*)>1 ;

-- 4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
UPDATE actor 
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' and last_name = 'WILLIAMS';

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! 
-- In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. 
-- Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error. 
-- BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER! (Hint: update the record using a unique identifier.)

UPDATE actor 
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO' and last_name = 'WILLIAMS';


-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW COLUMNS FROM address;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT s.first_name, s.last_name, a.address
FROM staff s
LEFT OUTER JOIN address a ON s.address_id = a.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment. 
SELECT s.first_name, s.last_name, SUM(p.amount) AS Payment
FROM staff s
LEFT OUTER JOIN payment p ON s.staff_id = p.staff_id
GROUP by 1,2;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT f.title, COUNT(fa.actor_id) as Actor_Count
FROM film f
INNER JOIN film_actor fa ON fa.film_id = f.film_id
GROUP BY 1;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT COUNT(*) AS Inventory_Count
FROM inventory 
LEFT JOIN film ON film.film_id = inventory.film_id
WHERE film.title = 'Hunchback Impossible';

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT c.first_name, c.last_name, SUM(p.amount) AS Total_Paid
FROM customer c 
INNER JOIN payment p ON c.customer_id = p.customer_id 
GROUP BY 1,2
ORDER BY 2;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English. 
SELECT title FROM film
WHERE language_id =(SELECT language_id FROM language
WHERE name = 'English') AND title LIKE 'Q%' OR title LIKE 'K%';

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name,last_name FROM actor WHERE actor_id IN
(SELECT actor_id FROM film_actor WHERE film_id =
(SELECT film_id FROM film WHERE title = 'Alone Trip'));

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT first_name,last_name, email FROM customer
LEFT OUTER JOIN address ON customer.address_id = customer.address_id
LEFT OUTER JOIN city ON city.city_id = address.city_id
LEFT OUTER JOIN country ON country.country_id = city.country_id
WHERE country.country = 'Canada'
GROUP BY 1,2,3;

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.
SELECT title FROM film
WHERE film_id IN (SELECT film_id FROM film_category WHERE category_id = (SELECT category_id FROM category WHERE name = 'Family'));

-- 7e. Display the most frequently rented movies in descending order.
SELECT f.title, COUNT(r.rental_id) AS Rental_Count FROM film f
LEFT OUTER JOIN inventory i ON i.film_id = f.film_id
LEFT OUTER JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY 1
ORDER BY 2 DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT s.store_id, SUM(p.amount) AS Total_Sales FROM store s
LEFT OUTER JOIN staff st ON s.store_id = st.store_id
LEFT OUTER JOIN payment p ON p.staff_id = st.staff_id
GROUP BY 1;

-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT s.store_id, c.city, co.country FROM store s
LEFT OUTER JOIN staff st ON st.store_id = s.store_id
LEFT OUTER JOIN address a ON a.address_id = st.address_id
LEFT OUTER JOIN city c ON c.city_id = a.city_id
LEFT OUTER JOIN country co ON co.country_id = c.country_id;

-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT c.name, SUM(p.amount) FROM category c
LEFT OUTER JOIN film_category f ON f.category_id = c.category_id
LEFT OUTER JOIN inventory i ON i.film_id = f.film_id
LEFT OUTER JOIN rental r ON r.inventory_id = i.inventory_id 
LEFT OUTER JOIN payment p ON p.rental_id = r.rental_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW Top_Five_Genres AS
SELECT c.name, SUM(p.amount) FROM category c
LEFT OUTER JOIN film_category f ON f.category_id = c.category_id
LEFT OUTER JOIN inventory i ON i.film_id = f.film_id
LEFT OUTER JOIN rental r ON r.inventory_id = i.inventory_id 
LEFT OUTER JOIN payment p ON p.rental_id = r.rental_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- 8b. How would you display the view that you created in 8a?
SELECT * FROM Top_Five_Views;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW Top_Five_Views;


