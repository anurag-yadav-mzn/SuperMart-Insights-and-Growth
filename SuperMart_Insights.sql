use supermart;
-- Daily Insights for Category Level Report

-- Set dynamic dates
SET @yesterday = DATE_SUB(CURDATE(), INTERVAL 1 DAY);
SET @two_days_ago = DATE_SUB(CURDATE(), INTERVAL 2 DAY);

SELECT 
    ph.category,
    COUNT(DISTINCT od.order_id) AS orders_yesterday,
    SUM(od.selling_price) AS gmv_yesterday,
    SUM(od.selling_price) * 0.9 AS revenue_yesterday, -- Assuming 10% cost deduction
    COUNT(DISTINCT od.customer_id) AS customers_yesterday,
    COUNT(DISTINCT od.product_id) AS live_products_yesterday,
    COUNT(DISTINCT od.store_id) AS live_stores_yesterday,
    ((COUNT(DISTINCT CASE WHEN od.order_date = @yesterday THEN od.order_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.order_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.order_id END), 0)) * 100 AS orders_growth_percent,
    ((SUM(CASE WHEN od.order_date = @yesterday THEN od.selling_price END) - 
      SUM(CASE WHEN od.order_date = @two_days_ago THEN od.selling_price END))
     / NULLIF(SUM(CASE WHEN od.order_date = @two_days_ago THEN od.selling_price END), 0)) * 100 AS gmv_growth_percent,
    ((SUM(CASE WHEN od.order_date = @yesterday THEN od.selling_price END) * 0.9 - 
      SUM(CASE WHEN od.order_date = @two_days_ago THEN od.selling_price END) * 0.9)
     / NULLIF(SUM(CASE WHEN od.order_date = @two_days_ago THEN od.selling_price END) * 0.9, 0)) * 100 AS revenue_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date = @yesterday THEN od.customer_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.customer_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.customer_id END), 0)) * 100 AS customers_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date = @yesterday THEN od.product_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.product_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.product_id END), 0)) * 100 AS live_products_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date = @yesterday THEN od.store_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.store_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.store_id END), 0)) * 100 AS live_stores_growth_percent

FROM 
    order_details  od
JOIN 
    product_hierarchy  ph
    ON od.product_id = ph.product_id
JOIN 
    store_cities  sc
    ON od.store_id = sc.store_id
WHERE 
    od.order_date IN (@yesterday, @two_days_ago)
GROUP BY 
    ph.category;
    
-- Daily Insights for Top 20 Brands Report
SELECT 
    ph.brand,
    COUNT(DISTINCT od.order_id) AS orders_yesterday,
    SUM(od.selling_price) AS gmv_yesterday,
    SUM(od.selling_price) * 0.9 AS revenue_yesterday, 
    COUNT(DISTINCT od.customer_id) AS customers_yesterday,
    COUNT(DISTINCT od.product_id) AS live_products_yesterday,
    COUNT(DISTINCT od.store_id) AS live_stores_yesterday,
    ((COUNT(DISTINCT CASE WHEN od.order_date = @yesterday THEN od.order_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.order_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.order_id END), 0)) * 100 AS orders_growth_percent,
    ((SUM(CASE WHEN od.order_date = @yesterday THEN od.selling_price END) - 
      SUM(CASE WHEN od.order_date = @two_days_ago THEN od.selling_price END))
     / NULLIF(SUM(CASE WHEN od.order_date = @two_days_ago THEN od.selling_price END), 0)) * 100 AS gmv_growth_percent,
    ((SUM(CASE WHEN od.order_date = @yesterday THEN od.selling_price END) * 0.9 - 
      SUM(CASE WHEN od.order_date = @two_days_ago THEN od.selling_price END) * 0.9)
     / NULLIF(SUM(CASE WHEN od.order_date = @two_days_ago THEN od.selling_price END) * 0.9, 0)) * 100 AS revenue_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date = @yesterday THEN od.customer_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.customer_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.customer_id END), 0)) * 100 AS customers_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date = @yesterday THEN od.product_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.product_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.product_id END), 0)) * 100 AS live_products_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date = @yesterday THEN od.store_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.store_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.store_id END), 0)) * 100 AS live_stores_growth_percent

FROM 
    order_details  od
JOIN 
    product_hierarchy  ph
    ON od.product_id = ph.product_id
WHERE 
    od.order_date IN (@yesterday, @two_days_ago)
GROUP BY 
    ph.brand
ORDER BY 
    gmv_yesterday DESC
LIMIT 20;

