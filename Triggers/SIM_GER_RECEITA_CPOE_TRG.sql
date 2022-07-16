create or replace TRIGGER TASY.SIM_GER_RECEITA_CPOE_TRG
  BEFORE INSERT ON PRESCR_MATERIAL
  FOR EACH ROW
  
  --<DS_SCRIPT>
-- DESCRIÇÃO..............: Gerar receita com base nos medicamentos prescritos na CPOE
-- RESPONSAVEL............: DOUGLAS FELIPE / ANDERSON FARIAS
-- DATA...................: 23/02/2022
-- APLICAÇÃO..............: TASY <CPOE>
--</DS_SCRIPT>
  
DECLARE
DS_RETORNO_W VARCHAR2(3000);
NR_PRESCRICAO_W NUMBER := :NEW.NR_PRESCRICAO;
CHECK_SE_RECEITA_W NUMBER;
SEQ_RECEITA_W NUMBER;

CURSOR c01 is
--LISTA OS ITENS
    SELECT
        obter_desc_material(CD_MATERIAL)||' '||CD_UNIDADE_MEDIDA||' '||QT_DOSE||' '||CD_INTERVALO AS RECEITA_ITEM_W
   FROM CPOE_MATERIAL
   WHERE 1=1
       AND NR_ATENDIMENTO = Obter_dados_prescricao(NR_PRESCRICAO_W,'A')
       AND TRUNC(dt_liberacao) = TRUNC(SYSDATE)
       AND DT_SUSPENSAO IS NULL;

VET01 c01%ROWTYPE;

BEGIN
--VALIDA SE TEM DA CPOE
 IF(OBTER_DADOS_PRESCRICAO(NR_PRESCRICAO_W,'CFO') = 2314) THEN

    -- SE EXISTE RECEITA PARA A PRESCRIÇÃO ATUAL ONDE 0 = NÃO EXISTE
    SELECT NVL(MAX(NR_SEQUENCIA),0)
        INTO CHECK_SE_RECEITA_W
    FROM MED_RECEITA
        WHERE 1=1
        AND NR_ATENDIMENTO_HOSP = OBTER_DADOS_PRESCRICAO(NR_PRESCRICAO_W,'A')
        AND IE_SITUACAO = 'A'
        AND NR_PRESCRICAO = NR_PRESCRICAO_W
        AND TRUNC(DT_RECEITA) = TRUNC(SYSDATE);

    IF (CHECK_SE_RECEITA_W = 0) THEN

        OPEN c01;
            LOOP
                FETCH c01 into VET01;
            EXIT WHEN c01%notfound;
                begin
                    ds_retorno_w := ds_retorno_w || VET01.RECEITA_ITEM_W|| CHR(10);
                end;
            END LOOP;
        CLOSE c01;
        END IF;
        ds_retorno_w := substr(ds_retorno_w, 1, length(ds_retorno_w)-2);

        -- verifica se o ds_retorno_w não passou nulo
        IF(DS_RETORNO_W is not null) THEN

            -- Cria nova sequencia na aba de receita
            SELECT MED_RECEITA_SEQ.nextval INTO SEQ_RECEITA_W FROM DUAL;

            --INSERT INTO SIM_LOG VALUES (NR_PRESCRICAO_W,SYSDATE,ds_retorno_w);
            INSERT INTO MED_RECEITA(NR_SEQUENCIA,
                                    DT_ATUALIZACAO,
                                    NM_USUARIO,
                                    NR_PRESCRICAO,
                                    DT_RECEITA,
                                    DS_RECEITA,
                                    NR_ATENDIMENTO_HOSP,
                                    CD_PESSOA_FISICA,
                                    CD_MEDICO,
                                    DT_LIBERACAO,
                                    IE_TIPO_RECEITA,
                                    IE_SITUACAO,
                                    CD_PERFIL_ATIVO)
                            VALUES
                                    (SEQ_RECEITA_W,
                                    SYSDATE,
                                    'CPOE',
                                    NR_PRESCRICAO_W,
                                    SYSDATE,
                                    DS_RETORNO_W,
                                    Obter_dados_prescricao(NR_PRESCRICAO_W,'A'),
                                    Obter_Dados_Atendimento(Obter_dados_prescricao(NR_PRESCRICAO_W,'A'),'CP'),
                                    Obter_dados_prescricao(NR_PRESCRICAO_W,'CP'),
                                    SYSDATE,
                                    'C',
                                    'A',
                                    '2073');
    END IF;
   END IF;

END SIM_GER_RECEITA_CPOE_TRG;