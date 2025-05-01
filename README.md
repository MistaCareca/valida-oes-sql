# Sistema de Gerenciamento de Usuários com Validação de Senha

## Descrição
Este projeto implementa um sistema de gerenciamento de usuários com um mecanismo de validação de senha robusto através de um trigger no banco de dados. Ele garante que as senhas dos usuários atendam a critérios de segurança antes de serem armazenadas.

## Estrutura do Banco de Dados
O banco de dados contém uma tabela principal:
- **usuarios**: Armazena informações dos usuários, incluindo nome, email (único), senha (criptografada) e a data de criação.

### Constraints
- O campo `email` possui a constraint `UNIQUE`, garantindo que cada usuário tenha um endereço de email distinto.
- O campo `senha` armazenará a senha do usuário (espera-se que seja criptografada pela aplicação antes da inserção, embora a validação ocorra no valor original).
- O campo `data_criacao` possui um valor padrão (`DEFAULT CURRENT_TIMESTAMP`), registrando automaticamente a data e hora da criação do usuário.

### Trigger
- Um trigger chamado `validar_senha` é acionado `BEFORE INSERT` em cada nova linha inserida na tabela `usuarios`. Este trigger verifica se a senha fornecida atende a critérios de complexidade.

## Pré-requisitos
- MySQL ou outro SGBD compatível com SQL e triggers.
- Permissões para criar tabelas e triggers no banco de dados.
- Conhecimento de boas práticas de segurança para senhas (criptografia na aplicação é essencial).

## Instalação
1. Execute o script SQL fornecido para criar a tabela e o trigger no seu banco de dados.
   ```bash
   mysql -u [usuário] -p < seu_script_usuarios.sql
   ```
   (Substitua `seu_script_usuarios.sql` pelo nome do arquivo que contém o código SQL.)
2. Conecte-se ao banco de dados onde você deseja criar a tabela e o trigger:
   ```sql
   -- Se necessário, selecione o banco de dados
   -- USE nome_do_banco_de_dados;
   ```

## Estrutura do Script
O script contém:
1. **Criação da Tabela `usuarios`**:
   - `id_usuario`: Identificador único do usuário (chave primária, auto incremento).
   - `nome`: Nome do usuário (campo obrigatório).
   - `email`: Endereço de email do usuário (campo obrigatório e único).
   - `senha`: Senha do usuário (campo obrigatório, espera-se que seja criptografada na aplicação).
   - `data_criacao`: Data e hora da criação do usuário (com valor padrão para o timestamp atual).
2. **Criação do Trigger `validar_senha`**:
   - Acionado `BEFORE INSERT` na tabela `usuarios`.
   - Realiza as seguintes verificações na nova senha (`NEW.senha`):
     - Comprimento mínimo de 12 caracteres.
     - Presença de pelo menos uma letra maiúscula (`[A-Z]`).
     - Presença de pelo menos uma letra minúscula (`[a-z]`).
     - Presença de pelo menos um número (`[0-9]`).
     - Presença de pelo menos um caractere especial (`[!@#$%^&*(),.?":{}|<>]`).
     - Ausência de sequências previsíveis ou palavras comuns (`123|abc|qwe|password|senha`).
   - Se alguma das condições não for atendida, o trigger impede a inserção e retorna um erro (`SIGNAL SQLSTATE '45000'`) com uma mensagem descritiva.
3. **Exemplos de Inserção**:
   - Uma inserção válida que atende a todos os critérios de senha.
   - Uma inserção inválida que não atende aos critérios de senha.

## Funcionalidades
- **Cadastro de Usuários**: Permite o registro de novos usuários com nome, email único e senha.
- **Validação de Senha no Banco de Dados**: Garante que todas as novas senhas atendam a um conjunto de requisitos de segurança definidos no trigger, antes de serem armazenadas no banco. Isso adiciona uma camada de segurança ao nível do banco de dados.
- **Registro de Data e Hora de Criação**: A data e hora em que o usuário é cadastrado são automaticamente registradas.
