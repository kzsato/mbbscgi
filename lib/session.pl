# =============================================================================
# File name: session.pl v1.00
# Copyright: horn@eztown.org
#            (URL: http://eztown.org/)
#
# ���̃t�@�C����mbbs.cgi(��)��session�Ǘ����W���[���t�@�C���ł��B
# =============================================================================

#------------------------------------------------------------------------------
# �Z�b�V�����`�F�b�N
# �Z�b�V�����������œn�������p�X���[�h���`�F�b�N�����Ƃ����݂̍��Ƃ̃��C��
#
#------------------------------------------------------------------------------
sub SessionChk{
	#	�T�[�o���t�@�C���̏���
	#	SessionID<>time<>reserved1<>reserved2<>
	#	���[�U���N�b�L�[�ɂ�sessionID�̂ݕۊ�
	my @MySessionFileData;
	my $MySessionID;
	my $MyD;
	my $MySessionLimit;

	# �p�X���[�h���n�����Ă����ꍇ�܂��`�F�b�N
	if(!&old_passchk){
		# �Z�b�V����ID�𐶐�
		$MySessionID = &generateID;
		# �N�b�L�[���Z�b�g
		&set_admin_cookie($MySessionID);
		# �T�[�o���ɂ��Z�b�V����ID���ۑ�
		&set_server_session($MySessionID);
		# �F�ؐ����I��
		return 0;
	}
	
	#	�N�b�L�[��ID���炤
	$MySessionID = &get_admin_cookie;
	#	NULL�������T���i��
	if(!$MySessionID){return 1;}

	#	�T�[�o���̃Z�b�V�����ꗗ�擾
	@MySessionFileData = &OpenSessionFile;
	#	NULL�������T���i��
	if(!$MySessionFileData[0]){return 1;}

	#	��������ID���܂܂��Ă��邩�`�F�b�N(���Ԃ��`�F�b�N)(�F��OK�Ȃ�return0)
	foreach (@MySessionFileData) {
		if ($_ !~ /$MySessionID/) { next; }
		($MyD, $MySessionLimit) = split(/<>/);
		last;
	}
	if($MySessionLimit > time){
		return 0;
	}
	return 1;
}

#------------------------------------------------------------------------------
# ���s�p�X���[�h�`�F�b�N���p
# �G���[�ɔ��΂��̂����߂āA���^�[���R�[�h�Ԃ������ł��B
#------------------------------------------------------------------------------
sub old_passchk {
	# �p�X���[�h�t�@�C�����J��
	open (IN,"$pswfile") || &error (open_er);
	@line = <IN>;
	close(IN);

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
		if ($pass ne $crypt3) { return 1; }
	} else {
		if ($in{'psw'}) { return 1; }
	}

	return 0;
}

#------------------------------------------------------------------------------
# �T�[�o�Z�b�V�����t�@�C���I�[�v������
# �Z�b�V�����t�@�C�����J���܂��B
#------------------------------------------------------------------------------
sub OpenSessionFile{
	my @MySessionFileData;
	
	# �ۑ��t�@�C�����J��
	open (IN,"$SessionFile") || &error (open_er);
		@MySessionFileData = <IN>;
	close(IN);
	
	return @MySessionFileData;
}

#------------------------------------------------------------------------------
# ID��������
# �K����ID�������܂��B�����ɂ��悤�Ǝv�������Ǎl�����̂߂��ǂ��̂ł�����
#------------------------------------------------------------------------------
sub generateID{
	srand(time);
	return crypt(time,rand(time));
}

#------------------------------------------------------------------------------
# �T�[�o�Z�b�V�����t�@�C���ۊǏ���
# �T�[�o�ɃZ�b�V����ID���ۊǂ��܂��B
#------------------------------------------------------------------------------
sub set_server_session($){
    my ($MySessionID) = @_;
	my @MyLine;
	my $MyTime;
	
	$MyTime = time + (60 * 10);
	
	
	# �t�@�C�������b�N�����B
	if ($file_lock) { flock("$SessionFile", 2); }

	# ���O�t�@�C�����I�[�v������
	open (IN,"$SessionFile") || &error (open_er);
	@MyLine = <IN>;
	close(IN);

	@MyLine = "";
	$MyLine[0] = "$MySessionID<>$MyTime<><><>\n";

	open (OUT,"> $SessionFile") || &error (open_er);
	print OUT @MyLine;
	close(OUT);
	

	# �t�@�C���̃��b�N�����������B
	if ($file_lock) { flock("$SessionFile", 8); }
	
}
#------------------------------------------------------------------------------
# �Ǘ��җp�N�b�L�[�̔��s
# 
# �������� SessionID
#------------------------------------------------------------------------------
sub set_admin_cookie($) {

    my ($MySessionID) = @_;
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

	($MyGSec,$MyGMin,$MyGHour,$MyGMday,$MyGMon,$MyGYear,$MyGWday)
					 = gmtime(time + 60*10);

	$MyGYear += 1900;
	if ($MyGSec  < 10) { $MyGSec  = "0$MyGSec";  }
	if ($MyGMin  < 10) { $MyGMin  = "0$MyGMin";  }
	if ($MyGHour < 10) { $MyGHour = "0$MyGHour"; }
	if ($MyGMday  < 10) { $MyGMday  = "0$MyGMday"; }

	$MyMonth = ('Jan','Feb','Mar','Apr','May',
			'Jun','Jul','Aug','Sep','Oct','Nov','Dec') [$MyGMon];
	$MyYoubi = ('Sun','Mon','Tue','Wed','Thu','Fri','Sat') [$MyGWday];

	$MyDateGMT = "$MyYoubi, $MyGMday\-$MyMonth\-$MyGYear $MyGHour:$MyGMin:$MyGSec GMT";

	$MyUrl = $ENV{'SCRIPT_NAME'};
	$MyUrl =~ s/$script//;

	print "Content-type: text/html\n";
	print "Set-Cookie: multi_bbs_admin=name:$cook_name,SessionID:$MySessionID;".
	" domain:$ENV{'SERVER_NAME'}; path:$MyUrl; expires=$MyDateGMT\n";
	
	return 0;

}

#------------------------------------------------------------------------------
# �Ǘ��җp�N�b�L�[�̎擾
# SessionID���Ԃ��炵��
#------------------------------------------------------------------------------
sub get_admin_cookie {
	@pairs = split(/\;/, $ENV{'HTTP_COOKIE'});
	foreach $pair (@pairs) {
		local($name, $value) = split(/\=/, $pair);
		$name =~ s/ //g;
		$DUMMY{$name} = $value;
	}

	@pairs = split(/\,/, $DUMMY{'multi_bbs_admin'});
	foreach $pair (@pairs) {
		local($name, $value) = split(/\:/, $pair);
		$COOKIE{$name} = $value;
	}
	
	return $COOKIE{'SessionID'};

}

1;
