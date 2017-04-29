# =============================================================================
# File name: write.cgi v1.040
# Copyright: horn@eztown.org
#            (URL: http://eztown.org/)
#
# ���̃t�@�C����mbbs.cgi(��)�̏������ݏ����t�@�C���ł��B
# =============================================================================

$writever = "1.040";

#------------------------------------------------------------------------------
# ���e����
#------------------------------------------------------------------------------
sub write {
	if ($host =~ /ezweb|ido|brew/){
		&kddichk;
	} else {
		&othchk;
	}
	&writeon;
}

sub kddichk {
	# �^������
	if ($user_agent =~ /^KDDI/) {
		$user_agent =~ /KDDI\-([\w]+)\s/;
		$devid = $1;
	} elsif ($user_agent =~ /KDDI/) {
		$user_agent =~ /Mozilla\/[0-9].[0-9] \(compatible\; MSIE [0-9].[0-9]\; KDDI\-([\w]+)/;
		$devid = $1;
		$pcsv = "1";

	} else {
		$user_agent =~ /UP\.Browser\/[0-9\.]+\-([\w]+) /;
		$devid = $1;
	}
	# �t�@�C���̃I�[�v��
	open (DEV, $devfile) || &error("�t�@�C���$file����J���܂���");

	# �t�@�C���̓Ǎ���
	@devs = <DEV>;

	# �t�@�C���̃N���[�Y
	close(DEV);

	foreach (@devs) {
		if ($_ !~ /$devid/) { next; }
		($dev, $agent_name) = split(/<>/);
		last;
	}

	if ($agent_name eq '') { $agent_name = $devid; }

	# �n�攻��
	if ( $host =~ /^050/ ) {
		if ($host =~ /^0500004|^0500005|^05001010|^05001011|^05001012|^05001015|^0501004|^0502004/) {
			$area_name = '�֓�';
		} elsif ($host =~ /^050002|^05001030|^05001031|^05001050|^0501022/) {
			$area_name = '����';
		} else {
			$area_name = '(IDO)';
		}
	} elsif ( $host =~ /^070/ )	{
		if ($host =~ /^0700/) {
			$area_name .= '�֐�';
		} elsif ($host =~ /^0701/) {
			$area_name = '���B';
		} elsif ($host =~ /^0702/) {
			$area_name = '����';
		} elsif ($host =~ /^0703/) {
			$area_name = '���k';
		} elsif ($host =~ /^0704/) {
			$area_name = '�k��';
		} elsif ($host =~ /^0705/) {
			$area_name = '�k�C��';
		} elsif ($host =~ /^0706/) {
			$area_name = '�l��';
		} elsif ($host =~ /^0707/) {
			$area_name = '����';
		} else {
			$area_name = '(CT)';
		}
	} elsif ( $host =~ /^080/ ) {
		if ($host =~ /^080009|^08001010/) {
			$area_name = '�֓�';
		} elsif ($host =~ /^08011030|^08010945/) {
			$area_name = '�֐�';
		} elsif ($host =~ /^08021020/) {
			$area_name = '���C';
		} else {
			$area_name = '(tu-ka)';
		}
	} elsif ( $pcsv == "1" ) {
		$area_name = 'PCSV';
	} else {
		$area_name = '';
	}
	if ($area_name =~ /./) {$agent_name = "$agent_name\/$area_name";}

}

sub othchk {	
	# i-mode
	if ($user_agent =~ /DoCoMo\//) {

		# �[�������̎��W
		if ($user_agent !~ /\(/) {
			($career, $ver, $agent_name, $max_packet, $mid) = split(/\//,$user_agent);
		} else {
			# FOMA�p����
			( $career, $ver, $agent_name, $tmp ) = split( /[\/\s\(\)]+/, $user_agent );
		}
		$area_name = '';
	}
	#J-Sky
	elsif ($user_j_agent ne ''){
		# �[�������̎��W
		if ($user_agent !~ /\(/) {
			($career, $ver, $agent_name, $max_packet, $mid) = split(/\//,$user_agent);
		}
		$area_name = '';
	}
	#H"
	elsif ($user_agent =~ /PDXGW\/\d\.\d/)	{
		$agent_name = $agent_name_1 = 'H"';
		$area_name = '';
	}
	
	#Air H" Phone
	elsif ($user_agent =~ /(DDIPOCKET|WILLCOM)/i) {

		$user_agent =~ /(DDIPOCKET|WILLCOM)\;.+\/(.*)\/2?\;?([0-9\.]*)\/(.*)\/([cC][0-9]*)\)/i;
		($career, $agent_name, $ver, $tmp, $max_packet) = ($1, $2, $3, $4, $5); 
		$agent_name =~ s/AH\-J3001V\,AH\-J3002V/AH\-J3001�2V/;
		
		$area_name = 'Willcom';

	}

	elsif ($user_agent =~ /(AH\-|WX3)/) {

		$user_agent =~ /Mozilla\/4.0 \(compatible\; MSIE 6.0\; [A-Z]+\/([\w]+)/;
		$agent_name = $1;
		$agent_name =~ s/AH\-J3001V\,AH\-J3002V/AH\-J3001�2V/;

		$area_name = 'PCSV';

	}

# �l�I����
# �Q�l�Fhttp://www.bayashi.net/st/pdmemo/ua.html

	else	{

		# jig browser web
		if ($user_agent =~ /Mozilla\/4.0 \(jig browser/) {
			$user_agent =~ /Mozilla\/4.0 \(jig browser web\; [0-9].[0-9].[0-9]\; ([\w]+)/;
			$devid = $1;
			# �t�@�C���̃I�[�v��
			open (DEV, $devfile) || &error("�t�@�C���$devfile����J���܂���");

			# �t�@�C���̓Ǎ���
			@devs = <DEV>;

			# �t�@�C���̃N���[�Y
			close(DEV);

			foreach (@devs) {
				if ($_ !~ /$devid/) { next; }
				($dev, $agent_name) = split(/<>/);
				last;
			}

			if ($agent_name eq '') { $agent_name = $devid; }
		}



		if ($user_agent =~ /AOL/)				{ $agent_name = 'AOL'; }	
		elsif ($user_agent =~ /OmniWeb\/1/i)	{ $agent_name = 'OmniWeb1'; }
		elsif ($user_agent =~ /OmniWeb\/2/i)	{ $agent_name = 'OmniWeb2'; }
		elsif ($user_agent =~ /OmniWeb\/3/i)	{ $agent_name = 'OmniWeb3'; }
		elsif ($user_agent =~ /OmniWeb\/4/i)	{ $agent_name = 'OmniWeb4'; }
		elsif ($user_agent =~ /OmniWeb/i)		{ $agent_name = 'OmniWeb'; }
		elsif ($user_agent =~ /Opera\/5/i)		{ $agent_name = 'Opera5'; }
		elsif ($user_agent =~ /Opera 5/i)		{ $agent_name = 'Opera5'; }
		elsif ($user_agent =~ /Opera 6/i)		{ $agent_name = 'Opera6'; }
		elsif ($user_agent =~ /Opera\/6/i)		{ $agent_name = 'Opera6'; }
		elsif ($user_agent =~ /Opera\/7/i)		{ $agent_name = 'Opera7'; }
		elsif ($user_agent =~ /Opera 7/i)		{ $agent_name = 'Opera7'; }
		elsif ($user_agent =~ /Opera\/8/i)		{ $agent_name = 'Opera8'; }
		elsif ($user_agent =~ /Opera 8/i)		{ $agent_name = 'Opera8'; }
		elsif ($user_agent =~ /Opera\/9/i)		{ $agent_name = 'Opera9'; }
		elsif ($user_agent =~ /Opera 9/i)		{ $agent_name = 'Opera9'; }
		elsif ($user_agent =~ /Opera/i)			{ $agent_name = 'Opera'; }
		elsif ($user_agent =~ /Lunascape/i)		{ $agent_name = 'Lunascape'; }
		elsif ($user_agent =~ /MSNbMSFT/i)		{ $agent_name = 'MSNExp.'; }
		elsif ($user_agent =~ /SH2101V/i)		{ $agent_name = 'SH2101V'; }
		elsif ($user_agent =~ /MSIE 3/i)		{ $agent_name = 'IE3'; }
		elsif ($user_agent =~ /MSIE 4/i)		{ $agent_name = 'IE4'; }
		elsif ($user_agent =~ /MSIE 5/i)		{ $agent_name = 'IE5'; }
		elsif ($user_agent =~ /MSIE 6/i)		{ $agent_name = 'IE6'; }
		elsif ($user_agent =~ /MSIE 7/i)		{ $agent_name = 'IE7'; }
		elsif ($user_agent =~ /MSIE 8/i)		{ $agent_name = 'IE8'; }
		elsif ($user_agent =~ /Netscape ?6/i)	{ $agent_name = 'Netscape6'; }
		elsif ($user_agent =~ /Netscape\/7/i)	{ $agent_name = 'Netscape7'; }
		elsif ($user_agent =~ /Gecko/i)	{
			if ($user_agent =~ /Netscape/i)	{ $agent_name = 'Netscape6/7'; }
			elsif ($user_agent =~ /chimera/i)	{ $agent_name = 'Chimera'; }
			else { $agent_name = 'Mozilla'; }
		}
		elsif ($user_agent =~ /^Mozilla\/2/)	{
			unless ($user_agent =~ /compatible/){ $agent_name = 'Netscape2';}
		}
		elsif ($user_agent =~ /^Mozilla\/3/)	{
			unless ($user_agent =~ /compatible/){ $agent_name = 'Netscape3';}
		}
		elsif ($user_agent =~ /^Mozilla\/4/)	{
			unless ($user_agent =~ /compatible/){ $agent_name = 'Netscape4';}
		}	
		elsif ($user_agent =~ /Mozilla\/5/i)	{ $agent_name = 'Mozilla'; }
		elsif ($user_agent =~ /Lynx/i)			{ $agent_name = 'Lynx'; }
		elsif ($user_agent =~ /Cuam/i)			{ $agent_name = 'Cuam'; }
		elsif ($user_agent =~ /WWWC/i)			{ $agent_name = 'WWWC'; }
		elsif ($user_agent =~ /L\-mode/i)		{ $agent_name = 'L-mode'; }
		elsif ($user_agent =~ /Internet Ninja/i){ $agent_name = 'Internet Ninja'; }
		elsif ($user_agent =~ /WebTV/i)			{ $agent_name = 'WebTV'; }
		elsif ($user_agent =~ /DreamPassport/i)	{ $agent_name = 'DreamCast'; }
		elsif ($user_agent =~ /Lite/i)			{ $agent_name = 'Lite'; }
		elsif ($user_agent =~ /iCab/i)			{ $agent_name = 'iCab'; }
		elsif ($user_agent =~ /Hot Java/i)		{ $agent_name = 'Hot Java'; }
		elsif ($user_agent =~ /w3m/i)			{ $agent_name = 'w3m'; }
		else {
			$agent_name = 'PC';
			$area_name = '';
		}


		if ($user_agent =~ /win[dows ]*95/i)			{ $area_name = 'Win95'; }
		elsif ($user_agent =~ /win[dows ]*ME/i)			{ $area_name = 'WinMe'; }
		elsif ($user_agent =~ /win[dows ]*9x/i)			{ $area_name = 'WinMe'; }
		elsif ($user_agent =~ /win[dows ]*98/i)			{ $area_name = 'Win98'; }
		elsif ($user_agent =~ /win[dows ]*XP/i)			{ $area_name = 'WinXP'; }
		elsif ($user_agent =~ /win[dows ]*NT ?6/i)		{ $area_name = 'Vista'; }
		elsif ($user_agent =~ /win[dows ]*NT ?5\.2/i)	{ $area_name = '2003'; }
		elsif ($user_agent =~ /win[dows ]*NT ?5\.1/i)	{ $area_name = 'XP'; }
		elsif ($user_agent =~ /Win[dows ]*NT ?5/i)		{ $area_name = '2000'; }
		elsif ($user_agent =~ /win[dows ]*2000/i)		{ $area_name = '2000'; }
		elsif ($user_agent =~ /Win[dows ]*NT/i)			{ $area_name = 'WinNT'; }
		elsif ($user_agent =~ /Win[dows ]*CE/i)			{ $area_name = 'WinCE'; }
		elsif (($user_agent =~ /sharp pda browser/i) && ($user_agent =~ /BrowserBoard/i))
				{ $area_name = 'BrowserBoard'; }
		elsif ($user_agent =~ /sharp pda browser/i)		{ $area_name = 'ZAURUS'; }
		elsif ($user_agent =~ /Mac/i)					{ $area_name = 'Mac'; }
		elsif ($user_agent =~ /L\-mode/i)				{ $area_name = 'NTT'; }
		elsif ($user_agent =~ /WWWC/i)					{ $area_name = 'Windows'; }
		elsif ($user_agent =~ /SH2101V/i)				{ $area_name = 'DoCoMo'; }
		elsif ($user_agent =~ /WebTV/i)					{ $area_name = ''; }
		elsif ($user_agent =~ /DreamPassport/i)			{ $area_name = 'SEGA'; }
		elsif ($user_agent =~ /X11|SunOS|Linux|HP\-UX|FreeBSD|NetBSD|OSF1|IRIX/i) 
		{ $area_name = 'UNIX'; }
		else { $area_name = ''; }
	}
	if ($area_name =~ /./) {$agent_name = "$agent_name\/$area_name";}
}

sub writeon {

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
	$in{'url'}	=~ s/&/&amp;/g;
	$in{'url'}  =~ s/</&lt;/g;
	$in{'url'}  =~ s/>/&gt;/g;
	$in{'mail'}	=~ s/&/&amp;/g;
	$in{'mail'}  =~ s/</&lt;/g;
	$in{'mail'}  =~ s/>/&gt;/g;
	$in{'dpas'}	=~ s/&/&amp;/g;
	$in{'dpas'}  =~ s/</&lt;/g;
	$in{'dpas'}  =~ s/>/&gt;/g;

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
		elsif ($column[16] == "1" && $in{'res'} eq $column[1]) { 
			&error (stop_er);
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
		
		# �X���b�g�X�g�b�v�i�Ƃ肠�������s�ł̓f�t�H�ŏ����j
		$s_stop = "0";

		# ���̓f�[�^�����ׂ�
		$column  = "";					#    ����������
		$column .= "$new<>";			# [0]�L���ԍ�
		$column .= "$res<>";			# [1]�e�L���ԍ�
		$column .= "$date<>";			# [2]���t
		$column .= "$time<>";			# [3]����
		$column .= "$name<>";			# [4]���O
		$column .= "$dai<>";			# [5]�薼
		$column .= "$msg<>";			# [6]�L��
		$column .= "$in{'mail'}<>";		# [7]���[��
		$column .= "$in{'url'}<>";		# [8]URL
		$column .= "$agent_name<>";		# [9]�[������
		$column .= "$host<>";			# [10]�z�X�g��
		$column .= "$addr<>";			# [11]IP�A�h���X
		$column .= "$dpas<>";			# [12]�p�X���[�h
		$column .= "$times<>";			# [13]���Ύ���
		$column .= "$ENV{'HTTP_USER_AGENT'}<>";	# [14]UA
		$column .= "$trip<>";			# [15]trip
		$column .= "$s_stop<>";			# [16]�X���b�g�X�g�b�v
		$column .= "0<>";				# [17]�\��
		$column .= "0<>";				# [18]�\��
		$column .= "\n";				# ���s�R�[�h

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
