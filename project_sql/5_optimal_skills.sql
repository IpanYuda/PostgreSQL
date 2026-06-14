

WITH demand_skills as (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        count(skills_job_dim.job_id) as demand
    FROM job_postings_fact
    INNER JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
    WHERE 
        job_title_short = 'Data Analyst'
        AND salary_year_avg is NOT NULL
        AND job_work_from_home = true
    GROUP BY skills_dim.skill_id
),  avg_salary as (
    SELECT
        skills_job_dim.skill_id,
        round(avg(salary_year_avg), 0) as salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
    WHERE 
        job_title_short = 'Data Analyst'
        AND salary_year_avg is NOT NULL
        AND job_work_from_home = true
    GROUP BY skills_job_dim.skill_id
)

SELECT
    demand_skills.skill_id,
    demand_skills.skills,
    demand,
    salary
FROM
    demand_skills
INNER JOIN avg_salary on demand_skills.skill_id = avg_salary.skill_id
ORDER BY salary desc,
demand desc