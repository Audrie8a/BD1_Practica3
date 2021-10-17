use p3_bases1;

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


CREATE TABLE IF NOT EXISTS CONTINENTE(
    id_Continente INT PRIMARY KEY AUTO_INCREMENT,
    continent VARCHAR(15) NOT NULL
);



CREATE TABLE IF NOT EXISTS  PAIS(
    id_Pais INT PRIMARY KEY AUTO_INCREMENT,
    iso_code VARCHAR(15) NOT NULL,
    locations VARCHAR(100) NOT NULL,
    id_Continente INT NOT NULL,
    CONSTRAINT FK_Continente_Pais FOREIGN KEY (id_Continente) REFERENCES Continente(id_Continente)
);


CREATE TABLE IF NOT EXISTS  CASO(
    id_Casos INT PRIMARY KEY AUTO_INCREMENT,
    total_cases FLOAT NULL,
    new_cases   FLOAT  NULL,
    new_cases_smothed FLOAT NULL,
    total_cases_per_million FLOAT NULL,
    new_cases_per_million   FLOAT NULL,
    new_cases_soothed_per_million   FLOAT NULL,
    Fecha Date NOT NULL,
    id_Pais INT NOT NULL,
    CONSTRAINT FK_Pais_Caso FOREIGN KEY (id_Pais) REFERENCES Pais(id_Pais)
);


CREATE TABLE IF NOT EXISTS  DatosVacuna(
    id_DatosVacuna INT PRIMARY KEY AUTO_INCREMENT,
    total_vaccinations FLOAT NULL,
    people_vaccinated FLOAT NULL,
    people_fully_vaccinated FLOAT NULL,
    new_vacinations FLOAT NULL,
    new_vacinations_smoothed FLOAT NULL,
    total_vacinations_per_hundred FLOAT NULL,
    people_vaccinated_per_hundred FLOAT NULL,
    people_fully_vaccinated_per_hundred FLOAT NULL,
    new_vaccinations_smoothed_per_million FLOAT NULL,
    total_boosters FLOAT NULL,
    total_bossters_per_hundred FLOAT NULL,
    Fecha Date NOT NULL,
    id_Pais INT NOT NULL,
    CONSTRAINT FK_Pais_DatosVacuna FOREIGN KEY (id_Pais) REFERENCES Pais(id_Pais)
);

CREATE TABLE IF NOT EXISTS  DatosHospital(
    id_DatosHospital INT PRIMARY KEY AUTO_INCREMENT,
    hosp_patients FLOAT NULL,
    hosp_patients_per_million FLOAT NULL,
    weekly_hosp_admissions FLOAT NULL,
    weekly_hosp_admissions_per_million FLOAT NULL,
    icu_patients FLOAT NULL,
    icu_patients_per_million FLOAT NULL,
    weekly_icu_admissions_per_million FLOAT NULL,
    weekly_icu_admissions FLOAT NULL,
    hospital_beds_per_thousand FLOAT NULL,
    Fecha Date NOT NULL,
    id_Pais INT NOT NULL,
    CONSTRAINT FK_Pais_DatosHospital FOREIGN KEY (id_Pais) REFERENCES Pais(id_Pais)
);


CREATE TABLE IF NOT EXISTS  DatosCasosEspeciales(
    id_DatosCasosEspeciales INT PRIMARY KEY AUTO_INCREMENT,
    cardiovasc_dath_rate FLOAT NULL,
    dibetes_prevalence FLOAT NULL,
    female_smokers FLOAT NULL,
    male_smokers FLOAT NULL,
    Fecha Date NOT NULL,
    id_Pais INT NOT NULL,
    CONSTRAINT FK_Pais_DatosCasosEspeciales FOREIGN KEY (id_Pais) REFERENCES Pais(id_Pais)
);


CREATE TABLE IF NOT EXISTS  Rate(
    id_Rates INT PRIMARY KEY AUTO_INCREMENT,
    reproduction_rate FLOAT NULL,
    positive_rate FLOAT NULL,
    test_per_case FLOAT NULL,
    excess_mortality FLOAT NULL,
    stringency_index FLOAT NULL,
    Fecha Date NOT NULL,
    id_Pais INT NOT NULL,
    CONSTRAINT FK_Pais_Rates FOREIGN KEY (id_Pais) REFERENCES Pais(id_Pais)
);


CREATE TABLE IF NOT EXISTS  DatosTest(
    id_DatosTest INT PRIMARY KEY AUTO_INCREMENT,
    new_test FLOAT  NULL,
    total_test FLOAT  NULL,
    total_tests_per_thousan FLOAT NULL,
    new_tests_per_thousan FLOAT NULL,
    new_tests_smoothed FLOAT NULL,
    new_tests_smooted_per_thousan FLOAT NULL,
    tes_units  VARCHAR(15) NULL,
    Fecha Date NOT NULL,
    id_Pais INT NOT NULL,
    CONSTRAINT FK_Pais_DatosTest FOREIGN KEY (id_Pais) REFERENCES Pais(id_Pais)
);

    
CREATE TABLE IF NOT EXISTS  DatosPais(
    id_DatosPais INT PRIMARY KEY AUTO_INCREMENT,
    population INT NULL,
    populatino_density FLOAT NULL,
    extreme_proverty FLOAT NULL,
    life_expectancy FLOAT NULL,
    gdp_per_capita FLOAT NULL,
    human_development_index FLOAT NULL,
    median_age FLOAT NULL, 
    aged_65_older FLOAT NULL,
    aged_70_older FLOAT NULL,
    handwashing_facilities FLOAT NULL,
    Anio VARCHAR(4) NOT NULL,
    id_Pais INT NOT NULL,
    CONSTRAINT FK_Pais_DatosPais FOREIGN KEY (id_Pais) REFERENCES Pais(id_Pais)
);


CREATE TABLE IF NOT EXISTS  Muerte(
    id_Muerte INT PRIMARY KEY AUTO_INCREMENT,
    total_deaths FLOAT NULL,
    new_deaths FLOAT NULL,
    new_deaths_smoothed FLOAT NULL,
    total_deaths_per_million FLOAT NULL,
    new_deaths_per_million FLOAT NULL,
    new_deaths_smoothed_per_million FLOAT NULL,
    Fecha Date NOT NULL,
    id_Pais INT NOT NULL,
    CONSTRAINT FK_Pais_Muerte FOREIGN KEY (id_Pais) REFERENCES Pais(id_Pais)
);

commit;
