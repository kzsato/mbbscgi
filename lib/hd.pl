#------------------------------------------------------------------------------
# ���e�t�H�[���iEZweb�j
#------------------------------------------------------------------------------
sub wap_form {
	# �w�b�_�[�o��
	$headtype = 1;
	&header;

	# �N�b�L�[�擾
	if ($use_cookie) { &get_cookie; }

	# URL�̃N�b�L�[����
	if ($url !~ /^http/) {
		$c_url = "http://" . $c_url;
	}

	# ���e�w��
	$dest = "$script?time=$times";	# URL+�_�~�[
	$data = "mode=write";			# ���[�h�w��
	$data .= "\&amp;name=\$name";		# ���O
	$data .= "\&amp;dai=\$dai";			# �薼
	$data .= "\&amp;msg=\$msg";			# �{��
	$data .= "\&amp;mail=\$mail";		# ���[���A�h���X
	$data .= "\&amp;url=\$wurl";		# �z�[���y�[�W
	$data .= "\&amp;dpas=\$dpas";		# �폜�p�X���[�h
	$data .= "\&amp;res=$in{'res'}";	# ���X�ԍ��̎w��

	$res_dai = "";
	if($in{'res'}){
		# ���X���̕��͂�\��
		open (IN,"$logfile") || &error (open_er);
		@line = <IN>;
		close(IN);

		# ���O�J�E���g�𕪗�
		$count   = shift(@line);

		# ���X�����ԍ��̋L����T��
		$num = 0;
		foreach $col (@line) {
			@column = split(/<>/,$col);
			if ($column[0] == $in{'res'}) {
				$res_dai = "RE\:$column[5]";	# �e�L���薼�o�^
				last;
			}
			$num++;
		}
	}

	if (($c_name) && ($c_ver == 1)) {
		$vars = "name=$c_name\&amp;dai=\&amp;msg=\&amp;mail=$c_mail\&amp;wurl=$c_url\&amp;dpas=$c_dpas";
	} else {
		$vars = "dai=\&amp;msg=";
	}

	# ���O����
	$content .= "<NODISPLAY>\n";
	$content .= "<ACTION type=\"accept\" task=\"go\" dest=\"#form\" vars=\"$vars\">\n";
	$content .= "</NODISPLAY>\n";

	# ���e�t�H�[���o��
	$content .= "<CHOICE name=\"form\" method=\"$list_method\" title=\"$wap_title\" bookmark=\"$fscript\">\n";
	$content .= "<ACTION type=\"soft1\" task=\"go\" dest=\"$script\" label=\"�߂�\">\n";
	$content .= "<CE task=\"go\" dest=\"#ename\" label=\"����\" receive=\"name\">���O:\$name\n";
	$content .= "<CE task=\"go\" dest=\"#edai\" label=\"����\" receive=\"dai\">�薼:\$dai\n";
	$content .= "<CE task=\"go\" dest=\"#emsg\" label=\"����\" receive=\"msg\">�{��:\$msg\n";
	$content .= "<CE task=\"go\" dest=\"#email\" label=\"����\" receive=\"mail\">mail:\$mail\n";
	$content .= "<CE task=\"go\" dest=\"#eurl\" label=\"����\" receive=\"wurl\">URL :\$wurl\n";
	$content .= "<CE task=\"go\" dest=\"#epas\" label=\"����\" receive=\"dpas\">�Í�:\$dpas\n";
	$content .= "<CE task=\"go\" dest=\"$dest\" method=\"$method\" postdata=\"$data\" label=\"���e\">���e����\n";
	$content .= "</CHOICE>\n";

	# ���O����
	$content .= "<ENTRY KEY=\"name\" name=\"ename\" title=\"$wap_title\" bookmark=\"$fscript\" DEFAULT=\"$c_name\">\n";
	$content .= "<ACTION type=\"accept\" task=\"go\" dest=\"#form\">\n";
	$content .= "�����O\n";
	$content .= "</ENTRY>\n";

	# �薼����
	$content .= "<ENTRY KEY=\"dai\" name=\"edai\" title=\"$wap_title\" bookmark=\"$fscript\" DEFAULT=\"$res_dai\">\n";
	$content .= "<ACTION type=\"accept\" task=\"go\" dest=\"#form\">\n";
	$content .= "�薼\n";
	$content .= "</ENTRY>\n";

	# �{������
	$content .= "<ENTRY KEY=\"msg\" name=\"emsg\" title=\"$wap_title\" bookmark=\"$fscript\">\n";
	$content .= "<ACTION type=\"accept\" task=\"go\" dest=\"#form\">\n";
	$content .= "�{��\n";
	$content .= "</ENTRY>\n";

	# ���[���A�h���X����
	$content .= "<ENTRY KEY=\"mail\" name=\"email\" title=\"$wap_title\" bookmark=\"$fscript\" format=\"*x\" DEFAULT=\"$c_mail\">\n";
	$content .= "<ACTION type=\"accept\" task=\"go\" dest=\"#form\">\n";
	$content .= "���[���A�h���X\n";
	$content .= "</ENTRY>\n";

	# �z�[���y�[�W�A�h���X����
	$content .= "<ENTRY KEY=\"wurl\" name=\"eurl\" title=\"$wap_title\" bookmark=\"$fscript\" format=\"*x\" DEFAULT=\"$c_url\">\n";
	$content .= "<ACTION type=\"accept\" task=\"go\" dest=\"#form\">\n";
	$content .= "�z�[���y�[�W\n";
	$content .= "</ENTRY>\n";

	# �폜�p�X���[�h����
	$content .= "<ENTRY KEY=\"dpas\" name=\"epas\" title=\"$wap_title\" bookmark=\"$fscript\" format=\"*x\" DEFAULT=\"$c_dpas\">\n";
	$content .= "<ACTION type=\"accept\" task=\"go\" dest=\"#form\">\n";
	$content .= "�폜�p�X���[�h\n";
	$content .= "</ENTRY>\n";

	# �t�b�^�[�o��
	&footer;
}

