#------------------------------------------------------------------------------
# ���e�t�H�[���ii-mode�AJ-Sky�A�h�b�gi�j
#------------------------------------------------------------------------------
sub c_form {
	# �w�b�_�[�o��
	$headtype = 0;
	&header;

	# �N�b�L�[�擾
	if ($use_cookie) { &get_cookie; }
	$c_url = "http://" . $c_url;

	# J-Sky(�X�e�[�V������Ή��@)��GET�̂ݑΉ��Ȃ̂�METHOD��ύX
	if ($agent == 3) { $method = 'GET'; }

	# �t�H�[���^�O
	$content .= "<FORM action=\"$script\" method=\"$method\">\n";
	$content .= "<INPUT type=\"hidden\" name=\"mode\" value=\"write\">\n";

	# �\���̒�����
	$content .= "<CENTER>\n";

	$res_dai = "";
	if($in{'res'}){
		# ���X���̕��͂�����
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
		$content .= "<INPUT type=\"hidden\" name=\"res\" value=\"$in{'res'}\">\n";
		$content .= "����X�����ݣ<BR>\n";
	} else {
		$content .= "��V�K�����ݣ<BR>\n";
	}

	

	# �t�H�[�}�b�g�̎w��
	if ($agent == 2) {
		$kana = 'istyle="1"';
		$alpha = 'istyle="3"';
		$password = 'password';
		$sizea = 12;
		$sizeb = 14;
		$sizec = 16;
	}
	if ($agent == 3) {
		$kana = 'mode="hiragana"';
		$alpha = 'mode="alphabet"';
		$password = 'pw';
		$sizea = 10;
		$sizeb = 12;
		$sizec = 14;
	}
	if ($agent == 4) {
		$kana = 'astyle="1"';
		$alpha = 'astyle="3"';
		$password = 'password';
		$sizea = 12;
		$sizeb = 14;
		$sizec = 16;
	}

	# ���O����
	$content .= "���O";
	$content .= "<INPUT type=\"text\" name=\"name\" value=\"$c_name\" size=\"$sizea\" $kana>";
	$content .= "<BR>\n";

	# �薼����
	$content .= "�薼";
	$content .= "<INPUT type=\"text\" name=\"dai\" value=\"$res_dai\" size=\"$sizea\" $kana>";
	$content .= "<BR>\n";

	# �{������
	$content .= "�{���@�@�@�@�@�@\n";
	$content .= "<TEXTAREA name=\"msg\" cols=\"$sizec\" rows=\"2\" $kana>";
	$content .= "</TEXTAREA><BR>\n";

	# ���[���A�h���X����
	$content .= "$mail_mark";
	$content .= "<INPUT type=\"text\" name=\"mail\" value=\"$c_mail\" size=\"$sizeb\" maxlength=\"100\" $alpha>";
	$content .= "<BR>\n";

	# �z�[���y�[�W�A�h���X����
	$content .= "$home_mark";
	$content .= "<INPUT type=\"text\" name=\"url\" value=\"$c_url\" size=\"$sizeb\" maxlength=\"100\"  $alpha>";
	$content .= "<BR>\n";

	# �폜�p�X���[�h����
	$content .= "$key_mark";
	$content .= "<INPUT type=\"$password\" name=\"dpas\" size=\"$sizeb\" value=\"$c_dpas\">";
	$content .= "<BR>\n";

	# ���e�^����{�^��
	$content .= "<CENTER>\n";
	$content .= "<INPUT type=\"submit\" value=\"���e\">\n";
	$content .= "<INPUT type=\"reset\" value=\"���\">\n";
	$content .= "</CENTER>\n";

	# �t�H�[���^�O�I���
	$content .= "</FORM>\n";

	# �\���̒����񂹏I���
	$content .= "</CENTER>\n";

	# �t�b�^�[�o��
	&footer;

	# ��ʏo��
	&c_print;
}

