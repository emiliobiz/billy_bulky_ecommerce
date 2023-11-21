# Billy Bulky E-Commerce Data Mart Documentation

## Overview
This documentation provides an overview of the dimensional and fact tables within the `marts` layer of the Billy Bulky e-commerce dbt project. The `marts` layer is designed to hold the transformed and aggregated data ready for analysis and reporting. 

Below is a description of each table within the `marts` schema, outlining their purpose, the type of information they store, and how they are used in the context of the data warehouse.

## Dimensional Tables

### customers
- **Purpose**: To provide a single source of truth for customer-related dimensions.
- **Contents**: Includes customer identifiers, names, emails, join dates, and countries, along with calculated metrics such as total orders and total spend.
- **Usage**: Used in conjunction with fact tables to analyze customer behavior and segmentation.

### products
- **Purpose**: To maintain a detailed view of product dimensions and performance metrics.
- **Contents**: Contains product identifiers, names, categories, prices, and sales metrics like total units sold and total sales value.
- **Usage**: Essential for product performance analysis, inventory management, and sales trend analysis.

## Fact Tables

### sales
- **Purpose**: To record transactional facts about each sale, linking to customer and product dimensions.
- **Contents**: Comprises keys to the `customers` and `products` tables, order quantities, dates, statuses, and calculated sales values.
- **Usage**: Acts as the central table for sales analysis, supporting reporting on sales trends, revenue, and other key business metrics.

## Usage Guidelines

- The tables in the `marts` layer are optimized for analysis and should be used as the primary source for reporting and dashboarding.
- Users should join the fact table with the relevant dimension tables to enrich their analysis and gain detailed insights.
- It is recommended to refer to the model schemas (`_marts_models.yml`) for detailed information on columns and data types.

## Additional Notes

- The `marts` layer tables are refreshed on a scheduled basis to ensure that reports reflect the most up-to-date information.
- Users should be aware of the refresh schedule and data latency when performing time-sensitive analysis.
- For any questions or concerns regarding the data models, please contact the data team (aka, Emilio Biz).

