# xh.lib v1.501 - 001 05.09.09
#------------------------------------------------------------------------------
# ���e�t�H�[���ixhtml�j
#------------------------------------------------------------------------------
sub x_form {
	# �w�b�_�[�o��
	$headtype = 1;
	&header;

	# �N�b�L�[�擾
	if ($use_cookie) { &get_user_data; }
	$c_url = "http://" . $c_url;

	# �t�H�[���^�O
	$content .= "<form action=\"$script\" method=\"$method\">\n";
	$content .= "<input type=\"hidden\" name=\"mode\" value=\"write\" />\n";

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
		$content .= "<input type=\"hidden\" name=\"res\" value=\"$in{'res'}\">\n";
		$content .= "�No.$in{'res'}�ւ̃��X�����ݣ<br />\n";
	} else {
		$content .= "��V�K�����ݣ<br />\n";
	}

	

	# �t�H�[�}�b�g�̎w��
	$kana = 'format="*M"';
	$alpha = 'format="*m"';
	$password = 'password';
	$passal = 'format="*x"';
	$sizea = 12;
	$sizeb = 14;
	$sizec = 16;


	# ���O����
	$content .= "���O\n";
	$content .= "<input type=\"text\" name=\"name\" value=\"$c_name\" size=\"$sizea\" $kana>";
	$content .= "<br />\n";

	# �薼����
	$content .= "�薼\n";
	$content .= "<input type=\"text\" name=\"dai\" value=\"$res_dai\" size=\"$sizea\" $kana>";
	$content .= "<br />\n";

	# �{������
	$content .= "�{��\n";
	$content .= "<textarea name=\"msg\" cols=\"$sizec\" rows=\"2\" $kana>";
	$content .= "</textarea><br />\n";

	# ���[���A�h���X����
	$content .= "$mail_mark";
	$content .= "<input type=\"text\" name=\"mail\" value=\"$c_mail\" size=\"$sizeb\" maxlength=\"100\" $alpha>";
	$content .= "<br />\n";

	# �z�[���y�[�W�A�h���X����
	$content .= "$home_mark";
	$content .= "<input type=\"text\" name=\"url\" value=\"$c_url\" size=\"$sizeb\" maxlength=\"100\"  $alpha>";
	$content .= "<br />\n";

	# �폜�p�X���[�h����
	$content .= "$key_mark";
	$content .= "<input type=\"$password\" name=\"dpas\" size=\"$sizeb\" value=\"$c_dpas\" $passal>";
	$content .= "<br />\n";

	# ���e�^����{�^��
	$content .= "<center>\n";
	$content .= "<input type=\"submit\" value=\"���e\">\n";
	$content .= "<input type=\"reset\" value=\"���\">\n";
	$content .= "</center>\n";

	# �t�H�[���^�O�I���
	$content .= "</form>\n";

	# �t�b�^�[�o��
	&footer;

	# ��ʏo��
	
}

#------------------------------------------------------------------------------
# �����݊m�F�ixhtml�j
#------------------------------------------------------------------------------
sub x_write {
	# �w�b�_�[�o��
	$headtype = 0;
	&header;

	# ���ʃ��j���[
	$content .= "<wml:do type=\"ACCEPT\" label=\"�m�F\">\n";
	$content .= "<go href=\"$script\" />\n";
	$content .= "</wml:do>\n";

	# ���e�̕\��
	$content .= "<center>";
	$content .= "�m�F\n";
	$content .= "No$new";					# �L���ԍ�
	# ���[���\��
	if ($in{'res'} ne "") {
		$content .= "No.$in{'res'}�ւ̃��X\n";
	}
	$content .= "</center>\n";
	$content .= "�薼:$dai<br />\n";			# �薼
	$content .= "���O:$name\n";				# ���O
	$content .= "<hr />\n";					# �d�؂��
	if ($autolink) { &autolink( $msg ); }	# ���������N�@�\
	$content .= "$msg\n";					# �L��
	$content .= "<hr />\n";					# �d�؂��

	$content .= "�u$agent_name�v\n";			# �[���\��

	# ���[���\��
	if ($in{'mail'} ne "") {
		$content .= "$mail_mark<br />$in{'mail'}<br />\n";
	}

	# �z�[���\��
	if ($in{'url'} ne "") {
		$content .= "$home_mark<br />$in{'url'}<br />\n";
	}

	# �߂�
	$content .= "<center><a href=\"$script\" title=\"�m�F\">�m�F</a></center>\n";

	# �t�b�^�[�o��
	&footer;

	# ��ʏo��
	
}

