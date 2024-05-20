create database crypto;
use crypto;
Select * from cryptopunkdata;

# How many sales occurred during this time period?
Select count(transaction_hash) as Sales from cryptopunkdata;

# Return the top 5 most expensive transactions (by USD price) for this data set. Return the name, ETH price, and USD price, as well as the date.
SELECT name, eth_price, usd_price, utc_timestamp as date
FROM cryptopunkdata
ORDER BY usd_price DESC
LIMIT 5;

# Return a table with a row for each transaction with an event column, a USD price column, and a moving average of USD price that averages the last 50 transactions.
Select transaction_hash, usd_price, 
avg(usd_price) over(order by day rows between 49 preceding and current row) as moving_avg_usd 
from cryptopunkdata;

# Return all the NFT names and their average sale price in USD. Sort descending. Name the average column as average_price.
select name, avg(usd_price) as Average_price from cryptopunkdata 
group by name
order by Average_price Desc; 

#Construct a column that describes each sale and is called summary. The sentence should include who sold the NFT name, who bought the NFT, who sold the NFT, the date, and what price it was sold for in USD rounded to the nearest thousandth.
Select Concat (name, " was sold for $ ", round (usd_price,-3), " to ", 
" from ", seller_address, " on ", day) as Summary from cryptopunkdata;

#Return each day of the week and the number of sales that occurred on that day of the week, as well as the average price in ETH. Order by the count of transactions in ascending order.
select dayofweek(day) as Days, count(*) as Count, avg (eth_price) as Average
from cryptopunkdata
group by dayofweek(day) 
order by count(*);

#Create a view called “1919_purchases” and contains any sales where “0x1919db36ca2fa2e15f9000fd9cdc2edcf863e685” was the buyer.
CREATE VIEW 1919_purchases AS
    SELECT * FROM cryptopunkdata
    WHERE buyer_address = '0x1919db36ca2fa2e15f9000fd9cdc2edcf863e685';

#Create a histogram of ETH price ranges. Round to the nearest hundred value. 
SELECT ROUND(eth_price, -2)  AS bucket, 
COUNT(*) AS count,
RPAD('', COUNT(*), '*') AS bar 
FROM cryptopunkdata
GROUP BY bucket
ORDER BY bucket;

#Return a unioned query that contains the highest price each NFT was bought for and a new column called status saying “highest” with a query that has the lowest price each NFT was bought for and the status column saying “lowest”. The table should have a name column, a price column called price, and a status column. Order the result set by the name of the NFT, and the status, in ascending order. 
Select name, max(eth_price), 'Highest' as Status
from cryptopunkdata
group by name
Union
Select name, min(eth_price), 'Lowest' as Status
from cryptopunkdata
group by name
order by name;

#Return the total volume (sum of all sales), round to the nearest hundred on a monthly basis (month/year).Select year(day) as Year, month(day) as Month, Round(sum(usd_price),-2) As Sum$
from cryptopunkdata
group by year(day), month(day)
order by year(day), month(day);

#Count how many transactions the wallet "0x1919db36ca2fa2e15f9000fd9cdc2edcf863e685"had over this time period.
Select count(*) from cryptopunkdata
where  buyer_address = "0x1919db36ca2fa2e15f9000fd9cdc2edcf863e685" or seller_address = "0x1919db36ca2fa2e15f9000fd9cdc2edcf863e685";

#Create an “estimated average value calculator” that has a representative price of the collection every day based off of these criteria:
 - Exclude all daily outlier sales where the purchase price is below 10% of the daily average price
 - Take the daily average of remaining transactions
 a) First create a query that will be used as a subquery. Select the event date, the USD price, and the average USD price for each day using a window function. Save it as a temporary table.
 b) Use the table you created in Part A to filter out rows where the USD prices is below 10% of the daily average and return a new estimated value which is just the daily average of the filtered data.
CREATE TEMPORARY TABLE avg_usd_price_per_day AS
SELECT 
utc_timestamp, usd_price, AVG(usd_price) OVER (PARTITION BY DATE(utc_timestamp)) AS daily_avg
FROM cryptopunkdata;

SELECT *, AVG(usd_price) OVER (PARTITION BY DATE(utc_timestamp)) AS new_estimated_value
FROM avg_usd_price_per_day
WHERE usd_price > (0.9 * daily_avg);




