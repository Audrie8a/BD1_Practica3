drop TABLE TEMPORAL;

--TOTAL DATOS: 122380
CREATE TABLE TEMPORAL(
    iso_code VARCHAR2(150),
    continent VARCHAR2(150),
    locations VARCHAR2(150),
    dates VARCHAR2(150),
    total_cases VARCHAR2(150),
    new_cases VARCHAR2(150),
    new_cases_smoothed VARCHAR2(150),
    total_deaths VARCHAR2(150),
    new_deaths VARCHAR2(150),
    new_deaths_smoothed VARCHAR2(150),
    total_cases_per_million VARCHAR2(150),
    new_cases_per_million VARCHAR2(150),
    new_cases_smoothed_per_million VARCHAR2(150),
    total_deaths_per_million VARCHAR2(150),
    new_deaths_per_million VARCHAR2(150),
    new_deaths_smoothed_per_million VARCHAR2(150),
    reproduction_rate VARCHAR2(150),
    icu_patients VARCHAR2(150),
    icu_patients_per_million VARCHAR2(150),
    hosp_patients VARCHAR2(150),
    hosp_patients_per_million VARCHAR2(150),
    weekly_icu_admissions VARCHAR2(150),
    weekly_icu_admissions_per_million VARCHAR2(150),
    weekly_hosp_admissions VARCHAR2(150),
    weekly_hosp_admissions_per_million VARCHAR2(150),
    new_tests VARCHAR2(150),
    total_tests VARCHAR2(150),
    total_tests_per_thousand VARCHAR2(150),
    new_tests_per_thousand VARCHAR2(150),
    new_tests_smoothed VARCHAR2(150),
    new_tests_smoothed_per_thousand VARCHAR2(150),
    positive_rate VARCHAR2(150),
    tests_per_case VARCHAR2(150),
    tests_units VARCHAR2(150),
    total_vaccinations VARCHAR2(150),
    people_vaccinated VARCHAR2(150),
    people_fully_vaccinated VARCHAR2(150),
    total_boosters VARCHAR2(150),
    new_vaccinations VARCHAR2(150),
    new_vaccinations_smoothed VARCHAR2(150),
    total_vaccinations_per_hundred VARCHAR2(150),
    people_vaccinated_per_hundred VARCHAR2(150),
    people_fully_vaccinated_per_hundred VARCHAR2(150),
    total_boosters_per_hundred VARCHAR2(150),
    new_vaccinations_smoothed_per_million VARCHAR2(150),
    stringency_index VARCHAR2(150),
    population VARCHAR2(150),
    population_density VARCHAR2(150),
    median_age VARCHAR2(150),
    aged_65_older VARCHAR2(150),
    aged_70_older VARCHAR2(150),
    gdp_per_capita VARCHAR2(150),
    extreme_poverty VARCHAR2(150),
    cardiovasc_death_rate VARCHAR2(150),
    diabetes_prevalence VARCHAR2(150),
    female_smokers VARCHAR2(150),
    male_smokers VARCHAR2(150),
    handwashing_facilities VARCHAR2(150),
    hospital_beds_per_thousand VARCHAR2(150),
    life_expectancy VARCHAR2(150),
    human_development_index VARCHAR2(150),
    excess_mortality_cumulative_absolute VARCHAR2(150),
    excess_mortality_cumulative VARCHAR2(150),
    excess_mortality VARCHAR2(150),
    excess_mortality_cumulative_per_million VARCHAR2(150)
);


DROP SEQUENCE id_ContinenteSeq;
DROP SEQUENCE id_PaisSeq;
DROP SEQUENCE id_CasoSeq;
DROP SEQUENCE id_DatosVacunaSeq;
DROP SEQUENCE id_DatosHospitalSeq;
DROP SEQUENCE id_DatosCasosEspecialesSeq;
DROP SEQUENCE id_RatesSeq;
DROP SEQUENCE id_DatosTestSeq;
DROP SEQUENCE id_DatosPaisSeq;
DROP SEQUENCE id_MuerteSeq;

ALTER TABLE PAIS DROP CONSTRAINT FK_Continente_Pais;
ALTER TABLE CASO DROP CONSTRAINT FK_Pais_Caso;
ALTER TABLE DatosVacuna DROP CONSTRAINT FK_Pais_DatosVacuna ;
ALTER TABLE DatosHospital DROP CONSTRAINT FK_Pais_DatosHospital;
ALTER TABLE DatosCasosEspeciales DROP CONSTRAINT FK_Pais_DatosCasosEspeciales;
ALTER TABLE Rate DROP CONSTRAINT FK_Pais_Rates;
ALTER TABLE DatosTest DROP CONSTRAINT FK_Pais_DatosTest;
ALTER TABLE DatosPais DROP CONSTRAINT FK_Pais_DatosPais;
ALTER TABLE Muerte DROP CONSTRAINT FK_Pais_Muerte;