-- Daily Insights for Top 50 Products Report
SELECT 
    od.product_id,
    ph.product,
    ph.brand,
    COUNT(DISTINCT od.order_id) AS orders_yesterday,
    SUM(od.selling_price) AS gmv_yesterday,
    SUM(od.selling_price) * 0.9 AS revenue_yesterday, 
    COUNT(DISTINCT od.customer_id) AS customers_yesterday,
    COUNT(DISTINCT od.product_id) AS live_products_yesterday,
    COUNT(DISTINCT od.store_id) AS live_stores_yesterday,
    ((COUNT(DISTINCT CASE WHEN od.order_date = @yesterday THEN od.order_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.order_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.order_id END), 0)) * 100 AS orders_growth_percent,
    ((SUM(CASE WHEN od.order_date = @yesterday THEN od.selling_price END) - 
      SUM(CASE WHEN od.order_date = @two_days_ago THEN od.selling_price END))
     / NULLIF(SUM(CASE WHEN od.order_date = @two_days_ago THEN od.selling_price END), 0)) * 100 AS gmv_growth_percent,
    ((SUM(CASE WHEN od.order_date = @yesterday THEN od.selling_price END) * 0.9 - 
      SUM(CASE WHEN od.order_date = @two_days_ago THEN od.selling_price END) * 0.9)
     / NULLIF(SUM(CASE WHEN od.order_date = @two_days_ago THEN od.selling_price END) * 0.9, 0)) * 100 AS revenue_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date = @yesterday THEN od.customer_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.customer_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.customer_id END), 0)) * 100 AS customers_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date = @yesterday THEN od.product_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.product_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.product_id END), 0)) * 100 AS live_products_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date = @yesterday THEN od.store_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.store_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.store_id END), 0)) * 100 AS live_stores_growth_percent

FROM 
    order_details  od
JOIN 
    product_hierarchy  ph
    ON od.product_id = ph.product_id
WHERE 
    od.order_date IN (@yesterday, @two_days_ago)
GROUP BY 
    od.product_id, ph.product, ph.brand
ORDER BY 
    gmv_yesterday DESC
LIMIT 50;

-- Daily Insights for StoreType_Id Report
SELECT 
    sc.storetype_id,
    COUNT(DISTINCT od.order_id) AS orders_yesterday,
    SUM(od.selling_price) AS gmv_yesterday,
    SUM(od.selling_price) * 0.9 AS revenue_yesterday, 
    COUNT(DISTINCT od.customer_id) AS customers_yesterday,
    COUNT(DISTINCT od.product_id) AS live_products_yesterday,
    COUNT(DISTINCT od.store_id) AS live_stores_yesterday,
    ((COUNT(DISTINCT CASE WHEN od.order_date = @yesterday THEN od.order_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.order_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.order_id END), 0)) * 100 AS orders_growth_percent,
    ((SUM(CASE WHEN od.order_date = @yesterday THEN od.selling_price END) - 
      SUM(CASE WHEN od.order_date = @two_days_ago THEN od.selling_price END))
     / NULLIF(SUM(CASE WHEN od.order_date = @two_days_ago THEN od.selling_price END), 0)) * 100 AS gmv_growth_percent,
    ((SUM(CASE WHEN od.order_date = @yesterday THEN od.selling_price END) * 0.9 - 
      SUM(CASE WHEN od.order_date = @two_days_ago THEN od.selling_price END) * 0.9)
     / NULLIF(SUM(CASE WHEN od.order_date = @two_days_ago THEN od.selling_price END) * 0.9, 0)) * 100 AS revenue_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date = @yesterday THEN od.customer_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.customer_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.customer_id END), 0)) * 100 AS customers_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date = @yesterday THEN od.product_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.product_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.product_id END), 0)) * 100 AS live_products_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date = @yesterday THEN od.store_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.store_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.store_id END), 0)) * 100 AS live_stores_growth_percent

FROM 
    order_details  od
JOIN 
    store_cities  sc
    ON od.store_id = sc.store_id
WHERE 
    od.order_date IN (@yesterday, @two_days_ago)
GROUP BY 
    sc.storetype_id
ORDER BY 
    gmv_yesterday DESC;
    
-- Month-To-Date (MTD) Insights for Category Level Report

-- Set dynamic dates
SET @start_of_month = DATE_FORMAT(CURDATE(), '%Y-%m-01');
SET @start_of_last_month = DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-01');
SET @end_of_last_month = LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH));

