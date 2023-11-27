####################################################
############ (1  Recyclable and Low Fat Products)
# (Q. Write a solution to find the ids of products that are both low fat and recyclable.)
# Write your MySQL query statement below
SELECT product_id 
FROM Products
WHERE low_fats =  recyclable AND low_fats <> 'N';

#2nd method
# Write your MySQL query statement below
SELECT product_id 
FROM Products
WHERE (low_fats =  recyclable) AND low_fats = 'Y' ;

# 3RD method
SELECT product_id 
FROM Products
WHERE low_fats = 'Y' AND  recyclable = 'Y';

####################################################
############ (2. Find Customer Referee)
# (Q. Find the names of the customer that are not referred by the customer with id = 2..)
# Write your MySQL query statement below
SELECT Name
from Customer
WHERE COALESCE(referee_id,0) <> 2; #COALESCE

#2ND METHOD
# Write your MySQL query statement below
SELECT Name
from Customer
WHERE referee_id IS NULL OR referee_id <> 2;

####################################################
############ (3. Big Countries)
# (Q. Write a solution to find the name, population, and area of the big countries.)
SELECT name, population, area
FROM World
WHERE AREA >= 3000000 OR population >=25000000;

####################################################
############ (4. Article Views)
/* (Q.Write a solution to find all the authors that viewed at least one of their own articles.
Return the result table sorted by id in ascending order.) */
SELECT DISTINCT author_id AS id
FROM Views
WHERE author_id = viewer_id
ORDER BY author_id;

####################################################
############ (5.Invalid Tweets)
/* (Q. Write a solution to find the IDs of the invalid tweets.
 The tweet is invalid if the number of characters used in the content of the tweet is strictly greater than 15..) */
# Write your MySQL query statement below
SELECT tweet_id
from Tweets
WHERE LENGTH(content) > 15;

####################################################
############ (6. Replace Employee ID With The Unique Identifier)
# (Q. Write a solution to show the unique ID of each user, If a user does not have a unique ID replace just show null.)
SELECT unique_id, name
FROM Employees E
LEFT JOIN EmployeeUNI EU
    ON E.ID = EU.ID;
    
####################################################
############ (7. Product Sales Analysis I)
# (Q. Write a solution to report the product_name, year, and price for each sale_id in the Sales table.)
SELECT product_name, year, price
FROM Sales S
JOIN Product P
    ON S.product_id = P.product_id;
    

####################################################
############ (8. Customer Who Visited but Did Not Make Any Transactions)
# (Q.Write a solution to find the IDs of the users who visited without making any transactions and the number of times they made these types of visits.)
# 1st method
SELECT customer_id, COUNT(v.visit_id) as count_no_trans 
FROM Visits v
LEFT JOIN Transactions t ON v.visit_id = t.visit_id
WHERE transaction_id IS NULL
GROUP BY customer_id;
    
# 2nd method
SELECT customer_id, COUNT(v.visit_id) as count_no_trans 
FROM Visits v
WHERE visit_id NOT IN (
	SELECT visit_id FROM Transactions)
GROUP BY customer_id;

# 3rd METHOD
SELECT customer_id, COUNT(visit_id) as count_no_trans 
FROM Visits v
WHERE NOT EXISTS (
	SELECT visit_id FROM Transactions t 
	WHERE t.visit_id = v.visit_id)
GROUP BY customer_id ;

