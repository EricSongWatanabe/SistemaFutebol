-- Criação da tabela Confederações
CREATE TABLE Confederacoes (
    id_conf SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    localidade VARCHAR(100)
);

-- Criação da tabela Campeonatos
CREATE TABLE Campeonatos (
    id_campeonato SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    premiacao NUMERIC,
    id_conf INT REFERENCES Confederacoes(id_conf)
);

-- Criação da tabela Clubes
CREATE TABLE Clubes (
    id_clube SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    ano_de_fundacao INT,
    pais_de_origem VARCHAR(100),
    patrocinio VARCHAR(100)
);

-- Criação da tabela Clube_Confederacao (relacionamento N:N entre clubes e confederações)
CREATE TABLE Clube_Confederacao (
    id_clube INT REFERENCES Clubes(id_clube),
    id_conf INT REFERENCES Confederacoes(id_conf),
    PRIMARY KEY (id_clube, id_conf)
);

-- Criação da tabela Campeonato_Clube (relacionamento N:N entre campeonatos e clubes)
CREATE TABLE Campeonato_Clube (
    id_campeonato INT REFERENCES Campeonatos(id_campeonato),
    id_clube INT REFERENCES Clubes(id_clube),
    titulos INT,
    PRIMARY KEY (id_campeonato, id_clube)
);

-- Criação da tabela Comissoes_Tecnicas
CREATE TABLE Comissoes_Tecnicas (
    id_comissao SERIAL PRIMARY KEY,
    nome_tecnico VARCHAR(100),
    nome_auxiliar VARCHAR(100),
    qtd_membros INT,
    id_clube INT REFERENCES Clubes(id_clube)
);

-- Criação da tabela Jogadores
CREATE TABLE Jogadores (
    rg_jogador SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    idade INT,
    numero INT,
    finalizacao INT CHECK (finalizacao BETWEEN 0 AND 100),
    defesa INT CHECK (defesa BETWEEN 0 AND 100),
    fisico INT CHECK (fisico BETWEEN 0 AND 100),
    posicao VARCHAR(50),
    valor_de_mercado NUMERIC,
    id_clube INT REFERENCES Clubes(id_clube)
);