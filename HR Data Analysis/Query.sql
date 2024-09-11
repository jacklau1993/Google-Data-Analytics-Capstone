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

-- calculate correlation between payment tier and experience
SELECT
    CORR(payment_tier, experience_in_current_domain) AS correlation_coefficient
FROM
    `focused-veld-331705.employee_dataset.employee_dataset_formatted`;

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