#------------------------------------------------------------------------------
# ���e�m�F�iEZweb�j
#------------------------------------------------------------------------------
sub wap_write {
	# �w�b�_�[�o��
	$headtype = 0;

	# �Ȃ񂾂�����񂪃G���[���邩����ʑ΍�i��
#	$agent = 1;
	&header;

	$content .= "<DISPLAY name=\"written\" title=\"$wap_title\" bookmark=\"$fscript\">\n";
	$content .= "<ACTION type=\"accept\" task=\"go\" dest=\"$script\" label=\"�m�F\">\n";
	# ���e�ԍ��\��
	$content .= "<CENTER>���e���� No.$new\n";

	# �薼/���e�҂̕\��
	# �S�p�V(���p14)�����ȉ��Ȃ璆�������A����ȊO�̓��C���ŕ\��
	$n_over = 0;
	$d_over = 0;
	if ($dai =~ /(..............)(.*)/) { $d_over = 1; }
	if ($name =~ /(..............)(.*)/) { $n_over = 1; }
	$dai =~ s/\$/\&\#36\;/g;
	$name =~ s/\$/\&\#36\;/g;

	# WARP��ALINE�ŉ��s���Ă��܂��׏ꍇ�������ĕ\��
	if (($d_over) && ($n_over)) {
		$content .= "<LINE>\n";
		$content .= "�$dai�<BR>\n";
		$content .= "$name\n<WRAP>\n";
	} elsif (($d_over) && (!$n_over)) {
		$content .= "<LINE>\n";
		$content .= "�$dai�\n<WRAP>\n";
		$content .= "<CENTER>$name<BR>\n";
	} elsif ((!$d_over) && ($n_over)) {
		$content .= "<BR>\n";
		$content .= "<CENTER>�$dai�\n<LINE>\n";
		$content .= "$name\n<WRAP>\n";
	} else {
		$content .= "<BR>\n";
		$content .= "<CENTER>�$dai�<BR>\n";
		$content .= "<CENTER>$name<BR>\n";
	}

	# �L���̕\��
	$content .= "<CENTER>----------------<BR>\n";
	if ($autolink) { &autolink( $msg ); }
	$msg =~ s/\$/\&\#36\;/g;
	$content .= "$msg<BR>\n";
	$content .= "<CENTER>----------------<BR>\n";

	# ���e�����̕\��
	$content .= "<CENTER>$date $time<BR>\n";

	# ���e�[���̕\��
	$content .= "<CENTER>�u$agent_name�v\n";

	# ���[���A�h���X�̕\��
	$content .= "<LINE>\n";
	if ($in{'mail'} ne "") {
		$content .= "<img icon=108>$in{'mail'}";
		$content .= "<BR>\n";
	}

	# �z�[���y�[�W�A�h���X�̕\��
	if (($in{'url'} ne "") && ($in{'url'} ne "http://")) {
		if ($in{'url'} =~ /hdml|HDML|wml|WML/) {
			if ($ENV{'HTTP_X_UP_DEVCAP_ISCOLOR'}) {
				$content .= "<img icon=155>";
			} else {
				$content .= "<img icon=161>";
			}
		} else {
			$content .= "<img icon=112>";
		}
		$content .= "$in{'url'}<BR>\n";
	}
	$content .= "</DISPLAY>\n";

	# �t�b�^�[�o��
	&footer;
}

#------------------------------------------------------------------------------
# �����t�H�[���iEZweb�j
#------------------------------------------------------------------------------
sub wap_sform {
	# �w�b�_�[�o��
	$headtype = 1;
	&header;

	# ���e�w��
	$dest = "$script?mode=seek";	# ���[�h�w��
	$dest .= "\&amp;cond=\$cond";		# ��������
	$dest .= "\&amp;string=\$string";	# ����������

	# ���O����
	$content .= "<NODISPLAY name=\"before\">\n";
	$content .= "<ACTION type=\"accept\" task=\"go\" dest=\"#seek_form\" vars=\"cond=and\&amp;string=\" REL=\"next\">\n";
	$content .= "</NODISPLAY>\n";

	# �����t�H�[���o��
	$content .= "<CHOICE name=\"seek_form\" method=\"$list_method\" title=\"$wap_title\" bookmark=\"$fscript\">\n";
	$content .= "<ACTION type=\"soft1\" task=\"go\" dest=\"$script\" label=\"�߂�\">\n";
	$content .= "�������������͂��A�������Ă�������\n";
	$content .= "<CE task=\"gosub\" dest=\"#econ\" label=\"����\" receive=\"cond\">����:\$cond\n";
	$content .= "<CE task=\"go\" dest=\"#estr\" label=\"����\" receive=\"string\">����:\$string\n";
	$content .= "<CE task=\"go\" dest=\"$dest\" label=\"����\">�����J�n\n";
	$content .= "</CHOICE>\n";

	# ������������
	$content .= "<CHOICE KEY=\"cond\" name=\"econ\" method=\"$list_method\" title=\"$wap_title\" bookmark=\"$fscript\">\n";
	$content .= "<CE task=\"RETURN\" label=\"�I��\" retvals=\"and\">AND����\n";
	$content .= "<CE task=\"RETURN\" label=\"�I��\" retvals=\"or\">OR����\n";
	$content .= "</CHOICE>\n";

	# �������������
	$content .= "<ENTRY KEY=\"string\" name=\"estr\" title=\"$wap_title\" bookmark=\"$fscript\">\n";
	$content .= "<ACTION type=\"accept\" task=\"go\" dest=\"#seek_form\">\n";
	$content .= "����������\n";
	$content .= "</ENTRY>\n";

	# �t�b�^�[�o��
	&footer;
}

