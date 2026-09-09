# 📊 CASE FILE 002 — PRHR-II

## HR Analytics — Employee Performance & Workforce Analysis

> **An end-to-end HR Analytics project built using Excel, MySQL, Python and Power BI to transform raw HR data into meaningful workforce and employee-performance insights.**

---

## 🔎 Project Overview

**PRHR-II** is the second project in my data analytics portfolio.

The project focuses on analyzing employee information, workforce structure, employee actions, tenure and performance using a complete data analytics workflow.

Instead of jumping directly into visualization, the project follows a structured process:

**Data Understanding → Data Quality & Cleaning → SQL Business Analysis → EDA & Deep Analysis → Power BI → Final Report**

The project was designed to demonstrate how a data analyst can take raw data and gradually transform it into business-ready insights.

---

# 🎯 Business Objective

The main objective was to understand the organization's workforce and employee-performance patterns and answer practical HR-related questions such as:

* How is the workforce distributed across departments?
* What is the current workforce structure?
* How many employees are active and terminated?
* What is the average employee tenure?
* How is employee performance distributed?
* What patterns can be identified from employee actions?
* What workforce and performance patterns deserve further investigation?

---

# 🔄 End-to-End Project Workflow

```text
                    RAW HR DATA
                         │
                         ▼
              ┌─────────────────────┐
              │       EXCEL         │
              │ Data Understanding  │
              │ & Initial Inspection│
              └──────────┬──────────┘
                         │
                         ▼
              ┌─────────────────────┐
              │       MySQL         │
              │ Data Quality &      │
              │ Data Cleaning       │
              └──────────┬──────────┘
                         │
                         ▼
              ┌─────────────────────┐
              │       MySQL         │
              │ SQL Business        │
              │     Analysis        │
              └──────────┬──────────┘
                         │
                         ▼
              ┌─────────────────────┐
              │      PYTHON         │
              │ EDA & Deep Analysis │
              └──────────┬──────────┘
                         │
                         ▼
              ┌─────────────────────┐
              │     POWER BI        │
              │ Dashboard & KPIs    │
              └──────────┬──────────┘
                         │
                         ▼
              ┌─────────────────────┐
              │    FINAL REPORT     │
              │ Insights & Findings │
              └──────────┬──────────┘
                         │
                         ▼
              ┌─────────────────────┐
              │      GITHUB         │
              │ Portfolio Project   │
              └─────────────────────┘
```

---

# 1️⃣ Data Understanding — Excel

The project started with **Excel**, where the raw HR datasets were initially examined and understood.

The purpose of this phase was to understand:

* Dataset structure
* Available tables and columns
* Data types
* Important HR attributes
* Employee-related fields
* Performance-related fields
* Potential data-quality issues
* Relationships between datasets

This phase established the foundation for the subsequent MySQL analysis.

---

# 2️⃣ Data Quality & Cleaning — MySQL

After understanding the datasets, the data was imported into **MySQL** for systematic data-quality checks and cleaning.

The main tables used were:

```text
tbl_employee
tbl_action
tbl_perf
```

### Data Quality Checks

The cleaning process covered:

### Completeness

Identifying missing values across important fields.

### Duplicates

Checking for duplicate records and potential duplication issues.

### Validity

Checking whether values followed expected rules and logical conditions.

### Consistency

Checking whether related values were consistent across the datasets.

### Relationships

Validating relationships between Employee, Action and Performance tables.

---

## 🛠️ Data Import & Technical Issues

During the MySQL stage, several real-world data problems were encountered and resolved, including:

* Incorrect dataset/file imported initially
* CSV import issues
* `local_infile` configuration
* `secure_file_priv` restrictions
* `LOAD DATA LOCAL INFILE` errors
* BOM/header-related issues
* Incorrect data-type/value errors
* Table and record-count inconsistencies

These issues were investigated and resolved as part of the data preparation process.

This made the project closer to a real-world analytics workflow rather than working with an already-perfect dataset.

---

# 3️⃣ SQL Business Analysis — MySQL

Once the data was cleaned and validated, the project moved into **SQL Business Analysis**.

The goal was to turn cleaned data into answers to business questions.

### Analysis Areas

* Employee distribution by department
* Workforce analysis
* Active vs. terminated employees
* Average employee tenure
* Employee performance analysis
* Employee action analysis
* Time/date-based analysis
* Aggregations and KPI calculations
* Cross-table analysis

SQL was used not just to retrieve data, but to answer **business-oriented questions**.

---

# 4️⃣ EDA & Deep Analysis — Python

After the SQL business analysis, **Python was introduced for Exploratory Data Analysis (EDA) and deeper statistical investigation.**

