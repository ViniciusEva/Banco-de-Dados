# Criação da tabela
CREATE TABLE pessoas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    sobrenome VARCHAR(50) NOT NULL
);

# Inserção de registros de exemplo
INSERT INTO pessoas (nome, sobrenome) VALUES 
('Silvio', 'Santos'),
('Maria', 'Silva'),
('João', 'Silva'),
('Aline', 'Pereira'),
('Ricardo', 'Santos'),
('Beatriz', 'Souza');

DELIMITER $$

CREATE PROCEDURE familia(IN sobrenome_param VARCHAR(50))
BEGIN
    SELECT id, nome, sobrenome 
    FROM pessoas 
    WHERE sobrenome LIKE CONCAT('%', sobrenome_param, '%');
END $$

DELIMITER ;

CALL familia('Silva');
CALL familia('Santos');
CALL familia('Oliveira');
CALL familia('Sou');
