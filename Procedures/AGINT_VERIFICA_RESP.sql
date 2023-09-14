create or replace PROCEDURE AGINT_VERIFICA_RESP (IN_CD_PESSOA_FISICA IN NUMBER,
                                                        IN_NM_USUARIO IN VARCHAR2,
                                                        RESPONSIBLE_NAME IN VARCHAR2,
                                                        RESPONSIBLE_DOCUMENTO IN VARCHAR2)
IS

/*<DS_SCRIPT>
 DESCRIÃ¿Ã¿O...: PROCEDURE QUE VERIFICA SE POSSUI RESPONSÁVEL CADASTRADO
 RESPONSAVEL.: Douglas Felipe, Viviane Viana e Gabriel Facundo
 DATA........: 19/01/2022
 APLICAÃ¿Ã¿O...: Agenda Integrada
</DS_SCRIPT>
<USUARIO=TASY>*/

    V_PESSOA_FISICA NUMBER;
    V_PESSOA_FISICA_RESP NUMBER;
BEGIN

    SELECT
    (SELECT CD_PESSOA_FISICA 
    FROM COMPL_PESSOA_FISICA
    WHERE CD_PESSOA_FISICA = IN_CD_PESSOA_FISICA AND IE_TIPO_COMPLEMENTO = 3) INTO V_PESSOA_FISICA 
    FROM DUAL;

    SELECT
    (SELECT CD_PESSOA_FISICA 
    FROM PESSOA_FISICA 
    WHERE NR_CPF = RESPONSIBLE_DOCUMENTO) INTO V_PESSOA_FISICA_RESP
    FROM DUAL;

        IF V_PESSOA_FISICA_RESP IS NULL
            THEN RAISE_APPLICATION_ERROR(-20001, 'ResponsÃ¡vel nÃ£o cadastrado no banco de dados. | ' || SQLERRM);
        END IF;

        IF V_PESSOA_FISICA IS NULL
            THEN INSERT INTO TASY.COMPL_PESSOA_FISICA (
                                        CD_PESSOA_FISICA,
                                        NR_SEQUENCIA,
                                        IE_TIPO_COMPLEMENTO,
                                        DT_ATUALIZACAO,
                                        NM_USUARIO,
                                        DT_ATUALIZACAO_NREC,
                                        NM_USUARIO_NREC,
                                        NM_CONTATO, 
                                        NR_CPF,
                                        CD_PESSOA_FISICA_REF
                                    ) VALUES (
                                        IN_CD_PESSOA_FISICA, 
                                        TASY.AGINT_OBTER_PROX_SEQ_COMP_PF(IN_CD_PESSOA_FISICA), 
                                        3, 
                                        SYSDATE,
                                        IN_NM_USUARIO,
                                        SYSDATE,
                                        IN_NM_USUARIO, 
                                        RESPONSIBLE_NAME, 
                                        RESPONSIBLE_DOCUMENTO,
                                        V_PESSOA_FISICA_RESP
                                    );
        ELSE 
            UPDATE TASY.COMPL_PESSOA_FISICA 
                SET 
                   NR_CPF = RESPONSIBLE_DOCUMENTO,
                   NM_CONTATO = RESPONSIBLE_NAME,
                   DT_ATUALIZACAO = SYSDATE,
                   NM_USUARIO = IN_NM_USUARIO,
                   CD_PESSOA_FISICA_REF = V_PESSOA_FISICA_RESP
                WHERE
                   CD_PESSOA_FISICA = IN_CD_PESSOA_FISICA
                   AND IE_TIPO_COMPLEMENTO = 3;
        END IF;
END AGINT_VERIFICA_RESP;