USE imdb;

/* Now that you have impORted the data sets, let’s explORe some of the tables. 
 To begin WITH, it is beneficial to know the shape of the tables AND whether any column hAS null values.
 Further in this segment, you will take a look at 'movies' AND 'genre' tables.*/



-- Segment 1:



-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT  Table_Name, 
		Table_Rows
FROM    INFORMATION_SCHEMA.TABLES
WHERE   TABLE_SCHEMA = 'imdb';








-- Q2. Which columns in the movie table have null values?
-- Type your code below:



SELECT  SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS ID_Null_Value,
		SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS Title_Null_Value,
		SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS Year_Null_Value,
		SUM(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END) AS DatePublished_Null_Value,
		SUM(CASE WHEN duratiON IS NULL THEN 1 ELSE 0 END) AS DuratiON_Null_Value,
		SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS country_Null_Value,
		SUM(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END) AS worldWide_Null_Value,
		SUM(CASE WHEN languages IS NULL THEN 1 ELSE 0 END) AS Language_Null_Value,
		SUM(CASE WHEN productiON_company IS NULL THEN 1 ELSE 0 END) AS production_company_Null_Value
FROM movie;



-- Now AS you can see four columns of the movie table hAS null values. Let's look at the at the movies releASed each year. 
-- Q3. Find the total number of movies releASed each year? How does the trend look MONTH wise? (Output expected)


/* Output fORmat fOR the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output fORmat fOR the secONd part of the questiON:
+---------------+-------------------+
|	MONTH_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- 1st part answer 
SELECT   year AS Year,
		 COUNT(year) AS number_of_movies
FROM     movie
GROUP BY year;

-- 2nd part answer
SELECT   MONTH(date_published) AS month_num,
		 COUNT(year) AS number_of_movies
FROM     movie
GROUP BY month_num
ORDER BY month_num ;


/*The highest number of movies is produced in the MONTH of March.
So, now that you have understood the MONTH-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA AND India produces huge number of movies each year. Lets find the number of movies produced by USA OR India fOR the lASt year.*/
  
-- Q4. How many movies were produced in the USA OR India in the year 2019??
-- Type your code below:

SELECT  COUNT(m.id) AS total_number_of_movies
FROM    movie m
WHERE   year = 2019 AND 
		(m.country LIKE '%India%' OR m.country LIKE '%USA%');



/* USA AND India produced mORe than a thousAND movies(you know the exact number!) in the year 2019.
ExplORing table Genre would be fun!! 
Let’s find out the different genres in the datASet.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT genre
FROM genre;

/* So, RSVP Movies plans to make a movie of ONe of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the lASt year?
Combining both the movie AND genres table can give mORe interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT     g.genre,
		   COUNT(m.id) AS number_of_movies
FROM       genre g
INNER JOIN movie m
		ON g.movie_id = m.id
GROUP BY   genre 
ORDER BY   number_of_movies DESC 
LIMIT 1;






/* So, bASed ON the insight that you just drew, RSVP Movies should focus ON the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belONg to two OR mORe genres. 
So, let’s find out the COUNT of movies that belONg to ONly ONe genre.*/

-- Q7. How many movies belONg to ONly ONe genre?
-- Type your code below:


WITH 	 movie_one_genre AS(SELECT movie_id 
FROM 	 genre 
GROUP BY movie_id 
HAVING   COUNT(movie_id)  = 1)
SELECT   COUNT(*) AS '#_movie_with_one_genre' 
FROM     movie_one_genre ;


/* There are mORe than three thousAND movies which hAS ONly ONe genre ASsociated WITH them.
So, this figure appears significant. 
Now, let's find out the possible duratiON of RSVP Movies’ next project.*/

-- Q8.What is the average duratiON of movies in each genre? 
-- (Note: The same movie can belONg to multiple genres.)


