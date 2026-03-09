SELECT
    job_id,
    job_title,
    job_location,
    company.name AS company_name,
    job_schedule_type,
    salary_year_avg,
    job_posted_date::date
FROM job_postings_fact AS job_posting
LEFT JOIN company_dim AS company ON company.company_id = job_posting.company_id
WHERE
    salary_year_avg IS NOT NULL AND
    job_title_short = 'Data Analyst' AND
    job_work_from_home = TRUE
ORDER BY salary_year_avg DESC
LIMIT 10
