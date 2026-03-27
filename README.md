# 🗄️ Documentação de Estrutura de Banco de Dados Relacional (SQL)

Este repositório contém a implementação de um banco de dados relacional utilizando **MySQL**. O objetivo desta documentação é detalhar os conceitos de estruturação, tipos de dados e comandos fundamentais para a criação e manutenção de qualquer banco de dados.

---

## 📋 Sumário
  * Estrutura do Banco de Dados
  * Tipos de Dados Utilizados
  * Comandos e Sintaxe
  * Relacionamentos e Chaves
  * Views (Visualizações)

## 🏗️ Estrutura do Projeto

O banco de dados é construído sobre três pilares principais: **Entidades**, **Relacionamentos** e **Integridade**.

### 1. Definição de Ambiente (DDL)
Os comandos iniciais preparam o servidor para receber as estruturas:
* `CREATE DATABASE`: Cria o container lógico dos dados.
* `USE`: Define o contexto de execução para o banco específico.

### 2. Tabelas e Restrições
As tabelas são definidas com restrições (Constraints) para garantir que os dados sejam confiáveis:
* **PRIMARY KEY (PK)**: Identificador único de cada registro. Impede duplicidade de linhas.
* **AUTO_INCREMENT**: Recurso do sistema para gerar IDs sequenciais automaticamente.
* **NOT NULL**: Garante que campos essenciais (como nomes ou capacidades) não fiquem vazios.
* **UNIQUE**: Impede valores repetidos em colunas específicas (ex: CPF, E-mail ou Títulos).
* **FOREIGN KEY (FK)**: Chave estrangeira que cria o vínculo entre duas tabelas, garantindo a integridade referencial.

---

## 📊 Tipos de Dados Utilizados

| Tipo | Descrição | Uso Comum |
| :--- | :--- | :--- |
| `INT` | Números inteiros. | IDs, Contagens, Quantidades. |
| `VARCHAR(n)` | Texto de comprimento variável (até *n* caracteres). | Nomes, Descrições, Logins. |
| `DECIMAL(p,s)` | Números de ponto fixo para alta precisão. | Valores financeiros e moedas. |
| `DATETIME` | Armazena data e hora fixas. | Agendamentos e Eventos. |
| `TIMESTAMP` | Registro de data/hora que se atualiza automaticamente. | Auditoria e Logs de criação. |

---

## 🔗 Relacionamentos (Lógica de Negócio)

A arquitetura utiliza o conceito de tabelas de **Entidade** (dados mestres) e tabelas de **Associação** (fatos/eventos):

1. **Tabelas Mestres**: Armazenam cadastros base que não dependem de outros (ex: Clientes, Itens, Localizações).
2. **Tabelas de Ligação**: Utilizam chaves estrangeiras para conectar múltiplas entidades, permitindo representar eventos complexos (ex: Uma venda que conecta um cliente a um produto em um horário específico).

---

## 🛠️ Comandos Principais

### Manipulação (DML)
Para inserir e gerenciar informações:
```sql
-- Inserção de dados
INSERT INTO Nome_Tabela (coluna1, coluna2) VALUES ('Valor1', 'Valor2');
```

### Alteração de Estrutura (DDL)
Para modificar uma tabela já existente sem deletá-la:
```sql
-- Atualização (Exemplo conceitual)
ALTER TABLE Nome_Tabela ADD CONSTRAINT Nome_Regra UNIQUE (coluna);
```

## 🖼️ Views (Visualizações)
Foi implementada uma View para simplificar consultas complexas. A View salva um comando `SELECT` longo sob um nome amigável, permitindo que usuários consultem relatórios completos sem precisar escrever múltiplos Joins repetidamente.

## 📐 Wireframe da Arquitetura (Esquema Lógico)
Abaixo, uma representação visual de como as tabelas interagem entre si:

```wireframe
+----------------+          +----------------+          +----------------+
|     FILME      |          |     SALA       |          |    CLIENTE     |
+----------------+          +----------------+          +----------------+
| id_filme (PK)  |          | id_sala (PK)   |          | id_cliente (PK)|
| titulo         |          | nome           |          | nome           |
| diretor        |          | capacidade     |          | cpf (Unique)   |
+-------+--------+          +-------+--------+          +-------+--------+
        |                           |                           |
        |      +----------------+   |                           |
        +----->|     SESSAO     |<--+                           |
               +----------------+                               |
               | id_sessao (PK) |                               |
               | fk_filme (FK)  |                               |
               | fk_sala  (FK)  |                               |
               | data_hora      |                               |
               +-------+--------+                               |
                       |                                        |
                       |      +----------------+                |
                       +----->|    INGRESSO    |<---------------+
                              +----------------+
                              | id_ingresso(PK)|
                              | fk_sessao (FK) |
                              | fk_cliente(FK) |
                              | assento        |
                              +----------------+
```
