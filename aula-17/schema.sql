-- Apagar as colunas para refazer tudo
DROP TABLE IF EXISTS historicos;
DROP TABLE IF EXISTS alunos_turmas;
DROP TABLE IF EXISTS professores_turmas;
DROP TABLE IF EXISTS alunos;
DROP TABLE IF EXISTS status_aluno;
DROP TABLE IF EXISTS professores;
DROP TABLE IF EXISTS bairros;
DROP TABLE IF EXISTS cidades;
DROP TABLE IF EXISTS turmas;
DROP TABLE IF EXISTS lugares;
DROP TABLE IF EXISTS periodos;
DROP TABLE IF EXISTS turnos;
DROP TABLE IF EXISTS disciplinas;

/*
 * Início
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

-- Cria tabela de status_aluno
CREATE TABLE status_aluno (
  id serial NOT NULL,
  status VARCHAR(15) NOT NULL UNIQUE,

  CONSTRAINT status_aluno_pky
    PRIMARY KEY (id)
);

-- Cria a tabela de alunos
CREATE TABLE alunos (
  id serial NOT NULL,
  bairro_id serial NOT NULL,
  status_aluno_id serial NOT NULL,
  matricula varchar(15) NOT NULL UNIQUE,
  nome varchar(80) NOT NULL,

  CONSTRAINT alunos_pky
    PRIMARY KEY (id),

  CONSTRAINT alunos_bairro_id_foreign FOREIGN KEY (bairro_id)
    REFERENCES bairros(id) MATCH SIMPLE
    ON UPDATE NO ACTION ON DELETE NO ACTION,

  CONSTRAINT alunos_status_aluno_id_foreign FOREIGN KEY (status_aluno_id)
    REFERENCES status_aluno(id) MATCH SIMPLE
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
    REFERENCES alunos(id) MATCH SIMPLE
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
INSERT INTO turnos (id, nome) VALUES (1, 'Manhã'), (2, 'Tarde'), (3, 'Noite');
-- Cidades
INSERT INTO cidades (id, nome) VALUES (1, 'Ceará-Mirim'), (2, 'Nísia Floresta'), (3, 'São José de Mipibu'),
                                  (4, 'Parnamirim'), (5, 'Natal');
-- Bairros de Natal
INSERT INTO bairros (id, nome, cidade_id) VALUES (1, 'Alecrim', 5), (2, 'Barro Vermelho', 5),
                                                 (3, 'Cidade Alta', 5), (4, 'Petrópolis', 5),
                                                 (5, 'Ribeira', 5), (6, 'Tirol', 5), (7, 'Felipe Camarão', 5),
                                                 (8, 'Candelária', 5), (9, 'Capim Macio', 5), (10, 'Lagoa Nova', 5),
                                                 (11, 'Neópolis', 5), (12, 'Bairro X', 1), (13, 'Bairro Y', 2);
-- Status
INSERT INTO status_aluno (id, status) VALUES (1, 'matriculado'), (2, 'desistencia'), (3, 'formado');
-- Alunos
INSERT INTO alunos (id, bairro_id, status_aluno_id, matricula, nome) VALUES (1, 1, 3, '201601', 'Aluno A'),
                                                                            (2, 1, 3, '201602', 'Aluno B'),
                                                                            (3, 5, 2, '201603', 'Aluno C'),
                                                                            (4, 9, 1, '201701', 'Aluno D'),
                                                                            (5, 1, 1, '201702', 'Aluno E'),
                                                                            (6, 11, 1, '201801', 'Aluno F'),
                                                                            (7, 12, 1, '201703', 'Aluno G'),
                                                                            (8, 12, 1, '201704', 'Aluno H');
-- Lugares
INSERT INTO lugares (id, codigo, nome) VALUES (1, 'A305', 'Laboratório A305');
INSERT INTO lugares (id, codigo, nome) VALUES (2, 'A306', 'Laboratório A306');
INSERT INTO lugares (id, codigo, nome) VALUES (3, 'B307', 'Laboratório B307');
INSERT INTO lugares (id, codigo, nome) VALUES (4, 'B308', 'Laboratório B308');
INSERT INTO lugares (id, codigo, nome) VALUES (5, 'A309', 'Laboratório A309');
-- Disciplinas
INSERT INTO disciplinas (id, codigo, nome, carga_horaria) VALUES (1, 'IMD1101', 'APRENDIZADO DE MÁQUINA', 60),
                                                                 (2, 'IMD0401', 'BANCO DE DADOS', 60),
                                                                 (3, 'IMD1130', 'BANCOS DE DADOS NOSQL', 60),
                                                                 (4, 'DIM0121', 'FUNDAMENTOS MATEMÁTICOS DA COMPUTAÇÃO II', 90),
                                                                 (5, 'DIM0495', 'TÓPICOS ESPECIAIS EM COMPUTAÇÃO XIV', 60),
                                                                 (6, 'IMD04012', 'BANCO DE DADOS II', 60);
-- Periodos
INSERT INTO periodos (id, inicio_dt, fim_dt) VALUES (1, '2018-08-01', '2018-12-20'),
                                                    (2, '2019-02-26', '2019-07-05'),
                                                    (3, '2019-08-01', '2019-12-20');
-- Turmas
INSERT INTO turmas (id, disciplina_id, periodo_id, lugar_id, turno_id, numero) VALUES (1, 1, 3, 1, 1, 1),
                                                                                      (2, 2, 3, 2, 1, 1),
                                                                                      (3, 3, 3, 3, 1, 1),
                                                                                      (4, 4, 3, 4, 2, 1),
                                                                                      (5, 5, 3, 5, 3, 1),
                                                                                      (6, 4, 2, 4, 2, 2),
                                                                                      (7, 6, 3, 2, 3, 1);
-- Professores
INSERT INTO professores (id, bairro_id, matricula, nome) VALUES (1, 1, 'Prof01', 'Professor A'), (2, 1, 'Prof02', 'Professor B'),
                                                                (3, 6, 'Prof03', 'Professor C'), (4, 7, 'Prof04', 'Professor D'),
                                                                (5, 10, 'Prof05', 'Professor E'), (6, 11, 'Prof06', 'Professor F'),
                                                                (7, 8, 'Prof07Sem', 'Professor Sem disciplina');

-- Professores_turmas
INSERT INTO professores_turmas (id, professor_id, turma_id) VALUES (1, 1, 4), (2, 2, 4),
                                                                   (3, 3, 1), (4, 4, 2),
                                                                   (5, 5, 3), (6, 6, 5),
                                                                   (7, 2, 7);