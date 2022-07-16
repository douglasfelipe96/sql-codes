create or replace TRIGGER TASY.SIM_CRIAR_SOLIC_EXAM_CPOE_TRG
  BEFORE INSERT ON TASY.PRESCR_PROCEDIMENTO
  FOR EACH ROW
  
--<DS_SCRIPT>
-- DESCRIÇÃO..............: Gera solicitação de exames com base nos procedimentos prescritos na CPOE
-- RESPONSAVEL............: DOUGLAS FELIPE
-- DATA...................: 22/02/2022
-- APLICAÇÃO..............: TASY <CPOE>
--</DS_SCRIPT>

DECLARE
    TYPE T_NUM IS TABLE OF NUMBER;
    CD_ESTABELECIMENTO_W T_NUM;
    CD_PROCEDIMENTO_W T_NUM;
    IE_ORIGEM_PROCED_W T_NUM;
    NR_SEQ_PROC_INT_W T_NUM;
    QT_EXAME_W T_NUM;

    NR_PRESCRICAO_W NUMBER := :NEW.NR_PRESCRICAO;

    CD_PESSOA_FISICA_W NUMBER;
    CD_MEDICO_W NUMBER;
    DT_LIBERACAO_W NUMBER;

    NR_SEQ_W  NUMBER(10);
    VAR_PEDIDO_EXAM_PROC NUMBER;
    CD_FUNCAO_ORIGEM_W NUMBER;
    NR_SEQ_ASSINATURA_W NUMBER (10,0);
    
    var_TOTAL NUMBER; -- Douglas em 31/03/22
    var_dt_suspensao DATE := :NEW.DT_SUSPENSAO; -- Douglas em 31/03/2022

