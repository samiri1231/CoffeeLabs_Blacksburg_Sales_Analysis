# CoffeeLabs Blacksburg Sales Analysis

A comprehensive data analysis project examining sales performance for CoffeeLabs café in Blacksburg over a one-month period (October 8 - November 9, 2025).

## Project Overview

This project analyzes point-of-sale data from CoffeeLabs to uncover sales trends, customer preferences, and operational insights. The analysis includes data cleaning, SQL queries for business intelligence, and an interactive dashboard for visualization.

## Key Findings

### Revenue Metrics
- **Total Revenue**: $26,164.52
- **Total Sales**: 4,930 transactions
- **Average Order Value**: $5.30

### Top Performing Products
1. **Latte** - 1,014 sales (20.6% of total sales)
2. **Spanish Latte** - 817 sales
3. **Matcha Latte** - 655 sales

### Sales Patterns
- **Peak Hours**: 2 PM (593 sales) and 12 PM (528 sales)
- **Category Breakdown**:
  - Specialty Drinks: 50.57% ($13,230)
  - Regular Drinks: 37.35% ($9,770)
  - Pastries: 8.46% ($2,210)

## Data Cleaning & Transformation

The SQL script performs comprehensive data cleaning:

### Data Quality Improvements
- Removed duplicate entries using `ROW_NUMBER()` window function
- Dropped unnecessary columns (Device Name, Location, Unit, Time Zone, SKU)
- Fixed character encoding issues in column names
- Standardized currency format (removed $, parentheses from negative values)
- Converted data types (strings to DOUBLE for monetary values, TIME for timestamps)
- Trimmed whitespace from item names
- Corrected spelling inconsistencies ("specialy drinks" → "specialty drinks")

### Feature Engineering
- Created `Final Sale` column combining Net Sales and Tax
- Added `Order_id` as primary key for unique transaction identification
- Generated `avg_sales` table for product pricing analysis
- Extracted hour from timestamp for time-based analysis

## SQL Analysis Highlights

### Popular Items Ranking
```sql
WITH times_sold AS (
    SELECT Item, COUNT(*) as Sales
    FROM sales_data
    GROUP BY Item
)
SELECT Item, Sales, 
       RANK() OVER(ORDER BY Sales DESC) as popularity_rank
FROM times_sold;
```

### Peak Sales Hours
```sql
SELECT HOUR(`Time`) AS hour_of_sale,
       COUNT(*) AS num_records
FROM sales_data
GROUP BY hour_of_sale
ORDER BY num_records DESC;
```

### Category Performance
```sql
SELECT Category, COUNT(*) AS types_sold
FROM sales_data
GROUP BY Category
ORDER BY types_sold DESC;
```

## Business Insights

### Product Strategy
- Lattes dominate sales, accounting for specialty varieties making up over 50% of revenue
- Low performers (Choco Fudge Pie, Pour Over Coffee) may need promotional support or menu reconsideration
- Average order value of $5.30 suggests opportunities for upselling

### Operational Insights
- Staffing should prioritize 12 PM - 3 PM window (peak hours)
- Morning rush (7-9 AM) shows moderate traffic (464-476 sales)
- Evening hours (7-11 PM) experience significant decline

### Revenue Opportunities
- Focus on specialty drink innovation (50%+ of revenue)
- Pastry sales (8.46%) represent growth potential
- Consider combo deals during slower hours (evening/late morning)

## Technologies Used

- **Database**: MySQL
- **Data Analysis**: SQL
- **Dashboard**: PowerBI
- **Documentation**: Markdown


## Author

Shiraz Amiri (your friendly neighborhood spiderman) 
BIT | DSS @ Virginia Tech Pamplin College Of Business
linkedin.com/in/shirazamiri

---

*Analysis Period: October 8 - November 9, 2025*
