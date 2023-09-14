CREATE OR REPLACE FUNCTION HCD_OBTER_QTD_DESF_MED_ALTA (CD_MEDICO_P NUMBER, DT_INICIO_P DATE, DT_FIM_P DATE)
RETURN NUMBER IS

/*<DS_SCRIPT>
 DESCRIÇÃO...: Function que retorna a quantidade de atendimentos em que um médico realizou o desfecho em um determinado espaço de tempo.
 RESPONSAVEL.: DOUGLAS FELIPE (douglas.felipe)
 DATA........: 14/11/2022
 APLICAÇÃO...: TASY
 ATUALIZAÇÃO...:
   
 OBSERVAÇÕES...:  
   
</DS_SCRIPT>*/

DS_RETORNO_W NUMBER;

BEGIN

    select distinct count(*)
    INTO DS_RETORNO_W
    from atendimento_paciente a 
    LEFT JOIN atendimento_alta c ON (a.nr_atendimento = c.nr_atendimento AND (c.ie_desfecho = 'A' or c.ie_desfecho is null) AND (c.nr_seq_motivo not in (23) or c.nr_seq_motivo is null) AND (c.ie_situacao = 'A' or c.ie_situacao is null) AND c.dt_liberacao is not null AND c.ie_tipo_orientacao = 'P')
    where 1=1
    AND TRUNC(a.dt_entrada) between DT_INICIO_P and DT_FIM_P
    AND a.ie_tipo_atendimento = 3
    AND a.dt_cancelamento is null
    AND c.cd_profissional = CD_MEDICO_P;
    --@SQL_WHERE


RETURN DS_RETORNO_W;

END HCD_OBTER_QTD_DESF_MED_ALTA;