#------------------------------------------------------------------------------
# �������ʕ\���iEZweb�j
#------------------------------------------------------------------------------
sub wap_sview {
	# �w�b�_�[�\��
	$headtype = 0;
	&header;

	# ���Ԃ̎擾
	&get_time;

	# �J�[�h�n��
	$content .= "<CHOICE name=\"tree\" method=\"$list_method\" title=\"$wap_title\" bookmark=\"$fscript\">\n";


	# �ϐ��̏����ݒ�
	$num     = 0;				# �L����
	$num_max = @new;			# ���[�L����
	$num_p   = 0;				# �y�[�W�J�E���g(�ʂ�)
	$num_peg = 1;				# �y�[�W�J�E���g
	$page    = $in{'page'};		# �y�[�W�w��

	# �y�[�W�̎w�肪�����ꍇ�́A�ŏ��̃y�[�W��\��
	if ($page eq "") { $page = 1; }

	# �������ʑ����\��
	$content .= "<CENTER>�������ʁF$num_max��\n";

	# �y�[�W�����v�Z
	$page_max = int($num_max / $max_line);
	if (($page_max * $max_line) < $num_max) { $page_max++; }

	# �y�[�W�\��
	if ($page_max > 1) { $content .= "<BR>\n<CENTER>$page�^$page_max��\n"; }

	while ($num < $num_max) {
		# �y�[�W�߂���
		if ($num_p == $max_line) {
			$num_p = 0;
			$num_peg++;
		}
		$num_p++;

		if ($num_peg == $page) {
			# �e�s�𕪊����A�z��Ɋi�[
			@column = split(/<>/,$new[$num]);

			# �ʕ\���ւ̃����N
			$dest = "$script?mode=view&amp;num=$column[0]";
			$content .= "<CE task=\"gosub\" dest=\"$dest\" label=\"�\\��\">";

			# �V���L���`�F�b�N
			if (($times - $column[13]) < $new_time * 3600) {
				$content .= "$new_mark ";
			} else {
				$content .= "$top_mark ";
			}

			# �L���\��
			$column[4] =~ s/\$/\&\#36\;/g;
			$column[5] =~ s/\$/\&\#36\;/g;

			# ���O�̕\��
			$content .= "No.column[0] $column[5]/$column[4]";
			
			if ($column[15] ne '') {
				$content .= " ��$column[15]-$column[2]\n";
			} else {
				$content .= "-$column[2]\n";
			}
		}
		$num++;
	}

	# �y�[�W�ړ�
	if ($num_peg != 1) {
		$dest = "$script?mode=seek";	# ���[�h�w��
		$dest .= "\&amp;cond=\$cond";		# ��������
		$dest .= "\&amp;string=\$string";	# ����������
		# ���y�[�W
		if ($page != $num_peg) {
			$next = $page + 1;
			$ndest = "$dest" . "\&amp;page=$next";	# �y�[�W�w��
			$content .= "<CE task=\"go\" dest=\"$ndest\" label=\"����\">���y�[�W\n";
		}
		# �O�y�[�W
		if ($page != 1) {
			$prev = $page - 1;
			$pdest = "$dest" . "\&amp;page=$prev";	# �y�[�W�w��
			$content .= "<CE task=\"go\" dest=\"$pdest\" label=\"�O��\">�O�y�[�W\n";
		}
	}

	# �L�����Ȃ��ꍇ�̏���
	if ($num == 0) { $content .= "���e�L���͗L��܂���<BR>\n"; }

	# �߂�
	$content .= "<CE task=\"go\" dest=\"$script\" label=\"�߂�\">Top�ɖ߂�\n";

	# �J�[�h�I���
	$content .= "</CHOICE>\n";

	# �t�b�^�[�\��
	&footer;
}

