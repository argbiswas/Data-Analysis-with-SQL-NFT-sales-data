create database crypto;
use crypto;
Select * from cryptopunkdata;

Select count(transaction_hash) as Sales from cryptopunkdata;

SELECT name, eth_price, usd_price, utc_timestamp as date
FROM cryptopunkdata
ORDER BY usd_price DESC
LIMIT 5;

Select transaction_hash, usd_price, 
avg(usd_price) over(order by day rows between 49 preceding and current row) as moving_avg_usd 
from cryptopunkdata;

select name, avg(usd_price) as Average_price from cryptopunkdata 
group by name
order by Average_price Desc; 

Select Concat (name, " was sold for $ ", round (usd_price,-3), " to ", 
" from ", seller_address, " on ", day) as Summary from cryptopunkdata;

select dayofweek(day) as Days, count(*) as Count, avg (eth_price) as Average
from cryptopunkdata
group by dayofweek(day) 
order by count(*);

CREATE VIEW 1919_purchases AS
    SELECT * FROM cryptopunkdata
    WHERE buyer_address = '0x1919db36ca2fa2e15f9000fd9cdc2edcf863e685';
    
SELECT ROUND(eth_price, -2)  AS bucket, 
COUNT(*) AS count,
RPAD('', COUNT(*), '*') AS bar 
FROM cryptopunkdata
GROUP BY bucket
ORDER BY bucket;

Select name, max(eth_price), 'Highest' as Status
from cryptopunkdata
group by name
Union
Select name, min(eth_price), 'Lowest' as Status
from cryptopunkdata
group by name
order by name;

Select year(day) as Year, month(day) as Month, Round(sum(usd_price),-2) As Sum$
from cryptopunkdata
group by year(day), month(day)
order by year(day), month(day);

Select count(*) from cryptopunkdata
where  buyer_address = "0x1919db36ca2fa2e15f9000fd9cdc2edcf863e685" or seller_address = "0x1919db36ca2fa2e15f9000fd9cdc2edcf863e685";

CREATE TEMPORARY TABLE avg_usd_price_per_day AS
SELECT 
utc_timestamp, usd_price, AVG(usd_price) OVER (PARTITION BY DATE(utc_timestamp)) AS daily_avg
FROM cryptopunkdata;

SELECT *, AVG(usd_price) OVER (PARTITION BY DATE(utc_timestamp)) AS new_estimated_value
FROM avg_usd_price_per_day
WHERE usd_price > (0.9 * daily_avg);




