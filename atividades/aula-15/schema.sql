-- Apagar as colunas para refazer tudo
DROP TABLE IF EXISTS itens;
DROP TABLE IF EXISTS solicitacoes;
DROP TABLE IF EXISTS produtos;
DROP TABLE IF EXISTS funcionarios;

-- Cria a tabela de produtos
CREATE TABLE produtos (
  id serial NOT NULL,
  descricao varchar(20) NOT NULL,

  CONSTRAINT produtos_pky
    PRIMARY KEY (id)
);

-- Cria a tabela de funcionarios
CREATE TABLE funcionarios (
  id serial NOT NULL,
  nome varchar(45) NOT NULL,

  CONSTRAINT funcionarios_pky
    PRIMARY KEY (id)
);

-- Cria a tabela de solicitacoes
CREATE TABLE solicitacoes (
  id serial NOT NULL,
  funcionario_id serial NOT NULL,
  solicitacao_dt date NOT NULL,

  CONSTRAINT solicitacoes_pky
    PRIMARY KEY (id),

  CONSTRAINT solicitacoes_funcionario_id_foreign FOREIGN KEY (funcionario_id)
    REFERENCES funcionarios(id) MATCH SIMPLE
    ON UPDATE NO ACTION ON DELETE NO ACTION
);

-- Cria a tabela de itens
CREATE TABLE itens (
  id serial NOT NULL,
  solicitacao_id serial NOT NULL,
  produto_id serial NOT NULL,
  quantidade integer NULL,

  CONSTRAINT itens_pky
    PRIMARY KEY (id),

  CONSTRAINT itens_solicitacao_id_foreign FOREIGN KEY (solicitacao_id)
    REFERENCES solicitacoes(id) MATCH SIMPLE
    ON UPDATE NO ACTION ON DELETE NO ACTION,

  CONSTRAINT itens_produto_id_foreign FOREIGN KEY (produto_id)
    REFERENCES produtos(id) MATCH SIMPLE
    ON UPDATE NO ACTION ON DELETE NO ACTION
);

/*
 * Inserts
 */
-- Funcionários
INSERT INTO funcionarios (id, nome) VALUES (1, 'Álvaro'), (2, 'Rebeka');

-- Produtos
INSERT INTO produtos (id, descricao) VALUES (1, 'Descrição X'), (2, 'Descrição Y'), (3, 'Descrição Z');

-- Solicitações
INSERT INTO solicitacoes (id, funcionario_id, solicitacao_dt) VALUES (1, 1, '2019-07-25'),
                                                                 (2, 1, (current_date - 1)),
                                                                 (3, 2, now());

-- Itens
INSERT INTO itens (solicitacao_id, produto_id, quantidade) VALUES (1, 1, 4500),
                                                                  (2, 2, 4650),
                                                                  (3, 3, 5100);
