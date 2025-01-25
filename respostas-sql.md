# Respostas Desafio Blue

### Obs: algumas modificações foram aplicadas nos códigos de criação de tabelas, considerando que o desafio foi realizado usando-se MariaDB. Logo, o comando 'VISIBLE' foi descartado. Também tomei a liberdade de colocar um 'AUTO_INCREMENT' na criação da tabela de endereços.

## 1 - A partir da tabela cliente, apresente query’s para atualizar com os dados da mesma as tabelas endereco e telefone.

- Tabela enderecos

```sql
-- caso a tabela esteja vazia:
INSERT INTO endereco (id_cliente, endereco_logradouro, bairro, cep, uf_endereco, cidade, id_pais)
SELECT id_cliente, end_logradouro, end_bairro, end_cep, end_uf_estado, end_cidade, id_pais
FROM cliente;

-- caso já esteja com dados:
UPDATE endereco AS e INNER JOIN cliente AS c ON e.id_cliente = c.id_cliente
SET
    e.endereco_logradouro = c.end_logradouro,
    e.bairro = c.end_bairro,
    e.cep = c.end_cep,
    e.uf_endereco = c.end_uf_estado,
    e.cidade = c.end_cidade,
    e.id_pais = c.id_pais;
```

- Tabela telefones

```sql
-- caso a tabela esteja vazia:
INSERT INTO telefone (id_cliente, telefone_res, telefone_cel, telefone_com)
SELECT id_cliente, fone_res, fone_cel, fone_com
FROM cliente
ON DUPLICATE KEY UPDATE
    telefone_res = VALUES(telefone_res),
    telefone_cel = VALUES(telefone_cel),
    telefone_com = VALUES(telefone_com);

-- caso já esteja com dados:
UPDATE telefone AS t
INNER JOIN cliente AS c ON t.id_cliente = c.id_cliente
SET
    t.telefone_res = c.fone_res,
    t.telefone_cel = c.fone_cel,
    t.telefone_com = c.fone_com;
```

## 2 - Apresente query’s para remoção das colunas que não são mais necessárias na tabela clientes, após a alimentação de dados das tabelas endereco e telefone.

```sql
ALTER TABLE cliente
    DROP COLUMN end_logradouro,
    DROP COLUMN end_bairro,
    DROP COLUMN end_cep,
    DROP COLUMN end_uf_estado,
    DROP COLUMN end_cidade;
    DROP COLUMN id_pais;

ALTER TABLE cliente
    DROP COLUMN fone_res,
    DROP COLUMN fone_cel,
    DROP COLUMN fone_com;
```

## 3 - Apresente uma query com a seleção agrupada dos dados das três tabelas.

```sql
SELECT
    c.id_cliente,
    c.nome,
    c.sobrenome,
    c.data_nasc,
    e.endereco_logradouro,
    e.bairro,
    e.cep,
    e.uf_endereco,
    e.cidade,
    t.telefone_res,
    t.telefone_cel,
    t.telefone_com
FROM cliente c
    LEFT JOIN endereco e ON c.id_cliente = e.id_cliente
    LEFT JOIN telefone t ON c.id_cliente = t.id_cliente
GROUP BY c.id_cliente;
```

## 4 - Crie uma tabela (contatos_sp), com as seguintes colunas:

    a. id_contato
    b. id_cliente
    c. id_endereco
    d. id_telefone
    e. endereço_completo (logradouro + cidade + uf + cep)

```sql
CREATE TABLE contatos_sp (
    id_contato INT NOT NULL AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    id_endereco INT NOT NULL,
    id_telefone INT NOT NULL,
    endereco_completo VARCHAR(255) NULL,
    PRIMARY KEY (id_contato),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (id_endereco) REFERENCES endereco(id_endereco),
    FOREIGN KEY (id_telefone) REFERENCES telefone(id_telefone)
);
```

## 5 - Alimente a nova tabela contatos_sp com os dados combinados das outras tabelas, dos clientes do estado de SP e que a coluna óbito esteja com o valor igual a 0.

```sql
INSERT INTO contatos_sp (id_cliente, id_endereco, id_telefone, endereco_completo)
SELECT
    c.id_cliente,
    e.id_endereco,
    t.id_telefone,
    CONCAT(e.endereco_logradouro, ' ', e.cidade, ' ', e.uf_endereco, ' ', e.cep) AS endereco_completo
FROM cliente c
    JOIN endereco e ON c.id_cliente = e.id_cliente
    JOIN telefone t ON c.id_cliente = t.id_cliente
WHERE c.end_uf_estado = 'SP' AND c.obito = 0;
```

## 6 - Aplique regras para que ao atualizar ou inserir dados nas tabelas cliente, endereço e telefone a tabela contatos_sp seja atualiza ou alimentada, para os clientes do estado de SP .

- trigger de insercao:

