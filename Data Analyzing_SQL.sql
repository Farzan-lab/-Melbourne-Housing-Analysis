SELECT FORMAT_DATE('%B', date) as monthly_sale , sum(Price)as total_price
FROM `plucky-sight-484704-a4.Mel_houses.Houses`
group by monthly_sale
order by total_price desc;

select Distance as distance_km ,round(avg(Price),2) as average_price, count(Price) as num_of_deals
FROM `plucky-sight-484704-a4.Mel_houses.Houses`
group by Distance
order by avg(Price) desc;


/* Step 1: Calculate global metrics for the entire dataset 
   (Combining both calculations into one CTE is more efficient)
*/
WITH city_stats AS (
    SELECT 
        ROUND(AVG(Price), 2) AS global_avg_price,
        COUNT(Price) AS global_total_deals
    FROM `plucky-sight-484704-a4.Mel_houses.Houses`
)
/* Step 2: Aggregate data by suburb and compare with global metrics */
SELECT 
    suburb, 
    COUNT(Price) AS suburb_deals, 
    round(AVG(Price),3) AS average_price
FROM `plucky-sight-484704-a4.Mel_houses.Houses`
CROSS JOIN city_stats -- Allows comparing each suburb to the city's total/average
GROUP BY suburb, global_avg_price, global_total_deals
HAVING 
    /* IMPORTANT: We use HAVING instead of WHERE 
       because we are filtering based on aggregated results (AVG/COUNT)
    */
    AVG(Price) < global_avg_price 
    AND COUNT(Price) > (global_total_deals * 0.01) -- Example: suburb must have > 1% of total deals
order by avg(Price) desc;


select sellerG, sum(price)
from `plucky-sight-484704-a4.Mel_houses.Houses`
group by sellerG 
order by sum(price) desc;


SELECT 
  SellerG, 
  COUNT(*) as Total_Sales, 
  ROUND(AVG(Price), 2) as Avg_Sales_Price
from `plucky-sight-484704-a4.Mel_houses.Houses`
GROUP BY SellerG
HAVING COUNT(*) > 50 -- only active sellers
ORDER BY Avg_Sales_Price desc
LIMIT 10;