#------------------------------------------------------------------------------
# �e�L�����X�g�\���iEZweb�j
#------------------------------------------------------------------------------
sub wap_list {
	# �w�b�_�[�\��
	$headtype = 0;
	&header;

	# ���Ԃ̎擾
	&get_time;

	# �J�[�h�n��
	$content .= "<CHOICE name=\"list\" method=\"$list_method\" title=\"$wap_title\" bookmark=\"$fscript\">\n";

	# ���O�t�@�C�����I�[�v������
	open (IN,"$logfile") || &error (open_er);
	@line = <IN>;
	close(IN);
	
	# �ϐ��̏����ݒ�
	$count   = shift(@line);	# ���O�J�E���g�𕪗�
	$num     = 0;				# �L����
	$num_max = @line;			# ���[�L����
	$num_p   = 0;				# �y�[�W�̃J�E���g(�ʂ�)
	$num_pag = 1;				# �y�[�W�̃J�E���g
	$tpage   = $in{'tpage'};	# �e�L�����X�g�y�[�W�w��
	$num_c   = 0;				# �c���[�L�����J�E���g
	$new_chk = 0;				# �V���L���̃`�F�b�N

	# �y�[�W�w��̂Ȃ��ꍇ�͎n�߂̃y�[�W�ɂ���B
	if ($tpage eq "") { $tpage = 1; }

	# �\�t�g�L�[�̐ݒ�
	$content .= "<ACTION type=\"soft1\" task=\"prev\" dest=\"$script\" label=\"�߂�\">\n";

	$dest = "$script?mode=form";
	$content .= "<ACTION type=\"soft2\" task=\"go\" dest=\"$dest\" label=\"�V�K\">\n";

	# �^�C�g���\��
	$content .= "<CENTER>";
	if (($ENV{'HTTP_X_UP_DEVCAP_ISCOLOR'}) && ($wap_png)){
		$content .= "<img src=\"$wap_png\" alt=\"[$wap_title]\">\n";
	} elsif ($wap_bmp) {
		$content .= "<img src=\"$wap_bmp\" alt=\"[$wap_title]\">\n";
	} else {
		$content .= "�$wap_title�\n";
	}

	# �e�L���̕\�����[�v
	while ($num <= $num_max) {

		# �e�s�𕪊����A�z��Ɋi�[
		@column = split(/<>/,$line[$num]);

		# �e�L���`�F�b�N
		if ($column[0] == $column[1]) {
			# �y�[�W��v�`�F�b�N
			if (($num_pag == $tpage) && ($head ne "")) {
				if ($num_c == 1) {
					$dest = "$script?mode=view";	# ���[�h�w��
					$dest .= "\&amp;num=$head";			# �L���w��
					$dest .= "\&amp;only=yes";			# �ʋL���w��
				} else {
					$dest = "$script?mode=tree";	# ���[�h�w��
					$dest .= "\&amp;tree=$head";		# �c���[�w��
					$dest .= "\&amp;tpage=$tpage";		# �e�L�����X�g�y�[�W�ۑ�
				}
				$content .= "<CE task=\"go\" dest=\"$dest\" label=\"�\\��\" >";
				if ($new_chk) { $content .= "$new_mark"; }
				if (!$new_chk) { $content .= "$top_mark"; }
				$dai =~ s/\$/\&\#36\;/g;

				# �L���\��
				if (!$list_view_mode){
					if ($ez_by) { $content .= "$num_c�� $dai by $name\n"; }
					if (!$ez_by) { $content .= "$num_c�� $dai\n"; }
				}
				if ($list_view_mode){
					if ($ez_by) { $content .= "$dai($num_c) by $name $date$time\n"; }
					if (!$ez_by) { $content .= "$dai($num_c) $date$time\n"; }
				}

			}

			# �e�l�̏�����
			$new_chk = 0;	# �V���L���`�F�b�N�N���A
			$num_c = 0;		# �c���[�L�����J�E���g�N���A

			# �e�L���̕\�����ڂ�ۑ�
			$head = $column[0];	# �e�L���ԍ�
			$dai  = $column[5];	# �e�L���薼
			if ($ez_by) { $name  = "$column[4]"; }	# �e�L�����e�Җ�

			# �y�[�W�߂���
			if ($num_p == $max_line) {
				$num_p = 0;
				$num_pag++;
			}
			$num_p++;
		}

		# �V���L���`�F�b�N
		if (($times - $column[13]) < $new_time * 3600) {
			$new_chk = 1;
		}

		$num_c++;
		$num++;
	}

	# �y�[�W�\��
	if ($num_pag != 1) {
		$dest = "$script?mode=list";	# ���[�h�w��
		# ���y�[�W
		if ($num_pag != $tpage) {
			$next = $tpage + 1;
			$ndest = $dest ."\&amp;tpage=$next";
			$content .= "<CE task=\"go\" dest=\"$ndest\" label=\"����\">��($next)�y�[�W\n";
		}

		# �O�y�[�W
		if ($tpage != 1) {
			$prev = $tpage - 1;
			$pdest = $dest ."\&amp;tpage=$prev";
			$content .= "<CE task=\"go\" dest=\"$pdest\" label=\"�O��\">�O($prev)�y�[�W\n";
		}
	}
	

	# �L�����Ȃ��ꍇ�̏���
	if ($num == 0) { $content .= "���e�L���͗L��܂���<BR>\n"; }

	# �V�K�����ݍ���
	$content .= "<CE task=\"go\" dest=\"$script?mode=form\" label=\"����\">�V�K������\n";

	# �߂�
	$dest = "$script?mode=menu";
	$content .= "<CE task=\"go\" dest=\"$dest\" label=\"Menu\">Menu��\n";

	# �J�[�h�I���
	$content .= "</CHOICE>\n";

	# �t�b�^�[�\��
	&footer;
}

