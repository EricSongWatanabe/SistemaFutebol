-- 1. Quais jogadores tem a finalização acima de 90 e são atacantes
SELECT nome, finalizacao, posicao
FROM Jogadores
WHERE finalizacao >= 90 AND posicao ILIKE 'atacante';

-- 2. Quais campeonatos são da confederação de id 1
SELECT c.id_campeonato, c.nome AS nome_campeonato, c.premiacao, conf.nome AS nome_confederacao
FROM Campeonatos c
JOIN Confederacoes conf ON c.id_conf = conf.id_conf
WHERE conf.id_conf = 1;


-- 3. Quais jogadores tem mais de 30 anos e o físico acima de 80
SELECT j.nome, j.idade, j.fisico, j.posicao, c.nome AS clube
FROM Jogadores j
JOIN Clubes c ON j.id_clube = c.id_clube
WHERE j.idade >= 30 AND j.fisico >= 80;

-- 4. Quais jogadores tem o valor de mercado acima de 30 milhões e são da posição zagueiro
SELECT j.nome, j.posicao, j.valor_de_mercado, c.nome AS clube
FROM Jogadores j
JOIN Clubes c ON j.id_clube = c.id_clube
WHERE j.valor_de_mercado > 30000000 AND j.posicao ILIKE 'zagueiro';

-- 5. Quais campeonatos tem premiação acima de 10 milhões
SELECT c.id_campeonato, c.nome AS nome_campeonato, c.premiacao, conf.nome AS confederacao
FROM Campeonatos c
JOIN Confederacoes conf ON c.id_conf = conf.id_conf
WHERE c.premiacao > 3000000;

-- 6. Quais comissoes tecnicas tem uma quantidade de membros maior que 8
SELECT c.id_clube, c.nome AS nome_clube, com.nome_tecnico, com.nome_auxiliar, com.qtd_membros
FROM clubes c
JOIN comissoes_tecnicas com ON c.id_clube = com.id_clube
WHERE qtd_membros > 8;

-- 7. Quais clubes tem o ano de origem acima de 1900 e o país de origem é o Brasil
SELECT id_clube, nome, ano_de_fundacao, pais_de_origem, patrocinio
FROM Clubes
WHERE ano_de_fundacao > 1900 AND pais_de_origem ILIKE 'brasil';

-- 8. Quais clubes estão em apenas uma confederação
SELECT cc.id_clube, cl.nome
FROM Clube_Confederacao cc
JOIN Clubes cl ON cc.id_clube = cl.id_clube
GROUP BY cc.id_clube, cl.nome
HAVING COUNT(cc.id_conf) = 1;

-- 9. Quais comissões técnicas estão sem clube no momento
SELECT id_comissao, nome_tecnico, nome_auxiliar, qtd_membros
FROM Comissoes_Tecnicas
WHERE id_clube IS NULL;

-- 10. Quais clubes tem mais de 5 títulos
SELECT id_clube, SUM(titulos) AS total_titulos
FROM campeonato_clube
GROUP BY id_clube HAVING SUM(titulos) > 5;
