
#6 filas

INSERT INTO CONTINENTE (continent) 
SELECT DISTINCT  continent from TEMPORAL where (continent !='');

SELECT * FROM CONTINENTE;

#224 filas
INSERT INTO PAIS (iso_code, locations, id_Continente)
SELECT DISTINCT T.iso_code, t.locations, C.id_Continente
FROM TEMPORAL T, CONTINENTE  C
WHERE T.continent =C.continent;


#116811 filas
INSERT INTO Muerte (total_deaths, new_deaths, new_deaths_smoothed,
total_deaths_per_million,new_deaths_per_million, 
new_deaths_smoothed_per_million, Fecha, id_Pais)
SELECT DISTINCT IF( total_deaths='', NULL, total_deaths)  AS 'total_deaths',
IF( new_deaths='', NULL, new_deaths)  AS 'new_deaths',
IF( new_deaths_smoothed='', NULL, new_deaths_smoothed)  AS 'new_deaths_smoothed',
IF( total_deaths_per_million='', NULL, total_deaths_per_million)  AS 'total_deaths_per_million',
IF( new_deaths_per_million='', NULL, new_deaths_per_million)  AS 'new_deaths_per_million',
IF( new_deaths_smoothed_per_million='', NULL, new_deaths_smoothed_per_million)  AS 'new_deaths_smoothed_per_million',
dates,  P.id_pais
FROM TEMPORAL T, PAIS P
WHERE T.locations=p.locations;


#SELECT COUNT(*) FROM(SELECT distinct locations, total_deaths, dates FROM TEMPORAL WHERE locations is not null);

#116811
INSERT INTO CASO (total_cases,new_cases,new_cases_smothed,total_cases_per_million,
new_cases_per_million, new_cases_soothed_per_million, Fecha,  id_Pais)
SELECT DISTINCT IF( total_cases='', NULL, total_cases)  AS 'total_cases',
IF( new_cases='', NULL, new_cases)  AS 'new_cases',
IF( new_cases_smoothed='', NULL, new_cases_smoothed)  AS 'new_cases_smoothed',
IF( total_cases_per_million='', NULL, total_cases_per_million)  AS 'total_cases_per_million',
IF( new_cases_per_million='', NULL, new_cases_per_million)  AS 'new_cases_per_million',
IF( new_cases_smoothed_per_million='', NULL, new_cases_smoothed_per_million)  AS 'new_cases_smoothed_per_million',
dates, p.id_pais
FROM TEMPORAL T, PAIS P
WHERE T.locations=p.locations;

#116811
INSERT INTO DatosVacuna (total_vaccinations,people_vaccinated,people_fully_vaccinated,
new_vacinations,new_vacinations_smoothed,total_vacinations_per_hundred,
people_vaccinated_per_hundred,people_fully_vaccinated_per_hundred,
new_vaccinations_smoothed_per_million,total_boosters,total_bossters_per_hundred,
Fecha, id_Pais)
SELECT DISTINCT IF( total_vaccinations='', NULL, total_vaccinations)  AS 'total_vaccinations',
IF( people_vaccinated='', NULL, people_vaccinated)  AS 'people_vaccinated',
IF( people_fully_vaccinated='', NULL, people_fully_vaccinated)  AS 'people_fully_vaccinated',
IF( new_vaccinations='', NULL, new_vaccinations)  AS 'new_vaccinations',
IF( new_vaccinations_smoothed='', NULL, new_vaccinations_smoothed)  AS 'new_vaccinations_smoothed',
IF( total_vaccinations_per_hundred='', NULL, total_vaccinations_per_hundred)  AS 'total_vaccinations_per_hundred',
IF( people_vaccinated_per_hundred='', NULL, people_vaccinated_per_hundred)  AS 'people_vaccinated_per_hundred',
IF( people_fully_vaccinated_per_hundred='', NULL, people_fully_vaccinated_per_hundred)  AS 'people_fully_vaccinated_per_hundred',
IF( new_vaccinations_smoothed_per_million='', NULL, new_vaccinations_smoothed_per_million)  AS 'new_vaccinations_smoothed_per_million',
IF( total_boosters='', NULL, total_boosters)  AS 'total_boosters',
IF( total_boosters_per_hundred='', NULL, total_boosters_per_hundred)  AS 'total_boosters_per_hundred',
dates, p.id_pais
FROM TEMPORAL T, PAIS P
WHERE T.locations=p.locations;