SELECT 
    ph.category,
    COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.order_id END) AS orders_mtd,
    SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) AS gmv_mtd,
    SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) * 0.9 AS revenue_mtd, 
    COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.customer_id END) AS customers_mtd,
    COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.product_id END) AS live_products_mtd,
    COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.store_id END) AS live_stores_mtd,
    ((COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.order_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.order_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.order_id END), 0)) * 100 AS orders_growth_percent,
    ((SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) - 
      SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END))
     / NULLIF(SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END), 0)) * 100 AS gmv_growth_percent,
    ((SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) * 0.9 - 
      SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END) * 0.9)
     / NULLIF(SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END) * 0.9, 0)) * 100 AS revenue_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.customer_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.customer_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.customer_id END), 0)) * 100 AS customers_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.product_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.product_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.product_id END), 0)) * 100 AS live_products_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.store_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.store_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.store_id END), 0)) * 100 AS live_stores_growth_percent

FROM 
    order_details  od
JOIN 
    product_hierarchy  ph
    ON od.product_id = ph.product_id
WHERE 
    od.order_date >= @start_of_last_month
GROUP BY 
    ph.category
ORDER BY 
    gmv_mtd DESC;
    
-- Month-To-Date (MTD) Insights for Top 20 Brands Report
SELECT 
    ph.brand,
    COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.order_id END) AS orders_mtd,
    SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) AS gmv_mtd,
    SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) * 0.9 AS revenue_mtd, 
    COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.customer_id END) AS customers_mtd,
    COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.product_id END) AS live_products_mtd,
    COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.store_id END) AS live_stores_mtd,
    ((COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.order_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.order_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.order_id END), 0)) * 100 AS orders_growth_percent,
    ((SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) - 
      SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END))
     / NULLIF(SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END), 0)) * 100 AS gmv_growth_percent,
    ((SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) * 0.9 - 
      SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END) * 0.9)
     / NULLIF(SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END) * 0.9, 0)) * 100 AS revenue_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.customer_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.customer_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.customer_id END), 0)) * 100 AS customers_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.product_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.product_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.product_id END), 0)) * 100 AS live_products_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.store_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.store_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.store_id END), 0)) * 100 AS live_stores_growth_percent

FROM 
    order_details  od
JOIN 
    product_hierarchy  ph
    ON od.product_id = ph.product_id
WHERE 
    od.order_date >= @start_of_last_month
GROUP BY 
    ph.brand
ORDER BY 
    gmv_mtd DESC
LIMIT 20;

-- Month-To-Date (MTD) Insights for Top 50 Products Report
SELECT 
    od.product_id,
    ph.product,
    ph.brand,
    COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.order_id END) AS orders_mtd,
    SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) AS gmv_mtd,
    SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) * 0.9 AS revenue_mtd, 
    COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.customer_id END) AS customers_mtd,
    COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.product_id END) AS live_products_mtd,
    COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.store_id END) AS live_stores_mtd,
    ((COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.order_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.order_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.order_id END), 0)) * 100 AS orders_growth_percent,
    ((SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) - 
      SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END))
     / NULLIF(SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END), 0)) * 100 AS gmv_growth_percent,
    ((SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) * 0.9 - 
      SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END) * 0.9)
     / NULLIF(SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END) * 0.9, 0)) * 100 AS revenue_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.customer_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.customer_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.customer_id END), 0)) * 100 AS customers_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.product_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.product_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.product_id END), 0)) * 100 AS live_products_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.store_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.store_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.store_id END), 0)) * 100 AS live_stores_growth_percent

FROM 
    order_details  od
JOIN 
    product_hierarchy  ph
    ON od.product_id = ph.product_id
WHERE 
    od.order_date >= @start_of_last_month
GROUP BY 
    od.product_id, ph.product, ph.brand
ORDER BY 
    gmv_mtd DESC
LIMIT 50;

-- Month-To-Date (MTD) Insights for StoreType_Id Report
SELECT 
    sc.storetype_id,
    COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.order_id END) AS orders_mtd,
    SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) AS gmv_mtd,
    SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) * 0.9 AS revenue_mtd, 
    COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.customer_id END) AS customers_mtd,
    COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.product_id END) AS live_products_mtd,
    COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.store_id END) AS live_stores_mtd,
    ((COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.order_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.order_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.order_id END), 0)) * 100 AS orders_growth_percent,
    ((SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) - 
      SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END))
     / NULLIF(SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END), 0)) * 100 AS gmv_growth_percent,
    ((SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) * 0.9 - 
      SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END) * 0.9)
     / NULLIF(SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END) * 0.9, 0)) * 100 AS revenue_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.customer_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.customer_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.customer_id END), 0)) * 100 AS customers_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.product_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.product_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.product_id END), 0)) * 100 AS live_products_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.store_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.store_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.store_id END), 0)) * 100 AS live_stores_growth_percent

