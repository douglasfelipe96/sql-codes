CREATE OR REPLACE TRIGGER HCD_BQ_PRESCR_VEL_INF_SOL 
BEFORE INSERT ON CPOE_MATERIAL
FOR EACH ROW
WHEN (NEW.IE_CONTROLE_TEMPO = 'S')

/*<DS_SCRIPT>
 DESCRIÇÃO...: Realiza o bloqueio da prescrição de soluções como velocidade de infusão caso no cadastro esteja informado como IE_TIPO_SOLUCAO_CPOE = 'C';
 RESPONSAVEL.: DOUGLAS FELIPE (douglas.felipe)
 DATA........: 08/05/2023
 APLICAÇÃO...: TASY
 ATUALIZAÇÃO...:
    -- EXEMPLO:Atualizado em 07/01/22 por Douglas F: Adicionado filtro para buscar o bloqueio também pelo horário caso informado
 OBSERVAÇÕES...:  
    
</DS_SCRIPT>*/


DECLARE

CD_MATERIAL_W NUMBER := :NEW.CD_MATERIAL;
IE_TIPO_SOLUCAO_W CPOE_MATERIAL.IE_TIPO_SOLUCAO%TYPE := :NEW.IE_TIPO_SOLUCAO;

IE_TIPO_SOLUCAO_CAD_W MATERIAL.IE_TIPO_SOLUCAO_CPOE%TYPE;

BEGIN

    IF(IE_TIPO_SOLUCAO_W = 'V') THEN
        
        SELECT IE_TIPO_SOLUCAO_CPOE
        INTO IE_TIPO_SOLUCAO_CAD_W
        FROM MATERIAL
        WHERE CD_MATERIAL = CD_MATERIAL_W;
    
    
        IF(IE_TIPO_SOLUCAO_CAD_W = 'C')
        THEN wheb_mensagem_pck.exibir_mensagem_abort('O item ' || OBTER_DESC_MATERIAL(CD_MATERIAL_W) || ' não permite ser prescrito como velocidade de infusão' || CHR(10) || 'Objeto Error: HCD_BQ_PRESCR_VEL_INF_SOL');
        END IF;
    
    END IF;


END HCD_BQ_PRESCR_VEL_INF_SOL;