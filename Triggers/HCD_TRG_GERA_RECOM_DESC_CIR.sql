create or replace TRIGGER HCD_TRG_GERA_RECOM_DESC_CIR
AFTER UPDATE ON CIRURGIA_DESCRICAO
FOR EACH ROW
WHEN (NEW.DT_LIBERACAO IS NOT NULL)

/*<DS_SCRIPT>
 DESCRIÇÃO...: TRIGGER QUE GERA A PRESCRIÇÃO DE ITENS NA CPOE APARTIR DA LIBERAÇÃO DE UMA DESCRIÇÃO CIRURGICA
 RESPONSAVEL.: DOUGLAS FELIPE 
 DATA........: 16/01/2022
 APLICAÇÃO...: TASY - Prontuário Eletrônico do Paciente - PEP
 ATUALIZAÇÃO...:
				01/08/2023 Douglas F: Alterado a recomendação da sequencia 61 para a 916

</DS_SCRIPT>*/


DECLARE

DT_LIBERACAO_W DATE := :NEW.DT_LIBERACAO;
DT_INATIVACAO_W DATE := :NEW.DT_INATIVACAO;
NR_CIRURGIA_W NUMBER := :NEW.NR_CIRURGIA;
CD_MEDICO_W NUMBER := :NEW.CD_RESPONSAVEL;
NR_ATENDIMENTO_W NUMBER := OBTER_DADOS_CIRURGIA(NR_CIRURGIA_W,'AT');
CD_PESSOA_FISICA_W NUMBER := OBTER_DADOS_ATENDIMENTO(NR_ATENDIMENTO_W, 'CP');


NR_SEQ_W CPOE_RECOMENDACAO.NR_SEQUENCIA%TYPE;

DT_INICIO_W DATE := DT_LIBERACAO_W;
DT_ATT_W DATE := SYSDATE;

IE_VERIFICA_CURATIVO NUMBER;
IE_VERIFICA_PUNCAO NUMBER;