#415 filas
INSERT INTO DatosPais(population,populatino_density,extreme_proverty,
life_expectancy,gdp_per_capita,human_development_index,median_age,
aged_65_older,aged_70_older,handwashing_facilities,Anio,id_Pais)
SELECT DISTINCT IF( population='', NULL, population)  AS 'population',
IF( population_density='', NULL, population_density)  AS 'population_density',
IF( extreme_poverty='', NULL, extreme_poverty)  AS 'extreme_poverty',
IF( life_expectancy='', NULL, life_expectancy)  AS 'life_expectancy',
IF( gdp_per_capita='', NULL, gdp_per_capita)  AS 'gdp_per_capita',
IF( human_development_index='', NULL, human_development_index)  AS 'human_development_index',
IF( median_age='', NULL, median_age)  AS 'median_age',
IF( aged_65_older='', NULL, aged_65_older)  AS 'aged_65_older',
IF( aged_70_older='', NULL, aged_70_older)  AS 'aged_70_older',
IF( handwashing_facilities='', NULL, handwashing_facilities)  AS 'aged_70_older',
(SELECT YEAR (dates)), p.id_pais
FROM TEMPORAL T, PAIS P
WHERE T.locations=p.locations;

#116811 filas
INSERT INTO DatosTest(new_test,total_test,total_tests_per_thousan,
new_tests_per_thousan, new_tests_smoothed,new_tests_smooted_per_thousan,
tes_units,Fecha,id_Pais)
SELECT DISTINCT  IF( new_tests='', NULL, new_tests)  AS 'new_tests',
IF( total_tests='', NULL, total_tests)  AS 'total_tests',
IF( total_tests_per_thousand='', NULL, total_tests_per_thousand)  AS 'total_tests_per_thousand',
IF( new_tests_per_thousand='', NULL, new_tests_per_thousand)  AS 'new_tests_per_thousand',
IF( new_tests_smoothed='', NULL, new_tests_smoothed)  AS 'new_tests_smoothed',
IF( new_tests_smoothed_per_thousand='', NULL, new_tests_smoothed_per_thousand)  AS 'new_tests_smoothed_per_thousand',
IF( tests_units='', NULL, tests_units)  AS 'tests_units',
dates, p.id_pais
FROM TEMPORAL T, PAIS P
WHERE T.locations=p.locations;

#116811 filas
INSERT INTO Rate(reproduction_rate,positive_rate,
test_per_case,excess_mortality,stringency_index, Fecha, id_Pais)
SELECT DISTINCT IF( reproduction_rate='', NULL, reproduction_rate)  AS 'reproduction_rate',
IF( positive_rate='', NULL, positive_rate)  AS 'positive_rate',
IF( tests_per_case='', NULL, tests_per_case)  AS 'tests_per_case',
IF( excess_mortality='', NULL, excess_mortality)  AS 'excess_mortality',
IF( stringency_index='', NULL, stringency_index)  AS 'stringency_index',
dates, p.id_pais
FROM TEMPORAL T, PAIS P
WHERE T.locations=p.locations;

#116811 filas
INSERT INTO DatosCasosEspeciales (cardiovasc_dath_rate,
dibetes_prevalence, female_smokers,male_smokers,
Fecha,id_Pais)
SELECT DISTINCT IF( cardiovasc_death_rate='', NULL, cardiovasc_death_rate)  AS 'cardiovasc_death_rate',
IF( diabetes_prevalence='', NULL, diabetes_prevalence)  AS 'diabetes_prevalence',
IF( female_smokers='', NULL, female_smokers)  AS 'female_smokers',
IF( male_smokers='', NULL, male_smokers)  AS 'male_smokers',
dates, p.id_pais
FROM TEMPORAL T, PAIS P
WHERE T.locations=p.locations;

#116811 filas
INSERT INTO DatosHospital (hosp_patients,hosp_patients_per_million,
weekly_hosp_admissions,weekly_hosp_admissions_per_million,
icu_patients, icu_patients_per_million,
weekly_icu_admissions_per_million, weekly_icu_admissions,
hospital_beds_per_thousand,
Fecha,id_Pais)
SELECT DISTINCT IF( hosp_patients='', NULL, hosp_patients)  AS 'hosp_patients',
IF( hosp_patients_per_million='', NULL, hosp_patients_per_million)  AS 'hosp_patients_per_million',
IF( weekly_hosp_admissions='', NULL, weekly_hosp_admissions)  AS 'weekly_hosp_admissions',
IF( weekly_hosp_admissions_per_million='', NULL, weekly_hosp_admissions_per_million)  AS 'weekly_hosp_admissions_per_million',
IF( icu_patients='', NULL, icu_patients)  AS 'icu_patients',
IF( icu_patients_per_million='', NULL, icu_patients_per_million)  AS 'icu_patients_per_million',
IF( weekly_icu_admissions_per_million='', NULL, weekly_icu_admissions_per_million)  AS 'weekly_icu_admissions_per_million',
IF( weekly_icu_admissions='', NULL, weekly_icu_admissions)  AS 'weekly_icu_admissions',
IF( hospital_beds_per_thousand='', NULL, hospital_beds_per_thousand)  AS 'hospital_beds_per_thousand',
dates, p.id_pais
FROM TEMPORAL T, PAIS P
WHERE T.locations=p.locations;

commit;



