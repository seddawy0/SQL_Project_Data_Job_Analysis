SELECT
    skills AS skill,
    COUNT(skill_to_job) AS demand_count
FROM job_postings_fact AS job_posting
INNER JOIN skills_job_dim AS skill_to_job ON skill_to_job.job_id = job_posting.job_id
INNER JOIN skills_dim AS skills ON skills.skill_id = skill_to_job.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_work_from_home = TRUE
GROUP BY
    skill
ORDER BY
    demand_count DESC
LIMIT 10

/*
The job market clearly shows that a successful data analyst needs a mix of:
SQL (data extraction)
Python/R (analysis)
Tableau / Power BI (visualization)
Excel (business work)

If someone wants to become a competitive data analyst, the best order is:
1️⃣ SQL
2️⃣ Excel
3️⃣ Python
4️⃣ Tableau or Power BI
5️⃣ Statistics / R
6️⃣ Cloud basics (Azure)
*/