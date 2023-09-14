CREATE OR REPLACE FUNCTION HCD_OBTER_QTD_PRESCR_MED_ALTA (CD_MEDICO_P NUMBER, DT_INICIO_P DATE, DT_FIM_P DATE)
RETURN NUMBER IS

/*<DS_SCRIPT>
 DESCRIÇÃO...: Function que retorna a quantidade de atendimentos em que um médico prescreveu alta para o paciente em um determinado espaço de tempo
 RESPONSAVEL.: DOUGLAS FELIPE (douglas.felipe)
 DATA........: 14/11/2022
 APLICAÇÃO...: TASY
 ATUALIZAÇÃO...:
   
 OBSERVAÇÕES...:  
   
</DS_SCRIPT>*/

DS_RETORNO_W NUMBER;

BEGIN

    select distinct  count(*)
        INTO DS_RETORNO_W
    from atendimento_paciente a 
    LEFT JOIN cpoe_recomendacao b ON (a.nr_atendimento = b.nr_atendimento and b.cd_recomendacao = 901 and b.dt_suspensao is null)
    where 1=1
        AND TRUNC(a.dt_entrada) between DT_INICIO_P and DT_FIM_P
        AND a.ie_tipo_atendimento = 3
        AND a.dt_cancelamento is null
        AND b.cd_medico = CD_MEDICO_P;
        --@SQL_WHERE


RETURN DS_RETORNO_W;

END HCD_OBTER_QTD_PRESCR_MED_ALTA;