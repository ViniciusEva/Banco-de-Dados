# 1. Criação do Banco de Dados
CREATE DATABASE IF NOT EXISTS BD_Mercado;
USE BD_Mercado;

# 2. Criação das Tabelas
CREATE TABLE Produto (
    id INT NOT NULL,
    nome VARCHAR(30) NOT NULL,
    valor_unitario DECIMAL(10,2),
    dt_validade DATE NOT NULL,
    estoque INT NOT NULL DEFAULT 0,
    PRIMARY KEY (id)
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

# 3. Trigger de Inserção com Validação de Estoque (Ajustada)
DELIMITER $

CREATE TRIGGER tgrInserirItensVendidos BEFORE INSERT
ON ItensVendido
FOR EACH ROW
BEGIN
    DECLARE estoque_atual INT;

    -- Busca o estoque disponível
    SELECT estoque INTO estoque_atual 
    FROM Produto 
    WHERE id = NEW.id_prod;

    -- Validação: Impede a venda se não houver estoque suficiente
    IF (estoque_atual < NEW.quantidade) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Erro: Estoque insuficiente para realizar a venda.';
    ELSE
        -- Se houver estoque, subtrai a quantidade do Produto
        UPDATE Produto 
        SET estoque = estoque - NEW.quantidade 
        WHERE id = NEW.id_prod;

        -- Atualiza o valor total da Venda
        UPDATE Venda 
        SET valor_total = valor_total + (NEW.quantidade * NEW.valor_unitario)
        WHERE id_venda = NEW.id_venda;
    END IF;
END $

DELIMITER ;

# 4. Trigger para quando itens são removidos
DELIMITER $

CREATE TRIGGER tgrItensVendidoRemovidos AFTER DELETE
ON ItensVendido
FOR EACH ROW
BEGIN
    -- Devolve a quantidade ao estoque
    UPDATE Produto 
    SET estoque = estoque + OLD.quantidade 
    WHERE id = OLD.id_prod;

    -- Subtrai o valor do total da venda
    UPDATE Venda 
    SET valor_total = valor_total - (OLD.quantidade * OLD.valor_unitario) 
    WHERE id_venda = OLD.id_venda;
END $

DELIMITER ;

# 5. Inserção de Dados Iniciais (Produtos e Vendas Vazias)
INSERT INTO Produto (id, nome, valor_unitario, dt_validade, estoque) VALUES (1, "leite", 4.95, "2023-11-27", 100);
INSERT INTO Produto (id, nome, valor_unitario, dt_validade, estoque) VALUES (2, "café", 18.95, "2024-02-20", 30);
INSERT INTO Produto (id, nome, estoque, dt_validade) VALUES (3, "bolachas", 40, "2023-11-27");

UPDATE Produto SET valor_unitario = 5.0, dt_validade = "2024-01-31" WHERE id = 3;

INSERT INTO Venda VALUES (1, "2022-11-27", 0, 1);
INSERT INTO Venda VALUES (2, "2022-11-27", 0, 2);

# 6. Testes de Inserção (DENTRO do limite de estoque)
INSERT INTO ItensVendido VALUES (1, 1, 1, 12, 4.95);
INSERT INTO ItensVendido VALUES (2, 1, 2, 12, 18.95);
INSERT INTO ItensVendido VALUES (3, 1, 3, 3, 5.0);

# Visualizando resultados após vendas bem-sucedidas
SELECT * FROM Produto;
SELECT * FROM Venda;

# 7. TESTE DA LIMITAÇÃO (Tentativa de vender mais do que tem no estoque)
# O Produto 2 (café) agora tem 18 unidades (30 iniciais - 12 vendidas).
# Vamos tentar vender 50 unidades. O MySQL deve bloquear:
-- INSERT INTO ItensVendido VALUES (4, 2, 2, 50, 18.95); 

# 8. Teste de Remoção (Trigger de DELETE)
DELETE FROM ItensVendido WHERE id_ItemVendido = 1;

# Visualizando resultados finais
SELECT * FROM Produto;
SELECT * FROM Venda;
SELECT * FROM ItensVendido;