#------------------------------------------------------------------------------
# �����t�H�[���ixhtml�j
#------------------------------------------------------------------------------
sub x_sform {
	# �w�b�_�[�o��
	$headtype = 1;
	&header;

	# �t�H�[�}�b�g�̎w��
	$alpha = 'format="*M"';
	$size = 16;

	# �^�C�g��
	$content .= "��L���̌����<br />\n";

	# ���ӏ���
	$content .= "����������̓X�y�[�X���<br />\n";

	# �t�H�[���̊J�n
	$content .= "<form action=\"$script\" method=\"$method\">\n";
	$content .= "<input type=\"hidden\" name=\"mode\" value=\"seek\">\n";

	# ���������w��
	$content .= "<input type=\"radio\" name=\"cond\" value=\"and\" CHECKED>";
	$content .= "and����<br />\n";
	$content .= "<input type=\"radio\" name=\"cond\" value=\"or\">";
	$content .= "or ����<br />\n";

	# �������������
	$content .= "����������@�@";
	$content .= "�@";
	$content .= "<br />\n";
	$content .= "<input type=\"text\" name=\"string\" size=\"$size\" $alpha><br />\n";

	# �����^����{�^��
	$content .= "<input type=\"submit\" value=\"����\">\n";
	$content .= "<input type=\"reset\" value=\"���\"><br />\n";

	# �t�H�[���^�O�I���
	$content .= "</form>\n";

	# �t�b�^�[�o��
	&footer;

	# ��ʏo��
	
}

#------------------------------------------------------------------------------
# �������ʕ\���ixhtml�j
#------------------------------------------------------------------------------
sub x_sview {
	# �w�b�_�[�\��
	$headtype = 1;
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
	$content .= "<center>";
	$content .= "��v�F$num_max��<br />\n";

	# ����������
	if ($cmax_line < ($text_y - 6)){ $cmax_line = ($text_y - 6 ) ;}

	# �y�[�W�����v�Z
	$page_max = int($num_max / $cmax_line);
	if (($page_max * $cmax_line) < $num_max) { $page_max++; }

	# �y�[�W�\��
	if ($page_max > 1) { $content .= "$page�^$page_max��<br />\n"; }
	$content .= "</center>";

	# ����������
	$content .= "<hr />\n";
	$content .= "$strings\n";
	$content .= "<hr />\n";

	$listcount = "1";

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
			$content .= "<p mode=\"nowrap\"><a href=\"$dest\" accesskey=\"$listcount\" title=\"�ǂ�\">";

			# �V���L���`�F�b�N
			if (($times - $column[13]) < $new_time * 3600) {
				$content .= "$new_mark";
			} else {
				$content .= "$top_mark";
			}

			# �����Z�k����
			$column[4] =~ s/(.{$text_x})(.*)/$1 /;
			$column[5] =~ s/(.{$text_x})(.*)/$1 /;

			# �L���\��
			$content .= "$column[5] by $column[4]</a></p>\n";

			$listcount = $listcount + 1;

		}
		$num++;
	}

	# �L�����Ȃ��ꍇ�̏���
	if ($num == 0) { $content .= "��v�L������<br />\n"; }


	$content .= "<hr /><br />\n";

	# �y�[�W�ړ�
	if ($num_peg != 1) {
		$dest = "$script?mode=seek";	# ���[�h�w��
		$dest .= "\&cond=$cond";		# ��������
		$dest .= "\&string=$strings";	# ����������
		if ($page != 1) {
			$prev = $page - 1;
			$pdest = "$dest" . "\&page=$prev";	# �y�[�W�w��

		# ���ʃ��j���[
		$content .= "<wml:do type=\"SOFT3\" label=\"�O��\">\n";
		$content .= "<go href=\"$pdest\" />\n";
		$content .= "</wml:do>\n";
		}

		if ($page != $num_peg) {
			$next = $page + 1;
			$ndest = "$dest" . "\&page=$next";	# �y�[�W�w��

		# ���ʃ��j���[
		$content .= "<wml:do type=\"SOFT4\" label=\"����\">\n";
		$content .= "<go href=\"$ndest\" />\n";
		$content .= "</wml:do>\n";

		}
	}

	# ���ʃ��j���[
	$content .= "<wml:do type=\"SOFT5\" label=\"�߂�\">\n";
	$content .= "<go href=\"$script\" />\n";
	$content .= "</wml:do>\n";

	# ���ʃ��j���[
	$content .= "<wml:do type=\"ACCEPT\" label=\"�߂�\">\n";
	$content .= "<go href=\"$script\" />\n";
	$content .= "</wml:do>\n";

	# �t�b�^�[�\��
	&footer;

	# ��ʏo��
	
}

