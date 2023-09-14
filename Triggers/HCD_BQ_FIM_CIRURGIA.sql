CREATE OR REPLACE TRIGGER HCD_BQ_FIM_CIRURGIA
BEFORE UPDATE ON CIRURGIA
FOR EACH ROW
WHEN (NEW.DT_TERMINO IS NOT NULL)

/*<DS_SCRIPT>
 DESCRIÇÃO...: Trigger que ao tentar finalizar o fim de cirurgia é verificado se o potencial de comunicação está preenchido, caso não é disparado mensagem de trava para preenchimento da mesma.
 RESPONSAVEL.: DOUGLAS FELIPE (douglas.felipe)
 DATA........: 14/06/2023
 APLICAÇÃO...: TASY
 ATUALIZAÇÃO...:
    Atualizado em 19/06/23 por Douglas F: Adicionado condição IF para ignorar setores que não sejam o CC UNA e UCB
    Atualizado em 26/06/23 por Douglas F: Adicionado um novo alerta para não permitir que a data fim seja menor que a do Início
 OBSERVAÇÕES...:  
    
</DS_SCRIPT>*/

DECLARE

NR_CIRURGIA_W CIRURGIA.NR_CIRURGIA%TYPE := :NEW.nr_cirurgia;
NR_PRESCR_W CIRURGIA.NR_PRESCRICAO%TYPE := :NEW.nr_prescricao;
DT_INICIO_REAL_W CIRURGIA.DT_INICIO_REAL%TYPE := :NEW.DT_INICIO_REAL;
DT_TERMINO_W CIRURGIA.DT_TERMINO%TYPE := :NEW.DT_TERMINO;

-- VERIFICA POTENCIAL DE CONTAMINAÇÃO PROCEDIMENTO PRINCIPAL --
CD_TIPO_CIRURGIA_W CIRURGIA.CD_TIPO_CIRURGIA%TYPE := :NEW.CD_TIPO_CIRURGIA;

-- ARMAZENA OS PROCEDIMENTOS DO POTENCIAL DE CONTAMINAÇÃO
ds_retorno VARCHAR2(4000) := null;

-- VERIFICA POTENCIAL DE CONTAMINAÇÃO PROCEDIMENTOS ADICIONAIS --
CURSOR c01 is
    select obter_desc_procedimento(a.cd_procedimento, a.ie_origem_proced) ds_procedimento, a.CD_TIPO_CIRURGIA
    from prescr_procedimento a join proc_interno b on (a.nr_seq_proc_interno = b.nr_sequencia) 
    where 1=1
    AND a.nr_prescricao = NR_PRESCR_W
    AND b.ie_tipo_util = 'C';


VET01 c01%rowtype;


BEGIN

-- VERIFICA SE OS PERFIS SÃO OS DE CENTRO CIRURGICO --
IF( OBTER_PERFIL_ATIVO() NOT IN (2651,2570,2562,2639,2180,2290,2181,2291,2182,2292,2561,2663,2532,2548,2517,2519,2518,2580,2581,2582,2471,2472,2473,2474,2533,2427,2574,2426,2550,2475,2494,2588)) THEN



-- ALERTA POTENCIAL DE CONTAMINAÇÃO ==
    OPEN c01;
        LOOP
          FETCH c01 into VET01;
          EXIT WHEN c01%notfound;
            BEGIN
                IF(vet01.CD_TIPO_CIRURGIA is null) then
                    ds_retorno := ds_retorno || '- ' || vet01.ds_procedimento || chr(10);
                END IF;
            END;
        END LOOP;
        CLOSE c01;

    IF(CD_TIPO_CIRURGIA_W IS NULL) THEN
        wheb_mensagem_pck.exibir_mensagem_abort('Potencial de contaminação não informado' || CHR(10) || 'Trigger: HCD_BQ_FIM_CIRURGIA');

    ELSIF( DS_RETORNO IS NOT NULL) THEN
        wheb_mensagem_pck.exibir_mensagem_abort('O(s) procedimento(s): ' || chr(10) || ds_retorno || 'não esta(ão) com o potencial de contaminação informado' || CHR(10) || 'Trigger: HCD_BQ_FIM_CIRURGIA');
    END IF;

-- ALERTA FIM DE CIRURGIA MENOR OU IGUAL AO INICIO --
IF (DT_TERMINO_W <= DT_INICIO_REAL_W)
    THEN wheb_mensagem_pck.exibir_mensagem_abort('O Fim de cirurgia não pode ser menor ou igual ao início' || CHR(10) || 'Trigger: HCD_BQ_FIM_CIRURGIA');
END IF;
        
    

END IF;

END HCD_BQ_FIM_CIRURGIA;