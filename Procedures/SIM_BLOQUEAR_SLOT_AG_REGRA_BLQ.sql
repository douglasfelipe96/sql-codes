create or replace PROCEDURE      SIM_BLOQUEAR_SLOT_AG_REGRA_BLQ
IS

/*<DS_SCRIPT>
 DESCRIÇÃO...: PROCEDURE QUE REALIZA O BLOQUEIO DE UM SLOT QUE CONSTA COMO LIVRE MESMO ESTANDO COM REGRA DE BLOQUEIO PARA AQUELE DIA NA AGENDA
 RESPONSAVEL.: DOUGLAS FELIPE (douglas.fs)
 DATA........: 04/01/2022
 APLICAÇÃO...: TASY
 ATUALIZAÇÃO...:
    -- Atualizado em 07/01/22 por Douglas F: Adicionado filtro para buscar o bloqueio também pelo horário caso informado
    -- Atualizado em 22/01/22 por Douglas F: Incluido insert em tabela de log
    -- Atualizado em 22/01/22 por Douglas F: Adicionado filtro para não buscar as especialidades Online
    -- Atualizado em 31/01/22 por Douglas F: Adicionado o filtro no Cursor C01 para não buscar do estabelecimento (22 - Fátima)
</DS_SCRIPT>
<USUARIO=TASY>*/

    CURSOR C01 IS
        SELECT
            c.cd_estabelecimento,
            TASY.OBTER_NOME_ESTABELECIMENTO(c.CD_ESTABELECIMENTO)ds_estab,
            c.CD_PESSOA_FISICA cd_medico, 
            TASY.OBTER_NOME_PF(c.CD_PESSOA_FISICA) nm_medico,
            c.cd_especialidade,
            TASY.OBTER_DESC_MED_ESPECIALIDADE(c.cd_especialidade) ds_especialidade,
            a.cd_agenda, 
            a.dt_inicial,
            b.NR_SEQUENCIA nr_seq_slot,
            b.ie_status_agenda,
            tasy.OBTER_VALOR_DOMINIO(83,b.IE_STATUS_AGENDA) ds_status_atual, 
            TO_CHAR(b.DT_AGENDA, 'HH24:MI')hr_slot
        FROM TASY.AGENDA_BLOQUEIO a INNER JOIN TASY.AGENDA_CONSULTA b on (b.cd_agenda = a.cd_agenda and TRUNC(b.dt_agenda) = TRUNC(a.dt_inicial))
                                    INNER JOIN TASY.AGENDA c ON (c.cd_agenda = b.cd_agenda)
        WHERE 
            TRUNC(a.DT_INICIAL) >= TRUNC(SYSDATE)
            AND b.cd_pessoa_fisica is null
            AND b.ie_status_agenda in ('L')
            AND UPPER(TASY.OBTER_DESC_MED_ESPECIALIDADE(c.cd_especialidade)) NOT LIKE ('%ONLINE%')
            AND (TO_CHAR(b.DT_AGENDA, 'HH24:MI') between TO_CHAR(a.HR_INICIO_BLOQUEIO, 'HH24:MI') and TO_CHAR(a.HR_FINAL_BLOQUEIO, 'HH24:MI')
            OR TO_CHAR(a.HR_INICIO_BLOQUEIO, 'HH24:MI') IS NULL) 
            AND c.cd_estabelecimento not in (22)
        ORDER BY a.DT_INICIAL, c.cd_estabelecimento, a.cd_agenda;


VET01 C01%ROWTYPE;


BEGIN
    OPEN C01;
    LOOP 
      FETCH C01 INTO VET01;
    EXIT WHEN C01 %NOTFOUND;
        BEGIN
            ALTERAR_STATUS_AGENDA_CONS(VET01.cd_estabelecimento,VET01.cd_agenda,VET01.nr_seq_slot,'B','34','Agenda com Regra de Bloqueio', 'N', 'TASY',0);
            
            INSERT INTO SIM_LOG_BLOQUEIO_SLOT
                    VALUES (SIM_LOG_BLOQUEIO_SLOT_SEQ.NEXTVAL,
                            VET01.cd_estabelecimento,
                            VET01.ds_estab,
                            VET01.cd_medico,
                            VET01.nm_medico,
                            VET01.cd_especialidade,
                            VET01.ds_especialidade,
                            VET01.cd_agenda,
                            VET01.dt_inicial,
                            VET01.hr_slot,
                            VET01.nr_seq_slot);
        END;
    END LOOP;
CLOSE C01;
COMMIT;
END SIM_BLOQUEAR_SLOT_AG_REGRA_BLQ;