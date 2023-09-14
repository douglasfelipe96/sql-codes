create or replace FUNCTION HCD_OBTER_HIST_RESTRICAO (CD_PESSOA_FISICA_P NUMBER)
RETURN VARCHAR2 IS

/*<DS_SCRIPT>
 DESCRIÇÃO...: Function que retorna o histórico de saúda aba restrições do paciente
 RESPONSAVEL.: DOUGLAS FELIPE (douglas.felipe)
 DATA........: 17/11/2022
 APLICAÇÃO...: TASY
 ATUALIZAÇÃO...:
    -- EXEMPLO:Atualizado em 07/01/22 por Douglas F: Adicionado filtro para buscar o bloqueio também pelo horário caso informado
 OBSERVAÇÕES...:  
    -- EXEMPLO: Douglas F: Parâmetro NR_SEQ_SUPERIOR_P utilizado apenas para os componentes dos médicamentos
</DS_SCRIPT>*/

DS_RETORNO_W VARCHAR2(4000);

CURSOR C01 IS
    SELECT COALESCE(OBTER_DESC_RESTRICAO(nr_seq_restricao), ds_observacao) ds_retricao
    FROM PACIENTE_REP_PRESCRICAO
    WHERE 1=1
    AND DT_FIM IS NULL
    AND IE_NEGA_RESTRICOES  IS NULL
    AND DT_LIBERACAO IS NOT NULL
    AND CD_PESSOA_FISICA = CD_PESSOA_FISICA_P;

VET01 C01%ROWTYPE;
BEGIN
    OPEN C01;
    LOOP
        FETCH C01 INTO VET01;
        EXIT WHEN C01%NOTFOUND;
        BEGIN
            DS_RETORNO_W := DS_RETORNO_W || VET01.ds_retricao || ', ';
        END;
    END LOOP;
    CLOSE C01;

    DS_RETORNO_W := SUBSTR(DS_RETORNO_W,1,LENGTH(DS_RETORNO_W)-2);

RETURN DS_RETORNO_W;

END HCD_OBTER_HIST_RESTRICAO;