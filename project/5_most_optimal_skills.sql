SELECT 
    skills.skill_id,
    skills.skills,
    COUNT(skill_to_job.job_id) AS demand_count,
    ROUND(AVG(job_posting.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact AS job_posting
INNER JOIN skills_job_dim AS skill_to_job ON job_posting.job_id = skill_to_job.job_id
INNER JOIN skills_dim AS skills ON skill_to_job.skill_id = skills.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True 
GROUP BY
    skills.skill_id
HAVING
    COUNT(skill_to_job.job_id) > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 20