/* Output fORmat:

+---------------+-------------------+
| genre			|	avg_duratiON	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT     g.genre,
	       ROUND(AVG(m.duratiON),2) AS avg_duratiON
FROM       genre g
INNER JOIN movie m
		ON g.movie_id = m.id
GROUP BY   genre 
ORDER BY   avg_duratiON DESC ;



/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) hAS the average duratiON of 106.77 mins.
Lets find WHERE the movies of genre 'thriller' ON the bASis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies amONg all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank functiON)


/* Output fORmat:
+---------------+-------------------+---------------------+
| genre			|		movie_COUNT	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH     top_ranking_movies AS (SELECT genre,
	     COUNT(movie_id) AS movie_COUNT ,
         RANK() OVER(ORDER BY COUNT(movie_id) DESC) AS genre_rank
FROM     genre
GROUP BY genre)
SELECT   * 
FROM     top_ranking_movies 
WHERE    genre = 'Thriller' ;


/*Thriller movies is in top 3 amONg all genres in terms of number of movies
 In the previous segment, you analysed the movies AND genres tables. 
 In this segment, you will analyse the ratings table AS well.
To start WITH lets get the min AND max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum AND maximum values in  each column of the ratings table except the movie_id column?
/* Output fORmat:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT MIN(avg_rating)    AS min_avg_rating ,
	   MAX(avg_rating)    AS max_avg_rating ,
       MIN(total_votes)   AS min_total_votes ,
       MAX(total_votes)   AS max_total_votes ,
       MIN(median_rating) AS min_median_rating ,
       MAX(median_rating) AS max_median_rating
FROM ratings ;


/* So, the minimum AND maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies bASed ON average rating.*/

-- Q11. Which are the top 10 movies bASed ON average rating?
/* Output fORmat:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() OR DENSE_RANK() is used too

SELECT     m.title,
		   r.avg_rating,
		   ROW_NUMBER() OVER (ORDER BY avg_rating DESC ) AS movie_rank
FROM       movie m
INNER JOIN ratings r 
		ON m.id = r.movie_id
LIMIT 10;




/* Do you find you favourite movie FAN in the top 10 movies WITH an average rating of 9.6? If not, pleASe check your code again!!
So, now that you know the top 10 movies, do you think character actORs AND filler actORs can be FROM these movies?
Summarising the ratings table bASed ON the movie COUNTs by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table bASed ON the movie COUNTs by median ratings.
/* Output fORmat:

+---------------+-------------------+
| median_rating	|	movie_COUNT		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- ORDER BY is good to have

SELECT   median_rating,
	     COUNT(movie_id) AS movie_COUNT
FROM     ratings
GROUP BY median_rating 
ORDER BY median_rating;


/* Movies WITH a median rating of 7 is highest in number. 
Now, let's find out the productiON house WITH which RSVP Movies can partner fOR its next project.*/

