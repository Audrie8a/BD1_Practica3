
--6 filas
INSERT INTO CONTINENTE (continent) 
SELECT DISTINCT  continent from TEMPORAL where (continent IS NOT NULL);


--224 filas
INSERT INTO PAIS (iso_code, locations, id_Continente)
SELECT DISTINCT T.iso_code, t.locations, C.id_Continente
FROM TEMPORAL T, CONTINENTE  C
WHERE T.continent =C.continent;


--118554 filas
INSERT INTO Muerte (total_deaths, new_deaths, new_deaths_smoothed,
total_deaths_per_million,new_deaths_per_million, 
new_deaths_smoothed_per_million, Fecha, id_Pais)
SELECT DISTINCT CASE WHEN TO_NUMBER(t.total_deaths,'99999999999999999.0')IS NOT NULL  THEN TO_NUMBER(t.total_deaths,'99999999999999999.0') ELSE 0 END,
CASE WHEN TO_NUMBER(T.new_deaths,'99999999999999999.0') IS NOT NULL THEN TO_NUMBER(T.new_deaths,'99999999999999999.9') ELSE 0 END, 
TO_NUMBER(t.new_deaths_smoothed,'99999999999999999.9999'),TO_NUMBER(t.total_deaths_per_million,'99999999999999999.9999'), 
TO_NUMBER(t.new_deaths_per_million,'99999999999999999.9999'),TO_NUMBER(t.new_deaths_smoothed_per_million,'99999999999999999.9999'), 
TO_DATE(t.dates,'YY/MM/DD'), p.id_pais
FROM TEMPORAL T, PAIS P
WHERE T.locations=p.locations;

--SELECT COUNT(*) FROM(SELECT distinct locations, total_deaths, dates FROM TEMPORAL WHERE locations is not null);

--118554 filas
INSERT INTO CASO (total_cases,new_cases,new_cases_smothed,total_cases_per_million,
new_cases_per_million, new_cases_soothed_per_million, Fecha,  id_Pais)
SELECT DISTINCT CASE WHEN TO_NUMBER(T.total_cases ,'99999999999999999.9') IS NOT NULL THEN TO_NUMBER(T.total_cases ,'99999999999999999.9') ELSE 0 END,
CASE WHEN TO_NUMBER(T.new_cases,'99999999999999999.9')  IS NOT NULL THEN TO_NUMBER(T.new_cases,'99999999999999999.9') ELSE 0 END,
TO_NUMBER(T.new_cases_smoothed,'99999999999999999.9999'), 
TO_NUMBER(T.total_cases_per_million,'99999999999999999.9999'), TO_NUMBER(T.new_cases_per_million,'99999999999999999.9999'),
TO_NUMBER(T.new_cases_smoothed_per_million,'99999999999999999.9999'),
TO_DATE(t.dates,'YY/MM/DD'), p.id_pais
FROM TEMPORAL T, PAIS P
WHERE T.locations=p.locations;

--118554
INSERT INTO DatosVacuna (total_vaccinations,people_vaccinated,people_fully_vaccinated,
new_vacinations,new_vacinations_smoothed,total_vacinations_per_hundred,
people_vaccinated_per_hundred,people_fully_vaccinated_per_hundred,
new_vaccinations_smoothed_per_million,total_boosters,total_bossters_per_hundred,
Fecha, id_Pais)
SELECT DISTINCT CASE WHEN TO_NUMBER(T.total_vaccinations ,'99999999999999999.9') IS NOT NULL THEN TO_NUMBER(T.total_vaccinations ,'99999999999999999.9') ELSE 0 END,
TO_NUMBER(T.people_vaccinated,'99999999999999999.9999'),
TO_NUMBER(T.people_fully_vaccinated,'99999999999999999.9999'),
CASE WHEN TO_NUMBER(T.new_vaccinations ,'99999999999999999.9') IS NOT NULL THEN TO_NUMBER(T.new_vaccinations ,'99999999999999999.9') ELSE 0 END,
TO_NUMBER(T.new_vaccinations_smoothed,'99999999999999999.9999'),TO_NUMBER(T.total_vaccinations_per_hundred,'99999999999999999.9999'), 
TO_NUMBER(T.people_vaccinated_per_hundred,'99999999999999999.9999'),TO_NUMBER(T.people_fully_vaccinated_per_hundred,'99999999999999999.9999'),
TO_NUMBER(T.new_vaccinations_smoothed_per_million,'99999999999999999.9999'),
TO_NUMBER(T.total_boosters,'99999999999999999.9999'),TO_NUMBER(T.total_boosters_per_hundred,'99999999999999999.9999'),
TO_DATE(t.dates,'YY/MM/DD'), p.id_pais
FROM TEMPORAL T, PAIS P
WHERE T.locations=p.locations;