#------------------------------------------------------------------------------
# �����݊m�F�ii-mode�AJ-Sky�A�h�b�gi�j
#------------------------------------------------------------------------------
sub c_write {
	# �w�b�_�[�o��
	$headtype = 0;
	&header;

	# ���e�̕\��
	$content .= "<CENTER>";
	$content .= "�m�F\n";
	$content .= "No$new";					# �L���ԍ�
	$content .= "</CENTER>\n";
	$content .= "�薼:$dai<BR>\n";			# �薼
	$content .= "���O:$name\n";				# ���O
	$content .= "<HR>\n";					# �d�؂��
	if ($autolink) { &autolink( $msg ); }	# ���������N�@�\
	$content .= "$msg\n";					# �L��
	$content .= "<HR>\n";					# �d�؂��

	$content .= "�u$agent_name�v\n";			# �[���\��

	# ���[���\��
	if ($in{'mail'} ne "") {
		$content .= "$mail_mark $in{'mail'}<BR>\n";
	}

	# �z�[���\��
	if ($in{'url'} ne "") {
		$content .= "$home_mark $in{'url'}<BR>\n";
	}

	# �߂�
	$content .= "<CENTER><A href=\"$script\">�m�F</A></CENTER>\n";

	# �t�b�^�[�o��
	&footer;

	# ��ʏo��
	&c_print;
}

#------------------------------------------------------------------------------
# �����t�H�[���ii-mode�AJ-Sky�A�h�b�gi�j
#------------------------------------------------------------------------------
sub c_sform {
	# �w�b�_�[�o��
	$headtype = 0;
	&header;

	# �t�H�[�}�b�g�̎w��
	if ($agent == 2) {
		$alpha = 'istyle="1"';
		$size = 16;
	}
	if ($agent == 3) {
		$alpha = 'mode="hiragana"';
		$size = 14;
	}
	if ($agent == 4) {
		$alpha = 'astyle="1"';
		$size = 16;
	}

	# �\���̒�����
	$content .= "<CENTER>\n";

	# �^�C�g��
	$content .= "��L���̌����<BR>\n";

	# ���ӏ���
	$content .= "�����������<BR>\n";
	$content .= "�X�y�[�X���<BR>\n";

	# J-Sky(�X�e�[�V������Ή��@)��GET�̂ݑΉ��Ȃ̂�METHOD��ύX
	if ($agent == 3) { $method = 'GET'; }

	# �t�H�[���̊J�n
	$content .= "<FORM action=\"$script\" method=\"$method\">\n";
	$content .= "<INPUT type=\"hidden\" name=\"mode\" value=\"seek\">\n";

	# ���������w��
	$content .= "<INPUT type=\"radio\" name=\"cond\" value=\"and\" CHECKED>";
	$content .= "and����<BR>\n";
	$content .= "<INPUT type=\"radio\" name=\"cond\" value=\"or\">";
	$content .= "or ����<BR>\n";

	# �������������
	$content .= "����������@�@";
	if ($agent != 3) { $content .= "�@"; }
	$content .= "<BR>\n";
	$content .= "<INPUT type=\"text\" name=\"string\" size=\"$size\" $alpha><BR>\n";

	# �����^����{�^��
	$content .= "<INPUT type=\"submit\" value=\"����\">\n";
	$content .= "<INPUT type=\"reset\" value=\"���\"><BR>\n";

	# �t�H�[���^�O�I���
	$content .= "</FORM>\n";

	# �\���̒����񂹏I���
	$content .= "</CENTER>\n";

	# �t�b�^�[�o��
	&footer;

	# ��ʏo��
	&c_print;
}

