set serveroutput on;


--1. Consulta que agrupe la cantidad actual de contagios por pa�s.
SELECT p.locations,MAX(c.total_cases)*10 TOTAL,EXTRACT( YEAR FROM c.fecha) ANIO
FROM PAIS P, CASO C
WHERE p.id_pais=c.id_pais
AND EXTRACT( YEAR FROM c.fecha)=(SELECT MAX(EXTRACT( YEAR FROM C2.fecha)) FROM CASO C2)
AND EXTRACT( MONTH FROM c.fecha)=(SELECT MAX(EXTRACT( MONTH FROM C3.fecha)) FROM CASO C3 WHERE EXTRACT( YEAR FROM c3.fecha)=(SELECT MAX(EXTRACT( YEAR FROM C4.fecha)) FROM CASO C4))
GROUP BY p.locations, EXTRACT( YEAR FROM c.fecha)
ORDER BY p.locations;


--2. Funci�n o m�todo que reciba el nombre del pa�s 
--y nos muestre el acumulado mensual de infectados, muertes y vacunados

CREATE OR REPLACE FUNCTION Consulta2 (nombre in Pais.locations%TYPE)
RETURN sys_refcursor 
IS
res sys_refcursor;
BEGIN
    OPEN res FOR 
    SELECT EXTRACT( MONTH FROM C.fecha) MES, 
    CASE WHEN SUM(C.new_cases)IS NULL THEN 0 ELSE SUM(C.new_cases)*10 END TotalCasos,
    CASE WHEN SUM(M.new_deaths)IS NULL THEN 0 ELSE SUM(M.new_deaths)*10  END TotalMuertes,
    CASE WHEN SUM(dv.new_vacinations) IS NULL THEN 0 ELSE SUM(DV.new_vacinations)*10 END TotalVacunados,
    EXTRACT( YEAR FROM C.fecha) ANIO
    FROM  PAIS P, MUERTE M, DatosVacuna DV, CASO C
    WHERE p.id_pais=m.id_pais
    AND P.id_pais=dv.id_pais
    AND p.id_pais=c.id_pais
    AND m.fecha=dv.fecha
    AND m.fecha=c.fecha
    AND dv.fecha=C.fecha
    AND P.locations=nombre
    GROUP BY EXTRACT( MONTH FROM M.fecha), EXTRACT( MONTH FROM DV.fecha),
    EXTRACT( MONTH FROM C.fecha),EXTRACT( YEAR FROM C.fecha)
    ORDER BY EXTRACT( YEAR FROM C.fecha),EXTRACT( MONTH FROM M.fecha), EXTRACT( MONTH FROM DV.fecha),EXTRACT( MONTH FROM C.fecha) asc;
    RETURN res;
END;

SELECT Consulta2('Argentina') FROM DUAL;

--3. Consulta que agrupe la cantidad actual de contagios de los �ltimos 3 meses 
--por continente.

SELECT  c.continent CONTINENTE, SUM(CA.NEW_CASES*10) CONTAGIOS
FROM CASO CA, PAIS P, CONTINENTE C
WHERE c.id_continente=p.id_continente
AND P.id_Pais=CA.id_pais
AND EXTRACT( MONTH FROM CA.fecha) >=(SELECT MAX(EXTRACT( MONTH FROM C2.fecha)) FROM CASO C2 WHERE EXTRACT( YEAR FROM C2.fecha)=(SELECT MAX(EXTRACT( YEAR FROM C3.fecha)) FROM CASO C3))-2
AND EXTRACT( YEAR FROM CA.fecha)=(SELECT MAX(EXTRACT( YEAR FROM C2.fecha)) FROM CASO C2)
GROUP BY c.continent
ORDER BY c.continent ASC
;

--4. Funci�n o m�todo muestre los pa�ses con mayor aceleraci�n de contagios 
--durante el mes de diciembre 2020 y enero 2021.
CREATE OR REPLACE FUNCTION Consulta4 
RETURN sys_refcursor 
IS
res sys_refcursor;
BEGIN
    OPEN res FOR 
    SELECT * FROM (
    SELECT p.locations PAIS, AVG(C.new_cases*10) Prom_NuevosCasos
    FROM PAIS P, CASO C
    WHERE p.id_pais=c.id_pais
    AND substr(FECHA,4) IN ('12/20','01/21')
    GROUP BY p.locations
    ORDER BY AVG(C.new_cases) desc)
    WHERE ROWNUM <=10;
    RETURN res;
END;

SELECT Consulta4() FROM DUAL;




--5. Promedio contagios durante el primer trimestre de la pandemia.

SELECT AVG(SUM(c.new_cases)*10) Prom_Primer_Trimestre
FROM PAIS P, CASO C
WHERE p.id_pais=c.id_pais
AND EXTRACT( MONTH FROM C.fecha) IN (
    (SELECT MIN(EXTRACT( MONTH FROM C2.fecha))FROM CASO C2),
    (SELECT MIN(EXTRACT( MONTH FROM C2.fecha)) FROM CASO C2)+1,
    (SELECT MIN(EXTRACT( MONTH FROM C2.fecha))FROM CASO C2)+2
    )
AND EXTRACT( YEAR FROM C.fecha)=(SELECT MIN(EXTRACT( YEAR FROM C3.fecha))FROM CASO C3)
GROUP BY P.locations;

