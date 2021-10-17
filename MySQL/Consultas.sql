#1. Consulta que agrupe la cantidad actual de contagios por país.
SELECT p.locations,MAX(c.total_cases)*10 TOTAL,( SELECT YEAR (c.fecha)) ANIO
FROM PAIS P, CASO C
WHERE p.id_pais=c.id_pais
AND ( YEAR (c.fecha))=(SELECT MAX( YEAR (C2.fecha)) FROM CASO C2)
AND ( YEAR (c.fecha))=(SELECT MAX( YEAR (C3.fecha)) FROM CASO C3 WHERE ( YEAR (c3.fecha))=(SELECT MAX( YEAR (C4.fecha)) FROM CASO C4))
GROUP BY p.locations, (SELECT YEAR (c.fecha))
ORDER BY p.locations;


#2. Función o método que reciba el nombre del país 
#y nos muestre el acumulado mensual de infectados, muertes y vacunados

DROP PROCEDURE IF EXISTS Consulta2;
DELIMITER $$;

CREATE PROCEDURE  Consulta2 (
	nombre varchar(100)
)
BEGIN
	SELECT (SELECT MONTH (C.fecha)) MES,
	MAX(C.total_cases)*10 AS TotalCasos,
	MAX(M.total_deaths)*10  AS TotalMuertes,
	MAX(DV.total_vaccinations)*10 AS TotalVacunados,			
	(SELECT YEAR (C.fecha)) AS ANIO
	FROM  PAIS P, MUERTE M, DatosVacuna DV, CASO C
	WHERE p.id_pais=m.id_pais
	AND P.id_pais=dv.id_pais
	AND p.id_pais=c.id_pais
	AND m.fecha=dv.fecha
	AND m.fecha=c.fecha
	AND dv.fecha=C.fecha
	AND P.locations=nombre
	GROUP BY (SELECT MONTH (M.fecha)), (SELECT MONTH (DV.fecha)),
	(SELECT MONTH (C.fecha)),(SELECT YEAR (C.fecha))
	ORDER BY (SELECT YEAR(C.fecha)),(SELECT MONTH (M.fecha)),
	(SELECT MONTH(DV.fecha)),(SELECT MONTH (C.fecha)) asc;
END;

CALL Consulta2('Argentina');
DELIMITER;

#3. Consulta que agrupe la cantidad actual de contagios de los últimos 3 meses 
#por continente.

SELECT  c.continent CONTINENTE, SUM(CA.NEW_CASES*10) CONTAGIOS
FROM CASO CA, PAIS P, CONTINENTE C
WHERE c.id_continente=p.id_continente
AND P.id_Pais=CA.id_pais
AND (SELECT MONTH (CA.fecha)) >=(SELECT MAX(MONTH (C2.fecha)) FROM CASO C2 WHERE (SELECT YEAR (C2.fecha))=(SELECT MAX(YEAR (C3.fecha)) FROM CASO C3))-2
AND (SELECT YEAR (CA.fecha))=(SELECT MAX(YEAR (C2.fecha)) FROM CASO C2)
GROUP BY c.continent
ORDER BY c.continent ASC
;


#4. Función o método muestre los países con mayor aceleración de contagios 
#durante el mes de diciembre 2020 y enero 2021.

DROP PROCEDURE IF EXISTS Consulta4;
DELIMITER $$;

CREATE PROCEDURE  Consulta4 ( )
BEGIN
	SELECT p.locations PAIS, AVG(C.new_cases*10) AS Prom_NuevosCasos
    FROM PAIS AS P, CASO AS C
    WHERE p.id_pais=c.id_pais
    AND Substr(FECHA,1,7) IN ('2020-12','2021-01')
    GROUP BY p.locations
    ORDER BY AVG(C.new_cases) desc
    LIMIT 10;
END;


CALL Consulta4();
DELIMITER;

#5. Promedio contagios durante el primer trimestre de la pandemia.

SELECT AVG(Total) AS Prom_Primer_Trimestre FROM (
SELECT SUM(C.new_cases)*10 AS Total
FROM PAIS P, CASO C
WHERE p.id_pais=c.id_pais
AND ( MONTH (C.fecha)) IN (
    (SELECT MIN( MONTH (C2.fecha))FROM CASO AS C2),
    (SELECT MIN(  MONTH (C2.fecha)) FROM CASO AS C2)+1,
    (SELECT MIN( MONTH (C2.fecha))FROM CASO AS C2)+2
    )
AND (YEAR (C.fecha))=(SELECT MIN( YEAR (C3.fecha))FROM CASO AS C3)
GROUP BY p.locations
) AS TOTALES
;

#6. Función o método que reciba un rango de infectados por día
#y devuelva los países que en algún momento tuvieron ese rango, 
#con su fecha correspondiente.
DROP PROCEDURE IF EXISTS Consulta6;
DELIMITER $$;

