# 1.TOTAL REVENUE
SELECT
    SUM(revenue_realized) AS Total_Revenue
FROM fact_bookings;

# 2.OCCUPANCY RATE
SELECT
    ROUND(
        (SUM(successful_bookings) / SUM(capacity)) * 100,
        2
    ) AS Occupancy_Rate
FROM fact_aggregated_bookings;

# 3.CANCELLATION RATE
SELECT
    ROUND(
        (COUNT(CASE WHEN booking_status='Cancelled' THEN 1 END)
        / COUNT(*)) * 100,
        2
    ) AS Cancellation_Rate
FROM fact_bookings;

# 4.TOTAL BBOOKINGS
SELECT
    COUNT(booking_id) AS Total_Bookings
FROM fact_bookings;

# 5.UTILIZED CAPACITY
SELECT
    SUM(successful_bookings) AS Utilized_Capacity
FROM fact_aggregated_bookings;

# 6.TREND ANAALYSIS
SELECT
YEAR(STR_TO_DATE(check_in_date,'%Y-%m-%d %H:%i:%s')) AS Year,
MONTH(STR_TO_DATE(check_in_date,'%Y-%m-%d %H:%i:%s')) AS Month,
SUM(revenue_realized) AS Revenue
FROM fact_bookings
WHERE booking_status='Checked Out'
GROUP BY Year, Month
ORDER BY Year, Month;

# 7.WEEKDAY V/S WEEKENDS
SELECT
CASE
WHEN DAYOFWEEK(STR_TO_DATE(check_in_date,'%Y-%m-%d %H:%i:%s')) IN (1,7)
THEN 'Weekend'
ELSE 'Weekday'
END AS Day_Type,
COUNT(*) AS Total_Bookings,
SUM(revenue_realized) AS Revenue
FROM fact_bookings
WHERE booking_status='Checked Out'
GROUP BY Day_Type;

# 8.REVENUE BY STATE & CITY
SELECT
    h.city,
    h.property_name,
    SUM(f.revenue_realized) AS Total_Revenue
FROM fact_bookings f
JOIN dim_hotels h
ON f.property_id = h.property_id
WHERE f.booking_status = 'Checked Out'
GROUP BY h.city, h.property_name
ORDER BY Total_Revenue DESC;

# 9.CLASS WISE REVENUE
SELECT
    r.room_class,
    SUM(f.revenue_realized) AS Total_Revenue
FROM fact_bookings f
JOIN dim_rooms r
ON f.room_category = r.room_id
WHERE f.booking_status = 'Checked Out'
GROUP BY r.room_class
ORDER BY Total_Revenue DESC;

# 10.BOOKING STATUS
SELECT
booking_status,
COUNT(*) AS Total_Bookings,
SUM(revenue_realized) AS Revenue
FROM fact_bookings
GROUP BY booking_status;

# 11.WEEKLY TREND

SELECT
    WEEK(STR_TO_DATE(a.check_in_date,'%d-%b-%y')) AS Week,
    SUM(a.successful_bookings) AS Total_Bookings,
    SUM(f.revenue_realized) AS Revenue,
    ROUND(
        SUM(a.successful_bookings) * 100.0 / SUM(a.capacity),
        2
    ) AS Occupancy_Rate
FROM fact_aggregated_bookings a
JOIN fact_bookings f
ON a.property_id = f.property_id
AND STR_TO_DATE(a.check_in_date,'%d-%b-%y') =
    DATE(f.check_in_date)
GROUP BY WEEK(STR_TO_DATE(a.check_in_date,'%d-%b-%y'))
ORDER BY Week;

SELECT COUNT(*) FROM fact_bookings;








