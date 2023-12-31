# Billy Bulky E-Commerce Data Project

<p align="center">
  <img src="https://github.com/emiliobiz/billy_bulky_ecommerce/assets/151553891/1c62ea9f-ea39-468c-92e7-457d43869360" width="200" alt="billy_bulky"/>
</p>

## Context

In the competitive field of e-commerce, data-driven decision-making is key to understanding customer behavior, optimizing inventory, and tracking sales performance. The Billy Bulky project leverages a modern data stack to transform raw e-commerce data into actionable insights through a sophisticated dbt implementation.

## Data Generation

Dummy data has been generated based on previous knowledge of Shopify's API to simulate a realistic e-commerce environment. We utilized the Python library Faker in combination with Numpy and Pandas to generate three core tables that represent customers, orders, and products. This synthetic dataset allows us to demonstrate the dbt project's capabilities without exposing sensitive real-world data.

- [Customers](https://github.com/emiliobiz/billy_bulky_ecommerce/files/13427002/customers.csv)
- [Orders](https://github.com/emiliobiz/billy_bulky_ecommerce/files/13427003/orders.csv)
- [Products](https://github.com/emiliobiz/billy_bulky_ecommerce/files/13427004/products.csv)

## Objective

The objective of this project is to demonstrate a robust data transformation layer using dbt (data build tool) to model e-commerce data for a fictional company, Billy Bulky. The aim is to showcase advanced skills in data analysis, data modeling, and expertise in the utilization of dbt Core features within a Snowflake data warehousing environment.

## Project Structure

The project is structured into three primary dbt modeling layers, each serving a distinct purpose in the transformation pipeline:

- **Staging Layer (`/staging`):** Raw data from source systems is lightly transformed for consistency and cleanliness.
- **Intermediate Layer (`/intermediate`):** More complex transformations are applied, such as customer segmentation and product performance metrics.
- **Marts Layer (`/marts`):** Final transformations produce the dimensional models and fact tables optimized for analytics and BI tool consumption.

## Models and Metrics

- **Customer Segmentation (`int_customers_segmentation`):** Metrics and purchase patterns provide insights into customer behavior.
- **Product Performance (`int_products_performance`):** Aggregates product data to calculate sales performance, inventory turnover, and profitability.
- **Sales Trends (`int_sales_trends`):** Analyzes sales data over time to discern trends and seasonal patterns.
- **Sales Table:** Centralizes sales data, linking customers and products to record transactional facts.
- **Customers Table:** Centralizes customers data, based on the `int_customers_segmentation` intermediate model.
- **Products Table:** Centralizes products data, based on the `int_products_performance` intermediate model.

## dbt Features and Data Practices

- **Seeds:** Added a static CSV seed file with employees references.
- **Variables:** Employed to handle environment-specific configurations, enabling flexibility in deployment across different environments (e.g: `vip_spending_threshold`).
- **Materializations:** Strategically used `ephemeral`, `table`, and `view` materializations to balance query performance and storage efficiency.
- **Snapshots:** Captured historical changes to data, such as product prices, to track and analyze over time.
- **Layering and Naming Conventions:** Adhered to industry-standard practices for clear organization and readability based on dbt best practices.
- **Macros:** Generate schema name to overwrite the default dbt schema.

## Tools Leveraged

- **Snowflake:** Efficient storage and compute power to query large volumes of e-commerce data.
- **dbt Core:** Utilized for running transformations, testing data integrity, documenting the data models, and compiling the project.
- **SQL:** The primary language for data modeling and transformation within dbt.
- **Jinja & Python:** Languages used for macros and dbt-specific syntaxes.
- **Git:** For version control and collaboration, ensuring best practices in code maintenance and deployment.

## Best Practices

Throughout the project, we have adhered to several best practices:

- **DRY Principle:** Ensuring that our SQL code is not repetitive by using dbt's ref() function to reference models.
- **Modular Design:** Each model is built to be independent, ensuring changes can be made with minimal impact on other models.
- **Version Control:** All changes are tracked through git and pushed to a Github repository.
- **Testing and Documentation:** Each model includes tests for data integrity and is well-documented for clarity and maintainability.

## Setup and Configuration

The project's setup involves configuration files such as `dbt_project.yml`, which defines the project structure and model materialization strategies, and `.yml` files in each model directory for documentation and testing configurations.

## Conclusion

This project represents a comprehensive approach to e-commerce data analysis, with a focus on scalability, maintainability, and the delivery of valuable business insights. It serves as a testament to the capabilities of dbt and modern data practices in the field of analytics engineering.

## Metabase

We can visualize our models using the open-source visualization tool Metabase. To open a Metabase instance, ensure that Docker is installed on your system and the Docker daemon is running. Then, execute the following commands in your terminal:

- docker pull metabase/metabase:latest
- docker run -d -p 3000:3000 --name metabase metabase/metabase

After running these commands, open your web browser and navigate to http://localhost:3000 to access the Metabase setup wizard. Proceed to configure your instance by connecting it to Snowflake with the appropriate credentials. Once configured, you can start creating dashboards and visualizations for your useful metrics directly from the Snowflake data warehouse.

**Two examples to Automate Billy Bulky's e-commerce reporting:**

<img width="1416" alt="Screenshot 2023-11-21 at 14 35 02" src="https://github.com/emiliobiz/billy_bulky_ecommerce/assets/151553891/f97013aa-21e8-473a-b5f4-e9f9507a887a">

<img width="1402" alt="Screenshot 2023-11-21 at 14 35 15" src="https://github.com/emiliobiz/billy_bulky_ecommerce/assets/151553891/64d786ca-67a9-4ffe-ac33-4aa2595f4637">