#------------------------------------------------------------------------------
# �ʃc���[�\���iEZweb�j
#------------------------------------------------------------------------------
sub wap_tree {
	# �w�b�_�[�\��
	$headtype = 0;
	&header;

	# ���Ԃ̎擾
	&get_time;

	# �J�[�h�n��
	$content .= "<CHOICE name=\"tree\" method=\"$list_method\" title=\"$wap_title\">\n";

	# ���O�t�@�C�����I�[�v������
	open (IN,"$logfile") || &error (open_er);
	@line = <IN>;
	close(IN);
	
	# �ϐ��̏����ݒ�
	$count   = shift(@line);	# ���O�J�E���g�𕪗�
	$num     = 0;				# �L����
	$num_max = @line;			# ���[�L����
	$num_p   = 0;				# �y�[�W�̃J�E���g(�ʂ�)
	$num_pag = 1;				# �y�[�W�̃J�E���g
	$tpage   = $in{'tpage'};	# �e�L�����X�g�y�[�W�ۑ�
	$page    = $in{'page'};		# �c���[�y�[�W�w��

	# �y�[�W�w��̂Ȃ��ꍇ�͎n�߂̃y�[�W�ɂ���B
	if ($page eq "") { $page = 1; }

	# �\���c���[�w��
	$tree = $in{'tree'};

	# �\�t�g�L�[�̐ݒ�
	$dest = "$script?mode=form\&amp;res=$tree";	# ���X�L���̎w��
	$content .= "<ACTION type=\"soft1\" task=\"go\" dest=\"$dest\" label=\"���X\">\n";

	while ($num < $num_max) {
		# �e�s�𕪊����A�z��Ɋi�[
		@column = split(/<>/,$line[$num]);
		if ($column[1] == $tree) {
			# �y�[�W�߂���
			if ($num_p == $max_line) {
				$num_p = 0;
				$num_pag++;
			}
			$num_p++;

			# �薼�⊮�@�\
			if ($column[0] == $column[1]) {
				$dai_tmp = "RE:$column[5]";
			}

			if ($num_pag == $page) {
				$dest = "$script?mode=view\&amp;num=$column[0]";	# �L���w��
				$content .= "<CE task=\"gosub\" dest=\"$dest\" label=\"�\\��\">";
				# �e�L���\��
				if ($column[0] == $column[1]) {
					if (($times - $column[13]) < $new_time * 3600) {
						$content .= "$new_mark";
					} else {
						$content .= "$top_mark";
					}
				# �q�L���\��
				} else {
					if (($times - $column[13]) < $new_time * 3600) {
						$content .= "$rnew_mark";
					} else {
						$content .= "$res_mark";
					}
				}
				# �薼�⊮�@�\
				if (($dai_aid) && ($column[5] eq $dai_tmp)) {
					$column[5] = $column[6];
					$column[5] =~ s/<BR>//g;
					$column[5] =~ s/(..........)(.*)/$1/;
				}
				$column[4] =~ s/\$/\&\#36\;/g;
				$column[5] =~ s/\$/\&\#36\;/g;
				$content .= "$column[5] $column[4]-$column[2]$column[3] No.$column[0]\n";
			}
		}
		$num++;
	}
	# �y�[�W�\��
	if ($num_pag != 1) {
		$dest = "$script?mode=tree";	# ���[�h�w��
		$dest .= "\&amp;tree=$tree";		# �c���[�w��
		$dest .= "\&amp;tpage=$tpage";		# �e�c���[�y�[�W�ۑ�
		# ���y�[�W
		if ($num_pag != $page) {
			$next = $page + 1;
			$ndest = $dest . "\&amp;page=$next";
			$content .= "<CE task=\"go\" dest=\"$ndest\" label=\"����\">��($next)�y�[�W\n";
		}
		# �O�y�[�W
		if ($page != 1) {
			$prev = $page - 1;
			$pdest = $dest . "\&amp;page=$prev";
			$content .= "<CE task=\"go\" dest=\"$pdest\" label=\"�O��\">�O($prev)�y�[�W\n";
		}
	}
	# �߂�
	$content .= "<CE task=\"go\" dest=\"$script\" label=\"�߂�\">�e�L���ꗗ�ɖ߂�\n";

	# �L�����Ȃ��ꍇ�̏���
	if ($num == 0) { $content .= "���e�L���͗L��܂���<BR>\n"; }

	# �߂�

	$dest = "$script?mode=menu";
	$content .= "<CE task=\"go\" dest=\"$dest\" label=\"�߂�\">�@�\\�ꗗ�ɖ߂�\n";

	# �J�[�h�I���
	$content .= "</CHOICE>\n";

	# �t�b�^�[�\��
	&footer;
}

