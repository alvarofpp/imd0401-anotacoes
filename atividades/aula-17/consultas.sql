-- a) Mostre quais são os bairros de Natal que possuem alunos matriculados
SELECT DISTINCT b.nome FROM bairros AS b RIGHT JOIN alunos a ON b.id = a.bairro_id
WHERE cidade_id = (
  SELECT id FROM cidades WHERE nome = 'Natal'
);

-- b) Mostre a matrícula e o nome de todos os alunos que são de Natal
SELECT a.matricula, a.nome FROM bairros AS b JOIN alunos a ON b.id = a.bairro_id
WHERE cidade_id = (
  SELECT id FROM cidades WHERE nome = 'Natal'
);

-- c) Mostre quais a disciplinas (código e nome) que estão alocadas no laboratório A305
SELECT DISTINCT d.codigo, d.nome FROM disciplinas AS d WHERE id IN (
  SELECT DISTINCT disciplina_id FROM turmas WHERE lugar_id = (
    SELECT id FROM lugares WHERE codigo = 'A305'
  )
);

-- d) Mostre a quantidade de bairros para cada uma das cidades cadastradas, onde o nome da cidade
--    deverá aparecer seguido da quantidade de bairros
SELECT c.nome, COUNT(b) AS qtde_bairros FROM cidades AS c
    JOIN bairros AS b ON c.id = b.cidade_id
GROUP BY c.id, c.nome ORDER BY c.nome;

-- e) Mostre a quantidade de alunos por cidade, onde o nome da cidade deverá aparecer seguido da
--    quantidade de alunos matriculados ('matriculados')
SELECT c.nome, COUNT(a) AS qtde_matriculados FROM cidades AS c
JOIN bairros AS b ON c.id = b.cidade_id
JOIN alunos AS a ON b.id = a.bairro_id WHERE a.status_aluno_id = (
  SELECT id FROM status_aluno WHERE status = 'matriculado'
) GROUP BY c.id, c.nome ORDER BY c.nome;

-- f) Mostre a carga horária total das disciplinas ministradas, onde o nome do professor deverá aparecer
--    seguido do valor total da carga horária. Observe que as colunas deverão apresentar os nomes
--    'professor' e 'ch', respectivamente
SELECT p.nome AS professor, SUM(d.carga_horaria) FROM turmas AS t
LEFT JOIN disciplinas AS d ON t.disciplina_id = d.id
LEFT JOIN professores_turmas AS pt ON t.id = pt.turma_id
RIGHT JOIN professores AS p ON pt.professor_id = p.id
GROUP BY p.id, p.nome ORDER BY p.nome;

-- g) Mostre o nome do professor e o SIAPE para todos eles que estão sem disciplinas cadastradas
SELECT p.nome AS professor, p.matricula AS siape FROM professores AS p
WHERE p.id NOT IN (
  SELECT DISTINCT p.id FROM professores_turmas AS pt
  LEFT JOIN professores p on pt.professor_id = p.id
);

-- h) Mostre os códigos e cargas horárias das disciplinas que são lecionadas no turno da noite
--    (NOTURNO), assim como os nomes dos professores e nomes dos alunos envolvidos com as mesmas