#######################################################################
####################################### (9. Rising Temperature)
/* Note:- Cartesian product between the "Weather" table and itself  means that each row in "Weather" is matched with every row in "Weather"
 without any specific criteria for the matching. it produce result set where every row from "Weather" is paired
 with every row from "Weather," resulting in a potentially very large result set.
 
 Best way to avoid this 
 !. Self-Joins with a Meaningful Condition
SELECT w1.*, w2.*
FROM Weather w1
JOIN Weather w2 ON w1.recordDate = w2.recordDate - INTERVAL 1 DAY;

| id | recordDate | temperature |
| -- | ---------- | ----------- |
| 1  | 2015-01-01 | 10          |
| 2  | 2015-01-02 | 25          |
| 3  | 2015-01-03 | 20          |
| 4  | 2015-01-04 | 30          |

result would be like
| id | recordDate | temperature | id | recordDate | temperature |
| -- | ---------- | ----------- | -- | ---------- | ----------- |
| 1  | 2015-01-01 | 10          | 2  | 2015-01-02 | 25          |
| 2  | 2015-01-02 | 25          | 3  | 2015-01-03 | 20          |
| 3  | 2015-01-03 | 20          | 4  | 2015-01-04 | 30          |

2. Subqueries: If you want to retrieve data based on some comparison within the same table, you can use subqueries.
SELECT *
FROM Weather
WHERE temperature > (SELECT AVG(temperature) FROM Weather);
# Result would be like 
| id | recordDate | temperature |
| -- | ---------- | ----------- |
| 2  | 2015-01-02 | 25          |
| 4  | 2015-01-04 | 30          |


3. Window Functions:If you want to perform calculations or comparisons based on a window of rows within the same table, you can use window functions.
SELECT recordDate, temperature,
       LAG(temperature) OVER (ORDER BY recordDate) AS previous_day_temp
FROM Weather;
| recordDate | temperature | previous_day_temp |
| ---------- | ----------- | ----------------- |
| 2015-01-01 | 10          | null              |
| 2015-01-02 | 25          | 10                |
| 2015-01-03 | 20          | 25                |
| 2015-01-04 | 30          | 20                | 

*/

# (Q. Write a solution to find all dates' Id with higher temperatures compared to its previous dates (yesterday)..)
# Write your MySQL query statement below
#1st method
SELECT W1.id
FROM Weather W1, Weather W2
WHERE DATEDIFF(W1.recordDate, W2.recordDate) = 1 AND W1.Temperature > W2.Temperature;

# 2nd Method Using DATE_ADD
SELECT W1.id
FROM Weather W1
JOIN Weather W2 ON W1.recordDate = DATE_ADD(W2.recordDate, INTERVAL 1 DAY)
WHERE W1.Temperature > W2.Temperature;

# 3rd Method
SELECT W1.id
FROM Weather W1
WHERE EXISTS (
    SELECT 1
    FROM Weather W2
    WHERE W2.recordDate = DATE_ADD(W1.recordDate, INTERVAL -1 DAY)
      AND W1.Temperature > W2.Temperature);
      
# OR
SELECT W1.id
FROM Weather W1
WHERE W1.Temperature > (
    SELECT W2.Temperature
    FROM Weather W2
    WHERE W2.recordDate = DATE_SUB(W1.recordDate, INTERVAL 1 DAY)
    LIMIT 1);

# 4th method
SELECT W1.id
FROM Weather W1
JOIN Weather W2
ON W1.recordDate = W2.recordDate + INTERVAL 1 DAY
WHERE W1.Temperature > W2.Temperature;

# 5th method my prefer
WITH WeatherWithRowNumber AS (SELECT
        id,
        recordDate,
        Temperature,
        ROW_NUMBER() OVER (ORDER BY recordDate) AS RowNum
       FROM Weather)
SELECT W1.id
FROM WeatherWithRowNumber W1
JOIN WeatherWithRowNumber W2 ON W1.RowNum = W2.RowNum + 1
WHERE W1.Temperature > W2.Temperature;

# OR WITH CTE ALSO
WITH WeatherShifted AS (
    SELECT
        W1.id AS id1,
        W1.recordDate AS date1,
        W1.Temperature AS temp1,
        W2.id AS id2,
        W2.recordDate AS date2,
        W2.Temperature AS temp2
    FROM Weather W1
    JOIN Weather W2 ON DATE_ADD(W1.recordDate, INTERVAL -1 DAY) = W2.recordDate)
SELECT id1
FROM WeatherShifted
WHERE temp1 > temp2;


# 6th method
SELECT W1.id
FROM Weather W1
WHERE W1.Temperature > (SELECT W2.Temperature FROM Weather W2
						WHERE W2.recordDate = (SELECT MAX(recordDate) FROM Weather
												WHERE recordDate < W1.recordDate));
                                                
# 7th method
WITH WeatherWithNext AS (
  SELECT
    id,
    recordDate,
    Temperature,
    LEAD(recordDate) OVER (ORDER BY recordDate) AS nextDate,
    LEAD(Temperature) OVER (ORDER BY recordDate) AS nextTemp
  FROM Weather)
SELECT id
FROM WeatherWithNext
WHERE nextDate = DATE_ADD(recordDate, INTERVAL 1 DAY) AND Temperature > nextTemp;


#######################################################################
########################## (9. Average Time of Process per Machine)


