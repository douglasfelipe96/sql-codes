CREATE OR REPLACE FUNCTION HCD_OBTER_SE_SAE_DIARIA (NR_ATENDIMENTO_p NUMBER, DT_ENTRADA_P DATE, DT_ALTA_P DATE)
RETURN VARCHAR2 IS

/*<DS_SCRIPT>
 DESCRIÇÃO...: Function que retorna se o atendimento possui SAE diária com base na data de entrada e saida do mesmo.
 RESPONSAVEL.: DOUGLAS FELIPE (douglas.felipe)
 DATA........: 16/11/2022
 APLICAÇÃO...: TASY
 ATUALIZAÇÃO...:
    -- EXEMPLO:Atualizado em 07/01/22 por Douglas F: Adicionado filtro para buscar o bloqueio também pelo horário caso informado
 OBSERVAÇÕES...:  
    -- EXEMPLO: Douglas F: Parâmetro NR_SEQ_SUPERIOR_P utilizado apenas para os componentes dos médicamentos, sendo assim para o medicamento principal não necessita a passagem do mesmo.
</DS_SCRIPT>*/

DS_RETORNO_W VARCHAR2(50);
IE_RETORNA_VALOR NUMBER;

BEGIN
        SELECT Count(DISTINCT Trunc(Z.dt_prescricao))
                INTO IE_RETORNA_VALOR
        FROM   pe_prescricao Z
        WHERE  Z.nr_atendimento = nr_atendimento_P
        and    trunc(z.dt_prescricao) between trunc(dt_entrada_p) and trunc(dt_alta_p-1);
        
        IF(IE_RETORNA_VALOR > 0 AND IE_RETORNA_VALOR >= (OBTER_DIAS_INTERNACAO(nr_atendimento_p) - 1)) 
            THEN DS_RETORNO_W := 'SIM';
        ELSE DS_RETORNO_W := 'NAO';
        END IF;


RETURN DS_RETORNO_W;

END HCD_OBTER_SE_SAE_DIARIA;