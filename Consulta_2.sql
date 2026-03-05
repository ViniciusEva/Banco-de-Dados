CREATE database bdAulas202601;
USE bdAulas202601;
CREATE TABLE aluno 
(
	ra VARCHAR (13) PRIMARY KEY,
	nome VARCHAR (100) NOT NULL,
	cpf VARCHAR (11) NOT NULL UNIQUE,
	dataNasc DATE NOT NULL,
	telefone VARCHAR (30) NOT NULL
);



DESCRIBE aluno;

ALTER TABLE aluno ADD COLUMN nomePai VARCHAR(100);
ALTER TABLE aluno ADD COLUMN nomeMae VARCHAR(100);



CREATE TABLE disciplina 
(
	codigo SMALLINT PRIMARY KEY AUTO_INCREMENT,
	nome VARCHAR(50) NOT NULL,
	carga_horaria INT
);

CREATE TABLE cursa
(
	idCursa INT PRIMARY KEY AUTO_INCREMENT,
	ra VARCHAR (5) NOT NULL,
	cod SMALLINT NOT NULL,
	dataInicio DATE NOT NULL,
	FOREIGN KEY (ra) REFERENCES aluno(ra) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (cod) REFERENCES disciplina(codigo) ON DELETE CASCADE ON UPDATE CASCADE 
);

SHOW TABLES;
DESCRIBE aluno;
DESCRIBE cursa;
DESCRIBE disciplina;

ALTER TABLE aluno MODIFY  nome varchar (50) NOT NULL;
ALTER TABLE disciplina MODIFY  nome varchar (50) NOT NULL;
ALTER TABLE aluno ADD COLUMN telefone varchar(15);
 

RENAME TABLE cursa TO  aluno_disc;

ALTER TABLE disciplina DROP COLUMN carga_horaria;

CREATE TABLE usuarios (
	cod_usuario	int,
	cod_aluno VARCHAR(13),
	login	varchar(10),
	senha	varchar(10),
	n_acesso	decimal(1,0),

	CONSTRAINT pk_usuarios PRIMARY KEY (cod_usuario),
	CONSTRAINT fk_usuarios_aluno FOREIGN KEY (cod_aluno) REFERENCES aluno(ra),
	CONSTRAINT uk_usuarios UNIQUE (cod_aluno, n_acesso)
);


INSERT INTO aluno (ra, nome, cpf, ndataNasc, telefone)
VALUES (1, 'pedro','1111','1980-09-23','(11)4647-9876');

INSERT INTO aluno VALUES (2,'Marcos','1112','1984-10-03','(12)3875-9876');

INSERT INTO aluno VALUES 
(3,'Rita','1113','1999-08-18','(11)3257-9456'),
(4,'Carla','1114','1998-08-10','(11)3358-9557'),
(5,'Roberto','1115','2019-07-18','(12)3458-8466');

INSERT INTO aluno (ra, nome, dataNasc, telefone) VALUES
  (6, ‘Rita Maria’, ‘1116’,’1999-08-18’,’(11)3257-9456’),
  (7, ‘Susi’,’1117’, ’1998-08-10’,’(11)3358-9557’), 
  (8, ‘Clayton’,’1118’, ’2019-07-18’,’(12)3458-8466’);

INSERT INTO disciplina (codigo, nome) VALUES (1,’Banco de Dados’);
INSERT INTO disciplina (codigo, nome, carga_horaria) VALUES (2,’Técnicas de Programação’);
INSERT INTO disciplina (codigo, nome, carga_horaria) VALUES (3,’Análise OO’);

INSERT INTO cursa (cod_aluno, cod_disciplina, Data_inicio) VALUES (1,1, '2025-03-08');
INSERT INTO cursa (cod_aluno, cod_disciplina, Data_inicio) VALUES (2,1, '2025-03-08');
INSERT INTO cursa (cod_aluno, cod_disciplina, Data_inicio) VALUES (3,2, '2025-03-08');


SHOW TABLES;