FROM 
    order_details  od
JOIN 
    store_cities  sc
    ON od.store_id = sc.store_id
WHERE 
    od.order_date >= @start_of_last_month
GROUP BY 
    sc.storetype_id
ORDER BY 
    gmv_mtd DESC;

-- Last Month-To-Date (LMTD) Insights for Category Level Report

-- Set dynamic dates
SET @start_of_same_period_last_month = DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-%d');
SET @end_of_same_period_last_month = DATE_SUB(CURDATE(), INTERVAL 1 MONTH);
SELECT 
    ph.category,
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.order_id END) AS orders_lmtd,
    SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.selling_price END) AS gmv_lmtd,
    SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.selling_price END) * 0.9 AS revenue_lmtd, 
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.customer_id END) AS customers_lmtd,
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.product_id END) AS live_products_lmtd,
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.store_id END) AS live_stores_lmtd,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.order_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= DATE_FORMAT(CURDATE(), '%Y-%m-01') THEN od.order_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= DATE_FORMAT(CURDATE(), '%Y-%m-01') THEN od.order_id END), 0)) * 100 AS orders_growth_percent,
    ((SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.selling_price END) - 
      SUM(CASE WHEN od.order_date >= DATE_FORMAT(CURDATE(), '%Y-%m-01') THEN od.selling_price END))
     / NULLIF(SUM(CASE WHEN od.order_date >= DATE_FORMAT(CURDATE(), '%Y-%m-01') THEN od.selling_price END), 0)) * 100 AS gmv_growth_percent,
    ((SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.selling_price END) * 0.9 - 
      SUM(CASE WHEN od.order_date >= DATE_FORMAT(CURDATE(), '%Y-%m-01') THEN od.selling_price END) * 0.9)
     / NULLIF(SUM(CASE WHEN od.order_date >= DATE_FORMAT(CURDATE(), '%Y-%m-01') THEN od.selling_price END) * 0.9, 0)) * 100 AS revenue_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.customer_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= DATE_FORMAT(CURDATE(), '%Y-%m-01') THEN od.customer_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= DATE_FORMAT(CURDATE(), '%Y-%m-01') THEN od.customer_id END), 0)) * 100 AS customers_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.product_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= DATE_FORMAT(CURDATE(), '%Y-%m-01') THEN od.product_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= DATE_FORMAT(CURDATE(), '%Y-%m-01') THEN od.product_id END), 0)) * 100 AS live_products_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.store_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= DATE_FORMAT(CURDATE(), '%Y-%m-01') THEN od.store_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= DATE_FORMAT(CURDATE(), '%Y-%m-01') THEN od.store_id END), 0)) * 100 AS live_stores_growth_percent

FROM 
    order_details  od
JOIN 
    product_hierarchy  ph
    ON od.product_id = ph.product_id
WHERE 
    od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month
GROUP BY 
    ph.category
ORDER BY 
    gmv_lmtd DESC;
    
-- Last Month-To-Date (LMTD) Insights for Top 20 Brands Report
SELECT 
    ph.brand,
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.order_id END) AS orders_lmtd,
    SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.selling_price END) AS gmv_lmtd,
    SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.selling_price END) * 0.9 AS revenue_lmtd,
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.customer_id END) AS customers_lmtd,
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.product_id END) AS live_products_lmtd,
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.store_id END) AS live_stores_lmtd,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.order_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.order_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.order_id END), 0)) * 100 AS orders_growth_percent,
    ((SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.selling_price END) - 
      SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END))
     / NULLIF(SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END), 0)) * 100 AS gmv_growth_percent,
    ((SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.selling_price END) * 0.9 - 
      SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) * 0.9)
     / NULLIF(SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) * 0.9, 0)) * 100 AS revenue_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.customer_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.customer_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.customer_id END), 0)) * 100 AS customers_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.product_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.product_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.product_id END), 0)) * 100 AS live_products_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.store_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.store_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.store_id END), 0)) * 100 AS live_stores_growth_percent

FROM 
    order_details  od
JOIN 
    product_hierarchy  ph
    ON od.product_id = ph.product_id
WHERE 
    od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month
GROUP BY 
    ph.brand
ORDER BY 
    gmv_lmtd DESC
LIMIT 20;

