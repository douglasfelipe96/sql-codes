create or replace procedure AGINT_REAGENDA_CONS	(cd_estabelecimento_p IN	number,
						nr_seq_origem_p IN	number,
						nr_seq_destino_p IN		number,
						ie_acao_p IN			varchar2,
						nr_seq_motivo_p IN		number,
						ds_motivo_p	IN          varchar2,
						nm_usuario_p IN			varchar2,
						nr_seq_atendimento_p IN	number,
						nr_seq_evento_atend_p IN number,
                        ds_observacao_p IN varchar2 default null,
						ds_retorno_p		out varchar2) AS
                        
/*<DS_SCRIPT>
DESCRICAO....: Realiza remarcação de consultas da plataforma Agenda Integrada
RESPONSAVEL..: Douglas Felipe, Viviane Viana e Gabriel Facundo
DATA.........: 27/01/2022
APLICACAO....: Agenda Integrada
ALTERACOES...:
</DS_SCRIPT>*/

/* variaveis registros */
cd_agenda_w                     	number(10);
cd_pessoa_fisica_w              	varchar2(10);
hr_inicio_w				date;
ie_forma_agendamento_w			number(3,0);
nr_minuto_duracao_w			number(10,0);
cd_medico_w                     	varchar2(10);
nm_pessoa_contato_w             	varchar2(50);
cd_procedimento_w               	number(15);
ds_observacao_w                 	varchar2(2000);
cd_convenio_w                   	number(5);
qt_idade_paciente_w             	number(3);
ie_origem_proced_w              	number(10);
ie_status_agenda_w              	varchar2(3);
ds_senha_w                      	varchar2(20);
nm_paciente_w                   	varchar2(80);
nr_atendimento_w                	number(10);
cd_usuario_convenio_w           	varchar2(30);
dt_agendamento_w			date;
nm_usuario_orig_w			varchar2(15);
qt_idade_mes_w                  	number(2);
cd_plano_w                      	varchar2(10);
nr_telefone_w                   	varchar2(80);
vl_previsto_w                   	number(15,2);
nr_seq_age_cons_w               	number(10);
cd_medico_exec_w                	varchar2(10);
nr_seq_classif_agenda_w         	number(10);
cd_procedencia_w                	number(5);
cd_categoria_w                  	varchar2(10);
cd_tipo_acomodacao_w            	number(4);
nr_doc_convenio_w               	varchar2(20);
dt_validade_carteira_w          	date;
nr_seq_proc_interno_w           	number(10);
nr_seq_status_pac_w             	number(10);
ie_lado_w                       	varchar2(1);
ds_laboratorio_w                	varchar2(80);
cd_doenca_cid_w                 	varchar2(10);
dt_nascimento_pac_w             	date;
nr_seq_sala_w                  		number(10);
ie_tipo_atendimento_w          		number(3);
cd_medico_req_w                 	varchar2(10);
cd_medico_req_ww                 	varchar2(10);
nr_seq_pq_proc_w                	number(10);
nr_seq_indicacao_w              	number(10);
cd_pessoa_indicacao_w           	varchar2(10);
nm_pessoa_indicacao_w			agenda_consulta.nm_pessoa_indicacao%type;
qt_prescricao_w				number(10);
nr_seq_proced_w				number(6,0);
ds_cirurgia_w				varchar2(500);
cd_setor_atendimento_w			number(5,0);
ie_status_paciente_w			varchar2(3);
ie_classif_agenda_w			varchar2(05);
ie_classif_proc_w			varchar2(5);
nr_seq_agenda_cons_proc_w		number(10,0);
nr_dente_w				number(5,0);
nr_seq_proc_odont_w			number(10,0);
nr_seq_agepaci_w			number(10,0);
qt_diaria_prev_w			number(3,0);
ie_classif_agenda_destino_w		varchar2(5);
nr_transacao_sus_w			varchar2(20);
nr_seq_segurado_w			number(10,0);
ie_situacao_atend_w			varchar2(1);
ie_utiliza_prof_horario_w		varchar2(1);
cd_setor_agenda_w			agenda.cd_setor_agenda%type; 	
nr_seq_tipo_midia_w			agenda_consulta.nr_seq_tipo_midia%type;

/* variaveis parametros */
ie_manut_proced_w			varchar2(1);
ie_duracao_copia_w			varchar2(1);
ie_duracao_transf_w			varchar2(1);
ie_user_orig_transf_w			varchar2(1);
ie_atend_copia_w			varchar2(1);
ie_atend_transf_w			varchar2(1);
ie_status_copia_w			varchar2(1);
ie_status_transf_w			varchar2(1);
ie_classif_orig_transf_w		varchar2(1);
ie_observacao_copia_w			varchar2(1);
ie_observacao_trans_w			varchar2(1);
nr_doc_convenio_copia_w			varchar2(1);
nr_doc_convenio_transf_w		varchar2(1);
ie_transacao_sus_copia_w		varchar2(1);
ie_transacao_sus_transf_w		varchar2(1);
ie_status_pac_transf_w			varchar2(1);
ie_status_pac_copia_w			varchar2(1);


/* variaveis complementares */
ie_manter_duracao_w			varchar2(1) := 'N';
ie_manter_usuario_w			varchar2(1) := 'N';
ie_manter_atend_w			varchar2(1) := 'S';
ie_manter_status_w			varchar2(1) := 'N';
cd_agenda_destino_w			number(10,0);
hr_destino_w				date;

/* variaveis historico */
atrib_oldvalue_w			varchar2(50);
atrib_newvalue_w			varchar2(50);

ds_erro_w				varchar2(255);
ie_consiste_sobreposicao_w		varchar2(1);
ie_executar_proc_w			varchar2(1);
nr_seq_forma_confirmacao_w		number(10);

dt_confirmacao_w			Date;
nm_usuario_confirm_w			Varchar2(15);

qt_same_pront_w				Number(5);
nr_sequencia_autor_w			number(10);
cd_conv_agenda_destino_w		number(5);
nr_seq_turno_w				number(10);
nr_seq_turno_esp_w			number(10);
ds_consistencia_w			varchar2(255);
qt_peso_w				number(6,3);
qt_altura_cm_w				number(5,2);
cd_empresa_ref_w			number(10,0);
ie_autorizacao_w			varchar2(3);
cd_especialidade_w			number(10,0);
crm_medico_externo_w			varchar2(60);
nm_medico_externo_w			varchar2(60);
nr_seq_motivo_agendamento_w		number(10,0);
cd_senha_w				varchar2(20);
ie_campo_peso_copia_w			varchar2(1);
ie_campo_peso_transf_w			varchar2(1);
ie_campo_altura_copia_w			varchar2(1);
ie_campo_altura_transf_w		varchar2(1);
ie_campo_empresa_copia_w		varchar2(1);
ie_campo_empresa_transf_w		varchar2(1);
ie_campo_autorizacao_copia_w		varchar2(1);
ie_campo_autorizacao_transf_w		varchar2(1);
ie_campo_especialidade_copia_w		varchar2(1);
ie_campo_especialidade_trans_w		varchar2(1);
ie_campo_crm_med_ext_copia_w		varchar2(1);
ie_campo_crm_med_ext_transf_w		varchar2(1);
ie_campo_nm_med_ext_copia_w		varchar2(1);
ie_campo_nm_med_ext_trans_w		varchar2(1);
ie_campo_mot_agend_copia_w		varchar2(1);
ie_campo_mot_agend_transf_w		varchar2(1);
ie_campo_senha_transf_w			varchar2(1);
ie_campo_senha_copia_w			varchar2(1);
ie_sala_transf_w			varchar2(1);
ie_sala_copia_w				varchar2(1);
nr_seq_item_ageint_w			number(10);
ie_canc_agenda_transf_w			Varchar2(1)	:= 'N';
ie_utiliza_agfa_w			varchar2(1);
nr_reserva_w				varchar2(20);
ie_reserva_transf_w			varchar2(1);
cd_estab_origem_w			number(4);
cd_estab_destino_w			number(4);
ie_modo_gerar_reserva_w			varchar2(1);
ie_historico_trans_w			varchar2(1);
ie_campo_classif_copia_w		varchar2(1);
ie_permite_agendamento_w		varchar2(1);

