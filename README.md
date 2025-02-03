SuperMart Insights and Growth Report in MySql<br/>

This project aims to analyze SuperMart's key performance indicators (KPIs) across multiple dimensions, including categories, brands, products, and store types, using dynamic datasets. By leveraging advanced data analytics tools like MySQL Workbench and BigQuery, we generate actionable insights to drive business decisions and growth strategies.

Objectives:<br/>
The project is divided into four distinct parts, each focusing on specific temporal and hierarchical perspectives to measure growth and performance.

Part 1: Daily Insights<br/>
Generate daily reports to evaluate SuperMart's performance at different levels of granularity :-

Category Level Report: Analyze metrics such as Orders, GMV, Revenue, Customers, Live Products, and Live Stores for yesterday's data, with growth percentages for each metric.<br/>
Top 20 Brands Report: Identify the top-performing brands (based on GMV) and evaluate key metrics for yesterday's data, including growth trends.<br/>
Top 50 Products Report: Examine the performance of the top products (based on GMV), including their associated brands, to uncover sales and growth patterns for yesterday's data.<br/>
StoreType_Id Report: Assess store-type performance based on Orders, GMV, Revenue, Customers, Live Products, and Live Stores for yesterday's data, including growth comparisons.<br/>

Part 2: Month-To-Date (MTD) Insights<br/>
Track cumulative monthly performance for deeper trend analysis:

Category Level Report: Provide an MTD summary of Orders, GMV, Revenue, Customers, Live Products, and Live Stores, along with growth percentages.<br/>
Top 20 Brands Report: Highlight the top-performing brands for the MTD period, showcasing key metrics and their growth trends.<br/>
Top 50 Products Report: Focus on top product-level performance for the MTD period, including product and brand details.<br/>
StoreType_Id Report: Analyze store-type performance metrics for the MTD period, identifying growth trends.<br/>

Part 3: Last Month-To-Date (LMTD) Insights<br/>
Compare performance trends by analyzing last month's data until the same day as the current period:

Category Level Report: Generate LMTD metrics such as Orders, GMV, Revenue, Customers, Live Products, and Live Stores, with growth percentages.<br/>
Top 20 Brands Report: Evaluate top-performing brands during the LMTD period, highlighting growth trends and sales contributions.<br/>
Top 50 Products Report: Identify leading products based on GMV for the LMTD period, including brand and product details.<br/>
StoreType_Id Report: Assess LMTD store-type performance with key metrics and growth rates.<br/>

Part 4: Last Month (LM) Insights<br/>
Provide a comprehensive analysis of last month's performance to identify recurring trends:

Category Level Report: Summarize LM metrics, including Orders, GMV, Revenue, Customers, Live Products, and Live Stores, with growth comparisons.<br/>
Top 20 Brands Report: Identify the best-performing brands for LM, highlighting their contributions and growth trends.<br/>
Top 50 Products Report: Explore LM performance at the product level, including GMV contributions and associated brand insights.<br/>
StoreType_Id Report: Analyze store-type performance for LM, identifying growth trends and patterns.<br/>

Technical Implementation:<br/>
Data Sources:

order_details_v1: Provides detailed information on customer orders, including product, store, and transactional data.<br/>
product_hierarchy_v1: Contains details on product categories and brands.<br/>
store_cities_v1: Includes store type and location-specific details.<br/>

Dynamic Date Functionality:<br/>
The queries are designed with a dynamic date component to ensure automated reporting for daily, MTD, LMTD, and LM data without manual intervention.

Key Metrics Analyzed:<br/>
Orders: Total count of customer orders.<br/>
GMV: Gross Merchandise Value, reflecting the total value of goods sold.<br/>
Revenue: Net earnings after discounts and refunds.<br/>
Customers: Total number of unique customers.<br/>
Live Products: Count of active products available for purchase.<br/>
Live Stores: Number of operational stores.<br/>
Growth %: Percentage change in performance metrics over comparable timeframes.<br/>

Expected Outcomes:<br/>
Identification of top-performing categories, brands, and products.<br/>
Insights into customer behavior and regional performance trends by store type.<br/>
Automated, dynamic reports for real-time decision-making and long-term planning.<br/>

Enhanced ability to track growth and performance across different timeframes, driving better resource allocation and strategy formulation.<br/>
This project forms the foundation for a data-driven approach to improving retail operations, optimizing inventory, and enhancing customer satisfaction at SuperMart.

Generate the following reports :-<br/>
Category-Level Performance Report<br/>
Generate reports on the following key metrics at the Category Level:<br/>
Orders, GMV, Revenue, Customers, Live Products, and Live Stores<br/>
Data should be extracted for:<br/>
Yesterday, Month-to-Date (MTD), and Last Month (LM)<br/>
Compute Growth % for:<br/>
Yesterday vs. Previous Day<br/>
MTD vs. Last Month MTD<br/>


Top 20 Brands Performance Report<br/>
Identify Top 20 Brands based on GMV and generate reports on:<br/>
Orders, GMV, Revenue, Customers, Live Products, and Live Stores<br/>
Data for Yesterday, MTD, and LM<br/>
Compute Growth % for:<br/>
Yesterday vs. Previous Day<br/>
MTD vs. Last Month MTD<br/>


Top 50 Products Performance Report<br/>
Identify Top 50 Product_Ids based on GMV, including Product Name and Brand<br/>
Generate reports on:<br/>
Orders, GMV, Revenue, Customers, Live Products, and Live Stores<br/>
Data for Yesterday, MTD, and LM<br/>
Compute Growth % for:<br/>
Yesterday vs. Previous Day<br/>
MTD vs. Last Month MTD<br/>


Store-Type Level Performance Report<br/>
Generate insights at the StoreType_Id Level using order_details_v1 and store_cities_v1 datasets:<br/>
Orders, GMV, Revenue, Customers, Live Products, and Live Stores<br/>
Data for Yesterday, MTD, and LM<br/>
Compute Growth % for:<br/>
Yesterday vs. Previous Day<br/>
MTD vs. Last Month MTD<br/>

 
Orders and GMV Range Distribution Report(MTD)<br/>
Generate a distribution report for Orders and GMV based on predefined range segments.<br/>
Format:
"Order Range" "Order Count"  "GMV Range" "GMV Value"
1-5            X              0-500       Y
6-10           X              501-1000    Y

Tools and Platforms:

MySQL Workbench: Used for executing SQL queries and generating reports dynamically.<br/>
Deliverables

Tabular reports with key performance metrics<br/>
Growth percentage analysis for each metric