BEGIN
-- retorna se dados advindos da CPOE e impede que ações como suspensão de itens gere solicitação VAR_DT_SUSPENSAO
 IF(OBTER_DADOS_PRESCRICAO(NR_PRESCRICAO_W,'CFO') = 2314 AND var_dt_suspensao is null) THEN

    -- retorna se existe materiais prescritos liberados
      SELECT count(*)
        INTO DT_LIBERACAO_W
     FROM cpoe_procedimento
        WHERE 1=1 
        AND nr_atendimento = OBTER_DADOS_PRESCRICAO(NR_PRESCRICAO_W,'A')
        AND dt_suspensao IS NULL
        AND trunc(dt_liberacao) = trunc(sysdate);

    -- retorna o código da pessoa fisica e codigo do medico
      SELECT DISTINCT cd_pessoa_fisica, cd_medico
        INTO CD_PESSOA_FISICA_W, CD_MEDICO_W
      FROM cpoe_procedimento
         WHERE 1=1 
         AND nr_atendimento =  OBTER_DADOS_PRESCRICAO(NR_PRESCRICAO_W,'A')
         AND dt_suspensao IS NULL
         AND trunc(dt_liberacao) = trunc(sysdate);
         
    -- Retorna a MAX da Assinatura Digital, para ser passado para solicitação de exames
          SELECT 
               MAX(CP.NR_SEQ_ASSINATURA)
               INTO NR_SEQ_ASSINATURA_W
         FROM TASY.CPOE_PROCEDIMENTO CP, 
              TASY.ATENDIMENTO_PACIENTE AP ,
              PROC_INTERNO PCI
        WHERE CP.NR_SEQ_PROC_INTERNO = PCI.NR_SEQUENCIA
          AND PCI.IE_SITUACAO = 'A'
          AND CP.NR_ATENDIMENTO = AP.NR_ATENDIMENTO
          AND AP.NR_ATENDIMENTO = OBTER_DADOS_PRESCRICAO(NR_PRESCRICAO_W,'A')
         AND CP.DT_LIB_SUSPENSAO IS NULL
          AND TRUNC(CP.DT_LIBERACAO) = TRUNC(SYSDATE);
          
  -- retorna os procedimentos prescritos
        SELECT AT.CD_ESTABELECIMENTO,
               PR.CD_PROCEDIMENTO,
               PR.IE_ORIGEM_PROCED,
               PI.QT_PROCEDIMENTO,
               PR.NR_SEQUENCIA
        BULK COLLECT INTO
               CD_ESTABELECIMENTO_W,
               CD_PROCEDIMENTO_W,
               IE_ORIGEM_PROCED_W,
               QT_EXAME_W,
               NR_SEQ_PROC_INT_W    
         FROM TASY.CPOE_PROCEDIMENTO PI, 
              TASY.ATENDIMENTO_PACIENTE AT ,
              PROC_INTERNO PR
        WHERE PI.NR_SEQ_PROC_INTERNO = PR.NR_SEQUENCIA
          AND PR.IE_SITUACAO = 'A'
          AND PI.NR_ATENDIMENTO = AT.NR_ATENDIMENTO
          AND AT.NR_ATENDIMENTO = OBTER_DADOS_PRESCRICAO(NR_PRESCRICAO_W,'A')
         AND PI.DT_LIB_SUSPENSAO IS NULL
          AND TRUNC(PI.DT_LIBERACAO) = TRUNC(SYSDATE);

       -- verifica se existe solicitação do medico em até 10 segundos antes
     SELECT 
        NVL(MAX(nr_sequencia), 0)
        INTO VAR_PEDIDO_EXAM_PROC
    FROM PEDIDO_EXAME_EXTERNO 
    WHERE NR_ATENDIMENTO = OBTER_DADOS_PRESCRICAO(NR_PRESCRICAO_W,'A')
    AND TRUNC(DT_SOLICITACAO) = TRUNC(SYSDATE)
   -- AND DT_LIBERACAO IS NULL;
    AND DT_SOLICITACAO >= (SYSDATE - INTERVAL '10' SECOND);
    
     -- Verifica se o medico tem assinatura digital ativa -- Douglas 31/03/22
     SELECT COUNT(*) 
       INTO var_TOTAL 
       FROM tasy.USUARIO u 
      WHERE U.cd_certificado is not null
       AND u.dt_validade_certificado IS NOT NULL
       AND u.dt_emissao_certificado IS NOT NULL
      -- AND TRUNC(u.dt_validade_certificado) >= TRUNC(SYSDATE) *Jessé 26/08/21 retirado devido a medicos com certificado nao atualizado no tasy (duplicava orcamento)
       AND u.CD_PESSOA_FISICA = OBTER_DADOS_PRESCRICAO(NR_PRESCRICAO_W, 'CP');
  
    --QUANDO O MEDICO TEM ASSINATURA DIGITAL NO USUARIO obrigatoriamente verifica se a assinatura nao vai estar nula para liberar prescricao -- Douglas 31/03/22
    --  inseri no orcamento se o medico com a assinatura digital ativa assinar a prescricao ao liberar -- caso nao assine, nao inseri


    IF (DT_LIBERACAO_W >= 1 and VAR_PEDIDO_EXAM_PROC = 0) THEN 
        IF (var_TOTAL > 0 and NR_SEQ_ASSINATURA_W is not null) THEN 
            SELECT PEDIDO_EXAME_EXTERNO_SEQ.nextval INTO VAR_PEDIDO_EXAM_PROC FROM DUAL;
                                INSERT INTO TASY.PEDIDO_EXAME_EXTERNO ( NR_SEQUENCIA,
                                            DT_ATUALIZACAO,
                                            NM_USUARIO,
                                            CD_PESSOA_FISICA,
                                            NR_ATENDIMENTO,
                                            CD_PROFISSIONAL,
                                            DT_SOLICITACAO,
                                            NM_USUARIO_NREC,
                                            DT_ATUALIZACAO_NREC,
                                            IE_FICHA_UNIMED,
                                            NR_SEQ_ASSINATURA
                                        )VALUES
                                        (   VAR_PEDIDO_EXAM_PROC,
                                            SYSDATE,
                                            TASY.OBTER_NOME_USUARIO_COD(CD_MEDICO_W),
                                            CD_PESSOA_FISICA_W,
                                            OBTER_DADOS_PRESCRICAO(NR_PRESCRICAO_W,'A'),
                                            CD_MEDICO_W,
                                            SYSDATE,
                                            TASY.OBTER_NOME_USUARIO_COD(CD_MEDICO_W),
                                            SYSDATE,
                                            'S',
                                            NR_SEQ_ASSINATURA_W
                                            );


            FOR indice IN 1..CD_ESTABELECIMENTO_W.COUNT LOOP

            INSERT INTO PEDIDO_EXAME_EXTERNO_ITEM ( NR_SEQUENCIA,
                                        DT_ATUALIZACAO,
                                        NM_USUARIO,
                                        NR_SEQ_PEDIDO,
                                        QT_EXAME,
                                        NR_SEQ_APRESENT,
                                        DT_ATUALIZACAO_NREC,
                                        NM_USUARIO_NREC,
                                        CD_PROCEDIMENTO,
                                        IE_ORIGEM_PROCED,
                                        NR_PROC_INTERNO
                                        )
                                    VALUES ( PEDIDO_EXAME_EXTERNO_ITEM_SEQ.NEXTVAL,
                                    SYSDATE,
                                    TASY.OBTER_NOME_USUARIO_COD(CD_MEDICO_W),
                                    VAR_PEDIDO_EXAM_PROC,
                                    QT_EXAME_W(indice),
                                    indice,
                                    SYSDATE,
                                    TASY.OBTER_NOME_USUARIO_COD(CD_MEDICO_W),
                                    CD_PROCEDIMENTO_W(indice),
                                    IE_ORIGEM_PROCED_W(indice),
                                    NR_SEQ_PROC_INT_W(indice)
                                    );
                END LOOP;
                
                -- realiza a liberação da solicitação de exames
            UPDATE PEDIDO_EXAME_EXTERNO SET DT_LIBERACAO = SYSDATE WHERE NR_SEQUENCIA = VAR_PEDIDO_EXAM_PROC;
        END IF;
        
          -- entra nesse if quando o medico nao tem assinatura digital ativa -- novo Jessé 24/06/20
            IF (var_TOTAL = 0) THEN 
                SELECT PEDIDO_EXAME_EXTERNO_SEQ.nextval INTO VAR_PEDIDO_EXAM_PROC FROM DUAL;
                                INSERT INTO TASY.PEDIDO_EXAME_EXTERNO ( NR_SEQUENCIA,
                                            DT_ATUALIZACAO,
                                            NM_USUARIO,
                                            CD_PESSOA_FISICA,
                                            NR_ATENDIMENTO,
                                            CD_PROFISSIONAL,
                                            DT_SOLICITACAO,
                                            NM_USUARIO_NREC,
                                            DT_ATUALIZACAO_NREC,
                                            IE_FICHA_UNIMED
                                        )VALUES
                                        (   VAR_PEDIDO_EXAM_PROC,
                                            SYSDATE,
                                            TASY.OBTER_NOME_USUARIO_COD(CD_MEDICO_W),
                                            CD_PESSOA_FISICA_W,
                                            OBTER_DADOS_PRESCRICAO(NR_PRESCRICAO_W,'A'),
                                            CD_MEDICO_W,
                                            SYSDATE,
                                            TASY.OBTER_NOME_USUARIO_COD(CD_MEDICO_W),
                                            SYSDATE,
                                            'S');


            FOR indice IN 1..CD_ESTABELECIMENTO_W.COUNT LOOP

            INSERT INTO PEDIDO_EXAME_EXTERNO_ITEM ( NR_SEQUENCIA,
                                        DT_ATUALIZACAO,
                                        NM_USUARIO,
                                        NR_SEQ_PEDIDO,
                                        QT_EXAME,
                                        NR_SEQ_APRESENT,
                                        DT_ATUALIZACAO_NREC,
                                        NM_USUARIO_NREC,
                                        CD_PROCEDIMENTO,
                                        IE_ORIGEM_PROCED,
                                        NR_PROC_INTERNO
                                        )
                                    VALUES ( PEDIDO_EXAME_EXTERNO_ITEM_SEQ.NEXTVAL,
                                    SYSDATE,
                                    TASY.OBTER_NOME_USUARIO_COD(CD_MEDICO_W),
                                    VAR_PEDIDO_EXAM_PROC,
                                    QT_EXAME_W(indice),
                                    indice,
                                    SYSDATE,
                                    TASY.OBTER_NOME_USUARIO_COD(CD_MEDICO_W),
                                    CD_PROCEDIMENTO_W(indice),
                                    IE_ORIGEM_PROCED_W(indice),
                                    NR_SEQ_PROC_INT_W(indice)
                                    );
                END LOOP;
                -- realiza a liberação da solicitação de exames
            UPDATE PEDIDO_EXAME_EXTERNO SET DT_LIBERACAO = SYSDATE WHERE NR_SEQUENCIA = VAR_PEDIDO_EXAM_PROC;
        END IF;
        
    END IF;

 END IF;
 
            
END SIM_CRIAR_SOLIC_EXAM_CPOE_TRG;