DROP TABLE CONTINENTE;
DROP TABLE PAIS;
DROP TABLE CASO;
DROP TABLE DatosVacuna;
DROP TABLE DatosHospital;
DROP TABLE DatosCasosEspeciales;
DROP TABLE Rate;
DROP TABLE DatosTest;
DROP TABLE DatosPais;
DROP TABLE Muerte;

CREATE SEQUENCE id_ContinenteSeq START WITH 1 INCREMENT BY 1;
CREATE TABLE CONTINENTE(
    id_Continente NUMBER DEFAULT id_ContinenteSeq.NEXTVAL,
    continent VARCHAR2(15) NOT NULL,
    PRIMARY KEY (id_Continente)
);


CREATE SEQUENCE id_PaisSeq START WITH 1 INCREMENT BY 1; 
CREATE TABLE PAIS(
    id_Pais NUMBER DEFAULT id_PaisSeq.NEXTVAL,
    iso_code VARCHAR2(15) NOT NULL,
    locations VARCHAR2(100) NOT NULL,
    id_Continente NUMBER NOT NULL,
    PRIMARY KEY (id_Pais),
    CONSTRAINT FK_Continente_Pais FOREIGN KEY (id_Continente) REFERENCES Continente(id_Continente)
);

CREATE SEQUENCE id_CasoSeq START WITH 1 INCREMENT BY 1;
CREATE TABLE CASO(
    id_Casos NUMBER DEFAULT id_CasoSeq.NEXTVAL,
    total_cases NUMBER (17,1) NULL,
    new_cases   NUMBER (17,1) NULL,
    new_cases_smothed NUMBER(17,4) NULL,
    total_cases_per_million NUMBER(17,4) NULL,
    new_cases_per_million   NUMBER(17,4) NULL,
    new_cases_soothed_per_million   NUMBER(17,4) NULL,
    Fecha Date NOT NULL,
    id_Pais NUMBER NOT NULL,
    PRIMARY KEY (id_Casos),
    CONSTRAINT FK_Pais_Caso FOREIGN KEY (id_Pais) REFERENCES Pais(id_Pais)
);

CREATE SEQUENCE id_DatosVacunaSeq START WITH 1 INCREMENT BY 1;
CREATE TABLE DatosVacuna(
    id_DatosVacuna NUMBER DEFAULT id_DatosVacunaSeq.NEXTVAL,
    total_vaccinations NUMBER(17,1) NULL,
    people_vaccinated NUMBER(17,4) NULL,
    people_fully_vaccinated NUMBER(17,4) NULL,
    new_vacinations NUMBER (17,1)NULL,
    new_vacinations_smoothed NUMBER(17,4) NULL,
    total_vacinations_per_hundred NUMBER(17,4) NULL,
    people_vaccinated_per_hundred NUMBER(17,4) NULL,
    people_fully_vaccinated_per_hundred NUMBER(17,4) NULL,
    new_vaccinations_smoothed_per_million NUMBER(17,4) NULL,
    total_boosters NUMBER(17,4) NULL,
    total_bossters_per_hundred NUMBER(17,4) NULL,
    Fecha Date NOT NULL,
    id_Pais NUMBER NOT NULL,
    PRIMARY KEY (id_DatosVacuna),
    CONSTRAINT FK_Pais_DatosVacuna FOREIGN KEY (id_Pais) REFERENCES Pais(id_Pais)
);

CREATE SEQUENCE id_DatosHospitalSeq START WITH 1 INCREMENT BY 1;
CREATE TABLE DatosHospital(
    id_DatosHospital NUMBER  DEFAULT id_DatosHospitalSeq.NEXTVAL,
    hosp_patients NUMBER(17,4) NULL,
    hosp_patients_per_million NUMBER(17,4) NULL,
    weekly_hosp_admissions NUMBER(17,4) NULL,
    weekly_hosp_admissions_per_million NUMBER(17,4) NULL,
    icu_patients NUMBER(17,4) NULL,
    icu_patients_per_million NUMBER(17,4) NULL,
    weekly_icu_admissions_per_million NUMBER(17,4) NULL,
    weekly_icu_admissions NUMBER(17,4) NULL,
    hospital_beds_per_thousand NUMBER(17,4) NULL,
    Fecha Date NOT NULL,
    id_Pais NUMBER NOT NULL,
    PRIMARY KEY (id_DatosHospital),
    CONSTRAINT FK_Pais_DatosHospital FOREIGN KEY (id_Pais) REFERENCES Pais(id_Pais)
);

