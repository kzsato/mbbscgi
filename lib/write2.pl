# =============================================================================
# File name: write.cgi v1.00
# Copyright: horn@eztown.org
#            (URL: http://eztown.org/)
#
# ���̃t�@�C����mbbs.cgi(��)�̏������ݏ����t�@�C���ł��B
# =============================================================================

$writever = "1.036";

# (08.03.06)�N�b�L�[�����̕����������ύX

#------------------------------------------------------------------------------
# ���e����
#------------------------------------------------------------------------------
sub write {

if ($agent == 1){
	$agent_name = "ezweb";
} elsif ($agent == 2){
	$agent_name = "i-mode";
} elsif ($agent == 3){
	$agent_name = "J-Sky";
} elsif ($agent == 4){
	$agent_name = 'H"';
} elsif ($agent == 5){
	$agent_name = 'ezweb';
} else {
	$agent_name = "PC";
}

	#	IPCheck�t�B���^�[�ɑΉ�������
	if($use_ipcheck){
		use IP_Base;
		## IP Spam Filter START_
		my $myfol = './ipcheck';
		my $ctype = 1;
		if (IP_Base::_allow_mail_address($in{'mail'},$myfol) == 1){$ctype = 4;}
		if (IP_Base::_check_ip_base($addr,$myfol,$ctype,'BBS')==0){&error (ipchk_er);}
		## IP Spam Filter END_
	}
	
	# �^�O�̋֎~����
	$in{'name'} =~ s/&/&amp;/g;
	$in{'name'} =~ s/</&lt;/g;
	$in{'name'} =~ s/>/&gt;/g;
	$in{'dai'}	=~ s/&/&amp;/g;
	$in{'dai'}  =~ s/</&lt;/g;
	$in{'dai'}  =~ s/>/&gt;/g;
	$in{'msg'}	=~ s/&/&amp;/g;
	$in{'msg'}  =~ s/</&lt;/g;
	$in{'msg'}  =~ s/>/&gt;/g;

	# ���s�̕ϊ�����
	$in{'msg'}  =~ s/\r\n/<BR>/g;
	$in{'msg'}  =~ s/\r/<BR>/g;
	$in{'msg'}  =~ s/\n/<BR>/g;

	# �s���ȉ��s�̔p�������iEZweb�����̓��͑΍��j
	$in{'name'} =~ s/\r//g;
	$in{'name'} =~ s/\n//g;
	$in{'dai'}  =~ s/\r//g;
	$in{'dai'}  =~ s/\n//g;
	$in{'mail'} =~ s/\r//g;
	$in{'mail'} =~ s/\n//g;
	$in{'url'}  =~ s/\r//g;
	$in{'url'}  =~ s/\n//g;
	$in{'dpas'} =~ s/\r//g;
	$in{'dpas'} =~ s/\n//g;

	# �s���ȋ󗓂̔p�������iEZweb�̃G���[�r���ׁ̈j
	$in{'mail'} =~ s/ //g;
	$in{'mail'} =~ s/�@//g;
	$in{'url'}  =~ s/ //g;
	$in{'url'}  =~ s/�@//g;

	$cook_name = "$in{'name'}";
	
	# �g���b�v
	$in{'name'} =~ s/��/��/g;
	if ($in{'name'}=~/#(.+)/){
		$key = $1;
		$salt = substr($key."H.", 1, 2);
		$salt =~ s/[^\.-z]/\./go;
		$salt =~ tr/:;<=>?@[\\]^_`/ABCDEFGabcdef/;
		$trip = substr(crypt($key, $salt), -8);
		#$in{'name'} =~ s/#.+/$trip/;
		 $in{'name'} =~ s/#.+//;
	}

	
	# �G���[����
	if ($in{'name'} eq "")	{ &error(name_er); }
	if ($in{'name'} eq " ")	{ &error(name_er); }
	if ($in{'name'} eq "�@"){ &error(name_er); }
	if ($in{'dai'} eq "")	{ &error(dai_er); }
	if ($in{'dai'} eq " ")	{ &error(dai_er); }
	if ($in{'dai'} eq "�@")	{ &error(dai_er); }
	if ($in{'msg'} eq "")	{ &error(msg_er); }
	if ($in{'msg'} eq " ")	{ &error(msg_er); }
	if ($in{'msg'} eq "�@")	{ &error(msg_er); }
	if ($in{'mail'} && $in{'mail'} !~ /(.+)\@.(.+)/) 
	{ &error(mail_er); }

	# �����R�[�h�ϊ�(�\���R�[�h�ƕۑ��R�[�h���Ⴄ�ꍇ�̂�)
	$name	= $in{'name'};
	$dai	= $in{'dai'};
	$msg	= $in{'msg'};
	if ($page_charset ne $file_charset) {
		&jcode::convert(*name, $file_charset);
		&jcode::convert(*dai , $file_charset);
		&jcode::convert(*msg , $file_charset);
	}

	# ���J�i�͂����Â�
	if ($hankana) {
	&jcode::h2z_sjis(\$name);
	&jcode::h2z_sjis(\$dai);
	&jcode::h2z_sjis(\$msg);
	}

	# ���e�T�C�Y����
	if (($length_chk) && (length($msg) > $length_def)) { &error(over_er); }

	# �Ǘ��t�@�C�����J��
	open (IN,"$pswfile") || &error (open_er);
	@line = <IN>;
	close(IN);

	# ���K�،��z���̍쐬
	@column = split(/<>/,$line[1]);
	$num = $#column;
	$line[1] = '';

	# ���K�،��ɂ����r������
	$loop = 0;
	while ($loop < $num) {
		if (index($name,$column[$loop]) >= 0){ &error(word_er); }
		if (index($dai,$column[$loop]) >= 0){ &error(word_er); }
		if (index($msg,$column[$loop]) >= 0){ &error(word_er); }
		if (index($mail,$column[$loop]) >= 0){ &error(word_er); }
		if (index($url,$column[$loop]) >= 0){ &error(word_er); }
		$loop++;
	}

	# ���Ԃ̎擾
	&get_time;

	# �z�X�g���̎擾
#	&get_host;

	# ���O�t�@�C�������b�N����
	if ($file_lock) { flock("$logfile", 2); }

	# ���O�t�@�C�����J��
	open (IN,"$logfile") || &error (open_er);
	@line = <IN>;
	close(IN);

	# �Q�d���e�̋֎~
	$double = 0;
	foreach $col (@line) {
		@column = split(/<>/,$col);
		if ($name eq $column[4] && $dai eq $column[5] && $msg eq $column[6]) { 
			$double = 1;
			last;
		}
	}
	if ($double == 0) {
		# �L���̓��e�ԍ�
		$new = shift(@line);
		$new =~ s/\n//;
		$new++;

		# �e�L���̃��X�ԍ�����
		$res = $in{'res'};
		if (!$res) { $res = $new; }

		# URL�̋L���������Ƃ��󗓂ɂ���
		if ($in{'url'} eq "http://") { $in{'url'} = ""; }

		# �p�X���[�h�Í�������
		$dpas = &pass_encode($in{'dpas'},$times);

		# ���̓f�[�^�����ׂ�
		$column  = "";				# ����������
		$column .= "$new<>";		# �L���ԍ�
		$column .= "$res<>";		# �e�L���ԍ�
		$column .= "$date<>";		# ���t
		$column .= "$time<>";		# ����
		$column .= "$name<>";		# ���O
		$column .= "$dai<>";		# �薼
		$column .= "$msg<>";		# �L��
		$column .= "$in{'mail'}<>";	# ���[��
		$column .= "$in{'url'}<>";	# URL
		$column .= "$agent_name<>";		# �[������
		$column .= "$host<>";		# �z�X�g��
		$column .= "$addr<>";		# IP�A�h���X
		$column .= "$dpas<>";		# �p�X���[�h
		$column .= "$times<>";		# ���Ύ���
		$column .= "$ENV{'HTTP_USER_AGENT'}<>";	# UA
		$column .= "$trip<>";		# trip
		$column .= "\n";			# ���s�R�[�h

		# �e�L���̏ꍇ
		if ($new == $res){
			unshift (@line,$column);
			@newline = @line;
		}
		# ���X�L���̏ꍇ
		if ($new != $res){
			# �V�K�z��������
			@newline = ();

		if ($res_sort){
			# ���X�̏����ꂽ�c���[�𔲂��o���Đ擪�ɂ���
			foreach $col (@line) {
				($num,$res_no) = split(/<>/,$col);
				if ($num eq $res) {
					# �e�L���̏���
					push (@newline,$col);
					$col = "";

					# ���X�L���̒ǉ�
					push (@newline,$column);
					next;
				}
				if ($res_no eq $res) {
				push (@newline,$col);
				$col = "";
				}
			}
		} else {
			# ���X�̏����ꂽ�c���[�𔲂��o���Đ擪�ɂ���
			foreach $col (@line) {
				($num,$res_no) = split(/<>/,$col);
				if ($res_no eq $res) {
					push (@newline,$col);
					$col = "";
				}
			}

			# ���X�L���̒ǉ�
			push (@newline,$column);
}
			# �c���L���������o��
			foreach $col (@line) {
				push (@newline,$col);
			}
		}

		# ���O�J�E���^���ǉ�
		unshift(@newline,"$new\n");

		# ���O�t�@�C�����i�[����
		open (OUT,">$logfile") || &error (open_er);
		print OUT @newline;
		close(OUT);

		# ���[���̔��s
		if ($mailing) { &postmail; }

		# ���[���̔��s �������̃A�h���X�����͂����Ă����Ƃ��͔��s���Ȃ�
		if ($mailing_mob) {
		#	if ($mailto ne $in{'mail'}){
				&postmail_mob;
		#	}
		}

		# �N�b�L�[�̔��s�ii-mode�ł̓N�b�L�[������ezweb�ł͑��֏����j
		if ($use_cookie){
			if($agent != 2|5) {
				&set_cookie;
			} elsif($agent == 5){
				&save_user_data;
			}
		}
	}

	# ���O�t�@�C���̃��b�N����������
	if ($file_lock) { flock("$logfile", 8); }

	return;
}

1;
