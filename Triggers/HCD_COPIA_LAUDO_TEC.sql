CREATE OR REPLACE TRIGGER HCD_COPIA_LAUDO_TEC 
BEFORE UPDATE ON SOLIC_COMPRA
FOR EACH ROW
WHEN (NEW.NR_SEQ_ORDEM_SERV IS NOT NULL AND NEW.DT_LIBERACAO IS NULL)

/*<DS_SCRIPT>
 DESCRIÇÃO...: Realiza a cópia das informações registradas na Ordem de Serviço(Nova) --> Avaliação para Solicitação de Compra --> Parecer
 RESPONSAVEL.: DOUGLAS FELIPE (douglas.felipe)
 DATA........: 09/11/2022
 APLICAÇÃO...: TASY
 ATUALIZAÇÃO...:
    -- EXEMPLO:Atualizado em 07/01/22 por Douglas F: Adicionado filtro para buscar o bloqueio também pelo horário caso informado
 OBSERVAÇÕES...:  
    
</DS_SCRIPT>*/



DECLARE

NR_SEQ_ORDEM_SERV_P NUMBER := :NEW.NR_SEQ_ORDEM_SERV;
NR_SOLIC_COMPRA_W NUMBER := :NEW.NR_SOLIC_COMPRA;

IE_VERIFICA_LAUDO_W NUMBER;
DS_TEXTO_PARECER_W VARCHAR2(4000);

BEGIN

-- VERIFICA SE ORDEM POSSUI LAUDO -- 
SELECT
    COUNT((select b.NR_SEQUENCIA FROM MAN_ORDEM_SERVICO a INNER JOIN MAN_ORDEM_SERV_AVALIACAO b ON (a.nr_sequencia = b.nr_seq_ordem_servico)
            WHERE a.nr_sequencia = NR_SEQ_ORDEM_SERV_P
            and b.dt_liberacao is not null
            and b.nr_seq_tipo_avaliacao not in (60,62)))
        INTO IE_VERIFICA_LAUDO_W
FROM DUAL;

IF ( IE_VERIFICA_LAUDO_W > 0 ) THEN
    
    SELECT 
        '**********Laudo Técnico**********' || CHR(10) || CHR(10) ||
        'Patrimônio: ' || HCD_OBTER_MAN_RESULT_AVAL(b.nr_sequencia,1536) || CHR(10) ||
        'Nº Serie ' || HCD_OBTER_MAN_RESULT_AVAL(b.nr_sequencia,1543) || CHR(10) ||
        'Marca: ' || HCD_OBTER_MAN_RESULT_AVAL(b.nr_sequencia,1541) || CHR(10) ||
        'Modelo: ' || HCD_OBTER_MAN_RESULT_AVAL(b.nr_sequencia,1542) || CHR(10) ||
        'Armazenamento: ' || HCD_OBTER_MAN_RESULT_AVAL(b.nr_sequencia,1544) || CHR(10) ||
        'Acessórios: ' || HCD_OBTER_MAN_RESULT_AVAL(b.nr_sequencia,1545) || CHR(10) ||
        'Apresentando o seguinte problema: ' || HCD_OBTER_MAN_RESULT_AVAL(b.nr_sequencia,1548) || CHR(10) ||
        'Laudo técnico: ' || HCD_OBTER_MAN_RESULT_AVAL(b.nr_sequencia,1549) || CHR(10) ||
        'Laudado por: ' || HCD_OBTER_MAN_RESULT_AVAL(b.nr_sequencia,1550) || CHR(10)
        
        INTO DS_TEXTO_PARECER_W
        
    FROM MAN_ORDEM_SERVICO a INNER JOIN MAN_ORDEM_SERV_AVALIACAO b ON (a.nr_sequencia = b.nr_seq_ordem_servico)
    WHERE a.nr_sequencia = NR_SEQ_ORDEM_SERV_P
    AND b.dt_liberacao is not null
    AND b.nr_seq_tipo_avaliacao not in (60,62)
    AND ROWNUM = 1;
    
    
    INSERT INTO SOLIC_COMPRA_PARECER (
                                    NR_SEQUENCIA,
                                    NR_SOLIC_COMPRA,
                                    DT_ATUALIZACAO,
                                    NM_USUARIO,
                                    DT_ATUALIZACAO_NREC,
                                    NM_USUARIO_NREC,
                                    DS_PARECER,
                                    IE_APROVADO
                                    )
                            VALUES(SOLIC_COMPRA_PARECER_SEQ.NEXTVAL,
                                   NR_SOLIC_COMPRA_W,
                                   SYSDATE,
                                   OBTER_USUARIO_ATIVO(),
                                   SYSDATE,
                                   OBTER_USUARIO_ATIVO(),
                                   DS_TEXTO_PARECER_W,
                                   'S'
                                   );
                                   
END IF;

END HCD_COPIA_LAUDO_TEC;