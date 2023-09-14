CREATE OR REPLACE TRIGGER HCD_TRG_INSERE_COMENTARIO_SAE
AFTER INSERT ON PE_PRESCRICAO
FOR EACH ROW

/*<DS_SCRIPT>
 DESCRIÇÃO...: Trigger que realiza a inserção na aba comentário da SAE o histórico de saúde do paciente
 RESPONSAVEL.: DOUGLAS FELIPE (douglas.felipe)
 DATA........: 17/11/2022
 APLICAÇÃO...: TASY
 ATUALIZAÇÃO...:
    -- EXEMPLO:Atualizado em 07/01/22 por Douglas F: Adicionado filtro para buscar o bloqueio também pelo horário caso informado
 OBSERVAÇÕES...:  
    -- EXEMPLO: Douglas F: Parâmetro IE_OPCAO_P pode ser 'A' - Agrupados ou 'N' - Normal.
</DS_SCRIPT>*/




DECLARE

NR_SEQ_PRESCR_W NUMBER := :NEW.NR_SEQUENCIA;
NR_ATENDIMENTO_W NUMBER := :NEW.NR_ATENDIMENTO;
CD_PESSOA_FISICA_W NUMBER := :NEW.CD_PESSOA_FISICA;


DS_ALERGIAS_W VARCHAR2(4000);
DS_HABITOS_W VARCHAR2(4000);
DS_DOENCAS_PREVIAS_W VARCHAR2(4000);
DS_HIST_CIRURGIAS_W VARCHAR2(4000);
DS_ORTESE_PROTESE_W VARCHAR2(4000);
DS_VULNERABILIDADES_W VARCHAR2(4000);
DS_RESTRICOES_W VARCHAR2(4000);
DS_TEXTO_W VARCHAR2(4000);


BEGIN

-- ALERGIAS --
SELECT OBTER_ALERGIAS(CD_PESSOA_FISICA_W) 
        INTO DS_ALERGIAS_W
FROM DUAL;

-- HÁBITOS --
SELECT HCD_OBTER_HIST_HABITOS(CD_PESSOA_FISICA_W) 
    INTO DS_HABITOS_W
FROM DUAL;

-- DOENÇAS PRÉVIAS --
SELECT OBTER_DOENCAS(CD_PESSOA_FISICA_W)
        INTO DS_DOENCAS_PREVIAS_W
FROM DUAL;

-- HISTÓRICO DE CIRURGIAS --
SELECT HCD_OBTER_HIST_CIRURGIA(CD_PESSOA_FISICA_W)
        INTO DS_HIST_CIRURGIAS_W
FROM DUAL;

-- ORTESE/PROTESE --
SELECT HCD_OBTER_HIST_ORTESE_PROTESE(CD_PESSOA_FISICA_W) 
        INTO DS_ORTESE_PROTESE_W
FROM DUAL; 

-- VULNERABILIDADES --
SELECT HCD_OBTER_HIST_VUL(CD_PESSOA_FISICA_W)
        INTO DS_VULNERABILIDADES_W
FROM DUAL;

-- RESTRIÇÕES --
SELECT HCD_OBTER_HIST_RESTRICAO(CD_PESSOA_FISICA_W)
    INTO DS_RESTRICOES_W
FROM DUAL;


DS_TEXTO_W := '<html tasy="html5"><body>
                        <pre><span style="font-size:20px;"><strong>Alergias:</strong></span></pre>
                         <p>' || DS_ALERGIAS_W || '</p>
                         </br>
                         <pre><span style="font-size:20px;"><strong>Hábitos:</strong></span></pre>
                         <p>' || DS_HABITOS_W || '</p>
                         </br>
                         <pre><span style="font-size:20px;"><strong>Doenças Prévias:</strong></span></pre>
                         <p>' || DS_DOENCAS_PREVIAS_W || '</p>
                         </br>
                         <pre><span style="font-size:20px;"><strong>Histórico de Cirurgias:</strong></span></pre>
                         <p>' || DS_HIST_CIRURGIAS_W || '</p>
                         </br>
                         <pre><span style="font-size:20px;"><strong>Ortese/Protese:</strong></span></pre>
                         <p>' || DS_ORTESE_PROTESE_W || '</p>
                         </br>
                         <pre><span style="font-size:20px;"><strong>Vulnerabilidades:</strong></span></pre>
                         <p>' || DS_VULNERABILIDADES_W || '</p>
                         </br>
                         <pre><span style="font-size:20px;"><strong>Restrições:</strong></span></pre>
                         <p>' || DS_RESTRICOES_W || '</p>
                         </br>
                        </body>
                        </body></html>';

INSERT INTO PE_PRESCR_COMENTARIO
VALUES
    (PE_PRESCR_COMENTARIO_SEQ.NEXTVAL,
    SYSDATE,
    OBTER_USUARIO_ATIVO(),
    NR_SEQ_PRESCR_W,
    DS_TEXTO_W,
    SYSDATE,
    OBTER_USUARIO_ATIVO());



END HCD_TRG_INSERE_COMENTARIO_SAE;