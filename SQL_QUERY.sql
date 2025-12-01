SHOW DATABASES;
USE `project crm`;

# OPPORTUNITY KPI'S
# Expected Amount
SELECT ROUND(SUM(`Expected Amount`)) AS total_expected_amount
FROM `opportunity table`;

# Active Opportunities
SELECT COUNT(*) AS Active_opportunities
FROM `opportunity table`
WHERE `Probability (%)` NOT IN (0, 100);

# Conversion Rate
SELECT 
  ROUND(
    SUM(Case When `Probability (%)` = 100 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 
    2
  ) AS conversion_rate
FROM `opportunity table`;

# Win Rate
SELECT
  ROUND(
    SUM(CASE WHEN `Probability (%)` = 100 THEN 1 ELSE 0 END) * 100.0 / 
    SUM(CASE WHEN `Probability (%)` in (0, 100) THEN 1 ELSE 0 END), 
    2
  ) AS win_rate
FROM `opportunity table`;

# Loss Rate
SELECT 
  ROUND(
    SUM(CASE WHEN `Probability (%)` = 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 
    2
  ) AS loss_rate
FROM `opportunity table`;

# Trend Analysis

# Expected v/s Forcast
SELECT `Close Year`, SUM(`Forecast Amount`) AS Forecast_Amount, 
ROUND(SUM(`Expected Amount`)) AS Expected_Amount
FROM `opportunity table`
WHERE `Close Year` IS NOT NULL
GROUP BY `Close Year`
ORDER BY `Close Year`;

# Active vs Total Opportunities

SELECT `Close Year`,
  COUNT(*) AS Total_Opportunities,
  SUM(CASE WHEN `Probability (%)` NOT IN (0, 100) THEN 1 ELSE 0 END) AS Active_Opportunities
FROM `opportunity table`
WHERE `Close Year` IS NOT NULL
GROUP BY `Close Year`
ORDER BY `Close Year`;

# Closed Won v/s Total Opportunities
SELECT `Close Year`,
  COUNT(*) AS Total_Opportunities,
  SUM(CASE WHEN `Probability (%)` = 100 THEN 1 ELSE 0 END) AS Closed_Won
FROM `opportunity table`
WHERE `Close Year` IS NOT NULL
GROUP BY `Close Year`
ORDER BY `Close Year`;

# Closed Won v/s Total Closed
SELECT `Close Year`,
  SUM(CASE WHEN `Probability (%)` = 100 THEN 1 ELSE 0 END) AS Closed_Won,
  SUM(CASE WHEN `Probability (%)` IN (0, 100) THEN 1 ELSE 0 END) AS Total_Closed
FROM `opportunity table`
WHERE `Close Year` IS NOT NULL
GROUP BY `Close Year`
ORDER BY `Close Year`;

# Opportunities By Industry 
SELECT `Industry`,
  COUNT(*) AS total_opportunities
FROM `opportunity table`
GROUP BY `Industry`
ORDER BY total_opportunities DESC;

# Expected Amount By Opportunity Type
SELECT `Opportunity Type`,
  SUM(`Expected Amount`) AS tot_expected_amount
FROM `opportunity table`
WHERE `Expected Amount` IS NOT NULL
GROUP BY `Opportunity Type`
ORDER BY tot_expected_amount DESC;

# LEAD KPI'S

# Total Lead
SELECT COUNT(*) AS total_leads
FROM `lead table`;

# Expected Amount from Converted Leads
SELECT 
  (SELECT SUM(`Expected Amount`) FROM `opportunity table`) AS total_expected_amount,
  (SELECT COUNT(*) FROM `lead table` WHERE `Converted` = 'TRUE') AS converted_leads;

# Lead Conversion Rate %
SELECT 
  ROUND(
    SUM(CASE WHEN `Converted` = 'TRUE' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
    2
  ) AS conversion_rate_percent
FROM `lead table`;

# Total Converted Accounts
SELECT 
  COUNT(DISTINCT `Converted Account ID`) AS converted_accounts
FROM `lead table`
WHERE `Converted Account ID` IS NOT NULL;

#Total Converted Opportunities 
SELECT 
  COUNT(DISTINCT `Converted Opportunity ID`) AS converted_opportunities
FROM `lead table`
WHERE `Converted Opportunity ID` IS NOT NULL;

# Leads By Source
SELECT `Lead Source`, 
  COUNT(*) AS total_leads
FROM `lead table`
GROUP BY `Lead Source`
ORDER BY total_leads DESC;

# Leads by Industry
SELECT `Industry`, 
COUNT(*) AS total_leads
FROM `lead table`
GROUP BY `Industry`
ORDER BY total_leads DESC;

# Leads by Stage
SELECT Status, COUNT(*) 
AS Total_Leads 
FROM `lead table`
GROUP BY Status
ORDER BY Total_Leads DESC;