# Introduction
Hello, my name is Oliwier Walczak and this is my very first project on GitHub connected with the business area I am interested into, which is data analytics/science.

At first, I want to thank to Luke Barrouse, data analyst and content creator, who have prepared full course on YouTube [course](https://www.youtube.com/watch?v=7mz73uXD9DA&t=11766s) with needed materials, including raw data and videos where he shows step by step how to prepare such professional project. I also want to thank Kelly Adams, the course producer. 



# Background

1. **Which remote job offers from 2023 for data analysts offered the best salary?**
2. **Which skills connected with data were the most preferable among best paying remote offers for Data Analysts in 2023?** 
3. **What were top 5 most frequently demanded skills among Data Analysts working remotely in 2023?**
4. **Which skills guaranted the highest average salary for Data Analysts working remotely in 2023?**
5. **Were skills with the highest average offered salary also the ones with highest frequency of appearing in job offers?**

# Tools I used
1. **SQL (PostgreSQL)**
2. **Git**
3. **GitHub**
# The analysis

## First Part (YouTube Course Queries)

### Query 1
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

## Second Part (My own researche - SQL)


Want to check SQL code, you will find it there:
[sql_project_public](/sql_project_public/)
# What I have learned
# *Conclusions*
