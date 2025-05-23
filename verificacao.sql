-- Reseta os ids 
TRUNCATE TABLE 
    jogadores, 
    campeonato_clube, 
    clube_confederacao, 
    campeonatos, 
    clubes, 
    comissoes_tecnicas, 
    confederacoes 
RESTART IDENTITY CASCADE;


-- Confere a tabela jogadores
SELECT *
FROM Jogadores
WHERE nome IS NULL
   OR posicao IS NULL
   OR idade <= 0
   OR numero <= 0
   OR finalizacao NOT BETWEEN 0 AND 100
   OR defesa NOT BETWEEN 0 AND 100
   OR fisico NOT BETWEEN 0 AND 100
   OR valor_de_mercado < 0
   OR (id_clube IS NOT NULL AND id_clube NOT IN (SELECT id_clube FROM Clubes));


-- Confere a tabela campeonatos
SELECT *
FROM Campeonatos
WHERE nome IS NULL
   OR nome = ''
   OR premiacao < 0
   OR id_conf NOT IN (SELECT id_conf FROM Confederacoes);

-- Confere a tabela clubes
SELECT *
FROM Clubes
WHERE nome IS NULL
   OR nome = ''
   OR ano_de_fundacao <= 0
   OR pais_de_origem IS NULL
   OR pais_de_origem = '';

-- Confere a tabela Clube_Confederacao
SELECT *
FROM Clube_Confederacao cc
WHERE id_clube NOT IN (SELECT id_clube FROM Clubes)
   OR id_conf NOT IN (SELECT id_conf FROM Confederacoes);

-- Confere a tabela Campeonato_Clube
SELECT *
FROM Campeonato_Clube cc
WHERE id_campeonato NOT IN (SELECT id_campeonato FROM Campeonatos)
   OR id_clube NOT IN (SELECT id_clube FROM Clubes)
   OR titulos < 0;

-- Confere a tabela Comissoes_Tecnicas
SELECT *
FROM Comissoes_Tecnicas
WHERE qtd_membros <= 0
   OR (id_clube IS NOT NULL AND id_clube NOT IN (SELECT id_clube FROM Clubes));