#------------------------------------------------------------------------------
# �������ʕ\���ii-mode�AJ-Sky�A�h�b�gi�j
#------------------------------------------------------------------------------
sub c_sview {
	# �w�b�_�[�\��
	$headtype = 0;
	&header;

	# ���Ԃ̎擾
	&get_time;

	# �ϐ��̏����ݒ�
	$num     = 0;				# �L����
	$num_max = @new;			# ���[�L����
	$num_p   = 0;				# �y�[�W�J�E���g(�ʂ�)
	$num_peg = 1;				# �y�[�W�J�E���g
	$page    = $in{'page'};		# �y�[�W�w��

	# �y�[�W�̎w�肪�����ꍇ�́A�ŏ��̃y�[�W��\��
	if ($page eq "") { $page = 1; }

	# �������ʑ����\��
	$content .= "<CENTER>";
	$content .= "��v�F$num_max��<BR>\n";

	# �y�[�W�����v�Z
	$page_max = int($num_max / $cmax_line);
	if (($page_max * $cmax_line) < $num_max) { $page_max++; }

	# �y�[�W�\��
	if ($page_max > 1) { $content .= "$page�^$page_max��<BR>\n"; }
	$content .= "</CENTER>";

	# ����������
	$content .= "<HR>\n";
	$content .= "$strings\n";
	$content .= "<HR>\n";

	while ($num < $num_max) {
		# �y�[�W�߂���
		if ($num_p == $cmax_line) {
			$num_p = 0;
			$num_peg++;
		}
		$num_p++;

		if ($num_peg == $page) {
			# �e�s�𕪊����A�z��Ɋi�[
			@column = split(/<>/,$new[$num]);

			# �ʕ\���ւ̃����N
			$dest = "$script?mode=view";	# ���[�h�w��
			$dest .= "\&amp;num=$column[0]";	# �L���w��
			$content .= "<A href=\"$dest\">";

			# �V���L���`�F�b�N
			if (($times - $column[13]) < $new_time * 3600) {
				$content .= "$new_mark";
			} else {
				$content .= "$top_mark";
			}

			# �����Z�k����
			$column[4] =~ s/(....)(.*)/$1 /;
			$column[5] =~ s/(........)(.*)/$1 /;

			# �L���\��
			$content .= "$column[5]$column[4]</A><BR>\n";
		}
		$num++;
	}

	# ��������
	$content .= "<CENTER>\n";

	# �L�����Ȃ��ꍇ�̏���
	if ($num == 0) { $content .= "��v�L������<BR>\n"; }

	# �y�[�W�ړ�
	if ($num_peg != 1) {
		$dest = "$script?mode=seek";	# ���[�h�w��
		$dest .= "\&amp;cond=$cond";		# ��������
		$dest .= "\&amp;string=$strings";	# ����������
		if ($page != 1) {
			$prev = $page - 1;
			$pdest = "$dest" . "\&amp;page=$prev";	# �y�[�W�w��
			$content .= "[<A href=\"$pdest\">�O</A>]";
		} else { $content .= "[�@]"; }
		if ($page != $num_peg) {
			$next = $page + 1;
			$ndest = "$dest" . "\&amp;page=$next";	# �y�[�W�w��
			$content .= "[<A href=\"$ndest\">��</A>]";
		} else { $content .= "[�@]"; }
	} else { $content .= "[�@][�@]"; }
	$content .= "[�@]";

	# �߂�
	$content .= "[<A href=\"$script\">��</A>]";

	# ��������
	$content .= "</CENTER>\n";

	# �t�b�^�[�\��
	&footer;

	# ��ʏo��
	&c_print;
}

#------------------------------------------------------------------------------
# �e�L�����X�g�\���ii-mode�AJ-Sky�A�h�b�gi�j
#------------------------------------------------------------------------------
sub c_list {
	# �w�b�_�[�\��
	$headtype = 0;
	&header;

	# ���Ԃ̎擾
	&get_time;

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
	$tpage   = $in{'tpage'};	# �y�[�W�w��
	$num_c   = 0;				# �c���[�L�����J�E���g
	$new_chk = 0;				# �V���L���̃`�F�b�N

	# �y�[�W�w��̂Ȃ��ꍇ�͎n�߂̃y�[�W�ɂ���B
	if ($tpage eq "") { $tpage = 1; }

	# �^�C�g���\��
	$content .= "<CENTER>��e�L�����X�g�</CENTER>";

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
				$content .= "<A href=\"$dest\">";
				if ($new_chk) { $content .= "$new_mark"; }
				if (!$new_chk) { $content .= "$top_mark"; }

				if (!$list_view_mode) {				
					if ($chtml_by) { $content .= " $num_c�� $dai by $name"; }
					if (!$chtml_by) { $content .= " $num_c�� $dai"; }
				}
				if ($list_view_mode) {
					if ($chtml_by) { $content .= " $dai($num_c) by $name $date$time"; }
					if (!$chtml_by) { $content .= " $dai($num_c) $date$time"; }
				}

				

				$content .= "</A><BR>\n";
			}

			# �e�L���̕\�����ڂ�ۑ�
			$head = $column[0];	# �e�L���ԍ�
			if ($agent == 3) {
				$column[5] =~ s/(......)(.*)/$1 /;
			} else {
				$column[5] =~ s/(........)(.*)/$1 /;
			}
			if ($agent == 3) {
				$column[4] =~ s/(......)(.*)/$1 /;
			} else {
				$column[4] =~ s/(........)(.*)/$1 /;
			}
			$dai  = $column[5];	# �e�L���薼
			$name  = $column[4];	# �e�L�����e�Җ�

			# �e�l�̏�����
			$new_chk = 0;	# �V���L���`�F�b�N�N���A
			$num_c = 0;		# �c���[�L�����J�E���g�N���A

			# �y�[�W�߂���
			if ($num_p == $cmax_line) {
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

	# �L�����Ȃ��ꍇ�̏���
	if ($num == 0) { $content .= "���e�L������<BR>\n"; }

	# ������
	$content .= "<CENTER>";

	# �y�[�W�\��
	if ($num_pag != 1) {
		$dest = "$script?mode=list";	# ���[�h�w��
		# �O�y�[�W
		if ($tpage != 1) {
			$prev = $tpage - 1;
			$pdest = "$dest"."\&amp;tpage=$prev";	# �y�[�W�w��
			$content .= "[<A HREF=\"$pdest\">�O</A>/";
		} else { $content .= "[�@/"; }
		# ���y�[�W
		if ($num_pag != $tpage) {
			$next = $tpage + 1;
			$ndest = "$dest"."\&amp;tpage=$next";	# �y�[�W�w��
			$content .= "<A HREF=\"$ndest\">��</A>/";
		} else { $content .= "�@/"; }
	} else { $content .= "[�@/�@/"; }
	$content .= "�@/";

	# �߂�
	$content .= "<A href=\"$script?mode=menu\">�ƭ�</A>/<A href=\"$script?mode=form\">�V�K</A>]";

	# �����񂹏I���
	$content .= "</CENTER>";

	# �t�b�^�[�\��
	&footer;
	&c_print;
}