-- Q13. Which productiON house hAS produced the most number of hit movies (average rating > 8)??
/* Output fORmat:
+------------------+-------------------+---------------------+
|productiON_company|movie_COUNT	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
WITH   movies_with_highest_rank AS (
SELECT m.production_company ,
	   COUNT(r.movie_id) AS movie_COUNT,
       DENSE_RANK() over (ORDER BY COUNT(r.movie_id)  DESC) AS prod_company_rank
FROM   movie m 
INNER JOIN ratings r
	  ON m.id = r.movie_id
WHERE r.avg_rating > 8 AND 
      m.production_company IS NOT NULL
GROUP BY m.production_company)
SELECT * 
FROM   movies_with_highest_rank 
WHERE  prod_company_rank =1 ;


-- It's ok if RANK() OR DENSE_RANK() is used too
-- Answer can be Dream WarriOR Pictures OR NatiONal Theatre Live OR both

-- Q14. How many movies releASed in each genre during March 2017 in the USA had mORe than 1,000 votes?
/* Output fORmat:

+---------------+-------------------+
| genre			|	movie_COUNT		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT  g.genre,
	    COUNT(m.id) AS movie_COUNT 
FROM    genre g
INNER JOIN movie m
		ON m.id=g.movie_id
INNER JOIN ratings r 
		ON m.id = r.movie_id
WHERE MONTH(m.date_published) = 3 AND
	  m.year = 2017 AND
      m.country LIKE '%USA%' AND
      r.total_votes > 1000
GROUP BY g.genre 
ORDER BY COUNT(m.id) DESC;






-- Lets try to analyse WITH a unique problem statement.
-- Q15. Find movies of each genre that start WITH the wORd ‘The’ AND which have an average rating > 8?
/* Output fORmat:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT  m.title,
		r.avg_rating,
		g.genre
FROM    genre g
INNER JOIN movie m
		ON m.id=g.movie_id
INNER JOIN ratings r 
		ON m.id = r.movie_id
WHERE m.title LIKE 'The%' AND
	  r.avg_rating > 8 
GROUP BY m.title
ORDER BY avg_rating DESC ;



-- You should also try your hAND at median rating AND check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies releASed BETWEEN 1 April 2018 AND 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT COUNT(m.id) AS no_of_movies
FROM   movie m 
INNER JOIN ratings r 
	  ON m.id = r.movie_id
WHERE m.date_published BETWEEN '2018-04-01' AND '2019-04-01' AND
	  r.median_rating = 8;





-- ONce again, try to solve the problem given below.
-- Q17. Do German movies get mORe votes than Italian movies? 
-- Hint: Here you have to find the total number of votes fOR both German AND Italian movies.
-- Type your code below:

SELECT  m.country,
	    SUM(r.total_votes) AS vote
FROM    movie m
INNER JOIN ratings r
		ON m.id = r.movie_id
WHERE m.country = 'Germany' OR m.country = 'Italy'
GROUP BY m.country;

-- Answer is Yes

/* Now that you have analysed the movies, genres AND ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching fOR null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values fOR individual columns OR follow below output fORmat
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_fOR_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT 
		SUM(CASE 
				WHEN name IS NULL THEN 1 
                ELSE 0 
                END) AS name_nulls, 
		SUM(CASE 
				WHEN height IS NULL THEN 1 
                ELSE 0 
                END) AS height_nulls,
		SUM(CASE 
				WHEN date_of_birth IS NULL THEN 1
                ELSE 0 
                END) AS date_of_birth_nulls,
		SUM(CASE 
				WHEN known_for_movies IS NULL THEN 1 
                ELSE 0 
                END) AS known_for_movies_nulls
FROM names;




/* There are no Null value in the column 'name'.
The directOR is the most impORtant persON in a movie crew. 
Let’s find out the top three directORs in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directORs in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies WITH an average rating > 8.)
/* Output fORmat:

+---------------+-------------------+
| directOR_name	|	movie_COUNT		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top_three_genre AS (
		SELECT g.genre ,
			   COUNT(m.id) AS no_of_movies
		FROM   genre g
		INNER JOIN movie m
			  ON g.movie_id =  m.id 
		INNER JOIN ratings r
			  ON m.id = r.movie_id
		WHERE r.avg_rating > 8
		GROUP BY genre
		ORDER BY COUNT(g.genre) DESC LIMIT 3)
SELECT n.name AS directOR_name,
		COUNT(d.movie_id) AS movie_COUNT
FROM names n
INNER JOIN directOR_mapping d
		ON n.id = d.name_id
INNER JOIN ratings r
		ON d.movie_id = r.movie_id
INNER JOIN genre g
		ON r.movie_id = g.movie_id
INNER JOIN top_three_genre t
		ON t.genre = g.genre
WHERE r.avg_rating > 8
GROUP BY n.name
ORDER BY movie_COUNT DESC 
LIMIT 3
;



/* James Mangold can be hired AS the directOR fOR RSVP's next project. Do you remeber his movies, 'Logan' AND 'The Wolverine'. 
Now, let’s find out the top two actORs.*/

-- Q20. Who are the top two actORs whose movies have a median rating >= 8?
/* Output fORmat:

+---------------+-------------------+
| actOR_name	|	movie_COUNT		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT  n.name AS actOR_name ,
	   COUNT(n.name) AS movie_COUNT
FROM names n 
INNER JOIN role_mapping rm
		ON n.id = rm.name_id
INNER JOIN ratings r 
		ON rm.movie_id = r.movie_id
WHERE r.median_rating >= 8 AND
	  rm.categORy = 'actOR'
GROUP BY n.name 
ORDER BY movie_COUNT DESC
LIMIT 2;






/* Have you find your favourite actOR 'Mohanlal' in the list. If no, pleASe check your code again. 
RSVP Movies plans to partner WITH other global productiON houses. 
Let’s find out the top three productiON houses in the wORld.*/

-- Q21. Which are the top three productiON houses bASed ON the number of votes received by their movies?
/* Output fORmat:
+------------------+--------------------+---------------------+
|productiON_company|vote_COUNT			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:


SELECT  m.production_company,
		SUM(r.total_votes) AS vote_COUNT,
        DENSE_RANK() OVER(ORDER BY SUM(r.total_votes) DESC) AS prod_comp_rank
FROM    movie m
INNER JOIN ratings r 
		ON m.id = r.movie_id
GROUP BY productiON_company
LIMIT 3;


/*Yes Marvel Studios rules the movie wORld.
So, these are the top three productiON houses bASed ON the number of votes received by the movies they have produced.

Since RSVP Movies is bASed out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actORs fOR its upcoming project to give a regiONal feel. 
Let’s find who these actORs could be.*/

