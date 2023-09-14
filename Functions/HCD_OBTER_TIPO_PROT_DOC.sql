CREATE OR REPLACE FUNCTION HCD_OBTER_TIPO_PROT_DOC(nr_sequencia_p NUMBER) 
RETURN NUMBER IS

/*
DESCRIÇÃO...: FUNÇÃO QUE RETORNA O TIPO DO PROTOCOLO A PARTIR DO NÚMERO DO PROTOCOLO DOCUMENTO NA TABELA PROTOCOLO_DOC_ITEM
RESPONSAVEL.: WILLIAM DIAS (william.dias)
DATA........: 03/07/2023
APLICAÇÃO...: TASY
ATUALIZAÇÃO...:
*/

cd_tipo_prot_doc_w NUMBER;

BEGIN

IF(nvl(nr_sequencia_p, 0) > 0) THEN
    SELECT ie_tipo_protocolo
    INTO cd_tipo_prot_doc_w
    FROM protocolo_documento
    WHERE nr_sequencia = nr_sequencia_p;
END IF;

RETURN cd_tipo_prot_doc_w;

END HCD_OBTER_TIPO_PROT_DOC;