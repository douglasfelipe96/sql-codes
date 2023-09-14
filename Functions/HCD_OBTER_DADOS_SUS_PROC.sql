CREATE OR REPLACE FUNCTION HCD_OBTER_DADOS_SUS_PROC (cd_procedimento_p number, ie_origem_proced_p number, ie_opcao number)
RETURN NUMBER



/*<DS_SCRIPT>
 DESCRIÇÃO...: Function que retorna os dados do procedimento SUS como Grupo, Subgrupo e Forma de Organização
 RESPONSAVEL.: DOUGLAS FELIPE (douglas.felipe)
 DATA........: 05/05/2023
 APLICAÇÃO...: TASY
 ATUALIZAÇÃO...:
    -- EXEMPLO:Atualizado em 07/01/22 por Douglas F: Adicionado filtro para buscar o bloqueio também pelo horário caso informado
 OBSERVAÇÕES...:  
     IE_OPCAO 
        -- 1 = Grupo
        -- 2 = Subgrupo
        -- 3 = Forma Organização

</DS_SCRIPT>*/

IS

ds_retorno number;

BEGIN

IF(ie_opcao = 1) THEN
    
    select	
        a.cd_grupo
        INTO ds_retorno
    from	sus_estrutura_procedimento_v a
    where	a.cd_procedimento	= cd_procedimento_p
    and	a.ie_origem_proced	= ie_origem_proced_p;
ELSIF(ie_opcao = 2) THEN
    select	
        a.cd_subgrupo
        INTO ds_retorno
    from	sus_estrutura_procedimento_v a
    where	a.cd_procedimento	= cd_procedimento_p
    and	a.ie_origem_proced	= ie_origem_proced_p;
ELSIF(ie_opcao = 3) THEN
    select	
        a.cd_forma_organizacao
        INTO ds_retorno
    from	sus_estrutura_procedimento_v a
    where	a.cd_procedimento	= cd_procedimento_p
    and	a.ie_origem_proced	= ie_origem_proced_p;
END IF;

RETURN ds_retorno;

END HCD_OBTER_DADOS_SUS_PROC;