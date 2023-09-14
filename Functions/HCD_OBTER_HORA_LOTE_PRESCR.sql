create or replace FUNCTION HCD_OBTER_HORA_LOTE_PRESCR (nr_seq_lote_p number, cd_material_p number, nr_seq_material_p number, nr_seq_superior_p number default null, nr_prescricao_p number, ie_opcao_p VARCHAR2, ie_opcao_col_p VARCHAR2 )
RETURN VARCHAR2
/*<DS_SCRIPT>
 DESCRIÇÃO...: Function que retorna os horários dos itens do lote da prescrição
 RESPONSAVEL.: DOUGLAS FELIPE (douglas.felipe)
 DATA........: 09/11/2022
 APLICAÇÃO...: TASY
 ATUALIZAÇÃO...:
    -- Atualizado em 09/11/22 por Douglas F: Adicionado filtro IE_OPCAO_COL para trazer se é a coluna de horário ou de dose a dispensar
 OBSERVAÇÕES...:  
    -- Douglas F: Parâmetro NR_SEQ_SUPERIOR_P utilizado apenas para os componentes dos médicamentos, sendo assim para o medicamento principal não necessita a passagem do mesmo.
    -- Douglas F: Parâmetro IE_OPCAO_P pode ser 'A' - Agrupados ou 'N' - Normal.
    -- Douglas F: Parâmetro IE_OPCAO_COL_P pode ser 'HR' - Horário ou 'DS' - Quantidade a Dispensar.
    -- Douglas F: Parâmetro NM_SEQ_MATERIAL utilizado para identificar de forma únic um item.
</DS_SCRIPT>*/

AS
ds_retorno VARCHAR2(4000);

cursor C01 is -- BANDA NORMAL
    -- NORMAL --
    select distinct
        to_char(dt_horario,'hh24:mi') ds_horario,
        c.qt_dispensar_hor || c.cd_unidade_medida qt_dispensar
    from tasy.ap_lote_item a,
         tasy.prescr_mat_hor c,
         tasy.ap_lote b
    where	b.nr_sequencia = a.nr_seq_lote
    and	b.nr_sequencia = nr_seq_lote_p
    and	a.nr_seq_mat_hor = c.nr_sequencia
    and c.nr_seq_superior is null
    and nr_seq_superior_p is null
    and a.cd_material = cd_material_p
    and c.nr_seq_material = nr_seq_material_p
    UNION ALL                            
    -- CP NORMAL --                            
    select distinct
        to_char(dt_horario,'hh24:mi'),
        c.qt_dispensar_hor || c.cd_unidade_medida qt_dispensar
    from tasy.ap_lote_item a,
         tasy.prescr_mat_hor c,
         tasy.ap_lote b
    where	b.nr_sequencia = a.nr_seq_lote
    and	b.nr_sequencia = nr_seq_lote_p
    and	a.nr_seq_mat_hor = c.nr_sequencia
    and c.nr_seq_superior is not null
    and ((c.nr_seq_superior = nr_seq_superior_p))
    and c.cd_material = cd_material_p
    and c.nr_seq_material = nr_seq_material_p;

VET01 C01%rowtype;


cursor C02 is
    -- AGRUPADO --
   select distinct
        to_char(dt_horario,'hh24:mi') ds_horario,
        c.qt_dispensar_hor || c.cd_unidade_medida qt_dispensar
    from tasy.ap_lote_item a,
         tasy.prescr_mat_hor c,
         tasy.ap_lote b
    where b.nr_lote_agrupamento = nr_seq_lote_p
    and b.nr_prescricao = c.nr_prescricao
    and b.nr_sequencia = a.nr_seq_lote
    and	a.nr_seq_mat_hor = c.nr_sequencia
    and a.cd_material = cd_material_p
    and c.nr_seq_superior is null
    and nr_seq_superior_p is null
    and c.dt_suspensao is null

    UNION ALL
    -- AGRUPADO CP --
    select distinct
        to_char(dt_horario,'hh24:mi') ds_horario,
        c.qt_dispensar_hor || c.cd_unidade_medida qt_dispensar
    from tasy.ap_lote_item a,
         tasy.prescr_mat_hor c,
         tasy.ap_lote b
    where b.nr_lote_agrupamento = nr_seq_lote_p
    and b.nr_sequencia = a.nr_seq_lote
    and	a.nr_seq_mat_hor = c.nr_sequencia
    and c.nr_seq_superior is not null
    and ((c.nr_seq_superior = nr_seq_superior_p))
    and c.nr_prescricao = nr_prescricao_p
    and a.cd_material = cd_material_p;

VET02 C02%rowtype;


BEGIN
    IF (IE_OPCAO_P = 'N')
        THEN
            IF(IE_OPCAO_COL_P = 'HR')
                THEN
                    OPEN C01;
                    LOOP
                    FETCH C01 INTO VET01;
                    EXIT WHEN C01%NOTFOUND;
        
                    ds_retorno := ds_retorno || VET01.DS_HORARIO || '   ';
                    END LOOP;
                    
            ELSIF(IE_OPCAO_COL_P = 'DS')
                THEN
                    OPEN C01;
                    LOOP
                    FETCH C01 INTO VET01;
                    EXIT WHEN C01%NOTFOUND;
        
                    ds_retorno := ds_retorno || VET01.QT_DISPENSAR || '   '; 
                    END LOOP;
            END IF;

            
    ELSIF (IE_OPCAO_P = 'A')
        THEN
            IF(IE_OPCAO_COL_P = 'HR')
                THEN
                    OPEN C02;
                    LOOP
                    FETCH C02 INTO VET02;
                    EXIT WHEN C02%NOTFOUND;
        
                    ds_retorno := ds_retorno || VET02.DS_HORARIO || '   ';
        
                    END LOOP;
            ELSIF(IE_OPCAO_COL_P = 'DS')
                THEN
                    OPEN C02;
                    LOOP
                    FETCH C02 INTO VET02;
                    EXIT WHEN C02%NOTFOUND;
        
                    ds_retorno := ds_retorno || VET02.QT_DISPENSAR || '   ';
        
                    END LOOP;
            END IF;
    END IF;

    ds_retorno := SUBSTR(ds_retorno,1,length(ds_retorno)-1);
    RETURN ds_retorno;

END HCD_OBTER_HORA_LOTE_PRESCR;