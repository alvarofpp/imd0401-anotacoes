-- Apagar as colunas para refazer tudo
DROP TABLE IF EXISTS Pesquisador_Artigo;
DROP TABLE IF EXISTS Artigo_Periodico;
DROP TABLE IF EXISTS Pesquisador;
DROP TABLE IF EXISTS Artigo;
DROP TABLE IF EXISTS Periodico;

/*
 * Início
 */
 -- Tabela original da questão
CREATE TABLE Pesquisador (
  "codPesquisador" integer NOT NULL,
  "nomePesquisador" VARCHAR(100) NOT NULL,
  "codArtigo" integer NOT NULL,
  "tituloArtigo" VARCHAR(100) NOT NULL,
  "paginaInicial" integer NOT NULL,
  "paginaFinal" integer NOT NULL,
  "codPeriodico" integer NOT NULL,
  "nomePeriodico" VARCHAR(100) NOT NULL,

  CONSTRAINT "codsPesquisadorArtigoPeriodicoKey"
    PRIMARY KEY ("codPesquisador", "codArtigo", "codPeriodico")
);
/*
 * 1FN
 *
 * Não se aplica, visto que não há atributos multivalorados/compostos
 */
 /*
 * 2FN e 3FN
 */
-- Cria a tabela de artigo
CREATE TABLE Artigo (
  "codArtigo" serial PRIMARY KEY,
  "tituloArtigo" VARCHAR(100) NOT NULL
);
-- Inserir os dados da tabela original
INSERT INTO Artigo ("codArtigo", "tituloArtigo")
  SELECT "codArtigo", "tituloArtigo"
  FROM Pesquisador;

-- Cria a tabela de periodico
CREATE TABLE Periodico (
  "codPeriodico" serial PRIMARY KEY,
  "nomePeriodico" VARCHAR(100) NOT NULL
);
-- Inserir os dados da tabela original
INSERT INTO Periodico ("codPeriodico", "nomePeriodico")
  SELECT "codPeriodico", "nomePeriodico"
  FROM Pesquisador;

-- Tabelas de relacionamentos N para N
-- Primeiro remove as várias Primary Keys
ALTER TABLE Pesquisador
  DROP CONSTRAINT "codsPesquisadorArtigoPeriodicoKey";
-- Agora declara a chave primaria de Pesquisador
ALTER TABLE Pesquisador
  ADD CONSTRAINT "codPesquisadorKey"
    PRIMARY KEY ("codPesquisador");
-- Cria a tabela de N para N entre pesquisador e artigo
CREATE TABLE Pesquisador_Artigo (
    "id" serial PRIMARY KEY,
    "codPesquisador" integer NOT NULL,
    "codArtigo" integer NOT NULL,

    CONSTRAINT codPesquisadorFkey FOREIGN KEY ("codPesquisador")
        REFERENCES Pesquisador("codPesquisador") MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    CONSTRAINT codArtigoFkey FOREIGN KEY ("codArtigo")
        REFERENCES Artigo("codArtigo") MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
);
-- Insere os valores para manter os relacionamentos
INSERT INTO Pesquisador_Artigo ("codPesquisador", "codArtigo")
  SELECT "codPesquisador", "codArtigo"
  FROM Pesquisador;
-- Apaga as colunas que Pesquisador não necessita mais
ALTER TABLE Pesquisador
  DROP COLUMN "tituloArtigo";
-- OBSERVAÇÃO: Não apaga "codArtigo", porque será usada posteriormente

-- Cria a tabela de N para N entre artigo e periodico
CREATE TABLE Artigo_Periodico (
    "id" serial PRIMARY KEY,
    "codPeriodico" integer NOT NULL,
    "codArtigo" integer NOT NULL,
    "paginaInicial" integer NOT NULL,
    "paginaFinal" integer NOT NULL,

    CONSTRAINT codPeriodicoFkey FOREIGN KEY ("codPeriodico")
        REFERENCES Periodico("codPeriodico") MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    CONSTRAINT codArtigoFkey FOREIGN KEY ("codArtigo")
        REFERENCES Artigo("codArtigo") MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
);
-- Insere os valores para manter os relacionamentos
INSERT INTO Artigo_Periodico ("codPeriodico", "codArtigo", "paginaInicial", "paginaFinal")
  SELECT "codPeriodico", "codArtigo", "paginaInicial", "paginaFinal"
  FROM Pesquisador;
-- Apaga as colunas que Pesquisador não necessita mais
ALTER TABLE Pesquisador
  DROP COLUMN "codPeriodico",
  DROP COLUMN "codArtigo",
  DROP COLUMN "paginaInicial",
  DROP COLUMN "paginaFinal";

