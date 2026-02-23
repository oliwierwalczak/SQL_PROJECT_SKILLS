
SELECT skills_job_dim.skill_id, skills_dim.skills, COUNT(skills_job_dim.job_id) AS postings_number_by_skill 
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst' and job_location = 'Anywhere'
GROUP BY skills_job_dim.skill_id, skills_dim.skills
ORDER BY postings_number_by_skill DESC
LIMIT 5;