--415 filas
INSERT INTO DatosPais(population,populatino_density,extreme_proverty,
life_expectancy,gdp_per_capita,human_development_index,median_age,
aged_65_older,aged_70_older,handwashing_facilities,Anio,id_Pais)
SELECT DISTINCT TO_NUMBER(T.population,'99999999999999999.9999'),TO_NUMBER(T.population_density,'99999999999999999.9999'),
TO_NUMBER(T.extreme_poverty,'99999999999999999.9999'),TO_NUMBER(T.life_expectancy,'99999999999999999.9999'),
TO_NUMBER(T.gdp_per_capita,'99999999999999999.9999'), TO_NUMBER(T.human_development_index,'99999999999999999.9999'),
TO_NUMBER(T.median_age,'99999999999999999.9999'),TO_NUMBER(T.aged_65_older,'99999999999999999.9999'),
TO_NUMBER(T.aged_70_older,'99999999999999999.9999'),TO_NUMBER(T.handwashing_facilities,'99999999999999999.9999'),
EXTRACT( YEAR FROM TO_DATE(t.dates,'YY/MM/DD')), p.id_pais
FROM TEMPORAL T, PAIS P
WHERE T.locations=p.locations;

--118554 filas
INSERT INTO DatosTest(new_test,total_test,total_tests_per_thousan,
new_tests_per_thousan, new_tests_smoothed,new_tests_smooted_per_thousan,
tes_units,Fecha,id_Pais)
SELECT DISTINCT  CASE WHEN  TO_NUMBER(T.new_tests ,'99999999999999999.9') IS NOT NULL THEN TO_NUMBER(T.new_tests ,'99999999999999999.9') ELSE 0 END , 
 CASE WHEN  TO_NUMBER(T.total_tests ,'99999999999999999.9') IS NOT NULL THEN  TO_NUMBER(T.total_tests ,'99999999999999999.9') ELSE 0 END,
TO_NUMBER(T.total_tests_per_thousand,'99999999999999999.9999'),
TO_NUMBER(T.new_tests_per_thousand,'99999999999999999.9999'),  
TO_NUMBER(T.new_tests_smoothed,'99999999999999999.9999'), 
TO_NUMBER(T.new_tests_smoothed_per_thousand,'99999999999999999.9999'),
 T.tests_units ,
TO_DATE(t.dates,'YY/MM/DD'), p.id_pais
FROM TEMPORAL T, PAIS P
WHERE T.locations=p.locations;

--118554 filas
INSERT INTO Rate(reproduction_rate,positive_rate,
test_per_case,excess_mortality,stringency_index, Fecha, id_Pais)
SELECT DISTINCT TO_NUMBER(T.reproduction_rate,'99999999999999999.9999'), TO_NUMBER(T.positive_rate,'99999999999999999.9999'),
TO_NUMBER(T.tests_per_case,'99999999999999999.9999'), TO_NUMBER(T.excess_mortality,'99999999999999999.9999'),
TO_NUMBER(T.stringency_index,'99999999999999999.9999'),
TO_DATE(t.dates,'YY/MM/DD'), p.id_pais
FROM TEMPORAL T, PAIS P
WHERE T.locations=p.locations;

--118554 filas
INSERT INTO DatosCasosEspeciales (cardiovasc_dath_rate,
dibetes_prevalence, female_smokers,male_smokers,
Fecha,id_Pais)
SELECT DISTINCT TO_NUMBER(T.cardiovasc_death_rate,'99999999999999999.9999'), TO_NUMBER(T.diabetes_prevalence,'99999999999999999.9999'),
TO_NUMBER(T.female_smokers,'99999999999999999.9999'), TO_NUMBER(T.male_smokers,'99999999999999999.9999'),
TO_DATE(t.dates,'YY/MM/DD'), p.id_pais
FROM TEMPORAL T, PAIS P
WHERE T.locations=p.locations;

--118554 filas
INSERT INTO DatosHospital (hosp_patients,hosp_patients_per_million,
weekly_hosp_admissions,weekly_hosp_admissions_per_million,
icu_patients, icu_patients_per_million,
weekly_icu_admissions_per_million, weekly_icu_admissions,
hospital_beds_per_thousand,
Fecha,id_Pais)
SELECT DISTINCT TO_NUMBER(T.hosp_patients,'99999999999999999.9999'),TO_NUMBER(T.hosp_patients_per_million,'99999999999999999.9999'),
TO_NUMBER(T.weekly_hosp_admissions,'99999999999999999.9999'), TO_NUMBER(T.weekly_hosp_admissions_per_million,'99999999999999999.9999'),
TO_NUMBER(T.icu_patients,'99999999999999999.9999'), TO_NUMBER(T.icu_patients_per_million,'99999999999999999.9999'),
TO_NUMBER(T.weekly_icu_admissions_per_million,'99999999999999999.9999'), TO_NUMBER(T.weekly_icu_admissions,'99999999999999999.9999'),
TO_NUMBER(T.hospital_beds_per_thousand,'99999999999999999.9999'),
TO_DATE(t.dates,'YY/MM/DD'), p.id_pais
FROM TEMPORAL T, PAIS P
WHERE T.locations=p.locations;

commit;



