create or replace TRIGGER HCD_TRG_BQ_PENDENCIA_HIST
BEFORE INSERT ON EVOLUCAO_PACIENTE
FOR EACH ROW
WHEN(NEW.IE_EVOLUCAO_CLINICA IN ('ENF'))


/*<DS_SCRIPT>
 DESCRIÇÃO...: TRIGGER QUER REALIZA O BLOQUEIO CASO EXISTA PENDÊNCIA DE REVISÃO NAS ABAS DO HISTÓRICO DE SAÚDE
 RESPONSAVEL.: DOUGLAS FELIPE 
 DATA........: 20/03/2023
 APLICAÇÃO...: TASY - Prontuário Eletrônico do Paciente - PEP >> NOTA CLINICA
 ATUALIZAÇÃO...: 
 20/04/2023 - Douglas F: Incluido informações para verificar caso o paciente não possua nenhum registro informado.

</DS_SCRIPT>*/


DECLARE

NR_ATENDIMENTO_W EVOLUCAO_PACIENTE.NR_ATENDIMENTO%TYPE := :NEW.nr_atendimento;
CD_PESSOA_FISICA_W EVOLUCAO_PACIENTE.CD_PESSOA_FISICA%TYPE := :NEW.cd_pessoa_fisica;
IE_EVOLUCAO_CLINICA_W EVOLUCAO_PACIENTE.IE_EVOLUCAO_CLINICA%TYPE := :NEW.ie_evolucao_clinica;
DT_LIBERACAO_W EVOLUCAO_PACIENTE.DT_LIBERACAO%TYPE := :NEW.dt_liberacao;


QT_ALERGIAS NUMBER;
QT_MEDICAMENTOS NUMBER;

DS_RETORNO_GERAL VARCHAR2(255);
QT_GERAL NUMBER;
IE_POSSUI_REGISTRO VARCHAR2(2);
IE_POSSUI_REG_ALERGIA VARCHAR2(2);
IE_POSSUI_REG_MEDIC VARCHAR2(2);