-- Q22. Rank actORs WITH movies releASed in India bASed ON their average ratings. Which actOR is at the top of the list?
-- Note: The actOR should have acted in at leASt five Indian movies. 
-- (Hint: You should use the weighted average bASed ON votes. If the ratings clASh, THEN the total number of votes should act AS the tie breaker.)

/* Output fORmat:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actOR_name	|	total_votes		|	movie_COUNT		  |	actOR_avg_rating 	 |actOR_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT  n.name AS actOR_name,
		r.total_votes,
        COUNT(m.id) AS movie_COUNT,
        ROUND(SUM(r.avg_rating* r.total_votes)/SUM(r.total_votes),2) AS actOR_avg_rating,
        RANK() over (ORDER BY ROUND(SUM(r.avg_rating* r.total_votes)/SUM(r.total_votes),2) DESC , SUM(total_votes) DESC) AS actor_rank
FROM names n
INNER JOIN role_mapping rm
		ON n.id = rm.name_id
INNER JOIN movie m
		ON rm.movie_id = m.id
INNER JOIN ratings r
		ON m.id = r.movie_id
WHERE  rm.category = 'actor' AND
		m.country LIKE '%India%' 
GROUP BY n.name 
HAVING COUNT(n.name) >= 5
LIMIT 1;

		

-- Top actOR is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies releASed in India bASed ON their average ratings? 
-- Note: The actresses should have acted in at leASt three Indian movies. 
-- (Hint: You should use the weighted average bASed ON votes. If the ratings clASh, THEN the total number of votes should act AS the tie breaker.)
/* Output fORmat:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_COUNT		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
 
SELECT  n.name AS actress_name,
		r.total_votes,
        COUNT(m.id) AS movie_COUNT,
        ROUND(SUM(r.avg_rating * r.total_votes)/SUM(r.total_votes),2) AS actress_avg_rating,
        RANK() over (ORDER BY ROUND(SUM(r.avg_rating* r.total_votes)/SUM(r.total_votes),2) DESC , SUM(total_votes) DESC) AS actress_rank
FROM names n
INNER JOIN role_mapping rm
		ON n.id = rm.name_id
INNER JOIN movie m
		ON rm.movie_id = m.id
INNER JOIN ratings r
		ON m.id = r.movie_id
WHERE  rm.category = 'actress' AND
		m.country LIKE '%India%' AND
        m.languages LIKE '%Hindi%'
GROUP BY name 
HAVING COUNT(name) >= 3
LIMIT 5;



/* Taapsee Pannu tops WITH average rating 7.74. 
Now let us divide all the thriller movies in the following categORies AND find out their numbers.*/


