-- Apagar as colunas para refazer tudo
DROP TABLE IF EXISTS historicos;
DROP TABLE IF EXISTS alunos_turmas;
DROP TABLE IF EXISTS professores_turmas;
DROP TABLE IF EXISTS alunos;
DROP TABLE IF EXISTS professores;
DROP TABLE IF EXISTS bairros;
DROP TABLE IF EXISTS cidades;
DROP TABLE IF EXISTS turmas;
DROP TABLE IF EXISTS lugares;
DROP TABLE IF EXISTS periodos;
DROP TABLE IF EXISTS turnos;
DROP TABLE IF EXISTS disciplinas;

/*
 * Schema
 */

-- Cria a tabela de cidades
CREATE TABLE cidades (
  id serial NOT NULL,
  nome varchar(40) NOT NULL,

  CONSTRAINT cidades_pky
    PRIMARY KEY (id)
);

-- Cria a tabela de bairros
CREATE TABLE bairros (
  id serial NOT NULL,
  cidade_id serial NOT NULL,
  nome varchar(50) NOT NULL,

  CONSTRAINT bairros_pky
    PRIMARY KEY (id),

  CONSTRAINT bairros_cidade_id_foreign FOREIGN KEY (cidade_id)
    REFERENCES cidades(id) MATCH SIMPLE
    ON UPDATE NO ACTION ON DELETE NO ACTION
);

-- Cria a tabela de alunos
CREATE TABLE alunos (
  id serial NOT NULL,
  bairro_id serial NOT NULL,
  matricula varchar(15) NOT NULL UNIQUE,
  nome varchar(80) NOT NULL,

  CONSTRAINT alunos_pky
    PRIMARY KEY (id),

  CONSTRAINT alunos_bairro_id_foreign FOREIGN KEY (bairro_id)
    REFERENCES bairros(id) MATCH SIMPLE
    ON UPDATE NO ACTION ON DELETE NO ACTION
);

-- Cria a tabela de professores
CREATE TABLE professores (
  id serial NOT NULL,
  bairro_id serial NOT NULL,
  matricula varchar(15) NOT NULL UNIQUE,
  nome varchar(80) NOT NULL,

  CONSTRAINT professores_pky
    PRIMARY KEY (id),

  CONSTRAINT professores_bairro_id_foreign FOREIGN KEY (bairro_id)
    REFERENCES bairros(id) MATCH SIMPLE
    ON UPDATE NO ACTION ON DELETE NO ACTION
);

-- Cria a tabela de disciplinas
CREATE TABLE disciplinas (
  id serial NOT NULL,
  codigo varchar(10) NOT NULL UNIQUE,
  nome varchar(100) NOT NULL,
  carga_horaria smallint NOT NULL,

  CONSTRAINT disciplinas_pky
    PRIMARY KEY (id)
);

-- Cria a tabela de lugares
CREATE TABLE lugares (
  id serial NOT NULL,
  codigo varchar(10) NOT NULL UNIQUE,
  nome varchar(100) NOT NULL,

  CONSTRAINT lugares_pky
    PRIMARY KEY (id)
);

-- Cria a tabela de periodos
CREATE TABLE periodos (
  id serial NOT NULL,
  inicio_dt date NOT NULL,
  fim_dt date NOT NULL,

  CONSTRAINT periodos_pky
    PRIMARY KEY (id)
);

-- Cria a tabela de turnos
CREATE TABLE turnos (
  id serial NOT NULL,
  nome varchar(20) NOT NULL UNIQUE,

  CONSTRAINT turnos_pky
    PRIMARY KEY (id)
);

-- Cria a tabela de turmas
CREATE TABLE turmas (
  id serial NOT NULL,
  disciplina_id serial NOT NULL,
  periodo_id serial NOT NULL,
  lugar_id serial NOT NULL,
  turno_id serial NOT NULL,
  numero smallint NOT NULL,

  CONSTRAINT turmas_pky
    PRIMARY KEY (id),

  CONSTRAINT turmas_disciplina_id_foreign FOREIGN KEY (disciplina_id)
    REFERENCES disciplinas(id) MATCH SIMPLE
    ON UPDATE NO ACTION ON DELETE NO ACTION,

  CONSTRAINT turmas_periodo_id_foreign FOREIGN KEY (periodo_id)
    REFERENCES periodos(id) MATCH SIMPLE
    ON UPDATE NO ACTION ON DELETE NO ACTION,

  CONSTRAINT lugares_lugar_id_foreign FOREIGN KEY (lugar_id)
    REFERENCES lugares(id) MATCH SIMPLE
    ON UPDATE NO ACTION ON DELETE NO ACTION,

  CONSTRAINT turnos_turno_id_foreign FOREIGN KEY (turno_id)
    REFERENCES turnos(id) MATCH SIMPLE
    ON UPDATE NO ACTION ON DELETE NO ACTION
);

