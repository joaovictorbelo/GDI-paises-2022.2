﻿CREATE TABLE MOEDA(
SIGLA_MOEDA VARCHAR(3),
        VALOR_EM_DOLAR FLOAT(6),
        CONSTRAINT PK_MOEDA PRIMARY KEY (SIGLA_MOEDA)
);


CREATE TABLE CRIPTOMOEDA(
           SIGLA_MOEDA VARCHAR(3),
        BLOCKCHAIN VARCHAR(255),
        CONSTRAINT PK_CRIPTOMOEDA PRIMARY KEY (SIGLA_MOEDA),
        CONSTRAINT FK_MOEDA FOREIGN KEY (SIGLA_MOEDA) REFERENCES MOEDA (SIGLA_MOEDA)
);


CREATE TABLE MOEDA_FIDUCIARIA(
        SIGLA_MOEDA VARCHAR(3),
        CONSTRAINT PK_MOEDA_FIDUCIARIA PRIMARY KEY (SIGLA_MOEDA),
        CONSTRAINT FK_MOEDAFID FOREIGN KEY (SIGLA_MOEDA) REFERENCES MOEDA (SIGLA_MOEDA)
);


CREATE TABLE PAIS(  
            SIGLA_PAIS VARCHAR(2),
        NOME_PAIS VARCHAR(25) CONSTRAINT NN_PAIS_NOME NOT NULL,
           PIB FLOAT(6),  
           EH_PENTA NUMBER(1) CONSTRAINT NN_PAIS_EH_PENTA NOT NULL,
           SIGLA_MOEDA VARCHAR(3) CONSTRAINT U_PAIS_SIGLA_MOEDA UNIQUE,
            CONSTRAINT PK_PAIS PRIMARY KEY (SIGLA_PAIS),
        CONSTRAINT FK_MOEDAPAIS FOREIGN KEY (SIGLA_MOEDA) REFERENCES MOEDA_FIDUCIARIA (SIGLA_MOEDA)
);


CREATE TABLE RECONHECE(
        RECONHECE VARCHAR(2),
        RECONHECIDO VARCHAR(2),
        CONSTRAINT PK_RECONHECE  PRIMARY KEY (RECONHECE, RECONHECIDO),
        CONSTRAINT FK_PAISRECONHECE FOREIGN KEY (RECONHECE) REFERENCES PAIS (SIGLA_PAIS),
        CONSTRAINT FK_PAISRECONHECIDO FOREIGN KEY (RECONHECIDO) REFERENCES PAIS (SIGLA_PAIS)  
);




CREATE TABLE CIDADE(
        SIGLA_CIDADE VARCHAR(5),
        NOME_CIDADE VARCHAR(25) CONSTRAINT NN_CIDADE_NOME NOT NULL,
        EH_CAPITAL NUMBER(1) CONSTRAINT NN_CIDADE_EH_CAPITAL NOT NULL,
        SIGLA_PAIS VARCHAR(2) CONSTRAINT NN_CIDADE_SIGLA_PAIS NOT NULL,
        CONSTRAINT PK_CIDADE PRIMARY KEY (SIGLA_CIDADE),
        CONSTRAINT FK_CIDADEPAIS FOREIGN KEY (SIGLA_PAIS) REFERENCES PAIS (SIGLA_PAIS)
);


CREATE TABLE CORES_BANDEIRA(
        COR VARCHAR(20),
        SIGLA_PAIS VARCHAR(2),
        CONSTRAINT PK_COR_BANDEIRA PRIMARY KEY (COR, SIGLA_PAIS),
        CONSTRAINT FK_BANDEIRA FOREIGN KEY (SIGLA_PAIS) REFERENCES PAIS (SIGLA_PAIS)
);


CREATE TABLE TERRITORIO_ANTARTIDA(
        SIGLA_PAIS VARCHAR(2),
        NUMERO_SERIE VARCHAR(10),
        AREA FLOAT(6),
        CONSTRAINT PK_ANTATIDA PRIMARY KEY (SIGLA_PAIS, NUMERO_SERIE),
        CONSTRAINT FK_PAISANTARTIDA FOREIGN KEY (SIGLA_PAIS) REFERENCES PAIS (SIGLA_PAIS)
);


CREATE TABLE IDIOMA(
SIGLA_IDIOMA VARCHAR(5) NOT NULL,
        NOME_IDIOMA VARCHAR(25) CONSTRAINT NN_IDIOMA_NOME NOT NULL,
        NUMERO_FALANTES INTEGER,
        CONSTRAINT PK_IDIOMA PRIMARY KEY (SIGLA_IDIOMA)
);


