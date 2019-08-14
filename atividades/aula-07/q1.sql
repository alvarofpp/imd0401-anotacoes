-- Apagar as colunas para refazer tudo
DROP TABLE IF EXISTS Publicacoes;
DROP TABLE IF EXISTS Artigos;
DROP TABLE IF EXISTS Pesquisadores;
DROP TABLE IF EXISTS Periodicos;

/*
 * Início
 */
 -- Tabela original da questão
CREATE TABLE Pesquisadores (
  "codPesquisador" serial NOT NULL,
  "nomePesquisador" VARCHAR(100) NOT NULL,
  "codArtigo" serial NOT NULL,
  "tituloArtigo" VARCHAR(100) NOT NULL,
  "paginaInicial" integer NOT NULL,
  "paginaFinal" integer NOT NULL,
  "codPeriodico" serial NOT NULL,
  "nomePeriodico" VARCHAR(100) NOT NULL,

  CONSTRAINT "codsPesquisadorArtigoPeriodicoKey"
    PRIMARY KEY ("codPesquisador", "codArtigo", "codPeriodico")
);

/*
 * 1FN
 */
-- Cria a tabela de artigo
CREATE TABLE Artigos (
  "codArtigo" serial PRIMARY KEY,
  "codPesquisador" serial NOT NULL,
  "tituloArtigo" VARCHAR(100) NOT NULL,
  "paginaInicial" integer NOT NULL,
  "paginaFinal" integer NOT NULL,
  "codPeriodico" serial NOT NULL,
  "nomePeriodico" VARCHAR(100) NOT NULL
);
-- Inserir os dados da tabela original
INSERT INTO Artigos ("codPesquisador","codArtigo","tituloArtigo","paginaInicial","paginaFinal","codPeriodico","nomePeriodico")
  SELECT "codPesquisador","codArtigo","tituloArtigo","paginaInicial","paginaFinal","codPeriodico","nomePeriodico"
  FROM Pesquisadores;
-- Agora remove as várias Primary Keys
ALTER TABLE Pesquisadores
  DROP CONSTRAINT "codsPesquisadorArtigoPeriodicoKey";
-- Apaga as colunas que não usamos mais em Pesquisador
ALTER TABLE Pesquisadores
  DROP COLUMN "codArtigo",
  DROP COLUMN "tituloArtigo",
  DROP COLUMN "paginaInicial",
  DROP COLUMN "paginaFinal",
  DROP COLUMN "codPeriodico",
  DROP COLUMN "nomePeriodico";
-- Agora declara a Primary Key de Pesquisador
ALTER TABLE Pesquisadores
  ADD CONSTRAINT "codPesquisadorKey"
    PRIMARY KEY ("codPesquisador");
-- Chave estrangeira em Artigo para Pesquisador
ALTER TABLE Artigos
  ADD CONSTRAINT codPesquisadorFkey FOREIGN KEY ("codPesquisador")
    REFERENCES Pesquisadores("codPesquisador") MATCH SIMPLE
    ON UPDATE NO ACTION ON DELETE NO ACTION;

 /*
 * 2FN
 */
-- Cria a tabela de publicacoes que é N para N entre Pesquisador e Artigo
CREATE TABLE Publicacoes (
    "codPublicacao" serial PRIMARY KEY,
    "codPesquisador" serial NOT NULL,
    "codArtigo" serial NOT NULL,

    CONSTRAINT codPesquisadorFkey FOREIGN KEY ("codPesquisador")
        REFERENCES Pesquisadores("codPesquisador") MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    CONSTRAINT codArtigoFkey FOREIGN KEY ("codArtigo")
        REFERENCES Artigos("codArtigo") MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
);
-- Insere os dados de relação
INSERT INTO Publicacoes ("codPesquisador", "codArtigo")
  SELECT "codPesquisador","codArtigo"
  FROM Artigos;
-- Apaga as colunas que não usamos mais em Pesquisador
ALTER TABLE Artigos
  DROP CONSTRAINT "codpesquisadorfkey",
  DROP COLUMN "codPesquisador";

/*
 * 3FN
 */
-- Cria a tabela de periodico
CREATE TABLE Periodicos (
  "codPeriodico" serial PRIMARY KEY,
  "nomePeriodico" VARCHAR(100) NOT NULL
);
-- Inserir os dados da tabela original
INSERT INTO Periodicos ("codPeriodico", "nomePeriodico")
  SELECT "codPeriodico", "nomePeriodico"
  FROM Artigos;
-- Apaga as colunas que Artigos não necessita mais
ALTER TABLE Artigos
  DROP COLUMN "nomePeriodico";
-- Chave estrangeira em Artigo para Periodico
ALTER TABLE Artigos
  ADD CONSTRAINT codPeriodicoFkey FOREIGN KEY ("codPeriodico")
    REFERENCES Periodicos("codPeriodico") MATCH SIMPLE
    ON UPDATE NO ACTION ON DELETE NO ACTION;

