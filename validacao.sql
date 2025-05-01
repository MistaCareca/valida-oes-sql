-- criaçao da tabela
CREATE TABLE usuarios (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Criação de um trigger para validar senhas(insert ou att)
DELIMITER //

CREATE TRIGGER validar_senha BEFORE INSERT ON usuarios
FOR EACH ROW
BEGIN
    -- Verifica se a senha tem caracteres suficientes
    IF LENGTH(NEW.senha) < 12 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A senha deve ter pelo menos 12 caracteres.';
    END IF;

    -- Verifica maiúscula
    IF NEW.senha NOT REGEXP '[A-Z]' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A senha deve conter pelo menos uma letra maiúscula.';
    END IF;

    -- Verifica minúscula
    IF NEW.senha NOT REGEXP '[a-z]' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A senha deve conter pelo menos uma letra minúscula.';
    END IF;

    -- Verifica se pelo menos um número
    IF NEW.senha NOT REGEXP '[0-9]' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A senha deve conter pelo menos um número.';
    END IF;

    -- Verifica se pelo menos um caractere especial
    IF NEW.senha NOT REGEXP '[!@#$%^&*(),.?":{}|<>]' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A senha deve conter pelo menos um caractere especial.';
    END IF;

    -- Verifica se a senha contém sequências previsíveis (exemplo: '123' ou 'abc')
    IF NEW.senha REGEXP '123|abc|qwe|password|senha' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A senha não pode conter sequências previsíveis ou palavras comuns.';
    END IF;
END //

DELIMITER ;

-- inserção válida
INSERT INTO usuarios (nome, email, senha) 
VALUES ('João Silva', 'joao@example.com', 'Seguranca@1234');

-- inserção inválida 
INSERT INTO usuarios (nome, email, senha) 
VALUES ('Maria Souza', 'maria@example.com', 'senha123');