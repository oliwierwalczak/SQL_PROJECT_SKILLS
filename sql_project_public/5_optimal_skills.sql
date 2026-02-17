
WITH skill_demand AS (
SELECT skills_job_dim.skill_id, skills_dim.skills, COUNT(skills_job_dim.job_id) AS postings_number_by_skill 
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst' and job_location = 'Anywhere' and salary_year_avg IS NOT NULL
GROUP BY skills_job_dim.skill_id, skills_dim.skills
), average_salary_skill AS (
SELECT skills_dim.skill_id, skills_dim.skills, ROUND(AVG(salary_year_avg), 0) AS average_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst' and salary_year_avg IS NOT NULL and job_location = 'Anywhere'
GROUP BY skills_dim.skills, skills_dim.skill_id
)

SELECT skill_demand.skill_id, skill_demand.skills, average_salary_skill.average_salary, skill_demand.postings_number_by_skill
FROM skill_demand 
inner JOIN average_salary_skill USING (skill_id)
WHERE postings_number_by_skill > 10
ORDER BY average_salary DESC
;