#------------------------------------------------------------------------------
# �ʕ\���iEZweb�j
#------------------------------------------------------------------------------
sub wap_view {
	# �w�b�_�[�o��
	$headtype = 1;
	&header;

	# ���O�t�@�C�����I�[�v������
	open (IN,"$logfile") || &error (open_er);
	@line = <IN>;
	close(IN);
	
	$count = shift(@line);	# ���O�J�E���g�𕪗�

	# �L���ԍ��̋L����T��
	foreach $col (@line) {
		@column = split(/<>/,$col);	# �\���s�𕪉�
		if ($column[0] == $in{'num'}) {
			$msg_length = length($col);
			last;
		}
	}

	# �ő�p�P�b�g�̎擾
	$max_packet = $ENV{'HTTP_X_UP_DEVCAP_MAX_PDU'};
	if ($max_packet eq "") { $max_packet = 1500; }

	# �L�����\�����E�𒴂����番���\��
	if ($msg_length > $max_packet) {
		# �L���̕����T�C�Y�̌v�Z
		$num = $msg_length / $max_packet;
		$msg_max_packet = $max_packet / $num;

		# �p�P�b�g�T�C�Y��؂艺���Đ����ɂ���B
		$msg_max_packet =~ s/([0-9]*)\.([0-9]*)$/$1/;

		# �y�[�W�̎w��
		$s_page = $in{'s_page'};
		if ($s_page eq "") { $s_page = 1; }

		# �L���̕���
		@msgs = split(/<BR>/,$column[6]);

		# �����ݒ�
		@s_msg = ();
		$tmp_msg = "";

		# �L�����p�P�b�g�T�C�Y�ŘA��
		$num = 1;
		foreach $msg (@msgs){
			$tmp_msg .= "$msg<BR>";
			if (length($tmp_msg) >= $msg_max_packet) {
				$num++;
				$tmp_msg = "$msg<BR>";
			}
			$s_msg[$num] .= "$msg<BR>";
		}

		# �y�[�W�������̌���
		$splits = $num;

		# ���b�Z�[�W�̎w��
		$column[6] = $s_msg[$s_page];
	}

	# ���e�̕\��
	$content .= "<DISPLAY name=\"view\" title=\"$wap_title\" bookmark=\"$fscript\">\n";

	# ���X�{�^����\��
	if ($in{'only'}) {
		$dest = "$script?mode=form";	# ���[�h�̎w��
		$dest .= "\&amp;res=$in{'num'}";	# ���X�L���̎w��
		$content .= "<ACTION type=\"soft1\" task=\"go\" dest=\"$dest\" label=\"���X\">\n";

	}

	# �߂�{�^����\��
	$content .= "<ACTION type=\"accept\" task=\"prev\" label=\"�߂�\">\n";

	# �L���ԍ��̕\��
	$content .= "<CENTER>�L��No.$column[0]";

	# �薼/���e�҂̕\��
	# �S�p�V(���p14)�����ȉ��Ȃ璆�������A����ȊO�̓��C���ŕ\��
	$n_over = 0;
	$d_over = 0;
	if ($column[4] =~ /(..............)(.*)/) { $n_over = 1; }
	if ($column[5] =~ /(..............)(.*)/) { $d_over = 1; }
	$column[4] =~ s/\$/\&\#36\;/g;
	$column[5] =~ s/\$/\&\#36\;/g;

	# WARP��ALINE�ŉ��s���Ă��܂��׏ꍇ�������ĕ\��
	if (($n_over) && ($d_over)) {
		$content .= "<LINE>\n";
		$content .= "�$column[5]�\n";
		$content .= "<BR>\n";
		$content .= "$column[4]\n";
		$content .= "<WRAP>\n";
	} elsif ((!$n_over) && ($d_over)) {
		$content .= "<LINE>\n";
		$content .= "�$column[5]�\n";
		$content .= "<WRAP>\n";
		$content .= "<CENTER>$column[4]\n";
		$content .= "<BR>\n";
	} elsif (($n_over) && (!$d_over)) {
		$content .= "<BR>\n";
		$content .= "<CENTER>�$column[5]�\n";
		$content .= "<LINE>\n";
		$content .= "$column[4]\n";
		$content .= "<WRAP>\n";
	} else {
		$content .= "<BR>\n";
		$content .= "<CENTER>�$column[5]�\n";
		$content .= "<BR>\n";
		$content .= "<CENTER>$column[4]\n";
		$content .= "<BR>\n";
	}

	# �y�[�W�̕\��
 	if ($msg_length > $max_packet) {
		$content .= "<CENTER>($s_page�^$splits)<BR>\n";
	}

	# �L���̕\��
	$content .= "<CENTER>----------------<BR>\n";
	if ($autolink) { &autolink( $column[6] ); }
	$column[6] =~ s/\$/\&\#36\;/g;
	$content .= "$column[6]<BR>\n";
	$content .= "<CENTER>----------------<BR>\n";

	# ���e�����̕\��
	$content .= "<CENTER>$column[2] $column[3]<BR>\n";

	# �[���̕\��
	$content .= "<CENTER>�u$column[9]�v<BR>\n";

	# ���[���\��
	if ($column[7] ne "") {
		if ($atmail) {
			$content .= "<A task=\"go\" dest=\"mailto:$column[7]\" label=\"���[��\">";
		} else {
			$content .= "<A task=\"go\" dest=\"device:home/goto?svc=Email&amp;SUB=sendMsg\" vars=\"TO=$column[7]\" label=\"���[��\">";
		}
		$content .= "<img icon=\"108\"></A>���[��<BR>\n";
	}

	# �z�[���\��
	if ($column[8] ne "") {
		$content .= "<A task=\"go\" dest=\"$column[8]\" label=\"�z�[��\">";
		if ($column[8] =~ /hdml|HDML|wml|WML/) {
			if ($ENV{'HTTP_X_UP_DEVCAP_ISCOLOR'}) {
				$content .= "<img icon=\"155\">";
			} else {
				$content .= "<img icon=\"161\">";
			}
		} else {
			$content .= "<img icon=\"112\">";
		}
		$content .= "</A>�z�[��<BR>\n";
	}

	if ($msg_length > $max_packet) {
		$dest = "$script?mode=view";	# ���[�h�w��
		$dest .= "\&amp;num=$column[0]";	# �L���w��
		# ���y�[�W
		if ($s_page != $splits) {
			$next = $s_page + 1;
			$ndest = $dest . "\&amp;s_page=$next";
			$content .= "<A task=\"go\" dest=\"$ndest\" label=\"����\">��($next)�y�[�W</A><BR>\n";
		}
		# �O�y�[�W
		if ($s_page != 1) {
			$prev = $s_page - 1;
			$pdest = $dest . "\&amp;s_page=$prev";
			$content .= "<A task=\"go\" dest=\"$pdest\" label=\"�O��\">�O($prev)�y�[�W</A><BR>\n";
		}
		# �߂胊���N
		$content .= "<A task=\"return\" label=\"�߂�\">�I���c���[�֖߂�</A><BR>\n";
	}

	$content .= "</DISPLAY>\n";

	# �t�b�^�[�\��
	&footer;
}

