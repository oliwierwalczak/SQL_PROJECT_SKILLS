
WITH top_skills_table AS (
    WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM job_postings_fact
    LEFT JOIN company_dim USING (company_id)
    WHERE job_title_short = 'Data Analyst' AND job_location = 'Anywhere' AND salary_year_avg IS NOT NULL
    ORDER BY salary_year_avg DESC
    LIMIT 10
)

SELECT top_paying_jobs.*, skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY salary_year_avg DESC
)

SELECT skills, count(skills) AS skills_number_of_postings
FROM top_skills_table
GROUP BY skills
ORDER BY skills_number_of_postings DESC;

/*
As you can see, throughout the top 10 job postings by salary, the most preferable 
skill is knowing SQL, then python and tableau.
*/


