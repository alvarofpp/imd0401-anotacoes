/*
 * Consultas
 */

/*
 * Mostre a descrição dos produtos que a quantidade solicitada foi
 * maior que 5.000.
 */
SELECT DISTINCT descricao FROM produtos WHERE id IN (
  SELECT produto_id FROM itens WHERE quantidade > 5000
);
-- Output: Descrição Z

/*
 * Mostre o nome dos funcionários, sem repetição, que fizeram
 * solicitações na data de ontem.
 */
SELECT DISTINCT nome FROM funcionarios WHERE id IN (
  SELECT funcionario_id FROM solicitacoes WHERE solicitacao_dt = (current_date - 1)
);
-- Output: Álvaro
