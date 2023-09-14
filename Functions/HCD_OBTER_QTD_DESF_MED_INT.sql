CREATE OR REPLACE FUNCTION HCD_OBTER_QTD_DESF_MED_INT (CD_MEDICO_P NUMBER, DT_INICIO_P DATE, DT_FIM_P DATE)
RETURN NUMBER IS

/*<DS_SCRIPT>
 DESCRIÇÃO...: Function que retorna a quantidade de atendimentos em que um médico realizou o desfecho INTERNAÇÃO em um determinado espaço de tempo.
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
LEFT JOIN atendimento_alta d ON (a.nr_atendimento = d.nr_atendimento AND (d.ie_desfecho = 'I' or d.ie_desfecho is null) AND (d.ie_situacao = 'A' or d.ie_situacao is null) AND d.dt_liberacao is not null  AND d.ie_tipo_orientacao = 'P')
where 1=1
    AND TRUNC(a.dt_entrada) between DT_INICIO_P and DT_FIM_P
    AND a.ie_tipo_atendimento = 3
    AND a.dt_cancelamento is null
   -- AND HCD_OBTER_PRIM_MED_RESP_PA(a.nr_atendimento, 'C') = 9602104
   AND d.cd_profissional = CD_MEDICO_P;
    --@SQL_WHERE


RETURN DS_RETORNO_W;

END HCD_OBTER_QTD_DESF_MED_INT;