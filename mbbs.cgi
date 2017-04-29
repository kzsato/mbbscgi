#!/usr/bin/perl

# =============================================================================
# File name: mbbs.cgi v1.5.0.1-RC1
# Copyright: horn@eztown.org
#            (URL: http://eztown.org/)
#
# �Ή��[�� : PC ezweb(WAP1.0/2.0) i-mode J-Sky Air-H" etc...
#
# ���̃X�N���v�g�t���[�E�F�A�ł��B
# �����A�ݒu�́A�l�̐ӔC�ɂ����čs���Ă��������B
#
# �����ɂ���
# mbbs1.4xx�̌����́Asuzukyu���J���́umbbs.cgi v1.93 & v2.02 & v3.02�v�ł��B
# ���̃X�N���v�g�́A���삪�Ȃ����Γo�ꂵ�܂����ł����B
# ���̏����؂��Č����\���グ�܂��B
# �Ȃ��A�����z�z�T�C�g�͕��̂��߁AURL�̏Љ��͊��������Ă��������܂��B
# =============================================================================


$version = 'v1.5.0.1-RC1';			# �o�[�W��������
$moddate = "2008.03.07";		# �ŏI����
$inifile = "mbbs_ini.pl";		# �ݒ��t�@�C����

#------------------------------------------------------------------------------
# ���O�����i�u���E�U���ʊm�F�j
#------------------------------------------------------------------------------
$user_agent = $ENV{'HTTP_USER_AGENT'};
$user_sim = $ENV{'HTTP_X_UP_UPLINK'};
$user_j_agent = $ENV{'HTTP_X_JPHONE_MSNAME'};

&get_host;

if ($denyfile) { require "$denyfile"; &deny;}

