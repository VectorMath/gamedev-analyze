# End-to-End Data Analytics Project

## Table of contents

* ### [Introduction](#Introduction)
* ### [Project Components](#Project-Components)
* ### [Technology Stack](#Technology-Stack)
* ### [DAG Dependencies](#DAG-Dependencies)
  * ### [Page "User"](#Page-User)
  * ### [Page "LTV"](#Page-LTV)
  * ### [Page "ARPU vs ARPPU"](#Page-ARPU-vs-ARPPU)
  * ### [Page "Transaction"](#Page-Transaction)
* ### [DWH Architecture](#DWH-Architecture)
  * ### [Stage Layer](#Stage-Layer)
  * ### [Core Layer](#Core-Layer)
  * ### [Mart Layer](#Mart-Layer)
* ### [Project Structure](#project-structure)

## Introduction

This project demonstrates a complete end-to-end data platform designed to support data-driven business decision-making. It covers the entire analytics lifecycle, from data ingestion and transformation to visualization and statistical analysis.

The project showcases modern Data Engineering and Analytics practices by integrating data warehousing, transformation, orchestration, business intelligence, and statistical analysis into a single solution.

## Project Components

* **Data Warehouse (DWH) Development**

  * Design and implementation of a scalable data warehouse architecture.

* **ETL/ELT Pipelines with dbt**

  * Data transformation, modeling, testing, and documentation using dbt.

* **Data Orchestration with Apache Airflow**

  * Automated workflow scheduling and pipeline management.

* **Business Intelligence Dashboards**

  * Development of interactive dashboards and business reports in Power BI.

* **Statistical Analysis**

  * Exploratory data analysis, hypothesis testing, and business insights generation using Jupyter Notebooks.

## Technology Stack

![Technology stack](docs/main_page/stack_tech.png)

* Python
* PostgreSQL
* Docker
* Apache Airflow
* Power BI
* dbt
* Jupyter Notebook

## DAG Dependencies

![dag_depends](docs/main_page/dag_depend.jpg)

## Dashboard screenshots

### Page "User"

![page_user](docs/bi/BI_User.jpg)

This dashboard provides an interactive overview of user behavior, engagement, retention, and monetization metrics. It is designed to help analysts and stakeholders explore the player base across different demographic and geographical segments.

### Page "LTV"

![page_ltv](docs/bi/BI_LTV.jpg)

This dashboard provides an overview of user lifetime value across different time horizons, helping evaluate long-term revenue generation and customer profitability.

### Page "ARPU vs ARPPU"

![page_arpu_arppu](docs/bi/BI_ARPU_ARPPU.jpg)

This dashboard provides a comparative analysis of Average Revenue Per User (ARPU) and Average Revenue Per Paying User (ARPPU) over time. It helps evaluate overall monetization performance and understand the contribution of paying users to total revenue.

### Page "Transaction"

![page_transaction](docs/bi/BI_Transaction.jpg)

This dashboard provides an analytical view of transaction behavior over time, with a focus on how user spending patterns evolve in relation to in-game events and content releases.

## DWH Architecture

The data warehouse is organized into three logical layers: **Stage**, **Core**, and **Mart**.

### Stage Layer

The **Stage** layer stores raw data extracted directly from source systems. This layer serves as the initial landing zone for data ingestion and preserves the original structure of the source data. Minimal transformations are performed at this stage, ensuring data traceability and simplifying debugging processes.

### Core Layer

The **Core** layer contains the primary data transformation and integration logic. Here, raw data is cleaned, validated, standardized, and enriched according to business requirements.

The data model in this layer follows a **Snowflake Schema**, where dimensions are normalized and may reference other dimension tables. This approach reduces data redundancy while maintaining a consistent and scalable analytical model that serves as the single source of truth across the warehouse.

![Core schema](docs/main_page/db_schema.jpg)

### Mart Layer

The **Mart** layer is the presentation layer of the warehouse. It contains denormalized tables and materialized views specifically designed for analytical workloads and reporting.

Datasets in this layer are optimized for fast querying and easy consumption, minimizing the need for complex joins. These business-ready data marts are used as the primary source for BI dashboards, reporting, and statistical analysis.

## Project Structure

* **[dags:](dags)** the folder contains code for data orchestration in Apache Airflow;
* **[dbt:](dbt)** the folder contains code for dbt part of project like models, config files and metadata;
* **[docs:](docs)** the folder with images for documentation in README.md files;
* **[notebook:](notebook)** the folder with Jupyter notebooks for statistical analysis;
* **[Dashboard.pbix:](Dashboard.pbix)** the Microsoft Power BI file that contains BI-report;
