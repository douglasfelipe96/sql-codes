CREATE OR REPLACE TRIGGER HCD_BQ_OC_SOMENTE_PAGAMENTO 
BEFORE UPDATE ON ORDEM_COMPRA
FOR EACH ROW
WHEN (NEW.DT_LIBERACAO IS NOT NULL AND NEW.IE_SOMENTE_PAGTO <> 'S')

/*<DS_SCRIPT>
 DESCRIÇÃO...: Realiza o bloqueio da liberação de ordem de compra cujo o material inserido seja algum da lista abaixo, mas a ordem de compra não está com a Flag "SOMENTE PARA PAGAMENTO"
 RESPONSAVEL.: DOUGLAS FELIPE (douglas.felipe)
 DATA........: 12/06/2023
 APLICAÇÃO...: TASY
 ATUALIZAÇÃO...:
    -- EXEMPLO:Atualizado em 07/01/22 por Douglas F: Adicionado filtro para buscar o bloqueio também pelo horário caso informado
 OBSERVAÇÕES...:
 
</DS_SCRIPT>*/

DECLARE

    NR_ORDEM_COMPRA_W ORDEM_COMPRA.NR_ORDEM_COMPRA%TYPE := :NEW.NR_ORDEM_COMPRA;

    NR_CONTAGEM NUMBER := 0;

BEGIN

    SELECT COUNT(*)
            INTO NR_CONTAGEM
    FROM ORDEM_COMPRA_ITEM
    WHERE NR_ORDEM_COMPRA = NR_ORDEM_COMPRA_W
    AND CD_MATERIAL IN (59734,60336,59917,60168,60168,70953,59734,60336,63731,59731,65235,59917,63984,69126,69986,63497,69273,59917);
    
    IF(NR_CONTAGEM > 0) THEN
        wheb_mensagem_pck.exibir_mensagem_abort('Existem itens que necessitam da flag "SOMENTE PARA PAGAMENTO" na ordem: Nº ' || NR_ORDEM_COMPRA_W);
    END IF;
    

END HCD_BQ_OC_SOMENTE_PAGAMENTO;