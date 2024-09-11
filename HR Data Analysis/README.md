## Introduction

This is a part of the Capstone project of Google Data Analytics Certificate programme. In the project, I will play a role of junior data analyst to provide analysed data for stakeholder to make data-driven decisions.

### Quick Links
[Dataset](https://www.kaggle.com/datasets/tawfikelmetwally/employee-dataset)

[SQL Query](Query.sql)

## Scenario
### Company Overview
I am working as a Junior Data Analyst at TechWave Inc., a mid-sized technology company specializing in software development and IT services. 

### My Role
As a Junior Data Analyst, I have been tasked by the HR department to conduct a comprehensive workforce-related analyses.

## Ask
### Key Question
1. What is the distribution of educational qualifications among employess?
2. How does the length of service (Joining Year) vary across different cities?
3. Is there a correlation between Payment Tier and Experience in Current Domain?
4. What is the gender distribution within the workforce?
5. Are there any patterns in leave-taking behaviour among employees?

## Prepare
The dataset is downloaded from [Kaggle](https://www.kaggle.com/datasets/tawfikelmetwally/employee-dataset) under the license of CC0:Public Domain.

In order to analyse the dataset, BigQuery is used as this is a mid-size dataset, which makes Excel is not suitable for analysis. The dataset is loaded onto BigQuery with a Project ID and Dataset ID of 'focused-veld-331705.employee_dataset.employee_dataset'.

## Process
### Data Exploration
The original dataset consists of  columns, including 
* 'Education', 
* 'JoiningYear', 
* 'City', 
* 'PaymentTier', 
* 'Age', 
* 'Gender', 
* 'EverBenched',
* 'ExperienceInCurrentDomain',
* 'LeaveOrNot'

Education, City, Gender are string. 
JoiningYear, PaymentTier, Age, ExperienceInCurrentDomain, LeaveOrNot are Integer.
EverBenched is boolean.

### Data Cleaning
SQL: Data Cleaning
First of all, I clean the dataset by creating a new tale with standardised column names, since some of the column names are not readible and with some typos. 

```
-- Create a new table from the original dataset with new column names
CREATE TABLE `focused-veld-331705.employee_dataset.employee_dataset_formatted` AS
SELECT
    Education AS education,
    JoiningYear AS joining_year,
    City AS city,
    PaymentTier AS payment_tier,
    Age AS age,
    Gender AS gender,
    EverBenched AS ever_benched,
    ExperienceInCurrentDomain AS experience_in_current_domain,
    LeaveOrNot AS leave_or_not
FROM
    `focused-veld-331705.employee_dataset.employee_dataset`;
```
This create an new dataset with a more readible column names for further analysis.

Second, I check if there is any missing values. After using SQL checking, there is no missing value in the dataset.

```
-- Check if there is any missing value
SELECT
    SUM(CASE WHEN education IS NULL THEN 1 ELSE 0 END) AS education_missing,
    SUM(CASE WHEN joining_year IS NULL THEN 1 ELSE 0 END) AS joining_year_missing,
    SUM(CASE WHEN city IS NULL THEN 1 ELSE 0 END) AS city_missing,
    SUM(CASE WHEN payment_tier IS NULL THEN 1 ELSE 0 END) AS payment_tier_missing,
    SUM(CASE WHEN age IS NULL THEN 1 ELSE 0 END) AS age_missing,
    SUM(CASE WHEN gender IS NULL THEN 1 ELSE 0 END) AS gender_missing,
    SUM(CASE WHEN ever_benched IS NULL THEN 1 ELSE 0 END) AS ever_benched_missing,
    SUM(CASE WHEN experience_in_current_domain IS NULL THEN 1 ELSE 0 END) AS experience_in_current_domain_missing,
    SUM(CASE WHEN leave_or_not IS NULL THEN 1 ELSE 0 END) AS leave_or_not_missing
FROM
    `focused-veld-331705.employee_dataset.employee_dataset_formatted`;
```
The query result shows that there is no missing value in all columns.

## Analyze and Share
### "What is the distribution of educational qualifications among employess?"
For analysis, this is the first question to address. To answer this question, I use SQL to get the distribution of educational qualifications among employees.

SQL as follows:
```
-- Look for distribution of educational qualifications among employees
SELECT
    education,
    COUNT(*) AS count
FROM
    `focused-veld-331705.employee_dataset.employee_dataset_formatted`
GROUP BY
    education
ORDER BY
    count DESC;
```

There are total 4653 employees in the workforce. Among them, 3601 are Bachelors, 873 are Masters, and 179 has a PHD.

### "How does the length of service (joining year) vary across different cities?"
To answer this question, the following SQL has been input into BigQuery.

```
-- Calculate average length of service for each city
CREATE TABLE `focused-veld-331705.employee_dataset.avg_length_of_service_by_city` AS
SELECT
    city,
    AVG(2024 - joining_year) AS avg_length_of_service
FROM
    `focused-veld-331705.employee_dataset.employee_dataset_formatted`
GROUP BY
    city
ORDER BY
    avg_length_of_service DESC;
```
This generates a new dataset that shows the average length of service for each city. 

For Bangalore, the average length of service is 9.1 year. For Pune, the average length of service is 8.9 year. For New Delhi, the average length of service is 8.4 year.

### "Is there a correlation between Payment Tier and Experience in Current Domain?"
The following SQL is used to calculate the Pearson correlation coefficient. The result will be a value between -1 and 1, where '1' indicates a perfect positive correlation, while '-1' indicates a perfect negative correlation, and '0' means no correlation.
```
-- calculate correlation between payment tier and experience
SELECT
    CORR(payment_tier, experience_in_current_domain) AS correlation_coefficient
FROM
    `focused-veld-331705.employee_dataset.employee_dataset_formatted`;
```

The correlation coefficient is 0.0183, which is a very near to zero value. In other words, it shows a very weak positive correlation between Payment Tier and Experience in the Current Domain. 

### "What is the gender distribution within the workforce?"
I run a simple SQL query to get the distribution of gender.
```
-- Get the gender distribution
CREATE TABLE `focused-veld-331705.employee_dataset.gender_distribution` AS
SELECT
    gender,
    COUNT(*) AS count
FROM
    `focused-veld-331705.employee_dataset.employee_dataset_formatted`
GROUP BY
    gender
ORDER BY
    count DESC;
```

This creates a new table that shows the gender distribution: 2778 male and 1875 female.

### "Are there any patterns in leave-taking behaviour among employees?"
This is the most challenging question as it involves different calculation of leave distribution. First I calculate by demographic factors like Gender, City, and Education. Then I calculate by work-related factors including payment tier, experience in current domain, and joining year. After run through all these calculations, I have a full understadning of the leave patterns among employees. 

#### Leave distribution by demographic factors
##### Gender
```
-- Leave distribution by gender
SELECT
    gender,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN leave_or_not = 1 THEN 1 ELSE 0 END) AS employees_on_leave,
    ROUND(SUM(CASE WHEN leave_or_not = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS leave_percentage
FROM
    `focused-veld-331705.employee_dataset.employee_dataset_formatted`
GROUP BY
    gender
ORDER BY
    leave_percentage DESC;
```
The below result from the query shows that 47.15% of female employees are on leave, while male employees only count for 25.77%.

##### City
```
-- leave distribution by city
SELECT
    city,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN leave_or_not = 1 THEN 1 ELSE 0 END) AS employees_on_leave,
    ROUND(SUM(CASE WHEN leave_or_not = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS leave_percentage
FROM
    `focused-veld-331705.employee_dataset.employee_dataset_formatted`
GROUP BY
    city
ORDER BY
    leave_percentage DESC;
```
The result shows that 50.39% of employees in Pune, 31.63% of employees in New Delhi, and 26.71% of employees in Bangalore are on leave.

##### Education
```
-- leave distribution by education
SELECT
    education,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN leave_or_not = 1 THEN 1 ELSE 0 END) AS employees_on_leave,
    ROUND(SUM(CASE WHEN leave_or_not = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS leave_percentage
FROM
    `focused-veld-331705.employee_dataset.employee_dataset_formatted`
GROUP BY
    education
ORDER BY
    leave_percentage DESC;
```
It shows that employees with a Master degree are most likely to take leave, which count for 48.8%. PHD employees are the least to take leave, about 25%.

#### Leave distribution by work-related factors
##### Payment Tier
```
-- leave distribution by payment tier
SELECT
    payment_tier,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN leave_or_not = 1 THEN 1 ELSE 0 END) AS employees_on_leave,
    ROUND(SUM(CASE WHEN leave_or_not = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS leave_percentage
FROM
    `focused-veld-331705.employee_dataset.employee_dataset_formatted`
GROUP BY
    payment_tier
ORDER BY
    leave_percentage DESC;
```

##### Experience in Current Domain
```
-- leave distribution by experience in current domain
SELECT
    experience_in_current_domain,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN leave_or_not = 1 THEN 1 ELSE 0 END) AS employees_on_leave,
    ROUND(SUM(CASE WHEN leave_or_not = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS leave_percentage
FROM
    `focused-veld-331705.employee_dataset.employee_dataset_formatted`
GROUP BY
    experience_in_current_domain
ORDER BY
    leave_percentage DESC;
```

##### Joining Year
```
-- leave distribution by joining year
SELECT
    joining_year,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN leave_or_not = 1 THEN 1 ELSE 0 END) AS employees_on_leave,
    ROUND(SUM(CASE WHEN leave_or_not = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS leave_percentage
FROM
    `focused-veld-331705.employee_dataset.employee_dataset_formatted`
GROUP BY
    joining_year
ORDER BY
    leave_percentage DESC;
```

With all these analysis, we can look for patterns for leave-taking behaviour. In order to visualise it, Tableau comes into play.

## Act
Act is the last phase within a data analysis process. In this phase, recommendations are made to stakeholders based on the findings from the analysis. Here are some recommendations:

1. Gender-Specific Support Programme: Introducing flexible working hours, remote work options, or enhanced parental leave policies that help reduce the need for frequent leave among female employees. 
2. Location-Specific HR Strategies: Conduct a more in-depth analysis to understand the reasons behind the high leave rate in Pune.
3. Educational Support and Career Development: Consider providing additional support or career developement opportunites for employees with Master's degrees. 
4. Payment Tier Analysis: Investigate the reasons behind the high leave rate in Payment Tier 2. This might involve reviewing workload, job satisfaction, and compensation levels. Consider offering incentives, adjusting workloads, or providing additional support to employees in this tier to reduce their need for leave.
5. Experience-Based Interventions: Introduce targeted interventions for employees with 2-3 years of experience, such as mentorship programs, skill development opportunities, or role rotations.
6. Focus on Recent Joiners: Consider enhancing the onboarding experience, providing more comprehensive training, and ensuring that new employees have the support they need to succeed.

## Limitation
I would also like to add a note that there are some limitations on the analysis above which may worth more in-depth digging. For example, the leave-taking pattern analysis may involve a more thorough cross-factor analysis to better find out if there is any specific pattern in leave-taking actions. Cross-factor analysis like examining the behaviour by gender and city combined, or payment tier and education combined. SQL may look like this:
```
-- cross factor analysis by gender and city
SELECT
    gender,
    city,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN leave_or_not = 1 THEN 1 ELSE 0 END) AS employees_on_leave,
    ROUND(SUM(CASE WHEN leave_or_not = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS leave_percentage
FROM
    `focused-veld-331705.employee_dataset.employee_dataset_formatted`
GROUP BY
    gender, city
ORDER BY
    leave_percentage DESC;
```
