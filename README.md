# INTRODUCTION 
In this project, I used SQL to analyze global data job market from 2023. The goal was to find the best career trends for data analysts. I focused on finding the highest-paying jobs, discovering which skills companies ask for the most, and where high demand meets high salary in data analytics

SQL queries you can check them here [project_sql folder](/project_sql/)

# BACKGROUND
this data i got from my [SQL COURSE](https://lukebarousse.com/sql). its packed with insight on job titles, salary, location, category, and skills required.

## This Project I want to answer these 4 question
1. What are the top paying data analyst jobs?
2. What skills are required for these top paying jobs?
3. What skills are most in demand for data analyst?
4. Which skills are asociated with higher salaries?

# USED TOOLS
- **SQL** : Language that I used to interaction with databases
- PostgresSQL : Databases that i used to store the data
- Visual Studio Code : Software that i used to execute SQL query
- Git & GitHub: the place for sharing my SQL project and script

# THE ANALYSIS
here is the way i approached for answering those question

### 1. Top Paying Data Analyst Jobs
for searching the highest salary jobs i filtering the jobs focus on Data Analyst, and the location prefer to anywhere so anyone can applied. the result appear must order by the salaries
```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name as company_name
FROM
    job_postings_fact
LEFT JOIN 
    company_dim on job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location ='Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10
```

here is the breakdown
- wide salary range from $184.000 to $650.000 indicate high salary potential in data analyst
- high diversity in job title from data analyst to director of analyst

![Top paying Jobs](assets\Code_Generated_Image.png)
*This bar graph showing top 10 salaries for data analyst, Gemini generated this graph from my SQL result*

### 2. Skills for Top Paying Jobs
the skills are required for the top ten jobs

```sql
WITH top_paying_jobs as (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name as company_name
    FROM
        job_postings_fact
    LEFT JOIN 
        company_dim on job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_location ='Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim on top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY salary_year_avg DESC
```
breakdown:
- SQL has 8 frequently
- followed by python has 7 
- and Tableu with 6
- These are the top 3 skills required for the top paying jobs

![Top Skills Required](assets\Code_Generated_Image1.png)
*This bar graph showing top skills required for data analyst, Gemini generated this graph from my SQL result*

### 3. Skills are the most on demand
i used Inner join the 3 table for getting the most skills on demand
```sql
SELECT 
    skills,
    count(job_postings_fact.job_id) as demand
FROM job_postings_fact
INNER JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst'
GROUP BY skills
ORDER BY demand DESC
LIMIT 5
```
Here's the breakdown of the most demanded skills for data analysts in 2023
- **SQL** and **Excel** remain fundamental, emphasizing the need for strong foundational skills in data processing and spreadsheet manipulation.
- **Programming** and **Visualization Tools** like **Python**, **Tableau**, and **Power BI** are essential, pointing towards the increasing importance of technical skills in data storytelling and decision support.

| Skills   | Demand Count |
|----------|--------------|
| SQL      | 7291         |
| Excel    | 4611         |
| Python   | 4330         |
| Tableau  | 3745         |
| Power BI | 2609         |

*Table of the demand for the top 5 skills in data analyst job postings*

### 4. Skills With The Highes Salaries
The skill-to-salary analysis highlighted the highest-paying capabilities.
```sql
SELECT 
    skills,
    round(avg(salary_year_avg), 0) as salary
FROM job_postings_fact
INNER JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst'
AND salary_year_avg is NOT NULL
GROUP BY skills
ORDER BY salary DESC
LIMIT 5
```

Here's a breakdown of the results for top paying skills for Data Analysts:
- **High Demand for Big Data & ML Skills:** Top salaries are commanded by analysts skilled in big data technologies (PySpark, Couchbase), machine learning tools (DataRobot, Jupyter), and Python libraries (Pandas, NumPy), reflecting the industry's high valuation of data processing and predictive modeling capabilities.
- **Software Development & Deployment Proficiency:** Knowledge in development and deployment tools (GitLab, Kubernetes, Airflow) indicates a lucrative crossover between data analysis and engineering, with a premium on skills that facilitate automation and efficient data pipeline management.
- **Cloud Computing Expertise:** Familiarity with cloud and data engineering tools (Elasticsearch, Databricks, GCP) underscores the growing importance of cloud-based analytics environments, suggesting that cloud proficiency significantly boosts earning potential in data analytics.

| Skills        | Average Salary ($) |
|---------------|-------------------:|
| pyspark       |            208,172 |
| bitbucket     |            189,155 |
| couchbase     |            160,515 |
| watson        |            160,515 |
| datarobot     |            155,486 |
| gitlab        |            154,500 |
| swift         |            153,750 |
| jupyter       |            152,777 |
| pandas        |            151,821 |
| elasticsearch |            145,000 |

*Table of the average salary for the top 10 paying skills for data analysts*

### Insights
From the analysis, several general insights emerged:

1. **Top-Paying Data Analyst Jobs**: The highest-paying jobs for data analysts that allow remote work offer a wide range of salaries, the highest at $650,000!
2. **Skills for Top-Paying Jobs**: High-paying data analyst jobs require advanced proficiency in SQL, suggesting it’s a critical skill for earning a top salary.
3. **Most In-Demand Skills**: SQL is also the most demanded skill in the data analyst job market, thus making it essential for job seekers.
4. **Skills with Higher Salaries**: Specialized skills, such as SVN and Solidity, are associated with the highest average salaries, indicating a premium on niche expertise.
 
 