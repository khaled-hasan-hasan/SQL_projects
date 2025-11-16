# SQL Data Analysis Portfolio 📊

**Khaled Hassan** | Data Analyst | Business Intelligence Developer

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue)](https://www.linkedin.com/in/khaled-hasan-abdo)
[![GitHub](https://img.shields.io/badge/GitHub-Follow-black)](https://github.com/khaled-hasan-hasan)
![SQL](https://img.shields.io/badge/SQL-PostgreSQL-blue)
![Status](https://img.shields.io/badge/Status-Active-green)

---

## 👋 About This Repository

This repository contains **SQL data analysis projects** demonstrating advanced querying techniques, data cleaning, aggregations, and business insights generation using **PostgreSQL**.

### Skills Demonstrated
- ✅ Complex SQL queries (JOINs, CTEs, Subqueries, Window Functions)
- ✅ Data validation and cleaning
- ✅ Aggregation and grouping with CUBE, ROLLUP, GROUPING SETS
- ✅ Business intelligence reporting
- ✅ Data exploration and analysis

---

## 📂 Projects

### 1. [Olympics & Sports Data Analysis](./olympics_analysis/)
**Comprehensive analysis of Summer & Winter Olympic Games data**

![Olympics](https://img.shields.io/badge/Dataset-Olympics-gold)
![Athletes](https://img.shields.io/badge/Records-10K+-blue)

**Business Questions Answered:**
- Which sports have the most athletes?
- What's the correlation between GDP and medal performance?
- Which countries have the best medals-per-capita ratio?
- How does BMI vary across different sports?
- Regional analysis of tallest athletes vs GDP

**Key Techniques:**
- Window Functions (ROW_NUMBER, RANK, PARTITION BY)
- Complex JOINs (4+ tables)
- CTEs and Subqueries
- UNION operations
- Data type conversions and validations
- GDP performance indexing

**Tables:** `summer_games`, `winter_games`, `athletes`, `countries`, `country_stats`

📊 **[View Detailed Analysis →](./olympics_analysis/README.md)**

---

### 2. [Movie Rental Business Intelligence](./movie_rental_analysis/)
**Business analytics for a movie streaming platform**

![Movies](https://img.shields.io/badge/Dataset-Movies-red)
![Rentals](https://img.shields.io/badge/Records-5K+-blue)

**Business Questions Answered:**
- What are the most popular movies and genres?
- Which actors generate the highest ratings?
- Customer behavior analysis by country and gender
- Revenue analysis by movie and time period
- Customer segmentation and preferences

**Key Techniques:**
- Aggregations with CUBE, ROLLUP, GROUPING SETS
- Correlated subqueries
- EXISTS and IN operators
- Pivot table analysis
- Customer cohort analysis
- Rating and revenue KPIs

**Tables:** `movies`, `renting`, `customers`, `actors`, `actsin`

📊 **[View Detailed Analysis →](./movie_rental_analysis/README.md)**

---

## 🛠️ Technical Skills

### SQL Concepts
| Category | Skills |
|----------|--------|
| **Query Types** | SELECT, JOIN, UNION, INTERSECT, EXCEPT |
| **Advanced SQL** | CTEs, Window Functions, Subqueries, Correlated Queries |
| **Aggregation** | GROUP BY, HAVING, CUBE, ROLLUP, GROUPING SETS |
| **Functions** | AVG, SUM, COUNT, MIN, MAX, ROW_NUMBER, RANK, PARTITION BY |
| **Data Cleaning** | CAST, COALESCE, TRIM, REPLACE, LEFT, SUBSTRING |
| **Validation** | IS NULL, EXISTS, IN, Data type conversions |

### Database System
- **PostgreSQL** (Primary)
- SQL Server (T-SQL) knowledge

---

## 📈 Sample Queries

### Complex Window Function Example
-- Calculate medals per capita with GDP performance index
SELECT
region,
country,
SUM(gold_medals + silver_medals + bronze_medals) AS total_medals,
SUM(gdp) / SUM(pop_in_millions::FLOAT) AS gdp_per_capita,
-- Performance index comparing to global average
(SUM(gdp) / SUM(pop_in_millions::FLOAT)) /
(SUM(SUM(gdp)) OVER() / SUM(SUM(pop_in_millions::FLOAT)) OVER()) AS performance_index
FROM summer_games s
JOIN countries c ON s.country_id = c.id
JOIN country_stats cs ON c.id = cs.country_id
WHERE cs.year = '2016-01-01'
GROUP BY region, country
ORDER BY performance_index DESC;

text

### Customer Segmentation with Pivot Tables
-- Analyze customer preferences by country and gender using CUBE
SELECT
c.country,
c.gender,
m.genre,
AVG(r.rating) AS avg_rating,
COUNT(*) AS num_rentals
FROM renting r
LEFT JOIN customers c ON r.customer_id = c.customer_id
LEFT JOIN movies m ON r.movie_id = m.movie_id
WHERE r.date_renting >= '2019-01-01'
GROUP BY CUBE(country, gender, genre)
ORDER BY country, gender, avg_rating DESC;

text

---

## 📁 Repository Structure

SQL_projects/
├── README.md # This file
├── olympics_analysis/
│ ├── README.md # Project documentation
│ ├── queries/
│ │ ├── 01_data_exploration.sql
│ │ ├── 02_aggregations.sql
│ │ ├── 03_window_functions.sql
│ │ ├── 04_validation_cleaning.sql
│ │ └── 05_final_reports.sql
│ ├── data/
│ │ ├── ERD_diagram.png
│ │ └── sample_data.csv
│ └── results/
│ └── analysis_outputs.md
│
└── movie_rental_analysis/
├── README.md # Project documentation
├── queries/
│ ├── 01_basic_queries.sql
│ ├── 02_joins_aggregations.sql
│ ├── 03_subqueries.sql
│ ├── 04_olap_analysis.sql
│ └── 05_business_insights.sql
├── data/
│ ├── ERD_diagram.png
│ └── sample_data.csv
└── results/
└── business_reports.md

text

---

## 🎯 Key Insights Delivered

### Olympics Project
- **Top Finding**: Countries with higher GDP per capita don't necessarily win more medals
- **Medals per Million**: Identified top 25 countries by population-adjusted performance
- **BMI Analysis**: Found correlation between athlete BMI and sport type
- **Regional Trends**: Europe and North America dominate in winter sports

### Movie Rental Project
- **Revenue Driver**: Action and Drama genres generate 65% of total revenue
- **Customer Behavior**: Customers aged 30-45 rent 2x more than other age groups
- **Actor Impact**: Top 10 actors drive 40% of high-rating rentals
- **Seasonal Patterns**: Rentals peak during winter months (Nov-Feb)

---

## 🚀 How to Use This Repository

### Prerequisites
- PostgreSQL 12+ (or any SQL database)
- SQL client (pgAdmin, DBeaver, or command line)

### Running the Queries

1. **Clone the repository**
git clone https://github.com/khaled-hasan-hasan/SQL_projects.git
cd SQL_projects

text

2. **Load sample data** (if provided)
psql -U your_username -d your_database -f data/olympics_data.sql

text

3. **Run queries**
psql -U your_username -d your_database -f queries/01_data_exploration.sql

text

Or open in your SQL client and execute.

---

## 📊 Project Metrics

| Metric | Olympics Project | Movie Rental Project |
|--------|------------------|----------------------|
| **Lines of SQL** | 1,200+ | 800+ |
| **Tables Analyzed** | 5 | 5 |
| **Queries Written** | 80+ | 60+ |
| **Business Insights** | 15+ | 12+ |
| **Complexity Level** | Advanced | Intermediate-Advanced |

---

## 📚 Concepts Covered

✅ **Data Exploration**: Understanding table structures and relationships
✅ **Data Cleaning**: Handling NULLs, duplicates, data type issues
✅ **Aggregations**: Grouping data with multiple dimensions
✅ **Window Functions**: Ranking, running totals, moving averages
✅ **Subqueries**: Nested queries for complex filtering
✅ **JOINs**: Combining multiple tables for insights
✅ **OLAP**: CUBE, ROLLUP, GROUPING SETS for pivot analysis
✅ **Performance**: Query optimization and indexing strategies

---

## 🎓 Learning Resources

These projects were built using skills from:
- **DataCamp**: "Exploratory Data Analysis in SQL"
- **LinkedIn Learning**: SQL courses
- **ITI**: Data Analysis training program

---

## 📫 Connect With Me

I'm actively seeking **Data Analyst** and **BI Developer** roles.

- 💼 **LinkedIn**: [Linkedin](https://www.linkedin.com/in/khaled-hasan-abdo)
- 📧 **Email**: [Gmail](khaled.habdo@gmail.com)
- 🌐 **Portfolio**: [Portfolio](https://khaled-hasan-hasan.github.io/))
- 💻 **GitHub**: [Github](https://github.com/khaled-hasan-hasan)

---

## 📜 Certifications

- 🎓 **Google Data Analytics Professional Certificate**
- 🎓 **DataCamp SQL Associate** *(In Progress)*
- 🎓 **Microsoft Power BI (PL-300)** *(In Progress)*
- 🎓 **ITI Power BI Developer Track**

---

## 🔮 Future Enhancements

- [ ] Add Python integration for data visualization
- [ ] Create Power BI dashboards for both projects
- [ ] Add more complex statistical analysis
- [ ] Include machine learning predictions
- [ ] Expand to real-time data analysis

---

## ⭐ If you find this repository helpful, please star it!

---

## 📄 License

This project is for educational and portfolio purposes.

**Last Updated**: November 2025