-- Last Month-To-Date (LMTD) Insights for Top 50 Products Report
SELECT 
    od.product_id,
    ph.product,
    ph.brand,
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.order_id END) AS orders_lmtd,
    SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.selling_price END) AS gmv_lmtd,
    SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.selling_price END) * 0.9 AS revenue_lmtd, 
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.customer_id END) AS customers_lmtd,
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.product_id END) AS live_products_lmtd,
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.store_id END) AS live_stores_lmtd,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.order_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.order_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.order_id END), 0)) * 100 AS orders_growth_percent,
    ((SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.selling_price END) - 
      SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END))
     / NULLIF(SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END), 0)) * 100 AS gmv_growth_percent,
    ((SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.selling_price END) * 0.9 - 
      SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) * 0.9)
     / NULLIF(SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) * 0.9, 0)) * 100 AS revenue_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.customer_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.customer_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.customer_id END), 0)) * 100 AS customers_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.product_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.product_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.product_id END), 0)) * 100 AS live_products_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.store_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.store_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.store_id END), 0)) * 100 AS live_stores_growth_percent

FROM 
    order_details  od
JOIN 
    product_hierarchy  ph
    ON od.product_id = ph.product_id
WHERE 
    od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month
GROUP BY 
    od.product_id, ph.product, ph.brand
ORDER BY 
    gmv_lmtd DESC
LIMIT 50;

--  Last Month-To-Date (LMTD) Insights for StoreType_Id Report
SELECT 
    sc.storetype_id,
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.order_id END) AS orders_lmtd,
    SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.selling_price END) AS gmv_lmtd,
    SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.selling_price END) * 0.9 AS revenue_lmtd, 
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.customer_id END) AS customers_lmtd,
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.product_id END) AS live_products_lmtd,
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.store_id END) AS live_stores_lmtd,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.order_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.order_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.order_id END), 0)) * 100 AS orders_growth_percent,
    ((SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.selling_price END) - 
      SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END))
     / NULLIF(SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END), 0)) * 100 AS gmv_growth_percent,
    ((SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.selling_price END) * 0.9 - 
      SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) * 0.9)
     / NULLIF(SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) * 0.9, 0)) * 100 AS revenue_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.customer_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.customer_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.customer_id END), 0)) * 100 AS customers_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.product_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.product_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.product_id END), 0)) * 100 AS live_products_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.store_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.store_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.store_id END), 0)) * 100 AS live_stores_growth_percent

FROM 
    order_details  od
JOIN 
    store_cities  sc
    ON od.store_id = sc.store_id
WHERE 
    od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month
GROUP BY 
    sc.storetype_id
ORDER BY 
    gmv_lmtd DESC;
    
-- Last Month (LM) Insights for Category Level Report

SELECT 
    ph.category,
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.order_id END) AS orders_lm,
    SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END) AS gmv_lm,
    SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END) * 0.9 AS revenue_lm, 
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.customer_id END) AS customers_lm,
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.product_id END) AS live_products_lm,
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.store_id END) AS live_stores_lm,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.order_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.order_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.order_id END), 0)) * 100 AS orders_growth_percent,
    ((SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END) - 
      SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END))
     / NULLIF(SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END), 0)) * 100 AS gmv_growth_percent,
    ((SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END) * 0.9 - 
      SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) * 0.9)
     / NULLIF(SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) * 0.9, 0)) * 100 AS revenue_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.customer_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.customer_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.customer_id END), 0)) * 100 AS customers_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.product_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.product_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.product_id END), 0)) * 100 AS live_products_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.store_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.store_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.store_id END), 0)) * 100 AS live_stores_growth_percent

FROM 
    order_details  od
JOIN 
    product_hierarchy  ph
    ON od.product_id = ph.product_id
WHERE 
    od.order_date BETWEEN @start_of_last_month AND @end_of_last_month
GROUP BY 
    ph.category
ORDER BY 
    gmv_lm DESC;
    
-- Last Month (LM) Insights for Top 20 Brands Report
SELECT 
    ph.brand,
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.order_id END) AS orders_lm,
    SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END) AS gmv_lm,
    SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END) * 0.9 AS revenue_lm, 
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.customer_id END) AS customers_lm,
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.product_id END) AS live_products_lm,
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.store_id END) AS live_stores_lm,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.order_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.order_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.order_id END), 0)) * 100 AS orders_growth_percent,
    ((SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END) - 
      SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END))
     / NULLIF(SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END), 0)) * 100 AS gmv_growth_percent,
    ((SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END) * 0.9 - 
      SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) * 0.9)
     / NULLIF(SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) * 0.9, 0)) * 100 AS revenue_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.customer_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.customer_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.customer_id END), 0)) * 100 AS customers_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.product_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.product_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.product_id END), 0)) * 100 AS live_products_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.store_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.store_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.store_id END), 0)) * 100 AS live_stores_growth_percent

FROM 
    order_details  od
JOIN 
    product_hierarchy  ph
    ON od.product_id = ph.product_id
