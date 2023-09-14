create or replace procedure AGINT_REAGENDA_EXAME (
		cd_estabelecimento_p IN	number,
		ie_altera_medico_p IN	varchar2,
		nr_seq_origem_p IN number,
		nr_seq_destino_p IN	number,
		ie_acao_p IN	varchar2,
		nr_seq_motivo_p IN		number,
		ds_motivo_p IN		varchar2,
		nm_usuario_p IN	varchar2,
        ds_observacao_p IN varchar2 default null,
        ds_retorno_p 	OUT varchar2) AS
        
/*<DS_SCRIPT>
DESCRICAO....: Realiza remarcação de exames da plataforma Agenda Integrada
RESPONSAVEL..: Douglas Felipe, Viviane Viana e Gabriel Facundo
DATA.........: 27/01/2022
APLICACAO....: Agenda Integrada
ALTERACOES...:
</DS_SCRIPT>*/

/* variaveis registros */
cd_agenda_w                     number(10);
cd_pessoa_fisica_w              varchar2(10);
hr_inicio_w						date;
nr_minuto_duracao_w				number(10,0);	
nr_minuto_duracao_ww			number(10,0);	
nr_minuto_duracao_www			number(10,0);
nr_min_dur_fim_turno_w				number(10,0);	
cd_medico_w                     	varchar2(10);
nm_pessoa_contato_w             	varchar2(50);
cd_procedimento_w               	number(15);
cd_procedimento_ww               	number(15);
ds_observacao_w                 	varchar2(4000);
cd_convenio_w                   	number(5);
qt_idade_paciente_w             	number(3);
qt_idade_meses_w					number(15,0);
ie_origem_proced_w              	number(10);
ie_origem_proced_ww              	number(10);
ie_status_agenda_w              	varchar2(3);
ds_senha_w                      	varchar2(20);
nm_paciente_w                   	varchar2(60);
nr_atendimento_w                	number(10);
cd_usuario_convenio_w           	varchar2(30);
dt_agendamento_w			date;
nm_usuario_orig_w			varchar2(15);
nm_usuario_ant_w			varchar2(15);
qt_idade_mes_w                  	agenda_paciente.qt_idade_mes%type;
cd_plano_w                      	varchar2(10);
nr_telefone_w                   	varchar2(255);
ie_autorizacao_w                	varchar2(3);
vl_previsto_w                   	number(15,2);
nr_seq_age_cons_w               	number(10);
cd_medico_exec_w                	varchar2(10);
nr_seq_classif_agenda_w         	number(10);
cd_categoria_w                  	varchar2(10);
cd_tipo_acomodacao_w            	number(4);
nr_doc_convenio_w             	  	varchar2(20);
dt_validade_carteira_w          	date;
nr_seq_proc_interno_w           	number(10);
nr_seq_proc_interno_ww           	agenda_paciente.nr_seq_proc_interno%type;
nr_seq_status_pac_w           	  	number(10);
ie_lado_w                       	varchar2(1);
ds_laboratorio_w                	varchar2(80);	
cd_doenca_cid_w                	 	varchar2(10);
dt_nascimento_pac_w             	date;
nr_seq_sala_w                  		number(10);
nm_medico_externo_w             	varchar2(60);
ie_tipo_atendimento_w          		number(3);
cd_medico_req_w                 	varchar2(10);
nr_seq_pq_proc_w                	number(10);
nr_seq_indicacao_w              	number(10);
cd_pessoa_indicacao_w           	varchar2(10);
qt_prescricao_w				number(10);
nr_seq_proced_w				number(6,0);
ds_cirurgia_w				varchar2(500);
qt_peso_w				number(6,3);
nr_seq_status_pac_dest_w		number(10,0);
qt_altura_cm_w				number(5,2);
qt_autorizacoes_w			number(10);
cd_cnpj_prestador_w			varchar2(14);
cd_unidade_externa_w			varchar2(60);
ie_necessita_internacao_w		varchar2(1);
ie_anestesia_w				varchar2(1);
nr_seq_tipo_classif_pac_w		number(10,0);
nr_secao_w				number(10,0);
qt_total_secao_w			number(10,0);
cd_anestesista_w			varchar2(10);
qt_anexo_w				number(10,0);
crm_med_ext_w				varchar2(60);
nr_seq_motivo_agend_w			number(10,0);
nr_seq_classif_agenda_dest_w		number(10,0);
qt_autor_evento_w			number(10,0);
qt_avaliacao_w				number(10,0);
ds_protocolo_w				varchar2(255);
ie_reserva_leito_w              	varchar2(3);
ds_email_w				varchar2(255);
cd_tipo_anestesia_w			varchar2(2);
nr_seq_motivo_anest_w 			number(10,0);
dt_solic_medico_w			date;
cd_profissional_pref_w			agenda_paciente.cd_profissional_pref%type;
nr_seq_pepo_w				agenda_paciente.nr_seq_pepo%type;
cd_medico_req_proc_w				agenda_paciente_proc.cd_medico_req%type;
cd_autorizacao_w agenda_paciente_proc.cd_autorizacao%type;
ie_autorizacao_proc_w agenda_paciente_proc.ie_autorizacao%type;
nr_seq_segurado_w     agenda_paciente.nr_seq_segurado%type;


/* variaveis parametros */
ie_manut_proced_w			varchar2(1);
ie_duracao_copia_w			varchar2(1);
ie_duracao_transf_w			varchar2(1);
ie_user_orig_transf_w			varchar2(1);
ie_atend_copia_w			varchar2(1);
ie_atend_transf_w			varchar2(1);
ie_status_copia_w			varchar2(1);
nr_seq_status_pac_copia_w		number(10,0);
nr_seq_status_pac_transf_w		number(10,0);
ie_classif_orig_transf_w		varchar2(1);
ie_canc_agenda_transf_w			Varchar2(1)	:= 'N';
ie_medico_exec_transf_w			varchar2(1);
ie_medico_exec_copia_w			varchar2(1);
ie_observacao_copia_w			varchar2(1);
ie_observacao_trans_w			varchar2(1);
nr_doc_convenio_copia_w			varchar2(1);
nr_doc_convenio_transf_w		varchar2(1);
ie_campo_crm_med_ext_copia_w		varchar2(1);
ie_campo_crm_med_ext_transf_w		varchar2(1);
ie_campo_mot_agend_copia_w		varchar2(1);
ie_campo_mot_agend_transf_w		varchar2(1);
ie_campo_peso_copia_w			varchar2(1);
ie_campo_peso_transf_w			varchar2(1);
ie_campo_altura_copia_w			varchar2(1);
ie_campo_altura_transf_w		varchar2(1);
ie_campo_empresa_copia_w		varchar2(1);
ie_campo_empresa_transf_w		varchar2(1);
ie_campo_autorizacao_copia_w		varchar2(1);
ie_campo_autorizacao_transf_w		varchar2(1);
ie_campo_nm_med_ext_copia_w		varchar2(1);
ie_campo_nm_med_ext_trans_w		varchar2(1);
ie_historico_trans_w			varchar2(1);
ie_campo_classif_copia_w		varchar2(1);
ie_avaliacao_transf_w			varchar2(1);
ie_avaliacao_copia_w			varchar2(1);
qt_min_dur_tempo_proced_w		number(10) := 0;
qt_min_dur_tempo_proc_adic_w	number(10) := 0;
qt_tot_min_dur_proc_adic_w 		number(10) := 0;
qt_min_tot_agend_w				number(10) := 0;
ie_status_pac_transf_w			varchar2(1);
ie_status_pac_copia_w			varchar2(1);
nr_dias_futuros_w				number(10) := 0;
nr_dias_fut_agendamento_w		number(10) := 0;
ie_cons_regra_agend_dias_fut_w	varchar2(1);

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
IE_FORMA_AGENDAMENTO_w			number(10,0);