if ($user_agent =~ /^UP\.Browser\//)			{ $agent = 1; }	# EZweb
elsif ($user_agent =~ /^KDDI/)					{ $agent = 5; }	# xhtml
elsif ($user_agent =~ /^OPWV-GEN-99\/UNI10/)	{ $agent = 5; }	# EZweb
elsif ($user_agent =~ /^OPWV-SDK\/11/)			{ $agent = 5; }	# EZweb
elsif ($user_agent =~ /UPSim/)					{ $agent = 1; }	# UP.Simulator
elsif ($user_agent =~ /DoCoMo\//)				{ $agent = 2; } # i-mode
elsif ($user_agent =~ /DDIPOCKET/)				{ $agent = 2; } # Air H" Phone
elsif ($user_agent =~ /L\-mode\//)				{ $agent = 2; } # L-mode
elsif ($user_j_agent ne '')						{ $agent = 3; } # J-SkyWeb
elsif ($user_agent =~ /PDXGW\/\d\.\d/)			{ $agent = 4; } # H"
elsif ($user_agent =~ /UP\.Browser\//)			{ $agent = 5; }	# EZweb
else											{ $agent = 0; } # PC

#------------------------------------------------------------------------------
# ���{�����i���ʁj
#------------------------------------------------------------------------------
require "$inifile";				# �����ݒ��t�@�C���̓Ǎ���
if ($iniversion < 1.40) { &error(inifile_er); }
&axs_check;						# �A�N�Z�X����
&form_decode;						# �t�H�[���f�R�[�h����

if ($agent == 1)	{ &wap_main; }	# EZweb�[���p����
elsif ($agent == 2)	{ &c_main; }	# i-mode�[���p����
elsif ($agent == 3)	{ &c_main; }	# J-Sky�[���p����
elsif ($agent == 4)	{ &c_main; }	# �h�b�gi�[���p����
elsif ($agent == 5)	{ &x_main; }	# xhtml�[���p����
else			 	{ &pc_main; }	# PC�[���p����

exit;

#------------------------------------------------------------------------------
# ���{�����ixhtml�j
#------------------------------------------------------------------------------
sub x_main {
	require "$xhlib";
	($text_x,$text_y) = split(/,/,$ENV{'HTTP_X_UP_DEVCAP_SCREENCHARS'});
	if ($in{'mode'} eq "form") {
		&x_form;							# ���e�t�H�[���iEZweb�j
	} elsif ($in{'mode'} eq "write") {
		require "$writelib";				# �������ݏ����̓Ǎ���
		&write;								# ���e�����i���ʁj
		&x_write;							# ���e�m�F�iEZweb�j

	} elsif ($in{'mode'} eq "menu") {
		&x_title;							# ���j���[�\���iezweb�j

	} elsif ($in{'mode'} eq "sform") {
		&x_sform;							# �����t�H�[���iEZweb�j
	} elsif ($in{'mode'} eq "seek") {
		&seek;								# ���������i���ʁj
		&x_sview;							# �������ʕ\���iEZweb�j
	} elsif ($in{'mode'} eq "list") {
		&x_list;							# �e�L�����X�g�\���iEZweb�j
	} elsif ($in{'mode'} eq "tree") {
		&x_tree;							# �ʃc���[�\���iEZweb�j
	} elsif ($in{'mode'} eq "view") {
		&x_view;							# �ʕ\���iEZweb�j
	} elsif ($in{'func'} eq "delete") {
		&user_delete;					# ���[�U�폜�����i���ʁj
		&del_ex;					# �����\��
	} elsif ($in{'mode'} eq "admin") {
		&passchk;						# �p�X���[�h�`�F�b�N�i���ʁj
		if ($in{'func'} eq "check") {
			&passchk;						# �p�X���[�h�`�F�b�N�i���ʁj
		} elsif ($in{'func'} eq "del_word") {
			&del_word;						# ���K�،��폜�����i���ʁj
		} elsif ($in{'func'} eq "add_word") {
			&add_word;						# ���K�،��ǉ������i���ʁj
		} elsif ($in{'func'} eq "change") {
			&change;						# �p�X���[�h�ύX�����i���ʁj
		}
		&x_admin;							# �Ǘ��҃t�H�[���iEZweb�j
	} elsif ($in{'mode'} eq "aform") {
		&passchk;						# �p�X���[�h�`�F�b�N�i���ʁj
		&x_aform;							# ���K�،��ǉ��t�H�[���iEZweb)
	} elsif ($in{'mode'} eq "change") {
		&passchk;						# �p�X���[�h�`�F�b�N�i���ʁj
		&x_pform;							# �p�X���[�h�ύX�t�H�[���iEZweb)
	} elsif ($in{'mode'} eq "check") {
		&x_pass;							# �p�X���[�h�m�F�t�H�[���iEZweb)
	} elsif ($in{'mode'} eq "ad_dform") {
		&passchk;						# �p�X���[�h�`�F�b�N�i���ʁj
		&x_ad_dform;						# �Ǘ��ҍ폜�t�H�[���iEZweb�j
	} elsif ($in{'mode'} eq "dform") {
		&x_dform;							# �폜�t�H�[���iEZweb�j
	} else {
		if ($in{'func'} eq "delete") {
			&user_delete;					# ���[�U�폜�����i���ʁj
		}
		&x_list;							# �^�C�g���\���iEZweb�j
	}
}

#------------------------------------------------------------------------------
# ���{�����ii-mode�AJ-Sky�A�h�b�gi�j
#------------------------------------------------------------------------------
sub c_main {
	require "$chlib";	
	if ($in{'mode'} eq "form") {
		&c_form;							# �����݃t�H�[���iCHTML�j
	} elsif ($in{'mode'} eq "write") {
		require "$writelib";				# �������ݏ����̓Ǎ���
		&write;								# �����ݏ����i���ʁj
		&c_write;							# �����݊m�F�iCHTML�j
	} elsif ($in{'mode'} eq "sform") {
		&c_sform;							# �����t�H�[���iCHTML�j
	} elsif ($in{'mode'} eq "seek") {
		&seek;								# ���������i���ʁj
		&c_sview;							# �������ʕ\���iCHTML�j
	} elsif ($in{'mode'} eq "list") {
		&c_list;							# �e�L�����X�g�\���iCHTML�j
	} elsif ($in{'mode'} eq "menu") {
		&c_title;							# �e�L�����X�g�\���iCHTML�j
	} elsif ($in{'mode'} eq "tree") {
		&c_tree;							# �ʃc���[�\���iCHTML�j
	} elsif ($in{'mode'} eq "view") {
		&c_view;							# �ʕ\���iCHTML�j
	} elsif ($in{'mode'} eq "dform") {
		&c_dform;							# �폜�t�H�[���iCHTML�j
	} elsif ($in{'func'} eq "del") {
		&user_delete;					# ���[�U�폜�����i���ʁj
		&del_ex;
	} else {
		&c_list;							# �^�C�g���\���iCHTML�j
	}
}

#------------------------------------------------------------------------------
# ���{�����iPC�j
#------------------------------------------------------------------------------
sub pc_main {
	require "$pclib";	
	require "$SessionLib";
	$SessionFlag = &SessionChk;
	if ($in{'mode'} eq "form") {
		&pc_form;							# ���e�t�H�[���iPC�j
	} elsif ($in{'mode'} eq "write") {
		if($UseWKeyChk){&wkeychk;}
		require "$writelib";				# �������ݏ����̓Ǎ���
		&write;								# ���e�����i���ʁj
		&pc_write;							# ���e�m�F�iPC�j
	} elsif ($in{'mode'} eq "sform") {
		&pc_sform;							# �����t�H�[���iPC�j
	} elsif ($in{'mode'} eq "seek") {
		&seek;								# ���������i���ʁj
		&pc_sview;							# �������ʕ\���iPC�j
	} elsif ($in{'mode'} eq "passform") { 
		&passform;							# �p�X���[�h���̓t�H�[���iPC�j
	} elsif ($in{'mode'} eq "admin") {
		if($SessionFlag){&passform}
		if ($in{'func'} eq "check") {
			if($SessionFlag){&passform}
		} elsif ($in{'func'} eq "change") {
			&change;						# �p�X���[�h�ύX�����iPC�j
			&adminmes;
			exit;
		} elsif ($in{'func'} eq "del_word") {
			&del_word;						# ���K�،��폜�����iPC�j
		} elsif ($in{'func'} eq "add_word") {
			&add_word;						# ���K�،��ǉ������iPC�j
		}
		&admin;								# �Ǘ��t�H�[���iPC�j
	} elsif ($in{'mode'} eq "dform") { 
		if($SessionFlag){&passform}
		if ($in{'func'} eq "delete") {
			&delete;						# �폜�����iPC�j
		}
		if($SessionFlag){&passform}
		&dform;								# �폜�t�H�[���iPC�j
	} elsif ($in{'mode'} eq "update"){		# Device�����t�@�C���A�b�v�f�[�g(PC)
		if($SessionFlag){&passform}
		&CheckDeviceTxt;				# �f�o�C�X�����X�V����(����)
		&updateResult;					# ���ʕ\��
	} elsif ($in{'mode'} eq "view") { 
		&pc_view;							# �ʕ\���iPC�j
	} elsif ($in{'mode'} eq "tree") { 
		&pc_tree;							# �c���[�\���iPC�j
	} elsif ($in{'mode'} eq "all") { 
		&pc_all;							# ���ׂĕ\���iPC�j
	} else {
		if ($in{'func'} eq "user_delete") { 
			&user_delete;					# ���[�U�폜�����i���ʁj
		}
		&pc_tree;							# �����̕\���iPC�j
	}
}

#------------------------------------------------------------------------------
# ���{�����iEZweb�j
#------------------------------------------------------------------------------
sub wap_main {
	require "$hdlib";	
	if ($in{'mode'} eq "form") {
		&wap_form;							# ���e�t�H�[���iEZweb�j
	} elsif ($in{'mode'} eq "write") {
		require "$writelib";				# �������ݏ����̓Ǎ���
		&write;								# ���e�����i���ʁj
		&wap_write;							# ���e�m�F�iEZweb�j

	} elsif ($in{'mode'} eq "menu") {
		&wap_title;							# ���j���[�\���iezweb�j

	} elsif ($in{'mode'} eq "sform") {
		&wap_sform;							# �����t�H�[���iEZweb�j
	} elsif ($in{'mode'} eq "seek") {
		&seek;								# ���������i���ʁj
		&wap_sview;							# �������ʕ\���iEZweb�j
	} elsif ($in{'mode'} eq "list") {
		&wap_list;							# �e�L�����X�g�\���iEZweb�j
	} elsif ($in{'mode'} eq "tree") {
		&wap_tree;							# �ʃc���[�\���iEZweb�j
	} elsif ($in{'mode'} eq "view") {
		&wap_view;							# �ʕ\���iEZweb�j
	} elsif ($in{'mode'} eq "admin") {
			&passchk;						# �p�X���[�h�`�F�b�N�i���ʁj
		if ($in{'func'} eq "check") {
			&passchk;						# �p�X���[�h�`�F�b�N�i���ʁj
		} elsif ($in{'func'} eq "del_word") {
			&del_word;						# ���K�،��폜�����i���ʁj
		} elsif ($in{'func'} eq "add_word") {
			&add_word;						# ���K�،��ǉ������i���ʁj
		} elsif ($in{'func'} eq "change") {
			&change;						# �p�X���[�h�ύX�����i���ʁj
		} elsif ($in{'func'} eq "delete") {
			&user_delete;					# ���[�U�폜�����i���ʁj
		}
		&wap_admin;							# �Ǘ��҃t�H�[���iEZweb�j
	} elsif ($in{'mode'} eq "aform") {
		&passchk;						# �p�X���[�h�`�F�b�N�i���ʁj
		&wap_aform;							# ���K�،��ǉ��t�H�[���iEZweb)
	} elsif ($in{'mode'} eq "change") {
		&passchk;						# �p�X���[�h�`�F�b�N�i���ʁj
		&wap_pform;							# �p�X���[�h�ύX�t�H�[���iEZweb)
	} elsif ($in{'mode'} eq "check") {
		&wap_pass;							# �p�X���[�h�m�F�t�H�[���iEZweb)
	} elsif ($in{'mode'} eq "ad_dform") {
		&passchk;						# �p�X���[�h�`�F�b�N�i���ʁj
		&wap_ad_dform;						# �Ǘ��ҍ폜�t�H�[���iEZweb�j
	} elsif ($in{'mode'} eq "dform") {
		&wap_dform;							# �폜�t�H�[���iEZweb�j
	} else {
		if ($in{'func'} eq "delete") {
			&user_delete;					# ���[�U�폜�����i���ʁj
		}
		&wap_list;							# �^�C�g���\���iEZweb�j
	}
}

#------------------------------------------------------------------------------
# �A�N�Z�X����
#------------------------------------------------------------------------------
sub axs_check {
	if ($reject[0]) {
		# �z�X�g�����擾
		&get_host;

		$h_flag = 0;
		foreach (@reject) {
			if ($_ eq '') { last; }
			$_ =~ s/\*/\.\*/g;
			if ($host =~ /$_/) { $h_flag=1; last; }
		}
		if ($h_flag) {
			# �w�b�_�[�\��
			$headtype = 0;
			&header;
			$content .= "�����������ł��B\n";
			# �t�b�^�[�\��
			&footer;
			exit;
		}
	}
}

#------------------------------------------------------------------------------
# �t�H�[���f�R�[�h����
#------------------------------------------------------------------------------
sub form_decode{
	local($query, @in, $key, $val);

	# GET���\�b�h��POST���\�b�h���𔻕ʂ���
	if ($ENV{'REQUEST_METHOD'} eq 'POST') {
		read(STDIN, $query, $ENV{'CONTENT_LENGTH'});
	}
	elsif ($ENV{'REQUEST_METHOD'} eq 'GET') {
		$query = $ENV{'QUERY_STRING'};
	}

	# ���̓f�[�^�𕪉�����
	local(@query) = split(/&/, $query);

	# Name=Val �� $in{'Name'} = 'Val' �̃n�b�V���ɂ����B
	foreach (@query) {

		# + ���󔒕����ɕϊ�
		tr/+/ /;

		# Name=Val �𕪂���
		($key, $val) = split(/=/);

		# %HH�`�������̕����Ƀf�R�[�h�����B
		$key =~ s/%([A-Fa-f0-9][A-Fa-f0-9])/pack("c", hex($1))/ge;
		$val =~ s/%([A-Fa-f0-9][A-Fa-f0-9])/pack("c", hex($1))/ge;

		$val =~ s/\r\n/\n/g;

		# �A�z�z���i�n�b�V���j�ɃZ�b�g
		$in{$key} = $val;
	}

	# �A�z�z���̃O���u���Ԃ�
	return *in;
}
#------------------------------------------------------------------------------
# ��������
#------------------------------------------------------------------------------
sub seek {
	# �G���[����
	if ($in{'string'} eq "") { &error(string_er); }

	# �����R�[�h�ϊ�(�\���R�[�h�ƕۑ��R�[�h���Ⴄ�ꍇ�̂�)
	$cond = $in{'cond'};
	$strings = $in{'string'};
	if ($page_charset ne $file_charset){
		&jcode::convert( *strings, $file_charset);
	}

	# �������������Ȃ��ׂ�
	@string = split(/ /,$strings);

	# �ۑ��t�@�C�����J��
	open (IN,"$logfile") || &error (open_er);
	@line = <IN>;
	close(IN);

	# �L���̃J�E���g�𕪗�
	$count = shift(@line);

	# �V�K�z��������
	@new = ();

	foreach $col (@line) {
		
		@column = split(/<>/,$col);
		$col = "$column[0]<>$column[1]<>$column[2]<>$column[3]<>$column[4]<>".
		"$column[5]<>$column[6]<><><>$column[9]<><><><>$column[13]<><>$column[15]<><><><>";
	
		$flag = 0;
		foreach $str (@string) {
			if (index($col,$str) >= 0){
				$flag = 1;
				if ($cond eq "or") { last; }
			} else {
				if ($cond eq "and") { $flag = 0; last; }
			}
		}

		$col = "$column[0]<>$column[1]<>$column[2]<>$column[3]<>$column[4]<>".
		"$column[5]<>$column[6]<>$column[7]<>$column[8]<>$column[9]<>".
		"$column[10]<>$column[11]<>$column[12]<>$column[13]<>$column[14]<>".
		"$column[15]<>$column[16]<>$column[17]<>$column[18]<>";

		if ($flag == 1 ) { push(@new,$col); }
	}
}

#------------------------------------------------------------------------------
# �폜����
#------------------------------------------------------------------------------
sub delete {
	# �t�@�C�������b�N�����B
	if ($file_lock) { flock("$logfile", 2); }

	# ���O�t�@�C�����I�[�v������
	open (IN,"$logfile") || &error (open_er);
	@line = <IN>;
	close(IN);
	
	# �ϐ��̏����ݒ�
	$count   = shift(@line);	# ���O�J�E���^���ޔ�
	$num     = 0;				# �L����
	$num_max = $#line;			# ���[�L����

	# �L���̍폜
	while ($num <= $num_max) {
		# �e�s�𕪊����A�z���Ɋi�[
		@column = split(/<>/,$line[$num]);

		# �ʍ폜
		if ($in{"col$column[0]"} == 1) {
			if ($column[0] == $column[1]) {
				# �e�L���̏ꍇ
				$line[$num] = "";				# �N���A
				$line[$num] .= "$column[0]<>";	# �L���ԍ�
				$line[$num] .= "$column[1]<>";	# �e�L���ԍ�
				$line[$num] .= "$column[2]<>";	# ���t
				$line[$num] .= "$column[3]<>";	# ����
				$line[$num] .= "$column[4]<>";	# ���O
				$line[$num] .= "$column[5]<>";	# �薼
				$line[$num] .= "�Ǘ��ҍ폜<>";	# �{��
				$line[$num] .= "$column[7]<>";	# ���[���A�h���X
				$line[$num] .= "$column[8]<>";	# �z�[���y�[�W
				$line[$num] .= "$column[9]<>";	# �[������
				$line[$num] .= "$column[10]<>";	# �z�X�g
				$line[$num] .= "$column[11]<>";	# IP�A�h���X
				$line[$num] .= "$pass<>";		# �p�X���[�h
				$line[$num] .= "$column[13]<>";	# ���Ύ���
				$line[$num] .= "$column[14]<>";	# UA
				$line[$num] .= "$column[15]<>";	# trip
				$line[$num] .= "$column[16]<>";	# stop
				$line[$num] .= "$column[17]<>";	# �\��
				$line[$num] .= "$column[18]<>";	# �\��
				$line[$num] .= "\n";			# ���s�R�[�h
			} else {
				# �q�L���̏ꍇ
				$line[$num] = "";
			}
		}

		# �c���[�ꊇ�폜
		if ($in{"tree$column[1]"} == 1) {
			$line[$num] = "";
		} elsif ($in{"tree$column[1]"} == 2) {
				$line[$num] = "";				# �N���A
				$line[$num] .= "$column[0]<>";	# �L���ԍ�
				$line[$num] .= "$column[1]<>";	# �e�L���ԍ�
				$line[$num] .= "$column[2]<>";	# ���t
				$line[$num] .= "$column[3]<>";	# ����
				$line[$num] .= "$column[4]<>";	# ���O
				$line[$num] .= "$column[5]<>";	# �薼
				$line[$num] .= "$column[6]<>";	# �{��
				$line[$num] .= "$column[7]<>";	# ���[���A�h���X
				$line[$num] .= "$column[8]<>";	# �z�[���y�[�W
				$line[$num] .= "$column[9]<>";	# �[������
				$line[$num] .= "$column[10]<>";	# �z�X�g
				$line[$num] .= "$column[11]<>";	# IP�A�h���X
				$line[$num] .= "$pass<>";		# �p�X���[�h
				$line[$num] .= "$column[13]<>";	# ���Ύ���
				$line[$num] .= "$column[14]<>";	# UA
				$line[$num] .= "$column[15]<>";	# trip
				$line[$num] .= "1<>";				# stop
				$line[$num] .= "$column[17]<>";	# �\��
				$line[$num] .= "$column[18]<>";	# �\��
				$line[$num] .= "\n";			# ���s�R�[�h
		} elsif ($in{"tree$column[1]"} == 3) {
				$line[$num] = "";				# �N���A
				$line[$num] .= "$column[0]<>";	# �L���ԍ�
				$line[$num] .= "$column[1]<>";	# �e�L���ԍ�
				$line[$num] .= "$column[2]<>";	# ���t
				$line[$num] .= "$column[3]<>";	# ����
				$line[$num] .= "$column[4]<>";	# ���O
				$line[$num] .= "$column[5]<>";	# �薼
				$line[$num] .= "$column[6]<>";	# �{��
				$line[$num] .= "$column[7]<>";	# ���[���A�h���X
				$line[$num] .= "$column[8]<>";	# �z�[���y�[�W
				$line[$num] .= "$column[9]<>";	# �[������
				$line[$num] .= "$column[10]<>";	# �z�X�g
				$line[$num] .= "$column[11]<>";	# IP�A�h���X
				$line[$num] .= "$pass<>";		# �p�X���[�h
				$line[$num] .= "$column[13]<>";	# ���Ύ���
				$line[$num] .= "$column[14]<>";	# UA
				$line[$num] .= "$column[15]<>";	# trip
				$line[$num] .= "0<>";				# stop
				$line[$num] .= "$column[17]<>";	# �\��
				$line[$num] .= "$column[18]<>";	# �\��
				$line[$num] .= "\n";			# ���s�R�[�h
		}
		$num++;
	}

	# ���O�J�E���^���ǉ�
	unshift(@line,"$count");

	open (OUT,">$logfile") || &error (open_er);
	print OUT @line;
	close(OUT);

	# �t�@�C���̃��b�N�����������B
	if ($file_lock) { flock("$logfile", 8); }
}

#------------------------------------------------------------------------------
# �p�X���[�h�ύX����
#------------------------------------------------------------------------------
sub change {
	# �G���[����
	if ($in{'pswa'} eq "") { &error(brank_er); }
	if ($in{'pswa'} ne $in{'pswb'}) { &error(much_er); }

	# �Ǘ��t�@�C�������b�N����
	if ($file_lock) { flock("$pswfile",2); }

	# �Ǘ��t�@�C�����J��
	open (IN,"$pswfile") || &error (open_er);
	@line = <IN>;
	close(IN);

	$times = time;

	# �V�K�p�X���[�h�쐬
	$psw = &pass_encode($in{'pswa'},$times);

	# �p�X���[�h�̓f���o��
	$line[0] = "$psw\n";

	# �Ǘ��t�@�C�����i�[����
	open (OUT,">$pswfile") || &error (open_er);
	print OUT @line;
	close(OUT);

	# �Ǘ��t�@�C���̃��b�N����������
	if ($file_lock) { flock("$pswfile", 8); }
	
}

#------------------------------------------------------------------------------
# ���K�،��폜����
#------------------------------------------------------------------------------
sub del_word {
	# �Ǘ��t�@�C�������b�N����
	if ($file_lock) { flock("$pswfile",2); }

	# �Ǘ��t�@�C�����J��
	open (IN,"$pswfile") || &error (open_er);
	@line = <IN>;
	close(IN);

	# ���K�،��z���̍쐬
	@column = split(/<>/,$line[1]);
	$num = $#column;
	$line[1] = '';

	# ���K�،��폜����
	$loop = 0;
	while ($loop < $num) {
		if ($loop != $in{'loop'}) { $line[1] .= "$column[$loop]<>"; }
		$loop++;
	}
	$line[1] .= "\n";

	# �Ǘ��t�@�C�����i�[����
	open (OUT,">$pswfile") || &error (open_er);
	print OUT @line;
	close(OUT);

	# �Ǘ��t�@�C���̃��b�N����������
	if ($file_lock) { flock("$pswfile", 8); }
}

#------------------------------------------------------------------------------
# ���K�،��ǉ�����
#------------------------------------------------------------------------------
sub add_word {
	# �G���[����
	if ($in{'word'} eq "") { &error(brank_er); }

	# �Ǘ��t�@�C�������b�N����
	if ($file_lock) { flock("$pswfile",2); }

	# �Ǘ��t�@�C�����J��
	open (IN,"$pswfile") || &error (open_er);
	@line = <IN>;
	close(IN);

	# �����R�[�h�ϊ�(�\���R�[�h�ƕۑ��R�[�h���Ⴄ�ꍇ�̂�)
	$word = $in{'word'};
	if ($page_charset ne $file_charset){
		&jcode::convert( *word, $file_charset);
	}

	# �ȑO�̏����̃S�~���p��
	if ($line[1] !~ /<>/) { $line[1] = "\n"; }

	# ���K�،��̒ǉ�
	$line[1] =~ s/\n$/$word<>\n/;

	# �Ǘ��t�@�C�����i�[����
	open (OUT,">$pswfile") || &error (open_er);
	print OUT @line;
	close(OUT);

	# �Ǘ��t�@�C���̃��b�N����������
	if ($file_lock) { flock("$pswfile", 8); }
}

#------------------------------------------------------------------------------
# ���[�U�폜����
#------------------------------------------------------------------------------
sub user_delete {
	# ���O�t�@�C�������b�N����
	if ($file_lock) { flock("$logfile", 2); }

	# ���O�t�@�C�����I�[�v������
	open (IN,"$logfile") || &error (open_er);
	@line = <IN>;
	close(IN);
	
	# �ԍ����L�����ɃG���[���\��
	if (!$in{'num'}) { error (num_er); }

	# �p�X���[�h���L�����ɃG���[���\��
	if (!$in{'dpas'}) { error (upass_er); }

	# ���O�J�E���g�𕪗�
	$count   = shift(@line);

	# �w�肵���ԍ��̋L�����T��
	$next = 0;
	foreach $lin (@line) {
		@column = split(/<>/,$lin);
		if ($column[0] == $in{'num'}) {
			$dpas = &pass_encode($in{'dpas'},$column[13]);
			if (($column[12] eq $dpas) || ($in{'admin'})) {
				$lin = "";	# �w�肵���L���̍폜
			} else {
				error (upass_er);
			}
		} elsif ($column[1] == $in{'num'}){
			if ($next == 0){
				$next = $column[0];	# �폜�L���̎��̋L���ԍ����ۑ�
			}
			# �폜�L���̎��̋L���ԍ����e�L���ԍ��ɕt���ւ�
			$column[1] = $next;
			$lin = "";
			foreach $col (@column) {
				if ($col eq "\n"){
					$lin .= "$col";
				} else {
					$lin .= "$col<>";
				}
			}
		}
	}

	# ���O�J�E���^���ǉ�
	unshift(@line,"$count");

	# ���O�t�@�C���Ɋi�[����
	open (OUT,">$logfile") || &error (open_er);
	print OUT @line;
	close(OUT);

	# ���O�t�@�C���̃��b�N����������
	if ($file_lock) { flock("$logfile", 8); }
}

#------------------------------------------------------------------------------
# �p�X���[�h�`�F�b�N�iPC�j
#------------------------------------------------------------------------------
sub passchk {
	# �p�X���[�h�t�@�C�����J��
	open (IN,"$pswfile") || &error (open_er);
	@line = <IN>;
	close(IN);

	# �L���̓��e�ԍ�
	$pass = shift(@line);
	$pass =~ s/\n//;

	if ($pass) {
		if ($pass =~ /^\$1\$/) {
			$bsalt = 3;
		} else {
			$bsalt = 0;
		}

		$salt = substr($pass,$bsalt,2);
		$crypt1 = crypt($in{'psw'},$salt);
		$crypt2 = crypt($crypt1,substr($crypt1,-2,2));
		$crypt3 = crypt($crypt2,$salt);
		if ($pass ne $crypt3) { &error(apass_er); }
	} else {
		if ($in{'psw'}) { &error(apass_er); }
	}

	return 0;
}

#------------------------------------------------------------------------------
# �w�b�_�[�w��
#------------------------------------------------------------------------------
sub header {

	# PC����
	if ($agent == 0) {
		$content = "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">\n";
		$content .= "<html lang=\"ja-JP\">\n";
		$content .= "<head>\n";
		$content .= "<title>$pc_title</title>\n";
		$content .= "<META http-equiv=\"Content-type\" content=\"text/html; charset=Shift_JIS\">\n";
		$content .= "<meta http-equiv=\"Content-Style-Type\" content=\"text/css\">\n";
		$content .= "<meta http-equiv=\"Cache-Control\" content=\"no-cache\" />\n";
		$content .= "<link rel=\"stylesheet\" type=\"text/css\" href=\"$cssfile\">";
		$content .= "</HEAD>\n";
		$content .= "<BODY background=\"$bg_img\" bgcolor=\"$bg_clr\" text=\"$tx_clr\" link=\"$li_clr\" ".
		"vlink=\"$vl_clr\" alink=\"$al_clr\">\n";
		$content .= "<BASEFONT size=\"2\">\n";

		# �L���������ꍇ�A�L�����\��
		if ($ad_data) {
			$content .= "$ad_data";
		}

	}
	
	# EZweb����
	elsif ($agent == 1) {
		# �L���b�V������
		if ($headtype == 0) {
			$content = "<HDML version=\"3.0\" markable=\"false\" ttl=\"1\" public=\"false\">\n";
		}elsif ($headtype == 1) {
			$content = "<HDML version=\"3.0\" markable=\"false\" ttl=\"9000\" public=\"false\">\n";
		}
	}

	# i-mode�AJ-Sky�A�h�b�gi�p����
	elsif ($agent =~ /2|3|4/) {
		$content = "<HTML>\n";
		if ($agent != 3) { $content .= "<HEAD>\n"; }
		if ($agent != 3) { $content .= "<TITLE>$c_title</TITLE>\n"; }
		$content .= "<META HTTP-EQUIV=\"Content-type\" CONTENT=\"text/html; charset=Shift_JIS\">\n";
		if ($agent != 3) { $content .= "</HEAD>\n"; }
		$content .= "<BODY BGCOLOR=$bg_clr TEXT=$tx_clr LINK=$li_clr>\n";
	}
	# xhtml�p����
	elsif ($agent == 5) {
		$content = "<?xml version=\"1.0\" encoding=\"Shift_JIS\"?>\n";
		$content .= "<!DOCTYPE html PUBLIC \"-//WAPFORUM//DTD XHTML Mobile 1.0//EN\"\n";
		$content .= " \"http://www.wapforum.org/DTD/xhtml-mobile10.dtd\" >\n";
		$content .= "<html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"ja\">\n";
		$content .= "<head>\n";
		if ($headtype == 0) {
		$content .= "<meta http-equiv=\"Cache-Control\" content=\"no-cache\" />\n";
		}
		$content .= "<meta name=\"vnd.up.markable\" content=\"false\" />\n";
		$content .= "<title>$x_title</title>\n";
		$content .= "</head>\n";
		$content .= "<body bgcolor=\"$bg_clr\" text=\"$tx_clr\" link=\"$li_clr\">\n";

		# ���ʃ��j���[
		$content .= "<wml:do type=\"SOFT1\" label=\"�V�K\">\n";
		$content .= "<go href=\"$script?mode=form\" />\n";
		$content .= "</wml:do>\n";
		
		# ���ʃ��j���[
		$content .= "<wml:do type=\"SOFT2\" label=\"menu\">\n";
		$content .= "<go href=\"$script?mode=menu\" />\n";
		$content .= "</wml:do>\n";
	}

}


#------------------------------------------------------------------------------
# �t�b�^�[�w��
#------------------------------------------------------------------------------
sub footer {
	# PC����
	if ($agent == 0 ) {
		$content .= "<BR><HR size=\"1\">\n";

		# ���쌠�\�� �ύX���Ȃ��ŉ�����
		$content .= "<div align=\"center\"> <SMALL>\n";
		$content .= "mbbs.cgi v1.93 \&amp; v2.02 \&amp; v3.02";
		$content .= " by suzukyu 2000.12\n";
		$content .= "</SMALL></div>\n";

		$content .= "<div align=\"center\"> <SMALL>\n";
		$content .= "<A href=\"http://eztown.org/\">";
		$content .= "mbbs.cgi �� $version";
		$content .= "</A>";
		$content .= " by horn $moddate\n";
		$content .= "</SMALL></div>\n";

		$content .= "</BODY>\n";
		$content .= "</HTML>\n";
		print "Content-type: text/html; charset=Shift_JIS\n\n";
		&jcode::convert( *content, $page_charset);
		print $content;
	}
	# EZweb����
	if ($agent == 1) {
		$content .= "</HDML>\n";
		print "Content-type: text/x-hdml; charset=Shift_JIS\n\n";
		&jcode::convert( *content, $page_charset);
		print $content;
	}

	# i-mode�AJ-Sky�A�h�b�gi�p����
	if ($agent =~ /2|3|4/) {
		$content .= "</BODY>\n";
		$content .= "</HTML>\n";
	}
	# xhtml�p����
	if ($agent == 5) {
		$content .= "</body>\n";
		$content .= "</html>\n";
		$len = length($content);
		print "Content-type: text/html\n";
		print "Content-length: $len\n\n";
		print $content;
	}


}


#------------------------------------------------------------------------------
# ���������N����
#------------------------------------------------------------------------------
sub autolink{
	$_[0] =~ s/(http?\:[\w\.\~\-\/\?\&\=\;\#\:\%]+)/&autoexg($1)/eg;
}

sub autoexg{
	$local = $_[0];
	# PC����
	if ($agent == 0) {
		if ($local =~ /hdml|HDML|wml|WML/) {
			if ($use_ezgate) {
				# EZ GATE�o�R�Ń����N���\��
				$output = "<A href=\"$url_ezgate$local\">";
				if ($pc_pimg){
					$output .= "<img border=\"0\" src=\"$pc_pimg\" alt=\"$local\">";
				} else {
					$output .= "[WAP_HP]";
				}
				$output .= "</A>";
			} else {
				if ($pc_pimg){
					$output .= "<img src=\"$pc_pimg\" alt=\"$local\">";
				} else {
					$output .= "$local";
				}
			}
		} else {
			$output = "<A href=\"$local\">";
			if ($pc_himg){
				$output .= "<img border=\"0\" src=\"$pc_himg\" alt=\"$local\">";
			} else {
				$output = "[HP]";
			}
			$output .= "</A>";
		}
	}
	# EZweb����
	if ($agent == 1) {
		$output = "<BR>";
		$output .= "<A task=\"go\" dest=\"$local\" label=\"�����N\">";
		if ($local =~ /hdml|HDML|wml|WML/) {
			if ($ENV{'HTTP_X_UP_DEVCAP_ISCOLOR'}) {
				$output .= "<img icon=\"155\" alt=\"$local\">";
			} else {
				$output .= "<img icon=\"161\" alt=\"$local\">";
			}
		} else {
			$output .= "<img icon=\"112\" alt=\"$local\">";
		}
		$output .= "</A>";
	}
	# i-mode�AJ-Sky�A�h�b�gi�p����
	if ($agent =~ /2|3|4/) {
		if ($local =~ /hdml|HDML|wml|WML/) {
			# EZ GATE�o�R�Ń����N���\��
			$local = "http://www.note.ne.jp/ezgate2/?$local";
			$output = "<a href=\"$local\">$phone_mark</a>";
		} else {
			$output = "<a href=\"$local\">$home_mark</a>";
		}
	}
	# xhtml�p����
	if ($agent =~ /5/) {
		$output = "<a href=\"$local\" title=\"HP\">$home_mark</a>";
	}
	return($output);
}

#------------------------------------------------------------------------------
# �G���[����
# �����G���[���b�Z�[�W�̓��b�Z�[�W�t�@�C�������肽��
#------------------------------------------------------------------------------
sub error($){
	# �w�b�_�[�\��
	$headtype = 0;
	&header;

	# ���b�Z�[�W������
    my ($error) = @_;
	if ($error eq "open_er")			{ $msge = "�f�[�^�t�@�C�����J���܂���";
	} elsif ($error eq "over_er")		{ $msge = "���e�������������z���܂���";
	} elsif ($error eq "pass_er")		{ $msge = "�p�X���[�h���Ⴂ�܂�(�s��)";
	} elsif ($error eq "upass_er")		{ $msge = "�p�X���[�h���Ⴂ�܂�(����u)";
	} elsif ($error eq "apass_er")		{ $msge = "�p�X���[�h���Ⴂ�܂�(����a)";
	} elsif ($error eq "name_er")		{ $msge = "�����O�����L��������";
	} elsif ($error eq "dai_er")		{ $msge = "�L���̑薼�����L��������";
	} elsif ($error eq "msg_er")		{ $msge = "�L���̖{�������L��������";
	} elsif ($error eq "num_er")		{ $msge = "�폜�����L���ԍ������L��������";
	} elsif ($error eq "mail_er")		{ $msge = "���[���̓��͂��s���ł�";
	} elsif ($error eq "string_er")		{ $msge = "���������������͂��ĉ�����";
	} elsif ($error eq "brank_er")		{ $msge = "�󗓂͎󂯕t���܂���";
	} elsif ($error eq "much_er")		{ $msge = "�Q�̓��͂����v���Ă��܂���";
	} elsif ($error eq "word_er")		{ $msge = "���e���e�ɔ��K�،��$column[$loop]����܂܂��Ă��܂�";
	} elsif ($error eq "writefile_er")	{ $msge = "�������ݏ����t�@�C���̕s���ł�";
	} elsif ($error eq "botdenyfile_er"){ $msge = "�������݋����t�@�C���̕s���ł�";
	} elsif ($error eq "inifile_er")	{ $msge = "�ݒ��t�@�C���̕s���ł�";
	} elsif ($error eq "stop_er")		{ $msge = "���̃X���ւ̏����͂ł��܂����ł��B�B";
	} elsif ($error eq "wkey_er")		{ $msge = "�������Ƃ����������e���Ⴀ���܂��񂩁H";
	} elsif ($error eq "inet_er")		{ $msge = "�z�X�g���������ł��܂����ł����B";
	} elsif ($error eq "socket_er")		{ $msge = "�\�P�b�g�����Ɏ��s���܂����B";
	} elsif ($error eq "port_er")		{ $msge = "�|�[�g�G���[���������܂����B";
	} elsif ($error eq "auth_er")		{ $msge = "�F�؃G���[���������܂����B";
	} else 								{ $msge = "�G���[�ł��B$error";}

	# PC����
	if ($agent == 0) {
		# �^�C�g���\��
		$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"1\" width=\"100%\">\n";
		$content .= "<TR><TH bgcolor=\"$tf_clr\">\n";
		$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"2\" width=\"100%\">\n";
		$content .= "<TR><TH bgcolor=\"$tb_clr\">\n";
		$content .= "<FONT color=\"$ti_clr\">�G���[���b�Z�[�W</FONT>\n";
		$content .= "</TH></TR>\n</TABLE>\n";
		$content .= "</TH></TR>\n</TABLE><BR>\n";

		$content .= "<TABLE width=\"100%\" height=\"50%\">\n";
		$content .= "<TR><TH align=\"center\" valign=\"center\">\n";
		# �G���[�\��
		$content .= "$msge<BR>\n";
		# �߂�
		$content .= "<A href=\"javascript:history.back()\">�߂�</A><BR>\n";
		$content .= "</TH></TR>\n";
		$content .= "</TABLE>\n";
	}
	# EZweb����
	if ($agent == 1) {
		# ���b�Z�[�W�̕\��
		$content .= "<DISPLAY title=\"$wap_title\" bookmark=\"$fscript\">\n";
		$content .= "<ACTION type=\"accept\" task=\"prev\" label=\"�߂�\">\n";
		$content .= "<CENTER>�G���[<BR>\n";
		$content .= "$msge\n";
		$content .= "</DISPLAY>\n";
		$content .= "\n";
	}
	# i-mode�AJ-Sky�A�h�b�gi�p����
	if ($agent =~ /2|3|4/) {
		$content .= "<CENTER>\n";
		$content .= "�G���[<BR><BR>\n";
		$content .= "$msge<BR>\n";
		$content .= "</CENTER>\n";
	}
	# xhtml�p����
	if ($agent =~ /5/) {
		$content .= "<center>\n";
		$content .= "�G���[<br /><br />\n";
		$content .= "$msge<br />\n";
		$content .= "</center>\n";
	}
	# �t�b�^�[�\��
	&footer;
	exit;
}

#------------------------------------------------------------------------------
# ���[�����M����
#------------------------------------------------------------------------------
sub postmail {
	# �����R�[�h�̕ϊ������ɖ߂�
	$massage = $msg;
	$massage =~ s/<BR>/\r\n/g;
	$massage =~ s/&amp:/&/g;
	$massage =~ s/&lt;/</g;
	$massage =~ s/&gt;/>/g;

	# ���[�����M
	open(MAIL,"| $sendmail $mailto") || die();
	$mail_content = "To: $mailto\n";
	$mail_content .= "From: $mailfm\n";
	$mail_content .= "Subject: $mail_title [$new] $dai\n";
	$mail_content .= "MIME-Version: 1.0\n";
	$mail_content .= "Content-type: text/plain; charset=ISO-2022-JP\n";
	$mail_content .= "Content-Transfer-Encoding: 7bit\n";
	$mail_content .= "X-Mailer: $script\n\n";
	$mail_content .= "Date : $date\n";
	$mail_content .= "Time : $time\n";
	$mail_content .= "Name : $name\n";
	$mail_content .= "Host : $host\n";
	$mail_content .= "Addr : $addr\n";
	$mail_content .= "Mail : $in{'mail'}\n";
	$mail_content .= "URL  : $in{'url'}\n";
	$mail_content .= "Title: $dai\n";
	$mail_content .= "Agent: $user_agent\n";
	$mail_content .= "Agent: $agent_name\n";
	$mail_content .= "-----------------------------------------------------\n";
	$mail_content .= "$massage\n";
	$mail_content .= "-----------------------------------------------------\n";
	$mail_content .= "���̋L��������$fscript?mode=view&no=$new&page=1\n";
	$mail_content .= "���̋L�����폜(�Ō��Ƀp�X���[�h�����͂��Ē��ڒ@��)\n";
	$mail_content .= "$fscript?mode=dform&func=delete&col$new=1&psw=�����Ƀp�X\n";
	&jcode::convert( *mail_content, $mail_charset);
	print MAIL $mail_content;
	close(MAIL);
}
#------------------------------------------------------------------------------
# ���[�����M����
#------------------------------------------------------------------------------
sub postmail_mob {
	# �����R�[�h�̕ϊ������ɖ߂�
	$massage = $msg;
	$massage =~ s/<BR>/\r\n/g;
	$massage =~ s/&amp:/&/g;
	$massage =~ s/&lt;/</g;
	$massage =~ s/&gt;/>/g;

	# ���[�����M
	open(MAIL,"| $sendmail $mailto_mob") || die();
	$mail_content = "To: $mailto_mob\n";
	$mail_content .= "From: $mailfm\n";
	$mail_content .= "Subject: $mail_title\n";
	$mail_content .= "MIME-Version: 1.0\n";
	$mail_content .= "Content-type: text/plain; charset=ISO-2022-JP\n";
	$mail_content .= "Content-Transfer-Encoding: 7bit\n";
	$mail_content .= "X-Mailer: $script\n\n";
	$mail_content .= "Sub : $dai\n";
	$mail_content .= "Name : $name\n";
	$mail_content .= "----------------\n";
	$mail_content .= "$massage\n";
	&jcode::convert( *mail_content, $mail_charset);
	print MAIL $mail_content;
	close(MAIL);
}

#------------------------------------------------------------------------------
# ���Ԃ̎擾
# �O���[�o����time,times,date�����邽�߂̏���
#------------------------------------------------------------------------------
# 08.03.07 �O�Ŏg���Ȃ��͂��̕ϐ����B����
sub get_time {

	my $MySec;
	my $MyMin;
	my $MyHour;
	my $MyDay;
	my $MyMon;
	my $MyYear;
	my $MyWday;
	my $MyWeek;
	
	# �^�C���]�[�������{���Ԃɍ��킹��
	$ENV{'TZ'} = "JST-9";

	# ���Ύ���
	$times = time;
	
	($MySec,$MyMin,$MyHour,$MyDay,$MyMon,$MyYear,$MyWday) = localtime($times);
	$MyYear += 1900;
	$MyMon++;
	if ($MyMin  < 10) { $MyMin = "0$MyMin"; }
	if ($MyHour < 10) { $MyHour= "0$MyHour";}
	if ($MyDay  < 10) { $MyDay = "0$MyDay"; }
	if ($MyMon  < 10) { $MyMon = "0$MyMon"; }

	$MyWeek = ('��','��','��','��','��','��','�y') [$MyWday];

	# ���t
	$date = "$MyYear\/$MyMon\/$MyDay($MyWeek)";

	# ����
	$time = "$MyHour\:$MyMin";
}

#------------------------------------------------------------------------------
# �z�X�g���̎擾
#------------------------------------------------------------------------------
sub get_host {
	$host = $ENV{'HTTP_X_UP_SUBNO'};
	$addr = $ENV{'REMOTE_ADDR'};

	if ($get_remotehost) {
		if ($host eq "" || $host eq "$addr") {
			$host = gethostbyaddr(pack("C4", split(/\./, $addr)), 2);
		}
	}
	if ($host eq "") { $host = $addr; }
}

#------------------------------------------------------------------------------
# �N�b�L�[�̔��s
#------------------------------------------------------------------------------
# (08.03.07)�O�Ŏg���Ȃ��͂��̕ϐ����B����
sub set_cookie {
	my $MyGSec;
	my $MyGMin;
	my $MyGHour;
	my $MyGMday;
	my $MyGMon;
	my $MyGYear;
	my $MyGWday;
	my $MyMonth;
	my $MyYoubi;
	my $MyUrl;
	my $MyDateGMT;
	my $MyCookie;
	my $MyEnName;
	
	($MyGSec,$MyGMin,$MyGHour,$MyGMday,$MyGMon,$MyGYear,$MyGWday)
					 = gmtime(time + 60*24*60*60);

	$MyGYear += 1900;
	if ($MyGSec  < 10) { $MyGSec  = "0$MyGSec";  }
	if ($MyGMin  < 10) { $MyGMin  = "0$MyGMin";  }
	if ($MyGHour < 10) { $MyGHour = "0$MyGHour"; }
	if ($MyGMday  < 10) { $MyGMday  = "0$MyGMday"; }

	$MyMonth = ('Jan','Feb','Mar','Apr','May',
			'Jun','Jul','Aug','Sep','Oct','Nov','Dec') [$MyGMon];
	$MyYoubi = ('Sun','Mon','Tue','Wed','Thu','Fri','Sat') [$MyGWday];

	$MyUrl = $in{'url'};
	$MyUrl =~ s/http\:\/\///;

	$MyDateGMT = "$MyYoubi, $MyGMday\-$MyMonth\-$MyGYear $MyGHour:$MyGMin:$MyGSec GMT";
	$MyCookie = "name\:$cook_name\,mail\:$in{'mail'}\,url\:$MyUrl\,dpas\:$in{'dpas'}";


	# EZweb����
	if ($agent =~ /1|5/) {
		# �G���R�[�h����
		$MyEnName = $cook_name;
		$MyEnName =~ s/([^0-9A-Za-z_ ])/'%'.unpack('H2',$1)/ge;
		$MyEnName =~ s/\s//g;

		print "Set-Cookie: mb_name=name:$MyEnName; expires=$MyDateGMT\n";
		print "Set-Cookie: mb_mail=mail:$in{'mail'}; expires=$MyDateGMT\n";
		print "Set-Cookie: mb_url=url:$MyUrl; expires=$MyDateGMT\n";
		print "Set-Cookie: mb_dpas=dpas:$in{'dpas'}; expires=$MyDateGMT\n";
		print "Set-Cookie: mb_ver=ver:1; expires=$MyDateGMT\n";
	}

	# PC�AJ-Sky�A�h�b�gi����
	else {
		print "Set-Cookie: multi_bbs=$MyCookie; expires=$MyDateGMT\n";
	}
}
#------------------------------------------------------------------------------
# �N�b�L�[���֏���
#------------------------------------------------------------------------------
sub save_user_data {

	my $MySubID;
	my $MyUrl;
	my @MyLine;
	my $MyNum;
	my $MyNumMax;
	my $MyNewNum;
	my $MyFlagEnd;
	my @MyColumn;

	$MySubID = $ENV{'HTTP_X_UP_SUBNO'};

	$MyUrl = $in{'url'};
	$MyUrl =~ s/http\:\/\///;

	# �t�@�C�������b�N�����B
	if ($file_lock) { flock("$userfile", 2); }

	# ���O�t�@�C�����I�[�v������
	open (IN,"$userfile") || &error (open_er);
	@MyLine = <IN>;
	close(IN);

	$MyNum     = 0;				# 
	$MyNumMax = $#MyLine;			# �o�^�f�[�^��
	$MyFlagEnd = 0;

	while ($MyNum <= $MyNumMax) {
		# �e�s�𕪊����A�z���Ɋi�[
		@MyColumn = split(/<>/,$MyLine[$MyNum]);
		
		if ($MyColumn[0] =~ /$subid/) {
			$MyLine[$MyNum] = "";	# �N���A
			$MyLine[$MyNum] .= "$MySubID<>$cook_name<>$in{'mail'}<>$MyUrl<>\n";
			$MyFlagEnd = 1;
		}

		$num++;
	}

	if(!$MyFlagEnd){
		$MyNewNum = $MyNumMax + 1;
		$MyLine[$MyNewNum] = "$MySubID<>$cook_name<>$in{'mail'}<>$MyUrl<>\n";
	}
	
	open (OUT,">$userfile") || &error (open_er);
	print OUT @MyLine;
	close(OUT);

	# �t�@�C���̃��b�N�����������B
	if ($file_lock) { flock("$userfile", 8); }
}

#------------------------------------------------------------------------------
# �N�b�L�[�̎擾
#------------------------------------------------------------------------------
sub get_cookie {
	@pairs = split(/\;/, $ENV{'HTTP_COOKIE'});
	foreach $pair (@pairs) {
		local($name, $value) = split(/\=/, $pair);
		$name =~ s/ //g;
		$DUMMY{$name} = $value;
	}

	# EZweb����
	if ($agent == 1) {
		local($name, $value) = split(/\:/, $DUMMY{'mb_name'});
		$COOKIE{$name} = $value;
		local($mail, $value) = split(/\:/, $DUMMY{'mb_mail'});
		$COOKIE{$mail} = $value;
		local($url, $value) = split(/\:/, $DUMMY{'mb_url'});
		$COOKIE{$url} = $value;
		local($dpas, $value) = split(/\:/, $DUMMY{'mb_dpas'});
		$COOKIE{$dpas} = $value;
		local($ver, $value) = split(/\:/, $DUMMY{'mb_ver'});
		$COOKIE{$ver} = $value;
	}
	# PC�AJ-Sky�A�h�b�gi����
	else {
		@pairs = split(/\,/, $DUMMY{'multi_bbs'});
		foreach $pair (@pairs) {
			local($name, $value) = split(/\:/, $pair);
			$COOKIE{$name} = $value;
		}
	}

	$c_name = $COOKIE{'name'};
	$c_mail = $COOKIE{'mail'};
	$c_url  = $COOKIE{'url'};
	$c_dpas = $COOKIE{'dpas'};
	$c_ver  = $COOKIE{'ver'};


	# �N�b�L�[�������̕����R�[�h�ϊ�
	if (($agent != 1|5) && ($page_charset ne $file_charset)){
		&jcode::convert(*c_name, $file_charset);
	}
}

#------------------------------------------------------------------------------
# �N�b�L�[���֏����i�擾�j
#------------------------------------------------------------------------------
sub get_user_data {
	my $MySubID;
	my @MyDUsr;
	my $MyFSub;
	$MySubID = $ENV{'HTTP_X_UP_SUBNO'};

	# �t�@�C���̃I�[�v��
	open (USR, $userfile) || &error("�t�@�C���$userfile����J���܂���");
		@MyDUsr = <USR>;
	close(USR);

	foreach (@MyDUsr) {
		if ($_ !~ /$MySubID/) { next; }
		($MyFSub,$c_name,$c_mail,$c_url) = split(/<>/);
		last;
	}

	if ($agent_name eq '') { $agent_name = $devid; }


}
#------------------------------------------------------------------------------
# �p�X���[�h�Í�������
#------------------------------------------------------------------------------
sub pass_encode {
	$salt = substr($_[1],-2,2);
	$crypt1 = crypt($_[0],$salt);
	$crypt2 = crypt($crypt1,substr($crypt1,-2,2));
	$crypt3 = crypt($crypt2,$salt);
	return($crypt3);
}

#------------------------------------------------------------------------------
# �@�\�o�[�\������
#------------------------------------------------------------------------------
sub topmenu {
	$content .= "<hr size=\"1\" width=\"80%\">\n";
	$content .= "<div align=\"center\"> \n";
	if ($pc_home) {
		$content .= "[<a class=\"topmenu\" href=\"$pc_home\">�z�[���y�[�W</a>]\n";
	}
	$content .= "[<a class=\"topmenu\" href=\"$pc_help\">�g��������</a>]\n";
	$content .= "[<a class=\"topmenu\" href=\"$script?mode=all\">���ׂĕ\\��</a>]\n";
	$content .= "[<a class=\"topmenu\" href=\"$script?mode=tree\">�c���[�\\��</a>]\n";
	$content .= "[<a class=\"topmenu\" href=\"$script?mode=form\">�V�K������</a>]\n";
	$content .= "[<a class=\"topmenu\" href=\"$script?mode=sform\">�L���̌���</a>]\n";
	if(!$SessionFlag){
		$content .= "[<a class=\"topmenu\" href=\"$script?mode=admin\">�Ǘ��Ґ��p</a>]\n";
	} else {
		$content .= "[<a class=\"topmenu\" href=\"$script?mode=passform\">�Ǘ��Ґ��p</a>]\n";
	}
	$content .= "</div>\n";
	$content .= "<hr size=\"1\" width=\"80%\">\n";
}

#------------------------------------------------------------------------------
# �폜����
#------------------------------------------------------------------------------
sub del_ex {
	# �w�b�_�[�o��
	$headtype = 1;
	&header;

	# �^�C�g��
	$content .= "<center><a href=\"$script\">�No.$in{'num'}�̍폜���������܂����B�</a></center>\n";

	# �t�b�^�[�o��
	&footer;

	exit;
	
}

#------------------------------------------------------------------------------
# device.txt�`�F�b�N���X�V����
#	���̂����S�i�ƌ��i�𕪊��������������Ǝv��
#------------------------------------------------------------------------------
# 08.02.15 	�V�K�쐬
# 08.03.07	���[�J���ϐ����𓝈�
sub CheckDeviceTxt {
	use Socket;     # Socket ���W���[�����g��

	my $MyHost = $DeviceInfo_host;
	my $MyIaddr;
	my $MySockAddr;
	my $MyDateInfoDir = $CheckDevInfoDate;
	my $MyDataDir = $CheckDevInfoData;
	my $MyLogFile = $CheckDevInfoLog;
	my $MySrvFileDate;
	my @MyLastUpdate;
	my @MyLine;
	my @MyLine2;

	# http://eztown.org/pc/ezwebcgi/device.shtml
	# �����AYYYYMMDDHHMMSS��device.txt�̍X�V�f�[�^���擾�ł���
	# ���[�J���̍X�V�����Ɣ��r���A�V��������DL���ĕʖ��ۑ�
	# �������ɁA���t�@�C�����폜���A���l�[���ۑ�
	# ���ׂĂ��I���������_�ł݂������񂱂��Ղ��[��

	# �{�̂̍X�V�ɂ����̂����Ή������������A�����������̂ŁA�����Ƃ�����
	# DL����DL�t�H���_�ɕۊǂ��邭�炢���E�E�E�H

	my $port = getservbyname('http', 'tcp');

	# �z�X�g�����AIP �A�h���X�̍\���̂ɕϊ�
	$MyIaddr = inet_aton($MyHost) || &error (inet_er);

	# �|�[�g�ԍ��� IP �A�h���X���\���̂ɕϊ�
	$MySockAddr = pack_sockaddr_in($port, $MyIaddr);

	# �\�P�b�g����
	socket(SOCKET, PF_INET, SOCK_STREAM, 0) || &error (socket_er);

	# �w���̃z�X�g�̎w���̃|�[�g�ɐڑ�
	connect(SOCKET, $MySockAddr) || &error (port_er);

	# �t�@�C���n���h�� SOCKET ���o�b�t�@�����O���Ȃ�
	select(SOCKET); $|=1; select(STDOUT);

	print SOCKET "GET $MyDateInfoDir HTTP/1.0\r\n";
	print SOCKET "Host: $MyHost:$port\r\n";
	print SOCKET "\r\n";


	# �w�b�_�������󂯎���
	while (<SOCKET>){
		# ���s�݂̂̍s�Ȃ烋�[�v�𔲂���
		m/^\r\n$/ and last;
	}

	# �{�f�B�������󂯎����A�\��
	while (<SOCKET>){
		$MySrvFileDate .= $_;
	}

	# ���ʂȉ��s�΍�
	$MySrvFileDate =~ s/\r//g;
	$MySrvFileDate =~ s/\n//g;

	# �ۑ��t�@�C�����J��
	open (IN,"$MyLogFile") || &error (open_er);
		@MyLastUpdate = <IN>;
	close(IN);

	# ���ʂȉ��s�΍�
	$MyLastUpdate[0] =~ s/\r//g;
	$MyLastUpdate[0] =~ s/\n//g;

	if($MySrvFileDate > $MyLastUpdate[0]){
		# update����
		# �\�P�b�g����
		socket(SOCKET, PF_INET, SOCK_STREAM, 0) || &error (socket_er);

		# �w���̃z�X�g�̎w���̃|�[�g�ɐڑ�
		connect(SOCKET, $MySockAddr) || &error (port_er);

		# �t�@�C���n���h�� SOCKET ���o�b�t�@�����O���Ȃ�
		select(SOCKET); $|=1; select(STDOUT);

		# �����肭������
		print SOCKET "GET $MyDataDir HTTP/1.0\r\n";
		print SOCKET "Host: $MyHost:$port\r\n";
		print SOCKET "\r\n";


		# �w�b�_�������󂯎���
		while (<SOCKET>){
			# ���s�݂̂̍s�Ȃ烋�[�v�𔲂���
			m/^\r\n$/ and last;
		}

		# �z�����錾
		# �{�f�B�������󂯎����A�\��
		while (<SOCKET>){
			$MyLine[0] .= $_;
		}

		# �t�@�C�������b�N�����B
		if ($file_lock) { flock("$devfile", 2); }

		# ���O�t�@�C�����I�[�v������
		open (OUT,"> $devfile") || &error (open_er);
		print OUT @MyLine;
		close(OUT);

		# �t�@�C���̃��b�N�����������B
		if ($file_lock) { flock("$devfile", 8); }

		$MyLine2[0] = $MySrvFileDate;

		# �t�@�C�������b�N�����B
		if ($file_lock) { flock("$MyLogFile", 2); }

		# ���O�t�@�C�����I�[�v������
		open (OUT,"> $MyLogFile") || &error (open_er);
		print OUT @MyLine2;
		close(OUT);

		# �t�@�C���̃��b�N�����������B
		if ($file_lock) { flock("$MyLogFile", 8); }

		$deviceUpdateFlag = 1;

	} else {
		$deviceUpdateFlag = 0;
	}

}