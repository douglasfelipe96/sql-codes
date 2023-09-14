create or replace procedure HCD_MAN_DEFINIR_USUARIO_EXEC(
				nr_seq_ordem_p		number,
				nm_usuario_exec_p		varchar2,
				nm_usuario_p		varchar2,
				cd_estabelecimento_p	number) is
                
                
/*<DS_SCRIPT>
 DESCRIÇÃO...: PROCEDURE QUE REALIZA A DEFINIÇÃO DO EXECUTOR DA OS, PROCEDURE CÓPIA DA PROCEDURE MAN_DEFINIR_USUARIO_EXECUTOR COM ALTERAÇÕES FEITA NA DATA
 RESPONSAVEL.: DOUGLAS FELIPE
 DATA........: 05/10/2022
 APLICAÇÃO...: TASY
 ATUALIZAÇÃO...:
    -- Atualizado em 05/10/22 por Douglas F: Comentado a procedure man_gerar_envio_comunicacao
</DS_SCRIPT>*/

ie_exige_causa_dano_tipo_w		varchar2(255);
nr_seq_estagio_apos_def_exec_w	varchar2(255);
nr_seq_causa_dano_w		man_ordem_servico.nr_seq_causa_dano%type;
nr_seq_tipo_solucao_w		man_ordem_servico.nr_seq_tipo_solucao%type;

begin

obter_param_usuario(299, 453, obter_perfil_Ativo, nm_usuario_p, cd_estabelecimento_p, ie_exige_causa_dano_tipo_w);
obter_param_usuario(299, 309, obter_perfil_Ativo, nm_usuario_p, cd_estabelecimento_p, nr_seq_estagio_apos_def_exec_w);

select	nvl(max(nr_seq_causa_dano),0),
	nvl(max(nr_seq_tipo_solucao),0)
into	nr_seq_causa_dano_w,
	nr_seq_tipo_solucao_w
from	man_ordem_servico
where	nr_sequencia = nr_seq_ordem_p;

if	(ie_exige_causa_dano_tipo_w <> 'N') then
	begin

	if	(ie_exige_causa_dano_tipo_w = 'A') and
		((nr_seq_causa_dano_w = 0) or (nr_seq_tipo_solucao_w = 0)) then
		begin
		wheb_mensagem_pck.exibir_mensagem_abort(269776);
		end;
	elsif	(ie_exige_causa_dano_tipo_w = 'C') and
		(nr_seq_causa_dano_w = 0) then
		begin
		wheb_mensagem_pck.exibir_mensagem_abort(269778);
		end;
	elsif	(ie_exige_causa_dano_tipo_w = 'T') and
		(nr_seq_tipo_solucao_w = 0)then
		begin
		wheb_mensagem_pck.exibir_mensagem_abort(269779);
		end;
	end if;

	end;
end if;

update	man_ordem_servico
set	nm_usuario_exec	= nm_usuario_exec_p,
	dt_atualizacao	= sysdate,
	nm_usuario	= nm_usuario_p
where	nr_sequencia	= nr_seq_ordem_p;

if	(nvl(nr_seq_estagio_apos_def_exec_w,'0') <> '0') then
	begin
	update	man_ordem_servico
	set	nr_seq_estagio	= nr_seq_estagio_apos_def_exec_w,
		dt_atualizacao	= sysdate,
		nm_usuario	= nm_usuario_p
	where	nr_sequencia	= nr_seq_ordem_p;
	end;
end if;

-- man_gerar_envio_comunicacao(nr_seq_ordem_p,'14','','',nm_usuario_p,'');

--commit;

end HCD_MAN_DEFINIR_USUARIO_EXEC;