Python was used to explore patterns that were better suited to programmatic and statistical analysis.

### Python Analysis Included

* Dataset-level exploration
* Data profiling
* Unique-value analysis
* Statistical summaries
* Distribution analysis
* Deeper investigation of employee attributes
* Validation of findings from previous analysis

The final cleaned dataset contained:

| Dataset     | Records |
| ----------- | ------: |
| Employee    |   1,562 |
| Action      |   2,586 |
| Performance |   9,605 |

### Example: Employee Level Analysis

The `Level` variable was statistically examined.

* **Mean:** 14.57
* **Standard Deviation:** 7.63
* **Q1:** 8
* **Q3:** 21
* **IQR:** 13

This helped provide a deeper understanding of the distribution of employee levels.

---

# ⚠️ Important Data Limitation — PayRate

During the data analysis process, an important issue was identified with the `PayRate` field.

The field contained **no usable values** across the employee dataset.

Therefore, compensation-related analysis was intentionally excluded.

The project does **not** make assumptions about missing salary information.

Excluded analysis included:

* Salary analysis
* Compensation comparison
* Pay equity analysis
* Salary vs. performance
* Compensation-based KPIs

This was treated as a genuine data limitation discovered during analysis.

---

# 5️⃣ Power BI — Dashboard & Visualization

After completing the SQL analysis and Python EDA, the data was brought into **Power BI**.

The objective was to convert analytical findings into an interactive HR dashboard.

### Dashboard Focus

The dashboard covers areas such as:

* Workforce KPIs
* Employee distribution
* Department analysis
* Active vs. terminated workforce
* Average tenure
* Employee performance
* Workforce demographics
* HR-related patterns

The dashboard contains **9 major visual/KPI components** designed around the project's business questions.

---

# 6️⃣ Final Report

The complete project was documented in a final business report.

The report brings together:

* Project background
* Business objectives
* Dataset understanding
* Data-quality process
* Cleaning methodology
* SQL analysis
* Python EDA
* Power BI dashboard
* Key findings
* Data limitations
* Business insights
* Conclusion

The report documents the project from the initial raw data stage through the final analytical output.

---

# 📁 Repository Structure

```text
CASE-FILE-002-PRHR-II
│
├── 01_Business_Understanding
│
├── 02_Data
│   ├── Raw
│   └── Cleaned
│
├── 03_SQL
│   └── PRHR_II_HR_Analysis.sql
│
├── 04_Python
│   └── PRHR_II_Data_Analysis.py
│
├── 05_Power_BI
│   ├── PRHR_II.pbix
│   ├── Screenshots
│   └── PDF
│
├── 06_Business_Report
│   └── PRHR_II_Final_Report.pdf
│
└── README.md
```

---

# 🛠️ Tools & Technologies

| Tool                | Purpose                                        |
| ------------------- | ---------------------------------------------- |
| **Excel**           | Data understanding & initial inspection        |
| **MySQL**           | Data quality, cleaning & SQL business analysis |
| **Python / Pandas** | EDA & deep analysis                            |
| **Power BI**        | Data modeling, DAX, KPIs & dashboard           |
| **GitHub**          | Project documentation & portfolio              |

---

# 💡 Key Skills Demonstrated

### Data Analytics

* Data Understanding
* Data Cleaning
* Data Quality Assessment
* Exploratory Data Analysis
* Statistical Analysis
* Business Analysis
* Insight Generation

### SQL

* Data Validation
* Aggregations
* Joins
* Conditional Logic
* Date Functions
* Relational Data Modeling
* Business KPI Analysis

### Python

* Pandas
* EDA
* Statistical Analysis
* Data Profiling
* Data Validation
* Deeper Pattern Analysis

### Power BI

* Data Modeling
* DAX
* KPI Development
* Interactive Visualizations
* Dashboard Design
* Business Storytelling

---

# 🚀 Project Outcome

PRHR-II demonstrates a complete data analytics lifecycle:

> **Understand the data → Clean the data → Analyze the business → Explore deeper with Python → Visualize the findings → Communicate insights.**

The project also demonstrates an important analytical principle:

> **Good analysis begins with good data understanding and validation—not with the dashboard.**

---

## 📌 Project Information

**Project:** PRHR-II — CASE FILE 002
**Domain:** Human Resources Analytics
**Focus:** Workforce & Employee Performance Analysis
**Tools:** Excel | MySQL | Python | Power BI
**Project Type:** Data Analytics Portfolio Project

---

## 👤 Author

**Suraj Ringne**

Data Analytics Portfolio
**SQL | Python | Power BI | Excel**
