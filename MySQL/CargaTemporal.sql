create database p3_bases1;
use p3_bases1;
SET GLOBAL local_infile=1;

drop TABLE TEMPORAL;


CREATE TABLE IF NOT EXISTS  TEMPORAL(
    iso_code VARCHAR(150),
    continent VARCHAR(150),
    locations VARCHAR(150),
    dates VARCHAR(150),
    total_cases VARCHAR(150),
    new_cases VARCHAR(150),
    new_cases_smoothed VARCHAR(150),
    total_deaths VARCHAR(150),
    new_deaths VARCHAR(150),
    new_deaths_smoothed VARCHAR(150),
    total_cases_per_million VARCHAR(150),
    new_cases_per_million VARCHAR(150),
    new_cases_smoothed_per_million VARCHAR(150),
    total_deaths_per_million VARCHAR(150),
    new_deaths_per_million VARCHAR(150),
    new_deaths_smoothed_per_million VARCHAR(150),
    reproduction_rate VARCHAR(150),
    icu_patients VARCHAR(150),
    icu_patients_per_million VARCHAR(150),
    hosp_patients VARCHAR(150),
    hosp_patients_per_million VARCHAR(150),
    weekly_icu_admissions VARCHAR(150),
    weekly_icu_admissions_per_million VARCHAR(150),
    weekly_hosp_admissions VARCHAR(150),
    weekly_hosp_admissions_per_million VARCHAR(150),
    new_tests VARCHAR(150),
    total_tests VARCHAR(150),
    total_tests_per_thousand VARCHAR(150),
    new_tests_per_thousand VARCHAR(150),
    new_tests_smoothed VARCHAR(150),
    new_tests_smoothed_per_thousand VARCHAR(150),
    positive_rate VARCHAR(150),
    tests_per_case VARCHAR(150),
    tests_units VARCHAR(150),
    total_vaccinations VARCHAR(150),
    people_vaccinated VARCHAR(150),
    people_fully_vaccinated VARCHAR(150),
    total_boosters VARCHAR(150),
    new_vaccinations VARCHAR(150),
    new_vaccinations_smoothed VARCHAR(150),
    total_vaccinations_per_hundred VARCHAR(150),
    people_vaccinated_per_hundred VARCHAR(150),
    people_fully_vaccinated_per_hundred VARCHAR(150),
    total_boosters_per_hundred VARCHAR(150),
    new_vaccinations_smoothed_per_million VARCHAR(150),
    stringency_index VARCHAR(150),
    population VARCHAR(150),
    population_density VARCHAR(150),
    median_age VARCHAR(150),
    aged_65_older VARCHAR(150),
    aged_70_older VARCHAR(150),
    gdp_per_capita VARCHAR(150),
    extreme_poverty VARCHAR(150),
    cardiovasc_death_rate VARCHAR(150),
    diabetes_prevalence VARCHAR(150),
    female_smokers VARCHAR(150),
    male_smokers VARCHAR(150),
    handwashing_facilities VARCHAR(150),
    hospital_beds_per_thousand VARCHAR(150),
    life_expectancy VARCHAR(150),
    human_development_index VARCHAR(150),
    excess_mortality_cumulative_absolute VARCHAR(150),
    excess_mortality_cumulative VARCHAR(150),
    excess_mortality VARCHAR(150),
    excess_mortality_cumulative_per_million VARCHAR(150)
);

# 122380 filas
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/owid-covid-data.csv' 
INTO TABLE TEMPORAL
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


#select COUNT(*) from TEMPORAL;

commit;