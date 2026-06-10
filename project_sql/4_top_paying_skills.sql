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