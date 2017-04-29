# =============================================================================
# File name: mbbs_ini.pl v1.41
# Copyright: horn@eztown.org
#            (URL: http://eztown.org/)
#
# ���̃t�@�C����mbbs.cgi(��)�̐ݒ��t�@�C���ł��B
# =============================================================================
#------------------------------------------------------------------------------
# �����ݒ��i���ʁj
#------------------------------------------------------------------------------
$iniversion = '1.41';				# �ݒ��t�@�C���̃o�[�W��������

$writelib = './lib/write.pl';		# �������ݏ���
$xhlib = './lib/xh.pl';				# xhtml����
$chlib = './lib/ch.pl';				# chtml����
$hdlib = './lib/hd.pl';				# hdml����
$pclib = './lib/pc.pl';				# pc����
$SessionLib = './lib/session.pl';	# �Z�b�V��������


$fscript = '/public_html/*****/mbbs.cgi';	# �X�N���v�g�̃t���p�X
$script = 'mbbs.cgi';				# �X�N���v�g��
$logfile = './ini/mbbs.log';		# �ۑ��t�@�C����
$pswfile = './ini/passcode.dat';	# �Ǘ��p�p�X���[�h�t�@�C��
$devfile = './ini/device.txt';		# �f�o�C�X�����t�@�C��
$userfile = "./ini/userfile.cgi";	# ���[�U�[�����ۑ��t�@�C��
$CheckDevInfoLog = "./ini/device.log";
									# device.txt�X�V���O�ۊǈʒu�@# 08.02.15 �ǉ�
$SessionFile = './ini/session.cgi';	# �Z�b�V���������ۑ��t�@�C��
$mailing = '0';						# ���[���ʒm(0=off 1=on)
$mailto = '';						# �ʒm�惁�[���A�h���X
$mailing_mob = '0';					# ���o�C���̃��[���ʒm(����)
$mailto_mob = '';					# �ʒm�惁�[���A�h���X(�g�їp)
$sendmail = '/usr/lib/sendmail';	# sendmail�̃p�X
$mailfm = '';						# �ʒm���̃��[���A�h���X
$mail_title = '';					# ���[�����M�����Ƃ��̑薼
$get_remotehost = 0;				# �z�X�g���擾���[�h
									# 0 : $ENV {'REMOTE_HOST'} �Ŏ擾�ł����ꍇ
									# 1 : gethostbyaddr �Ŏ擾�ł����ꍇ
$method = 'POST';					# METHOD�̑I��(POST/GET)
@reject = (							# �A�N�Z�X����
	'anonymizer.com',
	'cache*.*.interlog.com',
	'211.154.120.*',
	'',
	'',
	'');
$new_time = 24;						# NEW���\�����鎞��
$use_cookie = 1;					# �N�b�L�[�̎g�p(0:off/1:on)
$autolink = 1;						# �I�[�g�����N�̎g�p(0:off/1:on)
$file_lock = 1;						# �t�@�C�����b�N�@�\(0:off/1:on)
									# flock�֐��̂݃T�|�[�g���Ă��܂��B
									# flock���g���Ȃ����̏ꍇ0�ɂ��Ă��������B
$dai_aid = 1;						# �薼�⊮�@�\
									# �薼��RE:(�e�L���̑薼)�ƂȂ��Ă����ꍇ�A
									# �c���[�̑薼�𕶓��̕����ɒu��
$length_chk = 0;					# ���e����������(0:off/1:on)
$length_def = 10;					# ���������������ꍇ�̕�����(���p)
$use_ezgate = 1;					# EZgate���g�p(0:off/1:on)
$url_ezgate = "http://www.note.ne.jp/ezgate2/?";
									# EZgate��URL���w��
$UseWKeyChk = 0;					# �]���^�̏������݃��[�h�@�\
$wkey = "�v�[�h��";					# �������݃��[�h(0:off/1:on)
$use_ipcheck = 1;					# IPCheck�̎g�p(0:off/1:on)
$DeviceInfo_host = 'eztown.org';				# �X�V�����񋟃z�X�g(���{�I�ɕύX���Ȃ�)
$CheckDevInfoDate = "/pc/ezwebcgi/device.shtml";# �X�V�����񋟃t�@�C��(���{�I�ɕύX���Ȃ�)
$CheckDevInfoData = "/pc/ezwebcgi/device.txt";	# �X�V�pdevice.txt�̈ʒu(���{�I�ɕύX���Ȃ�)

