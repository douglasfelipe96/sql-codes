CREATE OR REPLACE FUNCTION TASY.HCD_OBTER_HR_PRIM_PRESCR_CORTE (DS_HORARIO_P VARCHAR2)
RETURN VARCHAR2
IS

/*<DS_SCRIPT>
 DESCRIÇÃO...: Function que retorna os horários de aprazamento conforme horário de corte PARA 1º PRESCRIÇÃO
 RESPONSAVEL.: DOUGLAS FELIPE (douglas.fs)
 DATA........: 26/09/2022
 APLICAÇÃO...: TASY (Prontuário Eletrônico do Paciente - PEP)
 ATUALIZAÇÃO...:
</DS_SCRIPT>*/


DS_HORARIO_W VARCHAR2(255) := DS_HORARIO_P ;
DS_RETORNO_W VARCHAR2(255);
QT_CONTADOR NUMBER(10,0) := 0;
QT_CONTADOR_2 NUMBER(10,0) := 0;
QT_INCREMENTADOR NUMBER(10,0) := 1;


BEGIN

-- Horários maiores que 07:00
WHILE (QT_CONTADOR <> 1 )
    LOOP  
        IF (to_date(TASY.sbsc_rel_apraz_obter_hor_pos(DS_HORARIO_W,QT_INCREMENTADOR), 'hh24:mi')> TO_DATE('07:00', 'HH24:MI') )
        
        THEN DS_RETORNO_W := DS_RETORNO_W || TASY.sbsc_rel_apraz_obter_hor_pos(DS_HORARIO_W,QT_INCREMENTADOR) || ' ';
        QT_INCREMENTADOR := QT_INCREMENTADOR + 1;
   
        ELSE QT_CONTADOR := 1;
        END IF;
        
        
    END LOOP;

-- Horários menores que 07:00
WHILE (QT_CONTADOR_2 <> 1 )
    LOOP  
        IF (to_date(TASY.sbsc_rel_apraz_obter_hor_pos(DS_HORARIO_W,QT_INCREMENTADOR), 'hh24:mi') < TO_DATE('07:00', 'HH24:MI') )
        
        THEN DS_RETORNO_W := DS_RETORNO_W || TASY.sbsc_rel_apraz_obter_hor_pos(DS_HORARIO_W,QT_INCREMENTADOR) || ' ';
        QT_INCREMENTADOR := QT_INCREMENTADOR + 1;
   
        ELSE QT_CONTADOR_2 := 1;
        END IF;
        
        
    END LOOP;

    DS_RETORNO_W := SUBSTR(DS_RETORNO_W,0,LENGTH(DS_RETORNO_W)-1);
    
RETURN DS_RETORNO_W;


END HCD_OBTER_HR_PRIM_PRESCR_CORTE;