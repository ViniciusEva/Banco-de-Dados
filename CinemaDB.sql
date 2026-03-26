
CREATE DATABASE CinemaDB;
USE CinemaDB;


CREATE TABLE Filme (
    id_filme INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(150) NOT NULL,
    diretor VARCHAR(100),
    duracao_min INT,
    genero VARCHAR(50),
    classificacao VARCHAR(10)
);


CREATE TABLE Sala (
    id_sala INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    capacidade_total INT NOT NULL
);


CREATE TABLE Cliente (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) UNIQUE,
    email VARCHAR(100)
);

-- Tabela de Sessões (Relaciona Filme e Sala)
CREATE TABLE Sessao (
    id_sessao INT PRIMARY KEY AUTO_INCREMENT,
    data_hora DATETIME NOT NULL,
    idioma VARCHAR(20),
    preco_base DECIMAL(10,2),
    fk_filme INT,
    fk_sala INT,
    FOREIGN KEY (fk_filme) REFERENCES Filme(id_filme),
    FOREIGN KEY (fk_sala) REFERENCES Sala(id_sala)
);

-- Tabela de Ingressos (Relaciona Sessão e Cliente)
CREATE TABLE Ingresso (
    id_ingresso INT PRIMARY KEY AUTO_INCREMENT,
    assento VARCHAR(10) NOT NULL,
    tipo_ingresso VARCHAR(20), -- Ex: Meia, Inteira
    data_venda TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fk_sessao INT,
    fk_cliente INT,
    FOREIGN KEY (fk_sessao) REFERENCES Sessao(id_sessao),
    FOREIGN KEY (fk_cliente) REFERENCES Cliente(id_cliente)
);

SHOW TABLES;




-- Adicionando uma regra de unicidade ao título do filme
ALTER TABLE Filme ADD CONSTRAINT UC_Titulo UNIQUE (titulo);




-- Inserindo Filmes
INSERT INTO Filme (titulo, diretor, duracao_min, genero, classificacao) VALUES 
('Interestelar', 'Christopher Nolan', 169, 'Ficção Científica', '12'),
('O Auto da Compadecida', 'Guel Arraes', 104, 'Comédia', 'Livre'),
('Batman: O Cavaleiro das Trevas', 'Christopher Nolan', 152, 'Ação', '12');

-- Inserindo Salas
INSERT INTO Sala (nome, capacidade_total) VALUES 
('Sala IMAX 01', 300),
('Sala 3D Premium', 150),
('Sala XD 05', 200);

INSERT INTO Cliente (nome, cpf, email) VALUES 
('Ana Souza', '123.456.789-00', 'ana.souza@email.com'),
('Carlos Lima', '987.654.321-11', 'carlos.lima@email.com');

INSERT INTO Sessao (data_hora, idioma, preco_base, fk_filme, fk_sala) VALUES 
('2026-04-10 19:30:00', 'Legendado', 45.00, 1, 1), -- Interestelar na Sala IMAX
('2026-04-10 21:00:00', 'Dublado', 30.00, 2, 2);    -- O Auto da Compadecida na Sala 3D

INSERT INTO Ingresso (assento, tipo_ingresso, fk_sessao, fk_cliente) VALUES 
('A12', 'Inteira', 1, 1), -- Ana na sessão de Interestelar
('B05', 'Meia', 1, 2);    -- Carlos na sessão de Interestelar

-- Ver todos os filmes cadastrados
SELECT * FROM Filme;

-- Ver todos os clientes,

SELECT * FROM Cliente;

-- Ver todas as salas
SELECT * FROM Sala;

-- Ver todas as sessões
SELECT * FROM Sessao;

-- Ver todas os ingressos
SELECT * FROM Ingressos;


CREATE VIEW View_Detalhes_Ingressos AS
SELECT 
    I.id_ingresso AS 'Cod_Ticket',
    C.nome AS 'Cliente',
    C.cpf AS 'CPF_Cliente',
    F.titulo AS 'Filme',
    F.genero AS 'Genero',
    S.data_hora AS 'Data_Hora',
    SA.nome AS 'Sala',
    I.assento AS 'Assento',
    I.tipo_ingresso AS 'Tipo',
    S.preco_base AS 'Valor'
FROM Ingresso I
JOIN Cliente C ON I.fk_cliente = C.id_cliente
JOIN Sessao S ON I.fk_sessao = S.id_sessao
JOIN Filme F ON S.fk_filme = F.id_filme
JOIN Sala SA ON S.fk_sala = SA.id_sala;

SELECT * FROM View_Detalhes_Ingressos;
