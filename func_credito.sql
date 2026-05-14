-- ==========================================================
-- 1. CONFIGURAÇÃO INICIAL E BANCO DE MERCADO
-- ==========================================================
CREATE DATABASE IF NOT EXISTS BD_Mercado;
USE BD_Mercado;

# Criação das Tabelas do Mercado
CREATE TABLE Produto (
    id INT NOT NULL PRIMARY KEY,
    nome VARCHAR(30) NOT NULL,
    valor_unitario DECIMAL(10,2),
    dt_validade DATE NOT NULL,
    estoque INT NOT NULL DEFAULT 0
);

CREATE TABLE Venda (
    id_venda INT PRIMARY KEY,
    data_venda DATE NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    caixa_registrador INT NOT NULL
);

CREATE TABLE ItensVendido (
    id_ItemVendido INT PRIMARY KEY,
    id_venda INT NOT NULL,
    id_prod INT NOT NULL,
    quantidade INT NOT NULL,
    valor_unitario DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_produto FOREIGN KEY (id_prod) REFERENCES Produto (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_Venda FOREIGN KEY (id_venda) REFERENCES Venda (id_venda) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ----------------------------------------------------------
-- TRIGGER: Validação de Estoque (Ajustada para BEFORE)
-- ----------------------------------------------------------
DELIMITER $
CREATE TRIGGER tgrInserirItensVendidos BEFORE INSERT ON ItensVendido
FOR EACH ROW
BEGIN
    DECLARE v_estoque_atual INT;

    SELECT estoque INTO v_estoque_atual FROM Produto WHERE id = NEW.id_prod;

    IF (v_estoque_atual < NEW.quantidade) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro: Estoque insuficiente!';
    ELSE
        UPDATE Produto SET estoque = estoque - NEW.quantidade WHERE id = NEW.id_prod;
        UPDATE Venda SET valor_total = valor_total + (NEW.quantidade * NEW.valor_unitario) 
        WHERE id_venda = NEW.id_venda;
    END IF;
END $
DELIMITER ;

-- ==========================================================
-- 2. TABELA DE PESSOAS E STORED PROCEDURE (FAMILIA)
-- ==========================================================
CREATE TABLE pessoas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    sobrenome VARCHAR(50) NOT NULL
);

INSERT INTO pessoas (nome, sobrenome) VALUES 
('Silvio', 'Santos'), ('Maria', 'Silva'), ('João', 'Silva'), ('Ricardo', 'Santos');

DELIMITER $
CREATE PROCEDURE sp_buscar_familia(IN p_sobrenome VARCHAR(50))
BEGIN
    SELECT * FROM pessoas WHERE sobrenome LIKE CONCAT('%', p_sobrenome, '%');
END $
DELIMITER ;

-- ==========================================================
-- 3. TABELA DE CLIENTES E STORED FUNCTION (CRÉDITO)
-- ==========================================================
CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(200) NOT NULL,
    status VARCHAR(20) NOT NULL, -- 'ativo'/'inativo'
    saldo_credito DECIMAL(10, 2)
);

INSERT INTO clientes(nome, status, saldo_credito) VALUES
('Marcos','ativo',500), ('Laura','inativo',800), ('Helena','ativo',800);

DELIMITER $
CREATE FUNCTION fn_calcular_ajuste_credito(p_id INT) 
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE v_status VARCHAR(20);
    DECLARE v_saldo DECIMAL(10, 2);
    
    SELECT status, saldo_credito INTO v_status, v_saldo FROM clientes WHERE id = p_id;
    
    IF v_status = 'ativo' THEN
        RETURN v_saldo + 200.00;
    ELSE
        RETURN v_saldo - 100.00;
    END IF;
END $
DELIMITER ;

-- ==========================================================
-- 4. ÁREA DE TESTES (DEMONSTRAÇÃO)
-- ==========================================================

# Teste Mercado (Inserindo Produto e Venda)
INSERT INTO Produto VALUES (1, 'Leite', 5.00, '2026-12-31', 10);
INSERT INTO Venda VALUES (101, CURDATE(), 0, 1);

# Este comando deve FUNCIONAR (diminui estoque para 8)
INSERT INTO ItensVendido VALUES (1, 101, 1, 2, 5.00); 

# Este comando deve dar ERRO (estoque insuficiente)
-- INSERT INTO ItensVendido VALUES (2, 101, 1, 50, 5.00); 

# Teste Procedure Família
CALL sp_buscar_familia('Silva');

# Teste Função de Crédito (Simulação e Update)
SELECT nome, saldo_credito, fn_calcular_ajuste_credito(id) as projeção FROM clientes;
UPDATE clientes SET saldo_credito = fn_calcular_ajuste_credito(1) WHERE id = 1;

# Verificação Final
SELECT * FROM Produto;
SELECT * FROM clientes;
