-- Apagar as colunas para refazer tudo
DROP TABLE IF EXISTS telefones;
DROP TABLE IF EXISTS funcionarios_cargos;
DROP TABLE IF EXISTS funcionarios_dependentes;
DROP TABLE IF EXISTS dependentes;
DROP TABLE IF EXISTS cargos;
DROP TABLE IF EXISTS funcionarios;

/*
 * Início
 */
 -- Tabela original da questão
CREATE TABLE funcionarios (
  "matricula" varchar(20) NOT NULL,
  "nome" varchar(100) NOT NULL,
  "nascimento_dt" date NOT NULL,
  "genero" char NOT NULL,
  "rg" varchar(9) NOT NULL,
  "endereco" varchar(250) NOT NULL,
  "telefone" varchar(20) NOT NULL,
  "admissao_dt" date NOT NULL,
  "cargo" varchar(100) NOT NULL,
  "inicio_cargo_dt" date NOT NULL,
  "fim_cargo_dt" date NOT NULL,
  "nome_dependente" varchar(100) NOT NULL,
  "nascimento_dependente_dt" date NOT NULL,

  CONSTRAINT "funcionarios_pk"
    PRIMARY KEY ("matricula")
);

/*
 * 1FN
 */
-- Cria a tabela de telefones
CREATE TABLE telefones (
  "id" serial NOT NULL,
  "funcionario_matricula" varchar(25) NOT NULL,
  "numero" varchar(20) NOT NULL,

  CONSTRAINT telefones_pky
    PRIMARY KEY ("id"),

  CONSTRAINT telefones_funcionario_matricula_foreign FOREIGN KEY ("funcionario_matricula")
    REFERENCES funcionarios("matricula") MATCH SIMPLE
    ON UPDATE NO ACTION ON DELETE NO ACTION
);
-- Inserir os dados da tabela original
INSERT INTO telefones ("funcionario_matricula","numero")
  SELECT "matricula","telefone"
  FROM funcionarios;
-- Apagar as colunas que não usamos mais na tabela original
ALTER TABLE funcionarios
  DROP COLUMN "telefone";
-- Cria a tabela de cargos
CREATE TABLE cargos (
  "id" serial NOT NULL,
  "funcionario_matricula" varchar(25) NOT NULL,
  "nome" varchar(100) NOT NULL,
  "inicio_cargo_dt" date NOT NULL,
  "fim_cargo_dt" date NOT NULL,
  "nome_dependente" varchar(100) NOT NULL,
  "nascimento_dependente_dt" date NOT NULL,

  CONSTRAINT cargos_pk
    PRIMARY KEY ("id"),

  CONSTRAINT cargos_funcionario_matricula_foreign FOREIGN KEY ("funcionario_matricula")
    REFERENCES funcionarios("matricula") MATCH SIMPLE
    ON UPDATE NO ACTION ON DELETE NO ACTION
);
-- Inserir os dados da tabela original
INSERT INTO cargos ("funcionario_matricula","nome","inicio_cargo_dt","fim_cargo_dt","nome_dependente","nascimento_dependente_dt")
  SELECT "matricula","cargo","inicio_cargo_dt","fim_cargo_dt","nome_dependente","nascimento_dependente_dt"
  FROM funcionarios;
-- Apagar as colunas que não usamos mais na tabela original
ALTER TABLE Funcionarios
  DROP COLUMN "cargo",
  DROP COLUMN "inicio_cargo_dt",
  DROP COLUMN "fim_cargo_dt",
  DROP COLUMN "nome_dependente",
  DROP COLUMN "nascimento_dependente_dt";

 /*
 * 2FN
 */
-- Cria a tabela de N para N entre funcionarios e cargos
CREATE TABLE funcionarios_cargos (
  "id" serial NOT NULL,
  "funcionario_matricula" varchar(25) NOT NULL,
  "cargo_id" serial NOT NULL,
  "inicio_cargo_dt" date NOT NULL,
  "fim_cargo_dt" date NOT NULL,
  "nome_dependente" varchar(100) NOT NULL,
  "nascimento_dependente_dt" date NOT NULL,

  CONSTRAINT funcionarios_cargos_pk
    PRIMARY KEY ("id"),

  CONSTRAINT funcionarios_cargos_cargo_id_foreign FOREIGN KEY ("cargo_id")
    REFERENCES cargos("id") MATCH SIMPLE
    ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT funcionarios_cargos_funcionario_matricula_foreign FOREIGN KEY ("funcionario_matricula")
    REFERENCES funcionarios("matricula") MATCH SIMPLE
    ON UPDATE NO ACTION ON DELETE NO ACTION
);
-- Insere os dados na tabela funcionarios_cargos de cargos
INSERT INTO funcionarios_cargos (
    "funcionario_matricula","cargo_id","inicio_cargo_dt","fim_cargo_dt","nome_dependente","nascimento_dependente_dt"
  ) SELECT "funcionario_matricula","id","inicio_cargo_dt","fim_cargo_dt","nome_dependente","nascimento_dependente_dt"
  FROM cargos;
-- Apaga as colunas que não usamos mais em cargos
ALTER TABLE cargos
  DROP CONSTRAINT "cargos_funcionario_matricula_foreign",
  DROP COLUMN "funcionario_matricula",
  DROP COLUMN "inicio_cargo_dt",
  DROP COLUMN "fim_cargo_dt",
  DROP COLUMN "nome_dependente",
  DROP COLUMN "nascimento_dependente_dt";

/*
 * 3FN
 */
  -- Cria a tabela de dependentes
CREATE TABLE dependentes (
  "id" serial NOT NULL,
  "nome" varchar(100) NOT NULL,
  "nascimento_dt" date NOT NULL,

  CONSTRAINT dependentes_pk
    PRIMARY KEY ("id")
);
-- Insere os dados na tabela dependentes de funcionarios_cargos
INSERT INTO dependentes ("nome","nascimento_dt")
  SELECT "nome_dependente","nascimento_dependente_dt"
  FROM funcionarios_cargos;
-- Cria a tabela de N para N entre funcionarios e dependentes
CREATE TABLE funcionarios_dependentes (
  "id" serial NOT NULL,
  "funcionario_matricula" varchar(25) NOT NULL,
  "dependente_id" serial NOT NULL,

  CONSTRAINT funcionarios_dependentes_pk
    PRIMARY KEY ("id"),

  CONSTRAINT funcionarios_dependentes_dependente_id_foreign FOREIGN KEY ("dependente_id")
    REFERENCES dependentes("id") MATCH SIMPLE
    ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT funcionarios_cargos_funcionario_matricula_foreign FOREIGN KEY ("funcionario_matricula")
    REFERENCES funcionarios("matricula") MATCH SIMPLE
    ON UPDATE NO ACTION ON DELETE NO ACTION
);
-- Insere os dados na tabela funcionarios_cargos de cargos
INSERT INTO funcionarios_dependentes ("funcionario_matricula","dependente_id")
  SELECT fc."funcionario_matricula",(
    SELECT "id" FROM dependentes AS d WHERE d."nome" = fc."nome_dependente" AND d."nascimento_dt" = fc."nascimento_dependente_dt"
    )
  FROM funcionarios_cargos AS fc;
-- Apaga as colunas que não usamos mais em funcionarios_cargos
ALTER TABLE funcionarios_cargos
  DROP COLUMN "nome_dependente",
  DROP COLUMN "nascimento_dependente_dt";

