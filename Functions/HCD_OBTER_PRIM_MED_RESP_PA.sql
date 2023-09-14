create or replace FUNCTION HCD_OBTER_PRIM_MED_RESP_PA (nr_atendimento_p NUMBER, ie_opcao_p VARCHAR2)
RETURN VARCHAR2

/*<DS_SCRIPT>
 DESCRIÇÃO...: Function que retorna o primeiro médico que assumiu o paciente no pronto atendimento
 RESPONSAVEL.: DOUGLAS FELIPE (douglas.felipe)
 DATA........: 11/11/2022
 APLICAÇÃO...: TASY
 ATUALIZAÇÃO...:
    -- EXEMPLO:Atualizado em 07/01/22 por Douglas F: Adicionado filtro para buscar o bloqueio também pelo horário caso informado
 OBSERVAÇÕES...:  
    -- Douglas F: Parâmetro IE_OPCAO_P  = 'C' - Código 'N' - Nome
</DS_SCRIPT>*/
IS

DS_RETORNO VARCHAR2(255);

BEGIN
    IF (IE_OPCAO_P = 'C')
        THEN
            SELECT CD_MEDICO_ATUAL
                INTO DS_RETORNO
            FROM (select CD_MEDICO_ATUAL
                  from atendimento_troca_medico where nr_atendimento = NR_ATENDIMENTO_P 
                  and (cd_medico_atual not in (667,644)) order by nr_sequencia)
            WHERE ROWNUM = 1;

    ELSIF (IE_OPCAO_P = 'N')
        THEN 
            SELECT NM_MEDICO INTO DS_RETORNO
            FROM (select OBTER_NOME_PF(CD_MEDICO_ATUAL) NM_MEDICO
                 from atendimento_troca_medico where nr_atendimento = NR_ATENDIMENTO_P
                 and (cd_medico_atual not in (667,644)) order by nr_sequencia) 
            WHERE ROWNUM = 1;
    END IF;


    RETURN ds_retorno;

END HCD_OBTER_PRIM_MED_RESP_PA;