--  Criar procedure Insere_Projeto
--  Criando procedure para cadastrar um novo projeto na base de dados:

CREATE OR REPLACE PROCEDURE brh.insere_projeto
(
    p_NOME          BRH.PROJETO.NOME%TYPE,
    p_RESPONSAVEL   BRH.PROJETO.RESPONSAVEL%TYPE,
    p_INICIO        BRH.PROJETO.INICIO%TYPE   
)  
IS
BEGIN
    INSERT INTO BRH.PROJETO
    (NOME, RESPONSAVEL, INICIO)
    VALUES
    (p_NOME, p_RESPONSAVEL, p_INICIO); 
END;


--_______________________________________________________________________________________
--  Criar fun��o calcula_idade
--  Criando uma fun��o que informa a idade a partir de uma data.

CREATE OR REPLACE FUNCTION  brh.calcula_idade
(
    p_DATA_NASCIMENTO IN  DATE
)
RETURN NUMBER
IS
    v_IDADE NUMBER;
BEGIN
    v_IDADE := TRUNC(MONTHS_BETWEEN (SYSDATE, p_DATA_NASCIMENTO)/12);
    return v_IDADE;
END;


--_______________________________________________________________________________________

--  Criar fun��o finaliza_projeto
--  Criando uma fun��o para registrar o t�rmino da execu��o de um projeto

CREATE OR REPLACE FUNCTION  brh.finaliza_projeto
(
    p_ID IN BRH.PROJETO.ID%TYPE
)
RETURN DATE
IS
    v_FIM DATE;
BEGIN
    v_FIM := TO_DATE(SYSDATE, 'DD/MM/YYYY');
    UPDATE BRH.PROJETO SET FIM = v_FIM WHERE ID = p_ID;
    RETURN v_FIM;
END;

--_______________________________________________________________________________________

--  Validar novo projeto
--  Alterando a procedure brh.insere_projeto para n�o permitir cadastrar projetos inv�lidos:
--  O nome do novo do projeto deve ter duas ou mais letras.
--  Se tiver menos caracteres, ou for null, lance uma exce��o com a mensagem "Nome de projeto inv�lido! Deve ter dois ou mais caracteres.".

CREATE OR REPLACE PROCEDURE brh.insere_projeto
(
    p_NOME          BRH.PROJETO.NOME%TYPE,
    p_RESPONSAVEL   BRH.PROJETO.RESPONSAVEL%TYPE,
    p_INICIO        BRH.PROJETO.INICIO%TYPE   
)  
IS
BEGIN
    IF LENGTH(p_NOME) < 2 OR p_NOME IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001,'Nome de projeto inv�lido! Deve ter dois ou mais caracteres.');
    ELSE
        INSERT INTO BRH.PROJETO
        (NOME, RESPONSAVEL, INICIO)
        VALUES
        (p_NOME, p_RESPONSAVEL, p_INICIO);
    END IF;
END;

--_______________________________________________________________________________________

--  Validar c�lculo de idade
--  Alterando a fun��o brh.calcula_idade para n�o permitir datas inv�lidas;

CREATE OR REPLACE FUNCTION  brh.calcula_idade
(
    p_DATA_NASCIMENTO IN  DATE
)
RETURN NUMBER
IS
    v_IDADE NUMBER;
BEGIN
    IF p_DATA_NASCIMENTO >= SYSDATE OR p_DATA_NASCIMENTO IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Imposs�vel calcular idade! Data inv�lida: '|| p_DATA_NASCIMENTO);
    ELSE    
        v_IDADE := TRUNC(MONTHS_BETWEEN (SYSDATE, p_DATA_NASCIMENTO)/12);
        return v_IDADE;
    END IF;
END;


--_______________________________________________________________________________________