CREATE PROCEDURE  Consulta6 ( 
limite1 Int, limite2 Int
)
BEGIN
	SELECT p.locations PAIS, AVG(C.new_cases*10) AS Prom_NuevosCasos
    FROM PAIS AS P, CASO AS C
    WHERE p.id_pais=c.id_pais
    AND Substr(FECHA,1,7) IN ('2020-12','2021-01')
    GROUP BY p.locations
    ORDER BY AVG(C.new_cases) desc
    LIMIT 10;
END;


CALL Consulta4();
DELIMITER;

CREATE OR REPLACE FUNCTION Consulta6(limite1 number, limite2 number)
RETURN sys_refcursor 
IS
fech date;
cas NUMBER(17,4);
res sys_refcursor;
BEGIN    
    DBMS_OUTPUT.PUT_LINE ('Pais #> '|| 'Fecha #> ' || 'Contagios');
    FOR ITEM IN (SELECT distinct p.locations
    FROM Pais P, Caso C
    WHERE p.id_pais=c.id_pais
    AND c.new_cases >= limite1
    AND c.new_cases<=limite2
    GROUP BY p.locations
    ORDER BY p.locations asc)
    
    LOOP
        #OPEN res FOR
        SELECT fecha, new_cases into fech, cas  FROM (
        SELECT p.locations, c.fecha, c.new_cases
        FROM Pais P, Caso C
        WHERE p.locations=ITEM.locations
        AND c.new_cases >= limite1
        AND c.new_cases<=limite2
        ) WHERE ROWNUM=1;
        
        DBMS_OUTPUT.PUT_LINE (ITEM.locations ||' #> '|| fech ||' #> ' || cas);
    END LOOP;
    return res;
END;

SELECT Consulta6(15,200) FROM DUAL;


#7. Función o método que muestre al top 10 de países con mayor cantidad de pruebas

DROP PROCEDURE IF EXISTS Consulta7;
DELIMITER $$;

CREATE PROCEDURE  Consulta7 ( )
BEGIN
	SELECT  p.locations, MAX(dt.total_test)Total_Pruebas
    FROM PAIS P, DatosTest DT
    WHERE p.id_pais=dt.id_pais
    GROUP BY p.locations
    ORDER BY MAX(dt.total_test) DESC
    LIMIT 10;
END;


CALL Consulta7();
DELIMITER;


#8. Función o método que reciba la fecha como parámetro 
#y que muestre el país que reporto más muertes en ese día.

DROP PROCEDURE IF EXISTS Consulta8;
DELIMITER $$;

CREATE PROCEDURE  Consulta8 ( fech date)
BEGIN
	SELECT p.locations, MAX(M.new_deaths)*10 Total_Muertes_Dia
    FROM PAIS P, MUERTE M
    WHERE p.id_pais=m.id_pais
    AND m.fecha=fech
    GROUP BY p.locations
    ORDER BY MAX(m.new_deaths) DESC
    LIMIT 1;
END;


CALL Consulta8('2021-09-13');
DELIMITER;

#9. Consulta que muestre los datos de Guatemala para un rango de fechas especifico.

SELECT P.locations,SUM(C.new_cases*10) AS Nuevos_Casos,MAX(C.total_cases*10) AS Total_Nuevos_Casos,
SUM(dv.new_vacinations*10) AS Nuevas_Vacunas,MAX(dv.total_vaccinations*10) AS Total_Nuevas_Vacunas,
SUM(M.new_deaths*10) AS Nuevas_Muertes, MAX(M.total_deaths*10) ASTotal_Muertes
FROM PAIS P, CASO C, datosvacuna DV, MUERTE M
WHERE p.id_pais=c.id_pais
AND P.id_Pais=DV.id_Pais
AND P.id_Pais=M.id_Pais
AND C.Fecha=DV.Fecha
AND C.Fecha= M.Fecha
And M.Fecha=DV.Fecha
AND P.locations='Guatemala'
and C.Fecha>='2020-01-31'
and C.Fecha<='2021-10-13'
Group by P.locations;

#10. Consulta que muestre los países de Latinoamérica ordenados de los más infectados a los menos infectados para un rango de fechas en específico.
select P.locations, sum(c.new_cases)*10  TotalCasos
from Pais  P, Caso C
where P.id_Pais=C.id_Pais
and P.locations in ('Argentina', 'Bolivia', 'Brazil','Chile', 'Colombia', 'Costa Rica', 'Cuba', 'Ecuador', 'El Salvador', 'Guayana', 'Grenada', 'Guatemala', 'Haiti', 'Honduras','Jamaica',
'Mexico','Nicaragua', 'Paraguay', 'Panama', 'Peru', 'Puerto Rico', 'Dominican Republic', 'Suriname', 'Uruguay', 'Venezuela')
and C.Fecha>'2020-01-31'
and C.Fecha<'2021-10-13'
group by P.locations
order by  sum(C.new_cases) desc;
