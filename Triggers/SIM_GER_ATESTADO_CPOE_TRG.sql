create or replace TRIGGER TASY.SIM_GER_ATESTADO_CPOE_TRG
  BEFORE INSERT ON PRESCR_RECOMENDACAO
  FOR EACH ROW
  
  --<DS_SCRIPT>
-- DESCRIÇÃO..............: Gerar atestado com base na prescrição da CPOE
-- RESPONSAVEL............: DOUGLAS FELIPE / ANDERSON FARIAS
-- DATA...................: 30/05/2022
-- APLICAÇÃO..............: TASY <CPOE>
--</DS_SCRIPT>

DECLARE
VAR_TOTAL number;
VAR_ATESTADO number;
NR_SEQ_ATEST_PAC_W NUMBER;
NR_PRESCRICAO_W NUMBER := :NEW.NR_PRESCRICAO;
NR_SEQ_CLASSIF_W NUMBER := :NEW.NR_SEQ_CLASSIF;

TYPE T_NUM IS TABLE OF NUMBER;
NR_ATENDIMENTO_W T_NUM;
QT_DIAS_W T_NUM;

TYPE T_LONG IS TABLE OF LONG;
DS_TEXTO_w T_LONG;

TYPE T_CHAR IS TABLE OF VARCHAR2(255);
NM_USUARIO_W T_CHAR;
CD_MEDICO_w T_CHAR;
CD_PESSOA_FISICA_W T_CHAR;

TYPE T_DATE IS TABLE OF DATE;
DT_ATENDIMENTO_W T_DATE;
DT_FIM_ATEST_W T_DATE;

