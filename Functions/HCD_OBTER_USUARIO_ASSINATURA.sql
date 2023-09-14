create or replace function HCD_OBTER_USUARIO_ASSINATURA( nr_seq_assinatura_p number)
                return  varchar2 is
                
                
/*<DS_SCRIPT>
 DESCRIÇÃO...: Function que retorna o usuário que realizou a assinatura digital
 RESPONSAVEL.: DOUGLAS FELIPE (douglas.felipe)
 DATA........: 25/05/2023
 APLICAÇÃO...: TASY
 ATUALIZAÇÃO...:
    -- EXEMPLO:Atualizado em 07/01/22 por Douglas F: Adicionado filtro para buscar o bloqueio também pelo horário caso informado
 OBSERVAÇÕES...:  
   EXEMPLO: -- Douglas F: Parâmetro IE_OPCAO_P pode ser 'A' - Agrupados ou 'N' - Normal.
</DS_SCRIPT>*/
                
                

ds_texto_w varchar2(255);
begin
ds_texto_w := '';
if (nr_seq_assinatura_p is not null ) then
    select  nvl(max(nm_usuario_nrec),'')
    into    ds_texto_w
    from    tasy_assinatura_digital
    where   nr_sequencia = nr_seq_assinatura_p
    and ds_hash_assinatura is not null;
end if;

return ds_texto_w;

end HCD_OBTER_USUARIO_ASSINATURA;