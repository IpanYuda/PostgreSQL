SELECT *
FROM company_dim
LIMIT 10;

SELECT *
FROM job_postings_fact
LIMIT 10;

SELECT *
FROM skills_dim
LIMIT 10;

SELECT *
FROM skills_job_dim
LIMIT 10;

SELECT
    job_title_short AS title,
    job_location as location,
    job_posted_date :: DATE as date   -- Mengubah type data menjadi DATE
FROM
    job_postings_fact;

SELECT
    job_title_short AS title,
    job_location as location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time   -- Mengubah sistem waktu UTC menjadi EST 
FROM
    job_postings_fact
LIMIT 5;


SELECT
    job_title_short AS title,
    job_location as location,
    job_posted_date :: DATE as date,   -- Mengubah type data menjadi DATE
    EXTRACT(MONTH FROM job_posted_date) AS date_month, --EXTRACT dogunakan untuk mengambil informasi yang diinginkan
    EXTRACT(YEAR FROM job_posted_date) AS date_year
FROM
    job_postings_fact
LIMIT 5;

SELECT
    COUNT(job_id) as job_posted_count,      -- hitung total job id
    EXTRACT(MONTH FROM job_posted_date) as date_month   -- ambil data bulan
FROM
    job_postings_fact
WHERE
    job_title_short ='Data Analyst' -- total job id yang dihitung hanya yang berjudul Data Analyst
GROUP BY
    date_month  --kelompokkan data berdasarkan bulannya
ORDER BY
    job_posted_count DESC;

--Mengumpulkan jumlah lowongan job data analyst  di setiap bulannya

SELECT 
    job_id,
    EXTRACT(MONTH FROM job_posted_date) as date_month,
    EXTRACT(YEAR FROM job_posted_date) as date_year
FROM job_postings_fact
--WHERE date_month > 5
LIMIT 10;

SELECT
    job_schedule_type,
    avg(salary_year_avg),
    avg(salary_hour_avg)
FROM
    job_postings_fact
WHERE
    job_posted_date > '2023-06-01'
GROUP BY
    job_schedule_type;


CREATE TABLE january_jobs as
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

CREATE TABLE february_jobs as
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

CREATE TABLE march_jobs as
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3;
    
SELECT
    COUNT(job_id),
    CASE 
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS job_location_category
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    job_location_category;


SELECT 
     avg(salary_year_avg), Min (salary_year_avg), max(salary_year_avg)
FROM job_postings_fact;

SELECT
    job_title_short,
    job_location,
    job_schedule_type,
    salary_year_avg,
    CASE
        WHEN salary_year_avg > 120000 THEN 'high'
        WHEN salary_year_avg < 120000 THEN 'low'
        ELSE 'Standar'
    END as salary_category
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst' and
    salary_year_avg is not NULL
ORDER BY
    salary_year_avg DESC;

-- SUBQUERIES AND CTE

SELECT
    company_id,
    name as company_name
FROM
    company_dim
WHERE company_id in (

        SELECT
            company_id
        FROM
            job_postings_fact
        WHERE
            job_no_degree_mention = true
        ORDER BY
            company_id
)

-- CTE

WITH company_jobs_count as (
    SELECT
            company_id,
            COUNT(*) as total_jobs
    FROM
            job_postings_fact
    GROUP BY
            company_id
) 

SELECT
    name as company_name,
    company_jobs_count.total_jobs
FROM
    company_dim
LEFT JOIN company_jobs_count on company_jobs_count.company_id = company_dim.company_id
ORDER BY total_jobs DESC;


/* identify the top 5 skills that are most frequently mentioned
in job postings. use a subquery to  find the skill IDs with
with the highest counts in the skill_job_dim table and then join
this result with the skills_dim table to get the skill names */


SELECT*
FROM skills_job_dim
LIMIT 10;


WITH skills_most as (
    SELECT 
        skill_id,
        COUNT (job_id) as job_count
    FROM
        skills_job_dim
    GROUP BY
        skill_id
    ORDER BY job_count DESC
)

SELECT
    skills,
    skills_most.job_count
FROM
    skills_dim
LEFT JOIN skills_most on skills_most.skill_id = skills_dim.skill_id

SELECT *
FROM job_postings_fact
LIMIT 10


WITH the_most_skills as (
SELECT
skill_id, COUNT(skill_id) AS skill_count
FROM skills_job_dim
inner join job_postings_fact on job_postings_fact.job_id = skills_job_dim.job_id
WHERE job_work_from_home = True
GROUP BY skill_id
)

SELECT
skills_dim.skill_id, skills, skill_count
FROM
skills_dim
inner join the_most_skills on the_most_skills.skill_id = skills_dim.skill_id


--UNION AND UNION ALL
/* UNION
Operator UNION digunakan untuk menggabungkan beberapa tabel 
dan menghapus semua baris yang duplikat. Jadi, hasil akhir 
yang Anda dapatkan hanya berisi baris-baris yang unik.

UNION ALL
Operator UNION ALL digunakan untuk menggabungkan beberapa 
tabel dan tetap mempertahankan semua baris, termasuk baris 
yang duplikat.*/

SELECT 
job_title_short, job_id, job_location
FROM january_jobs

UNION

SELECT 
job_title_short, job_id, job_location
FROM february_jobs;

SELECT 
    job_title_short,
    salary_year_avg
FROM (
    SELECT *
    from january_jobs
    UNION ALL
    SELECT *
    FROM february_jobs
    UNION ALL
    select *
    from march_jobs
)
where 
    salary_year_avg > 70000 and
    job_title_short = 'Data Analyst'
ORDER BY
    salary_year_avg DESC