SELECT AVG(SUM(C.new_cases)*10)
FROM PAIS P, CASO C
WHERE p.id_pais=c.id_pais
AND EXTRACT( MONTH FROM C.fecha) IN (
    (SELECT MIN(EXTRACT( MONTH FROM C2.fecha))FROM CASO C2),
    (SELECT MIN(EXTRACT( MONTH FROM C2.fecha)) FROM CASO C2)+1,
    (SELECT MIN(EXTRACT( MONTH FROM C2.fecha))FROM CASO C2)+2
    )
AND EXTRACT( YEAR FROM C.fecha)=(SELECT MIN(EXTRACT( YEAR FROM C3.fecha))FROM CASO C3)
GROUP BY p.locations ;

--6. Funci�n o m�todo que reciba un rango de infectados por d�a
--y devuelva los pa�ses que en alg�n momento tuvieron ese rango, 
--con su fecha correspondiente.

CREATE OR REPLACE FUNCTION Consulta6(limite1 number, limite2 number)
RETURN sys_refcursor 
IS
fech date;
cas NUMBER(17,4);
res sys_refcursor;
BEGIN    
    DBMS_OUTPUT.PUT_LINE ('Pais --> '|| 'Fecha --> ' || 'Contagios');
    FOR ITEM IN (SELECT distinct p.locations
    FROM Pais P, Caso C
    WHERE p.id_pais=c.id_pais
    AND c.new_cases >= limite1
    AND c.new_cases<=limite2
    GROUP BY p.locations
    ORDER BY p.locations asc)
    
    LOOP
        --OPEN res FOR
        SELECT fecha, new_cases into fech, cas  FROM (
        SELECT p.locations, c.fecha, c.new_cases
        FROM Pais P, Caso C
        WHERE p.locations=ITEM.locations
        AND c.new_cases >= limite1
        AND c.new_cases<=limite2
        ) WHERE ROWNUM=1;
        
        DBMS_OUTPUT.PUT_LINE (ITEM.locations ||' --> '|| fech ||' --> ' || cas);
    END LOOP;
    return res;
END;

SELECT Consulta6(15,200) FROM DUAL;


--7. Funci�n o m�todo que muestre al top 10 de pa�ses con mayor cantidad de pruebas

CREATE OR REPLACE FUNCTION Consulta7
RETURN sys_refcursor 
IS
res sys_refcursor;
BEGIN
    OPEN res FOR 
    SELECT * FROM (
    SELECT  p.locations, MAX(dt.total_test) Total_Pruebas
    FROM PAIS P, DatosTest DT
    WHERE p.id_pais=dt.id_pais
    GROUP BY p.locations
    ORDER BY MAX(dt.total_test) DESC)
    WHERE ROWNUM <=10;
    RETURN res;
END;

SELECT Consulta7() FROM DUAL;

SELECT * FROM (
    SELECT  p.locations, sum(dt.new_test*10)Total_Pruebas
    FROM PAIS P, DatosTest DT
    WHERE p.id_pais=dt.id_pais
    GROUP BY p.locations
    ORDER BY sum(dt.new_test) DESC)
    WHERE ROWNUM <=10;

--8. Funci�n o m�todo que reciba la fecha como par�metro 
--y que muestre el pa�s que reporto m�s muertes en ese d�a.

CREATE OR REPLACE FUNCTION Consulta8 (fech in muerte.fecha%TYPE)
RETURN sys_refcursor 
IS
res sys_refcursor;
BEGIN
    OPEN res FOR 
    SELECT * FROM (
    SELECT p.locations, MAX(M.new_deaths)*10 Total_Muertes_Dia
    FROM PAIS P, MUERTE M
    WHERE p.id_pais=m.id_pais
    AND m.fecha=fech
    GROUP BY p.locations
    ORDER BY MAX(m.new_deaths) DESC
    ) WHERE ROWNUM =1;
    RETURN res;
END;

SELECT Consulta8('13/09/21') FROM DUAL;


--9. Consulta que muestre los datos de Guatemala para un rango de fechas especifico.

SELECT P.locations,SUM(C.new_cases*10)Nuevos_Casos,MAX(C.total_cases*10) Total_Nuevos_Casos,
SUM(dv.new_vacinations*10) Nuevas_Vacunas,MAX(dv.total_vaccinations*10) Total_Nuevas_Vacunas,
SUM (M.new_deaths*10) Nuevas_Muertes, MAX(M.total_deaths*10)Total_Muertes
FROM PAIS P, CASO C, datosvacuna DV, MUERTE M
WHERE p.id_pais=c.id_pais
AND P.id_Pais=DV.id_Pais
AND P.id_Pais=M.id_Pais
AND C.Fecha=DV.Fecha
AND C.Fecha= M.Fecha
And M.Fecha=DV.Fecha
AND P.locations='Guatemala'
and C.Fecha>='31/01/20'
and C.Fecha<='13/10/21'
Group by P.locations;

--10. Consulta que muestre los pa�ses de Latinoam�rica ordenados de los m�s infectados a los menos infectados para un rango de fechas en espec�fico.
select P.locations, sum(c.new_cases)*10  TotalCasos
from Pais  P, Caso C
where P.id_Pais=C.id_Pais
and P.locations in ('Argentina', 'Bolivia', 'Brazil','Chile', 'Colombia', 'Costa Rica', 'Cuba', 'Ecuador', 'El Salvador', 'Guayana', 'Grenada', 'Guatemala', 'Haiti', 'Honduras','Jamaica',
'Mexico','Nicaragua', 'Paraguay', 'Panama', 'Peru', 'Puerto Rico', 'Dominican Republic', 'Suriname', 'Uruguay', 'Venezuela')
and C.Fecha>'31/01/20'
and C.Fecha<'13/10/21'
group by P.locations
order by  sum(C.new_cases) desc;