qt_integrada_w				number(10,0);
ds_abrev_origem_w 			varchar2(50);
ds_abrev_dest_w				varchar2(50);

nr_seq_vaga_w				number(10,0);

ie_estab_agenda_w			varchar2(1);
ie_status_aguardando_w			varchar2(1);
ie_alterar_vaga_w			varchar2(1);
cd_estab_gestao_w			number(4,0);
ie_solicitacao_w			varchar2(15);
ie_tipo_vaga_w				varchar2(15);
ie_status_gv_w				varchar2(1);
dt_prevista_w				date;
ds_setor_desejado_w			varchar2(255);
cd_unidade_basica_w			varchar2(10);
cd_unidade_compl_w			varchar2(10);
cd_tipo_acomod_desej_w			number(15,0);
ds_retorno_w				varchar2(255) := '';
ie_setor_transf_w			varchar2(1);
ie_setor_copia_w			varchar2(1);
ie_procedencia_copia_w			varchar2(1);
ie_procedencia_transf_w			varchar2(1);
ie_tipo_atend_copia_w			varchar2(1);
ie_tipo_atend_transf_w			varchar2(1);

qt_historico_w				number(10,0);
ie_perm_agendar_classif_w		varchar2(255);
ie_cons_regra_agenda_conv_w		varchar2(1);
ie_perm_transf_agend_exec_w		varchar2(1);
ie_reservado_w				varchar2(1);
nr_seq_agendamento_w			number(10);
ie_consiste_regra_conv_turno_w		varchar2(1);
ie_convenio_cancelamento_w		varchar2(1);
ie_consiste_mesmo_paciente_w		varchar2(1);
ie_consistencia_w			varchar2(255);
ie_agenda_w				varchar2(1);
ie_consiste_tempo_minimo_w		varchar2(1);
ie_med_req_copia_w		varchar2(1);
ie_med_req_transf_w		varchar2(1);
ie_conv_nao_lib_agenda_w	varchar2(1);

qt_solic_cip_w			number(10);
cd_estab_solic_cpi_w		number(4);
cd_setor_solic_cpi_w		number(10);
dt_validade_senha_w		date;
qt_hor_cancel_w				number(10);

ds_mensagem_w			varchar2(4000);
cd_medico_agenda_destino_w  	agenda.cd_pessoa_fisica%TYPE;
ds_erro_ww		        varchar2(255);
ds_email_w				varchar2(255);

/* cursores */
/* obter procedimentos adicionais */
cursor c01 is
select	cd_procedimento,
	ie_origem_proced,
	nr_seq_proc_interno,
	ie_executar_proc,
	a.nr_sequencia
from	agenda_consulta_proc a
where	nr_seq_agenda = nr_seq_origem_p
and not exists (select 1 from agenda_consulta_proc w 
		where a.nr_seq_proc_interno = w.nr_seq_proc_interno
		and w.nr_seq_agenda = nr_seq_destino_p)
order by
	nr_seq_agenda;


Cursor c02 is
select	nr_sequencia
from	autorizacao_convenio
where	nr_seq_agenda_consulta	= nr_seq_origem_p
and	(((ie_campo_autorizacao_copia_w = 'S') and (ie_acao_p = 'C')) or
	((ie_campo_autorizacao_transf_w = 'S') and (ie_acao_p = 'T')));


Cursor C03 is
	select	nr_dente
	from	agenda_cons_proc_odont a
	where	nr_seq_cons_proc = nr_seq_agenda_cons_proc_w;