CREATE SEQUENCE id_DatosCasosEspecialesSeq START WITH 1 INCREMENT BY 1;
CREATE TABLE DatosCasosEspeciales(
    id_DatosCasosEspeciales NUMBER DEFAULT id_DatosCasosEspecialesSeq.NEXTVAL,
    cardiovasc_dath_rate NUMBER(17,4) NULL,
    dibetes_prevalence NUMBER(17,4) NULL,
    female_smokers NUMBER(17,4) NULL,
    male_smokers NUMBER(17,4) NULL,
    Fecha Date NOT NULL,
    id_Pais NUMBER NOT NULL,
    PRIMARY KEY (id_DatosCasosEspeciales),
    CONSTRAINT FK_Pais_DatosCasosEspeciales FOREIGN KEY (id_Pais) REFERENCES Pais(id_Pais)
);

CREATE SEQUENCE id_RatesSeq START WITH 1 INCREMENT BY 1;
CREATE TABLE Rate(
    id_Rates NUMBER DEFAULT id_RatesSeq.NEXTVAL,
    reproduction_rate NUMBER(17,4) NULL,
    positive_rate NUMBER(17,4) NULL,
    test_per_case NUMBER(17,4) NULL,
    excess_mortality NUMBER(17,4) NULL,
    stringency_index NUMBER(17,4) NULL,
    Fecha Date NOT NULL,
    id_Pais NUMBER NOT NULL,
    PRIMARY KEY (id_Rates),
    CONSTRAINT FK_Pais_Rates FOREIGN KEY (id_Pais) REFERENCES Pais(id_Pais)
);

CREATE SEQUENCE id_DatosTestSeq START WITH 1 INCREMENT BY 1;
CREATE TABLE DatosTest(
    id_DatosTest NUMBER DEFAULT id_DatosTestSeq.NEXTVAL,
    new_test NUMBER (17,1) NULL,
    total_test NUMBER (17,1) NULL,
    total_tests_per_thousan NUMBER(17,4) NULL,
    new_tests_per_thousan NUMBER(17,4) NULL,
    new_tests_smoothed NUMBER(17,4) NULL,
    new_tests_smooted_per_thousan NUMBER(17,4) NULL,
    tes_units  VARCHAR2(15) NULL,
    Fecha Date NOT NULL,
    id_Pais NUMBER NOT NULL,
    PRIMARY KEY (id_DatosTest),
    CONSTRAINT FK_Pais_DatosTest FOREIGN KEY (id_Pais) REFERENCES Pais(id_Pais)
);

CREATE SEQUENCE id_DatosPaisSeq START WITH 1 INCREMENT BY 1;    
CREATE TABLE DatosPais(
    id_DatosPais NUMBER DEFAULT id_DatosPaisSeq.NEXTVAL,
    population NUMBER NULL,
    populatino_density NUMBER(17,4) NULL,
    extreme_proverty NUMBER(17,4) NULL,
    life_expectancy NUMBER(17,4) NULL,
    gdp_per_capita NUMBER(17,4) NULL,
    human_development_index NUMBER(17,4) NULL,
    median_age NUMBER(17,4) NULL, 
    aged_65_older NUMBER(17,4) NULL,
    aged_70_older NUMBER(17,4) NULL,
    handwashing_facilities NUMBER(17,4) NULL,
    Anio VARCHAR2(4) NOT NULL,
    id_Pais NUMBER NOT NULL,
    PRIMARY KEY (id_DatosPais),
    CONSTRAINT FK_Pais_DatosPais FOREIGN KEY (id_Pais) REFERENCES Pais(id_Pais)
);

CREATE SEQUENCE id_MuerteSeq START WITH 1 INCREMENT BY 1;
CREATE TABLE Muerte(
    id_Muerte NUMBER DEFAULT id_MuerteSeq.NEXTVAL,
    total_deaths NUMBER(17,0) NULL,
    new_deaths NUMBER(17,0) NULL,
    new_deaths_smoothed NUMBER(17,4) NULL,
    total_deaths_per_million NUMBER(17,4) NULL,
    new_deaths_per_million NUMBER(17,4) NULL,
    new_deaths_smoothed_per_million NUMBER(17,4) NULL,
    Fecha Date NOT NULL,
    id_Pais NUMBER NOT NULL,
    PRIMARY KEY (id_Muerte),
    CONSTRAINT FK_Pais_Muerte FOREIGN KEY (id_Pais) REFERENCES Pais(id_Pais)
);

commit;