CREATE TABLE OFICIAL(
        SIGLA_PAIS VARCHAR(2),
        SIGLA_IDIOMA VARCHAR(3),
        CONSTRAINT PK_OFICIAL PRIMARY KEY (SIGLA_PAIS, SIGLA_IDIOMA),
        CONSTRAINT FK_IDIOMAPAIS FOREIGN KEY (SIGLA_IDIOMA) REFERENCES IDIOMA (SIGLA_IDIOMA),
        CONSTRAINT FK_PAISIDIOMA FOREIGN KEY (SIGLA_PAIS) REFERENCES PAIS (SIGLA_PAIS)
);


CREATE TABLE OBRA_PUBLICA(
        COD_OBRA VARCHAR(30),
        VALOR FLOAT(6) CONSTRAINT NN_OBRA_PUBLICA_VALOR  NOT NULL,
        CONSTRAINT PK_OBRA_PUBLICA PRIMARY KEY (COD_OBRA)
);


CREATE TABLE REALIZA(
        COD_OBRA VARCHAR(30),
        SIGLA_PAIS VARCHAR(2),
        CONSTRAINT PK_REALIZA PRIMARY KEY (COD_OBRA, SIGLA_PAIS),
        CONSTRAINT FK_PAISREALIZA FOREIGN KEY (SIGLA_PAIS) REFERENCES PAIS (SIGLA_PAIS),
        CONSTRAINT FK_OBRAREALIZADA FOREIGN KEY (COD_OBRA) REFERENCES OBRA_PUBLICA (COD_OBRA)
);


CREATE TABLE EMPRESA_PRIVADA(
        NOME_EMPRESA_PRIVADA VARCHAR(25) CONSTRAINT NN_EMPRESA_PRIVADA_NOME NOT NULL,
        REGISTRO VARCHAR(25),
        RUA VARCHAR(25),
        BAIRRO VARCHAR(25),
        CIDADE VARCHAR(5),
        CONSTRAINT PK_EMPRESA_PRIVADA PRIMARY KEY (REGISTRO),
        CONSTRAINT PK_CIDADEEMPRESA FOREIGN KEY (CIDADE) REFERENCES CIDADE (SIGLA_CIDADE)
);


CREATE TABLE PARCERIA(
        SIGLA_PAIS VARCHAR(2),
        COD_OBRA VARCHAR(30),
        REGISTRO VARCHAR(25),
        CONSTRAINT PK_PARCERIA PRIMARY KEY (SIGLA_PAIS, COD_OBRA, REGISTRO),
        CONSTRAINT FK_REALIZAPARCERIA FOREIGN KEY (SIGLA_PAIS, COD_OBRA) REFERENCES REALIZA (SIGLA_PAIS, COD_OBRA),
        CONSTRAINT FK_EMPRESAPARCEIRA FOREIGN KEY (REGISTRO) REFERENCES EMPRESA_PRIVADA (REGISTRO)
);


CREATE TABLE COMMODITY(
        COD_SH VARCHAR(10),
        COTACAO FLOAT(6) CONSTRAINT NN_COMMODITY_COTACAO NOT NULL,
        TIPO VARCHAR(15) CONSTRAINT NN_COMMODITY_TIPO NOT NULL,
        CONSTRAINT PK_COMMODITY PRIMARY KEY (COD_SH)
);


CREATE TABLE COMPROU(
        COD_SH VARCHAR(10),
        SIGLA_MOEDA VARCHAR(3),
        SIGLA_PAIS VARCHAR(2),
        DATA_COMPRA DATE,
        PRECO FLOAT(6) CONSTRAINT NN_COMPROU_PRECO NOT NULL,
            CONSTRAINT PK_COMPROU PRIMARY KEY (COD_SH, SIGLA_MOEDA, SIGLA_PAIS, DATA_COMPRA),
        CONSTRAINT FK_COMMODITYCOMPRADA FOREIGN KEY (COD_SH) REFERENCES COMMODITY (COD_SH),
        CONSTRAINT FK_MOEDACOMPRA FOREIGN KEY (SIGLA_MOEDA) REFERENCES MOEDA (SIGLA_MOEDA),
        CONSTRAINT FK_PAISCOMPROU FOREIGN KEY (SIGLA_PAIS) REFERENCES PAIS (SIGLA_PAIS)
);