begin
if	(cd_estabelecimento_p is not null) and
	(nr_seq_origem_p is not null) and
	(nr_seq_destino_p is not null) and
	(ie_acao_p is not null) and
	(nm_usuario_p is not null) then

	reservar_horario_agecons(nr_seq_destino_p,
				 nm_usuario_p,
				 ie_reservado_w);	

	if	(ie_reservado_w = 'N') then
		Wheb_mensagem_pck.exibir_mensagem_abort(262368);
	end if;

	/* obter parametros */

	obter_param_usuario(821, 70, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p,ie_manut_proced_w);

	Obter_Param_Usuario(866, 136, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento,ie_alterar_vaga_w);
	Obter_Param_Usuario(866, 137, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento,ie_estab_agenda_w);
	Obter_Param_Usuario(866, 138, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento,ie_status_aguardando_w);
	Obter_Param_Usuario(821, 294, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento,ie_cons_regra_agenda_conv_w);
	Obter_Param_Usuario(821, 315, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento,ie_perm_transf_agend_exec_w);
	Obter_Param_Usuario(821, 372, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento,ie_convenio_cancelamento_w);
	Obter_Param_Usuario(821, 488, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento,ie_consiste_tempo_minimo_w);
	Obter_Param_Usuario(821, 432, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento,ie_consiste_mesmo_paciente_w);

	Obter_Param_Usuario(869,31,obter_perfil_ativo,nm_usuario_p,cd_estabelecimento_p,ie_utiliza_agfa_w);

	select	obter_parametro_agenda(cd_estabelecimento_p, 'IE_DURACAO_COPIA', 'N')
	into	ie_duracao_copia_w
	from	dual;

	select	obter_parametro_agenda(cd_estabelecimento_p, 'IE_DURACAO_TRANSF', 'N')
	into	ie_duracao_transf_w
	from	dual;

	select	obter_parametro_agenda(cd_estabelecimento_p, 'IE_USUARIO_ORIG_TRANSF', 'N')
	into	ie_user_orig_transf_w
	from	dual;

	select	obter_parametro_agenda(cd_estabelecimento_p, 'IE_ATEND_COPIA', 'S')
	into	ie_atend_copia_w
	from	dual;

	select	obter_parametro_agenda(cd_estabelecimento_p, 'IE_ATEND_TRANSF', 'S')
	into	ie_atend_transf_w
	from	dual;

	select	obter_parametro_agenda(cd_estabelecimento_p, 'IE_STATUS_COPIA', 'N')
	into	ie_status_copia_w
	from	dual;

	select	obter_parametro_agenda(cd_estabelecimento_p, 'IE_STATUS_TRANSF', 'N')
	into	ie_status_transf_w
	from	dual;

	obter_param_usuario(821, 36, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p,ie_consiste_sobreposicao_w);

	select	obter_parametro_agenda(cd_estabelecimento_p, 'IE_CLASSIF_ORIG_TRANSF', 'N')
	into	ie_classif_orig_transf_w
	from	dual;

	select	obter_parametro_agenda(cd_estabelecimento_p, 'IE_CAMPO_SENHA_TRANSF', 'S')
	into	ie_campo_senha_transf_w
	from	dual;

	select	obter_parametro_agenda(cd_estabelecimento_p, 'IE_CAMPO_SENHA_COPIA', 'S')
	into	ie_campo_senha_copia_w
	from	dual;

	select	obter_parametro_agenda(cd_estabelecimento_p, 'IE_CAMPO_SALA_TRANSF', 'S')
	into	ie_sala_transf_w
	from	dual;

	select	obter_parametro_agenda(cd_estabelecimento_p, 'IE_CAMPO_SALA_COPIA', 'S')
	into	ie_sala_copia_w
	from	dual;

	select obter_parametro_agenda(cd_estabelecimento_p, 'IE_DOC_CONV_COPIA', 'S')
	into	nr_doc_convenio_copia_w
	from 	dual;

	select obter_parametro_agenda(cd_estabelecimento_p, 'IE_DOC_CONV_TRANSF', 'N')
	into	nr_doc_convenio_transf_w
	from 	dual;


	ie_transacao_sus_copia_w	:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_TRANSACAO_SUS_COPIA', 'N');

	ie_transacao_sus_transf_w	:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_TRANSACAO_SUS_TRANSF', 'N');

	ie_campo_peso_copia_w 		:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_PESO_COPIA', 'N');

	ie_campo_peso_transf_w		:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_PESO_TRANSF', 'N');

	ie_campo_altura_copia_w		:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_ALTURA_COPIA', 'N');

	ie_campo_altura_transf_w 	:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_ALTURA_TRANSF', 'N');

	ie_campo_empresa_copia_w 	:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_EMPRESA_COPIA', 'N');

	ie_campo_empresa_transf_w 	:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_EMPRESA_TRANSF', 'N');

	ie_campo_autorizacao_copia_w 	:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_AUTORIZACAO_COPIA', 'N');

	ie_campo_autorizacao_transf_w 	:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_AUTORIZACAO_TRANSF', 'N');	

	ie_campo_especialidade_copia_w  := obter_parametro_agenda(cd_estabelecimento_p, 'IE_ESPECIALIDADE_COPIA', 'N');

	ie_campo_especialidade_trans_w	:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_ESPECIALIDADE_TRANSF', 'N');

	ie_campo_crm_med_ext_copia_w	:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_CRM_EXT_COPIA', 'N');	

	ie_campo_crm_med_ext_transf_w	:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_CRM_EXT_TRANSF', 'N');	

	ie_campo_nm_med_ext_copia_w	:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_MEDICO_EXT_COPIA', 'N');	

	ie_campo_nm_med_ext_trans_w	:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_MEDICO_EXT_TRANSF', 'N');	

	ie_campo_mot_agend_copia_w	:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_MOT_AGENDA_COPIA', 'N');	

	ie_campo_mot_agend_transf_w	:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_MOT_AGENDA_TRANSF', 'N');


	ie_reserva_transf_w			:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_RESERVA_TRANSF', 'S');

	ie_observacao_copia_w		:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_OBS_COPIA', 'S');

	ie_observacao_trans_w		:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_OBS_TRANSFERENCIA', 'S');

	obter_param_usuario(869, 102, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p,ie_modo_gerar_reserva_w);

	ie_historico_trans_w		:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_HISTORICO_TRANSF', 'N');

	ie_setor_transf_w			:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_SETOR_TRANSFERENCIA', 'N');

	ie_setor_copia_w			:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_SETOR_COPIA', 'N');

	ie_procedencia_transf_w		:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_PROCEDENCIA_TRANSF', 'N');

	ie_procedencia_copia_w		:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_PROCEDENCIA_COPIA', 'N');

	ie_tipo_atend_copia_w		:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_TIPO_ATEND_COPIA', 'N');

	ie_tipo_atend_transf_w		:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_TIPO_ATEND_TRANSF', 'N');

	ie_campo_classif_copia_w 	:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_CLASSIF_ORIG_COPIA', 'S');

	ie_med_req_copia_w			:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_MEDICO_REQ_COPIA', 'S');

	ie_med_req_transf_w			:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_MEDICO_REQ_TRANSF', 'S');

	ie_status_pac_transf_w		:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_STATUS_PAC_TRANSFERIR', 'N');

	ie_status_pac_copia_w		:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_STATUS_PAC_COPIA', 'N');


	/* obter dados origem */
	select	b.cd_agenda,
			b.cd_pessoa_fisica,
			b.dt_agenda,
			b.nr_minuto_duracao,
			b.cd_medico,
			b.nm_pessoa_contato,
			b.cd_procedimento,
			b.ds_observacao,
			b.cd_convenio,
			b.qt_idade_pac,
			b.ie_origem_proced,
			b.ie_status_agenda,
			b.ds_senha,
			b.nm_paciente,
			b.nr_atendimento,
			b.cd_usuario_convenio,
			b.dt_agendamento,
			b.nm_usuario_origem,
			--qt_idade_mes,
			b.cd_plano,
			b.nr_telefone,
			b.ie_autorizacao,
			--vl_previsto,
			--nr_seq_age_cons,
			--cd_medico_exec,
			--nr_seq_classif_agenda,
			b.cd_procedencia,
			b.cd_categoria,
			b.cd_tipo_acomodacao,
			b.nr_doc_convenio,
			b.dt_validade_carteira,
			b.nr_seq_proc_interno,
			nr_seq_status_pac,
			--ie_lado,
			--ds_laboratorio,
			b.cd_cid,
			b.dt_nascimento_pac,
			b.nr_seq_sala,
			b.nm_medico_externo,
			b.ie_tipo_atendimento,
			b.cd_medico_req,
			b.nr_seq_pq_proc,
			b.nr_seq_indicacao,
			b.cd_pessoa_indicacao,
			b.nm_pessoa_indicacao,
			b.ds_confirmacao,
			b.cd_setor_atendimento,
			b.ie_status_paciente,
			b.ie_classif_agenda,
			b.nr_seq_forma_confirmacao,
			b.dt_confirmacao,
			b.nm_usuario_confirm,
			b.ie_forma_agendamento,
			b.cd_senha,
			b.nr_reserva,
			a.cd_estabelecimento,
			nr_seq_agepaci,
			b.qt_peso,
			b.qt_altura_cm,
			b.cd_empresa_ref,
			b.cd_especialidade,
			b.crm_medico_externo,
			b.nr_seq_motivo_agendamento,
			b.qt_diaria_prev,
			b.nr_seq_agendamento,
			b.nr_transacao_sus,
			b.nr_seq_segurado,
			dt_validade_senha,
      		b.nr_seq_tipo_midia,
			b.ds_email
	into	cd_agenda_w,
			cd_pessoa_fisica_w,
			hr_inicio_w,
			nr_minuto_duracao_w,
			cd_medico_w,
			nm_pessoa_contato_w,
			cd_procedimento_w,
			ds_observacao_w,
			cd_convenio_w,
			qt_idade_paciente_w,
			ie_origem_proced_w,
			ie_status_agenda_w,
			ds_senha_w,
			nm_paciente_w,
			nr_atendimento_w,
			cd_usuario_convenio_w,
			dt_agendamento_w,
			nm_usuario_orig_w,
			--qt_idade_mes_w,
			cd_plano_w,
			nr_telefone_w,
			ie_autorizacao_w,
			--vl_previsto_w,
			--nr_seq_age_cons_w,
			--cd_medico_exec_w,
			--nr_seq_classif_agenda_w,
			cd_procedencia_w,
			cd_categoria_w,
			cd_tipo_acomodacao_w,
			nr_doc_convenio_w,
			dt_validade_carteira_w,
			nr_seq_proc_interno_w,
			nr_seq_status_pac_w,
			--ie_lado_w,
			--ds_laboratorio_w,
			cd_doenca_cid_w,
			dt_nascimento_pac_w,
			nr_seq_sala_w,
			nm_medico_externo_w,
			ie_tipo_atendimento_w,
			cd_medico_req_w,
			nr_seq_pq_proc_w,
			nr_seq_indicacao_w,
			cd_pessoa_indicacao_w,
			nm_pessoa_indicacao_w,
			ds_cirurgia_w,
			cd_setor_atendimento_w,
			ie_status_paciente_w,
			ie_classif_agenda_w,
			nr_seq_forma_confirmacao_w,
			dt_confirmacao_w,
			nm_usuario_confirm_w,
			ie_forma_agendamento_w,
			cd_senha_w,
			nr_reserva_w,
			cd_estab_origem_w,
			nr_seq_agepaci_w,
			qt_peso_w,
			qt_altura_cm_w,
			cd_empresa_ref_w,
			cd_especialidade_w,
			crm_medico_externo_w,
			nr_seq_motivo_agendamento_w,
			qt_diaria_prev_w,
			nr_seq_agendamento_w,
			nr_transacao_sus_w,
			nr_seq_segurado_w	,
			dt_validade_senha_w,
			nr_seq_tipo_midia_w,
			ds_email_w
	from	agenda a,
			agenda_consulta b
	where	b.nr_sequencia = nr_seq_origem_p
	and		a.cd_agenda	= b.cd_agenda;

	/* obter dados destino */
	select	b.cd_agenda,
			b.dt_agenda,
			b.cd_convenio,
			b.nr_seq_turno,
			b.nr_seq_turno_esp,
			a.cd_estabelecimento,
			b.ie_classif_agenda,
			b.cd_medico_req,
			nvl(a.ie_utiliza_prof_horario, 'N'),
			a.cd_setor_agenda,
			a.cd_pessoa_fisica
	into	cd_agenda_destino_w,
			hr_destino_w,
			cd_conv_agenda_destino_w,
			nr_seq_turno_w,
			nr_seq_turno_esp_w,
			cd_estab_destino_w,
			ie_classif_agenda_destino_w,
			cd_medico_req_ww,
			ie_utiliza_prof_horario_w,
			cd_setor_agenda_w,
			cd_medico_agenda_destino_w
	from	agenda a,
			agenda_consulta b
	where	nr_sequencia = nr_seq_destino_p
	and		a.cd_agenda	= b.cd_agenda;

	if	(nr_seq_segurado_w is not null) then
		select max(ie_situacao_atend)
		into	ie_situacao_atend_w
		from 	pls_segurado 
		where 	nr_sequencia = nr_seq_segurado_w;
		if	(ie_situacao_atend_w <> 'A') then
			WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(239972);
		end if;
	end if;

	/* Consistir agendamentos para o mesmo paciente/dia*/
	if	((ie_consiste_mesmo_paciente_w	= 'S') or (ie_consiste_mesmo_paciente_w = 'A')) then
		Consistir_agend_espec_dif(cd_pessoa_fisica_w, cd_agenda_destino_w, hr_destino_w, nr_minuto_duracao_w, ie_permite_agendamento_w);

		if	(ie_permite_agendamento_w = 'N') then
			if	(ie_consiste_mesmo_paciente_w	= 'S') then
				liberar_horario_agenda_cons(nr_seq_destino_p, nm_usuario_p);
				Wheb_mensagem_pck.exibir_mensagem_abort(213811); 
			elsif	(ie_consiste_mesmo_paciente_w = 'A') then
				ds_retorno_w := Wheb_mensagem_pck.get_texto(213811);
			end if;
		end if;
	end if;


	if	(ie_consiste_tempo_minimo_w = 'S') then
		begin
			Consistir_quimio_dur_agecons(hr_destino_w, cd_pessoa_fisica_w, nm_usuario_p, cd_estabelecimento_p);
		Exception when others then
			liberar_horario_agecons(nr_seq_destino_p, nm_usuario_p, nr_seq_turno_w);
			Wheb_mensagem_pck.exibir_mensagem_abort( 262328 , 'DS_MENSAGEM='||substr(sqlerrm,1,255));
		end;
	end if;

	consiste_convenio_agecons(nr_seq_destino_p, cd_agenda_destino_w, cd_convenio_w, hr_destino_w, nm_usuario_p);

	IF (ie_acao_p = 'C') THEN
    		BEGIN
    		consistir_qtd_conv_regra_cons(	nr_seq_destino_p,
						cd_convenio_w,
						hr_destino_w,
						cd_agenda_destino_w,
						cd_pessoa_fisica_w,
						cd_categoria_w,
						cd_plano_w,
						cd_estabelecimento_p,
						nm_usuario_p,
						cd_medico_agenda_destino_w,
						nr_seq_proc_interno_w,
						ie_tipo_atendimento_w,
						ds_erro_ww,
						ds_erro_ww,
						ds_erro_ww);

		Exception when others then
			liberar_horario_agecons(nr_seq_destino_p, nm_usuario_p, nr_seq_turno_w);
			Wheb_mensagem_pck.exibir_mensagem_abort( 262328 , 'DS_MENSAGEM='||substr(sqlerrm,1,255));
		END;
    	END IF;

	ie_perm_agendar_classif_w := Obter_Se_Perm_PF_Classif(821, cd_agenda_destino_w, cd_pessoa_fisica_w, hr_destino_w,'DCE');

	if	(ie_perm_agendar_classif_w is not null) then
		liberar_horario_agenda_cons(nr_seq_destino_p, nm_usuario_p);
		Wheb_mensagem_pck.exibir_mensagem_abort( 262370 , 'DS_MENSAGEM='||ie_perm_agendar_classif_w);
	end if;

	if	(cd_estab_origem_w	<> cd_estab_destino_w) then
		if	(ie_modo_gerar_reserva_w	= '1') then			
			if	(ie_acao_p = 'T') then
				ds_abrev_origem_w 	:= upper(obter_abrev_estabelecimento(cd_estab_origem_w));
				ds_abrev_dest_w		:= upper(obter_abrev_estabelecimento(cd_estab_destino_w));
				nr_reserva_w	:= substr(replace(nr_reserva_w,ds_abrev_origem_w,ds_abrev_dest_w),1,20);
			else
				nr_reserva_w	:= Ageint_Obter_Reserva_Pac(nr_seq_destino_p, hr_destino_w, cd_pessoa_fisica_w, cd_estab_destino_w,'S');
			end if;
		end if;
	end if;

	/* tratar parametros */
	if	(ie_manut_proced_w = 'N') or
		((ie_manut_proced_w = 'C') and
		(ie_acao_p = 'T')) or 
		((ie_manut_proced_w = 'T') and
		(ie_acao_p = 'C')) then
		cd_procedimento_w := null;
		ie_origem_proced_w := null;
		nr_seq_proc_interno_w := null;
	end if;		

	if	(ie_acao_p = 'C') then
		nr_seq_agendamento_w	:= null;
		if	(nr_doc_convenio_copia_w = 'N') then
			nr_doc_convenio_w := '';
		end if;		

		if	(ie_sala_copia_w = 'N') then		
			nr_Seq_sala_w	:= '';
		end if;

		if	(ie_campo_senha_copia_w		= 'N') then
			cd_senha_w	:= '';
		end if;

		if	(ie_campo_peso_copia_w		= 'N') then
			qt_peso_w	:= '';		
		end if;

		if	(ie_campo_altura_copia_w	= 'N') then
			qt_altura_cm_w	:= '';		
		end if;

		if	(ie_campo_empresa_copia_w	= 'N') then
			cd_empresa_ref_w := '';		
		end if;

		if	(ie_campo_autorizacao_copia_w	= 'N') then
			ie_autorizacao_w := '';		
		end if;

		if	(ie_campo_especialidade_copia_w	= 'N') then
			cd_especialidade_w := '';		
		end if;

		if	(ie_campo_crm_med_ext_copia_w	= 'N') then
			crm_medico_externo_w := '';		
		end if;

		if	(ie_campo_nm_med_ext_copia_w	= 'N') then
			nm_medico_externo_w := '';		
		end if;

		if	(ie_campo_mot_agend_copia_w	= 'N') then
			nr_seq_motivo_agendamento_w := '';		
		end if;

		if	(ie_campo_classif_copia_w	= 'N') then
			ie_classif_agenda_w := ie_classif_agenda_destino_w;		
		end if;


		if	(ie_duracao_copia_w = 'S') then
			ie_manter_duracao_w := 'S';
		elsif	(ie_duracao_copia_w = 'P') then
			select	obter_se_mantem_dur_agecons(cd_agenda_destino_w,nr_seq_destino_p,hr_destino_w,nr_minuto_duracao_w)
			into	ie_manter_duracao_w
			from	dual;
		else
			ie_manter_duracao_w := 'N';
		end if;
		ie_manter_atend_w := ie_atend_copia_w;

		if	(ie_status_copia_w = 'S') then
			ie_manter_status_w := 'S';
		elsif	(ie_status_copia_w = 'A') and
			(ie_manter_atend_w = 'S') and
			(nr_atendimento_w > 0) then
			ie_manter_status_w := 'S';
		end if;

		if	(ie_observacao_copia_w = 'N') then
			ds_observacao_w	:= '';
		end if;

		if	(ie_setor_copia_w	= 'A') then
			cd_setor_atendimento_w	:= obter_setor_agenda(cd_agenda_destino_w);
		elsif (ie_setor_copia_w = 'E') then
			cd_setor_atendimento_w 	:= cd_setor_agenda_w;
		elsif (ie_setor_copia_w	= 'N') then
			cd_setor_atendimento_w	:= null;
		end if;

		if	(ie_procedencia_copia_w = 'N') then
			cd_procedencia_w := null;
		end if;

		if	(ie_tipo_atend_copia_w = 'N') then
			ie_tipo_atendimento_w := null;
		end if;		

		if	(ie_transacao_sus_copia_w = 'N') then
			nr_transacao_sus_w := null;
		end if;

		if	(ie_med_req_copia_w = 'N') and
			(ie_utiliza_prof_horario_w = 'N')then
			cd_medico_req_w := null;
		else
			select	decode(ie_utiliza_prof_horario_w, 'S', cd_medico_req_ww, cd_medico_req_w)
			into	cd_medico_req_w
			from	dual;			
		end if;	

		if	(ie_status_pac_copia_w = 'N') then
			nr_seq_status_pac_w := null;
		end if;

	elsif	(ie_acao_p = 'T') then

		if	(nr_doc_convenio_transf_w = 'N') then
			nr_doc_convenio_w := '';
		end if;		

		if	(ie_sala_transf_w = 'N') then		
			nr_Seq_sala_w	:= '';
		end if;

		if	(ie_campo_senha_transf_w	= 'N') then
			cd_senha_w	:= '';
		end if;

		if	(ie_campo_peso_transf_w		= 'N') then
			qt_peso_w	:= '';		
		end if;

		if	(ie_campo_altura_transf_w	= 'N') then
			qt_altura_cm_w	:= '';		
		end if;

		if	(ie_campo_empresa_transf_w	= 'N') then
			cd_empresa_ref_w := '';		
		end if;

		if	(ie_campo_autorizacao_transf_w	= 'N') then
			ie_autorizacao_w := '';		
		end if;

		if	(ie_campo_especialidade_trans_w	= 'N') then
			cd_especialidade_w := '';		
		end if;

		if	(ie_campo_crm_med_ext_transf_w	= 'N') then
			crm_medico_externo_w := '';		
		end if;

		if	(ie_campo_nm_med_ext_trans_w	= 'N') then
			nm_medico_externo_w := '';		
		end if;

		if	(ie_campo_mot_agend_transf_w	= 'N') then
			nr_seq_motivo_agendamento_w := '';		
		end if;		

		if	(ie_observacao_trans_w = 'N') then
			ds_observacao_w	:= '';
		end if;

		if	(ie_duracao_transf_w = 'S') then
			ie_manter_duracao_w := 'S';
		elsif	(ie_duracao_transf_w = 'P') then
			select	obter_se_mantem_dur_agecons(cd_agenda_destino_w,nr_seq_destino_p,hr_destino_w,nr_minuto_duracao_w)
			into	ie_manter_duracao_w
			from	dual;
		else
			ie_manter_duracao_w := 'N';
		end if;
		ie_manter_usuario_w	:= ie_user_orig_transf_w;
		ie_manter_atend_w	:= ie_atend_transf_w;

		if	(ie_status_transf_w = 'S') then
			ie_manter_status_w := 'S';
		elsif	(ie_status_transf_w = 'A') and
			(ie_manter_atend_w = 'S') and
			(nr_atendimento_w > 0) then
			ie_manter_status_w := 'S';
		end if;

		if	(ie_setor_transf_w	= 'A') then
			cd_setor_atendimento_w	:= obter_setor_agenda(cd_agenda_destino_w);
		elsif (ie_setor_transf_w = 'E') then
			cd_setor_atendimento_w 	:= cd_setor_agenda_w;
		elsif (ie_setor_transf_w	= 'N') then
			cd_setor_atendimento_w	:= null;
		end if;

		if	(ie_procedencia_transf_w = 'N') then
			cd_procedencia_w := null;
		end if;		

		if	(ie_tipo_atend_transf_w = 'N') then
			ie_tipo_atendimento_w := null;
		end if;

		if	(ie_transacao_sus_transf_w = 'N') then
			nr_transacao_sus_w := null;
		end if;

		if	(ie_med_req_transf_w = 'N') and
			(ie_utiliza_prof_horario_w = 'N')then
			cd_medico_req_w := null;
		else
			select	decode(ie_utiliza_prof_horario_w, 'S', cd_medico_req_ww, cd_medico_req_w)
			into	cd_medico_req_w
			from	dual;
		end if;

		if	(ie_status_pac_transf_w = 'N') then
			nr_seq_status_pac_w := null;
		end if;

	end if;

	if	(ie_consiste_sobreposicao_w = 'S') then
		begin
		Consistir_Duracao_Agecons(cd_agenda_destino_w, hr_destino_w, nr_minuto_duracao_w, nr_seq_destino_p, ds_erro_w);
		if	(ds_erro_w is not null) then
			liberar_horario_agenda_cons(nr_seq_destino_p, nm_usuario_p);
			Wheb_mensagem_pck.exibir_mensagem_abort( 262328 , 'DS_MENSAGEM='||ds_erro_w);
		end if;
		end; 
	end if;

	consistir_prazo_convenio_agend(cd_pessoa_fisica_w, hr_destino_w, cd_convenio_w, nm_usuario_p, cd_estabelecimento_p, ds_erro_w);
	if	(ds_erro_w is not null) then
		liberar_horario_agenda_cons(nr_seq_destino_p, nm_usuario_p);
		Wheb_mensagem_pck.exibir_mensagem_abort( 262328 , 'DS_MENSAGEM='||ds_erro_w);
	end if;

	if	(ie_classif_orig_transf_w = 'S') then
		ie_classif_proc_w	:= ie_classif_agenda_w;
	else
		ie_classif_proc_w	:= ie_classif_agenda_destino_w;
	end if;

	consistir_classif_agecon(cd_estabelecimento_p,
			 cd_pessoa_fisica_w,
			 hr_destino_w,
			 cd_agenda_w,
			 cd_convenio_w,
			 null,
			 null, 
			 null,
			 ie_classif_proc_w,
			 nr_seq_destino_p,
			 ie_consistencia_w,
			 ie_agenda_w);
	if	(ie_agenda_w = 'N') then
		liberar_horario_agenda_cons(nr_seq_destino_p, nm_usuario_p);
		Wheb_mensagem_pck.exibir_mensagem_abort( 262328 , 'DS_MENSAGEM='||ie_consistencia_w);
	end if;

	if	(ie_convenio_cancelamento_w = 'S') and
		(cd_convenio_w is not null) then
		Agecons_cons_se_conv_canc(cd_convenio_w,hr_destino_w);
	end if;					 

	if	(ie_acao_p 	= 'C') then
		dt_confirmacao_w		:= null;
		nm_usuario_confirm_w		:= null;
		nr_seq_forma_confirmacao_w	:= null;
		ds_cirurgia_w			:= null;
		nr_seq_agepaci_w		:= null;
	end if;

	-- [381] Consistir a regra de convenio x turno ao transferir agenda
	Obter_Param_Usuario(821,381,obter_perfil_ativo,nm_usuario_p,wheb_usuario_pck.get_cd_estabelecimento,ie_consiste_regra_conv_turno_w);
	if	(ie_acao_p 	= 'C') then	
		consistir_turno_convenio(nr_seq_destino_p,cd_agenda_destino_w,hr_destino_w,nr_seq_turno_w,cd_convenio_w,cd_categoria_w,ds_consistencia_w, nm_usuario_p, cd_estabelecimento_p, ie_acao_p, nr_seq_origem_p);	
	elsif (ie_acao_p = 'T') and
		(ie_consiste_regra_conv_turno_w = 'S') then		
		consistir_turno_convenio(nr_seq_destino_p,cd_agenda_destino_w,hr_destino_w,nr_seq_turno_w,cd_convenio_w,cd_categoria_w,ds_consistencia_w, nm_usuario_p, cd_estabelecimento_p, ie_acao_p, nr_seq_origem_p);

	end if;

	if	(ds_consistencia_w is not null) then
		liberar_horario_agenda_cons(nr_seq_destino_p, nm_usuario_p);
		Wheb_mensagem_pck.exibir_mensagem_abort( 262328 , 'DS_MENSAGEM='||ds_consistencia_w);
	end if;

	consistir_turno_esp_convenio(cd_agenda_destino_w,hr_destino_w,nr_seq_turno_esp_w,cd_convenio_w,nr_seq_destino_p,ds_consistencia_w, cd_categoria_w, ie_acao_p);

	if	(ds_consistencia_w is not null) then
		liberar_horario_agenda_cons(nr_seq_destino_p, nm_usuario_p);
		Wheb_mensagem_pck.exibir_mensagem_abort( 262328 , 'DS_MENSAGEM='||ds_consistencia_w);		

	end if;

	if	(ie_cons_regra_agenda_conv_w	= 'S') then
		begin
		consiste_regra_agecons_conv(cd_convenio_w, cd_categoria_w, cd_agenda_destino_w, cd_setor_atendimento_w, cd_plano_w, cd_pessoa_fisica_w, hr_destino_w, cd_estabelecimento_p, cd_empresa_ref_w, null);
		Exception when others then
			liberar_horario_agecons(nr_seq_destino_p, nm_usuario_p, nr_seq_turno_w);
			Wheb_mensagem_pck.exibir_mensagem_abort( 262328 , 'DS_MENSAGEM='||substr(sqlerrm,1,255));
		end;

	end if;

	ds_mensagem_w := obter_msg_bloq_geral_agenda_js (cd_estabelecimento_p,
					cd_agenda_destino_w,
					nr_seq_destino_p,
					null,
					hr_destino_w);
	if (ds_mensagem_w is not null) then
		liberar_horario_agenda_cons(nr_seq_destino_p, nm_usuario_p);
		Wheb_mensagem_pck.exibir_mensagem_abort(ds_mensagem_w);
	end if;

	if	(ie_perm_transf_agend_exec_w	= 'N') and		
		(nr_atendimento_w		> 0) and
		(ie_acao_p			= 'T')then
		liberar_horario_agenda_cons(nr_seq_destino_p, nm_usuario_p); 
		Wheb_mensagem_pck.exibir_mensagem_abort(262373);
	end if;

  select	max(obter_se_conv_lib_agenda(cd_agenda_destino_w, cd_convenio_w))
  into	ie_conv_nao_lib_agenda_w
  from	dual;

  if	(ie_conv_nao_lib_agenda_w = 'N') then
    liberar_horario_agecons(nr_seq_destino_p, nm_usuario_p, nr_seq_turno_w);
    wheb_mensagem_pck.Exibir_Mensagem_Abort(220661);
  end if;

	if	(ie_acao_p = 'T') then
		select	count(*)
		into	qt_same_pront_w
		from	same_solic_pront
		where	nr_seq_agecons	= nr_seq_origem_p;

		if	(qt_same_pront_w > 0) then
			update	same_solic_pront
			set	nr_seq_agecons = nr_seq_destino_p
			where	nr_seq_agecons = nr_seq_origem_p;
		end if;

		select	count(*)
		into	qt_solic_cip_w
		from	same_cpi_solic
		where	nr_seq_agenda = nr_seq_origem_p;

		select	max(cd_setor_exclusivo),
			max(cd_estabelecimento)
		into	cd_setor_solic_cpi_w,
			cd_estab_solic_cpi_w	
		from	agenda
		where	cd_agenda = cd_agenda_destino_w;

		if	(qt_solic_cip_w > 0) then
			update	same_cpi_solic
			set	nr_seq_agenda = nr_seq_destino_p,
				dt_desejada   = hr_destino_w,
				dt_solicitacao = sysdate,
				dt_atualizacao = sysdate,
				nm_usuario = nm_usuario_p,
				nm_usuario_solic = nm_usuario_p,
				cd_agenda  = cd_agenda_destino_w,
				cd_setor_atendimento = nvl(cd_setor_solic_cpi_w,cd_setor_atendimento),
				cd_estabelecimento  = cd_estab_solic_cpi_w
			where	nr_seq_agenda = nr_seq_origem_p;
		end if;
	end if;

	agecons_consiste_cmce(cd_pessoa_fisica_w, cd_convenio_w, cd_agenda_destino_w, hr_destino_w);

	/* gerar dados destino */
	update	agenda_consulta
	set	cd_pessoa_fisica		= cd_pessoa_fisica_w,
		nr_minuto_duracao		= decode(ie_manter_duracao_w,'S',nr_minuto_duracao_w,nr_minuto_duracao),
		nm_usuario			= nm_usuario_p,
		dt_atualizacao		= sysdate,
		cd_medico			= cd_medico_w,
		nm_pessoa_contato		= nm_pessoa_contato_w,
		cd_procedimento		= cd_procedimento_w,
		ds_observacao			= ds_observacao_w,
		cd_convenio			= cd_convenio_w,
		qt_idade_pac			= qt_idade_paciente_w,
		ie_origem_proced		= ie_origem_proced_w,
		ie_status_agenda		= decode(ie_manter_status_w,'S', ie_status_agenda_w,'N'),
		ds_senha			= ds_senha_w,
		nm_paciente			= nm_paciente_w,
		nr_atendimento		= decode(ie_manter_atend_w,'S',nr_atendimento_w,null),
		cd_usuario_convenio		= cd_usuario_convenio_w,
		nm_usuario_origem		= decode(ie_manter_usuario_w,'S',nm_usuario_orig_w,nm_usuario_p),
		--qt_idade_mes		= qt_idade_mes_w,
		cd_plano			= cd_plano_w,
		nr_telefone			= nr_telefone_w,
		dt_agendamento		= decode(ie_acao_p,'T',dt_agendamento_w,sysdate),
		ie_autorizacao		= ie_autorizacao_w,
		--vl_previsto			= vl_previsto_w,
		--nr_seq_age_cons		= nr_seq_age_cons_w,
		--cd_medico_exec		= cd_medico_exec_w,
		cd_procedencia		= cd_procedencia_w,
		cd_categoria			= cd_categoria_w,
		cd_tipo_acomodacao		= cd_tipo_acomodacao_w,
		nr_doc_convenio		= nr_doc_convenio_w,
		dt_validade_carteira		= dt_validade_carteira_w,
		nr_seq_proc_interno		= nr_seq_proc_interno_w,
		nr_seq_status_pac		= nr_seq_status_pac_w,
		--ie_lado			= ie_lado_w,
		--ds_laboratorio		= ds_laboratorio_w,
		cd_cid			= cd_doenca_cid_w,
		dt_nascimento_pac		= dt_nascimento_pac_w,
		nr_seq_sala			= nvl(nr_seq_sala_w,nr_seq_sala), 
		nm_medico_externo		= nm_medico_externo_w,
		ie_tipo_atendimento	= ie_tipo_atendimento_w,
		cd_medico_req			= cd_medico_req_w,
		nr_seq_pq_proc		= nr_seq_pq_proc_w,
		nr_seq_indicacao		= nr_seq_indicacao_w,
		cd_pessoa_indicacao		= cd_pessoa_indicacao_w,
		nm_pessoa_indicacao		= nm_pessoa_indicacao_w,
		ds_confirmacao		= ds_cirurgia_w,
		ie_status_paciente		= ie_status_paciente_w,
		cd_setor_atendimento		= cd_setor_atendimento_w,
		nr_seq_motivo_transf		= nr_seq_motivo_p,
		ds_motivo_copia_trans	= ds_motivo_p,
		dt_copia_trans		= sysdate,
		nm_usuario_copia_trans	= nm_usuario_p,
		ie_classif_agenda	= decode(ie_classif_orig_transf_w, 'S', ie_classif_agenda_w, ie_classif_agenda),
		nr_seq_forma_confirmacao	= nr_seq_forma_confirmacao_w,
		dt_confirmacao			= decode(ie_manter_status_w, 'S', dt_confirmacao_w, null),
		nm_usuario_confirm		= decode(ie_manter_status_w, 'S', nm_usuario_confirm_w, null),
		ie_forma_agendamento		= ie_forma_agendamento_w,
		cd_Senha			= cd_Senha_w,
		nr_seq_turno			= nr_seq_turno_w,
		nr_reserva			= decode(ie_reserva_transf_w, 'S', nr_reserva_w, null),
		nr_seq_agepaci			= nr_seq_agepaci_w,
		qt_peso				= qt_peso_w,
		qt_altura_cm			= qt_altura_cm_w,
		cd_empresa_ref			= cd_empresa_ref_w,
		cd_especialidade		= cd_especialidade_w,
		crm_medico_externo		= crm_medico_externo_w,
		nr_seq_motivo_agendamento	= nr_seq_motivo_agendamento_w,
		ie_transferido			= decode(ie_acao_p,'T','S','N'),
		nm_usuario_acesso		= null,
		nr_seq_agendamento		= nr_seq_agendamento_w,
		nr_transacao_sus		= nr_transacao_sus_w,
		nr_atend_pls			= nr_seq_atendimento_p,
		nr_seq_evento_atend		= nr_seq_evento_atend_p,
		dt_validade_senha		= decode(ie_acao_p,'C',dt_validade_senha_w,null),
		nr_seq_segurado         = nr_seq_segurado_w,
    	nr_seq_tipo_midia     = nr_seq_tipo_midia_w,
		ds_email			= ds_email_w
	where	nr_sequencia			= nr_seq_destino_p;

	if	(ie_acao_p = 'T') and
		(ie_historico_trans_w = 'S') then

		select	count(*)
		into	qt_historico_w
		from	agenda_cons_hist
		where	nr_seq_agenda	= nr_seq_origem_p;

		if	(qt_historico_w > 0) then
			update	agenda_cons_hist
			set	nr_seq_agenda	=	nr_seq_destino_p,
				nm_usuario	=	nm_usuario_p,
				dt_atualizacao	=	sysdate
			where	nr_seq_agenda	=	nr_seq_origem_p;	
		end if;		
	end if;

	if	(ie_acao_p = 'T') and
		(ie_alterar_vaga_w = 'S') then

		select	max(nr_sequencia)
		into	nr_seq_vaga_w
		from	gestao_vaga
		where	nr_seq_agenda = nr_seq_origem_p;

		if	(nr_seq_vaga_w > 0) then

			select	max(cd_estabelecimento),
					max(ie_solicitacao),
					max(ie_tipo_vaga),
					max(ie_status),
					max(dt_prevista),
					max(obter_nome_setor(cd_setor_desejado)),
					max(cd_unidade_basica),
					max(cd_unidade_compl),
					max(cd_tipo_acomod_desej)
				into	cd_estab_gestao_w,
					ie_solicitacao_w,
					ie_tipo_vaga_w,
					ie_status_gv_w,
					dt_prevista_w,
					ds_setor_desejado_w,
					cd_unidade_basica_w,
					cd_unidade_compl_w,
					cd_tipo_acomod_desej_w
			from	gestao_vaga
			where	nr_sequencia = nr_seq_vaga_w;

			if	(ie_estab_agenda_w = 'S') then

				if	(cd_estab_gestao_w is not null) and
					(cd_estab_gestao_w <> cd_estab_destino_w) then

					cancelar_gestao_vaga(nr_seq_origem_p,null,nm_usuario_p,cd_estabelecimento_p);

					update	gestao_vaga
					set	nr_seq_agenda = null
					where	nr_seq_agenda = nr_seq_origem_p;

					Ageint_Gerar_necessidade_vaga(nr_seq_destino_p,ie_solicitacao_w,ie_tipo_vaga_w,cd_tipo_acomod_desej_w,cd_estab_gestao_w,nm_usuario_p,'S',ds_retorno_w);

					select	max(nr_sequencia)
					into	nr_seq_vaga_w
					from	gestao_vaga
					where	nr_seq_agenda = nr_seq_destino_p;

					if	(nr_seq_vaga_w is not null) then
						update	gestao_vaga
						set	qt_dia		= qt_diaria_prev_w
						where	nr_sequencia	= nr_seq_vaga_w;
					end if;			

				elsif	(cd_estab_gestao_w is not null) and
					(cd_estab_gestao_w = cd_estab_destino_w) then

					if	(ie_status_aguardando_w = 'S') and
						((ie_status_gv_w = 'R') or (ie_status_gv_w = 'P')) then -- Somente sera alterado o status quando a data prevista for em dia diferente da data da agenda, momento da transferencia de agendamento
						if	(to_char(dt_prevista_w,'dd/mm/yyyy') <> to_char(hr_destino_w,'dd/mm/yyyy')) then
							Desfazer_reserva_leito(nr_seq_vaga_w,nm_usuario_p);
							ds_retorno_w:= 	wheb_mensagem_pck.get_texto(793139,
											'DS_SETOR_DESEJADO='||ds_setor_desejado_w||
											';CD_UNIDADE_BASICA='||cd_unidade_basica_w||
											';CD_UNIDADE_COMPL='||cd_unidade_compl_w)||chr(13)||																
									wheb_mensagem_pck.get_texto(793140,
											'NM_PACIENTE_W='||nm_paciente_w);
						end if;	
					end if;

					update	gestao_vaga
					set	dt_prevista	= hr_destino_w,
						nr_seq_agenda	= nr_seq_destino_p
					where	nr_sequencia	= nr_seq_vaga_w;

				end if;
			end if;
		end if;
	end if;

	/* tratar parametros */
	if	(ie_manut_proced_w = 'S') or
		((ie_manut_proced_w = 'C') and
		(ie_acao_p = 'C')) or
		((ie_manut_proced_w = 'T') and
		(ie_acao_p = 'T')) then
		/* gerar procedimentos adicionais */
		open c01;
		loop
		fetch c01 into	cd_procedimento_w,
				ie_origem_proced_w,
				nr_seq_proc_interno_w,
				ie_executar_proc_w,
				nr_seq_agenda_cons_proc_w;
		exit when c01%notfound;
			begin

			/* obter sequencia 
			select	nvl(max(nr_sequencia),0)+1
			into	nr_seq_proced_w
			from	agenda_consulta_proc
			where	nr_seq_agenda = nr_seq_destino_p; */

			select	agenda_consulta_proc_seq.nextval
			into	nr_seq_proc_odont_w
			from	dual;

			insert into agenda_consulta_proc	(
								nr_sequencia,
								nr_seq_agenda,
								cd_procedimento,
								ie_origem_proced,
								nr_seq_proc_interno,
								dt_atualizacao,
								nm_usuario,
								ie_executar_proc
								)
							values	(
								nr_seq_proc_odont_w,
								nr_seq_destino_p,
								cd_procedimento_w,
								ie_origem_proced_w,
								nr_seq_proc_interno_w,
								sysdate,
								nm_usuario_p,
								ie_executar_proc_w
								);

			open C03;
			loop
			fetch C03 into	
				nr_dente_w;
			exit when C03%notfound;
				begin

				insert into agenda_cons_proc_odont( nr_sequencia,
								dt_atualizacao,         
								nm_usuario,             
								dt_atualizacao_nrec,    
								nm_usuario_nrec,        
								nr_dente,       
								nr_seq_cons_proc)
							values 	(agenda_cons_proc_odont_seq.nextval,
								 sysdate,
								 nm_usuario_p,
								 sysdate,
								 nm_usuario_p,
								 nr_dente_w,
								 nr_seq_proc_odont_w);

				end;
			end loop;
			close C03;

			end;
		end loop;
		close c01;
	end if;


	open c02;
	loop
	fetch c02 into
		nr_sequencia_autor_w;
	exit when c02%notfound;
		if (ie_utiliza_agfa_w <> 'S') then
			update	autorizacao_convenio
			set	nr_seq_agenda_consulta	= nr_seq_destino_p,
				dt_agenda_cons   	= hr_destino_w
			where	nr_sequencia		= nr_sequencia_autor_w;
		end if;
	end loop;
	close c02;

	if	(ie_acao_p = 'T') then
		/* gerar historico */
		atrib_oldvalue_w := substr(obter_nome_agenda_cons(cd_agenda_w),1,50);
		atrib_newvalue_w := substr(obter_nome_agenda_cons(cd_agenda_destino_w),1,50);

		gerar_agenda_consulta_hist(cd_agenda_destino_w,nr_seq_origem_p,'T',nm_usuario_p,wheb_mensagem_pck.get_texto(793141,
							'NM_AGENDA_OLD='||atrib_oldvalue_w||
							';HR_INICIO='||to_char(hr_inicio_w, pkg_date_formaters.localize_mask('timestamp', pkg_date_formaters.getUserLanguageTag(cd_estabelecimento_p, nm_usuario_p)))||
							';NM_AGENDA_NEW='||atrib_newvalue_w||
							';HR_DESTINO_W='||to_char(hr_destino_w, pkg_date_formaters.localize_mask('timestamp', pkg_date_formaters.getUserLanguageTag(cd_estabelecimento_p, nm_usuario_p)))),cd_pessoa_fisica_w,nm_paciente_w,hr_destino_w);							

	elsif	(ie_acao_p = 'C') then
		/* gerar historico */
		atrib_oldvalue_w := substr(obter_nome_agenda_cons(cd_agenda_w),1,50);
		atrib_newvalue_w := substr(obter_nome_agenda_cons(cd_agenda_destino_w),1,50);

		gerar_agenda_consulta_hist(cd_agenda_destino_w,nr_seq_origem_p,'CP',nm_usuario_p,wheb_mensagem_pck.get_texto(793142,
							'ATRIB_OLDVALUE_W='||atrib_oldvalue_w||
							';DT_AGENDA_ORIG_W='||to_char(hr_inicio_w, pkg_date_formaters.localize_mask('timestamp', pkg_date_formaters.getUserLanguageTag(cd_estabelecimento_p, nm_usuario_p)))||
							';ATRIB_NEWVALUE_W='||atrib_newvalue_w||
							';DT_AGENDA_DEST_W='||to_char(hr_destino_w, pkg_date_formaters.localize_mask('timestamp', pkg_date_formaters.getUserLanguageTag(cd_estabelecimento_p, nm_usuario_p)))),cd_pessoa_fisica_w,nm_paciente_w,hr_destino_w);

	end if;

	if	(ie_acao_p = 'T') then
		/* verificar prescricoes vinculadas */
		select	count(*)
		into	qt_prescricao_w
		from	prescr_medica
		where	nr_seq_agecons = nr_seq_origem_p;

		/* atualizar prescricoes vinculadas */
		if	(qt_prescricao_w > 0) then
			update	prescr_medica
			set	nr_seq_agecons = nr_seq_destino_p
			where	nr_seq_agecons = nr_seq_origem_p;
		end if;

		obter_param_usuario(821, 180, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p,ie_canc_agenda_transf_w);			

        AGINT_INSERT_LOG_REMARCA(NR_SEQ_ORIGEM_P,NR_SEQ_DESTINO_P,DS_OBSERVACAO_P,'C');

		if	(ie_canc_agenda_transf_w = 'N') then

			select	count(*)
			into	qt_integrada_w
			from	agenda_integrada_item
			where	nr_seq_agenda_cons	= nr_seq_origem_p;

			if	(qt_integrada_w > 0) then
				ie_canc_agenda_transf_w	:= 'S';
			end if;

		end if;

		if	(ie_canc_agenda_transf_w = 'S') then	
			--alterar_status_agecons(cd_agenda_w, nr_seq_origem_p, 'C', null, 'Transferencia de agenda - '||to_char(hr_destino_w,'dd/mm/yyyy hh24:mi'), null, nm_usuario_p, null);
			-- Voltada alteracao por problemas com as OS's: 592556 e 594551

			select	nvl(max(PKG_DATE_UTILS.extract_field('SECOND', dt_Agenda)), 0) + 1
				into	qt_hor_cancel_w
				from	agenda_consulta
				where	cd_agenda = cd_agenda_w
				and   	dt_agenda between ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(hr_inicio_w) and ESTABLISHMENT_TIMEZONE_UTILS.endOfDay(hr_inicio_w)
				and	to_date(to_char(dt_agenda,'dd/mm/yyyy hh24:mi') || ':00', 'dd/mm/yyyy hh24:mi:ss') = to_date(to_char(hr_inicio_w,'dd/mm/yyyy hh24:mi') || ':00', 'dd/mm/yyyy hh24:mi:ss')
				and	ie_status_agenda = 'C';

			update	agenda_consulta
				set	ie_status_agenda	= 'C',
					dt_Agenda			= dt_agenda + qt_hor_cancel_w / 86400,
					nm_usuario_status	= nm_usuario_p,
					dt_status			= sysdate,
					ds_motivo_status		= wheb_mensagem_pck.get_texto(793144)||' - '||to_char(hr_destino_w,pkg_date_formaters.localize_mask('short', pkg_date_formaters.getUserLanguageTag(cd_estabelecimento_p, nm_usuario_p))),
					cd_motivo_cancelamento	= nr_seq_motivo_p,
					nm_usuario			= nm_usuario_p,
					nm_usuario_cancelamento	= nm_usuario_p,
					dt_cancelamento			= sysdate
			where	nr_sequencia			= nr_seq_origem_p;
		else
			/* excluir registro origem */
			delete from agenda_consulta
			where nr_sequencia = nr_seq_origem_p;
		end if;

		BEGIN
    			consistir_qtd_conv_regra_cons(	nr_seq_destino_p,
								cd_convenio_w,
								hr_destino_w,
								cd_agenda_destino_w,
								cd_pessoa_fisica_w,
								cd_categoria_w,
								cd_plano_w,
								cd_estabelecimento_p,
								nm_usuario_p,
								cd_medico_agenda_destino_w,
								nr_seq_proc_interno_w,
								ie_tipo_atendimento_w,
								ds_erro_ww,
								ds_erro_ww,
								ds_erro_ww);

		Exception when others THEN
      			ROLLBACK;
			liberar_horario_agecons(nr_seq_destino_p, nm_usuario_p, nr_seq_turno_w);      
			Wheb_mensagem_pck.exibir_mensagem_abort( 262328 , 'DS_MENSAGEM='||substr(sqlerrm,1,255));
		END;
	end if;
end if;

commit;

ds_retorno_p	:= ds_retorno_w;

end AGINT_REAGENDA_CONS;