#------------------------------------------------------------------------------
# �e�L�����X�g�\���ixhtml�j
#------------------------------------------------------------------------------
sub x_list {
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

	# ����������
	if ($cmax_line < ($text_y - 2)){ $cmax_line = ($text_y - 2 ) ;}

	# �^�C�g���\��
	$content .= "<center>��e�L�����X�g�</center>\n";

	$listcount = "1";
	$list_ico = "180";
	
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

				if ($listcount == 10){$listcount = "0";}
				if ($list_ico == 189){$list_ico = "325";}

				$content .= "<p mode=\"nowrap\"><a href=\"$dest\" accesskey=\"$listcount\" title=\"�ǂ�\"><img localsrc=\"$list_ico\"> ";
				if ($new_chk) { $content .= "$new_mark"; }
				if (!$new_chk) { $content .= "$top_mark"; }

				if (!$list_view_mode) {				
					if ($xhtml_by) { $content .= " $num_c�� $dai by $name"; }
					if (!$xhtml_by) { $content .= " $num_c�� $dai"; }
				}
				if ($list_view_mode) {
					if ($xhtml_by) { $content .= " $dai($num_c) by $name $date$time"; }
					if (!$xhtml_by) { $content .= " $dai($num_c) $date$time"; }
				}

				$content .= "</a></p>\n";
				$listcount = $listcount + 1;
				$list_ico = $list_ico + 1;
			}

			# �e�L���̕\�����ڂ�ۑ�
			$head = $column[0];	# �e�L���ԍ�
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
	if ($num == 0) { $content .= "���e�L������<br />\n"; }

	# �y�[�W�\��
	if ($num_pag != 1) {
		$dest = "$script?mode=list";	# ���[�h�w��
		# ���y�[�W
		if ($num_pag != $tpage) {
			$next = $tpage + 1;
			$ndest = "$dest"."\&amp;tpage=$next";	# �y�[�W�w��
			# ���ʃ��j���[
			$content .= "<wml:do type=\"SOFT3\" label=\"����\">\n";
			$content .= "<go href=\"$ndest\" />\n";
			$content .= "</wml:do>\n";
		}

		# �O�y�[�W
		if ($tpage != 1) {
			$prev = $tpage - 1;
			$pdest = "$dest"."\&amp;tpage=$prev";	# �y�[�W�w��
			# ���ʃ��j���[
			$content .= "<wml:do type=\"SOFT4\" label=\"�O��\">\n";
			$content .= "<go href=\"$pdest\" />\n";
			$content .= "</wml:do>\n";
		}
	}

	# ���ʃ��j���[
	$content .= "<wml:do type=\"SOFT5\" label=\"�����[�h\">\n";
	$content .= "<go href=\"$script\" />\n";
	$content .= "</wml:do>\n";

	# ���ʃ��j���[
	$content .= "<wml:do type=\"SOFT6\" label=\"HP�ɖ߂�\">\n";
	$content .= "<go href=\"$x_home\" />\n";
	$content .= "</wml:do>\n";

	# ���ʃ��j���[
	$content .= "<wml:do type=\"ACCEPT\" label=\"�۰��\">\n";
	$content .= "<go href=\"$script\" />\n";
	$content .= "</wml:do>\n";

	# �t�b�^�[�\��
	&footer;
	
}