WHERE 
    od.order_date BETWEEN @start_of_last_month AND @end_of_last_month
GROUP BY 
    ph.brand
ORDER BY 
    gmv_lm DESC
LIMIT 20;

-- Last Month (LM) Insights for Top 50 Products Report
SELECT 
    od.product_id,
    ph.product,
    ph.brand,
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.order_id END) AS orders_lm,
    SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END) AS gmv_lm,
    SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END) * 0.9 AS revenue_lm, 
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.customer_id END) AS customers_lm,
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.product_id END) AS live_products_lm,
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.store_id END) AS live_stores_lm,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.order_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.order_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.order_id END), 0)) * 100 AS orders_growth_percent,
    ((SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END) - 
      SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END))
     / NULLIF(SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END), 0)) * 100 AS gmv_growth_percent,
    ((SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END) * 0.9 - 
      SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) * 0.9)
     / NULLIF(SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) * 0.9, 0)) * 100 AS revenue_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.customer_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.customer_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.customer_id END), 0)) * 100 AS customers_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.product_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.product_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.product_id END), 0)) * 100 AS live_products_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.store_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.store_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.store_id END), 0)) * 100 AS live_stores_growth_percent

FROM 
    order_details  od
JOIN 
    product_hierarchy  ph
    ON od.product_id = ph.product_id
WHERE 
    od.order_date BETWEEN @start_of_last_month AND @end_of_last_month
GROUP BY 
    od.product_id, ph.product, ph.brand
ORDER BY 
    gmv_lm DESC
LIMIT 50;

-- Last Month (LM) Insights for StoreType_Id Report
SELECT 
    sc.storetype_id,
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.order_id END) AS orders_lm,
    SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END) AS gmv_lm,
    SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END) * 0.9 AS revenue_lm, 
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.customer_id END) AS customers_lm,
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.product_id END) AS live_products_lm,
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.store_id END) AS live_stores_lm,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.order_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.order_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.order_id END), 0)) * 100 AS orders_growth_percent,
    ((SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END) - 
      SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END))
     / NULLIF(SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END), 0)) * 100 AS gmv_growth_percent,
    ((SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END) * 0.9 - 
      SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) * 0.9)
     / NULLIF(SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) * 0.9, 0)) * 100 AS revenue_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.customer_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.customer_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.customer_id END), 0)) * 100 AS customers_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.product_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.product_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.product_id END), 0)) * 100 AS live_products_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.store_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.store_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.store_id END), 0)) * 100 AS live_stores_growth_percent

FROM 
    order_details  od
JOIN 
    store_cities  sc
    ON od.store_id = sc.store_id
WHERE 
    od.order_date BETWEEN @start_of_last_month AND @end_of_last_month
GROUP BY 
    sc.storetype_id
ORDER BY 
    gmv_lm DESC;
    
-- Category-Level Performance Report
WITH category_performance AS (
    SELECT 
        p.category,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(o.selling_price) AS GMV,
        COUNT(DISTINCT o.customer_id) AS unique_customers,
        COUNT(DISTINCT o.product_id) AS live_products,
        COUNT(DISTINCT o.store_id) AS live_stores,
        DATE(o.order_date) AS order_date
    FROM order_details o
    JOIN product_hierarchy p ON o.product_id = p.product_id
    WHERE o.order_date >= DATE_SUB(CURDATE(), INTERVAL 60 DAY)
    GROUP BY p.category, DATE(o.order_date)
)
SELECT 
    category,
    SUM(CASE WHEN order_date = CURDATE() - INTERVAL 1 DAY THEN total_orders END) AS orders_yesterday,
    SUM(CASE WHEN order_date = CURDATE() - INTERVAL 2 DAY THEN total_orders END) AS orders_previous_day,
    (SUM(CASE WHEN order_date = CURDATE() - INTERVAL 1 DAY THEN total_orders END) -
     SUM(CASE WHEN order_date = CURDATE() - INTERVAL 2 DAY THEN total_orders END)) /
     NULLIF(SUM(CASE WHEN order_date = CURDATE() - INTERVAL 2 DAY THEN total_orders END), 0) * 100 AS growth_orders_yesterday,
    
    SUM(CASE WHEN MONTH(order_date) = MONTH(CURDATE()) THEN total_orders END) AS orders_MTD,
    SUM(CASE WHEN MONTH(order_date) = MONTH(CURDATE() - INTERVAL 1 MONTH) THEN total_orders END) AS orders_last_month,
    (SUM(CASE WHEN MONTH(order_date) = MONTH(CURDATE()) THEN total_orders END) -
     SUM(CASE WHEN MONTH(order_date) = MONTH(CURDATE() - INTERVAL 1 MONTH) THEN total_orders END)) /
     NULLIF(SUM(CASE WHEN MONTH(order_date) = MONTH(CURDATE() - INTERVAL 1 MONTH) THEN total_orders END), 0) * 100 AS growth_orders_MTD