$res_sort = '0';					# ���X�L���̕\�����ݒ�(0=�W�� 1=�t�])
# �킩���ɂ����̂ŗ����������ƁA
# 0�Ȃ��X���b�g�ɂ����X�̕\����
# No.001
# -No.002
# -No.003
# -No.004
# �ƂȂ��A1�Ȃ�
# No.001
# -No.004
# -No.003
# -No.002
# �ƂȂ��܂��B
# �������A�V�K�������ݕ����ɂ̂ݓK�p�����܂��̂ł����ӂ��������B



#------------------------------------------------------------------------------
# �����ݒ��i�����R�[�h�j
#------------------------------------------------------------------------------
require './lib/jcode.pl';	# �����R�[�h�ϊ����C�u�����̎w��
$page_charset = 'sjis';		# �\���p�����R�[�h
$file_charset = 'sjis';		# ���������p(���̃t�@�C����)�����R�[�h
$mail_charset = 'jis';		# ���[���o�͗p�����R�[�h
$hankana = 1;				# ���p�J�i�������݋֎~�ݒ�(0:off/1:on�j
					# ���̋@�\���g���ꍇ�́A�����R�[�h�̓f�t�H���g���g�p���邱��

#------------------------------------------------------------------------------
# �����ݒ��i�z�F�j
#------------------------------------------------------------------------------
if($agent != 1) {
	# �ǎ��E�w�i�F�E�����F
	$bg_img = '';			# �w�i�摜�i�ȗ��j
	$bg_clr = "#FFFFFF";	# �w�i�F
	$tx_clr	= "#000000";	# �����F
	$li_clr	= "#0000FF";	# �����N�F�i���K���j
	$vl_clr	= "#0000FF";	# �����N�F�i�T�K���j
	$al_clr	= "#66FFFF";	# �����N�F�i�K�⒆�j

	# �L���g�̔z�F
	$tf_clr = "#000000";	# �e�[�u���g�̐F
	$tg_clr = "#FFFFFF";	# �e�[�u���w�i�F

	# �A�N�Z���g�̔z�F
	$new_clr = "#FF3366";	# NEW�}�[�N�̐F
	$dai_clr = "#0000FF";	# �薼�̐F

	# �^�C�g���̔z�F
	$ti_clr = "#FFFFFF";	# �^�C�g�������F
	$tb_clr = "#000000";	# �^�C�g���g�̔w�i�F
}
#------------------------------------------------------------------------------
# �����ݒ��iPC�j
#------------------------------------------------------------------------------
if ($agent == 0){
	$cssfile = './ini/mbbs.css';		# css�t�@�C���ݒ�(�ꕔ�Ή�)
	$pc_title = '';						# �^�C�g��
	$pc_img = '';						# �^�C�g���摜�t�@�C��
	$pc_help = './txt/help.html';		# �w���v�t�@�C����
	$pc_himg = './img/home.jpg';		# HP�摜�t�@�C��
	$pc_pimg = './img/phone.jpg';		# HP�摜�t�@�C���iEZweb�؁[�W�p�j
	$pc_mimg = './img/mail.jpg';		# MAIL�p�摜�t�@�C��
	$pc_home = '';						# �z�[���y�[�W�i�߂��y�[�W�j
	# �P�y�[�W�ӂ��̍ő��c���[��
		# �ǂ��炩���폜�t�H�[���ƍ��킹�Ă����ƁA�y�[�W�̊m�F���֗��ł��B
		$max_view  = 10;	# ���ׂĕ\��
		$max_tree  = 10;	# �c���[�\��
		$max_dform = 10;	# �폜�t�H�[��
	$top_mark = '��';					# �c���[�̃g�b�v�L��
	$res_mark = '��';					# �c���[�̃��X�L��

	# �L���̑}��
	# ���L���̃A�h���X�ɂ́A$ad_data = <<'AD_DATA' �̎��̍s�����A
	#   �s���� AD_DATA �Ƃ������������钼�O�̍s�܂łł��B
	# �����̃^�O�̓r���ɉ��s�������Ȃ��ł��������B
	# ����
	# $ad_data = <<'AD_DATA';
	# <!-- TG-Affiliate Banner Space -->
	# <A href="http://ad.trafficgate.net/e/m.pl?h=6363&g=5&m=99&t=img" target="_blank">
	# <IMG src="http://srv.trafficgate.net/e/b.pl?h=6363&g=5&m=99" border="0"></A>
	# <!-- /TG-Affiliate Banner Space -->
	# AD_DATA

$ad_data = <<'AD_DATA';
AD_DATA
}
#------------------------------------------------------------------------------
# �����ݒ��iEZweb�j
#------------------------------------------------------------------------------
if ($agent == 1){
	$wap_title = '';					# �^�C�g��
	# �^�C�g���摜�t�@�C����
		$wap_bmp = './img/title.bmp';		# ����bmp�t�@�C��
		$wap_png = './img/ctitle.png';		# �J���[png�t�@�C��
	$wap_help = './txt/help.hdml';		# �w���v�t�@�C����
	$wap_own = '';						# ���쌠�\��
	$wap_home = '';						# �z�[���y�[�W�i�߂��y�[�W�j
	$max_line = 7;						# �P�y�[�W�ӂ��̍ő��L�����B

	$new_mark = '<IMG ICON="77" alt="��">';		# �V���̐e�L���L��
	$top_mark = '<IMG ICON="28" alt="��">';		# �e�L���L��
	$rnew_mark = '<IMG ICON="68" alt="��">';	# �V���̃��X�L���L��
	$res_mark = '<IMG ICON="10" alt="��">';		# ���X�L���L��
	# @mail�[���Ή�
		if ($ENV{'HTTP_X_UP_SUBNO'} =~ /[a-z][a-z]\.ezweb/) {
			$atmail = 1;
		}
	$list_method = 'number';			# �ꗗ�\�����ʂ̑I�����ԍ�
										# (number:�t����/alpha:�t���Ȃ�)
	$ez_by = '1';						# �e�L���\�����ɓ��e�Җ��\��
										# (0:���Ȃ�/1:����)
	$list_view_mode = '0';				# �e�L���\�����[�h
										#  0:�薼 ���X�� ���e�Җ� by ���e�Җ�
										#  1:�薼(���X��) by ���e�Җ� ���e�N����
}
#------------------------------------------------------------------------------
# �����ݒ��ii-mode�j
#------------------------------------------------------------------------------
if ($agent == 2){
	
	$c_title = '';						# �^�C�g��
	$c_img = './img/ititle.gif';		# �^�C�g���摜�t�@�C����
	$c_help = './txt/chelp.html';		# �w���v�t�@�C��
	$c_own = '';						# ���쌠�\��
	$c_home = '';						# �z�[���y�[�W
	$cmax_line = 7;						# �P�y�[�W�ӂ��̍ő��L����
	$one_mark   = "\&\#63879;";	# �P
	$two_mark   = "\&\#63880;";	# �Q
	$three_mark = "\&\#63881;";	# �R
	$four_mark  = "\&\#63882;";	# �S
	$five_mark  = "\&\#63883;";	# �T
	$six_mark   = "\&\#63884;";	# �U
	$seven_mark = "\&\#63885;";	# �V
	$eight_mark = "\&\#63886;";	# �W
	$nine_mark  = "\&\#63887;";	# �X
	$zero_mark  = "\&\#63888;";	# �O
	$top_mark   = "\&\#63722;";	# �c���[�̃g�b�v�L��
	$new_mark   = "\&\#63874;";	# �c���[�̃g�b�v�L���i�V���j
	$res_mark   = "��";			# �c���[�̃��X�L��
	$mail_mark  = "\&\#63863;";	# ���[���̋L��
	$home_mark  = "\&\#63684;";	# �z�[���̋L��
	$phone_mark = "\&\#63721;";	# �g�ђ[���̋L��
	$key_mark   = "\&\#63869;";	# ���̋L��
	$chtml_by = '1';			# �e�L���\�����ɓ��e�Җ��\��(0:off/1:on)
	$list_view_mode = '0';		# �e�L���\�����[�h
								#  0:�薼 ���X�� ���e�Җ� by ���e�Җ�
								#  1:�薼(���X��) by ���e�Җ� ���e�N����
}
#------------------------------------------------------------------------------
# �����ݒ��iJ-Sky�j
#------------------------------------------------------------------------------
if ($agent == 3){
	$c_title = '';					# �^�C�g��
	$c_img = './img/jtitle.jpg';	# �^�C�g���摜�t�@�C����
	$c_help = './txt/jhelp.html';	# �w���v�t�@�C��
	$c_own = '';					# ���쌠�\��
	$c_home = '';					# �z�[���y�[�W
	$cmax_line = 7;					# �P�y�[�W�ӂ��̍ő��L����
	$one_mark   = '$F<';		# �P
	$two_mark   = '$F=';		# �Q
	$three_mark = '$F>';		# �R
	$four_mark  = '$F?';		# �S
	$five_mark  = '$F@';		# �T
	$six_mark   = '$FA';		# �U
	$seven_mark = '$FB';		# �V
	$eight_mark = '$FC';		# �W
	$nine_mark  = '$FD';		# �X
	$zero_mark  = '$FE';		# �O
	$top_mark   = '$FZ';		# �c���[�̃g�b�v�L��
	$new_mark   = '$F2';		# �c���[�̃g�b�v�L���i�V���j
	$res_mark   = '$F\';		# �c���[�̃��X�L��
	$mail_mark  = '$E!';		# ���[���̋L��
	$home_mark  = '$GV';		# �z�[���̋L��
	$phone_mark = '$G*';		# �g�ђ[���̋L��
	$key_mark   = '$G_';		# ���̋L��
	$chtml_by = '1';			# �e�L���\�����ɓ��e�Җ��\��(0:off/1:on)
	$list_view_mode = '0';		# �e�L���\�����[�h
								#  0:�薼 ���X�� ���e�Җ� by ���e�Җ�
								#  1:�薼(���X��) by ���e�Җ� ���e�N����
}
#------------------------------------------------------------------------------
# �����ݒ��ixhtml�j
#------------------------------------------------------------------------------
if ($agent == 5){
	$x_title = '';					# �^�C�g��
	$x_img = './img/ctitle.png';	# �^�C�g���摜�t�@�C����
	$x_help = './txt/chelp.html';	# �w���v�t�@�C��
	$x_own = '';					# ���쌠�\��
	$x_home = '';					# �z�[���y�[�W
	$cmax_line = 7;					# �P�y�[�W�ӂ��̍ő��L����
	$one_mark   = "\&\#63879;";	# �P
	$two_mark   = "\&\#63880;";	# �Q
	$three_mark = "\&\#63881;";	# �R
	$four_mark  = "\&\#63882;";	# �S
	$five_mark  = "\&\#63883;";	# �T
	$six_mark   = "\&\#63884;";	# �U
	$seven_mark = "\&\#63885;";	# �V
	$eight_mark = "\&\#63886;";	# �W
	$nine_mark  = "\&\#63887;";	# �X
	$zero_mark  = "\&\#63888;";	# �O
	$top_mark   = "\&\#63722;";	# �c���[�̃g�b�v�L��
	$new_mark   = "\&\#63874;";	# �c���[�̃g�b�v�L���i�V���j
	$res_mark   = "<img localsrc=\"10\" />";	# �c���[�̃��X�L��
	$rnew_mark  = "<img localsrc=\"68\" />";	# �V�����X�L��
	$mail_mark  = "\&\#63863;";	# ���[���̋L��
	$home_mark  = "\&\#63684;";	# �z�[���̋L��
	$phone_mark = "\&\#63721;";	# �g�ђ[���̋L��
	$key_mark   = "\&\#63869;";	# ���̋L��
	$xhtml_by = '1';			# �e�L���\�����ɓ��e�Җ��\��(0:off/1:on)
	$list_view_mode = '0';		# �e�L���\�����[�h
								#  0:�薼 ���X�� ���e�Җ� by ���e�Җ�
								#  1:�薼(���X��) by ���e�Җ� ���e�N����
}

1;


