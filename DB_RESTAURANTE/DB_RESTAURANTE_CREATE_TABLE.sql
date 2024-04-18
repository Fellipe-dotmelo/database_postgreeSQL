-- CRIANDO TABLES
CREATE TABLE MESAS(
	ID INT NOT NULL PRIMARY KEY,
	MESA_CODIGO VARCHAR(20),
	MESA_SITUACAO VARCHAR(1) DEFAULT 'A',
	DATA_CRIACAO TIMESTAMP,
	DATA_ATUALIZACAO TIMESTAMP
);

-- GRAVANDO REGISTROS FUNCIONARIOS
CREATE TABLE FUNCIONARIOS(
	ID INT NOT NULL PRIMARY KEY,
	FUNCIONARIO_CODIGO VARCHAR(20),
	FUNCIONARIO_NOME VARCHAR(100),
	FUNCIONARIO_SITUACAO VARCHAR(1) DEFAULT 'A',
	FUNCIONARIO_COMISSAO REAL,
	FUNCIONARIO_CARGO VARCHAR(30),
	DATA_CRIACAO TIMESTAMP,
	DATA_ATUALIZACAO TIMESTAMP	
);

CREATE TABLE VENDAS(
	ID INT NOT NULL PRIMARY KEY,
	FUNCIONARIO_ID INT REFERENCES FUNCIONARIOS(ID),
	MESA_ID INT REFERENCES MESAS(ID),
	VENDA_CODIGO VARCHAR(20),
	VENDA_VALOR REAL,
	VENDA_TOTAL REAL,
	VENDA_DESCONTO REAL,
	VENDA_SITUACAO VARCHAR(1) DEFAULT 'A',
	DATA_CRICAO TIMESTAMP,
	DATA_ATUALIZACAO TIMESTAMP
);

CREATE TABLE PRODUTOS(
	ID INT NOT NULL PRIMARY KEY,
	PRODUTO_CODIGO VARCHAR(20),
	PRODUTO_NOME VARCHAR(60),
	PRODUTO_VALOR REAL,
	PRODUTO_SITUACAO VARCHAR(1) DEFAULT 'A',
	DATA_CRICAO TIMESTAMP,
	DATA_ATUALIZACAO TIMESTAMP
);

CREATE TABLE ITENS_VENDAS(
	ID INT NOT NULL PRIMARY KEY,
	PRODUTO_ID INT NOT NULL REFERENCES PRODUTOS(ID),
	VENDAS_ID INT NOT NULL REFERENCES VENDAS(ID),
	ITEM_VALOR REAL,
	ITEM_QUANTIDADE INT,
	ITEM_TOTAL REAL,
	DATA_CRIACAO TIMESTAMP,
	DATA_ATUALIZACAO TIMESTAMP
);

CREATE TABLE COMISSOES(
	ID INT NOT NULL PRIMARY KEY,
	FUNCIONARIO_ID INT REFERENCES FUNCIONARIOS(ID),
	COMISSAO_VALOR REAL,
	COMISSAO_SITUACAO VARCHAR(1) DEFAULT 'A',
	DATA_CRIACAO TIMESTAMP,
	DATA_ATUALIZACAO TIMESTAMP
);

ALTER TABLE COMISSOES ADD COLUMN DATA_PAGAMENTO TIMESTAMP;

