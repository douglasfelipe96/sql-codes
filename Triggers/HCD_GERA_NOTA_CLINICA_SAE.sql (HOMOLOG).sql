create or replace TRIGGER HCD_GERA_NOTA_CLINICA_SAE
BEFORE UPDATE ON PE_PRESCRICAO
FOR EACH ROW

DECLARE

CD_PESSOA_FISICA_W NUMBER := :NEW.CD_PESSOA_FISICA;
NR_ATENDIMENTO_W NUMBER := :NEW.NR_ATENDIMENTO;
NR_SEQ_PRESCR_W NUMBER := :NEW.NR_SEQUENCIA;
CD_PRESCR_W NUMBER := :NEW.CD_PRESCRITOR;
DT_LIBERACAO_W DATE := :NEW.DT_LIBERACAO;
DT_INATIVACAO_W DATE := :NEW.DT_INATIVACAO;
CD_PERFIL_ATIVO_W NUMBER := :NEW.CD_PERFIL_ATIVO;
CD_SETOR_ATENDIMENTO_W NUMBER := :NEW.CD_SETOR_ATENDIMENTO;


QT_DIAS_INTERNADO_W NUMBER;
DT_ENTRADA_SETOR_W DATE;

DS_RISCOS_W VARCHAR2(4000);

-- ACHADOS SAE --
DS_ABDOME_W VARCHAR2(4000);
DS_CONDICOES_HIG_CORP_W VARCHAR2(4000);
DS_CONDICOES_PELE_MUCOSA_W VARCHAR2(4000);
DS_DISP_VASCULARES_W VARCHAR2(4000);
DS_ELIMINACAO_INTEST_W VARCHAR2(4000);
DS_ELIMINACAO_URINARIA_W VARCHAR2(4000);
DS_FERIDAS_OPERATORIAS_W VARCHAR2(4000);
DS_INGEST_ALIMENTAR_W VARCHAR2(4000);
DS_INTEGR_EMOCIONAL_W VARCHAR2(4000);
DS_LOCOMOCAO_W VARCHAR2(4000);
DS_MMSS_MMII_W VARCHAR2(4000);
DS_MOTRICIDADE_W VARCHAR2(4000);
DS_NIVEL_CONSCIENCIA_W VARCHAR2(4000); 
DS_PERFUSAO_PERIF_W VARCHAR2(4000);
DS_PRESSAO_ARTERIAL_W VARCHAR2(4000);
DS_PULSO_PERIFERICO_W VARCHAR2(4000);
DS_REGULACAO_TERM_W VARCHAR2(4000);
DS_RITMO_CARDIAC_W VARCHAR2(4000);
DS_SONO_REPOUSO_W VARCHAR2(4000);
DS_TORAX_W VARCHAR2(4000);
DS_TOSSE_W VARCHAR2(4000);
DS_VENTILACAO_W VARCHAR2(4000);
-- FIM ACHADOS SAE --

DS_TEXTO_W VARCHAR2(4000);


BEGIN

IF (DT_LIBERACAO_W IS NOT NULL AND DT_INATIVACAO_W IS NULL)
    THEN
    -- RISCOS DO PACIENTE --
    SELECT HCD_DIAGNOSTICOS_SAE(NR_SEQ_PRESCR_W) INTO DS_RISCOS_W FROM DUAL;

    -- Dias de Internação --
    SELECT OBTER_DIAS_INTERNACAO(NR_ATENDIMENTO_W) INTO QT_DIAS_INTERNADO_W FROM DUAL;

