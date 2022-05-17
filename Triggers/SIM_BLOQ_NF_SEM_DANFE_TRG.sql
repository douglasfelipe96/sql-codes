create or replace TRIGGER SIM_BLOQ_NF_SEM_DANFE_TRG
BEFORE UPDATE ON NOTA_FISCAL
FOR EACH ROW

/*
<DS_SCRIPT>
DESCRICAO....: Trigger responsável por barrar o cálculo de notas fiscais de entrada cuja a operação seja NOTA FISCAL DE COMPRA, cujo o DANFE não esteja preenchido
RESPONSAVEL..: DOUGLAS FELIPE 
DATA.........: 01/03/2022
APLICACAO....: TASY
ALTERACOES...:
08/03/22 - Douglas Felipe - Acrescentado para não buscar as que estão em lote contabil
18/03/22 - Douglas Felipe - Acrescentado condição para não consistir no estorno das notas campo IE_SITUACAO_W = 1 - Notas Ativas
</DS_SCRIPT>
*/


DECLARE

NM_USUARIO_CALC_W VARCHAR2(15) := :NEW.NM_USUARIO_CALC;
NR_DANFE_W VARCHAR2(60) := :NEW.NR_DANFE;
CD_OPERACAO_NF_W NUMBER(4,0) := :NEW.CD_OPERACAO_NF;
IE_TIPO_NOTA_W VARCHAR2(3) := :NEW.IE_TIPO_NOTA;
NR_LOTE_CONTABIL_W NUMBER(10,0) := :NEW.NR_LOTE_CONTABIL;
IE_SITUACAO_W VARCHAR2(1) := :NEW.IE_SITUACAO;

BEGIN

    IF(NM_USUARIO_CALC_W IS NOT NULL  AND IE_TIPO_NOTA_W IN ('EN','EF') AND CD_OPERACAO_NF_W = 1 AND NR_LOTE_CONTABIL_W = 0 AND IE_SITUACAO_W = '1') THEN
        IF(NR_DANFE_W IS NULL)
        THEN  raise_application_error(-20011, 'SIM_BLOQ_NF_SEM_DANFE_TRG: DANFE não preenchido');
        END IF;
    END IF;

END SIM_BLOQ_NF_SEM_DANFE_TRG;