CREATE OR REPLACE TRIGGER HCD_TRG_CP_INDICACAO_CLIN
  AFTER INSERT ON TASY.PRESCR_PROCEDIMENTO
  FOR EACH ROW
  
--<DS_SCRIPT>
-- DESCRIÇÃO..............: Copia indicação clinica procedimentos
-- RESPONSAVEL............: DOUGLAS FELIPE
-- DATA...................: 22/12/2022
-- APLICAÇÃO..............: TASY <CPOE>
--</DS_SCRIPT>

DECLARE

 NR_PRESCRICAO_W NUMBER := :NEW.NR_PRESCRICAO;
 NR_ATENDIMENTO_W NUMBER := OBTER_DADOS_PRESCRICAO(NR_PRESCRICAO_W,'A');
 DT_ATUALIZACAO_w DATE  := :NEW.DT_ATUALIZACAO_NREC;
 
 var_dt_suspensao DATE := :NEW.DT_SUSPENSAO;
 -- nr_seq_proc_w NUMBER := :NEW.NR_SEQ_PROC_CPOE;
 
 
 TYPE T_NUM IS TABLE OF NUMBER;
 NR_SEQ_W T_NUM;
 
 
 DS_INDICACAO_W VARCHAR2(4000);
    
 IE_VERIFICA_INDICACAO NUMBER := 0;
 
 

BEGIN 
    IF(OBTER_DADOS_PRESCRICAO(NR_PRESCRICAO_W,'CFO') = 2314 AND var_dt_suspensao is null) THEN
    
    SELECT 
        x.NR_SEQUENCIA
        BULK COLLECT INTO
            NR_SEQ_W
    FROM cpoe_procedimento x
        where 1=1
        and x.nr_atendimento = NR_ATENDIMENTO_W
        and x.dt_liberacao =  DT_ATUALIZACAO_w/* between ( TO_DATE(obter_dados_prescricao(NR_PRESCRICAO_W,'DL'),'DD/MM/YYYY HH24:MI:SS') - INTERVAL '1' MINUTE) 
        AND  TO_DATE(obter_dados_prescricao(NR_PRESCRICAO_W,'DL'),'DD/MM/YYYY HH24:MI:SS')*/
        AND x.dt_suspensao is null;
        
       
       -- ARMAZENA A INDICAÇÃO CLINICA --
        FOR indice IN 1..NR_SEQ_W.COUNT LOOP
        
            -- VERIFICA A INDICAÇÃO
            SELECT COUNT(DS_DADO_CLINICO)
                    INTO IE_VERIFICA_INDICACAO
                    FROM cpoe_procedimento
                    where 1=1
                    and nr_atendimento = NR_ATENDIMENTO_W
                    and nr_sequencia = nr_seq_w(indice);
                    
            IF(IE_VERIFICA_INDICACAO = 1)
            THEN
               
               SELECT DS_DADO_CLINICO
                INTO DS_INDICACAO_W
                    FROM cpoe_procedimento
                    where 1=1
                    and nr_atendimento = NR_ATENDIMENTO_W
                    and nr_sequencia = nr_seq_w(indice);
               
            END IF;
        END LOOP;
        
        
        FOR indice IN 1..NR_SEQ_W.COUNT LOOP
        
            IE_VERIFICA_INDICACAO := 0;
        
            -- VERIFICA SE JÁ EXISTE INDICAÇÃO --
            SELECT COUNT(DS_DADO_CLINICO)
                    INTO IE_VERIFICA_INDICACAO
                    FROM cpoe_procedimento
                    where 1=1
                    and nr_atendimento = NR_ATENDIMENTO_W
                    and nr_sequencia = nr_seq_w(indice);
                    
            IF(IE_VERIFICA_INDICACAO = 0)
            THEN
                UPDATE CPOE_PROCEDIMENTO SET DS_DADO_CLINICO = DS_INDICACAO_W 
                WHERE NR_ATENDIMENTO = NR_ATENDIMENTO_W AND NR_SEQUENCIA = NR_SEQ_W(indice);
            END IF;
        END LOOP;
  
    
END IF;
    
END HCD_TRG_CP_INDICACAO_CLIN;