BEGIN
--VALIDA SE TEM DA CPOE
 IF(OBTER_DADOS_PRESCRICAO(NR_PRESCRICAO_W,'CFO') = 2314 AND NR_SEQ_CLASSIF_W = 23) THEN

    -- Verifica se o medico tem assinatura digital ativa -- Douglas 31/03/22
     SELECT COUNT(*) 
       INTO VAR_TOTAL 
       FROM tasy.USUARIO u 
      WHERE U.cd_certificado is not null
       AND u.dt_validade_certificado IS NOT NULL
       AND u.dt_emissao_certificado IS NOT NULL
       AND u.CD_PESSOA_FISICA = OBTER_DADOS_PRESCRICAO(NR_PRESCRICAO_W, 'CP');

    -- verifica se existe solicitação do medico em até 10 segundos antes
     SELECT 
        NVL(MAX(nr_sequencia), 0)
        INTO VAR_ATESTADO
    FROM ATESTADO_PACIENTE
    WHERE NR_ATENDIMENTO = OBTER_DADOS_PRESCRICAO(NR_PRESCRICAO_W,'A')
    AND TRUNC(DT_ATESTADO) = TRUNC(SYSDATE)
    AND DT_ATESTADO BETWEEN (SYSDATE - INTERVAL '10' SECOND) AND SYSDATE;


    -- LISTA OS ATESTADOS 
     SELECT DISTINCT
        a.NR_ATENDIMENTO,
        a.dt_atualizacao_nrec dt_atendimento,
        NVL(a.DS_RECOMENDACAO,b.DS_DIAS_APLICACAO) qt_dias,
        a.DT_ATUALIZACAO_NREC + NVL(a.DS_RECOMENDACAO,b.DS_DIAS_APLICACAO) dt_fim_atest,
        a.nm_usuario_nrec,
        a.cd_medico,
        a.cd_pessoa_fisica,

       (SELECT 'Atesto para os devidos fins, a pedido, que o(a) Sr(a). '
                || tasy.Obter_Dados_Atendimento (a.NR_ATENDIMENTO,'NP')
                || ' inscrito(a) no CPF sob o nº '
                || tasy.obter_dados_pf (tasy.Obter_Dados_Atendimento (NR_ATENDIMENTO,'CP'),'CPF')
                || ', paciente sob meus cuidados, foi atendido(a) no dia '
                || a.DT_ATUALIZACAO
                || ' às '
                || TO_CHAR (a.DT_ATUALIZACAO, 'HH:MM')
                || ', apresentando quadro de ' 
                || a.DS_JUSTIFICATIVA
                ||'. '
                ||' e necessitando de '
                ||NVL(DS_RECOMENDACAO,DS_DIAS_APLICACAO)
                ||' dia(s) de repouso.'
        FROM DUAL) ds_texto

  BULK COLLECT INTO

     NR_ATENDIMENTO_W,
     DT_ATENDIMENTO_W,
     QT_DIAS_W,
     DT_FIM_ATEST_W,
     NM_USUARIO_W,
     CD_MEDICO_W,
     CD_PESSOA_FISICA_W,
     DS_TEXTO_W


    FROM CPOE_RECOMENDACAO a INNER JOIN TIPO_RECOMENDACAO b ON (a.cd_recomendacao = b.cd_tipo_recomendacao)
    WHERE 1=1
    AND a.NR_ATENDIMENTO = OBTER_DADOS_PRESCRICAO(NR_PRESCRICAO_W,'A')
    AND b.nr_seq_classif = 23
    AND a.DT_LIB_SUSPENSAO is null
    AND a.dt_liberacao is not null
    AND TRUNC(a.dt_atualizacao_nrec) = trunc(SYSDATE);

        -- CASO TENHA ASSINATURA DIGITAL --
            IF( VAR_TOTAL <> 0 AND VAR_ATESTADO = 0 ) THEN

            FOR indice IN 1..NR_ATENDIMENTO_W.COUNT  LOOP

                SELECT ATESTADO_PACIENTE_SEQ.nextval INTO NR_SEQ_ATEST_PAC_W FROM DUAL;

                INSERT INTO ATESTADO_PACIENTE (NR_SEQUENCIA,
                                               DT_ATESTADO,
                                               DT_FIM,
                                               NR_ATENDIMENTO,
                                               DT_ATUALIZACAO,
                                               NM_USUARIO,
                                               CD_MEDICO,
                                               CD_PESSOA_FISICA,
                                               DT_ATUALIZACAO_NREC,
                                               NM_USUARIO_NREC,
                                               DT_LIBERACAO,
                                               DS_ATESTADO,
                                               NR_SEQ_TIPO_ATESTADO,
                                               IE_SITUACAO,
                                               QT_DIAS_ATESTADO) 
                                               VALUES
                                               ( NR_SEQ_ATEST_PAC_W,
                                                 SYSDATE,
                                                 DT_FIM_ATEST_W(indice),
                                                 NR_ATENDIMENTO_W(indice),
                                                 SYSDATE,
                                                 NM_USUARIO_W(indice),
                                                 CD_MEDICO_W(indice),
                                                 CD_PESSOA_FISICA_W(indice),
                                                 sysdate,
                                                 NM_USUARIO_W(indice),
                                                 SYSDATE,
                                                 DS_TEXTO_W(indice),
                                                 2,
                                                 'A',
                                                 QT_DIAS_W(indice));

                 END LOOP;

                END IF;

              -- CASO NÃO TENHA ASSINATURA DIGITAL --  
                IF( VAR_TOTAL = 0 AND VAR_ATESTADO = 0 ) THEN

                FOR indice IN 1..NR_ATENDIMENTO_W.COUNT  LOOP

                SELECT ATESTADO_PACIENTE_SEQ.nextval INTO NR_SEQ_ATEST_PAC_W FROM DUAL;

                INSERT INTO ATESTADO_PACIENTE (NR_SEQUENCIA,
                                               DT_ATESTADO,
                                               DT_FIM,
                                               NR_ATENDIMENTO,
                                               DT_ATUALIZACAO,
                                               NM_USUARIO,
                                               CD_MEDICO,
                                               CD_PESSOA_FISICA,
                                               DT_ATUALIZACAO_NREC,
                                               NM_USUARIO_NREC,
                                               DT_LIBERACAO,
                                               DS_ATESTADO,
                                               NR_SEQ_TIPO_ATESTADO,
                                               IE_SITUACAO,
                                               QT_DIAS_ATESTADO) 
                                               VALUES
                                               ( NR_SEQ_ATEST_PAC_W,
                                                 SYSDATE,
                                                 DT_FIM_ATEST_W(indice),
                                                 NR_ATENDIMENTO_W(indice),
                                                 SYSDATE,
                                                 NM_USUARIO_W(indice),
                                                 CD_MEDICO_W(indice),
                                                 CD_PESSOA_FISICA_W(indice),
                                                 sysdate,
                                                 NM_USUARIO_W(indice),
                                                 SYSDATE,
                                                 DS_TEXTO_W(indice),
                                                 2,
                                                 'A',
                                                 QT_DIAS_W(indice));
                END LOOP;
                END IF;

 END IF;
    -- INSERE ATESTADOS NA TABELA DE LOG DE ATESTADOS --
    INSERT INTO SIM_LOG_CPOE_ATESTADO VALUES (SIM_LOG_CPOE_ATESTADO_SEQ.NEXTVAL, SYSDATE, OBTER_USUARIO_ATIVO, CD_MEDICO_W(1),NR_PRESCRICAO_W,NR_SEQ_ATEST_PAC_W);
END SIM_GER_ATESTADO_CPOE_TRG;