#------------------------------------------------------------------------------
# �ʃc���[�\���ii-mode�AJ-Sky�A�h�b�gi�j
#------------------------------------------------------------------------------
sub c_tree {
	# �w�b�_�[�\��
	$headtype = 0;
	&header;

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

	# �^�C�g���\��
	$content .= "<CENTER>��ʃc���[�</CENTER>";

	# �\���c���[�w��
	$tree = $in{'tree'};
	foreach $lin (@line) {
		# �e�s�𕪊����A�z��Ɋi�[
		@column = split(/<>/,$lin);
		if ($column[1] == $tree) {
			if ($column[16] eq "1"){
			$stopchk = "1";
			}
			# �y�[�W�߂���
			if ($num_p == $cmax_line) {
				$num_p = 0;
				$num_pag++;
			}
			$num_p++;

			# �薼�⊮�@�\
			if ($column[0] == $column[1]) {
				$dai_tmp = "RE:column[5]";
			}

			# �y�[�W�`�F�b�N
			if ($num_pag == $page) {
				# �ʕ\���ւ̃����N
				$dest = "$script?mode=view";	# ���[�h�w��
				$dest .= "\&amp;num=$column[0]";	# �L���w��

				$content .= "<A HREF=\"$dest\">";
				if ($column[0] == $column[1]) {
					$content .= "$top_mark";
				} else {
					if ($flag != 1) { $flag = 1; }
					$content .= "$res_mark";
				}

				# �薼�⊮�@�\
				if (($dai_aid) && ($column[5] eq $dai_tmp)) {
					$column[5] = $column[6];
					$column[5] =~ s/<BR>//g;
				}

				$column[4] =~ s/(....)(.*)/$1 /;
				if ($agent == 3) {
					$column[5] =~ s/(......)(.*)/$1 /;
				} else {
					$column[5] =~ s/(........)(.*)/$1 /;
				}
	
				$content .= "$column[5]$column[4]</A><BR>\n";
			}
		}
	}
	if ($flag != 1) {
		$content .= "���X�L������<BR>";
	}

	# ������
	$content .= "<CENTER>";

	# �y�[�W�\��
	if ($num_pag != 1) {
		$dest = "$script?mode=tree";	# ���[�h�w��
		$dest .= "\&amp;tree=$tree";		# �e�L���w��
		$dest .= "\&amp;tpage=$tpage";		# �e�L�����X�g�y�[�W�ۑ�
		# �O�y�[�W
		if ($page != 1) {
			$prev = $page - 1;
			$pdest = "$dest"."\&amp;page=$prev";	# �y�[�W�w��
			$content .= "[<A HREF=\"$pdest\">�O</A>/";
		} else { $content .= "[�@/"; }
		# ���y�[�W
		if ($num_pag != $page) {
			$next = $page + 1;
			$ndest = "$dest"."\&amp;page=$next";	# �y�[�W�w��
			$content .= "<A HREF=\"$ndest\">��</A>/";
		} else { $content .= "�@/"; }
	} else { $content .= "[�@/�@/"; }
	# ���X
	if (!$stopchk){
		$dest = "$script?mode=form\&amp;res=$tree";	# ���X�L���̎w��
		$content .= "<A HREF=\"$dest\">��</A>/";
	}else{
		$content .= "�@/";
	}
	# �߂�
	$content .= "<A href=\"$script\">��</A>]";

	# �����񂹏I���
	$content .= "</CENTER>";

	# �t�b�^�[�\��
	&footer;
	&c_print;
}

