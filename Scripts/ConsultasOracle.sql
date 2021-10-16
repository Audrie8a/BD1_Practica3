set serveroutput on;


--1. Consulta que agrupe la cantidad actual de contagios por país.
SELECT p.locations,SUM(c.new_cases)*10 TOTAL,EXTRACT( YEAR FROM c.fecha) ANIO
FROM PAIS P, CASO C
WHERE p.id_pais=c.id_pais
AND EXTRACT( YEAR FROM c.fecha)=(SELECT MAX(EXTRACT( YEAR FROM C2.fecha)) FROM CASO C2)
AND EXTRACT( MONTH FROM c.fecha)=(SELECT MAX(EXTRACT( MONTH FROM C3.fecha)) FROM CASO C3 WHERE EXTRACT( YEAR FROM c3.fecha)=(SELECT MAX(EXTRACT( YEAR FROM C4.fecha)) FROM CASO C4))
GROUP BY p.locations, EXTRACT( YEAR FROM c.fecha)
ORDER BY p.locations;


--2. Función o método que reciba el nombre del país 
--y nos muestre el acumulado mensual de infectados, muertes y vacunados

CREATE OR REPLACE FUNCTION Consulta2 (nombre in Pais.locations%TYPE)
RETURN sys_refcursor 
IS
res sys_refcursor;
BEGIN
    OPEN res FOR 
    SELECT EXTRACT( MONTH FROM C.fecha) MES, 
    CASE WHEN MAX(C.total_cases)IS NULL THEN 0 ELSE MAX(C.total_cases)*10 END TotalCasos,
    CASE WHEN MAX(M.total_deaths)IS NULL THEN 0 ELSE MAX(M.total_deaths)*10  END TotalMuertes,
    CASE WHEN MAX(DV.total_vaccinations) IS NULL THEN 0 ELSE MAX(DV.total_vaccinations)*10 END TotalVacunados,
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

SELECT Consulta2('Guatemala') FROM DUAL;

--3. Consulta que agrupe la cantidad actual de contagios de los últimos 3 meses 
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

--4. Función o método muestre los países con mayor aceleración de contagios 
--durante el mes de diciembre 2020 y enero 2021.
CREATE OR REPLACE FUNCTION Consulta4 
RETURN sys_refcursor 
IS
res sys_refcursor;
BEGIN
    OPEN res FOR 
    SELECT *FROM (
    SELECT p.locations PAIS, AVG(C.new_cases) Prom_NuevosCasos
    FROM PAIS P, CASO C
    WHERE p.id_pais=c.id_pais
    AND substr(FECHA,4)='12/20'
    OR substr(FECHA,4)='01/21'
    GROUP BY p.locations
    ORDER BY SUM(C.new_cases) desc)
    WHERE ROWNUM <=10;
    RETURN res;
END;

SELECT Consulta4() FROM DUAL;




--5. Promedio contagios durante el primer trimestre de la pandemia.

SELECT AVG(SUM(C.total_cases)) Prom_Primer_Trimestre
FROM PAIS P, CASO C
WHERE p.id_pais=c.id_pais
AND EXTRACT( MONTH FROM C.fecha) IN (
    (SELECT MIN(EXTRACT( MONTH FROM C2.fecha))FROM CASO C2),
    (SELECT MIN(EXTRACT( MONTH FROM C2.fecha))FROM CASO C2)+1,
    (SELECT MIN(EXTRACT( MONTH FROM C2.fecha))FROM CASO C2)+2
    )
AND EXTRACT( YEAR FROM C.fecha)=(SELECT MIN(EXTRACT( YEAR FROM C3.fecha))FROM CASO C3)
GROUP BY P.locations;



--6. Función o método que reciba un rango de infectados por día
--y devuelva los países que en algún momento tuvieron ese rango, 
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


--7. Función o método que muestre al top 10 de países con mayor cantidad de pruebas

CREATE OR REPLACE FUNCTION Consulta7
RETURN sys_refcursor 
IS
res sys_refcursor;
BEGIN
    OPEN res FOR 
    SELECT * FROM (
    SELECT  p.locations, MAX(dt.total_test)Total_Pruebas
    FROM PAIS P, DatosTest DT
    WHERE p.id_pais=dt.id_pais
    GROUP BY p.locations
    ORDER BY MAX(dt.total_test) DESC)
    WHERE ROWNUM <=10;
    RETURN res;
END;

SELECT Consulta7() FROM DUAL;

--8. Función o método que reciba la fecha como parámetro 
--y que muestre el país que reporto más muertes en ese día.

CREATE OR REPLACE FUNCTION Consulta8 (fech in muerte.fecha%TYPE)
RETURN sys_refcursor 
IS
res sys_refcursor;
BEGIN
    OPEN res FOR 
    SELECT * FROM (
    SELECT p.locations, MAX(M.new_deaths)
    FROM PAIS P, MUERTE M
    WHERE p.id_pais=m.id_pais
    AND m.fecha=fech
    GROUP BY p.locations
    ORDER BY MAX(m.new_deaths) DESC
    ) WHERE ROWNUM =1;
    RETURN res;
END;

SELECT Consulta8('13/09/21') FROM DUAL;

SELECT locations,MAX(new_deaths)
FROM TEMPORAL
WHERE dates='2021-09-13'
GROUP BY locations
ORDER BY MAX(new_deaths) desc;


SELECT p.locations, MAX(M.new_deaths)
    FROM PAIS P, MUERTE M
    WHERE p.id_pais=m.id_pais
    AND m.fecha='13/09/21'
    GROUP BY p.locations
    ORDER BY MAX(m.new_deaths) DESC;
    
--9. Consulta que muestre los datos de Guatemala para un rango de fechas especifico.
--10. Consulta que muestre los países de Latinoamérica ordenados de los más infectados a los menos infectados para un rango de fechas en específico.