#------------------------------------------------------------------------------
# �ʃc���[�\���ixhtml�j
#------------------------------------------------------------------------------
sub x_tree {
	&get_time;
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

	# ����������
	if ($cmax_line < ($text_y - 2)){ $cmax_line = ($text_y - 2 ) ;}

	# �^�C�g���\��
	$content .= "<center>��ʃc���[�</center>\n";

	$listcount = "1";
	$list_ico = "180";

	# �\���c���[�w��
	$tree = $in{'tree'};
	foreach $lin (@line) {
		# �e�s�𕪊����A�z��Ɋi�[
		@column = split(/<>/,$lin);
		if ($column[1] == $tree) {
			# �y�[�W�߂���
			if ($num_p == $cmax_line) {
				$num_p = 0;
				$num_pag++;
			}
			$num_p++;

			# �薼�⊮�@�\
			if ($column[0] == $column[1]) {
				$dai_tmp = "RE:$column[5]";
			}

			# �y�[�W�`�F�b�N
			if ($num_pag == $page) {
				# �ʕ\���ւ̃����N
				$dest = "$script?mode=view";	# ���[�h�w��
				$dest .= "\&amp;num=$column[0]";	# �L���w��

				if ($listcount == 10){$listcount = "0";}
				if ($list_ico == 189){$list_ico = "325";}
				
				$content .= "<p mode=\"nowrap\"><a href=\"$dest\" accesskey=\"$listcount\" title=\"�ǂ�\"><img localsrc=\"$list_ico\"> ";

				# �e�L���\��
				if ($column[0] == $column[1]) {
					if (($times - $column[13]) < $new_time * 3600) {
						$content .= "$new_mark";
					} else {
						$content .= "$top_mark";
					}
				# �q�L���\��
				} else {
					$flag = 1;
					if (($times - $column[13]) < $new_time * 3600) {
						$content .= "$rnew_mark";
					} else {
						$content .= "$res_mark";
					}
				}

				# �薼�⊮�@�\
				if (($dai_aid) && ($column[5] == $dai_tmp)) {
					$column[5] = $column[6];
					$column[5] =~ s/<BR//g;
					$column[5] =~ s/<//g;
					$column[5] =~ s/>//g;
					$column[5] =~ s/(.{$text_x})(.*)/$1/;
				}
	
				$content .= "$column[5] by $column[4]</a></p>\n";

				$listcount = $listcount + 1;
				$list_ico = $list_ico + 1;
			}
		}
	}
	if ($flag != 1) {
		$content .= "���X�L������<br />";
	}


	# �y�[�W�\��
	if ($num_pag != 1) {
		$dest = "$script?mode=tree";	# ���[�h�w��
		$dest .= "\&amp;tree=$tree";		# �e�L���w��
		$dest .= "\&amp;tpage=$tpage";		# �e�L�����X�g�y�[�W�ۑ�
		# ���y�[�W
		if ($num_pag != $page) {
			$next = $page + 1;
			$ndest = "$dest"."\&amp;page=$next";	# �y�[�W�w��

			# ���ʃ��j���[
			$content .= "<wml:do type=\"SOFT3\" label=\"����\">\n";
			$content .= "<go href=\"$ndest\" />\n";
			$content .= "</wml:do>\n";
		}
		# �O�y�[�W
		if ($page != 1) {
			$prev = $page - 1;
			$pdest = "$dest"."\&amp;page=$prev";	# �y�[�W�w��

			# ���ʃ��j���[
			$content .= "<wml:do type=\"SOFT4\" label=\"�O��\">\n";
			$content .= "<go href=\"$pdest\" />\n";
			$content .= "</wml:do>\n";
		}
	}

	# ���X
	$dest = "$script?mode=form\&amp;res=$tree";	# ���X�L���̎w��
	$content .= "<wml:do type=\"SOFT5\" label=\"���X\">\n";
	$content .= "<go href=\"$dest\" />\n";
	$content .= "</wml:do>\n";

	# ���ʃ��j���[
	$content .= "<wml:do type=\"SOFT6\" label=\"�߂�\">\n";
	$content .= "<go href=\"$script\" />\n";
	$content .= "</wml:do>\n";

	# ���ʃ��j���[
	$content .= "<wml:do type=\"ACCEPT\" label=\"�߂�\">\n";
	$content .= "<go href=\"$script\" />\n";
	$content .= "</wml:do>\n";

	# �t�b�^�[�\��
	&footer;
	
}