#------------------------------------------------------------------------------
# �Ǘ��t�H�[���iEZweb�j
#------------------------------------------------------------------------------
sub wap_admin {
	# �w�b�_�[�\��
	$headtype = 1;
	&header;

	# �J�[�h�n��
	$content .= "<CHOICE title=\"$wap_title\" bookmark=\"$fscript\">\n";

	# �߂�{�^�����o��
	$content .= "<ACTION type=\"soft1\" task=\"go\" dest=\"$script\" label=\"�߂�\">\n";

	# �����\��
	$content .= "<CENTER>��Ǘ��ҋ@�\\�\n";

	# �L���폜
	$dest = "$script?mode=ad_dform&amp;psw=$in{'psw'}";
	$content .= "<CE task=\"go\" dest=\"$dest\" label=\"�폜\">[�L���폜����]\n";

	# �p�X���[�h�ύX
	$dest = "$script?mode=change&amp;psw=$in{'psw'}";
	$content .= "<CE task=\"go\" dest=\"$dest\" label=\"�ύX\">[�Í��ύX����]\n";

	# ��K�،�ǉ�
	$dest = "$script?mode=aform&amp;psw=$in{'psw'}";
	$content .= "<CE task=\"go\" dest=\"$dest\" label=\"�ǉ�\">[��K�،�ǉ�]\n";

	# ���O�t�@�C�����I�[�v������B
	open (IN,"$pswfile") || &error (open_er);
	@line = <IN>;
	close(IN);
	
	@column = split(/<>/,$line[1]);
	$num = $#column;

	# ��K�،�폜
	if ($num) {
		$loop = 0;
		while ($loop < $num) {
			# ��K�،ꍀ�ڂ̕\��
			$dest = "$script?mode=admin\&amp;func=del_word\&amp;loop=$loop&amp;psw=$in{'psw'}";
			$content .= "<CE task=\"go\" dest=\"$dest\" label=\"�폜\">�폜-$column[$loop]\n";
			$loop++;
		}
	}

	# �J�[�h�I���
	$content .= "</CHOICE>\n";

	# �t�b�^�[�\��
	&footer;
	exit;
}

#------------------------------------------------------------------------------
# ��K�،�ǉ��t�H�[���iEZweb�j
#------------------------------------------------------------------------------
sub wap_aform {
	# �w�b�_�[�\��
	$headtype = 1;
	&header;

	# ���O����
	$content .= "<NODISPLAY name=\"pre\">\n";
	$content .= "<ACTION type=\"accept\" task=\"go\" dest=\"#imput\" vars=\"word=\">\n";
	$content .= "</NODISPLAY>\n";

	# ���͏���
	$content .= "<ENTRY key=\"word\" name=\"imput\" title=\"$wap_title\" bookmark=\"$fscript\">\n";
	$content .= "<ACTION type=\"accept\" task=\"go\" dest=\"#post\" label=\"����\">\n";
	$content .= "��K�،�F\n";
	$content .= "</ENTRY>\n";

	# ���e����
	$dest = "$script?mode=admin\&amp;func=add_word\&amp;word=\$word";
	$content .= "<NODISPLAY name=\"post\">\n";
	$content .= "<ACTION type=\"accept\" task=\"go\" dest=\"$dest\">\n";
	$content .= "</NODISPLAY>\n";

	# �t�b�^�[�\��
	&footer;
	exit;
}

#------------------------------------------------------------------------------
# �p�X���[�h�ύX�t�H�[���iEZweb�j
#------------------------------------------------------------------------------
sub wap_pform {
	# �w�b�_�[�\��
	$headtype = 1;
	&header;

	# ���O����
	$content .= "<NODISPLAY name=\"pre\">\n";
	$content .= "<ACTION type=\"accept\" task=\"go\" dest=\"#imput\" vars=\"pswa=\&amp;pswb=\">\n";
	$content .= "</NODISPLAY>\n";

	# ���͏���
	$content .= "<ENTRY key=\"pswa\" name=\"imput\" title=\"$wap_title\" bookmark=\"$fscript\" format=\"*x\">\n";
	$content .= "<ACTION type=\"accept\" task=\"go\" dest=\"#check\" label=\"����\">\n";
	$content .= "�p�X���[�h(����)\n";
	$content .= "</ENTRY>\n";

	# �m�F���͏���
	$content .= "<ENTRY key=\"pswb\" name=\"check\" title=\"$wap_title\" bookmark=\"$fscript\" format=\"*x\">\n";
	$content .= "<ACTION type=\"accept\" task=\"go\" dest=\"#post\" label=\"�m�F\">\n";
	$content .= "�p�X���[�h(�m�F)\n";
	$content .= "</ENTRY>\n";

	# ���e����
	$dest = "$script?mode=admin\&amp;func=change\&amp;pswa=\$pswa\&amp;pswb=\$pswb";
	$content .= "<NODISPLAY name=\"post\">\n";
	$content .= "<ACTION type=\"accept\" task=\"go\" dest=\"$dest\">\n";
	$content .= "</NODISPLAY>\n";

	# �t�b�^�[�\��
	&footer;
	exit;
}

#------------------------------------------------------------------------------
# �p�X���[�h�m�F�t�H�[���iEZweb�j
#------------------------------------------------------------------------------
sub wap_pass {
	# �w�b�_�[�\��
	$headtype = 1;
	&header;

	# ���O����
	$content .= "<NODISPLAY name=\"pre\">\n";
	$content .= "<ACTION type=\"accept\" task=\"go\" dest=\"#imput\" vars=\"psw=\">\n";
	$content .= "</NODISPLAY>\n";

	# ���͏���
	$content .= "<ENTRY key=\"psw\" name=\"imput\" title=\"$wap_title\" bookmark=\"$fscript\" format=\"*x\">\n";
	$content .= "<ACTION type=\"accept\" task=\"go\" dest=\"#post\" label=\"�m�F\">\n";
	$content .= "�p�X���[�h�F\n";
	$content .= "</ENTRY>\n";

	# ���e����
	$dest = "$script?mode=admin\&amp;func=check\&amp;psw=\$psw";
	$content .= "<NODISPLAY name=\"post\">\n";
	$content .= "<ACTION type=\"accept\" task=\"go\" dest=\"$dest\">\n";
	$content .= "</NODISPLAY>\n";

	# �t�b�^�[�\��
	&footer;
	exit;
}

