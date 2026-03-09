# 📊 Data Analyst Job Market Analysis — 2023

> An in-depth exploration of the data analyst job market, uncovering the highest-paying roles, most in-demand skills, and the optimal skill investments for career growth.

---

## 📌 Introduction

The data analytics job market is evolving rapidly. Professionals entering or advancing within the field face a critical question: **which skills deliver the greatest career value?** This project investigates that question through structured SQL analysis of real-world job posting data from 2023, with a focus on remote data analyst positions. The goal is to provide actionable, evidence-based insights that help data professionals make smarter decisions about their skill development.

---

## 🌐 Background

This analysis was motivated by a desire to better understand the landscape of data analyst careers — not through anecdote, but through data. The dataset covers thousands of job postings collected throughout 2023 and includes attributes such as job title, company, location, salary, and required skills.

Data hails from my [SQL Course](https://www.youtube.com/watch?v=7mz73uXD9DA).

### The central questions driving this project were:

1. Which data analyst roles offer the highest compensation?
2. What skills are most frequently required by employers?
3. Which skills command the highest average salaries?
4. What skills represent the best combination of demand *and* pay — the "optimal" investments?

By systematically answering each of these questions, this analysis delivers a clear picture of where the market rewards analysts most generously and what it takes to compete at the top.

---

## 🛠️ Tools I Used

The following tools were central to every phase of this project, from data extraction to final visualisation:

- **SQL** — The primary tool for querying and transforming the raw dataset. All aggregations, joins, and filters were written in SQL, making the analysis reproducible and transparent.
- **VS Code** — The development environment of choice for writing and executing SQL queries.
- **Git & GitHub** — Used for version control and to document the project's evolution, ensuring all analytical steps are traceable.
- **PostgreSQL** — The database engine used to host and query the job postings dataset.

---

## 🔍 The Analysis

### 1. Top 10 Highest-Paying Data Analyst Roles

The first analysis identified the ten best-compensated remote data analyst positions posted in 2023, ranked by average annual salary.

```sql
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
```

![Top 10 Highest-Paying Data Analyst Jobs](assets\chart1_top_paying_jobs.png)

**Key Finding:** The salary range among top-paying roles is extraordinarily wide. A single outlier — a Data Analyst posting at Mantys — reached $650,000 per year, nearly double the next highest role (Meta's Director of Analytics at $336,500). Excluding this outlier, salaries at the upper end of the market cluster between $184,000 and $256,000, suggesting a healthy premium for senior and director-level analyst roles at technology, telecommunications, and financial services companies.

---

### 2. Skills Required for Top-Paying Roles

With the top-paying roles identified, the next logical step was to determine which skills those roles most commonly require.

```sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        company.name AS company_name,
        salary_year_avg
    FROM job_postings_fact AS job_posting
    LEFT JOIN company_dim AS company ON company.company_id = job_posting.company_id
    WHERE
        salary_year_avg IS NOT NULL AND
        job_title_short = 'Data Analyst' AND
        job_work_from_home = TRUE
    ORDER BY salary_year_avg DESC
    LIMIT 10
)

SELECT
    top_paying_jobs.*,
    skills.skills
FROM top_paying_jobs
INNER JOIN skills_job_dim AS skill_to_job ON skill_to_job.job_id = top_paying_jobs.job_id
INNER JOIN skills_dim AS skills ON skills.skill_id = skill_to_job.skill_id
ORDER BY salary_year_avg DESC
```

![Skills Required Across Top-Paying Data Analyst Roles](assets\chart2_skills_top_jobs.png)

**Key Finding:** SQL and Python appear in virtually every high-paying role, confirming their status as foundational, non-negotiable skills. Tableau is also nearly universal. Beyond the core stack, cloud technologies — particularly AWS and Azure — and collaboration tools such as Jira, Confluence, and Atlassian appear frequently in director-level and principal-level roles, suggesting that senior analysts are expected to operate across both technical and organisational domains.

---

### 3. Most In-Demand Skills Across All Data Analyst Postings

The third analysis broadened the scope from the top ten roles to the entire dataset, identifying the skills mentioned most frequently across all data analyst job postings in 2023.

```sql
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
```

![Top 10 Most In-Demand Skills for Data Analysts](assets\chart3_most_demanded_skills.png)
| Skill      | Demand Count |
|------------|-------------:|
| SQL        | 7,291        |
| Excel      | 4,611        |
| Python     | 4,330        |
| Tableau    | 3,745        |
| Power BI   | 2,609        |
| R          | 2,142        |
| SAS        | 1,866        |
| Looker     | 868          |
| Azure      | 821          |
| PowerPoint | 819          |

**Key Finding:** SQL leads by a significant margin with over 7,200 mentions — nearly 60% more than the second-ranked skill, Excel (4,611). Python (4,330) and Tableau (3,745) round out the top four. Power BI, R, and SAS each command a meaningful share of postings, reinforcing the diversity of tooling expectations across different organisations and industries. The clear takeaway is that SQL fluency is the single most important skill for any data analyst entering the market.

---

### 4. Skills Associated with the Highest Average Salaries

This analysis examined which specific technical skills correlate with the highest salaries when they appear in job postings — irrespective of how frequently those skills are demanded.

```sql
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
```

![Top 20 Skills by Average Salary](assets\chart4_skills_by_salary.png)
| Skill         | Average Salary ($) |
|---------------|-------------------:|
| PySpark       | 208,172            |
| Bitbucket     | 189,155            |
| Watson        | 160,515            |
| Couchbase     | 160,515            |
| DataRobot     | 155,486            |
| GitLab        | 154,500            |
| Swift         | 153,750            |
| Jupyter       | 152,777            |
| Pandas        | 151,821            |
| Elasticsearch | 145,000            |
| Golang        | 145,000            |
| NumPy         | 143,513            |
| Databricks    | 141,907            |
| Linux         | 136,508            |
| Kubernetes    | 132,500            |
| Atlassian     | 131,162            |
| Twilio        | 127,000            |
| Airflow       | 126,103            |
| Scikit-learn  | 125,781            |
| Jenkins       | 125,436            |

**Key Finding:** Niche and specialist skills occupy the top of the salary ranking. PySpark ($208K), Bitbucket ($189K), and cloud/AI tools such as Watson and Couchbase (both ~$160K) sit far above the market average. These skills tend to appear in senior engineering-adjacent analyst roles that demand deep technical expertise. The important caveat is that many of these skills have low overall demand (as shown in Analysis 3), meaning they represent a high-risk, high-reward specialisation path rather than a broadly applicable investment.

---

### 5. Optimal Skills — Balancing Demand and Salary

The final analysis synthesises demand and compensation into a single view, identifying the skills that offer the best of both worlds: meaningful demand from employers *and* strong average salaries.

```sql
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
```

![Most Optimal Skills: Demand vs. Salary](assets\chart5_optimal_skills.png)
| Skill ID | Skills     | Demand Count | Average Salary ($) |
|----------|------------|:------------:|-------------------:|
| 8        | go         | 27           | 115,320            |
| 234      | confluence | 11           | 114,210            |
| 97       | hadoop     | 22           | 113,193            |
| 80       | snowflake  | 37           | 112,948            |
| 74       | azure      | 34           | 111,225            |
| 77       | bigquery   | 13           | 109,654            |
| 76       | aws        | 32           | 108,317            |
| 4        | java       | 17           | 106,906            |
| 194      | ssis       | 12           | 106,683            |
| 233      | jira       | 20           | 104,918            |
| 79       | oracle     | 37           | 104,534            |
| 185      | looker     | 49           | 103,795            |
| 2        | nosql      | 13           | 101,414            |
| 1        | python     | 236          | 101,397            |
| 5        | r          | 148          | 100,499            |
| 78       | redshift   | 16           | 99,936             |
| 187      | qlik       | 13           | 99,631             |
| 182      | tableau    | 230          | 99,288             |
| 197      | ssrs       | 14           | 99,171             |
| 92       | spark      | 13           | 99,077             |

**Key Finding:** Python (236 postings, ~$101K avg) and Tableau (230 postings, ~$99K avg) stand out as the most broadly optimal skills — both are in high demand and command well-above-median compensation. Snowflake, Azure, and AWS offer a compelling combination of growing demand and salaries consistently above $108K, making them strategic additions to any analyst's toolkit. Go, Hadoop, and BigQuery are niche but well-compensated, appealing to analysts willing to differentiate through specialisation.

---

## 📚 What I Learned

This project reinforced several important lessons — both technical and strategic:

**On SQL:** Complex, multi-table queries combining aggregations, window functions, and CTEs are indispensable for structured data analysis. Writing clean, well-documented SQL from the outset saves significant time during review and iteration.

**On data storytelling:** Raw numbers rarely speak for themselves. The real analytical value emerged when individual findings were contextualised and compared — for example, contrasting the "most in-demand" and "highest-paying" skill lists revealed a clear gap between what the market needs broadly and what it rewards most richly.

**On career strategy:** The data tells a clear story for analysts at all career stages. Early-career professionals should prioritise SQL, Excel, and Python. Mid-career analysts seeking salary growth should target cloud platforms (Snowflake, Azure, AWS) and specialised libraries (pandas, PySpark). Senior analysts aiming for top compensation should develop cross-functional skills including project management tooling (Jira, Confluence) alongside technical depth.

---

## ✅ Conclusions

The 2023 data analyst job market rewards a tiered skill stack. SQL and Excel remain the most frequently requested skills, but they are not sufficient alone for top-tier compensation. Python and Tableau represent the strongest combination of demand and pay for the majority of the market. Cloud and big data technologies — Snowflake, Azure, AWS, and PySpark — are the highest-leverage skills for analysts seeking significant salary growth, particularly in senior or specialist roles.

The analysis also highlights that the highest-compensated roles are not necessarily the most common ones. Analysts who invest in cloud infrastructure, data engineering-adjacent tools, and collaboration platforms position themselves for director-level and principal-level roles where compensation can exceed $200,000 annually.

In summary: **master the fundamentals, build depth in cloud technologies, and develop the communication and tooling skills that senior roles demand**.

---

## 📁 Project Structure

```
📦 SQL_Project_Data_Job_Analysis
 ┣ 📂 assets/
 ┃ ┣ 🖼️ chart1_top_paying_jobs.png
 ┃ ┣ 🖼️ chart2_skills_top_jobs.png
 ┃ ┣ 🖼️ chart3_most_demanded_skills.png
 ┃ ┣ 🖼️ chart4_skills_by_salary.png
 ┃ ┗ 🖼️ chart5_optimal_skills.png
 ┣ 📂 project/
 ┃ ┣ 📄 1_top_paying_jobs.sql
 ┃ ┣ 📄 2_top_paying_job_skills.sql
 ┃ ┣ 📄 3_in-demand_skills.sql
 ┃ ┣ 📄 4_top_paying_skills.sql
 ┃ ┗ 📄 5_most_optimal_skills.sql
 ┣ 📂 sql_load/
 ┃ ┣ 🗄️ 1_create_database.sql
 ┃ ┣ 🗄️ 2_create_tables.sql
 ┃ ┣ 🗄️ 3_modify_tables.sql
 ┗ 📄 README.md
```

---

*Dataset sourced from public job postings aggregated in 2023. Analysis conducted using PostgreSQL. All salaries are in USD and represent averages across qualifying job postings.*
