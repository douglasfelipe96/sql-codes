create or replace PROCEDURE AGINT_INSERT_LOG_REMARCA( CD_SLOT_ORIGEM_P IN NUMBER, CD_SLOT_DESTINO_P IN NUMBER, DS_OBSERVACAO_P IN VARCHAR2, IE_OPCAO_P IN VARCHAR2)
AS

/*<DS_SCRIPT>
DESCRICAO....: Realiza inserção de dados na tabela de log de remarcação da plataforma Agenda Integrada
RESPONSAVEL..: Douglas Felipe, Viviane Viana e Gabriel Facundo
DATA.........: 27/01/2022
APLICACAO....: Agenda Integrada
ALTERACOES...:
</DS_SCRIPT>*/


/* IE_OPCAO_P*/
-- C - Consulta
-- E - Exame

CURSOR C01 is 
        SELECT 
            B.CD_ESPECIALIDADE,
            B.cd_estabelecimento,
            A.CD_AGENDA,
            A.NR_SEQUENCIA,
            A.DT_AGENDA,
            A.NM_USUARIO_ORIGEM,
            A.ds_observacao
        FROM tasy.agenda_consulta A INNER JOIN tasy.agenda B ON (A.cd_agenda = B.cd_agenda) 
        WHERE A.nr_sequencia = CD_SLOT_ORIGEM_P
        AND UPPER(IE_OPCAO_P) = 'C'
    UNION ALL
        SELECT 
            A.NR_SEQ_PROC_INTERNO,
            B.CD_ESTABELECIMENTO,
            A.CD_AGENDA,
            A.NR_SEQUENCIA,
            A.DT_AGENDA,
            A.NM_USUARIO_ORIG,
            A.ds_observacao
        FROM tasy.agenda_paciente A INNER JOIN tasy.agenda B ON (A.cd_agenda = B.cd_agenda) 
        WHERE A.nr_sequencia = CD_SLOT_ORIGEM_P
        AND UPPER(IE_OPCAO_P) = 'E';

CURSOR C02 is  -- Busca os dados da agenda de destino
            SELECT 
                B.cd_estabelecimento,
                A.CD_AGENDA,
                A.NR_SEQUENCIA,
                A.DT_AGENDA,
                A.NM_USUARIO
            FROM tasy.agenda_consulta A INNER JOIN tasy.agenda B ON (A.cd_agenda = B.cd_agenda) 
            WHERE A.nr_sequencia = CD_SLOT_DESTINO_P
            AND UPPER(ie_opcao_p) = 'C'
    UNION ALL
            SELECT 
                B.cd_estabelecimento,
                A.CD_AGENDA,
                A.NR_SEQUENCIA,
                A.DT_AGENDA,
                A.NM_USUARIO
            FROM tasy.agenda_paciente A INNER JOIN tasy.agenda B ON (A.cd_agenda = B.cd_agenda) 
            WHERE A.nr_sequencia = CD_SLOT_DESTINO_P
            AND UPPER(ie_opcao_p) = 'E';

VET01 C01%ROWTYPE;
VET02 C02%ROWTYPE;

BEGIN
    OPEN C01;
    LOOP
        FETCH C01 INTO VET01;
    EXIT WHEN C01%NOTFOUND;
    END LOOP;
    CLOSE C01;

    OPEN C02;
    LOOP
        FETCH C02 INTO VET02;
        EXIT WHEN C02%NOTFOUND;
    END LOOP;
    CLOSE C02;

   INSERT INTO AGINT_LOG_REMARCA (
    nr_sequencia,
    cd_especialidade,
    CD_ESTAB_ORIGEM,
    CD_AGENDA_ORIGEM,
    CD_SLOT_AG_ORIGEM,
    DT_AGENDA_ORIGEM,
    NM_USUARIO_ORIGEM,
    DT_ATUALIZACAO,
    CD_ESTAB_DESTINO,
    CD_AGENDA_DESTINO,
    CD_SLOT_AG_DESTINO,
    DT_AGENDA_DESTINO,
    NM_USUARIO_DESTINO,
    DS_OBSERVACAO) 
    VALUES (
    AGINT_LOG_REMARCA_SEQ.NEXTVAL,
    VET01.CD_ESPECIALIDADE,
    VET01.CD_ESTABELECIMENTO,
    VET01.CD_AGENDA,
    VET01.NR_SEQUENCIA,
    VET01.DT_AGENDA,
    VET01.NM_USUARIO_ORIGEM,
    SYSDATE,
    VET02.CD_ESTABELECIMENTO,
    VET02.CD_AGENDA,
    VET02.NR_SEQUENCIA,
    VET02.DT_AGENDA,
    VET02.NM_USUARIO,
    DS_OBSERVACAO_P
);

END AGINT_INSERT_LOG_REMARCA;