-- INSERE ACHADOS NAS VARIÁVEIS
    SELECT 
        HCD_ANAMNESE_EXAM_SAE(NR_SEQ_PRESCR_W, 34), /* ABDOME */
        HCD_ANAMNESE_EXAM_SAE(NR_SEQ_PRESCR_W, 19), /* Condições da Higiene Corporal */
        HCD_ANAMNESE_EXAM_SAE(NR_SEQ_PRESCR_W, 23), /* Condições da pele e mucosas */
        HCD_ANAMNESE_EXAM_SAE(NR_SEQ_PRESCR_W, 65), /* Dispositivos Vasculares */
        HCD_ANAMNESE_EXAM_SAE(NR_SEQ_PRESCR_W, 62), /* Eliminações Intestinais */
        HCD_ANAMNESE_EXAM_SAE(NR_SEQ_PRESCR_W, 63), /* Elininações Urinárias */
        HCD_ANAMNESE_EXAM_SAE(NR_SEQ_PRESCR_W, 51), /* Ferida Operatória */
        HCD_ANAMNESE_EXAM_SAE(NR_SEQ_PRESCR_W, 59), /* Ingesta alimentar e hídrica */
        HCD_ANAMNESE_EXAM_SAE(NR_SEQ_PRESCR_W, 46), /* Integridade Emocional */
        HCD_ANAMNESE_EXAM_SAE(NR_SEQ_PRESCR_W, 49), /* Locomoção */
        HCD_ANAMNESE_EXAM_SAE(NR_SEQ_PRESCR_W, 64), /* MMSS E MMII */
        HCD_ANAMNESE_EXAM_SAE(NR_SEQ_PRESCR_W, 50), /* Motricidade */
        HCD_ANAMNESE_EXAM_SAE(NR_SEQ_PRESCR_W, 44), /* Nível de Consciência */
        HCD_ANAMNESE_EXAM_SAE(NR_SEQ_PRESCR_W, 66), /* Perfusão Perfiférica */
        HCD_ANAMNESE_EXAM_SAE(NR_SEQ_PRESCR_W, 57), /* Pressão Arterial */
        HCD_ANAMNESE_EXAM_SAE(NR_SEQ_PRESCR_W, 58), /* Pulsos Periféricos */
        HCD_ANAMNESE_EXAM_SAE(NR_SEQ_PRESCR_W, 47), /* Regulação Térmica */
        HCD_ANAMNESE_EXAM_SAE(NR_SEQ_PRESCR_W, 56), /* Ritmo Cardíaco */
        HCD_ANAMNESE_EXAM_SAE(NR_SEQ_PRESCR_W, 45), /* Sono e Repouso */
        HCD_ANAMNESE_EXAM_SAE(NR_SEQ_PRESCR_W, 52), /* Tórax */
        HCD_ANAMNESE_EXAM_SAE(NR_SEQ_PRESCR_W, 54), /* Tosse */
        HCD_ANAMNESE_EXAM_SAE(NR_SEQ_PRESCR_W, 55) /* Ventilação */
        INTO
        DS_ABDOME_W,
        DS_CONDICOES_HIG_CORP_W,
        DS_CONDICOES_PELE_MUCOSA_W,
        DS_DISP_VASCULARES_W,
        DS_ELIMINACAO_INTEST_W,
        DS_ELIMINACAO_URINARIA_W,
        DS_FERIDAS_OPERATORIAS_W,
        DS_INGEST_ALIMENTAR_W,
        DS_INTEGR_EMOCIONAL_W,
        DS_LOCOMOCAO_W,
        DS_MMSS_MMII_W,
        DS_MOTRICIDADE_W,
        DS_NIVEL_CONSCIENCIA_W,
        DS_PERFUSAO_PERIF_W,
        DS_PRESSAO_ARTERIAL_W,
        DS_PULSO_PERIFERICO_W,
        DS_REGULACAO_TERM_W,
        DS_RITMO_CARDIAC_W,
        DS_SONO_REPOUSO_W,
        DS_TORAX_W,
        DS_TOSSE_W,
        DS_VENTILACAO_W
    FROM DUAL;

    SELECT MAX(TRUNC(DT_ENTRADA_UNIDADE)) 
        INTO DT_ENTRADA_SETOR_W
    FROM ATEND_PACIENTE_UNIDADE 
    WHERE 1=1
    AND nr_atendimento = NR_ATENDIMENTO_W 
    AND cd_setor_atendimento = CD_SETOR_ATENDIMENTO_W;


IF (QT_DIAS_INTERNADO_W > 1) THEN

    DS_TEXTO_W := '<html tasy="html5"><body>
                            <p> Paciente evoluindo no <strong>' || QT_DIAS_INTERNADO_W || 'º </strong> dia de internação, ao exame físico encontra-se <strong>' ||  DS_NIVEL_CONSCIENCIA_W || '</strong>, apresentando sono e repouso <strong>' || DS_SONO_REPOUSO_W || '</strong>, <strong>' || DS_INTEGR_EMOCIONAL_W || '</strong>, <strong>' || DS_REGULACAO_TERM_W || '</strong> apresentando condições de higiene corporal <strong>' || DS_CONDICOES_HIG_CORP_W || '</strong>, <strong>' || DS_LOCOMOCAO_W || '</strong>, apresentando motricidade <strong>' || DS_MOTRICIDADE_W || '</strong>, pele e mucosas <strong>' || DS_CONDICOES_PELE_MUCOSA_W || '</strong>, ferida operatória <strong>' || DS_FERIDAS_OPERATORIAS_W || '</strong> tórax <strong>' || DS_TORAX_W || '</strong>, tosse <strong>' || DS_TOSSE_W || '</strong>, <strong>' || DS_VENTILACAO_W || '</strong>, <strong>' || DS_RITMO_CARDIAC_W || '</strong>, <strong>' || DS_PRESSAO_ARTERIAL_W || '</strong>, pulsos periféricos <strong>' || DS_PULSO_PERIFERICO_W || '</strong>, apresentando <strong>' || DS_INGEST_ALIMENTAR_W || '</strong>, abdome <strong>' || DS_ABDOME_W || '</strong>, <strong>' || DS_ELIMINACAO_INTEST_W ||'</strong>, <strong>' || DS_ELIMINACAO_URINARIA_W || '</strong>, membros superiores/inferiores apresentando <strong>' || DS_MMSS_MMII_W ||'</strong>, em uso de <strong>' || DS_DISP_VASCULARES_W || '</strong>, <strong>' || DS_PERFUSAO_PERIF_W || '</strong>.</p>
                             </br>
                            <p> Riscos do Paciente: <strong>' || DS_RISCOS_W || '</strong>. </p>
                             </br>
                            </body>
                            </body></html>';

