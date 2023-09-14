create or replace procedure      gerar_ordem_compra_autor(nr_seq_autor_p		number,
				dt_entrega_p		date,
				cd_local_estoque_p	number,
				cd_estabelecimento_p	number,
				nm_usuario_p		varchar2,
				nr_ordem_compra_p	out number) is


nr_sequencia_w			number(10);
cd_comprador_w			varchar(10);
nr_ordem_compra_w		number(10);
cd_cgc_w			varchar2(14);
cd_cgc_ww			varchar2(14) := 'X';
nr_cot_compra_w			number(10);
nr_item_cot_compra_w		number(10);
cd_moeda_w			number(10);
vl_desconto_w			number(13,4);
pr_desconto_w			number(13,4);
ie_frete_w			varchar2(1);
cd_pessoa_solicitante_w		varchar2(10);
cd_local_entrega_w		number(10);
cd_condicao_pagamento_w		number(10);
nr_item_oci_w			number(5);
cd_conta_contabil_w		varchar2(20);
cd_centro_custo_w			number(10);
cd_material_w			number(6);
qt_material_w			number(13,4);
cd_unidade_medida_compra_w	varchar2(30);
vl_unitario_material_w		number(13,4);
vl_item_liquido_w			number(13,4) := 0;
nr_seq_marca_w			number(10);
nr_atendimento_w        number(10);


Cursor C01 is
select	b.cd_cgc,
	a.nr_cot_compra,
	a.nr_item_cot_compra,
	a.nr_sequencia,
	a.cd_material,
	substr(obter_dados_material(a.cd_material,'UMP'),1,30) cd_unidade_medida_compra,
	b.vl_unitario_cotado,
	a.qt_solicitada,	
	b.nr_seq_marca,
    OBTER_DADOS_AUTOR_CIRURGIA(a.nr_seq_autorizacao, 'AT')nr_atendimento
from	material_autor_cirurgia a,
	material_autor_cir_cot b
where	a.nr_sequencia = b.nr_sequencia
and	a.nr_seq_autorizacao =  nr_seq_autor_p
and	b.ie_aprovacao = 'S'
and	a.qt_solicitada > 0
and	a.nr_ordem_compra is null
order by	cd_cgc,cd_material;


begin

open C01;
loop
fetch C01 into	
	cd_cgc_w,
	nr_cot_compra_w,
	nr_item_cot_compra_w,
	nr_sequencia_w,
	cd_material_w,
	cd_unidade_medida_compra_w,
	vl_unitario_material_w,
	qt_material_w,
	nr_seq_marca_w,
    nr_atendimento_w;