#------------------------------------------------------------------------------
# �Ǘ��ҍ폜�t�H�[���iEZweb�j
#------------------------------------------------------------------------------
sub wap_ad_dform {
	# �w�b�_�[�\��
	$headtype = 1;
	&header;

	# ���O����
	$content .= "<NODISPLAY name=\"pre\">\n";
	$content .= "<ACTION type=\"accept\" task=\"go\" dest=\"#imput\" vars=\"psw=\">\n";
	$content .= "</NODISPLAY>\n";

	# ���͏���
	$content .= "<ENTRY key=\"num\" name=\"imput\" title=\"$wap_title\" bookmark=\"$fscript\" format=\"*x\">\n";
	$content .= "<ACTION type=\"accept\" task=\"go\" dest=\"#post\" label=\"�m�F\">\n";
	$content .= "�폜�L���ԍ��F\n";
	$content .= "</ENTRY>\n";

	$dest = "$script?mode=admin\&amp;func=delete\&amp;num=\$num\&amp;admin=1";
	$content .= "<NODISPLAY name=\"post\">\n";
	$content .= "<ACTION type=\"accept\" task=\"go\" dest=\"$dest\">\n";
	$content .= "</NODISPLAY>\n";

	# �t�b�^�[�\��
	&footer;
	exit;
}

#------------------------------------------------------------------------------
# �폜�t�H�[���iEZweb�j
#------------------------------------------------------------------------------
sub wap_dform {
	# �w�b�_�[�o��
	$headtype = 1;
	&header;

	# ���e�w��
	$dest = "$script?func=delete";			# �@�\�w��
	$dest .= "\&amp;num=\$num";					# ���e�ԍ�
	$dest .= "\&amp;dpas=\$dpas";				# �폜�p�X���[�h
	if ($in{'admin'}) {
		$dest .= "\&amp;mode=admin\&amp;admin=1";	# ���[�h�w��
	}

	# �폜�t�H�[���o��
	$content .= "<CHOICE name=\"dform\" method=\"$list_method\" title=\"$wap_title\" bookmark=\"$fscript\">\n";
	$content .= "<ACTION type=\"soft1\" task=\"go\" dest=\"$script\" label=\"�߂�\">\n";
	$content .= "�L���ԍ��^�Í�����͂��폜���Ă�������\n";
	$content .= "<CE task=\"go\" dest=\"#enum\" label=\"����\" receive=\"num\">�ԍ�:\$num\n";
	$content .= "<CE task=\"go\" dest=\"#epas\" label=\"����\" receive=\"dpas\">�Í�:\$dpas\n";
	$content .= "<CE task=\"go\" dest=\"$dest\" label=\"�폜\">�L�����폜\n";

	$content .= "</CHOICE>\n";

	# �폜�L���̔ԍ�����
	$content .= "<ENTRY KEY=\"num\" name=\"enum\" title=\"$wap_title\" bookmark=\"$fscript\" format=\"*N\">\n";
	$content .= "<ACTION type=\"accept\" task=\"go\" dest=\"#dform\">\n";
	$content .= "�폜�L���̔ԍ�\n";
	$content .= "</ENTRY>\n";

	# �폜�p�X���[�h����
	$content .= "<ENTRY KEY=\"dpas\" name=\"epas\" title=\"$wap_title\" bookmark=\"$fscript\" format=\"*x\">\n";
	$content .= "<ACTION type=\"accept\" task=\"go\" dest=\"#dform\">\n";
	$content .= "�폜�p�X���[�h\n";
	$content .= "</ENTRY>\n";

	# �t�b�^�[�o��
	&footer;
}

#------------------------------------------------------------------------------
# �`����ʁiEZweb�j
#------------------------------------------------------------------------------
sub wap_title {
	# �w�b�_�[�o��
	$headtype = 1;
	&header;

	# �J�[�h�w�b�_�[�o��
	$content .= "<CHOICE name=\"top\" method=\"$list_method\" title=\"$wap_title\" bookmark=\"$fscript\">\n";

	# �z�[��������ꍇ�߂�{�^�����o��
	if ($wap_home) {
		$content .= "<ACTION type=\"soft1\" task=\"go\" dest=\"$wap_home\" label=\"HOME\" icon=\"112\">\n";
	}

	$content .= "<LINE>$wap_title\Menu�\\��\n";

	# �c���[�\������
	$content .= "<CE task=\"go\" dest=\"$script?mode=list\" label=\"�\\��\">";
	$content .= "[<img ICON=\"234\">�c���[�\\��]\n";

	# �V�K�����ݍ���
	$content .= "<CE task=\"go\" dest=\"$script?mode=form\" label=\"����\">";
	$content .= "[<img ICON=\"149\">�V�K������]\n";

	# �L���̌�������
	$content .= "<CE task=\"go\" dest=\"$script?mode=sform\" label=\"����\">";
	$content .= "[<img ICON=\"119\">�L���̌���]\n";

	# �g������������
	$content .= "<CE task=\"go\" dest=\"$wap_help\" label=\"����\">";
	$content .= "[<img ICON=\"270\">�g��������]\n";

	# ���쌠�\��
	$content .= "<CE task=\"go\" dest=\"$wap_own\" label=\"���\">";
	$content .= "[<img ICON=\"81\">���쌠�\\��]\n";

	# �L���̍폜����
	$content .= "<CE task=\"go\" dest=\"$script?mode=dform\" label=\"�폜\">";
	$content .= "[<img ICON=\"61\">�L���̍폜]\n";

	# �Ǘ��Ґ�p����
	$content .= "<CE task=\"go\" dest=\"$script?mode=check\" label=\"�Ǘ�\">";
	$content .= "[<img ICON=\"98\">�Ǘ��Ґ�p]\n";

	# �J�[�h�t�b�_�[�o��
	$content .= "</CHOICE>\n";

	# �t�b�^�[�o��
	&footer;
}

1;
