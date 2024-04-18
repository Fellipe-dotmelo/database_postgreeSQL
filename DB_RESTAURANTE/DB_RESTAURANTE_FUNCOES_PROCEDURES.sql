-- CRIANDO FUNÇÕES/CONJUNTOS DE PROCEDIMENTOS

CREATE OR REPLACE FUNCTION 
            RETORNA_NOME_FUNCIONARIO(FUNC_ID INT) 
            RETURNS TEXT AS 
            $$              
            DECLARE 
            NOME     TEXT;   
            SITUACAO TEXT;
            BEGIN
			
              SELECT FUNCIONARIO_NOME,
                     FUNCIONARIO_SITUACAO
                INTO NOME, SITUACAO
                FROM FUNCIONARIOS
               WHERE ID = FUNC_ID;	
	           
               IF SITUACAO = 'A' THEN
                 RETURN NOME || ' USUÁRIO ATIVO';                 
               ELSE                  
                 RETURN NOME || ' USUÁRIO INATIVO';                 
               END IF;  
			   
            END
            $$ 
            LANGUAGE PLPGSQL;
			
SELECT RETORNA_NOME_FUNCIONARIO(1);



CREATE OR REPLACE FUNCTION 
            RT_VALOR_COMISSAO(FUNC_ID INT)
            RETURNS REAL AS 
            $$
            DECLARE             
              VALOR_COMISSAO REAL;
             
            BEGIN              
              SELECT FUNCIONARIO_COMISSAO
                INTO VALOR_COMISSAO
                FROM FUNCIONARIOS
               WHERE ID = FUNC_ID;               
               RETURN VALOR_COMISSAO;
            END
            $$
            LANGUAGE PLPGSQL;

SELECT RT_VALOR_COMISSAO(1);


CREATE OR REPLACE FUNCTION 
             CALC_COMISSAO(DATA_INI TIMESTAMP,
                           DATA_FIM TIMESTAMP)
             RETURNS VOID AS $$
             DECLARE 
            
            -- DECLARAÇÃO DAS VARIÁVEIS QUE IREMOS
            -- UTILIZAR. JÁ NA DECLARAÇÃO ELAS
            -- RECEBEM O VALOR ZERO. POIS ASSIM
            -- GARANTO QUE ELAS ESTARÃO ZERADAS
            -- QUANDO FOR UTILIZA-LAS.
            
               TOTAL_COMISSAO  REAL := 0;
               PORC_COMISSAO   REAL := 0;
			   
			-- DECLARANDO UMA VARIAVEL PARA ARMAZENAR 
			-- OS REGISTROS DOS LOOP
			   REG             RECORD;
               
            --CURSOR PARA BUSCAR A % DE COMISSÃO DO FUNCIONARIO
            
              CR_PORCE CURSOR (FUNC_ID INT) IS 
                  SELECT RT_VALOR_COMISSAO(FUNC_ID);

             BEGIN
            
            -- REALIZA UM LOOP E BUSCA TODAS AS VENDAS
            --  NO PEREÍODO INFORMADO
            
                FOR REG IN( 
                  SELECT VENDAS.ID ID,
                         FUNCIONARIO_ID,
                         VENDA_TOTAL
                    FROM VENDAS
                   WHERE DATA_CRIACAO >= DATA_INI
                     AND DATA_CRIACAO <= DATA_FIM 
                     AND VENDA_SITUACAO = 'A')LOOP         
            
            -- ABERTURA, UTILIZAÇÃO E FECHAMENTO DO CURSOR
            
                  OPEN CR_PORCE(REG.FUNCIONARIO_ID);
                  FETCH CR_PORCE INTO PORC_COMISSAO;
                  CLOSE CR_PORCE;
                  
                             
                  TOTAL_COMISSAO := (REG.VENDA_TOTAL * 
                                    PORC_COMISSAO)/100;
                 
            -- INSERE NA TABELA DE COMISSOES O VALOR 
            -- QUE O FUNCIONARIO IRA RECEBER DE COMISSAO
            -- DAQUELA VENDA
            
                  INSERT INTO COMISSOES(
                                        FUNCIONARIO_ID,
                                        COMISSAO_VALOR,
                                        COMISSAO_SITUACAO,
                                        DATA_CRIACAO,
                                        DATA_ATUALIZACAO) 
                  VALUES(REG.FUNCIONARIO_ID,
                         TOTAL_COMISSAO,
                         'A',
                         NOW(),
                         NOW());
            
            -- UPDATE NA SITUACAO DA VENDA 
            -- PARA QUE ELA NÃO SEJA MAIS COMISSIONADA
            
                  UPDATE VENDAS SET VENDA_SITUACAO = 'C'
                   WHERE ID = REG.ID;
            
            -- DEVEMOS ZERAR AS VARIÁVEIS PARA REUTILIZA-LAS
            
                   TOTAL_COMISSAO := 0;
                   PORC_COMISSAO  := 0;
                  
            -- TERMINO DO LOOP
            
                END LOOP;                                    
             
             END
             $$ LANGUAGE PLPGSQL;

SELECT CALC_COMISSAO('01/01/2016 00:00:00','01/01/2016 00:00:00');

SELECT COMISSAO_VALOR,
                    DATA_CRIACAO
               FROM COMISSOES;

POSTGRESQL=> DROP FUNCTION CALC_COMISSOES();    
