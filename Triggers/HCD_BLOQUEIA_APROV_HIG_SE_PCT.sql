CREATE OR REPLACE TRIGGER HCD_BLOQUEIA_APROV_HIG_SE_PCT
BEFORE UPDATE ON SL_UNID_ATEND
FOR EACH ROW

/*<DS_SCRIPT>
 DESCRIÇÃO...: Trigger que realiza o bloqueio ao tentar aprovar um leito na função Gestão de Serviço de leito, caso o mesmo tenha paciente.
 RESPONSAVEL.: DOUGLAS FELIPE (douglas.felipe)
 DATA........: 29/09/2022
 APLICAÇÃO...: TASY (Gestão de Serviço de Leito)
 ATUALIZAÇÃO...:
</DS_SCRIPT>*/


DECLARE

NR_SEQ_UNIDADE_W NUMBER(10,0) := :NEW.NR_SEQ_UNIDADE;
DT_INICIO_W DATE := :NEW.DT_INICIO;
NR_ATENDIMENTO_W NUMBER (10,0);

BEGIN

    IF(DT_INICIO_W IS NOT NULL)
        THEN
            SELECT NR_ATENDIMENTO
                INTO NR_ATENDIMENTO_W
            FROM unidade_atendimento
            where nr_seq_interno = NR_SEQ_UNIDADE_W;
            
                IF(NR_ATENDIMENTO_W IS NOT NULL)
                    THEN
                        raise_application_error(-20012,  'Existe paciente vinculado a unidade!');
                END IF;
    END IF;


END HCD_BLOQUEIA_APROV_HIG_SE_PCT;