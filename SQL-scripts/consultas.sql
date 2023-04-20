﻿/*PROJETAR O NOME E A(s) LÍNGUA(s) OFICIAL DE TODOS OS PAÍSES NO BANCO DE DADOS: (INNER JOIN E OUTER JOIN)*/


SELECT P.NOME_PAIS AS PAIS, I.NOME_IDIOMA AS IDIOMA
FROM IDIOMA I INNER JOIN OFICIAL O ON(I.SIGLA_IDIOMA = O.SIGLA_IDIOMA)
        FULL OUTER JOIN PAIS P ON(O.SIGLA_PAIS = P.SIGLA_PAIS)


/*PROJETAR O NOME DOS PAÍSES QUE TÊM OBRAS CADASTRADAS NO BANCO DE DADOS (SUBCONSULTA DE TABELA)*/ 


SELECT NOME_PAIS
FROM PAIS P 
WHERE P.SIGLA_PAIS IN(SELECT R.SIGLA_PAIS
                                    FROM REALIZA R)


/*PROJETAR OS PAÍSES QUE FIZERAM COMPRAS CADASTRADAS NO SISTEMA (SEMIJOIN)*/ 


SELECT NOME_PAIS
FROM PAIS P 
WHERE EXISTS(SELECT *
                    FROM COMPROU C
                    WHERE C.SIGLA_PAIS = P.SIGLA_PAIS)


/*PROJETAR AS DUPLAS DE PAISES QUE NÃO SE RECONHECEM (SUBCONSULTA DO TIPO TABELA)*/


SELECT P1.SIGLA_PAIS, P2.SIGLA_PAIS
FROM PAIS P1, PAIS P2
WHERE (P1.SIGLA_PAIS, P2.SIGLA_PAIS) NOT IN (SELECT * FROM RECONHECE)
    AND P1.SIGLA_PAIS != P2.SIGLA_PAIS


/*OU ENTÃO, USANDO ANTIJOIN:*/


SELECT P1.SIGLA_PAIS, P2.SIGLA_PAIS
FROM PAIS P1, PAIS P2
WHERE P1.SIGLA_PAIS != P2.SIGLA_PAIS 
    AND NOT EXISTS (SELECT *
                            FROM RECONHECE R
                            WHERE P1.SIGLA_PAIS = R.RECONHECE AND P2.SIGLA_PAIS = R.RECONHECIDO)




/*RETORNA OS PAISES QUE POSSUEM PIB MAIOR QUE O DE OUTROS PAISES COM O MESMO IDIOMA OFICIAL(INNER JOIN + SUBCONSULTA DO TIPO ESCALAR + GROUP BY/HAVING)*/


SELECT P.NOME_PAIS, P.PIB, O.SIGLA_IDIOMA
FROM PAIS P
JOIN OFICIAL O on (P.SIGLA_PAIS = O.SIGLA_PAIS)
WHERE P.PIB = (
        SELECT MAX(P2.PIB)
        FROM PAIS P2
        JOIN OFICIAL O2 on (P2.SIGLA_PAIS = O2.SIGLA_PAIS)
        GROUP BY O2.SIGLA_IDIOMA
        HAVING O2.SIGLA_IDIOMA = O.SIGLA_IDIOMA
);


    
/*RETORNA OS PAISES QUE JA FIZERAM COMPRA USANDO A MOEDA ADOTADA OFICIALMENTE POR ELE (OPERAÇÃO DE CONJUNTO)*/


SELECT SIGLA_PAIS, SIGLA_MOEDA
FROM COMPROU
INTERSECT
SELECT SIGLA_PAIS, SIGLA_MOEDA
FROM PAIS;


/*E OS QUE FIZERAM COMPRAS EM OUTRAS MOEDAS QUE NÃO AS SUAS (OPERAÇÃO DE CONJUNTO)*/


SELECT SIGLA_PAIS, SIGLA_MOEDA
FROM COMPROU
MINUS
SELECT SIGLA_PAIS, SIGLA_MOEDA
FROM PAIS;


/*PROJETAR A SIGLA DAS CIDADES COM MESMO NOME E PAÍS DA CIDADE DE SIGLA OSA (SUBCONSULTA DE LINHA)*/


SELECT SIGLA_CIDADE
FROM CIDADE
WHERE (NOME_CIDADE, SIGLA_PAIS) = 
(SELECT NOME_CIDADE, SIGLA_PAIS
FROM CIDADE
WHERE SIGLA_CIDADE = ‘OSA’);
________________
/*TRIGGER QUE IMPEDE QUE UMA COMPRA COM DATA ANTERIOR A 01/01/2000 SEJA CADASTRADA NO BANCO DE DADOS*/


CREATE OR REPLACE TRIGGER MAIOR_Q_2000
BEFORE INSERT OR UPDATE OF DATA_COMPRA ON COMPROU
FOR EACH ROW
BEGIN
IF :  NEW.DATA_COMPRA < TO_DATE('01/01/2000', 'DD/MM/YYYY') THEN
        raise_application_error(-20000, 'DATA PROIBIDA!');
END IF;
END;


/*FUNÇÃO QUE AVERIGUA, PARA UMA DADA SIGLA DE IDIOMA, QUANTOS PAÍSES COM AQUELA LÍNGUA OFICIAL TEM PIB SUPERIOR AO OFERECIDO COMO INPUT*/


CREATE OR REPLACE FUNCTION GDP (PIB_ IN PAIS.PIB%TYPE, SIG_IDIOMA IN OFICIAL.SIGLA_IDIOMA%TYPE) 
RETURN NUMBER IS QTD_PIB NUMBER(3);


BEGIN 
  SELECT COUNT(*) INTO QTD_PIB
  FROM PAIS P 
  WHERE EXISTS (SELECT * FROM OFICIAL O WHERE O.SIGLA_PAIS = P.SIGLA_PAIS AND O.SIGLA_IDIOMA = SIG_IDIOMA)
  AND P.PIB > PIB_;


  RETURN (QTD_PIB);
END GDP;