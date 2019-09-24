-- Apagar as colunas para refazer tudo
DROP TABLE IF EXISTS publicacoes;
DROP TABLE IF EXISTS artigos;
DROP TABLE IF EXISTS pesquisadores;
DROP TABLE IF EXISTS periodicos;

/*
 * Início
 */
 -- Tabela original da questão
CREATE TABLE pesquisadores (
  "id" serial NOT NULL,
  "nome_pesquisador" varchar(100) NOT NULL,
  "cod_artigo" serial NOT NULL,
  "titulo_artigo" varchar(100) NOT NULL,
  "pagina_inicial" integer NOT NULL,
  "pagina_final" integer NOT NULL,
  "cod_periodico" serial NOT NULL,
  "nome_periodico" varchar(100) NOT NULL,

  CONSTRAINT "pesquisadores_pkey"
    PRIMARY KEY ("id", "cod_artigo", "cod_periodico")
);

/*
 * 1FN
 */
-- Cria a tabela de artigos
CREATE TABLE artigos (
  "id" serial NOT NULL,
  "pesquisador_id" serial NOT NULL,
  "titulo" varchar(100) NOT NULL,
  "pagina_inicial" integer NOT NULL,
  "pagina_final" integer NOT NULL,
  "cod_periodico" serial NOT NULL,
  "nome_periodico" varchar(100) NOT NULL,

  CONSTRAINT artigos_pkey
    PRIMARY KEY ("id")
);
-- Inserir os dados da tabela original
INSERT INTO artigos ("pesquisador_id","id","titulo","pagina_inicial","pagina_final","cod_periodico","nome_periodico")
  SELECT "id","cod_artigo","titulo_artigo","pagina_inicial","pagina_final","cod_periodico","nome_periodico"
  FROM pesquisadores;
-- Agora remove as várias PK de pesquisadores
ALTER TABLE pesquisadores
  DROP CONSTRAINT "pesquisadores_pkey";
-- Apaga as colunas que não usamos mais em pesquisadores
ALTER TABLE pesquisadores
  DROP COLUMN "cod_artigo",
  DROP COLUMN "titulo_artigo",
  DROP COLUMN "pagina_inicial",
  DROP COLUMN "pagina_final",
  DROP COLUMN "cod_periodico",
  DROP COLUMN "nome_periodico";
-- Agora declara a PK de pesquisadores
ALTER TABLE pesquisadores
  ADD CONSTRAINT "pesquisadores_pkey"
    PRIMARY KEY ("id");
-- Chave estrangeira em artigos referente a pesquisadores
ALTER TABLE artigos
  ADD CONSTRAINT artigos_pesquisador_id_foreign FOREIGN KEY ("pesquisador_id")
    REFERENCES pesquisadores("id") MATCH SIMPLE
    ON UPDATE NO ACTION ON DELETE NO ACTION;

 /*
 * 2FN
 */
-- Cria a tabela de publicacoes que serve como N para N entre pesquisadores e artigos
CREATE TABLE publicacoes (
  "id" serial NOT NULL,
  "pesquisador_id" serial NOT NULL,
  "artigo_id" serial NOT NULL,

  CONSTRAINT publicacoes_pkey
    PRIMARY KEY ("id"),

  CONSTRAINT publicacoes_pesquisador_id_foreign FOREIGN KEY ("pesquisador_id")
    REFERENCES pesquisadores("id") MATCH SIMPLE
    ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT publicacoes_artigo_id_foreign FOREIGN KEY ("artigo_id")
    REFERENCES artigos("id") MATCH SIMPLE
    ON UPDATE NO ACTION ON DELETE NO ACTION
);
-- Insere os dados em publicacoes
INSERT INTO publicacoes ("pesquisador_id", "artigo_id")
  SELECT "pesquisador_id","id"
  FROM artigos;
-- Apaga as colunas que não usamos mais em artigos
ALTER TABLE artigos
  DROP CONSTRAINT "artigos_pesquisador_id_foreign",
  DROP COLUMN "pesquisador_id";

/*
 * 3FN
 */
-- Cria a tabela de periodicos
CREATE TABLE periodicos (
  "id" serial NOT NULL,
  "nome" varchar(100) NOT NULL,

  CONSTRAINT periodicos_pkey
    PRIMARY KEY ("id")
);
-- Inserir os dados de artigos em periodicos
INSERT INTO periodicos ("id", "nome")
  SELECT "cod_periodico", "nome_periodico"
  FROM artigos;
-- Apaga as colunas que artigos não necessita mais
ALTER TABLE artigos
  DROP COLUMN "nome_periodico";
-- Renomeia a coluna referente a periodicos em artigos
ALTER TABLE artigos
  RENAME COLUMN "cod_periodico" TO "periodico_id";
-- Chave estrangeira em artigos para periodicos
ALTER TABLE Artigos
  ADD CONSTRAINT artigos_periodico_id_foreign FOREIGN KEY ("periodico_id")
    REFERENCES periodicos("id") MATCH SIMPLE
    ON UPDATE NO ACTION ON DELETE NO ACTION;