#------------------------------------------------------------------------------
# �ʕ\���ixhtml�j
#------------------------------------------------------------------------------
sub x_view {
	# �w�b�_�[�o��
	$headtype = 1;
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

	# �{����<BR>��ϊ�
	$column[5] =~ s/<BR//g;
	$column[5] =~ s/<//g;
	$column[5] =~ s/>//g;
	$column[6] =~ s/<BR>/<br \/>/g;

	# ���e�̕\��
	$content .= "<center>\n";
	$content .= "�L�� No.$column[0]<br />\n";		# �L���ԍ�
	$content .= "�$column[5]�<br />\n";			# �薼
	$content .= "$column[4]\n";					# ���e��
	$content .= "</center>\n";
	$content .= "<hr />\n";
	if ($autolink) { &autolink( $column[6] ); }	# ���������N�@�\
	$content .= "$column[6]\n";					# �L��

	# �d�ؐ�
	$content .= "<hr />\n";

	# ��������
	$content .= "<center>\n";

	$content .= "$column[2] $column[3]<br />\n";	# ���e����

	# �d�ؐ�
	$content .= "<hr />\n";

	# ��������
	$content .= "<center>\n";

	$content .= "�u$column[9]�v<br />\n";	# �[��

	# ���[���\��
	if ($column[7] ne "") {
		$content .= "[<a href=\"mailto:$column[7]\" title=\"mail\">$mail_mark</a>/";
	} else { $content .= "[�@/"; }

	# �z�[���\��
	if ($column[8] ne "") {
		&autolink( $column[8] );
		$content .= "$column[8]/";
	} else { $content .= "�@/"; }

	# �폜
	$dest = "$script?mode=dform";		# ���[�h�w��
	$dest .= "\&num=$column[0]";		# �L���ԍ��w��
	$content .= "<a href=\"$dest\" title=\"�폜\">��</a>/";

	# ���X
	$dest = "$script?mode=form\&res=$column[1]";	# ���X�L���̎w��
	$content .= "<a href=\"$dest\" title=\"�ԐM\">��</a>/";

	# �߂�
	$content .= "<a href=\"$script\" title=\"�߂�\">��</a>]";

	# ���������I���
	$content .= "</center>\n";

	# �t�b�^�[�\��
	&footer;
	
}

#------------------------------------------------------------------------------
# �폜�t�H�[���ixhtml�j
#------------------------------------------------------------------------------
sub x_dform {
	# �w�b�_�[�o��
	$headtype = 1;
	&header;

	# �N�b�L�[�擾
	if ($use_cookie) { &get_cookie; }

	$number = 'format="*N"';
	$password = 'password';
	$passal = 'format="*x"';
	$sizea = 9;
	$sizeb = 14;

	# �^�C�g��
	$content .= "<center>��L���̍폜�<br />\n";

	# ����
	$content .= "�����ڂ���͌�<br />\n";
	$content .= "�폜�{�^������<br />\n";

	# �t�H�[���̊J�n
	$content .= "<form action=\"$script\" method=\"$method\">\n";
	$content .= "<input type=\"hidden\" name=\"func\" value=\"delete\">\n";

	# �L���ԍ��w��
	$content .= "�L�� No";
	$content .= "<input type=\"text\" name=\"num\" value=\"$in{'num'}\" size=\"$sizea\" $number><br />\n";

	# �폜�p�X���[�h����
	$content .= "$key_mark";
	$content .= "<input type=\"$password\" value=\"$c_dpas\" size=\"$sizeb\" name=\"dpas\" $passal>\n";

	# �폜�^����{�^��
	$content .= "<input type=\"submit\" value=\"�폜\">\n";
	$content .= "<input type=\"reset\" value=\"���\">\n";
	$content .= "</center>\n";

	# �t�H�[���^�O�I���
	$content .= "</form>\n";

	# �t�b�^�[�o��
	&footer;

	# ��ʏo��
	
}