ELSIF (QT_DIAS_INTERNADO_W <= 1  OR DT_ENTRADA_SETOR_W = TRUNC(SYSDATE)) THEN
      DS_TEXTO_W := '<html tasy="html5"><body>
                            <p> Paciente admitido desta unidade de internação, proveniente de______, acompanhando por______. Ao exame físico encontra-se <stong>' || DS_NIVEL_CONSCIENCIA_W || '</strong>, apresentando sono e repouso <strong>' || DS_SONO_REPOUSO_W || '</strong>, <strong>' || DS_INTEGR_EMOCIONAL_W || '</strong>, <strong>' || DS_REGULACAO_TERM_W || '</strong> apresentando condições de higiene corporal <strong>' || DS_CONDICOES_HIG_CORP_W || '</strong>, <strong>' || DS_LOCOMOCAO_W || '</strong>, apresentando motricidade <strong>' || DS_MOTRICIDADE_W || '</strong>, pele e mucosas <strong>' || DS_CONDICOES_PELE_MUCOSA_W || '</strong>, ferida operatória <strong>' || DS_FERIDAS_OPERATORIAS_W || '</strong> tórax <strong>' || DS_TORAX_W || '</strong>, tosse <strong>' || DS_TOSSE_W || '</strong>, <strong>' || DS_VENTILACAO_W || '</strong>, <strong>' || DS_RITMO_CARDIAC_W || '</strong>, <strong>' || DS_PRESSAO_ARTERIAL_W || '</strong>, pulsos periféricos <strong>' || DS_PULSO_PERIFERICO_W || '</strong>, apresentando <strong>' || DS_INGEST_ALIMENTAR_W || '</strong>, abdome <strong>' || DS_ABDOME_W || '</strong>, <strong>' || DS_ELIMINACAO_INTEST_W ||'</strong>, <strong>' || DS_ELIMINACAO_URINARIA_W || '</strong>, membros superiores/inferiores apresentando <strong>' || DS_MMSS_MMII_W ||'</strong>, em uso de <strong>' || DS_DISP_VASCULARES_W || '</strong>, <strong>' || DS_PERFUSAO_PERIF_W || '</strong>.</p>
                             </br>
                             <p> Riscos do Paciente: <strong>' || DS_RISCOS_W || '</strong>.</p>
                             </br>
                            </body>
                            </body></html>';


END IF;

    INSERT INTO EVOLUCAO_PACIENTE
                (CD_EVOLUCAO,
                 DT_EVOLUCAO,
                 IE_TIPO_EVOLUCAO,
                 CD_PESSOA_FISICA,
                 DT_ATUALIZACAO,
                 NM_USUARIO,
                 DT_ATUALIZACAO_NREC,
                 NM_USUARIO_NREC,
                 NR_ATENDIMENTO,
                 DS_EVOLUCAO,
                 CD_MEDICO,
                 IE_EVOLUCAO_CLINICA,
                 CD_SETOR_ATENDIMENTO,
                 CD_PERFIL_ATIVO,
                 IE_RESTRICAO_VISUALIZACAO,
                 IE_SITUACAO
                )
        VALUES (
                EVOLUCAO_PACIENTE_SEQ.NEXTVAL, -- SEQUENCIA
                SYSDATE, -- DT_EVOLUCAO
                3, -- IE_TIPO_EVOLUCAO
                CD_PESSOA_FISICA_W, -- CD_PESSOA_FISICA
                SYSDATE, -- DT_ATUALIZACAO
                OBTER_USUARIO_ATIVO(), -- NM_USUARIO
                SYSDATE, -- DT_ATUALIZACAO_NREC
                OBTER_USUARIO_ATIVO(), -- NM_USUARIO_NREC
                NR_ATENDIMENTO_W, -- NR_ATENDIMENTO
                DS_TEXTO_W, -- DS_EVOLUCAO
                CD_PRESCR_W, -- CD_MEDICO
                'ENF', -- IE_EVOLUCAO_CLINICA
                OBTER_SETOR_ATENDIMENTO(NR_ATENDIMENTO_W), -- CD_SETOR_ATENDIMENTO
                OBTER_PERFIL_ATIVO(), -- CD_PERFIL_ATIVO
                'T', -- IE_RESTRICAO_VISUALIZACAO
                'A'); -- IE_SITUACAO
END IF;

END HCD_GERA_NOTA_CLINICA_SAE;