BEGIN
    IF(DT_LIBERACAO_W = SYSDATE AND DT_INATIVACAO_W IS NULL) THEN


    -- VERIFICA SE JÁ LANÇOU A RECOMENDAÇÃO CURATIVO--
    select 
    COUNT(*)
    INTO IE_VERIFICA_CURATIVO
    from cpoe_recomendacao 
    where nr_atendimento = NR_ATENDIMENTO_W 
    and cd_recomendacao = 911 
    and dt_suspensao is null
    and dt_inicio between sysdate and sysdate + interval '5' second;

    IF (IE_VERIFICA_CURATIVO = 0) THEN
    NR_SEQ_W := cpoe_recomendacao_seq.NEXTVAL;


    --- INSERE CURATIVO FERIDA OPERATÓRIA --
        INSERT INTO cpoe_recomendacao (
            cd_funcao_origem,
            ie_oncologia,
            ie_urgencia,
            qt_dias_padrao,
            dt_inicio,
            cd_recomendacao,
            dt_liberacao,
            nr_seq_pepo,
            dt_lib_suspensao,
            ie_nivel_atencao,
            dt_prox_geracao,
            ie_retrogrado,
            dt_liberacao_enf,
            ie_item_valido,
            cd_medico,
            nr_cirurgia,
            ie_administracao,
            dt_atualizacao_nrec,
            nr_seq_transcricao,
            ie_prescritor_aux,
            nr_sequencia,
            dt_liberacao_aux,
            ie_futuro,
            dt_liberacao_farm,
            dt_ciencia_medico,
            ie_acm,
            ie_periodo,
            ie_duracao,
            nr_ocorrencia,
            hr_prim_horario,
            cd_pessoa_fisica,
            nr_cirurgia_patologia,
            cd_perfil_ativo,
            ie_se_necessario,
            ds_recomendacao,
            dt_atualizacao,
            cd_intervalo,
            ie_item_alta,
            nr_seq_topografia,
            ie_evento_unico,
            nr_seq_soap,
            nm_usuario,
            nr_seq_cpoe_anterior,
            dt_fim,
            nr_seq_agenda,
            nr_atendimento,
            ie_tipo_prescr_cirur,
            ds_justificativa,
            nr_seq_conclusao_apae,
            nm_usuario_nrec,
            ds_horarios,
            cd_setor_atendimento
        ) VALUES (
            2314,
            'N',
            NULL,
            NULL,
            DT_INICIO_W,
            394,
            NULL,
            NULL,
            NULL,
            'T',
            NULL,
            'N',
            NULL,
            'S',
            NULL,
            NULL,
            'N',
            DT_ATT_W,
            NULL,
            NULL,
            NR_SEQ_W,
            NULL,
            'N',
            NULL,
            NULL,
            'N',
            NULL,
            'C',
            1.0,
            TO_CHAR(DT_ATT_W,'HH24:MI'),
            CD_PESSOA_FISICA_W,
            NULL,
            NULL,
            'S',
            NULL,
            DT_ATT_W,
            'SN',
            'N',
            NULL,
            'N',
            NULL,
            obter_usuario_ativo(),
            NULL,
            NULL,
            NULL,
            nr_atendimento_w,
            NULL,
            NULL,
            NULL,
            obter_usuario_ativo(),
            NULL,
            NULL
        );

    END IF;




    -- VERIFICA SE JÁ LANÇOU A RECOMENDAÇÃO CURATIVO--
    select 
    COUNT(*)
    INTO IE_VERIFICA_PUNCAO
    from cpoe_recomendacao 
    where nr_atendimento = NR_ATENDIMENTO_W 
    and cd_recomendacao = 916 
    and dt_suspensao is null
    and dt_inicio between sysdate and sysdate + interval '5' SECOND;

    IF (IE_VERIFICA_PUNCAO = 0) THEN
    NR_SEQ_W := cpoe_recomendacao_seq.NEXTVAL;

    --- INSERE CURATIVO SIMPLES --
        INSERT INTO cpoe_recomendacao (
            cd_funcao_origem,
            ie_oncologia,
            ie_urgencia,
            qt_dias_padrao,
            dt_inicio,
            cd_recomendacao,
            dt_liberacao,
            nr_seq_pepo,
            dt_lib_suspensao,
            ie_nivel_atencao,
            dt_prox_geracao,
            ie_retrogrado,
            dt_liberacao_enf,
            ie_item_valido,
            cd_medico,
            nr_cirurgia,
            ie_administracao,
            dt_atualizacao_nrec,
            nr_seq_transcricao,
            ie_prescritor_aux,
            nr_sequencia,
            dt_liberacao_aux,
            ie_futuro,
            dt_liberacao_farm,
            dt_ciencia_medico,
            ie_acm,
            ie_periodo,
            ie_duracao,
            nr_ocorrencia,
            hr_prim_horario,
            cd_pessoa_fisica,
            nr_cirurgia_patologia,
            cd_perfil_ativo,
            ie_se_necessario,
            ds_recomendacao,
            dt_atualizacao,
            cd_intervalo,
            ie_item_alta,
            nr_seq_topografia,
            ie_evento_unico,
            nr_seq_soap,
            nm_usuario,
            nr_seq_cpoe_anterior,
            dt_fim,
            nr_seq_agenda,
            nr_atendimento,
            ie_tipo_prescr_cirur,
            ds_justificativa,
            nr_seq_conclusao_apae,
            nm_usuario_nrec,
            ds_horarios,
            cd_setor_atendimento
        ) VALUES (
            2314,
            'N',
            NULL,
            NULL,
            DT_INICIO_W,
            916,
            NULL,
            NULL,
            NULL,
            'T',
            NULL,
            'N',
            NULL,
            'S',
            NULL,
            NULL,
            'N',
            DT_ATT_W,
            NULL,
            NULL,
            NR_SEQ_W,
            NULL,
            'N',
            NULL,
            NULL,
            'N',
            NULL,
            'C',
            1.0,
            TO_CHAR(DT_ATT_W,'HH24:MI'),
            CD_PESSOA_FISICA_W,
            NULL,
            NULL,
            'S',
            NULL,
            DT_ATT_W,
            'SN',
            'N',
            NULL,
            'N',
            NULL,
            obter_usuario_ativo(),
            NULL,
            NULL,
            NULL,
            nr_atendimento_w,
            NULL,
            NULL,
            NULL,
            obter_usuario_ativo(),
            NULL,
            NULL
        );
    END IF;

    END IF;

END HCD_TRG_GERA_RECOM_DESC_CIR;