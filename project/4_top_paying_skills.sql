SELECT
    skills AS skill,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact AS job_posting
INNER JOIN skills_job_dim AS skill_to_job ON skill_to_job.job_id = job_posting.job_id
INNER JOIN skills_dim AS skills ON skills.skill_id = skill_to_job.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    job_work_from_home = TRUE
GROUP BY
    skill
ORDER BY
    avg_salary DESC
LIMIT 20

/*
Big Data skills drive the highest salaries:
Tools like PySpark, Databricks, and Elasticsearch appear at the top, showing that analysts who can work
with large-scale data systems earn significantly more.

Python ecosystem is a core high-pay skill set:
Libraries such as Pandas, NumPy, Jupyter, and Scikit-learn show that strong Python-based data analysis
and basic machine learning skills are highly valued.

Analytics roles are blending with data engineering:
Tools like Airflow, Linux, Kubernetes, GitLab, and Jenkins indicate that higher-paid analysts often
build pipelines, automate workflows, and collaborate using engineering tools, not just analyze data.
*/