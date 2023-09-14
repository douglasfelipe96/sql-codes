CREATE OR REPLACE TRIGGER HCD_BQ_VINCULO_ATEND_QUIMIO
BEFORE UPDATE ON PACIENTE_ATENDIMENTO
FOR EACH ROW
WHEN (NEW.NR_ATENDIMENTO IS NOT NULL)

/*<DS_SCRIPT>
 DESCRIÇÃO...: Trigger que ao tentar vincular um atendimento que não é de infusão disparará um alerta informando que o atendimento não é elegível de vincular atendimento na Quimioterapia.
 RESPONSAVEL.: DOUGLAS FELIPE (douglas.felipe)
 DATA........: 14/06/2023
 APLICAÇÃO...: TASY
 ATUALIZAÇÃO...:
    -- EXEMPLO:Atualizado em 07/01/22 por Douglas F: Adicionado filtro para buscar o bloqueio também pelo horário caso informado
 OBSERVAÇÕES...:  
    
</DS_SCRIPT>*/

DECLARE

NR_ATENDIMENTO_W PACIENTE_ATENDIMENTO.NR_ATENDIMENTO%TYPE := :NEW.NR_ATENDIMENTO;
NR_ATENDIMENTO_SUGERIDO_W PACIENTE_ATENDIMENTO.NR_ATENDIMENTO%TYPE;


NR_SEQ_PACIENTE_W PACIENTE_ATENDIMENTO.NR_SEQ_PACIENTE%TYPE := :NEW.NR_SEQ_PACIENTE;

verifica_classif_atend ATENDIMENTO_PACIENTE.NR_SEQ_CLASSIFICACAO%TYPE;

cd_pessoa_fisica_w ATENDIMENTO_PACIENTE.CD_PESSOA_FISICA%TYPE;

BEGIN

    SELECT DISTINCT CD_PESSOA_FISICA 
        INTO cd_pessoa_fisica_w
    FROM paciente_setor
    where nr_seq_paciente = NR_SEQ_PACIENTE_W;
    
    SELECT nr_seq_classificacao 
        INTO verifica_classif_atend
    FROM atendimento_paciente
    where nr_atendimento = nr_atendimento_w;
    
    SELECT MAX(NR_ATENDIMENTO)
       INTO NR_ATENDIMENTO_SUGERIDO_W
    FROM atendimento_paciente
    WHERE 1=1
    AND cd_pessoa_fisica = cd_pessoa_fisica_w
    AND NR_SEQ_CLASSIFICACAO  = 93
    AND dt_alta is null;
    

    IF (verifica_classif_atend <> 93) 
        THEN
            IF (NR_ATENDIMENTO_SUGERIDO_W is not null) THEN
                wheb_mensagem_pck.exibir_mensagem_abort('O Atendimento ' || NR_ATENDIMENTO_W || ' não é um atendimento elegível a infusão, o atendimento ' ||  NR_ATENDIMENTO_SUGERIDO_W || ' é o atendimento mais recente elegível a infusão.');
            ELSIF (NR_ATENDIMENTO_SUGERIDO_W IS NULL) THEN
                wheb_mensagem_pck.exibir_mensagem_abort('O Atendimento ' || NR_ATENDIMENTO_W || ' não é um atendimento elegível a infusão, favor contactar a Recepção');
            END IF;
    END IF;

END HCD_BQ_VINCULO_ATEND_QUIMIO;