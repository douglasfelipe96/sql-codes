CREATE OR REPLACE TRIGGER HCD_TRG_CP_CLASSIF_ATEND_DESF
BEFORE UPDATE ON ATENDIMENTO_ALTA
FOR EACH ROW

/*<DS_SCRIPT>
 DESCRIÇÃO...: Trigger que realiza a inserção na classificacao do atendimento ao ser gerado atendimento de internado apartir do desfecho
 RESPONSAVEL.: DOUGLAS FELIPE (douglas.felipe)
 DATA........: 08/12/2022
 APLICAÇÃO...: TASY
 ATUALIZAÇÃO...:
    -- EXEMPLO:Atualizado em 07/01/22 por Douglas F: Adicionado filtro para buscar o bloqueio também pelo horário caso informado
 OBSERVAÇÕES...:  
    -- EXEMPLO: Douglas F: Parâmetro IE_OPCAO_P pode ser 'A' - Agrupados ou 'N' - Normal.
</DS_SCRIPT>*/




DECLARE

NR_ATENDIMENTO_W ATENDIMENTO_ALTA.NR_ATENDIMENTO%TYPE := :NEW.NR_ATENDIMENTO;
IE_DESFECHO_W ATENDIMENTO_ALTA.IE_DESFECHO%TYPE := :NEW.IE_DESFECHO;
DT_LIB_DESFECHO_W ATENDIMENTO_ALTA.DT_LIBERACAO%TYPE := :NEW.DT_LIBERACAO;


NR_SEQ_CLASSIF_ATEND_W ATENDIMENTO_PACIENTE.NR_SEQ_CLASSIFICACAO%TYPE;

BEGIN

    IF(dt_lib_desfecho_w is not null AND ie_desfecho_w = 'I') THEN
        
      -- PEGA A CLASSIFICAÇÃO DO ATENDIMENTO DE PA  --
        SELECT 
            nr_seq_classificacao
                INTO NR_SEQ_CLASSIF_ATEND_W
        FROM atendimento_paciente 
        WHERE 1=1
        AND nr_atendimento = NR_ATENDIMENTO_W;
        
        -- REALIZA A ATUALIZAÇÃO PARA O ATENDIMENTO DE INTERNADO --
        UPDATE atendimento_paciente SET nr_seq_classificacao = NR_SEQ_CLASSIF_ATEND_W, IE_TIPO_ATEND_TISS  = 7 WHERE nr_atend_origem_pa = NR_ATENDIMENTO_W;
    
    END IF;


END HCD_TRG_CP_CLASSIF_ATEND_DESF;