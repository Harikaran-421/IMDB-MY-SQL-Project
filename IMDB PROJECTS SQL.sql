use imdb_data ;

/* Now that I have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, I will take a look at 'movies' and 'genre' tables.*/
 
 -- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?

select table_name , table_rows from information_schema.tables where table_schema = 'imdb_data';

-- Q2. Which columns in the movie table have null values?


describe movie ;
describe genre;

select 'title' , count(*) as null_count from movie where title  is null union 
select 'id' , count(*) as null_count from movie where id is null
union select 'year' , count(*) as null_count from movie where year is null
union
select 'date_publish', count(*) from movie where date_published is null
union select 'duartion' , count(* ) from movie where duration is null 
union select 'country' , count(*) from movie where country is null 
union select 'worldwide_gross_income' , count(*) from movie where worlwide_gross_income is null 
union select 'language' , count(*) from movie where languages is null 
union select 'production_comapny' , count(*)  from movie where production_company is null order by null_count asc ;


 -- Q3. Find the total number of movies released each year? How does the trend look month wise?
 
 -- divice as two part 1 year wise  another one moth wise 
 -- total number of movies released each year?
 select year , count(title) as total_movies from movie group by year ;
 
 -- How does the trend look month wise?
 select month(date_published) as month_num, count(title) as total_movies from movie group by month(date_published) order by month_num asc;

/*The highest number of movies is produced in the month of March.
So, now that we have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/

SELECT 
    year , COUNT(title) as total_movies
FROM
    movie
WHERE year = 2019 
	AND (country LIKE '%USA%'
        OR country LIKE '%india%')
GROUP BY year;


/* USA and India produced more than a thousand movies(we know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?

select distinct genre from genre ;

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t I want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?

select g.genre, count(m.title) from movie as m inner join genre as g  on g.movie_id = m.id  group by g.genre order by count(m.title) desc  limit 2; 

/* So, based on the insight that we just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?

WITH AGG
     AS (SELECT m.ID,
                Count(g.GENRE) AS Genre
         FROM   MOVIE m
                INNER JOIN GENRE g
                        ON g.MOVIE_ID = m.ID
         GROUP  BY ID
         HAVING Count(g.GENRE) = 1)
SELECT Count(ID) AS movie_count
FROM   AGG; 

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)



SELECT g.genre,
       ROUND(AVG(m.DURATION), 2) AS avg_duration
FROM   MOVIE m
       INNER JOIN GENRE g
               ON g.MOVIE_ID = m.ID
GROUP  BY g.GENRE
ORDER  BY ROUND(AVG(m.DURATION), 2) DESC;  


/* Now we know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)



WITH GENRE_RANKS
     AS (SELECT genre,
                Count(MOVIE_ID)                    AS 'movie_count',
                RANK()
                  OVER(
                    ORDER BY Count(MOVIE_ID) DESC) AS genre_rank
         FROM   GENRE
         GROUP  BY GENRE)
SELECT *
FROM   GENRE_RANKS
WHERE  GENRE = 'thriller'; 

-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?

SELECT ROUND(MIN(AVG_RATING), 1) AS min_avg_rating,
       ROUND(MAX(AVG_RATING), 1) AS max_avg_rating,
       MIN(TOTAL_VOTES)          AS min_total_votes,
       MAX(TOTAL_VOTES)          AS max_total_votes,
       MIN(MEDIAN_RATING)        AS min_median_rating,
       MAX(MEDIAN_RATING)        AS max_median_rating
FROM   RATINGS; 












