#------------------------------------------------------------------------------
# �ʕ\���ii-mode�AJ-Sky�A�h�b�gi�j
#------------------------------------------------------------------------------
sub c_view {
	# �w�b�_�[�o��
	$headtype = 0;
	&header;

	# ���Ԃ̎擾
	&get_time;

	# ���O�t�@�C�����I�[�v������
	open (IN,"$logfile") || &error (open_er);
	@line = <IN>;
	close(IN);
	
	$count = shift(@line);	# ���O�J�E���g�𕪗�

	# �L���ԍ��̋L����T��
	foreach $col (@line) {
		@column = split(/<>/,$col);	# �\���s�𕪉�
		if ($column[0] == $in{'num'}) { last; }
	}

	# ���e�̕\��
	$content .= "<CENTER>\n";
	$content .= "�L�� No.$column[0]<BR>\n";		# �L���ԍ�
	$content .= "�$column[5]�<BR>\n";			# �薼
	$content .= "$column[4]\n";					# ���e��
	$content .= "</CENTER>\n";
	$content .= "<HR>\n";
	if ($autolink) { &autolink( $column[6] ); }	# ���������N�@�\
	$content .= "$column[6]\n";					# �L��

	# �d�ؐ�
	$content .= "<HR>\n";

	# ��������
	$content .= "<CENTER>\n";
	$content .= "$column[2] $column[3]<BR>\n";	# ���e����

	# �d�ؐ�
	$content .= "<HR>\n";

	# ��������
	$content .= "<CENTER>\n";
	$content .= "�u$column[9]�v<BR>\n";	# �[��

	# ���[���\��
	if ($column[7] ne "") {
		$content .= "[<A href=\"mailto:$column[7]\">$mail_mark</A>/";
	} else { $content .= "[�@/"; }

	# �z�[���\��
	if ($column[8] ne "") {
		&autolink( $column[8] );
		$content .= "$column[8]/";
	} else { $content .= "�@/"; }

	# �폜
	$dest = "$script?mode=dform";		# ���[�h�w��
	$dest .= "\&amp;num=$column[0]";		# �L���ԍ��w��
	$content .= "<A href=\"$dest\">��</A>/";

	if ($in{'only'} && $column[16] ne "1"){
		# ���X
		$dest = "$script?mode=form\&amp;res=$column[0]";	# ���X�L���̎w��
		$content .= "<A HREF=\"$dest\">��</A>]";
	} else {
		# �߂�
		$content .= "<A href=\"$script\">��</A>]";
	}

	# ���������I���
	$content .= "</CENTER>\n";

	# �t�b�^�[�\��
	&footer;
	&c_print;
}

#------------------------------------------------------------------------------
# �폜�t�H�[���ii-mode�AJ-Sky�A�h�b�gi�j
#------------------------------------------------------------------------------
sub c_dform {
	# �w�b�_�[�o��
	$headtype = 0;
	&header;

	# �N�b�L�[�擾
	if ($use_cookie) { &get_cookie; }

	# �t�H�[�}�b�g�̎w��
	if ($agent == 2) {
		$number = 'istyle="4"';
		$password = 'password';
		$sizea = 9;
		$sizeb = 14;
	}
	if ($agent == 3) {
		$number = 'MODE="numeric"';
		$password = 'pw';
		$sizea = 7;
		$sizeb = 12;
	}
	if ($agent == 4) {
		$number = 'astyle="4"';
		$password = 'password';
		$sizea = 9;
		$sizeb = 14;
	}

	# �^�C�g��
	$content .= "<CENTER>��L���̍폜�<BR>\n";

	# ����
	$content .= "�����ڂ���͌�<BR>\n";
	$content .= "�폜�{�^������<BR>\n";

	# J-Sky(�X�e�[�V������Ή��@)��GET�̂ݑΉ��Ȃ̂�METHOD��ύX
	if ($agent == 3) { $method = 'GET'; }

	# �t�H�[���̊J�n
	$content .= "<FORM action=\"$script\" method=\"$method\">\n";
	$content .= "<INPUT type=\"hidden\" name=\"func\" value=\"del\">\n";

	# �L���ԍ��w��
	$content .= "�L�� No";
	$content .= "<INPUT type=\"text\" name=\"num\" value=\"$in{'num'}\" size=\"$sizea\" $number><BR>\n";

	# �폜�p�X���[�h����
	$content .= "$key_mark";
	$content .= "<INPUT type=\"$password\" value=\"$c_dpas\" size=\"$sizeb\" name=\"dpas\">\n";

	# �폜�^����{�^��
	$content .= "<INPUT type=\"submit\" value=\"�폜\">\n";
	$content .= "<INPUT type=\"reset\" value=\"���\">\n";
	$content .= "</CENTER>\n";

	# �t�H�[���^�O�I���
	$content .= "</FORM>\n";

	# �t�b�^�[�o��
	&footer;

	# ��ʏo��
	&c_print;
}

