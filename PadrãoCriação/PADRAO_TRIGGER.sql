CREATE OR REPLACE TRIGGER HCD_NOME_DA_FUNÇÃO ('PARÂMETROS')
BEFORE/AFTER SELECT/UPDATE/DELETE ON NOME_DA_TABELA
FOR EACH ROW;

/*<DS_SCRIPT>
 DESCRIÇÃO...: Function que retorna os horários dos itens do lote da prescrição
 RESPONSAVEL.: DOUGLAS FELIPE (douglas.felipe)
 DATA........: 09/11/2022
 APLICAÇÃO...: TASY
 ATUALIZAÇÃO...:
    -- EXEMPLO:Atualizado em 07/01/22 por Douglas F: Adicionado filtro para buscar o bloqueio também pelo horário caso informado
 OBSERVAÇÕES...:  
    -- Douglas F: Parâmetro NR_SEQ_SUPERIOR_P utilizado apenas para os componentes dos médicamentos, sendo assim para o medicamento principal não necessita a passagem do mesmo.
    -- Douglas F: Parâmetro IE_OPCAO_P pode ser 'A' - Agrupados ou 'N' - Normal.
</DS_SCRIPT>*/

DECLARE


BEGIN





END HCD_NOME_DA_FUNÇÃO;