-- Apaga as functions, triggers e views caso exista
DROP TRIGGER IF EXISTS clientes_check_iu ON clientes;
DROP FUNCTION IF EXISTS clientes_check;
DROP TRIGGER IF EXISTS servicos_check_iu ON servicos;
DROP FUNCTION IF EXISTS servicos_check;
DROP TRIGGER IF EXISTS orcamentos_i ON orcamentos;
DROP FUNCTION IF EXISTS orcamentos_insert;
DROP TRIGGER IF EXISTS itens_i ON itens;
DROP FUNCTION IF EXISTS itens_insert;
DROP VIEW IF EXISTS vw_orcamentos;

-- c) Crie uma função (FUNCTION) que faça a verificação (inserção e alteração) dos campos
--   nomeCliente, CPF e email da tabela Cliente, de tal forma que valores nulos não sejam
--   aceitos. Na sequência, crie um gatilho (TRIGGER) para que essa função seja disparada.
CREATE FUNCTION clientes_check() RETURNS trigger AS $clientes_check$
BEGIN
    -- Verificar se nome do cliente é nulo
    IF NEW.nome IS NULL THEN
        RAISE EXCEPTION 'O nome do cliente não pode ser nulo';
    END IF;
    -- Verificar se cpf do cliente é nulo
    IF NEW.cpf IS NULL THEN
        RAISE EXCEPTION 'O cpf do cliente não pode ser nulo';
    END IF;
    -- Verificar se email do cliente é nulo
    IF NEW.email IS NULL THEN
        RAISE EXCEPTION 'O email do cliente não pode ser nulo';
    END IF;
RETURN NEW;
END;
$clientes_check$ LANGUAGE plpgsql;

CREATE TRIGGER clientes_check_iu BEFORE INSERT OR UPDATE
    ON clientes
    FOR EACH  ROW EXECUTE PROCEDURE clientes_check();

-- d) Crie uma função (FUNCTION) que faça a verificação (inserção e alteração) dos campos
--   descricaoServico, valorServico e horasServico da tabela Serviços, de tal forma
--   que valores nulos ou menores que R$ 10,00 não sejam aceitos. Na sequência, crie um gatilho
--   (TRIGGER) para que essa função seja disparada [1,0].
CREATE FUNCTION servicos_check() RETURNS trigger AS $servicos_check$
BEGIN
    -- Verificar se descricao do serviço é nulo
    IF NEW.descricao IS NULL THEN
        RAISE EXCEPTION 'A descrição do serviço não pode ser nulo';
    END IF;
    -- Verificar se valor do serviço é nulo
    IF NEW.valor IS NULL THEN
        RAISE EXCEPTION 'O valor do serviço não pode ser nulo';
    END IF;
    -- Verificar se horas do serviço é nulo
    IF NEW.horas IS NULL THEN
        RAISE EXCEPTION 'As horas do serviço não pode ser nulo';
    END IF;
    -- Verificar se valor do serviço é menor que 10
    IF NEW.valor < 10.0 THEN
        RAISE EXCEPTION 'O valor do não pode ser menor do que 10';
    END IF;
RETURN NEW;
END;
$servicos_check$ LANGUAGE plpgsql;

CREATE TRIGGER servicos_check_iu BEFORE INSERT OR UPDATE
    ON servicos
    FOR EACH  ROW EXECUTE PROCEDURE servicos_check();

-- e) Crie uma função (FUNCTION) de inserção na tabela Orçamento, de tal forma que os valores para
--   os campos situacao, dataInicio, totalValor, totalHoras sejam atribuídos
--   automaticamente na seguinte forma: 'ABERTO', data atual, 0.0, 0. Na sequência, crie um gatilho
--   (TRIGGER) para que essa função seja disparada [1,0].
CREATE FUNCTION orcamentos_insert() RETURNS trigger AS $orcamentos_insert$
BEGIN
    -- Atribui os valores
    INSERT INTO orcamentos(situacao, inicio_dt, total_valor, total_horas)
    VALUES ('ABERTO', now(), 0.0, 0);
END;
$orcamentos_insert$ LANGUAGE plpgsql;

CREATE TRIGGER orcamentos_i BEFORE INSERT
    ON orcamentos
    FOR EACH  ROW EXECUTE PROCEDURE orcamentos_insert();

-- f) Crie uma função (FUNCTION) de inserção na tabela Itens, de tal forma que o valor para o campo
--   situacaoServico seja atribuído automaticamente na seguinte forma: 'ABERTO'. Na sequência, crie
--   um gatilho (TRIGGER) para que essa função seja disparada [1,0].
CREATE FUNCTION itens_insert() RETURNS trigger AS $itens_insert$
BEGIN
    -- Atribui os valores
    INSERT INTO itens(situacao)
    VALUES ('ABERTO');
END;
$itens_insert$ LANGUAGE plpgsql;

CREATE TRIGGER itens_i BEFORE INSERT
    ON itens
    FOR EACH  ROW EXECUTE PROCEDURE itens_insert();

-- g) Crie uma view chamada vw_Orcamento que será usada para mostrar os clientes
--   (nomeCliente, CPF e email) que possuem Orçamentos (descricaoProblema,
--   situacao, totalValor as ValorPagar e totalHoras as HorasTrabalhadas) e
--   quais Serviços (descricaoServico, valorServico e horasServico) foram executados
--   [1,0].
CREATE VIEW vw_orcamentos AS
    SELECT c.nome,c.cpf,c.email,
           o.descricao_problema,o.situacao,o.total_valor AS valor_pagar,o.total_horas AS horas_trabalhadas,
           s.descricao,s.valor,s.horas FROM clientes AS c
        LEFT JOIN orcamentos AS o ON c.id = o.cliente_id
        LEFT JOIN itens AS i ON o.id = i.orcamento_id
        LEFT JOIN servicos AS s ON i.servico_id = s.id
    ORDER BY c.nome;
