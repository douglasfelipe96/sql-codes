CREATE OR REPLACE TRIGGER SIM_RESTRINGE_PROTOCOLO_USER
AFTER INSERT ON PROTOCOLO_MEDICACAO
FOR EACH ROW

DECLARE

NM_USUARIO_W VARCHAR2(255) := OBTER_USUARIO_ATIVO;
CD_PROTOCOLO_W NUMBER := :NEW.CD_PROTOCOLO;
NR_SEQ_INTERNA_W NUMBER := :NEW.NR_SEQ_INTERNA;
NR_SEQ_MEDICACAO_W NUMBER := :NEW.NR_SEQUENCIA;
NR_SEQ_PROT_MEDIC_LIB NUMBER;
CD_PESSOA_FISICA_W NUMBER;

BEGIN
    SELECT OBTER_CODIGO_USUARIO(NM_USUARIO_W) INTO CD_PESSOA_FISICA_W FROM DUAL;
    
        SELECT PROTOCOLO_MEDIC_LIB_SEQ.NEXTVAL INTO NR_SEQ_PROT_MEDIC_LIB FROM DUAL;
    INSERT INTO protocolo_medic_lib (
                                        nr_sequencia,
                                        dt_atualizacao,
                                        nm_usuario,
                                        dt_atualizacao_nrec,
                                        nm_usuario_nrec,
                                        cd_protocolo,
                                        ie_regra,
                                        nr_seq_medicacao,
                                        ie_padrao,
                                        nr_seq_apres,
                                        cd_pessoa_fisica)

                                VALUES( NR_SEQ_PROT_MEDIC_LIB,
                                        SYSDATE,
                                        NM_USUARIO_W,
                                        SYSDATE,
                                        NM_USUARIO_W,
                                        CD_PROTOCOLO_W,
                                        'U',
                                        NR_SEQ_MEDICACAO_W,
                                        'N',
                                        1,
                                        CD_PESSOA_FISICA_W
                                        );
                                        
--    UPDATE PROTOCOLO_MEDIC_LIB set cd_protocolo = :NEW.CD_PROTOCOLO where NR_SEQUENCIA = NR_SEQ_PROT_MEDIC_LIB; 

END SIM_RESTRINGE_PROTOCOLO_USER;