```sql
CREATE TRIGGER after_insert_cliente
AFTER INSERT ON cliente
FOR EACH ROW
BEGIN
    -- insere em endereco:
    INSERT INTO endereco (id_cliente, endereco_logradouro, bairro, cep, uf_endereco, cidade, id_pais)
    VALUES (
        NEW.id_cliente,
        NEW.end_logradouro,
        NEW.end_bairro,
        NEW.end_cep,
        NEW.end_uf_estado,
        NEW.end_cidade,
        NEW.id_pais
    );

    -- insere em telefone:
    INSERT INTO telefone (id_cliente, telefone_res, telefone_cel, telefone_com)
    VALUES (
        NEW.id_cliente,
        NEW.fone_res,
        NEW.fone_cel,
        NEW.fone_com
    );

    -- insere em contatos_sp, se o cliente for de SP e o óbito for 0:
    INSERT INTO contatos_sp (id_cliente, id_endereco, id_telefone, endereco_completo)
    SELECT
        NEW.id_cliente,
        e.id_endereco,
        t.id_telefone,
        CONCAT(e.endereco_logradouro, ' ', e.cidade, ' ', e.uf_endereco, ' ', e.cep) AS endereco_completo
    FROM endereco e
    INNER JOIN telefone t ON e.id_cliente = t.id_cliente
    WHERE e.id_cliente = NEW.id_cliente
    AND t.id_cliente = NEW.id_cliente
    AND NEW.end_uf_estado = 'SP'
    AND NEW.obito = 0
    ORDER BY e.id_endereco DESC, t.id_telefone DESC
    LIMIT 1;
END;
```

- trigger de atualização:

```sql
CREATE DEFINER=`root`@`%` TRIGGER after_update_cliente
AFTER UPDATE ON cliente
FOR EACH ROW
BEGIN
    -- atualiza endereco:
    UPDATE endereco SET
        endereco_logradouro = NEW.end_logradouro,
        bairro = NEW.end_bairro,
        cep = NEW.end_cep,
        uf_endereco = NEW.end_uf_estado,
        cidade = NEW.end_cidade,
        id_pais = NEW.id_pais
    WHERE id_cliente = NEW.id_cliente;

    -- atualiza telefone:
    UPDATE telefone SET
        telefone_res = NEW.fone_res,
        telefone_cel = NEW.fone_cel,
        telefone_com = NEW.fone_com
    WHERE id_cliente = NEW.id_cliente;

    IF NEW.end_uf_estado = 'SP' AND NEW.obito = 0 THEN
        UPDATE contatos_sp
        SET
            id_endereco = (SELECT id_endereco
                           FROM endereco
                           WHERE id_cliente = NEW.id_cliente
                           ORDER BY id_endereco DESC LIMIT 1),
            id_telefone = (SELECT id_telefone
                           FROM telefone
                           WHERE id_cliente = NEW.id_cliente
                           ORDER BY id_telefone DESC LIMIT 1),
            endereco_completo = CONCAT(
                (SELECT endereco_logradouro
                 FROM endereco
                 WHERE id_cliente = NEW.id_cliente
                 ORDER BY id_endereco DESC LIMIT 1),
                ' ',
                (SELECT cidade
                 FROM endereco
                 WHERE id_cliente = NEW.id_cliente
                 ORDER BY id_endereco DESC LIMIT 1),
                ' ',
                (SELECT uf_endereco
                 FROM endereco
                 WHERE id_cliente = NEW.id_cliente
                 ORDER BY id_endereco DESC LIMIT 1),
                ' ',
                (SELECT cep
                 FROM endereco
                 WHERE id_cliente = NEW.id_cliente
                 ORDER BY id_endereco DESC LIMIT 1)
            )
        WHERE id_cliente = NEW.id_cliente;

        IF ROW_COUNT() = 0 THEN
            INSERT INTO contatos_sp (id_cliente, id_endereco, id_telefone, endereco_completo)
            SELECT
                NEW.id_cliente,
                e.id_endereco,
                t.id_telefone,
                CONCAT(e.endereco_logradouro, ' ', e.cidade, ' ', e.uf_endereco, ' ', e.cep) AS endereco_completo
            FROM endereco e
            INNER JOIN telefone t ON e.id_cliente = t.id_cliente
                WHERE e.id_cliente = NEW.id_cliente
                AND t.id_cliente = NEW.id_cliente
                ORDER BY e.id_endereco DESC, t.id_telefone DESC
            LIMIT 1;
        END IF;
    ELSE
        DELETE FROM contatos_sp WHERE id_cliente = NEW.id_cliente;
    END IF;
END;
```

## 7 - Aplique uma regra para que ao remover um dado da tabela cliente, os dados atrelados ao mesmo das outras tabelas, também sejam removidos.

```sql
-- alterar endereco
ALTER TABLE endereco DROP FOREIGN KEY fk_id_cliente_endereco;
ALTER TABLE endereco
ADD CONSTRAINT fk_id_cliente_endereco
FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente) ON DELETE CASCADE;

-- alterar telefone
ALTER TABLE telefone DROP FOREIGN KEY fk_id_cliente_telefone;
ALTER TABLE telefone
ADD CONSTRAINT fk_id_cliente_telefone
FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente) ON DELETE CASCADE;


-- alterar contatos_sp
ALTER TABLE contatos_sp DROP FOREIGN KEY contatos_sp_ibfk_1;
ALTER TABLE contatos_sp DROP FOREIGN KEY contatos_sp_ibfk_2;
ALTER TABLE contatos_sp DROP FOREIGN KEY contatos_sp_ibfk_3;

ALTER TABLE contatos_sp
ADD CONSTRAINT contatos_sp_ibfk_1
FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente) ON DELETE CASCADE;

ALTER TABLE contatos_sp
ADD CONSTRAINT contatos_sp_ibfk_2
FOREIGN KEY (id_endereco) REFERENCES endereco(id_endereco) ON DELETE CASCADE;

ALTER TABLE contatos_sp
ADD CONSTRAINT contatos_sp_ibfk_3
FOREIGN KEY (id_telefone) REFERENCES telefone(id_telefone) ON DELETE CASCADE;
```