exit when C01%notfound;
	begin

	if	(cd_cgc_w <> cd_cgc_ww) then
	
		select	cd_moeda_padrao,
			cd_condicao_pagamento_padrao,
			cd_comprador_padrao,
			cd_pessoa_solic_padrao
		into	cd_moeda_w,
			cd_condicao_pagamento_w,
			cd_comprador_w,
			cd_pessoa_solicitante_w
		from	parametro_compras
		where	cd_estabelecimento = cd_estabelecimento_p;
	
		if	(nr_cot_compra_w > 0) then
		
			select	nvl(max(b.cd_moeda),cd_moeda_w),
				nvl(max(b.cd_condicao_pagamento),cd_condicao_pagamento_w),
				nvl(max(b.vl_desconto),0),
				max(b.pr_desconto),
				max(b.ie_frete),
				nvl(max(a.cd_comprador), cd_comprador_w)
			into	cd_moeda_w,
				cd_condicao_pagamento_w,
				vl_desconto_w,
				pr_desconto_w,
				ie_frete_w,
				cd_comprador_w
			from	cot_compra a,
				cot_compra_forn b
			where	a.nr_cot_compra = b.nr_cot_compra
			and	b.cd_cgc_fornecedor = cd_cgc_w
			and	a.nr_cot_compra = nr_cot_compra_w;
		end if;
	
		if	(nvl(cd_moeda_w,0) = 0) then
			wheb_mensagem_pck.Exibir_Mensagem_Abort(260559);
		end if;
		
		if	(nvl(cd_condicao_pagamento_w,0) = 0) then
			wheb_mensagem_pck.Exibir_Mensagem_Abort(260558);
		end if;
		
		if	(nvl(cd_comprador_w,'0') = '0') then
			wheb_mensagem_pck.Exibir_Mensagem_Abort(260560);
		end if;
		
		if	(nvl(cd_pessoa_solicitante_w,'0') = '0') then
			wheb_mensagem_pck.Exibir_Mensagem_Abort(260564);
		end if;
		
	
		select	ordem_compra_seq.nextval
		into	nr_ordem_compra_w
		from	dual;

		insert into ordem_compra(
			nr_ordem_compra,
			cd_estabelecimento,
			cd_cgc_fornecedor,
			cd_condicao_pagamento,
			cd_comprador,
			dt_ordem_compra,
			dt_atualizacao,
			nm_usuario,
			cd_moeda,
			ie_situacao,
			dt_inclusao,
			cd_pessoa_solicitante,
			ie_frete,
			pr_desconto,
			cd_local_entrega,
			dt_entrega,
			ie_aviso_chegada,
			ie_emite_obs,
			ie_urgente,
			vl_desconto,
			ie_tipo_ordem,
			ds_observacao,
			nr_seq_autor_cir,
            nr_atendimento)
		values(	nr_ordem_compra_w,
			cd_estabelecimento_p,
			cd_cgc_w,
			cd_condicao_pagamento_w,
			/*cd_comprador_w*/ 1122787, -- ATT EM 14/06/2023: SUBSTITUÍDO O CAMPO PADRÃO PELO CÓDIGO DO COMPRADOR CENTRAL DE OPME
			sysdate,
			sysdate,
			nm_usuario_p,
			cd_moeda_w,
			'A',
			sysdate,
			/*cd_pessoa_solicitante_w*/ OBTER_CODIGO_USUARIO(NM_USUARIO_P), -- ATT EM 28/12/2022: SUBSTITUIDO O CAMPO cd_pessoa_solicitante_w PELO USUÁRIO QUE REALIZOU A EXECUÇÃO
			nvl(ie_frete_w,'C'),
			pr_desconto_w,
			cd_local_estoque_p,
			dt_entrega_p,
			'N',
			'N',
			'N',
			vl_desconto_w,
			'M',
			wheb_mensagem_pck.get_texto(301945,'NR_SEQ_AUTOR_P='||nr_seq_autor_p),
			nr_seq_autor_p,
            nr_atendimento_w);
		
		cd_cgc_ww := cd_cgc_w;
	end if;
	
	if	(nr_ordem_compra_w > 0) then
		
		vl_item_liquido_w	:= vl_unitario_material_w * qt_material_w;
		
		define_conta_material(cd_estabelecimento_p,
			cd_material_w,
			1,null, null, null, null, null, null, null,
			cd_local_estoque_p,
			null, sysdate,
			cd_conta_contabil_w,
			cd_centro_custo_w,
			null);
		
		select	nvl(max(nr_item_oci),0) + 1
		into	nr_item_oci_w
		from	ordem_compra_item
		where	nr_ordem_compra = nr_ordem_compra_w;
		
		insert into ordem_compra_item(
			nr_ordem_compra,
			nr_item_oci,
			cd_material,
			cd_unidade_medida_compra,
			vl_unitario_material,
			qt_material,
			qt_original,
			dt_atualizacao,
			nm_usuario,
			ie_situacao,
			cd_local_estoque,
			nr_cot_compra,
			nr_item_cot_compra,
			vl_item_liquido,
			cd_conta_contabil,
			nr_seq_marca,
			vl_total_item,
			cd_sequencia_parametro)
		values(	nr_ordem_compra_w,
			nr_item_oci_w,
			cd_material_w,
			cd_unidade_medida_compra_w,
			vl_unitario_material_w,
			qt_material_w,
			qt_material_w,
			sysdate,
			nm_usuario_p,
			'A',
			cd_local_estoque_p,
			nr_cot_compra_w,
			nr_item_cot_compra_w,
			vl_item_liquido_w,
			cd_conta_contabil_w,
			nr_seq_marca_w,
			round((qt_material_w * vl_unitario_material_w),4),
			philips_contabil_pck.get_parametro_conta_contabil);
			
		insert into ordem_compra_item_entrega(
			nr_sequencia,
			nr_ordem_compra,
			nr_item_oci,
			dt_prevista_entrega,
			qt_prevista_entrega,
			dt_atualizacao,
			nm_usuario)
		values(	ordem_compra_item_entrega_seq.nextval,
			nr_ordem_compra_w,
			nr_item_oci_w,
			dt_entrega_p,
			qt_material_w,
			sysdate,
			nm_usuario_p);
		
		update	material_autor_cirurgia
		set	nr_ordem_compra = nr_ordem_compra_w
		where	nr_sequencia = nr_sequencia_w;
	
	end if;	
	end;
	
end loop;
close C01;

if(nr_ordem_compra_w = 0) then
   wheb_mensagem_pck.Exibir_Mensagem_Abort(1109639);
end if;

commit;

nr_ordem_compra_p	:= nr_ordem_compra_w;

end gerar_ordem_compra_autor;