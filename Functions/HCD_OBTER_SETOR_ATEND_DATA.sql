create or replace FUNCTION HCD_OBTER_SETOR_ATEND_DATA (NR_ATENDIMENTO_P NUMBER, DT_PARAMETRO_P DATE, IE_OPCAO_P NUMBER)
RETURN VARCHAR2

/*<DS_SCRIPT>
 DESCRIÇÃO...: Function que retorna o setor de internação de um atendimento em uma determinada data
 RESPONSAVEL.: DOUGLAS FELIPE (douglas.fs)
 DATA........: 27/02/2023
 APLICAÇÃO...: TASY
 ATUALIZAÇÃO...:
</DS_SCRIPT>*/

/* IE_OPCAO_P */

-- 1 = Código Setor de Atendimento
-- 2 = Unidade Básica - Unidade Complementar

IS

DS_RETORNO_W VARCHAR2 (255);

BEGIN


IF (IE_OPCAO_P = 1)
THEN

SELECT 
    x.CD_SETOR_ATENDIMENTO
    INTO DS_RETORNO_W
FROM atend_paciente_unidade x 
WHERE NR_SEQ_INTERNO = (select	MAX(nr_seq_interno)
                        from 	atend_paciente_unidade a
                        where	a.nr_atendimento 		= NR_ATENDIMENTO_P
                        and (a.dt_saida_unidade > DT_PARAMETRO_P OR a.dt_saida_unidade is null)
                        and a.ie_passagem_setor = 'N'
                        and a.cd_setor_atendimento not in (250));

ELSIF (IE_OPCAO_P = 2)
    THEN
        SELECT 
        x.CD_UNIDADE_BASICA || ' - ' || x.CD_UNIDADE_COMPL
        INTO DS_RETORNO_W
        FROM atend_paciente_unidade x 
        WHERE NR_SEQ_INTERNO = (select	MAX(nr_seq_interno)
                                from 	atend_paciente_unidade a
                                where	a.nr_atendimento 		= NR_ATENDIMENTO_P
                                and (a.dt_saida_unidade > DT_PARAMETRO_P OR a.dt_saida_unidade is null)
                                and a.ie_passagem_setor = 'N'
                                and a.cd_setor_atendimento not in (250));
END IF;

RETURN DS_RETORNO_W;

END HCD_OBTER_SETOR_ATEND_DATA;