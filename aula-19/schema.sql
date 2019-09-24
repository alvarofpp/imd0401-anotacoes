-- Apagar as colunas para refazer tudo
DROP TABLE IF EXISTS itens;
DROP TABLE IF EXISTS orcamentos;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS servicos;

/*
 * Início
 */

-- Cria a tabela de clientes
CREATE TABLE clientes (
  id serial NOT NULL,
  nome varchar(40) NOT NULL,
  cpf varchar(11) NOT NULL UNIQUE,
  email varchar(120) NOT NULL UNIQUE,

  CONSTRAINT clientes_pky
    PRIMARY KEY (id)
);

-- Cria a tabela de servicos
CREATE TABLE servicos (
  id serial NOT NULL,
  descricao varchar(150) NOT NULL,
  valor decimal(5,2) NOT NULL,
  horas integer NOT NULL,

  CONSTRAINT servicos_pky
    PRIMARY KEY (id)
);

-- Cria a tabela de orcamentos
CREATE TABLE orcamentos (
  id serial NOT NULL,
  cliente_id serial NOT NULL,
  descricao_problema text NOT NULL,
  situacao varchar(10) NOT NULL,
  inicio_dt date NOT NULL,
  fim_dt date DEFAULT NULL,
  total_valor integer NOT NULL,
  total_horas integer NOT NULL,

  CONSTRAINT orcamentos_pky
    PRIMARY KEY (id),

  CONSTRAINT orcamentos_cliente_id_foreign FOREIGN KEY (cliente_id)
    REFERENCES clientes(id) MATCH SIMPLE
    ON UPDATE NO ACTION ON DELETE NO ACTION,

  CONSTRAINT orcamentos_situacao_check CHECK (
      situacao = 'ABERTO' OR
      situacao = 'AGUARDANDO' OR
      situacao = 'APROVADO' OR
      situacao = 'FINALIZADO'
    )
);

-- Cria a tabela de itens
CREATE TABLE itens (
  id serial NOT NULL,
  servico_id serial NOT NULL,
  orcamento_id serial NOT NULL,
  situacao varchar(10) NOT NULL,

  CONSTRAINT itens_pky
    PRIMARY KEY (id),

  CONSTRAINT itens_servico_id_foreign FOREIGN KEY (servico_id)
    REFERENCES servicos(id) MATCH SIMPLE
    ON UPDATE NO ACTION ON DELETE NO ACTION,

  CONSTRAINT itens_orcamento_id_foreign FOREIGN KEY (orcamento_id)
    REFERENCES orcamentos(id) MATCH SIMPLE
    ON UPDATE NO ACTION ON DELETE NO ACTION,

  CONSTRAINT itens_situacao_check CHECK (
      situacao = 'ABERTO' OR
      situacao = 'AGUARDANDO' OR
      situacao = 'APROVADO' OR
      situacao = 'FINALIZADO'
    )
);

/*
 * Inserts
 */
-- Clientes
INSERT INTO clientes (id, nome, cpf, email) VALUES (1, 'Cliente A', '00000000001', 'cliente_a@gmail.com'),
                                                   (2, 'Cliente B', '00000000002', 'cliente_b@gmail.com'),
                                                   (3, 'Cliente C', '00000000003', 'cliente_c@gmail.com'),
                                                   (4, 'Cliente D', '00000000004', 'cliente_d@gmail.com'),
                                                   (5, 'Cliente E', '00000000005', 'cliente_e@gmail.com'),
                                                   (6, 'Cliente F', '00000000006', 'cliente_f@gmail.com'),
                                                   (7, 'Cliente G', '00000000007', 'cliente_g@gmail.com'),
                                                   (8, 'Cliente H', '00000000008', 'cliente_h@gmail.com'),
                                                   (9, 'Cliente I', '00000000009', 'cliente_i@gmail.com'),
                                                   (10, 'Cliente J', '00000000010', 'cliente_j@gmail.com');
-- Serviços
INSERT INTO servicos (id, descricao, valor, horas) VALUES (1, 'Serviço 1', 80.25, 1),
                                                          (2, 'Serviço 2', 90.5, 2),
                                                          (3, 'Serviço 3', 100.99, 3),
                                                          (4, 'Serviço 4', 110.25, 4),
                                                          (5, 'Serviço 5', 120.44, 5),
                                                          (6, 'Serviço 6', 130.30, 6),
                                                          (7, 'Serviço 7', 150.0, 7),
                                                          (8, 'Serviço 8', 160.75, 8),
                                                          (9, 'Serviço 9', 200.50, 9),
                                                          (10, 'Serviço 10', 300.0, 10);
-- Orçamentos
INSERT INTO orcamentos (id, descricao_problema, situacao, inicio_dt, fim_dt, total_valor, total_horas) VALUES (1, 'Orçamento 1', 'ABERTO', now(), now(), 1000, 15),
                                                                                                              (2, 'Orçamento 2', 'ABERTO', now(), now(), 2000, 25),
                                                                                                              (3, 'Orçamento 3', 'AGUARDANDO', now(), now(), 1500, 17),
                                                                                                              (4, 'Orçamento 4', 'AGUARDANDO', now(), now(), 1750, 19),
                                                                                                              (5, 'Orçamento 5', 'APROVADO', now(), now(), 1800, 22),
                                                                                                              (6, 'Orçamento 6', 'APROVADO', now(), now(), 3245, 18),
                                                                                                              (7, 'Orçamento 7', 'FINALIZADO', now(), now(), 1200, 17),
                                                                                                              (8, 'Orçamento 8', 'FINALIZADO', now(), now(), 800, 17),
                                                                                                              (9, 'Orçamento 9', 'FINALIZADO', now(), now(), 1400, 19),
                                                                                                              (10, 'Orçamento 10', 'FINALIZADO', now(), now(), 1600, 20);
-- Itens
INSERT INTO itens (id, servico_id, orcamento_id, situacao) VALUES (1, 1, 1, 'ABERTO'),
                                                                  (2, 1, 1, 'ABERTO'),
                                                                  (3, 1, 1, 'AGUARDANDO'),
                                                                  (4, 1, 1, 'AGUARDANDO'),
                                                                  (5, 1, 1, 'APROVADO'),
                                                                  (6, 1, 1, 'APROVADO'),
                                                                  (7, 1, 1, 'FINALIZADO'),
                                                                  (8, 1, 1, 'FINALIZADO'),
                                                                  (9, 1, 1, 'FINALIZADO'),
                                                                  (10, 1, 1, 'FINALIZADO');

