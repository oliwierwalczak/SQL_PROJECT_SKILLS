# Introduction
**Hello, my name is Oliwier Walczak and this is my very first project on GitHub connected with the business area I am interested into, which is data analytics/science.**

**At first, I want to thank to Luke Barrouse, data analyst and content creator, who have prepared full course on YouTube [(course)](https://www.youtube.com/watch?v=7mz73uXD9DA&t=11766s) with needed materials, including raw data and videos where he shows step by step how to prepare complete data analytics project. I also want to thank to Kelly Adams, the course producer.**



# Background

## In the first part of the project, I followed Luke Barousse's path and analyze job offers data to answear following qestions:

1. **Which remote job offers from 2023 for data analysts offered the highest annual salary?**
2. **Which skills connected with data were the most preferable among best paying remote offers for Data Analysts in 2023?** 
3. **What were top 5 most frequently demanded skills among Data Analysts working remotely in 2023?**
4. **Which skills guaranted the highest average salary for Data Analysts working remotely in 2023?**
5. **Were skills with the highest average offered salary also the ones with highest frequency of appearing in job offers?**

## In the second part, I focused more on cases connected with one of my favourite data analytic tools - SQL.** 

rest will be aded soon:)
 
# Tools I used
1. **SQL (PostgreSQL)**
2. **Git**
3. **GitHub**
# The analysis

## First Part (YouTube course queries)

Want to check SQL code, you will find it there:
[sql_project_public](/sql_project_public/)

### Query No. 1 - top 10 job offers with highest annual salary.

I used filtering to count only job offers for data analysts in general, with remote type of work and having information about annual salary. To get top ten offers, I used 'ORDER BY' clause, 'DESC' to start from the highest salary and 'LIMIT 10' to get only 10 best offers. Additionally, I used 'LEFT JOIN' to join companies' names from COMPANY_DIM table.
```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM job_postings_fact
LEFT JOIN company_dim USING (company_id)
WHERE job_title_short = 'Data Analyst' AND job_location = 'Anywhere' AND salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10;
```
Key findings: 
- The best 10 job offers for Data Analysts working remotely by salary vary from 184 000.00$ to 650 000.00$, comparing to average 123 268.82$ for all job postings in the dataset. The numbers show that in 2023 having occupation as a data analyst / data scientist created very atractive income perspective, comparing to average index salary at 66 621.80$ in United States ([https://www.census.gov/library/publications/2024/demo/p60-282.html](https://www.census.gov/library/publications/2024/demo/p60-282.html)).
- In the group of potential employers we see a set of companies from different areas, like telecommunication, high tech, finance and recruitment. This is a proof that data analysts play key role in companies' performance, providing knowledge and skills essential to cope with huge amount of data collected due to their operational processes.


### Query No. 2 - top 10 job offers - the most preferable skills.

I used query from previous task as a Common Table Expression (CTE) top_paying_jobs. Then I used it to create another CTE top_paying_skils, which I used to identify a list of expected skills in each top paying offer. Finally, I ran another query to count number of findings for each skill.

```sql
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
```

### Query No. 3 - most frequently demanded skills.

In task 3 I used data to investigate which skills are the most common across all job postings in our dataset. I focused on Data Analyst role and limited my investigation to those occupations which could be done anywhere. I combined job_postings_fact table with skills_job_dim and skills_dim, group them by skill name and skill id and counted number of offers with each skill. I limited my query to print only top 5 most common skills, which are respectively SQL, EXCEL, PYTHON, TABLEAU, POWER BI (*here I did not include filter for annual salary to not be null*)

```sql
SELECT skills_job_dim.skill_id, skills_dim.skills, COUNT(skills_job_dim.job_id) AS postings_number_by_skill 
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst' AND job_location = 'Anywhere'
GROUP BY skills_job_dim.skill_id, skills_dim.skills
ORDER BY postings_number_by_skill DESC
LIMIT 5;
```

### Query No. 4 - highest average salary per skill.

I used connection between 3 tables from previous tasks to check what are the average salaries per year among job offers (for Data Analysts working remotely) with different skills. I grouped them by skill name and counted average. Finally, I limited my query to 25 skills with highest average salary.    

```sql
SELECT skills_dim.skills, ROUND(AVG(salary_year_avg), 0) AS average_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst' AND job_location = 'Anywhere' and salary_year_avg IS NOT NULL
GROUP BY skills_dim.skills
ORDER BY average_salary DESC
LIMIT 25;
```


### Query No. 5 - highest paying skills VS. most frequently demanded skills.

In the last task in the course, I combined queries from tasks 3 and 4 (using CTEs) to compare the number of postings with each skill demanded with average annual salary connected with that skill. I used INNER JOIN to match number of offers and average salary for skill, using skill id. I limited my query to only those skills, which appeared in at least 10 offers. Finally I ordered all rows by average salary 

```sql
WITH skill_demand AS (
SELECT skills_job_dim.skill_id, skills_dim.skills, COUNT(skills_job_dim.job_id) AS postings_number_by_skill 
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst' AND job_location = 'Anywhere' AND salary_year_avg IS NOT NULL
GROUP BY skills_job_dim.skill_id, skills_dim.skills
), average_salary_skill AS (
SELECT skills_dim.skill_id, skills_dim.skills, ROUND(AVG(salary_year_avg), 0) AS average_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst' AND salary_year_avg IS NOT NULL and job_location = 'Anywhere'
GROUP BY skills_dim.skills, skills_dim.skill_id
)

SELECT skill_demand.skill_id, skill_demand.skills, average_salary_skill.average_salary, skill_demand.postings_number_by_skill
FROM skill_demand 
INNER JOIN average_salary_skill USING (skill_id)
WHERE postings_number_by_skill > 10
ORDER BY average_salary DESC
;
```





## Second Part (My own research - SQL) - will be added soon:)



# What I have learned
# *Conclusions*
