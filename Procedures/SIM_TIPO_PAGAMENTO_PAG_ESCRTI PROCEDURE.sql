create or replace PROCEDURE SIM_TIPO_PAGAMENTO_PAG_ESCRIT (NR_SEQUENCIA_P number,IE_OPCAO_P VARCHAR2)
IS

/*<DS_SCRIPT>
 DESCRIÇÃO...: PROCEDURE QUE ALTERA O TIPO DE PAGAMENTO DOS ITENS DE UM BORDERÔ DE UMA VEZ SÓ
 RESPONSAVEL.: DOUGLAS FELIPE (douglas.fs)
 DATA........: 29/11/2021
 APLICAÇÃO...: TASY
</DS_SCRIPT>
<USUARIO=TASY>*/


-- Tipo Pagamento --
--PC - Pagamento Concessionaria
--BLQ - Boleto Cobrança (Cód. de Barras)
--CC - Crédito em conta corrente
--CCP - Crédito em conta poupança
--CHQ - CHQ-CHEQUE
--CRT - Crédito em conta Real Time
--DDA - Rastreamento de títulos - DDA
--DOC - Documento de Ordem de Crédito
--OP - Ordem de Pagamento
--QRC - PIX - QR Code
--TED - TED-Transferência eletrônica disponível
--TPI - PIX - Transferência


BEGIN

 UPDATE TITULO_PAGAR_ESCRIT SET IE_TIPO_PAGAMENTO = UPPER(IE_OPCAO_P) WHERE NR_SEQ_ESCRIT = NR_SEQUENCIA_P;


END SIM_TIPO_PAGAMENTO_PAG_ESCRIT;