-- Cria a tabela que vincula professores e turmas
CREATE TABLE professores_turmas (
  id serial NOT NULL,
  professor_id serial NOT NULL,
  turma_id serial NOT NULL,

  CONSTRAINT professores_turmas_pky
    PRIMARY KEY (id),

  CONSTRAINT professores_turmas_professor_id_foreign FOREIGN KEY (professor_id)
    REFERENCES professores(id) MATCH SIMPLE
    ON UPDATE NO ACTION ON DELETE NO ACTION,

  CONSTRAINT professores_turmas_turma_id_foreign FOREIGN KEY (turma_id)
    REFERENCES turmas(id) MATCH SIMPLE
    ON UPDATE NO ACTION ON DELETE NO ACTION
);

-- Cria a tabela que vincula alunos e turmas
CREATE TABLE alunos_turmas (
  id serial NOT NULL,
  alunos_id serial NOT NULL,
  turma_id serial NOT NULL,

  CONSTRAINT alunos_turmas_pky
    PRIMARY KEY (id),

  CONSTRAINT alunos_turmas_aluno_id_foreign FOREIGN KEY (alunos_id)
    REFERENCES professores(id) MATCH SIMPLE
    ON UPDATE NO ACTION ON DELETE NO ACTION,

  CONSTRAINT alunos_turmas_turma_id_foreign FOREIGN KEY (turma_id)
    REFERENCES turmas(id) MATCH SIMPLE
    ON UPDATE NO ACTION ON DELETE NO ACTION
);

-- Cria a tabela de historicos
CREATE TABLE historicos (
  id serial NOT NULL,
  aluno_turma_id serial NOT NULL,
  frequencia smallint NOT NULL,
  nota decimal(5, 2) NOT NULL,
  situacao varchar(150) NOT NULL,

  CONSTRAINT historicos_pky
    PRIMARY KEY (id),

  CONSTRAINT historicos_aluno_turma_id_foreign FOREIGN KEY (aluno_turma_id)
    REFERENCES alunos_turmas(id) MATCH SIMPLE
    ON UPDATE NO ACTION ON DELETE NO ACTION,

  CONSTRAINT historicos_situacao_check CHECK (
      situacao = 'APR' OR
      situacao = 'APRN' OR
      situacao = 'REP' OR
      situacao = 'CANC' OR
      situacao = 'MATR' OR
      situacao = 'REPMF'
    )
);

/*
 * Inserts
 */
 -- Turnos
INSERT INTO turnos (nome) VALUES ('Manhã'), ('Tarde'), ('Noite');
 -- Cidades
INSERT INTO cidades (nome) VALUES ('Ceará-Mirim'), ('Ielmo Marinho'), ('Maxaranguape'),
                                  ('Monte Alegre'), ('Nísia Floresta'), ('São José de Mipibu'),
                                  ('Vera Cruz'), ('Bom Jesus'), ('Parnamirim'),
                                  ('Natal');
 -- Bairros de Natal
INSERT INTO bairros (nome, cidade_id) VALUES ('Alecrim', 10), ('Areia Preta', 10), ('Barro Vermelho', 10),
                                  ('Cidade Alta', 10), ('Lagoa Seca', 10), ('Petrópolis', 10),
                                  ('Ribeira', 10), ('Rocas', 10), ('Tirol', 10),
                                  ('Santos Reis', 10), ('Bom Pastor', 10), ('Cidade da Esperança', 10),
                                  ('Cidade Nova', 10), ('Dix-Sept Rosado', 10), ('Felipe Camarão', 10),
                                  ('Guarapes', 10), ('Nossa Senhora de Nazaré', 10), ('Candelária', 10),
                                  ('Capim Macio', 10), ('Lagoa Nova', 10), ('Neópolis', 10),
                                  ('Nova Descoberta', 10), ('Ponta Negra', 10), ('Igapó', 10),
                                  ('Nordeste', 10), ('Pitimbu', 10), ('Planalto', 10),
                                  ('Nossa Senhora da Apresentação', 10), ('Pajuçara', 10), ('Potengi', 10),
                                  ('Redinha', 10), ('Quintas', 10), ('Redinha', 10),
                                  ('Salinas', 10);