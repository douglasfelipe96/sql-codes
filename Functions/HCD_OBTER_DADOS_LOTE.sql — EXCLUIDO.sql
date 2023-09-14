create or replace FUNCTION HCD_OBTER_DADOS_LOTE (nr_seq_lote_p number, cd_material_p number, nr_seq_material_p number, ie_posicao number, ie_tipo_lote varchar2, ie_opcao varchar2)
RETURN VARCHAR2

/*<DS_SCRIPT>
 DESCRIÇÃO...: FUNÇÃO QUE RETORNA OS DADOS REFERENTE AO HORÁRIO E DOSAGEM DOS MEDICAMENTOS DO LOTE NORMAIS E AGRUPADOS
 RESPONSAVEL.: DOUGLAS FELIPE (douglas.fs)
 DATA........: 28/09/2022
 APLICAÇÃO...: TASY
 ATUALIZAÇÃO...:
</DS_SCRIPT>*/


-- IE_POSICAO = COLUNAS DE 1 A 12

-- IE_TIPO_LOTE:
-- 'N' - NORMAL
-- 'A' - AGRUPADO

-- IE_OPCAO: 
-- 'H' - Horário 
-- 'D' - Dosagem


IS
DS_RETORNO VARCHAR2(255);
BEGIN
    IF(ie_posicao = 1)
        THEN
            IF (ie_tipo_lote = 'N')
                THEN
                    IF(ie_opcao = 'H') 
                        THEN
                            select distinct
                            to_char(dt_horario,'hh24:mi')
                                INTO DS_RETORNO
                            from tasy.prescr_mat_hor
                            where (nr_seq_lote = nr_seq_lote_p)
                            and (cd_material = cd_material_p)
                            and (nr_seq_material = nr_seq_material_p)
                            and (to_char(dt_horario,'hh24:mi') between '00:00' and '01:59');  
                    ELSIF (ie_opcao = 'D')
                        THEN
                            select distinct
                            qt_dispensar_hor || cd_unidade_medida
                                INTO DS_RETORNO
                            from tasy.prescr_mat_hor
                            where (nr_seq_lote = nr_seq_lote_p)
                            and (cd_material = cd_material_p)
                            and (nr_seq_material = nr_seq_material_p)
                            and (to_char(dt_horario,'hh24:mi') between '00:00' and '01:59');
                    END IF;

            ELSIF (ie_tipo_lote = 'A')
                THEN
                    IF(ie_opcao = 'H') 
                        THEN
                            select distinct
                            to_char(dt_horario,'hh24:mi')
                                INTO DS_RETORNO
                            from tasy.prescr_mat_hor c,
                                 tasy.ap_lote a
                            where a.nr_lote_agrupamento = nr_seq_lote_p
                            and a.nr_sequencia = c.nr_seq_lote
                            and (cd_material = cd_material_p)
                            and (nr_seq_material = nr_seq_material_p)
                            and (to_char(dt_horario,'hh24:mi')  between '00:00' and '01:59');
                    ELSIF (ie_opcao = 'D')
                        THEN
                            select distinct
                            qt_dispensar_hor || cd_unidade_medida
                                INTO DS_RETORNO
                            from tasy.prescr_mat_hor c,
                                 tasy.ap_lote a
                            where a.nr_lote_agrupamento = nr_seq_lote_p
                            and a.nr_sequencia = c.nr_seq_lote
                            and (cd_material = cd_material_p)
                            and (nr_seq_material = nr_seq_material_p)
                            and (to_char(dt_horario,'hh24:mi')  between '00:00' and '01:59');
                    END IF;
            END IF;
    ELSIF(ie_posicao = 2)
        THEN
            IF (ie_tipo_lote = 'N')
                THEN
                    IF(ie_opcao = 'H') 
                        THEN
                            select distinct
                            to_char(dt_horario,'hh24:mi')
                                INTO DS_RETORNO
                            from tasy.prescr_mat_hor
                            where (nr_seq_lote = nr_seq_lote_p)
                            and (cd_material = cd_material_p)
                            and (nr_seq_material = nr_seq_material_p)
                            and (to_char(dt_horario,'hh24:mi') between '02:00' and '03:59');  
                    ELSIF (ie_opcao = 'D')
                        THEN
                            select distinct
                            qt_dispensar_hor || cd_unidade_medida
                                INTO DS_RETORNO
                            from tasy.prescr_mat_hor
                            where (nr_seq_lote = nr_seq_lote_p)
                            and (cd_material = cd_material_p)
                            and (nr_seq_material = nr_seq_material_p)
                            and (to_char(dt_horario,'hh24:mi') between '02:00' and '03:59');
                    END IF;
            ELSIF (ie_tipo_lote = 'A')
                THEN
                    IF(ie_opcao = 'H') 
                        THEN
                            select distinct
                            to_char(dt_horario,'hh24:mi')
                                INTO DS_RETORNO
                            from tasy.prescr_mat_hor c,
                                 tasy.ap_lote a
                            where a.nr_lote_agrupamento = nr_seq_lote_p
                            and a.nr_sequencia = c.nr_seq_lote
                            and (cd_material = cd_material_p)
                            and (nr_seq_material = nr_seq_material_p)
                            and (to_char(dt_horario,'hh24:mi')  between '02:00' and '03:59');
                    ELSIF (ie_opcao = 'D')
                        THEN
                            select distinct
                            qt_dispensar_hor || cd_unidade_medida
                                INTO DS_RETORNO
                            from tasy.prescr_mat_hor c,
                                 tasy.ap_lote a
                            where a.nr_lote_agrupamento = nr_seq_lote_p
                            and a.nr_sequencia = c.nr_seq_lote
                            and (cd_material = cd_material_p)
                            and (nr_seq_material = nr_seq_material_p)
                            and (to_char(dt_horario,'hh24:mi')  between '02:00' and '03:59');
                    END IF;
            END IF;
    ELSIF(ie_posicao = 3)
        THEN
            IF (ie_tipo_lote = 'N')
                THEN
                    IF(ie_opcao = 'H') 
                        THEN
                            select distinct
                            to_char(dt_horario,'hh24:mi')
                                INTO DS_RETORNO
                            from tasy.prescr_mat_hor
                            where (nr_seq_lote = nr_seq_lote_p)
                            and (cd_material = cd_material_p)
                            and (nr_seq_material = nr_seq_material_p)
                            and (to_char(dt_horario,'hh24:mi') between '04:00' and '05:59');  
                    ELSIF (ie_opcao = 'D')
                        THEN
                            select distinct
                            qt_dispensar_hor || cd_unidade_medida
                                INTO DS_RETORNO
                            from tasy.prescr_mat_hor
                            where (nr_seq_lote = nr_seq_lote_p)
                            and (cd_material = cd_material_p)
                            and (nr_seq_material = nr_seq_material_p)
                            and (to_char(dt_horario,'hh24:mi') between '04:00' and '05:59');
                    END IF;
            ELSIF (ie_tipo_lote = 'A')
                THEN
                    IF(ie_opcao = 'H') 
                        THEN
                            select distinct
                            to_char(dt_horario,'hh24:mi')
                                INTO DS_RETORNO
                            from tasy.prescr_mat_hor c,
                                 tasy.ap_lote a
                            where a.nr_lote_agrupamento = nr_seq_lote_p
                            and a.nr_sequencia = c.nr_seq_lote
                            and (cd_material = cd_material_p)
                            and (nr_seq_material = nr_seq_material_p)
                            and (to_char(dt_horario,'hh24:mi')  between '04:00' and '05:59');
                    ELSIF (ie_opcao = 'D')
                        THEN
                            select distinct
                            qt_dispensar_hor || cd_unidade_medida
                                INTO DS_RETORNO
                            from tasy.prescr_mat_hor c,
                                 tasy.ap_lote a
                            where a.nr_lote_agrupamento = nr_seq_lote_p
                            and a.nr_sequencia = c.nr_seq_lote
                            and (cd_material = cd_material_p)
                            and (nr_seq_material = nr_seq_material_p)
                            and (to_char(dt_horario,'hh24:mi') between '04:00' and '05:59');
                    END IF;
            END IF;
     ELSIF(ie_posicao = 4)
        THEN
            IF (ie_tipo_lote = 'N')
                THEN
                    IF(ie_opcao = 'H') 
                        THEN
                            select distinct
                            to_char(dt_horario,'hh24:mi')
                                INTO DS_RETORNO
                            from tasy.prescr_mat_hor
                            where (nr_seq_lote = nr_seq_lote_p)
                            and (cd_material = cd_material_p)
                            and (nr_seq_material = nr_seq_material_p)
                            and (to_char(dt_horario,'hh24:mi') between '06:00' and '07:59');  
                    ELSIF (ie_opcao = 'D')
                        THEN
                            select distinct
                            qt_dispensar_hor || cd_unidade_medida
                                INTO DS_RETORNO
                            from tasy.prescr_mat_hor
                            where (nr_seq_lote = nr_seq_lote_p)
                            and (cd_material = cd_material_p)
                            and (nr_seq_material = nr_seq_material_p)
                            and (to_char(dt_horario,'hh24:mi') between '06:00' and '07:59');
                    END IF;
            ELSIF (ie_tipo_lote = 'A')
                THEN
                    IF(ie_opcao = 'H') 
                        THEN
                            select distinct
                            to_char(dt_horario,'hh24:mi')
                                INTO DS_RETORNO
                            from tasy.prescr_mat_hor c,
                                 tasy.ap_lote a
                            where a.nr_lote_agrupamento = nr_seq_lote_p
                            and a.nr_sequencia = c.nr_seq_lote
                            and (cd_material = cd_material_p)
                            and (nr_seq_material = nr_seq_material_p)
                            and (to_char(dt_horario,'hh24:mi')  between '06:00' and '07:59');
                    ELSIF (ie_opcao = 'D')
                        THEN
                            select distinct
                            qt_dispensar_hor || cd_unidade_medida
                                INTO DS_RETORNO
                            from tasy.prescr_mat_hor c,
                                 tasy.ap_lote a
                            where a.nr_lote_agrupamento = nr_seq_lote_p
                            and a.nr_sequencia = c.nr_seq_lote
                            and (cd_material = cd_material_p)
                            and (nr_seq_material = nr_seq_material_p)
                            and (to_char(dt_horario,'hh24:mi') between '06:00' and '07:59');
                    END IF;
            END IF;
    ELSIF(ie_posicao = 5)
        THEN
            IF (ie_tipo_lote = 'N')
                THEN
                    IF(ie_opcao = 'H') 
                        THEN
                            select distinct
                            to_char(dt_horario,'hh24:mi')
                                INTO DS_RETORNO
                            from tasy.prescr_mat_hor
                            where (nr_seq_lote = nr_seq_lote_p)
                            and (cd_material = cd_material_p)
                            and (nr_seq_material = nr_seq_material_p)
                            and (to_char(dt_horario,'hh24:mi') between '08:00' and '09:59');  
                    ELSIF (ie_opcao = 'D')
                        THEN
                            select distinct
                            qt_dispensar_hor || cd_unidade_medida
                                INTO DS_RETORNO
                            from tasy.prescr_mat_hor
                            where (nr_seq_lote = nr_seq_lote_p)
                            and (cd_material = cd_material_p)
                            and (nr_seq_material = nr_seq_material_p)
                            and (to_char(dt_horario,'hh24:mi') between '08:00' and '09:59');
                    END IF;
            ELSIF (ie_tipo_lote = 'A')
                THEN
                    IF(ie_opcao = 'H') 
                        THEN
                            select distinct
                            to_char(dt_horario,'hh24:mi')
                                INTO DS_RETORNO
                            from tasy.prescr_mat_hor c,
                                 tasy.ap_lote a
                            where a.nr_lote_agrupamento = nr_seq_lote_p
                            and a.nr_sequencia = c.nr_seq_lote
                            and (cd_material = cd_material_p)
                            and (nr_seq_material = nr_seq_material_p)
                            and (to_char(dt_horario,'hh24:mi')  between '08:00' and '09:59');
                    ELSIF (ie_opcao = 'D')
                        THEN
                            select distinct
                            qt_dispensar_hor || cd_unidade_medida
                                INTO DS_RETORNO
                            from tasy.prescr_mat_hor c,
                                 tasy.ap_lote a
                            where a.nr_lote_agrupamento = nr_seq_lote_p
                            and a.nr_sequencia = c.nr_seq_lote
                            and (cd_material = cd_material_p)
                            and (nr_seq_material = nr_seq_material_p)
                            and (to_char(dt_horario,'hh24:mi') between '08:00' and '09:59');
                    END IF;
            END IF;
    ELSIF(ie_posicao = 6)
        THEN
            IF (ie_tipo_lote = 'N')
                THEN
                    IF(ie_opcao = 'H') 
                        THEN
                            select distinct
                            to_char(dt_horario,'hh24:mi')
                                INTO DS_RETORNO
                            from tasy.prescr_mat_hor
                            where (nr_seq_lote = nr_seq_lote_p)
                            and (cd_material = cd_material_p)
                            and (nr_seq_material = nr_seq_material_p)
                            and (to_char(dt_horario,'hh24:mi') between '10:00' and '11:59');  
                    ELSIF (ie_opcao = 'D')
                        THEN
                            select distinct
                            qt_dispensar_hor || cd_unidade_medida
                                INTO DS_RETORNO
                            from tasy.prescr_mat_hor
                            where (nr_seq_lote = nr_seq_lote_p)
                            and (cd_material = cd_material_p)
                            and (nr_seq_material = nr_seq_material_p)
                            and (to_char(dt_horario,'hh24:mi') between '10:00' and '11:59');
                    END IF;

            ELSIF (ie_tipo_lote = 'A')
                THEN
                    IF(ie_opcao = 'H') 
                        THEN
                            select distinct
                            to_char(dt_horario,'hh24:mi')
                                INTO DS_RETORNO
                            from tasy.prescr_mat_hor c,
                                 tasy.ap_lote a
                            where a.nr_lote_agrupamento = nr_seq_lote_p
                            and a.nr_sequencia = c.nr_seq_lote
                            and (cd_material = cd_material_p)
                            and (nr_seq_material = nr_seq_material_p)
                            and (to_char(dt_horario,'hh24:mi')  between  '10:00' and '11:59');
                    ELSIF (ie_opcao = 'D')
                        THEN
                            select distinct
                            qt_dispensar_hor || cd_unidade_medida
                                INTO DS_RETORNO
                            from tasy.prescr_mat_hor c,
                                 tasy.ap_lote a
                            where a.nr_lote_agrupamento = nr_seq_lote_p
                            and a.nr_sequencia = c.nr_seq_lote
                            and (cd_material = cd_material_p)
                            and (nr_seq_material = nr_seq_material_p)
                            and (to_char(dt_horario,'hh24:mi') between  '10:00' and '11:59');
                    END IF;
            END IF;
    ELSIF(ie_posicao = 7)
        THEN
            IF (ie_tipo_lote = 'N')
                THEN
                    IF(ie_opcao = 'H') 
                        THEN
                            select distinct
                            to_char(dt_horario,'hh24:mi')
                                INTO DS_RETORNO
                            from tasy.prescr_mat_hor
                            where (nr_seq_lote = nr_seq_lote_p)
                            and (cd_material = cd_material_p)
                            and (nr_seq_material = nr_seq_material_p)
                            and (to_char(dt_horario,'hh24:mi') between '12:00' and '13:59');  
                    ELSIF (ie_opcao = 'D')
                        THEN
                            select distinct
                            qt_dispensar_hor || cd_unidade_medida
                                INTO DS_RETORNO
                            from tasy.prescr_mat_hor
                            where (nr_seq_lote = nr_seq_lote_p)
                            and (cd_material = cd_material_p)
                            and (nr_seq_material = nr_seq_material_p)
                            and (to_char(dt_horario,'hh24:mi') between '12:00' and '13:59');
                    END IF;

            ELSIF (ie_tipo_lote = 'A')
                THEN
                    IF(ie_opcao = 'H') 
                        THEN
                            select distinct
                            to_char(dt_horario,'hh24:mi')
                                INTO DS_RETORNO
                            from tasy.prescr_mat_hor c,
                                 tasy.ap_lote a
                            where a.nr_lote_agrupamento = nr_seq_lote_p
                            and a.nr_sequencia = c.nr_seq_lote
                            and (cd_material = cd_material_p)
                            and (nr_seq_material = nr_seq_material_p)
                            and (to_char(dt_horario,'hh24:mi')  between  '12:00' and '13:59');
                    ELSIF (ie_opcao = 'D')
                        THEN
                            select distinct
                            qt_dispensar_hor || cd_unidade_medida
                                INTO DS_RETORNO
                            from tasy.prescr_mat_hor c,
                                 tasy.ap_lote a
                            where a.nr_lote_agrupamento = nr_seq_lote_p
                            and a.nr_sequencia = c.nr_seq_lote
                            and (cd_material = cd_material_p)
                            and (nr_seq_material = nr_seq_material_p)
                            and (to_char(dt_horario,'hh24:mi') between  '12:00' and '13:59');
                    END IF;
            END IF;
    ELSIF(ie_posicao = 8)
        THEN
            IF (ie_tipo_lote = 'N')
                THEN
                    IF(ie_opcao = 'H') 
                        THEN
                            select distinct
                            to_char(dt_horario,'hh24:mi')
                                INTO DS_RETORNO
                            from tasy.prescr_mat_hor
                            where (nr_seq_lote = nr_seq_lote_p)
                            and (cd_material = cd_material_p)
                            and (nr_seq_material = nr_seq_material_p)
                            and (to_char(dt_horario,'hh24:mi') between '14:00' and '15:59');  
                    ELSIF (ie_opcao = 'D')
                        THEN
                            select distinct
                            qt_dispensar_hor || cd_unidade_medida
                                INTO DS_RETORNO
                            from tasy.prescr_mat_hor
                            where (nr_seq_lote = nr_seq_lote_p)
                            and (cd_material = cd_material_p)
                            and (nr_seq_material = nr_seq_material_p)
                            and (to_char(dt_horario,'hh24:mi') between '14:00' and '15:59');
                    END IF;

            ELSIF (ie_tipo_lote = 'A')
                THEN
                    IF(ie_opcao = 'H') 
                        THEN
                            select distinct
                            to_char(dt_horario,'hh24:mi')
                                INTO DS_RETORNO
                            from tasy.prescr_mat_hor c,
                                 tasy.ap_lote a
                            where a.nr_lote_agrupamento = nr_seq_lote_p
                            and a.nr_sequencia = c.nr_seq_lote
                            and (cd_material = cd_material_p)
                            and (nr_seq_material = nr_seq_material_p)
                            and (to_char(dt_horario,'hh24:mi')  between  '14:00' and '15:59');
                    ELSIF (ie_opcao = 'D')
                        THEN
                            select distinct
                            qt_dispensar_hor || cd_unidade_medida
                                INTO DS_RETORNO
                            from tasy.prescr_mat_hor c,
                                 tasy.ap_lote a
                            where a.nr_lote_agrupamento = nr_seq_lote_p
                            and a.nr_sequencia = c.nr_seq_lote
                            and (cd_material = cd_material_p)
                            and (nr_seq_material = nr_seq_material_p)
                            and (to_char(dt_horario,'hh24:mi') between  '14:00' and '15:59');
                    END IF;
            END IF;
    ELSIF(ie_posicao = 9)
        THEN
            IF (ie_tipo_lote = 'N')
                THEN
                    IF(ie_opcao = 'H') 
                        THEN
                            select distinct
                            to_char(dt_horario,'hh24:mi')
                                INTO DS_RETORNO
                            from tasy.prescr_mat_hor
                            where (nr_seq_lote = nr_seq_lote_p)
                            and (cd_material = cd_material_p)
                            and (nr_seq_material = nr_seq_material_p)
                            and (to_char(dt_horario,'hh24:mi') between '16:00' and '17:59');  
                    ELSIF (ie_opcao = 'D')
                        THEN
                            select distinct
                            qt_dispensar_hor || cd_unidade_medida
                                INTO DS_RETORNO
                            from tasy.prescr_mat_hor
                            where (nr_seq_lote = nr_seq_lote_p)
                            and (cd_material = cd_material_p)
                            and (nr_seq_material = nr_seq_material_p)
                            and (to_char(dt_horario,'hh24:mi') between '16:00' and '17:59');
                    END IF;

            ELSIF (ie_tipo_lote = 'A')
                THEN
                    IF(ie_opcao = 'H') 
                        THEN
                            select distinct
                            to_char(dt_horario,'hh24:mi')
                                INTO DS_RETORNO
                            from tasy.prescr_mat_hor c,
                                 tasy.ap_lote a
                            where a.nr_lote_agrupamento = nr_seq_lote_p
                            and a.nr_sequencia = c.nr_seq_lote
                            and (cd_material = cd_material_p)
                            and (nr_seq_material = nr_seq_material_p)
                            and (to_char(dt_horario,'hh24:mi')  between  '16:00' and '17:59');
                    ELSIF (ie_opcao = 'D')
                        THEN
                            select distinct
                            qt_dispensar_hor || cd_unidade_medida
                                INTO DS_RETORNO
                            from tasy.prescr_mat_hor c,
                                 tasy.ap_lote a
                            where a.nr_lote_agrupamento = nr_seq_lote_p
                            and a.nr_sequencia = c.nr_seq_lote
                            and (cd_material = cd_material_p)
                            and (nr_seq_material = nr_seq_material_p)
                            and (to_char(dt_horario,'hh24:mi') between  '16:00' and '17:59');
                    END IF;
            END IF;
    ELSIF(ie_posicao = 10)
        THEN
            IF (ie_tipo_lote = 'N')
                THEN
                    IF(ie_opcao = 'H') 
                        THEN
                            select distinct
                            to_char(dt_horario,'hh24:mi')
                                INTO DS_RETORNO
                            from tasy.prescr_mat_hor
                            where (nr_seq_lote = nr_seq_lote_p)
                            and (cd_material = cd_material_p)
                            and (nr_seq_material = nr_seq_material_p)
                            and (to_char(dt_horario,'hh24:mi') between '18:00' and '19:59');  
                    ELSIF (ie_opcao = 'D')
                        THEN
                            select distinct
                            qt_dispensar_hor || cd_unidade_medida
                                INTO DS_RETORNO
                            from tasy.prescr_mat_hor
                            where (nr_seq_lote = nr_seq_lote_p)
                            and (cd_material = cd_material_p)
                            and (nr_seq_material = nr_seq_material_p)
                            and (to_char(dt_horario,'hh24:mi') between '18:00' and '19:59');
                    END IF;

            ELSIF (ie_tipo_lote = 'A')
                THEN
                    IF(ie_opcao = 'H') 
                        THEN
                            select distinct
                            to_char(dt_horario,'hh24:mi')
                                INTO DS_RETORNO
                            from tasy.prescr_mat_hor c,
                                 tasy.ap_lote a
                            where a.nr_lote_agrupamento = nr_seq_lote_p
                            and a.nr_sequencia = c.nr_seq_lote
                            and (cd_material = cd_material_p)
                            and (nr_seq_material = nr_seq_material_p)
                            and (to_char(dt_horario,'hh24:mi')  between  '18:00' and '19:59');
                    ELSIF (ie_opcao = 'D')
                        THEN
                            select distinct
                            qt_dispensar_hor || cd_unidade_medida
                                INTO DS_RETORNO
                            from tasy.prescr_mat_hor c,
                                 tasy.ap_lote a
                            where a.nr_lote_agrupamento = nr_seq_lote_p
                            and a.nr_sequencia = c.nr_seq_lote
                            and (cd_material = cd_material_p)
                            and (nr_seq_material = nr_seq_material_p)
                            and (to_char(dt_horario,'hh24:mi') between  '18:00' and '19:59');
                    END IF;
            END IF;
    ELSIF(ie_posicao = 11)
        THEN
            IF (ie_tipo_lote = 'N')
                THEN
                    IF(ie_opcao = 'H') 
                        THEN
                            select distinct
                            to_char(dt_horario,'hh24:mi')
                                INTO DS_RETORNO
                            from tasy.prescr_mat_hor
                            where (nr_seq_lote = nr_seq_lote_p)
                            and (cd_material = cd_material_p)
                            and (nr_seq_material = nr_seq_material_p)
                            and (to_char(dt_horario,'hh24:mi') between '20:00' and '21:59');  
                    ELSIF (ie_opcao = 'D')
                        THEN
                            select distinct
                            qt_dispensar_hor || cd_unidade_medida
                                INTO DS_RETORNO
                            from tasy.prescr_mat_hor
                            where (nr_seq_lote = nr_seq_lote_p)
                            and (cd_material = cd_material_p)
                            and (nr_seq_material = nr_seq_material_p)
                            and (to_char(dt_horario,'hh24:mi') between '20:00' and '21:59');
                    END IF;

            ELSIF (ie_tipo_lote = 'A')
                THEN
                    IF(ie_opcao = 'H') 
                        THEN
                            select distinct
                            to_char(dt_horario,'hh24:mi')
                                INTO DS_RETORNO
                            from tasy.prescr_mat_hor c,
                                 tasy.ap_lote a
                            where a.nr_lote_agrupamento = nr_seq_lote_p
                            and a.nr_sequencia = c.nr_seq_lote
                            and (cd_material = cd_material_p)
                            and (nr_seq_material = nr_seq_material_p)
                            and (to_char(dt_horario,'hh24:mi')  between  '20:00' and '21:59');
                    ELSIF (ie_opcao = 'D')
                        THEN
                            select distinct
                            qt_dispensar_hor || cd_unidade_medida
                                INTO DS_RETORNO
                            from tasy.prescr_mat_hor c,
                                 tasy.ap_lote a
                            where a.nr_lote_agrupamento = nr_seq_lote_p
                            and a.nr_sequencia = c.nr_seq_lote
                            and (cd_material = cd_material_p)
                            and (nr_seq_material = nr_seq_material_p)
                            and (to_char(dt_horario,'hh24:mi') between  '20:00' and '21:59');
                    END IF;
            END IF;
    ELSIF(ie_posicao = 12)
        THEN
            IF (ie_tipo_lote = 'N')
                THEN
                    IF(ie_opcao = 'H') 
                        THEN
                            select distinct
                            to_char(dt_horario,'hh24:mi')
                                INTO DS_RETORNO
                            from tasy.prescr_mat_hor
                            where (nr_seq_lote = nr_seq_lote_p)
                            and (cd_material = cd_material_p)
                            and (nr_seq_material = nr_seq_material_p)
                            and (to_char(dt_horario,'hh24:mi') between '20:00' and '21:59');  
                    ELSIF (ie_opcao = 'D')
                        THEN
                            select distinct
                            qt_dispensar_hor || cd_unidade_medida
                                INTO DS_RETORNO
                            from tasy.prescr_mat_hor
                            where (nr_seq_lote = nr_seq_lote_p)
                            and (cd_material = cd_material_p)
                            and (nr_seq_material = nr_seq_material_p)
                            and (to_char(dt_horario,'hh24:mi') between '20:00' and '21:59');
                    END IF;

            ELSIF (ie_tipo_lote = 'A')
                THEN
                    IF(ie_opcao = 'H') 
                        THEN
                            select distinct
                            to_char(dt_horario,'hh24:mi')
                                INTO DS_RETORNO
                            from tasy.prescr_mat_hor c,
                                 tasy.ap_lote a
                            where a.nr_lote_agrupamento = nr_seq_lote_p
                            and a.nr_sequencia = c.nr_seq_lote
                            and (cd_material = cd_material_p)
                            and (nr_seq_material = nr_seq_material_p)
                            and (to_char(dt_horario,'hh24:mi')  between  '22:00' and '23:59');
                    ELSIF (ie_opcao = 'D')
                        THEN
                            select distinct
                            qt_dispensar_hor || cd_unidade_medida
                                INTO DS_RETORNO
                            from tasy.prescr_mat_hor c,
                                 tasy.ap_lote a
                            where a.nr_lote_agrupamento = nr_seq_lote_p
                            and a.nr_sequencia = c.nr_seq_lote
                            and (cd_material = cd_material_p)
                            and (nr_seq_material = nr_seq_material_p)
                            and (to_char(dt_horario,'hh24:mi') between  '22:00' and '23:59');
                    END IF;
            END IF;
    END IF;

    RETURN DS_RETORNO;

END HCD_OBTER_DADOS_LOTE;