#------------------------------------------------------------------------------
# �`����ʁixhtml�j
#------------------------------------------------------------------------------
sub x_title {
	# �w�b�_�[�o��
	$headtype = 1;
	&header;

	# �^�C�g���\��
	if ($x_img) {
		$content .= "<img src=\"$x_img\" alt=\"[$x_title]\"><br />\n";
	} else {
		$content .= "�$x_title�<br />\n";
	}

	# �I�v�V�������w��
	# ���ڕ\��
	$content .= "$one_mark<a href=\"$script?mode=list\" accesskey=\"1\" title=\"tree\">�c���[�\\��</a><br />\n";
	$content .= "$two_mark<a href=\"$script?mode=form\" accesskey=\"2\" title=\"�V�K\">�V�K������</a><br />\n";
	$content .= "$three_mark<a href=\"$script?mode=sform\" accesskey=\"3\" title=\"����\">�L���̌���</a><br />\n";
	$content .= "$four_mark<a href=\"$script?mode=dform\" accesskey=\"4\" title=\"�폜\">�L���̍폜</a><br />\n";

	# �w���v�t�@�C��������ꍇ�A�������ڂ�\��
	if ($x_help) {
		$content .= "$five_mark<a href=\"$x_help\" accesskey=\"7\" title=\"help\">�g��������</a><br />\n";
	}

	# ���쌠�\���t�@�C��������ꍇ�\��
	if ($x_own) {
		$content .= "$eight_mark<a href=\"$x_own\" accesskey=\"8\" title=\"(C)\">���쌠�\\��</a><br />\n";
	}

	# �Ǘ��Ґ�p����
	$content .= "$nine_mark<a href=\"$script?mode=check\" label=\"�Ǘ�\" accesskey=\"9\" title=\"�Ǘ�\">�Ǘ��Ґ�p</a><br />\n";

	# �z�[��������ꍇ�A�߂荀�ڂ�\��
	if ($x_home) {
		$content .= "$zero_mark<a href=\"$x_home\" accesskey=\"0\" title=\"�߂�\">";
		$content .= "�g�o�֖߂�</a><br />\n";
	}

	# �t�b�^�[�o��
	&footer;
}


#------------------------------------------------------------------------------
# �Ǘ��t�H�[���iEZweb�j
#------------------------------------------------------------------------------
sub x_admin {
	# �w�b�_�[�\��
	$headtype = 1;
	&header;

	# �����\��
	$content .= "<center>��Ǘ��ҋ@�\\�</center><br />\n";

	# �L���폜
	$dest = "$script?mode=ad_dform&amp;psw=$in{'psw'}";
	$content .= "<a href=\"$dest\" title=\"�폜\">[�L���폜����]</a><br />\n";

	# �p�X���[�h�ύX
	$dest = "$script?mode=change&amp;psw=$in{'psw'}";
	$content .= "<a href=\"$dest\" title=\"�ύX\">[�Í��ύX����]</a><br />\n";

	# ��K�،�ǉ�
	$dest = "$script?mode=aform&amp;psw=$in{'psw'}";
	$content .= "<a href=\"$dest\" title=\"�ǉ�\">[��K�،�ǉ�]</a><br />\n";

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
			$content .= "<a href=\"$dest\" title=\"�폜\">�폜-$column[$loop]<br />\n";
			$loop++;
		}
	}

	# �t�b�^�[�\��
	&footer;
	exit;
}