FROM category_performance
GROUP BY category;

-- Top 20 Brands Performance Report
WITH brand_performance AS (
    SELECT 
        p.brand,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(o.selling_price) AS GMV,
        COUNT(DISTINCT o.customer_id) AS unique_customers,
        COUNT(DISTINCT o.product_id) AS live_products,
        COUNT(DISTINCT o.store_id) AS live_stores,
        DATE(o.order_date) AS order_date
    FROM order_details o
    JOIN product_hierarchy p ON o.product_id = p.product_id
    WHERE o.order_date >= DATE_SUB(CURDATE(), INTERVAL 60 DAY)
    GROUP BY p.brand, DATE(o.order_date)
)
SELECT 
    brand,
    SUM(CASE WHEN order_date = CURDATE() - INTERVAL 1 DAY THEN total_orders END) AS orders_yesterday,
    SUM(CASE WHEN order_date = CURDATE() - INTERVAL 2 DAY THEN total_orders END) AS orders_previous_day,
    (SUM(CASE WHEN order_date = CURDATE() - INTERVAL 1 DAY THEN total_orders END) -
     SUM(CASE WHEN order_date = CURDATE() - INTERVAL 2 DAY THEN total_orders END)) /
     NULLIF(SUM(CASE WHEN order_date = CURDATE() - INTERVAL 2 DAY THEN total_orders END), 0) * 100 AS growth_orders_yesterday,
    
    SUM(CASE WHEN MONTH(order_date) = MONTH(CURDATE()) THEN total_orders END) AS orders_MTD,
    SUM(CASE WHEN MONTH(order_date) = MONTH(CURDATE() - INTERVAL 1 MONTH) THEN total_orders END) AS orders_last_month,
    (SUM(CASE WHEN MONTH(order_date) = MONTH(CURDATE()) THEN total_orders END) -
     SUM(CASE WHEN MONTH(order_date) = MONTH(CURDATE() - INTERVAL 1 MONTH) THEN total_orders END)) /
     NULLIF(SUM(CASE WHEN MONTH(order_date) = MONTH(CURDATE() - INTERVAL 1 MONTH) THEN total_orders END), 0) * 100 AS growth_orders_MTD,
    SUM(GMV) AS total_GMV
FROM brand_performance
GROUP BY brand
ORDER BY total_GMV DESC
LIMIT 20;

-- Top 50 Products Performance Report
WITH product_performance AS (
    SELECT 
        p.product_id,
        p.product,
        p.brand,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(o.selling_price) AS GMV,
        COUNT(DISTINCT o.customer_id) AS unique_customers,
        COUNT(DISTINCT o.product_id) AS live_products,
        COUNT(DISTINCT o.store_id) AS live_stores,
        DATE(o.order_date) AS order_date
    FROM order_details o
    JOIN product_hierarchy p ON o.product_id = p.product_id
    WHERE o.order_date >= DATE_SUB(CURDATE(), INTERVAL 60 DAY)
    GROUP BY p.product_id, p.product, p.brand, DATE(o.order_date)
)
SELECT 
    product_id,
    product,
    brand,
    SUM(CASE WHEN order_date = CURDATE() - INTERVAL 1 DAY THEN total_orders END) AS orders_yesterday,
    SUM(CASE WHEN order_date = CURDATE() - INTERVAL 2 DAY THEN total_orders END) AS orders_previous_day,
    (SUM(CASE WHEN order_date = CURDATE() - INTERVAL 1 DAY THEN total_orders END) -
     SUM(CASE WHEN order_date = CURDATE() - INTERVAL 2 DAY THEN total_orders END)) /
     NULLIF(SUM(CASE WHEN order_date = CURDATE() - INTERVAL 2 DAY THEN total_orders END), 0) * 100 AS growth_orders_yesterday,
    
    SUM(CASE WHEN MONTH(order_date) = MONTH(CURDATE()) THEN total_orders END) AS orders_MTD,
    SUM(CASE WHEN MONTH(order_date) = MONTH(CURDATE() - INTERVAL 1 MONTH) THEN total_orders END) AS orders_last_month,
    (SUM(CASE WHEN MONTH(order_date) = MONTH(CURDATE()) THEN total_orders END) -
     SUM(CASE WHEN MONTH(order_date) = MONTH(CURDATE() - INTERVAL 1 MONTH) THEN total_orders END)) /
     NULLIF(SUM(CASE WHEN MONTH(order_date) = MONTH(CURDATE() - INTERVAL 1 MONTH) THEN total_orders END), 0) * 100 AS growth_orders_MTD,
    SUM(GMV) AS total_GMV
