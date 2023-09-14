CREATE OR REPLACE FUNCTION HCD_OBTER_HIST_CIRURGIA (CD_PESSOA_FISICA_P NUMBER)
RETURN VARCHAR2 IS

/*<DS_SCRIPT>
 DESCRIÇÃO...: Function que retorna o histórico de cirurgia do paciente
 RESPONSAVEL.: DOUGLAS FELIPE (douglas.felipe)
 DATA........: 16/11/2022
 APLICAÇÃO...: TASY
 ATUALIZAÇÃO...:
    -- EXEMPLO:Atualizado em 07/01/22 por Douglas F: Adicionado filtro para buscar o bloqueio também pelo horário caso informado
 OBSERVAÇÕES...:  
    -- EXEMPLO: Douglas F: Parâmetro NR_SEQ_SUPERIOR_P utilizado apenas para os componentes dos médicamentos, sendo assim para o medicamento principal não necessita a passagem do mesmo.
</DS_SCRIPT>*/


DS_RETORNO_W VARCHAR2(4000);

CURSOR C01 IS
    select distinct dt_cirurgia, COALESCE(DS_PROCEDIMENTO_INF, OBTER_DESC_PROCEDIMENTO(CD_PROCEDIMENTO, IE_ORIGEM_PROCED)) DS_PROCEDIMENTO 
    from HISTORICO_SAUDE_CIRURGIA
    WHERE 1=1
    AND ((DS_PROCEDIMENTO_INF is not null and CD_PROCEDIMENTO is null) 
        OR (DS_PROCEDIMENTO_INF is null and CD_PROCEDIMENTO is not null) 
        OR (DS_PROCEDIMENTO_INF is not null and CD_PROCEDIMENTO is not null)) 
    AND cd_pessoa_fisica = CD_PESSOA_FISICA_P;

VET01 C01%ROWTYPE;

BEGIN
    OPEN C01;
    LOOP
        FETCH C01 INTO VET01;
        EXIT WHEN C01%NOTFOUND;
        BEGIN
            DS_RETORNO_W := DS_RETORNO_W || VET01.DS_PROCEDIMENTO || ', ';
        END;
    END LOOP;
    CLOSE C01;
    
DS_RETORNO_W := SUBSTR(DS_RETORNO_W,1,length(DS_RETORNO_W)-2);
    
RETURN DS_RETORNO_W;

END HCD_OBTER_HIST_CIRURGIA;