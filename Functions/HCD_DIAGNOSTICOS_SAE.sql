CREATE OR REPLACE FUNCTION HCD_DIAGNOSTICOS_SAE (NR_SEQ_PRESCR_P NUMBER)
RETURN VARCHAR2 IS

/*<DS_SCRIPT>
 DESCRIÇÃO...: Function que retorna de forma ordenada os diagnosticos informados na SAE
 RESPONSAVEL.: DOUGLAS FELIPE (douglas.felipe)
 DATA........: 22/11/2022
 APLICAÇÃO...: TASY
 ATUALIZAÇÃO...:
    -- EXEMPLO:Atualizado em 07/01/22 por Douglas F: Adicionado filtro para buscar o bloqueio também pelo horário caso informado
 OBSERVAÇÕES...:  
    -- EXEMPLO Douglas F: Parâmetro IE_OPCAO_P pode ser 'A' - Agrupados ou 'N' - Normal.
</DS_SCRIPT>*/


DS_RETORNO_W VARCHAR2(4000);
QUEBRA_W VARCHAR2(10) := CHR(13)||CHR(10);

CURSOR C01 IS
    
    SELECT PE_OBTER_DESC_DIAG(nr_seq_diag,'DI')  ds_diagnostico
    FROM PE_PRESCR_DIAG 
    WHERE NR_SEQ_PRESCR = NR_SEQ_PRESCR_P
    ORDER BY 1;
    
    
VET01 C01%ROWTYPE;    

BEGIN
    OPEN C01;
    LOOP
        FETCH C01 INTO VET01;
    EXIT WHEN C01%NOTFOUND;
        BEGIN
            DS_RETORNO_W := DS_RETORNO_W || QUEBRA_W || VET01.DS_DIAGNOSTICO;
        END;
    END LOOP;
    
RETURN DS_RETORNO_W;

END HCD_DIAGNOSTICOS_SAE;