FROM product_performance
GROUP BY product_id, product, brand
ORDER BY total_GMV DESC
LIMIT 50;

-- Store-Type Level Performance Report
WITH store_type_performance AS (
    SELECT 
        s.storetype_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(o.selling_price) AS GMV,
        COUNT(DISTINCT o.customer_id) AS unique_customers,
        COUNT(DISTINCT o.product_id) AS live_products,
        COUNT(DISTINCT o.store_id) AS live_stores,
        DATE(o.order_date) AS order_date
    FROM order_details o
    JOIN store_cities s ON o.store_id = s.store_id
    WHERE o.order_date >= DATE_SUB(CURDATE(), INTERVAL 60 DAY)
    GROUP BY s.storetype_id, DATE(o.order_date)
)
SELECT 
    storetype_id,
    SUM(CASE WHEN order_date = CURDATE() - INTERVAL 1 DAY THEN total_orders END) AS orders_yesterday,
    SUM(CASE WHEN order_date = CURDATE() - INTERVAL 2 DAY THEN total_orders END) AS orders_previous_day,
    (SUM(CASE WHEN order_date = CURDATE() - INTERVAL 1 DAY THEN total_orders END) -
     SUM(CASE WHEN order_date = CURDATE() - INTERVAL 2 DAY THEN total_orders END)) /
     NULLIF(SUM(CASE WHEN order_date = CURDATE() - INTERVAL 2 DAY THEN total_orders END), 0) * 100 AS growth_orders_yesterday,
    
    SUM(CASE WHEN MONTH(order_date) = MONTH(CURDATE()) THEN total_orders END) AS orders_MTD,
    SUM(CASE WHEN MONTH(order_date) = MONTH(CURDATE() - INTERVAL 1 MONTH) THEN total_orders END) AS orders_last_month,
    (SUM(CASE WHEN MONTH(order_date) = MONTH(CURDATE()) THEN total_orders END) -
     SUM(CASE WHEN MONTH(order_date) = MONTH(CURDATE() - INTERVAL 1 MONTH) THEN total_orders END)) /
     NULLIF(SUM(CASE WHEN MONTH(order_date) = MONTH(CURDATE() - INTERVAL 1 MONTH) THEN total_orders END), 0) * 100 AS growth_orders_MTD,
    SUM(GMV) AS total_GMV
FROM store_type_performance
GROUP BY storetype_id
ORDER BY total_GMV DESC;


-- Orders and GMV Range Distribution (MTD) Report
WITH BrandProductCounts AS (
  SELECT 
    brand,
    COUNT(product_id) AS product_count,
    CASE 
      WHEN COUNT(product_id) BETWEEN 1 AND 5 THEN '1-5'
      WHEN COUNT(product_id) BETWEEN 6 AND 10 THEN '6-10'
      ELSE '10+' 
    END AS `Product Range`
  FROM product_hierarchy
  GROUP BY brand
),
VolumeCalculation AS (
  SELECT 
    product_id,
    (COALESCE(CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(length, ' x ', 1), ' x ', -1) AS DECIMAL(10,2)), 1) *
     COALESCE(CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(length, ' x ', 2), ' x ', -1) AS DECIMAL(10,2)), 1) *
     COALESCE(CAST(SUBSTRING_INDEX(length, ' x ', -1) AS DECIMAL(10,2)), 1)) AS volume
  FROM product_hierarchy
),
ProductDistribution AS (
  SELECT 
    CASE 
      WHEN volume BETWEEN 0 AND 500 THEN '0-500'
      WHEN volume BETWEEN 501 AND 1000 THEN '501-1000'
      ELSE '1000+' 
    END AS `Volume Range`,
    COUNT(product_id) AS `Product Count`,
    SUM(volume) AS `Total Volume`
  FROM VolumeCalculation
  GROUP BY `Volume Range`
)

SELECT 
  bpc.`Product Range`,
  COUNT(bpc.brand) AS `Brand Count`,
  SUM(bpc.product_count) AS `Total Products`,
  pd.`Volume Range`,
  pd.`Product Count`,
  pd.`Total Volume`
FROM BrandProductCounts bpc
CROSS JOIN ProductDistribution pd
GROUP BY bpc.`Product Range`, pd.`Volume Range`
ORDER BY bpc.`Product Range`, pd.`Volume Range`;