BEGIN
    IF(OBTER_DADOS_ATENDIMENTO(NR_ATENDIMENTO_W, 'TA') = 1 AND SYSDATE >= (TO_DATE(OBTER_DADOS_ATENDIMENTO(NR_ATENDIMENTO_W, 'DE'),'DD/MM/YYYY HH24:MI:SS') + INTERVAL '12' HOUR)) THEN

        -- VERIFICA SE EXISTE PENDENCIA NO HISTÓRICO DE SAÚDE --
            SELECT 
                sum(qt)
                INTO QT_GERAL
            FROM (SELECT 
                    COUNT(*) qt
                  FROM paciente_alergia
                  WHERE CD_PESSOA_FISICA = CD_PESSOA_FISICA_W
                  AND NR_ATENDIMENTO <> NR_ATENDIMENTO_W
                  AND dt_inativacao IS NULL
                  AND dt_fim is null
                  AND dt_liberacao is not null
                  AND (dt_revisao IS NULL OR dt_revisao < TO_DATE(OBTER_DADOS_ATENDIMENTO(NR_ATENDIMENTO_W, 'DE'),'DD/MM/YYYY HH24:MI:SS'))
                 -- AND (dt_registro < TO_DATE(OBTER_DADOS_ATENDIMENTO(430723, 'DE'),'DD/MM/YYYY HH24:MI:SS'))
                  UNION ALL
                  SELECT 
                    COUNT(*)
                  FROM PACIENTE_MEDIC_USO
                  WHERE CD_PESSOA_FISICA = CD_PESSOA_FISICA_W
                  AND NR_ATENDIMENTO <> NR_ATENDIMENTO_W
                  AND dt_inativacao IS NULL
                  AND dt_fim IS NULL
                  AND dt_liberacao is not null
                  AND (dt_revisao IS NULL OR dt_revisao < TO_DATE(OBTER_DADOS_ATENDIMENTO(NR_ATENDIMENTO_W, 'DE'),'DD/MM/YYYY HH24:MI:SS'))
                 -- AND (dt_registro < TO_DATE(OBTER_DADOS_ATENDIMENTO(430723, 'DE'),'DD/MM/YYYY HH24:MI:SS'))
                 );




        -- VERIFICA SE PENDENCIA ALERGIAS --
            SELECT COUNT(*)
                INTO QT_ALERGIAS
            FROM paciente_alergia
            WHERE CD_PESSOA_FISICA = CD_PESSOA_FISICA_W
            AND NR_ATENDIMENTO <> NR_ATENDIMENTO_W
            AND dt_inativacao IS NULL
            AND dt_fim IS NULL
            AND dt_liberacao is not null
            AND (dt_revisao IS NULL OR dt_revisao < TO_DATE(OBTER_DADOS_ATENDIMENTO(NR_ATENDIMENTO_W, 'DE'),'DD/MM/YYYY HH24:MI:SS'))
           -- AND (dt_registro < TO_DATE(OBTER_DADOS_ATENDIMENTO(430723, 'DE'),'DD/MM/YYYY HH24:MI:SS'))
           ;

        -- VERIFICA SE PENDENCIA MEDICAMENTOS --
            SELECT COUNT(*)
                INTO QT_MEDICAMENTOS
            FROM PACIENTE_MEDIC_USO
            WHERE CD_PESSOA_FISICA = CD_PESSOA_FISICA_W
            AND NR_ATENDIMENTO <> NR_ATENDIMENTO_W
            AND dt_inativacao IS NULL
            AND dt_fim IS NULL
            AND dt_liberacao is not null
            AND (dt_revisao IS NULL OR dt_revisao < TO_DATE(OBTER_DADOS_ATENDIMENTO(NR_ATENDIMENTO_W, 'DE'),'DD/MM/YYYY HH24:MI:SS'))
          --  AND (dt_registro < TO_DATE(OBTER_DADOS_ATENDIMENTO(430723, 'DE'),'DD/MM/YYYY HH24:MI:SS'))
          ;

            -- VERIFICA SE POSSUI ALGUM REGISTRO NA ABA ALERGIAS --

            SELECT 
                    DECODE(COUNT(*),0,'N','S')
                    INTO IE_POSSUI_REG_ALERGIA
                  FROM paciente_alergia
                  WHERE 1=1
                  AND CD_PESSOA_FISICA = CD_PESSOA_FISICA_W
                  AND DT_INATIVACAO IS NULL;

            -- VERIFICA SE POSSUI ALGUM REGISTRO NA ABA MEDIC EM USO --
            SELECT 
                    DECODE(COUNT(*),0,'N','S')
                    INTO IE_POSSUI_REG_MEDIC
                  FROM PACIENTE_MEDIC_USO
                  WHERE 1=1
                  AND CD_PESSOA_FISICA = CD_PESSOA_FISICA_W
                  AND DT_INATIVACAO IS NULL;

            IF(QT_ALERGIAS <> 0) THEN
                DS_RETORNO_GERAL := DS_RETORNO_GERAL || 'Alergias' || ', ';
            END IF;

            IF(QT_MEDICAMENTOS <> 0) THEN
                DS_RETORNO_GERAL := DS_RETORNO_GERAL || 'Medicamentos em uso' || ', ';
            END IF;

            DS_RETORNO_GERAL := SUBSTR (DS_RETORNO_GERAL, 1, LENGTH(DS_RETORNO_GERAL) - 2);

            IF (QT_GERAL <> 0) THEN
            wheb_mensagem_pck.exibir_mensagem_abort('Existem pendências de reavaliação no histórico de saúde na(s) aba(s): ' || ds_retorno_geral);            
            END IF;


             IF(IE_POSSUI_REG_ALERGIA = 'N' OR IE_POSSUI_REG_MEDIC = 'N') THEN-- CASO NÃO POSSUA REGISTROS --

                    IF (ie_possui_reg_alergia = 'N') THEN
                        DS_RETORNO_GERAL := DS_RETORNO_GERAL || 'Alergias' || ', ';
                    END IF;

                    IF (ie_possui_reg_medic = 'N') THEN
                        DS_RETORNO_GERAL := DS_RETORNO_GERAL || 'Medicamentos em uso' || ', ';
                    END IF;

                    DS_RETORNO_GERAL := SUBSTR (DS_RETORNO_GERAL, 1, LENGTH(DS_RETORNO_GERAL) - 2);   
                    wheb_mensagem_pck.exibir_mensagem_abort('É Necessário preencher o histórico de saúde na(s) aba(s): ' || ds_retorno_geral);
            END IF;


        END IF;
END HCD_TRG_BQ_PENDENCIA_HIST;