#SQL Analysis – Finding the Reasons Behind Drop-Off :

CREATE DATABASE customer_dropoff;
use customer_dropoff;

# 3.1 First: Understand the Data:
SELECT *
FROM customer_dropoff
LIMIT 10;

#3.2 Identify Dropped-Off Customers , Let’s define drop-off as customers inactive for 30+ days.
select 
   customer_id,
   days_since_last_activity,
   churned
from customer_dropoff
where days_since_last_activity >= 30;
#Business Meaning
#These are customers already showing danger signals, even if not churned yet.

#3.3 Last Activity Before Drop-Off (KEY INSIGHT)
SELECT
    last_activity,
    COUNT(*) AS dropoff_count
FROM customer_dropoff
WHERE days_since_last_activity >= 30
GROUP BY last_activity
ORDER BY dropoff_count DESC;
/*
What This Tells Business:
* Which user action failed last
* Where to fix UX, support, or funnel
🧠 Example Insight:
“Browsing without purchase is the top drop-off trigger → checkout friction
*/

#3.4 Discount Exposure vs Inactivity (Marketing Gold)
SELECT
    discount_received,
    discount_used,
    COUNT(*) AS customer_count
FROM customer_dropoff
WHERE days_since_last_activity >= 30
GROUP BY discount_received, discount_used
ORDER BY customer_count DESC;
/*
🎯 Business Questions Answered
Are discounts preventing disengagement?
Are users ignoring offers?
🧠 Example Insight:
“Customers receiving discounts but not using them are high-risk disengagers”
*/

#3.5 Discount Impact on Churn
SELECT
    discount_received,
    ROUND(AVG(churned) * 100, 2) AS churn_rate_percent
FROM customer_dropoff
GROUP BY discount_received;
/* 
📊 Business Meaning
Measures ROI of discounts
Helps stop wasteful campaigns
*/

#3.6 Time-Based Drop-Off Patterns (Weekday vs Weekend)
SELECT
    engagement_day,
    COUNT(*) AS dropoff_count
FROM customer_dropoff
WHERE days_since_last_activity >= 30
GROUP BY engagement_day;
/*
🧠 Example Insight:
“Weekend-only users disengage faster → need different content timing”
*/


#3.7 Silent Churn Detection.
# Customers with no complaint but long inactivity:
SELECT
    customer_id,
    days_since_last_activity,
    feedback_comment
FROM customer_dropoff
WHERE days_since_last_activity >= 45
AND feedback_comment IN ('Satisfied', 'Great service');
/*
🔥 Why This Is Powerful
Detects silent dissatisfaction
These users leave without warning
*/

#3.8 Engagement Gap Segmentation (Persona Builder)
SELECT
    CASE
        WHEN days_since_last_activity < 15 THEN 'Active'
        WHEN days_since_last_activity BETWEEN 15 AND 30 THEN 'At Risk'
        ELSE 'Dropped Off'
    END AS engagement_status,
    COUNT(*) AS customer_count
FROM customer_dropoff
GROUP BY engagement_status;
/*
📌 Business Usage:
Retarget At Risk customers
Stop focusing on already lost users
*/

/*
3.9 SQL Summary  : 
“Using SQL, I analyzed customer engagement gaps, last interaction types, discount effectiveness, and time-based patterns to identify 
behavioral and promotional causes of customer drop-off before churn.”
*/