#------------------------------------------------------------------------------
# �`����ʁii-mode�AJ-Sky�A�h�b�gi�j
#------------------------------------------------------------------------------
sub c_title {
	# �w�b�_�[�o��
	$headtype = 0;
	&header;

	# �^�C�g���\��
	if ($c_img) {
		$content .= "<CENTER><img SRC=\"$c_img\" ALT=\"[$c_title]\"><BR>\n";
	} else {
		$content .= "<CENTER>�$c_title�<BR>\n";
	}

	# �I�v�V�������w��
	if ($agent =~ /2|4/) {
		# ���ڕ\��
		$content .= "<A href=\"$script?mode=list\" accesskey=\"1\">";
		$content .= "$one_mark�c���[�\\��</A><BR>\n";
		$content .= "<A href=\"$script?mode=form\" accesskey=\"2\">";
		$content .= "$two_mark�V�K������</A><BR>\n";
		$content .= "<A href=\"$script?mode=sform\" accesskey=\"3\">";
		$content .= "$three_mark�L���̌���</A><BR>\n";
		$content .= "<A href=\"$script?mode=dform\" accesskey=\"4\">";
		$content .= "$four_mark�L���̍폜</A><BR>\n";

		# �w���v�t�@�C��������ꍇ�A�������ڂ�\��
		if ($c_help) {
			$content .= "<A href=\"$c_help\" accesskey=\"5\">";
			$content .= "$five_mark�g��������</A><BR>\n";
		}

		# ���쌠�\���t�@�C��������ꍇ�\��
		if ($c_own) {
			$content .= "<A href=\"$c_own\" accesskey=\"6\">";
			$content .= "$five_mark���쌠�\\��</A><BR>\n";
		}

		# �z�[��������ꍇ�A�߂荀�ڂ�\��
		if ($c_home) {
			$content .= "<A href=\"$c_home\" accesskey=\"0\">";
			$content .= "$zero_mark�g�o�֖߂�</A><BR>\n";
		}
	}
	if ($agent == 3) {
		# ���ڕ\��
		$content .= "<A href=\"$script?mode=list\" directkey=\"1\">";
		$content .= "�c���[�\\��</A><BR>\n";
		$content .= "<A href=\"$script?mode=form\" directkey=\"2\">";
		$content .= "�V�K������</A><BR>\n";
		$content .= "<A href=\"$script?mode=sform\" directkey=\"3\">";
		$content .= "�L���̌���</A><BR>\n";
		$content .= "<A href=\"$script?mode=dform\" directkey=\"4\">";
		$content .= "�L���̍폜</A><BR>\n";

		# �w���v�t�@�C��������ꍇ�A�������ڂ�\��
		if ($c_help) {
			$content .= "<A href=\"$c_help\" directkey=\"5\">";
			$content .= "�g��������</A><BR>\n";
		}

		# ���쌠�\���t�@�C��������ꍇ�\��
		if ($c_own) {
			$content .= "<A href=\"$c_own\" directkey=\"6\">";
			$content .= "���쌠�\\��</A><BR>\n";
		}

		# �z�[��������ꍇ�A�߂荀�ڂ�\��
		if ($c_home) {
			$content .= "<A href=\"$c_home\" directkey=\"0\">";
			$content .= "�g�o�֖߂�</A><BR>\n";
		}
	}

	# �t�b�^�[�o��
	&footer;
	&c_print;
}

#------------------------------------------------------------------------------
# i-mode�AJ-Sky�A�h�b�gi�p�o�̓T�u���[�`��
# (��)i-mode�ł́AContent-length��HTTP�w�b�_�ɖ����Ă͂Ȃ�Ȃ�
#------------------------------------------------------------------------------
sub c_print {
		$len = length($content);
		print "Content-type: text/html\n";
		print "Content-length: $len\n\n";
		print $content;
		exit;
}



1;