cd_empresa_ref_w			Number(10);
cd_Setor_atendimento_w			Number(5);
dt_confirmacao_w			date;
nm_usuario_confirm_w			varchar2(15);
ds_confirmacao_w     			varchar2(80);
nr_seq_forma_confirmacao_w   		number(10);

cd_setor_origem_w			number(5);
cd_setor_destino_w			number(5);
ds_motivo_transf_w			varchar2(255);

ie_sala_transf_w			varchar2(1);
ie_sala_copia_w				varchar2(1);
ie_utiliza_agfa_w			varchar2(1);
ie_lado_adic_w				varchar2(1);
cd_medico_adic_w			varchar2(10);
nr_seq_item_ageint_w			number(10);
ie_reserva_transf_w			varchar2(1);
nr_reserva_w				varchar2(20);

qt_integrada_w				number(10,0);
qt_historico_w				number(10,0);
ie_status_transf_w			varchar2(1);
ie_setor_transf_w			varchar2(1);
ie_procedencia_copia_w			varchar2(1);
ie_procedencia_transf_w			varchar2(1);
ie_setor_copia_w			varchar2(1);
cd_procedencia_w                	number(5);
cd_medico_exec_dest_w			varchar2(10);
ds_erro_w				varchar2(255);
ie_consiste_medico_w			varchar2(1);
ie_med_req_copia_w		varchar2(1);
ie_med_req_transf_w		varchar2(1);
qt_agendamentos_w		number(10);
qt_regra_w				number(10);
ie_cons_obito_pac_w		varchar2(1);
ie_consiste_medico_copia_w	varchar2(1);
ie_tipo_obito_pessoa_w	varchar2(1);
ds_mensagem_w			varchar2(255);
ie_se_hor_sobreposto_w	varchar2(1);
ie_consistir_sobrep_w	varchar2(1);
ie_cons_dur_proc_fim_turno_w	varchar2(1) := 'N';
ds_consistencia_fim_turno_w		varchar2(255) := '';
nr_sequencia_w varchar2(10);


cd_procedimento_w_regra		number(15,0);
ie_origem_proced_regra_w	number(10,0);
nr_seq_proc_interno_regra_w	number(10,0);
ie_lado_adic_regra_w		varchar2(1);
cd_medico_adic_regra_w		varchar2(10);
ds_retorno_w				varchar2(255);
ie_consentimento_informado_w	varchar2(1);
dt_agenda_dest_w 		date;

/* Evento */
nr_seq_evento_w				number(10,0);
qt_autor_cirur_w			number(10);

ie_regra_agenda_ep12_w		varchar2(1);
ds_param_integ_hl7_w		varchar2(2000);

ds_mensagem_bloq_w		varchar2(4000);
cd_medico_exec_regr_w		pessoa_fisica.cd_pessoa_fisica%type;
vl_coparticipacao_w		agenda_paciente_auxiliar.vl_coparticipacao%type;
vl_coparticipacao_adic_w	agenda_paciente_proc.vl_coparticipacao%type;
nr_seq_pac_aux_w		agenda_paciente_auxiliar.nr_sequencia%type;

/* cursores */
/* obter procedimentos adicionais */
cursor c01 is
	select	nr_seq_agenda,
		cd_procedimento,
			ie_origem_proced,
			nr_seq_proc_interno,
			ie_lado,
			cd_medico,
			cd_medico_req,
      cd_autorizacao,
      ie_autorizacao,
      vl_coparticipacao
	from	agenda_paciente_proc
	where	nr_sequencia = nr_seq_origem_p
	order by
			nr_seq_agenda;

/* Evento Transferencia da Agenda de Exames */	
Cursor C02 is
	select	a.nr_seq_evento
	from	regra_envio_sms a
	where	a.cd_estabelecimento	= cd_estabelecimento_p
	and		a.ie_evento_disp	= 'TAE'
	and		qt_idade_paciente_w between nvl(qt_idade_min,0)	and nvl(qt_idade_max,9999)
	and		nvl(a.ie_situacao,'A') = 'A';

