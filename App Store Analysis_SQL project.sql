CREATE TAble aapleStore_description_combined AS

Select * FROM appleStore_description1

Union ALL

Select * FROM appleStore_description2

Union ALL

Select * FROM appleStore_description3

union ALL

Select * FROM appleStore_description4


**EXPLORATORY DATA ANALYSIS**

-- check the number of unique apps in both tablesAppleStoreAppleStore

Select count(distinct id) AS UniqueAppIDs
From AppleStore

select count (distinct id) AS UniqueAppID
From appleStore_description_combined

--check for any missing values in key fieldsAppleStore

select count(*) as MissingValues
from AppleStore
where track_name is NULL or user_rating is NULL or prime_genre is NULL

select count(*) as MissingValues
from appleStore_description_combined
where app_desc is NULL

--Find out the number of apps per genre

select prime_genre, COUNT(*) as NumApps
from AppleStore
Group by prime_genre
ORDER by NumApps DESC


--Get an overview of the apps' ratings

Select min(user_rating) as MinRating,
       max(user_rating) as MaxRating,
       avg(user_rating) as AvgRating
From AppleStore



**DATA ANALYSIS**

--Determine wheather paid apps have higher ratings then free apps

select CASE
            when price > 0 then 'Paid'
            else 'Free'
         end as App_Type,
         avg(user_rating) as Avg_Rating
from AppleStore
group by App_Type

--Check if apps with more supported languages have higher ratings

select case 
            when lang_num < 10 then '<10 languages'
            when lang_num BETWEEN 10 and 30 then '10-30 languages'
            else '>30 languages'
         end as language_bucket,
         avg(user_rating) as Avg_Rating
from AppleStore
group by language_bucket
order by Avg_Rating DESC

--Check genres with low ratings

select prime_genre,
       avg(user_rating) as Avg_Rating
from AppleStore
group by prime_genre
order by Avg_Rating ASC
limit 10


--Check if there is a correalation between the lenght of the app description and the user rating

SELECT case 
           when length(b.app_desc) <500 then 'Short'
           when length(b.app_desc) BETWEEN 500 and 1000 then 'Medium'
           else 'Long'
         End as description_lenght_bucket,
         avg(a.user_rating) as Average_Rating
             
from
     AppleStore as a
JOIN
     appleStore_description_combined as b
ON
     a.id = b.id

group by description_lenght_bucket
order by Average_Rating DESC

--Check the top-rates apps for each genre

select
      prime_genre,
      track_name,
      user_rating
from (
      select
  	  prime_genre,
 	  track_name,
      user_rating,
      RANK() OVER(PARTITION by prime_genre order by user_rating DESC, rating_count_tot DESC) as rank
      from 
      AppleStore
      ) as a
where 
a.rank = 1




 
