CREATE database bdAulas202601;

CREATE TABLE aluno 
(
	ra VARCHAR(13) PRIMARY KEY,
	nome VARCHAR (100) NOT NULL,
	cpf VARCHAR (11) NOT NULL UNIQUE,
	dataNasc DATE NOT NULL,
);

DESCRIBE aluno;
SHOW TABLES;

ALTER TABLE Aluno ADD COLUMN nomePai;
ALTER TABLE Aluno ADD COLUMN nomeMae;



CREATE TABLE disciplina 
(
	codigo SMALLINT PRIMARY KEY,
	nome VARCHAR(50) NOT NULL,
	carga_horaria INT
);

CREATE TABLE cursa
(
	Cod_aluno BIGINT,
	Cod_disciplina BIGINT,
	Data_inicio DATE,
	PRIMARY KEY (cod_aluno, cod_disciplina, data_inicio),
	FOREIGN KEY (cod_aluno) REFERENCES aluno(RA) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY(cod_disciplina) REFERENCES disciplina(codigo) ON DELETE CASCADE ON UPDATE CASCADE
);