#------------------------------------------------------------------------------
# ��K�،�ǉ��t�H�[���iEZweb�j
#------------------------------------------------------------------------------
sub x_aform {
	# �w�b�_�[�\��
	$headtype = 1;
	&header;

	$content .= "<form action=\"$script\" method=\"$method\">\n";
	$content .= "<input type=\"hidden\" name=\"mode\" value=\"admin\">\n";
	$content .= "<input type=\"hidden\" name=\"func\" value=\"del_word\">\n";
	$content .= "<input type=\"hidden\" name=\"loop\" value=\"$loop\">\n";
	$content .= "<input type=\"submit\" value=\"�폜\">\n";
	$content .= "</form>\n";

	# �t�b�^�[�\��
	&footer;
	exit;
}

#------------------------------------------------------------------------------
# �p�X���[�h�ύX�t�H�[���iEZweb�j
#------------------------------------------------------------------------------
sub x_pform {
	# �w�b�_�[�\��
	$headtype = 1;
	&header;

	$content .= "<form action=\"$script\" method=\"$method\">\n";
	$content .= "<input type=\"hidden\" name=\"mode\" value=\"admin\">\n";
	$content .= "<input type=\"hidden\" name=\"func\" value=\"change\">\n";
	$content .= "�V�Í�\n";
	$content .= "$key_mark";
	$content .= "<input type=\"password\" name=\"pswa\" size=\"16\" format=\"*x\">";
	$content .= "<br />\n";
	$content .= "�m�F�p\n";
	$content .= "<input type=\"password\" name=\"pswb\" size=\"16\" format=\"*x\"><br />\n";
	$content .= "<input type=\"submit\" value=\"�ύX\">\n";
	$content .= "<INPUT type=\"reset\" value=\"���\">\n";
	$content .= "</form>\n";

	# �t�b�^�[�\��
	&footer;
	exit;
}

#------------------------------------------------------------------------------
# �p�X���[�h�m�F�t�H�[���iEZweb�j
#------------------------------------------------------------------------------
sub x_pass {
	# �w�b�_�[�\��
	$headtype = 1;
	&header;

	# ���̓e�[�u��
	$content .= "�p�X���[�h����͂��A����{�^���������Ă��������B<BR>\n";
	# �t�H�[���^�O
	$content .= "<form action=\"$script\" method=\"$method\">\n";
	$content .= "<input type=\"hidden\" name=\"mode\" value=\"admin\">\n";
	$content .= "<input type=\"hidden\" name=\"func\" value=\"check\">\n";
	# �p�X���[�h����
	$content .= "$key_mark";
	$content .= "<input type=\"password\" name=\"psw\" size=\"16\" format=\"*x\">";
	$content .= "<br />\n";
	$content .= "<input type=\"submit\" value=\"����\">\n";
	$content .= "<input type=\"reset\" value=\"���\">\n";
	$content .= "</form>\n";

	# �t�b�^�[�\��
	&footer;
	exit;
}

#------------------------------------------------------------------------------
# �Ǘ��ҍ폜�t�H�[���iEZweb�j
#------------------------------------------------------------------------------
sub x_ad_dform {
	# �w�b�_�[�\��
	$headtype = 1;
	&header;

	# �t�H�[���^�O
	$content .= "<form action=\"$script\" method=\"$method\">\n";
	$content .= "<input type=\"hidden\" name=\"mode\" value=\"admin\">\n";
	$content .= "<input type=\"hidden\" name=\"func\" value=\"delete\">\n";
	$content .= "<input name=\"num\" size=\"5\">\n";
	$content .= "<input type=\"hidden\" name=\"admin\" value=\"1\">\n";
	$content .= "<input type=\"submit\" value=\"�폜\">\n";
	$content .= "</form>\n";

	# �t�b�^�[�\��
	&footer;
	exit;
}



1;