/* Q24. SELECT thriller movies AS per avg rating AND classify them in the following categORy: 

			Rating > 8: Superhit movies
			Rating BETWEEN 7 AND 8: Hit movies
			Rating BETWEEN 5 AND 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
SELECT  m.title,
		r.avg_rating,
		CASE 
			WHEN r.avg_rating > 8 THEN 'Superhit Movies'
            WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
            WHEN r.avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
            ELSE 'Flop movie'
		END AS movie_category
FROM movie m
INNER JOIN ratings r
		ON m.id = r.movie_id
INNER JOIN genre g
		ON r.movie_id = g.movie_id
WHERE g.genre = 'Thriller'
ORDER BY avg_rating DESC;



/* Until now, you have analysed various tables of the data set. 
Now, you will perfORm some tASks that will give you a broader understANDing of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total AND moving average of the average movie duratiON? 
-- (Note: You need to show the output table in the questiON.) 
/* Output fORmat:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duratiON	|running_total_duratiON|moving_avg_duratiON  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT  g.genre,
		ROUND(AVG(m.duratiON),2) AS avg_duration,
	    SUM(ROUND(AVG(m.duratiON),2)) OVER w1 AS running_total_duration,
        AVG(ROUND(AVG(m.duratiON),2)) OVER w2 AS moving_avg_duration
FROM genre g
INNER JOIN movie m
			ON g.movie_id = m.id
GROUP BY genre 
WINDOW  w1 AS (ORDER BY g.genre ROWS UNBOUNDED PRECEDING ),
		w2 AS (ORDER BY g.genre ROWS 10  PRECEDING)
ORDER BY genre ;








-- Round is good to have AND not a must have; Same thing applies to sORting


-- Let us find top 5 movies of each year WITH top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belONg to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output fORmat:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres bASed ON most number of movies

WITH top_three_genre AS(
		SELECT 	g.genre,
				COUNT(g.movie_id) AS movie_COUNT
		FROM genre g
		GROUP BY genre
		ORDER BY COUNT(g.movie_id) DESC
		LIMIT 3) ,
unsigned_gORss_income AS (
		SELECT CONVERT(REPLACE(REPLACE(TRIM(wORlwide_gross_income), "INR ",""), "$ ",""),UNSIGNED ) AS gross_income ,
				mv.id AS id
		FROM  movie mv
) ,
top_five_movie AS (
		SELECT 	g.genre,
				m.year,
				m.title AS movie_name,
				ugs.gross_income AS wORldwide_gross_income,
				DENSE_RANK() OVER(partitiON by  year ORDER BY  ugs.gross_income DESC) AS movie_rank
		FROM movie m
		INNER JOIN genre g
				ON m.id = g.movie_id
		INNER JOIN unsigned_gORss_income ugs
				ON g.movie_id = ugs.id
		WHERE genre IN (SELECT genre FROM top_three_genre) 
			  )
SELECT * 
FROM   top_five_movie 
WHERE  movie_rank <= 5 ;







-- Finally, let’s find out the names of the top two productiON houses that have produced the highest number of hits amONg multilingual movies.
-- Q27.  Which are the top two productiON houses that have produced the highest number of hits (median rating >= 8) amONg multilingual movies?
/* Output fORmat:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT  m.production_company,
		COUNT(m.id)AS movie_count,
        DENSE_RANK() OVER(ORDER BY COUNT(m.id) DESC) AS prod_comp_rank
FROM  movie m 
INNER JOIN ratings r
		ON m.id = r.movie_id
WHERE r.median_rating >= 8 AND
	  POSITION(',' in languages) > 0 AND
	  m.productiON_company is not null
GROUP BY m.productiON_company 
LIMIT 2;







-- Multilingual is the impORtant piece in the above questiON. It wAS created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of mORe than ONe language


-- Q28. Who are the top 3 actresses bASed ON number of Super Hit movies (average rating >8) in drama genre?
/* Output fORmat:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT  n.name AS actress_name,
		SUM(r.total_votes) AS total_votes,
        COUNT(r.movie_id) AS movie_count,
        ROUND(SUM(r.avg_rating * r.total_votes)/SUM(r.total_votes),2) AS actress_avg_rating,
        DENSE_RANK() OVER(ORDER BY COUNT(r.movie_id) DESC) AS actress_rank
FROM names n
INNER JOIN role_mapping rm
		ON n.id = rm.name_id
INNER JOIN ratings r 
		ON rm.movie_id = r.movie_id
INNER JOIN genre g 
		ON r.movie_id = g.movie_id
WHERE   rm.categORy = 'actress' AND
		r. avg_rating > 8       AND
        g.genre = 'Drama'
GROUP BY n.name
LIMIT 3;
		






/* Q29. Get the following details fOR top 9 directORs (bASed ON number of movies)
DirectOR id
Name
Number of movies
Average inter movie duratiON in days
Average movie ratings
Total votes
Min rating
Max rating
total movie duratiONs

FORmat:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| directOR_id	|	directOR_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duratiON |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH date_summary AS
(
		SELECT d.name_id,
		NAME,
		d.movie_id,
		duratiON,
		r.avg_rating,
		total_votes,
		m.date_published,
		LEAD(date_published,1) OVER(PARTITION BY d.name_id ORDER BY date_published,movie_id ) AS next_date_published
		FROM directOR_mapping AS d
		INNER JOIN names AS n ON n.id = d.name_id
		INNER JOIN movie AS m ON m.id = d.movie_id
		INNER JOIN ratings AS r ON r.movie_id = m.id ),
top_director_summary AS
		(
		SELECT *,
			   DATEDIFF(next_date_published, date_published) AS date_difference
		FROM date_summary
		)
SELECT 	name_id AS director_id,
		NAME AS director_name,
		COUNT(movie_id) AS number_of_movies,
		ROUND(AVG(date_difference),2) AS avg_inter_movie_days,
		ROUND(AVG(avg_rating),2) AS avg_rating,
		SUM(total_votes) AS total_votes,
		MIN(avg_rating) AS min_rating,
		MAX(avg_rating) AS max_rating,
		SUM(duratiON) AS total_duration
FROM top_directOR_summary
GROUP BY directOR_id
ORDER BY COUNT(movie_id) DESC
LIMIT 9;





