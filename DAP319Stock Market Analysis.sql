CREATE DATABASE stock;
use stock;
select * from synthetic_stock_data; 

# KPI 1 Average Daily Trading Volume
SELECT AVG(Volume) AS AverageDailyTradingVolume
FROM synthetic_stock_data; -- For all ticker

SELECT Ticker, AVG(Volume) AS AverageDailyTradingVolume
FROM synthetic_stock_data
GROUP BY Ticker; -- For one by one ticker

# KPI 2 Most Volatile Stocks
SELECT Ticker, AVG(Beta) AS HighestBeta
FROM synthetic_stock_data
GROUP BY Ticker
ORDER BY HighestBeta DESC;

# KPI 3 Stocks with Highest Dividend and Lowest Dividend
-- For Highest Divident
SELECT Ticker, SUM(`Dividend Amount`) AS TotalDividend
FROM synthetic_stock_data
GROUP BY Ticker
ORDER BY TotalDividend DESC;

-- For Lowest Dividend
SELECT Ticker, SUM(`Dividend Amount`) AS TotalDividend
FROM synthetic_stock_data
GROUP BY Ticker
ORDER BY TotalDividend ASC;

-- percent Highest Dividend and Lowest Dividend
SELECT 
    Ticker, 
    SUM(`Dividend Amount`) AS TotalDividend,
    SUM(`Dividend Amount`) / (SELECT SUM(`Dividend Amount`) FROM synthetic_stock_data) * 100 AS TotalDividendPercentage
FROM 
    synthetic_stock_data
GROUP BY 
    Ticker
ORDER BY 
    TotalDividend DESC;

# KPI 4 Highest and Lowest P/E Ratios
SELECT 
    Ticker,
    MAX(`PE Ratio`) AS HighestPERatio,
    MIN(`PE Ratio`) AS LowestPERatio
FROM 
    synthetic_stock_data
GROUP BY 
    Ticker
ORDER BY 
    HighestPERatio DESC;

    
# KPI 5 Stocks with Highest Market Cap
select Ticker,
concat(round((sum(`Market Cap`)/1000000000000),2), ' T') as Market_Cap
from synthetic_stock_data
group by Ticker;

# KPI 6 Stocks Near 52 Week High
select Ticker,
max(`52 Week High`)
from synthetic_stock_data
group by Ticker;

# KPI 7 Stocks Near 52 Week Low
select Ticker,
min(`52 Week Low`)
from synthetic_stock_data
group by Ticker;

# KPI 8 Stocks with Strong Buy Signals and stocks with Strong Selling Signal
-- For all Stocks with Strong Buy Signals and stocks with Strong Selling Signal
SELECT 
    Ticker,
    `MACD`,
    `RSI (14 days)`,
    CASE 
        WHEN `MACD` > 0 AND `RSI (14 days)` < 45 THEN 'Strong Buy'
        WHEN `MACD` < 0 AND `RSI (14 days)` >= 69 THEN 'Strong Sell'
    END AS TradeSignal
FROM 
    synthetic_stock_data
WHERE 
    (`MACD` > 0 AND `RSI (14 days)` < 45)
    OR
    (`MACD` < 0 AND `RSI (14 days)` >= 69);

WITH SignalData AS (
    SELECT 
        Ticker,
        `MACD`,
        `RSI (14 days)`,
        CASE 
            WHEN `MACD` > 0 AND `RSI (14 days)` < 45 THEN 'Strong Buy'
            WHEN `MACD` < 0 AND `RSI (14 days)` >= 69 THEN 'Strong Sell'
            ELSE 'Neutral'
        END AS TradeSignal
    FROM 
        synthetic_stock_data
)

SELECT 
    TradeSignal,
    COUNT(Ticker) AS SignalCount
FROM 
    SignalData
WHERE 
    TradeSignal IN ('Strong Buy', 'Strong Sell', 'Neutral')
GROUP BY 
    TradeSignal;


-- For Average of Stocks with Strong Buy Signals and stocks with Strong Selling Signal
SELECT 
    Ticker,
    AVG(`MACD`) AS AvgMACD,
    AVG(`RSI (14 days)`) AS AvgRSI
FROM 
    synthetic_stock_data
GROUP BY 
    Ticker;

# All KPI In one table
SELECT 
    Ticker,
    AVG(`PE Ratio`) AS AvgPERatio,
    MAX(`PE Ratio`) AS MaxPERatio,
    MIN(`PE Ratio`) AS MinPERatio,
    MAX(`Market Cap`) AS MarketCap,
    AVG(`Volume`) AS AvgDailyTradingVolume,
    SUM(`Dividend Amount`) AS TotalDividend,
    SUM(`Dividend Amount`) / (SELECT SUM(`Dividend Amount`) FROM synthetic_stock_data) * 100 AS TotalDividendPercentage,
    AVG(`MACD`) AS AvgMACD,
    AVG(`RSI (14 days)`) AS AvgRSI,
    max(`52 Week High`) AS 52weekhigh,
	min(`52 Week High`) AS 52weeklow
    
FROM 
    synthetic_stock_data
GROUP BY 
    Ticker;
    


# extra analysis
WITH SignalData AS (
    SELECT 
        Ticker,
        `MACD`,
        `RSI (14 days)`,
        CASE 
            WHEN `MACD` > 0 AND `RSI (14 days)` < 45 THEN 'Strong Buy'
            WHEN `MACD` < 0 AND `RSI (14 days)` >= 69 THEN 'Strong Sell'
            ELSE 'Neutral'
        END AS TradeSignal
    FROM 
        synthetic_stock_data
)

SELECT 
    Ticker,
    TradeSignal,
    COUNT(Ticker) AS SignalCount
FROM 
    SignalData
WHERE 
    TradeSignal IN ('Strong Buy', 'Strong Sell', 'Neutral')
GROUP BY 
    Ticker, TradeSignal;