begin
if	(cd_estabelecimento_p is not null) and
	(nr_seq_origem_p is not null) and
	(nr_seq_destino_p is not null) and
	(ie_acao_p is not null) and
	(nm_usuario_p is not null) then
	-- /* obter parametros */
	begin
    select nr_sequencia
	into nr_sequencia_w
    from agenda_paciente
    where nr_sequencia = nr_seq_destino_p;
     exception
     when no_data_found then
       Wheb_mensagem_pck.exibir_mensagem_abort(407737);
     end; 

	obter_param_usuario(820, 4, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p,nr_dias_futuros_w);	

	obter_param_usuario(820, 12, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p,ie_manut_proced_w);	

	Obter_Param_Usuario(869,31,obter_perfil_ativo,nm_usuario_p,cd_estabelecimento_p,ie_utiliza_agfa_w);

	Obter_Param_Usuario(820,40,obter_perfil_ativo,nm_usuario_p,cd_estabelecimento_p,ie_consiste_medico_w);

	Obter_Param_Usuario(820,250,obter_perfil_ativo,nm_usuario_p,cd_estabelecimento_p,ie_cons_obito_pac_w);

	Obter_Param_Usuario(820,379,obter_perfil_ativo,nm_usuario_p,cd_estabelecimento_p,ie_consiste_medico_copia_w);

	Obter_Param_Usuario(820,382,obter_perfil_ativo,nm_usuario_p,cd_estabelecimento_p,ie_cons_regra_agend_dias_fut_w);

	Obter_Param_Usuario(820,387,obter_perfil_ativo,nm_usuario_p,cd_estabelecimento_p,ie_cons_dur_proc_fim_turno_w);

	select 	nvl(max(ie_consiste_duracao),'I')
	into	ie_consistir_sobrep_w	
	from 	parametro_agenda
	where 	cd_estabelecimento = cd_estabelecimento_p;

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

	select	obter_parametro_agenda(cd_estabelecimento_p, 'NR_SEQ_STATUS_PAC_COPIA', null)
	into	nr_seq_status_pac_copia_w
	from	dual;

	select	obter_parametro_agenda(cd_estabelecimento_p, 'NR_SEQ_STATUS_PAC_TRANSF', null)
	into	nr_seq_status_pac_transf_w
	from	dual;

	select	obter_parametro_agenda(cd_estabelecimento_p, 'IE_CLASSIF_ORIG_TRANSF', 'N')
	into	ie_classif_orig_transf_w
	from	dual;

	select	obter_parametro_agenda(cd_estabelecimento_p, 'IE_SETOR_TRANSFERENCIA', 'N')
	into	ie_setor_transf_w
	from	dual;

	select	obter_parametro_agenda(cd_estabelecimento_p, 'IE_MEDICO_EXEC_TRANSF', 'S')
	into	ie_medico_exec_transf_w
	from	dual;

	select	obter_parametro_agenda(cd_estabelecimento_p, 'IE_MEDICO_EXEC_COPIA', 'S')
	into	ie_medico_exec_copia_w
	from	dual;

	select	obter_parametro_agenda(cd_estabelecimento_p, 'IE_CAMPO_SALA_COPIA', 'S')
	into	ie_sala_copia_w
	from	dual;

	select	obter_parametro_agenda(cd_estabelecimento_p, 'IE_CAMPO_SALA_TRANSF', 'S')
	into	ie_sala_transf_w
	from	dual;

	select 	obter_parametro_agenda(cd_estabelecimento_p, 'IE_DOC_CONV_COPIA', 'S')
	into	nr_doc_convenio_copia_w
	from 	dual;

	select 	obter_parametro_agenda(cd_estabelecimento_p, 'IE_DOC_CONV_TRANSF', 'N')
	into	nr_doc_convenio_transf_w
	from 	dual;

	select 	obter_parametro_agenda(cd_estabelecimento_p, 'IE_RESERVA_TRANSF', 'S')
	into	ie_reserva_transf_w
	from 	dual;

	ie_campo_crm_med_ext_copia_w	:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_CRM_EXT_COPIA', 'N');

	ie_campo_crm_med_ext_transf_w	:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_CRM_EXT_TRANSF', 'N');

	ie_campo_mot_agend_copia_w	:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_MOT_AGENDA_COPIA', 'N');

	ie_campo_mot_agend_transf_w	:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_MOT_AGENDA_TRANSF', 'N');

	ie_campo_peso_copia_w		:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_PESO_COPIA', 'N');

	ie_campo_peso_transf_w		:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_PESO_TRANSF', 'N');

	ie_campo_altura_copia_w		:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_ALTURA_COPIA', 'N');

	ie_campo_altura_transf_w	:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_ALTURA_TRANSF', 'N');

	ie_campo_empresa_copia_w	:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_EMPRESA_COPIA', 'N');

	ie_campo_empresa_transf_w	:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_EMPRESA_TRANSF', 'N');

	ie_campo_autorizacao_copia_w	:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_AUTORIZACAO_COPIA', 'N');

	ie_campo_autorizacao_transf_w	:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_AUTORIZACAO_TRANSF', 'N');

	ie_campo_nm_med_ext_copia_w	:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_MEDICO_EXT_COPIA', 'N');

	ie_campo_nm_med_ext_trans_w	:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_MEDICO_EXT_TRANSF', 'N');	

	ie_observacao_copia_w		:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_OBS_COPIA', 'S');

	ie_observacao_trans_w		:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_OBS_TRANSFERENCIA', 'S');

	ie_historico_trans_w		:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_HISTORICO_TRANSF', 'N');

	ie_setor_copia_w 		:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_SETOR_COPIA', 'N');

	ie_procedencia_transf_w		:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_PROCEDENCIA_TRANSF', 'N');

	ie_procedencia_copia_w		:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_PROCEDENCIA_COPIA', 'N');

	ie_campo_classif_copia_w 	:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_CLASSIF_ORIG_COPIA', 'S');	

	ie_avaliacao_transf_w		:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_AVALIACAO_TRANSF', 'N');

	ie_avaliacao_copia_w		:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_AVALIACAO_COPIA', 'N');

	ie_med_req_copia_w		:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_MEDICO_REQ_COPIA', 'S');

	ie_med_req_transf_w		:= obter_parametro_agenda(cd_estabelecimento_p, 'IE_MEDICO_REQ_TRANSF', 'S');

	/* obter dados origem */
	select	cd_agenda,
		cd_pessoa_fisica,
		hr_inicio,
		nr_minuto_duracao,
		cd_medico,
		nm_pessoa_contato,
		cd_procedimento,
		ds_observacao,
		cd_convenio,
		qt_idade_paciente,
		ie_origem_proced,
		ie_status_agenda,
		ds_senha,
		nm_paciente,
		nr_atendimento,
		cd_usuario_convenio,
		dt_agendamento,
		nm_usuario_orig,
		qt_idade_mes,
		cd_plano,
		nr_telefone,
		ie_autorizacao,
		vl_previsto,
		nr_seq_age_cons,
		cd_medico_exec,
		nr_seq_classif_agenda,
		cd_procedencia,
		cd_categoria,
		cd_tipo_acomodacao,
		nr_doc_convenio,
		dt_validade_carteira,
		nr_seq_proc_interno,
		nr_seq_status_pac,
		ie_lado,
		ds_laboratorio,
		cd_doenca_cid,
		dt_nascimento_pac,
		nr_seq_sala,
		nm_medico_externo,
		ie_tipo_atendimento,
		cd_medico_req,
		nr_seq_pq_proc,
		nr_seq_indicacao,
		cd_pessoa_indicacao,
		ds_cirurgia,
		qt_peso,
		qt_altura_cm,
		IE_FORMA_AGENDAMENTO,
		cd_empresa_ref,
		cd_Setor_atendimento,
		dt_confirmacao,
		nm_usuario_confirm,
		ds_confirmacao,     
		nr_seq_forma_confirmacao,
		cd_setor_origem,
		cd_setor_destino,
		cd_cnpj_prestador,
		cd_unidade_externa,
		ie_necessita_internacao,
		ie_anestesia,
		nr_seq_tipo_classif_pac,
		nr_secao,
		qt_total_secao,
		cd_anestesista,
		nm_usuario,
		nr_reserva,
		crm_medico_externo,
		nr_seq_motivo_agendamento,
		qt_idade_meses,
		ds_protocolo,
		ie_reserva_leito,
		ds_email,
		cd_tipo_anestesia,
		nr_seq_motivo_anest,
		dt_solic_medico,
		cd_profissional_pref,
		nr_seq_segurado,
		(select max(x.vl_coparticipacao) from agenda_paciente_auxiliar x where x.nr_seq_agenda = nr_seq_origem_p)
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
		qt_idade_mes_w,
		cd_plano_w,
		nr_telefone_w,
		ie_autorizacao_w,
		vl_previsto_w,
		nr_seq_age_cons_w,
		cd_medico_exec_w,
		nr_seq_classif_agenda_w,
		cd_procedencia_w,
		cd_categoria_w,
		cd_tipo_acomodacao_w,
		nr_doc_convenio_w,
		dt_validade_carteira_w,
		nr_seq_proc_interno_w,
		nr_seq_status_pac_w,
		ie_lado_w,
		ds_laboratorio_w,
		cd_doenca_cid_w,
		dt_nascimento_pac_w,
		nr_seq_sala_w,
		nm_medico_externo_w,
		ie_tipo_atendimento_w,
		cd_medico_req_w,
		nr_seq_pq_proc_w,
		nr_seq_indicacao_w,
		cd_pessoa_indicacao_w,
		ds_cirurgia_w,
		qt_peso_w,
		qt_altura_cm_w,
		IE_FORMA_AGENDAMENTO_w,
		cd_empresa_ref_w,
		cd_Setor_atendimento_w,
		dt_confirmacao_w,
		nm_usuario_confirm_w,
		ds_confirmacao_w,
		nr_seq_forma_confirmacao_w ,
		cd_setor_origem_w,
		cd_setor_destino_w,
		cd_cnpj_prestador_w,
		cd_unidade_externa_w,
		ie_necessita_internacao_w,
		ie_anestesia_w,
		nr_seq_tipo_classif_pac_w,
		nr_secao_w,
		qt_total_secao_w,
		cd_anestesista_w,
		nm_usuario_ant_w,
		nr_reserva_w,
		crm_med_ext_w,
		nr_seq_motivo_agend_w,
		qt_idade_meses_w,
		ds_protocolo_w,
		ie_reserva_leito_w,
		ds_email_w,
		cd_tipo_anestesia_w,
		nr_seq_motivo_anest_w,
		dt_solic_medico_w,
		cd_profissional_pref_w,
		nr_seq_segurado_w,
		vl_coparticipacao_w
	from	agenda_paciente
	where	nr_sequencia = nr_seq_origem_p;

	/*obter dados do fanep*/
	select	nr_seq_pepo
	into	nr_seq_pepo_w
	from	agenda_paciente
	where	nr_sequencia = nr_seq_origem_p
	and	obter_tipo_agenda(cd_agenda_w) = 2;

	/* obter dados destino */
	select	max(cd_agenda),
			max(hr_inicio),
			max(nr_seq_classif_agenda),
			max(cd_medico_exec),
			max(nr_minuto_duracao),
			max(nr_seq_proc_interno),
			max(cd_procedimento),
			max(ie_origem_proced),
			max(dt_agenda)
	into	cd_agenda_destino_w,
			hr_destino_w,
			nr_seq_classif_agenda_dest_w,
			cd_medico_exec_dest_w,			
			nr_minuto_duracao_www,
			nr_seq_proc_interno_ww,
			cd_procedimento_ww,
			ie_origem_proced_ww,
			dt_agenda_dest_w
	from	agenda_paciente
	where	nr_sequencia	= nr_seq_destino_p;



	/* Consistir regra de dias futuros para agendamento */
	select	nvl(max(nr_dias_fut_agendamento),0)
	into	nr_dias_fut_agendamento_w
	from	agenda
	where	cd_agenda = cd_agenda_destino_w;

	/* consiste do cadastro da agenda */
	if 	(nr_dias_fut_agendamento_w = 0) and
		(nvl(nr_dias_futuros_w,0) > 0) and
		(ie_cons_regra_agend_dias_fut_w = 'S') and
		(trunc(hr_destino_w) > trunc(sysdate + nr_dias_futuros_w)) then
		Wheb_mensagem_pck.exibir_mensagem_abort(354616, 'NR_DIAS_FUTUROS_W=' || nr_dias_futuros_w);
	end if;

	/* consiste do parametro */
	if  (ie_cons_regra_agend_dias_fut_w = 'S') and
		(nr_dias_fut_agendamento_w > 0) and
		(trunc(hr_destino_w) > trunc(sysdate + nr_dias_fut_agendamento_w)) then
		Wheb_mensagem_pck.exibir_mensagem_abort(354709, 'NR_DIAS_FUT_AGENDAMENTO_W=' || nr_dias_fut_agendamento_w);
	end if;	

	Consistir_qtd_conv_regra(nr_seq_destino_p, cd_convenio_w, hr_destino_w, cd_agenda_destino_w, cd_pessoa_fisica_w, cd_categoria_w, cd_plano_w, cd_estabelecimento_p, nm_usuario_p, null, null, nr_seq_proc_interno_w, qt_agendamentos_w, qt_regra_w, ds_mensagem_w);

	--Consistir se consentimento informado
	select	decode(count(*),0,'N','S')
	into	ie_consentimento_informado_w
	from	pep_pac_ci
	where	nr_seq_agenda = nr_seq_origem_p;

	if	(ie_consentimento_informado_w = 'S') then
		--O agendamento de origem possui consentimento registrado! Favor verificar se e necessario gerar para o novo agendamento.
		ds_retorno_w := obter_desc_expressao_idioma(671390, null, philips_param_pck.get_nr_seq_idioma);
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

	if	(nr_seq_proc_interno_ww is not null) and
		(cd_procedimento_ww is not null) and
		(ie_origem_proced_ww is not null) and
		(ie_manut_proced_w = 'N')then
		cd_procedimento_w 		:= cd_procedimento_ww;
		ie_origem_proced_w 		:= ie_origem_proced_ww;
		nr_seq_proc_interno_w	:= nr_seq_proc_interno_ww;		
	end if;
	if (ie_altera_medico_p = 'S') and (cd_medico_exec_w <> '0') then
		cd_medico_exec_regr_w := cd_medico_exec_w;
	end if;
	ds_mensagem_bloq_w := obter_msg_bloq_geral_agenda_js (cd_estabelecimento_p,
				cd_agenda_destino_w,
				nr_seq_origem_p,
				null,
				hr_destino_w,
				'N',
				'N',
				nr_seq_proc_interno_w,
				cd_procedimento_w,
				ie_origem_proced_w,
				null,
				null,
				cd_medico_exec_regr_w);

	if (ds_mensagem_bloq_w is not null) then
		Wheb_mensagem_pck.exibir_mensagem_abort(ds_mensagem_bloq_w);
	end if;

	if	(ie_acao_p = 'C') then

		if	(nr_doc_convenio_copia_w = 'N') then
			nr_doc_convenio_w := '';
		end if;		

		if	(ie_campo_mot_agend_copia_w = 'N') then
			nr_seq_motivo_agend_w := '';
		end if;			

		if	(ie_campo_crm_med_ext_copia_w = 'N') then
			crm_med_ext_w := '';
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

		if	(ie_campo_nm_med_ext_copia_w	= 'N') then
			nm_medico_externo_w := '';		
		end if;

		if	(ie_sala_copia_w = 'N') then
			nr_seq_sala_w	:= '';
		end if;


		if	(ie_medico_exec_copia_w = 'N') then
			cd_medico_exec_w 	:= '';
		end if;

		if	(cd_medico_exec_w is not null) then
			select	max(cd_medico)
			into	cd_medico_exec_w
			from	agenda_medico
			where	cd_agenda = cd_agenda_destino_w
			and	cd_medico = cd_medico_exec_w
			and	nvl(ie_situacao,'A') = 'A';
		end if;

		if	(ie_duracao_copia_w = 'S') then
			ie_manter_duracao_w := 'S';
		elsif	(ie_duracao_copia_w = 'P') then
			select	obter_se_mantem_duracao_agenda(cd_agenda_destino_w,nr_seq_destino_p,hr_destino_w,nr_minuto_duracao_w)
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

		nr_secao_w		:= nr_secao_w + 1;

		if	(nr_secao_w <= qt_total_secao_w) then
			nr_secao_w	:= nr_secao_w;
		else
			nr_secao_w	:= '';
			qt_total_secao_w	:= '';
		end if;

		if	(ie_setor_copia_w	= 'A') then
			cd_setor_atendimento_w	:= obter_setor_agenda(cd_agenda_destino_w);
		elsif	(ie_setor_copia_w	= 'N') then
			cd_setor_atendimento_w	:= null;
		elsif	(ie_setor_copia_w	= 'E') then
			cd_setor_atendimento_w	:= obter_setor_agenda(cd_agenda_destino_w);
		end if;

		if	(ie_procedencia_copia_w = 'N') then
			cd_procedencia_w := null;
		end if;	

		if	(ie_campo_classif_copia_w	= 'N') then
			nr_seq_classif_agenda_w := nr_seq_classif_agenda_dest_w;		
		end if;		

		if	(ie_med_req_copia_w = 'N')then
			cd_medico_w := null;
		end if;

	elsif	(ie_acao_p = 'T') then

		begin

		if	(nr_doc_convenio_transf_w = 'N') then
			nr_doc_convenio_w := '';
		end if;		

		/* OS 96088 - Jerusa em 10/06/2008 */
		if	(ie_status_agenda_w = 'C') then
			Wheb_mensagem_pck.exibir_mensagem_abort(262522);
		end if;

		if	(ie_duracao_transf_w = 'S') then
			ie_manter_duracao_w := 'S';
		elsif	(ie_duracao_transf_w = 'P') then
			select	obter_se_mantem_duracao_agenda(cd_agenda_destino_w,nr_seq_destino_p,hr_destino_w,nr_minuto_duracao_w)
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

		if	(ie_consiste_medico_w <> 'N') and  (nvl(ie_altera_medico_p,'N') <> 'S') then
			cd_medico_exec_w 	:= '';
		elsif	(ie_consiste_medico_w = 'N') and
			(ie_medico_exec_transf_w = 'N') then
			cd_medico_exec_w 	:= '';
		end if;

		if	(ie_sala_transf_w = 'N') then
			nr_seq_sala_w	:= '';
		end if;

		if	(ie_campo_crm_med_ext_transf_w = 'N') then
			crm_med_ext_w	:= '';
		end if;

		if	(ie_campo_mot_agend_transf_w = 'N') then
			nr_seq_motivo_agend_w := '';
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

		if	(ie_campo_nm_med_ext_trans_w	= 'N') then
			nm_medico_externo_w := '';		
		end if;	

		if	(ie_observacao_trans_w = 'N') then
			ds_observacao_w	:= '';
		end if;

		if	(ie_setor_transf_w	= 'A') then
			cd_setor_atendimento_w	:= obter_setor_agenda(cd_agenda_destino_w);
		elsif	(ie_setor_transf_w	= 'N') then
			cd_setor_atendimento_w	:= null;
		elsif	(ie_setor_transf_w = 'E') then
			cd_setor_atendimento_w	:= obter_setor_agenda(cd_agenda_destino_w);
		end if;

		if	(ie_procedencia_transf_w = 'N') then
			cd_procedencia_w := null;
		end if;		

		if	(ie_med_req_transf_w = 'N')then
			cd_medico_w := null;
		end if;

		select	count(*)
		into	qt_anexo_w
		from	anexo_agenda
		where	nr_seq_agenda	= nr_seq_origem_p;

		if	(qt_anexo_w > 0) then

			update	anexo_agenda
			set	nr_seq_agenda	= nr_seq_destino_p
			where	nr_seq_agenda	= nr_seq_origem_p;

		end if;

		end;
	end if;

	if	(ie_consiste_medico_copia_w = 'S') and
		(ie_acao_p = 'C') and
		(nvl(cd_medico_exec_w,' ') <> nvl(cd_medico_exec_dest_w,' ')) then
		wheb_mensagem_pck.exibir_mensagem_abort(215671);
	end if;

	/* OS 96088 - Jerusa em 10/06/2008 */
	select	decode(ie_acao_p,'C', decode(nr_seq_status_pac_copia_w, null, nr_seq_status_pac_w, nr_seq_status_pac_copia_w),
			decode(nr_seq_status_pac_transf_w, null, nr_seq_status_pac_w, nr_seq_status_pac_transf_w))
	into	nr_seq_status_pac_dest_w
	from	dual;

	if	(ie_setor_transf_w	= 'A') then
		cd_Setor_atendimento_w	:= obter_setor_agenda(cd_agenda_destino_w);
	elsif	(ie_setor_transf_w	= 'N') then
		cd_setor_atendimento_w	:= '';
	elsif	(ie_setor_transf_w = 'E') then
		cd_setor_atendimento_w	:= obter_setor_agenda(cd_agenda_destino_w);
	end if;

	if	(ie_altera_medico_p = 'S') then
		cd_medico_exec_dest_w	:= nvl(cd_medico_exec_w,cd_medico_exec_dest_w);
	end if;
	consistir_executor_agenda(2,
				cd_agenda_destino_w,
				nr_seq_destino_p,
				cd_medico_exec_dest_w,
				cd_pessoa_fisica_w,
				qt_idade_paciente_w,
				ds_erro_w);
	if	(ds_erro_w is not null) then
		Wheb_mensagem_pck.exibir_mensagem_abort( 262328 , 'DS_MENSAGEM='||ds_erro_w);
	end if;	

	if	(ie_cons_obito_pac_w = 'S')then

		select	nvl(obter_se_paciente_obito(cd_pessoa_fisica_w), 'N')
		into	ie_tipo_obito_pessoa_w
		from	dual;

		if	(ie_tipo_obito_pessoa_w <> 'N') and
			(ie_tipo_obito_pessoa_w = 'A')then
			--Este paciente possui um atendimento com motivo de alta obito!
			wheb_mensagem_pck.exibir_mensagem_abort(223085);
		elsif	(ie_tipo_obito_pessoa_w <> 'N') and
				(ie_tipo_obito_pessoa_w = 'C')then
			--Este paciente possui data de obito informada no cadastro de pessoas!
			wheb_mensagem_pck.exibir_mensagem_abort(223086);		
		end if;

	end if;




	/*Consistir a regra 'Tempo Proced' ao efetuar a copia/transferencia*/
	if	(cd_agenda_destino_w is not null)then
		begin		
		select	obter_tempo_duracao_proced(	cd_agenda_destino_w,
											cd_medico_exec_dest_w,
											cd_procedimento_w,
											ie_origem_proced_w,
											cd_pessoa_fisica_w,
											nr_seq_proc_interno_w,
											ie_lado_w,
											cd_convenio_w,
											cd_categoria_w,
											cd_plano_w,
											nr_seq_destino_p,
											null)
		into	qt_min_dur_tempo_proced_w
		from	dual;
		exception
		when others then
			qt_min_dur_tempo_proced_w := 0;	
		end;	
	end if;	

	/*Consistir a regra 'Tempo Proced' ao efetuar a copia/transferencia para os procedimentos adicionais*/
	open c01;
	loop
	fetch c01 into	nr_seq_proced_w,
					cd_procedimento_w_regra,
					ie_origem_proced_regra_w,
					nr_seq_proc_interno_regra_w,
					ie_lado_adic_regra_w,
					cd_medico_adic_regra_w,
					cd_medico_req_proc_w,
					cd_autorizacao_w,
					ie_autorizacao_proc_w,
					vl_coparticipacao_adic_w;
	exit when c01%notfound;
		begin						
		if	(cd_agenda_destino_w is not null)then
			begin		
			select	obter_tempo_duracao_proced(	cd_agenda_destino_w,
												nvl(cd_medico_adic_w, cd_medico_exec_dest_w),
												cd_procedimento_w_regra,
												ie_origem_proced_regra_w,
												cd_pessoa_fisica_w,
												nr_seq_proc_interno_regra_w,
												ie_lado_adic_regra_w,
												cd_convenio_w,
												cd_categoria_w,
												cd_plano_w,
												nr_seq_destino_p,
												null)
			into	qt_min_dur_tempo_proc_adic_w
			from	dual;
			exception
			when others then
				qt_min_dur_tempo_proc_adic_w := 0;	
			end;	

		qt_tot_min_dur_proc_adic_w	:= qt_tot_min_dur_proc_adic_w + qt_min_dur_tempo_proc_adic_w;
		end if;			
		end;
	end loop;
	close c01;		

	qt_min_tot_agend_w	:= qt_min_dur_tempo_proced_w + qt_tot_min_dur_proc_adic_w;	
	/*Consistir sobreposicao de horarios caso o proximo agendamento nao estiver livre*/
	if	(ie_consistir_sobrep_w = 'I') then

		select	nvl(obter_se_sobreposicao_horario(cd_agenda_destino_w, hr_destino_w, qt_min_tot_agend_w), 'N')
		into	ie_se_hor_sobreposto_w
		from	dual;

		if (ie_se_hor_sobreposto_w = 'S')then 
			Wheb_mensagem_pck.exibir_mensagem_abort(262523);
		end if;		
	end if;

	/*Consistir a duracao do exame principal/adicionais de acordo com a duracao do final do turno*/
	if	(ie_cons_dur_proc_fim_turno_w = 'S')then
		begin

		select	nvl(decode(nvl(qt_min_tot_agend_w, 0), 0, decode(ie_manter_duracao_w,'S',nr_minuto_duracao_w, nr_minuto_duracao_www), qt_min_tot_agend_w),0)
		into	nr_min_dur_fim_turno_w
		from	dual;

		Consistir_dur_marcacao_exames(	hr_destino_w,
										cd_agenda_destino_w,
										nm_usuario_p,
										nr_min_dur_fim_turno_w,
										nr_seq_destino_p,
										null,
										null,
										ds_consistencia_fim_turno_w);										
		exception
		when others then
			ds_consistencia_fim_turno_w := '';
		end;

		if	(ds_consistencia_fim_turno_w is not null)then
			Wheb_mensagem_pck.exibir_mensagem_abort( 262328 , 'DS_MENSAGEM='||ds_consistencia_fim_turno_w);			
		end if;

	end if;	

	if	(wheb_usuario_pck.is_evento_ativo('220') = 'S') and
		(verifica_proced_integracao(nr_seq_proc_interno_w, cd_procedimento_w, ie_origem_proced_w, 46) = 'S') then

		select	decode(count(*),0,'N','S')
		into	ie_regra_agenda_ep12_w
		from	REGRA_AGENDA_EP12 a
		where	a.cd_agenda = cd_agenda_w;

		if	(ie_regra_agenda_ep12_w = 'S') then
			ds_param_integ_hl7_w :=	'cd_pessoa_fisica=' || cd_pessoa_fisica_w || obter_separador_bv ||
									'nr_sequencia=' || nr_seq_destino_p || obter_separador_bv;

			gravar_agend_integracao(220, ds_param_integ_hl7_w);
		end if;

	end if;	

	/* gerar dados destino */
	update	agenda_paciente
	set	cd_pessoa_fisica		= cd_pessoa_fisica_w,
		nr_minuto_duracao		= decode(nvl(qt_min_tot_agend_w, 0), 0, decode(ie_manter_duracao_w,'S',nr_minuto_duracao_w,nr_minuto_duracao), qt_min_tot_agend_w),		
		nm_usuario				= nm_usuario_p,
		dt_atualizacao			= sysdate,
		cd_medico				= cd_medico_w,
		nm_pessoa_contato		= nm_pessoa_contato_w,
		cd_procedimento			= cd_procedimento_w,
		ds_observacao			= ds_observacao_w,
		cd_convenio				= cd_convenio_w,
		qt_idade_paciente		= qt_idade_paciente_w,
		qt_idade_meses			= qt_idade_meses_w,
		ie_origem_proced		= ie_origem_proced_w,
		ie_status_agenda		= decode(ie_manter_status_w,'S', ie_status_agenda_w,'N'),
		dt_confirmacao			= decode(ie_manter_status_w,'S', dt_confirmacao_w,null),
		nm_usuario_confirm		= decode(ie_manter_status_w,'S', nm_usuario_confirm_w,null),
		ds_confirmacao     		= decode(ie_manter_status_w,'S', ds_confirmacao_w,null),
		nr_seq_forma_confirmacao	= decode(ie_manter_status_w,'S', nr_seq_forma_confirmacao_w,null),
		ds_senha				= ds_senha_w,
		nm_paciente				= nm_paciente_w,
		nr_atendimento			= decode(ie_manter_atend_w,'S',nr_atendimento_w,null),
		cd_usuario_convenio		= cd_usuario_convenio_w,
		nm_usuario_orig			= decode(ie_manter_usuario_w,'S',nm_usuario_orig_w,nm_usuario_p),
		qt_idade_mes			= qt_idade_mes_w,
		cd_plano				= cd_plano_w,
		nr_telefone				= nr_telefone_w,
		dt_agendamento			= decode(ie_acao_p,'T',dt_agendamento_w,sysdate),
		ie_autorizacao			= ie_autorizacao_w,
		vl_previsto				= vl_previsto_w,
		nr_seq_age_cons			= nr_seq_age_cons_w,
		cd_medico_exec			= decode(ie_altera_medico_p,'S',nvl(cd_medico_exec_w,cd_medico_exec),cd_medico_exec),
		cd_procedencia			= cd_procedencia_w,
		cd_categoria			= cd_categoria_w,
		cd_tipo_acomodacao		= cd_tipo_acomodacao_w,
		nr_doc_convenio			= nr_doc_convenio_w,
		dt_validade_carteira	= dt_validade_carteira_w,
		nr_seq_proc_interno		= nr_seq_proc_interno_w,
		nr_seq_status_pac		= nr_seq_status_pac_dest_w,
		ie_lado					= ie_lado_w,
		ds_laboratorio			= ds_laboratorio_w,
		cd_doenca_cid			= cd_doenca_cid_w,
		dt_nascimento_pac		= dt_nascimento_pac_w,
		nr_seq_sala				= nvl(nr_seq_sala_w,nr_seq_sala),
		nm_medico_externo		= nm_medico_externo_w,
		ie_tipo_atendimento		= ie_tipo_atendimento_w,
		cd_medico_req			= cd_medico_req_w,
		nr_seq_pq_proc			= nr_seq_pq_proc_w,
		nr_seq_indicacao		= nr_seq_indicacao_w,
		cd_pessoa_indicacao		= cd_pessoa_indicacao_w,
		ds_cirurgia				= ds_cirurgia_w,
		nr_seq_motivo_transf	= nr_seq_motivo_p,
		ds_motivo_copia_trans	= ds_motivo_p,
		dt_copia_trans			= sysdate,
		nm_usuario_copia_trans	= nm_usuario_p,
		qt_peso					= qt_peso_w,
		qt_altura_cm			= qt_altura_cm_w,
		nr_seq_classif_agenda	= decode(ie_classif_orig_transf_w, 'S', nr_seq_classif_agenda_w, nr_seq_classif_agenda),
		IE_FORMA_AGENDAMENTO	= IE_FORMA_AGENDAMENTO_w,
		cd_empresa_ref			= cd_empresa_ref_w,
		cd_setor_atendimento	= cd_Setor_Atendimento_w,
		cd_setor_origem			= cd_setor_origem_w,
		cd_setor_destino		= cd_setor_destino_w,
		cd_cnpj_prestador		= cd_cnpj_prestador_w,
		cd_unidade_externa		= cd_unidade_externa_w,
		ie_necessita_internacao	= ie_necessita_internacao_w,
		ie_anestesia			= ie_anestesia_w,
		nr_seq_tipo_classif_pac	= nr_seq_tipo_classif_pac_w,
		nr_secao				= nr_secao_w,
		qt_total_secao			= qt_total_secao_w,
		cd_anestesista			= cd_anestesista_w,
		nr_reserva				= decode(ie_reserva_transf_w, 'S', nr_reserva_w, null),
		crm_medico_externo		= crm_med_ext_w,
		nr_seq_motivo_agendamento	= nr_seq_motivo_agend_w,
		ie_transferido				= decode(ie_acao_p,'T','S','N'),
		ds_protocolo				= ds_protocolo_w,
		ie_reserva_leito		= decode(ie_acao_p,'T',ie_reserva_leito_w, ie_reserva_leito),
		ds_email			= ds_email_w,
		cd_tipo_anestesia		= decode(ie_acao_p,'T',cd_tipo_anestesia_w, cd_tipo_anestesia),
		nr_seq_motivo_anest		= decode(ie_acao_p,'T',nr_seq_motivo_anest_w, nr_seq_motivo_anest),
		dt_solic_medico			= dt_solic_medico_w,
		cd_profissional_pref		= cd_profissional_pref_w,
		nr_seq_pepo			= decode(ie_acao_p, 'T', nr_seq_pepo_w, null),
		nr_seq_segurado     = nr_seq_segurado_w
	where	nr_sequencia			= nr_seq_destino_p;


	if (nvl(vl_coparticipacao_w,0) > 0) then
		select 	max(nr_sequencia)
		into 	nr_seq_pac_aux_w
		from 	agenda_paciente_auxiliar apa
		where 	apa.nr_seq_agenda = nr_seq_destino_p;

		if (nvl(nr_seq_pac_aux_w,0) > 0) then
			update	agenda_paciente_auxiliar
			set	vl_coparticipacao = vl_coparticipacao_w
			where 	nr_sequencia = nr_seq_pac_aux_w;
		else 
			INSERT INTO agenda_paciente_auxiliar (
					nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					vl_coparticipacao,
					nr_seq_agenda)
				values(	agenda_paciente_auxiliar_seq.nextval,
					sysdate,
					nm_usuario_p,
					sysdate,
					nm_usuario_p,
					vl_coparticipacao_w,
					nr_seq_destino_p
				);
		end if;
	end if;

	if	(ie_acao_p = 'T' and nr_seq_pepo_w is not null)  then

	update	pepo_cirurgia
	set	dt_cirurgia 			= hr_destino_w
	where	nr_sequencia 			= nr_seq_pepo_w;

	end if;

	if	(ie_acao_p = 'T') and
		(ie_historico_trans_w = 'S') then

		select	count(*)
		into	qt_historico_w
		from	agenda_pac_hist
		where	nr_seq_agenda	= nr_seq_origem_p;

		if	(qt_historico_w > 0) then
			update	agenda_pac_hist
			set	nr_seq_agenda	=	nr_seq_destino_p,
				nm_usuario	=	nm_usuario_p,
				dt_atualizacao	=	sysdate
			where	nr_seq_agenda	=	nr_seq_origem_p;	
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
		fetch c01 into	nr_seq_proced_w,
					cd_procedimento_w,
					ie_origem_proced_w,
					nr_seq_proc_interno_w,
					ie_lado_adic_w,
					cd_medico_adic_w,
					cd_medico_req_proc_w,
					cd_autorizacao_w,
					ie_autorizacao_proc_w,
					vl_coparticipacao_adic_w;
		exit when c01%notfound;
			begin
			/* obter sequencia */
			if	(ie_manut_proced_w <> 'S') then
			        if	(ie_campo_autorizacao_copia_w = 'N' and ie_acao_p = 'C') or 
					(ie_campo_autorizacao_transf_w = 'N' and ie_acao_p = 'T') then
				      	cd_autorizacao_w := '';
			      	end if;	
			        if	(nr_doc_convenio_copia_w = 'N' and ie_acao_p = 'C') or 
					(nr_doc_convenio_transf_w = 'N' and ie_acao_p = 'T') then
				      	ie_autorizacao_proc_w := '';
	      			end if;	
		    	end if;

			insert into agenda_paciente_proc	(
								nr_sequencia,
								nr_seq_agenda,
								cd_procedimento,
								ie_origem_proced,
								nr_seq_proc_interno,
								dt_atualizacao,
								nm_usuario,
								ie_lado,
								cd_medico,
								cd_medico_req,
						                cd_autorizacao,
                						ie_autorizacao,
								vl_coparticipacao
								)
							values	(
								nr_seq_destino_p,
								nr_seq_proced_w,
								cd_procedimento_w,
								ie_origem_proced_w,
								nr_seq_proc_interno_w,
								sysdate,
								nm_usuario_p,
								ie_lado_adic_w,
								cd_medico_adic_w,
								cd_medico_req_proc_w,
                						cd_autorizacao_w,
                						ie_autorizacao_proc_w,
								vl_coparticipacao_adic_w
								);
			end;
		end loop;
		close c01;
	end if;

	if	(ie_acao_p = 'T') then
		/* verificar prescricoes vinculadas */
		select	count(*)
		into	qt_prescricao_w
		from	prescr_medica
		where	nr_seq_agenda = nr_seq_origem_p;

		/* atualizar prescricoes vinculadas */
		if	(qt_prescricao_w > 0) then
			update	prescr_medica
			set	nr_seq_agenda = nr_seq_destino_p
			where	nr_seq_agenda = nr_seq_origem_p;
		end if;

		cpoe_transferir_agenda( nr_seq_origem_p, nr_seq_destino_p);

		if	(ie_avaliacao_transf_w = 'S') then
			select	count(*)
			into	qt_avaliacao_w
			from	med_avaliacao_paciente
			where	nr_seq_agenda_pac = nr_seq_origem_p;

			if	(qt_avaliacao_w > 0) then
				update	med_avaliacao_paciente
				set	nr_seq_agenda_pac = nr_seq_destino_p
				where	nr_seq_agenda_pac = nr_seq_origem_p;
			end if;

		end if;

		if (ie_utiliza_agfa_w <> 'S') then
			/* verificar autorizacoes vinculadas */
			select	count(*)
			into	qt_autorizacoes_w
			from	autorizacao_convenio
			where	nr_seq_agenda = nr_seq_origem_p;

			/* atualizar autorizacoes vinculadas */
			if	(qt_autorizacoes_w > 0) then
				update	autorizacao_convenio
				set	nr_seq_agenda = nr_seq_destino_p,
					dt_agenda 	= dt_agenda_dest_w
				where	nr_seq_agenda = nr_seq_origem_p;

				update procedimento_autorizado
				set	nr_seq_agenda	 = nr_seq_destino_p
				where	nr_seq_Agenda	= nr_seq_origem_p;
			end if;		

			select	count(*)
			into	qt_autor_evento_w
			from	autor_convenio_evento
			where	nr_seq_agenda = nr_seq_origem_p;

			if	(qt_autor_evento_w > 0) then
				update	autor_convenio_evento
				set	nr_seq_agenda = nr_seq_destino_p
				where	nr_seq_agenda = nr_seq_origem_p;
			end if;

		end if;

		update	agenda_pac_opme
		set	nr_seq_agenda = nr_seq_destino_p
		where	nr_seq_agenda = nr_seq_origem_p;

		update	aval_pre_anestesica
		set	nr_seq_agenda = nr_seq_destino_p
		where	nr_seq_agenda = nr_seq_origem_p;		

		select	count(*)
		into	qt_autor_cirur_w
		from	autorizacao_cirurgia
		where	nr_seq_agenda = nr_seq_origem_p;

		if	(qt_autor_cirur_w	> 0) then
			update	autorizacao_cirurgia
			set		nr_seq_agenda	= nr_seq_destino_p
			where	nr_seq_agenda	= nr_seq_origem_p;
		end if;

		/* gerar historico */
		atrib_oldvalue_w := substr(obter_nome_agenda(cd_agenda_w),1,50);
		atrib_newvalue_w := substr(obter_nome_agenda(cd_agenda_destino_w),1,50);

		if	(nr_seq_motivo_p > 0) then
			ds_motivo_transf_w	:= wheb_mensagem_pck.get_texto(306787, 'DS_MOTIVO_AGENDA=' || substr(obter_desc_motivo_agenda(nr_seq_motivo_p),1,255)); --  Motivo: #@DS_MOTIVO_AGENDA#@ -
		end if;

		gerar_agenda_paciente_hist(cd_agenda_destino_w,nr_seq_origem_p,'T',nm_usuario_p, wheb_mensagem_pck.get_texto(306780, 	'ATRIB_OLDVALUE_W=' || atrib_oldvalue_w || ';' ||
																																'HR_INICIO=' || to_char(hr_inicio_w,'dd/mm/yyyy hh24:mi:ss') || ';' ||
																																'ATRIB_NEWVALUE_W=' || atrib_newvalue_w || ';' ||
																																'HR_DESTINO=' || to_char(hr_destino_w,'dd/mm/yyyy hh24:mi:ss') || ';' ||
																																'DS_MOTIVO_TRANSF_W=' || ds_motivo_transf_w || ';' ||
																																'DS_MOTIVO_P=' || substr(ds_motivo_p,1,255) || ';' ||
																																'NM_USUARIO_ANT_W=' || nm_usuario_ant_w), cd_pessoa_fisica_w,nm_paciente_w,hr_destino_w, obter_perfil_ativo);
		-- Transferencia de #@ATRIB_OLDVALUE_W#@ as #@HR_INICIO#@ para #@ATRIB_NEWVALUE_W#@ as #@HR_DESTINO#@ #@DS_MOTIVO_TRANSF_W#@ #@DS_MOTIVO_P#@, usuario anterior #@NM_USUARIO_ANT_W#@

		/* Inserir na tabela de log de reagendamento da plataforma Agenda Integrada */
        AGINT_INSERT_LOG_REMARCA(NR_SEQ_ORIGEM_P,NR_SEQ_DESTINO_P,DS_OBSERVACAO_P,'E');

        /* excluir registro origem */
		obter_param_usuario(820, 78, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_canc_agenda_transf_w );

		if	(ie_canc_agenda_transf_w = 'N') then

			select	count(*)
			into	qt_integrada_w
			from	agenda_integrada_item
			where	nr_seq_agenda_exame	= nr_seq_origem_p;

			if	(qt_integrada_w > 0) then
				ie_canc_agenda_transf_w	:= 'S';
			end if;

		end if;

		if	(ie_canc_agenda_transf_w = 'S') then

			if	(ie_acao_p = 'T' and nr_seq_pepo_w is not null)  then

				update	agenda_paciente
				set	nr_seq_pepo 			= null
				where	nr_sequencia 			= nr_seq_origem_p;
			end if;

			alterar_status_agenda(cd_Agenda_w, nr_seq_origem_p, 'C', '', wheb_mensagem_pck.get_texto(306776, null), 'N', nm_usuario_p); -- Transferencia de agenda
		else
			delete from agenda_paciente
			where nr_sequencia = nr_seq_origem_p;
		end if;

		open C02;
		loop
		fetch C02 into	
			nr_seq_evento_w;
		exit when C02%notfound;
			begin
			gerar_evento_transf_agenda(nr_seq_evento_w,nr_atendimento_w,cd_pessoa_fisica_w,null,nm_usuario_p,
				cd_agenda_w, hr_inicio_w, cd_medico_w, cd_procedimento_w,
				ie_origem_proced_w, null, hr_destino_w, cd_agenda_destino_w, ds_observacao_w, null);
			end;
		end loop;
		close C02;

		--Atualizar informacoes da lista de espera
		update	agenda_lista_espera
		set	nr_seq_agenda = nr_seq_destino_p
		where	nr_seq_agenda = nr_seq_origem_p;

	elsif	(ie_acao_p = 'C') then
		begin
		--Consistir a copia da avaliacao do paciente
		if	(ie_avaliacao_copia_w = 'S') then
			select	count(*)
			into	qt_avaliacao_w
			from	med_avaliacao_paciente
			where	nr_seq_agenda_pac = nr_seq_origem_p;

			if	(qt_avaliacao_w > 0) then
				insert into med_avaliacao_paciente (	
													CD_ESTABELECIMENTO,
													CD_MEDICO,                  
													CD_PERFIL_ATIVO,                 
													CD_PESSOA_FISICA,                
													CD_SETOR_ATENDIMENTO,            
													CD_UNIDADE,                      
													DS_JUSTIFICATIVA,                
													DS_OBSERVACAO,                   
													DT_ATUALIZACAO,             
													DT_ATUALIZACAO_NREC,             
													DT_AVALIACAO,               
													DT_INATIVACAO,                   
													DT_LIBERACAO,                    
													DT_LIBERACAO_AUX,                
													IE_APRESENTAR_WEB,               
													IE_ATUALIZA_MACRO,               
													IE_AVALIACAO_PARCIAL,            
													IE_AVALIADOR_AUX,                
													IE_RESTRICAO_VISUALIZACAO,       
													IE_SITUACAO,                     
													NM_USUARIO,                 
													NM_USUARIO_INATIVACAO,      
													NM_USUARIO_LIB,                  
													NM_USUARIO_NREC,                 
													NR_ATENDIMENTO,                  
													NR_CIRURGIA,                     
													NR_PRESCRICAO,                   
													NR_SEQ_AGEINT,                   
													NR_SEQ_AGENDA_CONS,              
													NR_SEQ_AGENDA_PAC,               
													NR_SEQ_ASSINAT_INATIVACAO,       
													NR_SEQ_ASSINATURA,               
													NR_SEQ_ATEND_CHECKLIST,
													NR_SEQ_ATENDIMENTO,              
													NR_SEQ_ATEPACU,                  
													NR_SEQ_AVAL_COMPL,               
													NR_SEQ_AVAL_PRE,                 
													NR_SEQ_CHAMADO,                  
													NR_SEQ_CHECKLIST_ITEM,           
													NR_SEQ_CHECKUP,                  
													NR_SEQ_COM_CLIENTE,              
													NR_SEQ_CONSULTA,                 
													NR_SEQ_CONTATO,                  
													NR_SEQ_LOTE,                     
													NR_SEQ_MATERIAL,                 
													NR_SEQ_PAC_HFP,                  
													NR_SEQ_PEPO,                     
													NR_SEQ_PRESCR,                   
													NR_SEQ_REGULACAO,                
													NR_SEQ_TIPO_AVALIACAO,           
													NR_SEQUENCIA)
				select								CD_ESTABELECIMENTO,
													CD_MEDICO,                  
													CD_PERFIL_ATIVO,                 
													CD_PESSOA_FISICA,                
													CD_SETOR_ATENDIMENTO,            
													CD_UNIDADE,                      
													DS_JUSTIFICATIVA,                
													DS_OBSERVACAO,                   
													DT_ATUALIZACAO,             
													DT_ATUALIZACAO_NREC,             
													DT_AVALIACAO,               
													DT_INATIVACAO,                   
													null,                    
													DT_LIBERACAO_AUX,                
													IE_APRESENTAR_WEB,               
													IE_ATUALIZA_MACRO,               
													IE_AVALIACAO_PARCIAL,            
													IE_AVALIADOR_AUX,                
													IE_RESTRICAO_VISUALIZACAO,       
													IE_SITUACAO,                     
													NM_USUARIO,                 
													NM_USUARIO_INATIVACAO,      
													NM_USUARIO_LIB,                  
													NM_USUARIO_NREC,                 
													NR_ATENDIMENTO,                  
													NR_CIRURGIA,                     
													NR_PRESCRICAO,                   
													NR_SEQ_AGEINT,                   
													null,              
													nr_seq_destino_p,               
													NR_SEQ_ASSINAT_INATIVACAO,       
													NR_SEQ_ASSINATURA,               
													NR_SEQ_ATEND_CHECKLIST,
													NR_SEQ_ATENDIMENTO,              
													NR_SEQ_ATEPACU,                  
													NR_SEQ_AVAL_COMPL,               
													NR_SEQ_AVAL_PRE,                 
													NR_SEQ_CHAMADO,                  
													NR_SEQ_CHECKLIST_ITEM,           
													NR_SEQ_CHECKUP,                  
													NR_SEQ_COM_CLIENTE,              
													NR_SEQ_CONSULTA,                 
													NR_SEQ_CONTATO,                  
													NR_SEQ_LOTE,                     
													NR_SEQ_MATERIAL,                 
													NR_SEQ_PAC_HFP,                  
													NR_SEQ_PEPO,                     
													NR_SEQ_PRESCR,                   
													NR_SEQ_REGULACAO,                
													NR_SEQ_TIPO_AVALIACAO,
													med_avaliacao_paciente_seq.nextval
				from	med_avaliacao_paciente
				where	nr_seq_agenda_pac = nr_seq_origem_p;			
			end if;

		end if;
		exception
		when others then
			ds_erro_w	:= '';
		end;
	end if;

end if; 

ds_retorno_p	:= ds_retorno_w;
commit;

end AGINT_REAGENDA_EXAME;