create or replace FUNCTION HCD_ANAMNESE_EXAM_SAE (NR_SEQ_PRESCR_P NUMBER, NR_SEQ_ITEM_P NUMBER)
RETURN VARCHAR2 IS

/*<DS_SCRIPT>
 DESCRIÇÃO...: Function que retorna de forma ordenada os diagnosticos informados na SAE
 RESPONSAVEL.: DOUGLAS FELIPE (douglas.felipe)
 DATA........: 22/11/2022
 APLICAÇÃO...: TASY
 ATUALIZAÇÃO...:
    -- EXEMPLO:Atualizado em 07/01/22 por Douglas F: Adicionado filtro para buscar o bloqueio também pelo horário caso informado
 OBSERVAÇÕES...:  
    -- EXEMPLO Douglas F: Parâmetro IE_OPCAO_P pode ser 'A' - Agrupados ou 'N' - Normal.
</DS_SCRIPT>*/

/* NR_SEQ_ITEM_P  
34	Abdome
19	Condições da Higiene Corporal
23	Condições da pele e mucosas
65	Dispositivos Vasculares
62	Eliminações Intestinais
63	Elininações Urinárias
51	Ferida Operatória
59	Ingesta alimentar e hídrica
46	Integridade Emocional
49	Locomoção
64	MMSS E MMII
50	Motricidade
44	Nível de Consciência
66	Perfusão Perfiférica
57	Pressão Arterial
58	Pulsos Periféricos
47	Regulação Térmica
56	Ritmo Cardíaco
45	Sono e Repouso
52	Tórax
54	Tosse
55	Ventilação
*/


DS_RETORNO_W VARCHAR2(4000);

CURSOR C01 IS

    SELECT OBTER_DESC_ITEM_RESULTADO(nr_seq_result) DS_ANAMNESE_EXA_SAE
    FROM PE_PRESCR_ITEM_RESULT 
    WHERE nr_seq_prescr = NR_SEQ_PRESCR_P
    AND nr_seq_item = nr_seq_item_p
    ORDER BY 1;



VET01 C01%ROWTYPE;    

BEGIN
    OPEN C01;
    LOOP
        FETCH C01 INTO VET01;
    EXIT WHEN C01%NOTFOUND;
        BEGIN
            DS_RETORNO_W := DS_RETORNO_W || VET01.DS_ANAMNESE_EXA_SAE || ',';
        END;
    END LOOP;

DS_RETORNO_W := SUBSTR(DS_RETORNO_W,1,LENGTH(DS_RETORNO_W)-1);
RETURN DS_RETORNO_W;

END HCD_ANAMNESE_EXAM_SAE;