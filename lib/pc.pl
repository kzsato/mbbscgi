$pcver = "1.03";
# �������ʂ��璼�ڃ��X�t�H�[���ɂ�����悤�ɉ���
#------------------------------------------------------------------------------
# ���e�t�H�[���iPC�j
#------------------------------------------------------------------------------
sub pc_form {
	# �w�b�_�[�o��
	$headtype = 0;
	&header;

	# �^�C�g���\��
	if ($pc_img) {
		$content .= "<div align=\"center\"> <img src=\"$pc_img\"></div><br>\n";
		$content .= "<div align=\"center\"> ���e�t�H�[��</div><br>\n";
	} else {
		$content .= "<table border=\"0\" cellspacing=\"0\" cellpadding=\"1\" width=\"100\%\">\n";
		$content .= "<tr><th bgcolor=\"$tf_clr\">\n";
		$content .= "<table border=\"0\" cellspacing=\"0\" cellpadding=\"2\" width=\"100\%\">\n";
		$content .= "<tr><th bgcolor=\"$tb_clr\">\n";
		$content .= "<font color=\"$ti_clr\">$pc_title�|���e�t�H�[��</font>\n";
		$content .= "</th></tr>\n</table>\n";
		$content .= "</th></tr>\n</table><br>\n";
	}

	# �@�\�o�[�\��
	&topmenu;

	if((!$in{'res'}) &&(!$in{'edno'})){
		# �V�K������
		$content .= "<BR>\n";
		$content .= "<div align=\"center\"> �V�K������</div>\n";
		if($UseWKeyChk){
			$content .= "<div align=\"center\"> �������݃L�[���[�h�́w$wkey�x�ł��B</div>\n";
		}
		$content .= "<div align=\"center\"> �L���������݂��f��</div>\n";
		$content .= "<BR>\n";
	}elsif($in{'edno'}){
		# �ҏW�t�H�[��
		$content .= "<BR>\n";
		$content .= "<div align=\"center\"> �L���̕ҏW</div>\n";
		$content .= "<BR>\n";
		
	}else{
		# ���X���̕��͂�\��
		open (IN,"$logfile") || &error (open_er);
		@line = <IN>;
		close(IN);
		
		$count   = shift(@line);
		$num     = 0;		# �L����
		$num_max = $#line;	# �ő�L����
		$res_dai = "";		# ���X�L���̑薼

		# �g�̕\��
		$content .= "<BR>\n";
		if($UseWKeyChk){
			$content .= "<div align=\"center\"> �������݃L�[���[�h�́w$wkey�x�ł��B</div>\n";
		}
		$content .= "<div align=\"center\"> �ȉ��̃c���[�ɕԐM</div>\n";
		$content .= "<BR>\n";
		$content .= "<TABLE border=\"0\" cellpadding=\"1\" cellspacing=\"0\" width=\"80%\" align=\"center\">\n";
		$content .= "<TR><TD bgcolor=\"$tf_clr\">\n";
		$content .= "<TABLE border=\"0\" cellpadding=\"10\" cellspacing=\"0\" width=\"100%\">\n";
		$content .= "<TR><TD bgcolor=\"$tg_clr\">\n";
		$content .= "<TABLE border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">\n";

		while ($num <= $num_max) {
			# �e�s�𕪊����A�z��Ɋi�[
			@column = split(/<>/,$line[$num]);

			# ���X�L���������^�\��
			if($column[1] == $in{'res'}) {
				# �d�ؐ�
				if ($column[0] != $column[1]) {
					$content .= "<TR><TD bgcolor=\"$tg_clr\" colspan=\"2\">\n";
					$content .= "<HR size=\"1\" width=\"95%\">\n";
					$content .= "</TD></TR>\n";
				}

				if ($column[0] == $column[1]) {
					$res_dai = "RE:$column[5]";
				}

				# ���s�̎n��
				$content .= "<TR><TD bgcolor=\"$tg_clr\">\n";

				# �L���ԍ��̕\��
				$content .= "No.$column[0]\n";

				# �\��̕\��
				$content .= "<FONT color=\"$dai_clr\">$column[5]</FONT>\n";

				# ���O�̕\��
				$content .= "<strong>$column[4]</strong>\n";

				# ���[���A�h���X�̕\��
				if ($column[7] ne '') {
					$content .= "<a href=\"mailto\:$column[7]\">";
					if ($pc_mimg) {
						$content .= "<img border=\"0\" src=\"$pc_mimg\" alt=\"MAIL\">";
					} else {
						$content .= "[mail]\n";
					}
					$content .= "</A>\n";
				}

				# �z�[���y�[�W�̕\��
				if ($column[8] ne ''){
					if ($autolink) { &autolink( $column[8] ); }
					$content .= "$column[8]\n"; 
				}

				# �[���̕\��
				$content .= "<SMALL>[$column[9]]</SMALL>\n";

				# �������ݓ����̕\��
				$content .= "<SMALL>$column[2] $column[3]</SMALL>\n";

				# ���s�̏I���
				$content .= "</TD></TR>\n";

				# �R�����g�̕\��
				if ($autolink) { &autolink( $column[6] ); }
				$content .= "<TR><TD bgcolor=\"$tg_clr\">\n";
				$content .= "<BLOCKQUOTE>\n$column[6]\n</BLOCKQUOTE>\n";
				$content .= "</TD></TR>\n";

			}
			$num++;
		}
		# �g�̕\���i�I���j
		$content .= "</TABLE>\n</TD></TR>\n</TABLE>\n</TD></TR>\n</TABLE>\n";
	}

	
	if($in{'edno'}){
		$edit = $in{'edno'};

		# �L���ǂݏo������
		# �t�@�C���̃I�[�v��
		open (IN, $logfile) || &error("�t�@�C���$file����J���܂���");
		@line = <IN>;
		close(IN);
		
		foreach (@line) {
			if ($_ !~ /$edit/) { next; }
				@line = split(/<>/,$line[$num]);
			last;
		}

		if ($ed_new eq $ed_dres) { &error("�e�L���̕ҏW�͂ł��܂���") };
		
		$c_name = "$column[4]";
		$c_dai = "$column[5]";
		$c_mail = "$column[7]";
		$c_url = "$column[8]";
		$c_msg = "$column[6]";
			
		
	}
	# �N�b�L�[�̎擾
	elsif ($use_cookie) { &get_cookie; }

	# �t�H�[���^�O
	$content .= "<FORM action=\"$script\" method=\"$method\">\n";
	$content .= "<INPUT type=\"hidden\" name=\"mode\" value=\"write\">\n";
	$content .= "<INPUT type=\"hidden\" name=\"res\" value=\"$in{'res'}\">\n";

	# �e�[�u���̎w��
	$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"1\" align=\"center\">\n";
	$content .= "<TR bgcolor=\"$tf_clr\"><TD>\n";
	$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"10\" align=\"center\">\n";
	$content .= "<TR bgcolor=\"$tg_clr\"><TD>\n";
	$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"1\" align=\"center\">\n";

	# ���O����
	$content .= "<TR bgcolor=\"$tg_clr\">\n";
	$content .= "<TD>\n";
	$content .= "<strong>�����O</strong>�@<INPUT name=\"name\" size=\"15\" value=\"$c_name\">";
	if($UseWKeyChk){
		$content .= "<strong>keyword</strong>�@<INPUT name=\"wkey\" size=\"15\" value=\"�͂���\">";
	}
	$content .= "�@<SMALL>�K�{</SMALL>\n";
	$content .= "</TD>\n";
	$content .= "</TR>\n";

	# �薼����
	$content .= "<TR bgcolor=\"$tg_clr\">\n";
	$content .= "<TD>\n";
	$content .= "<strong>��@��</strong>�@<INPUT name=\"dai\" size=\"25\" value=\"$res_dai\" value=\"$c_dai\">";
	$content .= "�@<SMALL>�K�{</SMALL>\n";
	$content .= "</TD>\n";
	$content .= "</TR>\n";

	# ���[���A�h���X����
	$content .= "<TR bgcolor=$tg_clr>\n";
	$content .= "<TD>\n";
	$content .= "<strong>���[��</strong>�@<INPUT name=\"mail\" size=\"25\" value=\"$c_mail\">\n";
	$content .= "</TD>\n";
	$content .= "</TR>\n";

	# �z�[���y�[�W�A�h���X����
	$content .= "<TR bgcolor=\"$tg_clr\">\n";
	$content .= "<TD>\n";
	$content .= "<strong>�t�q�k</strong>�@<INPUT name=\"url\" size=\"40\" value=\"http://$c_url\">\n";
	$content .= "</TD>\n";
	$content .= "</TR>\n";

	# ���b�Z�[�W����
	$content .= "<TR bgcolor=\"$tg_clr\">\n";
	$content .= "<TD><strong>���b�Z�[�W</strong></TD>\n";
	$content .= "</TR>\n";
	$content .= "<TR bgcolor=\"$tg_clr\">\n";
	$content .= "<TD><TEXTAREA name=\"msg\" COLS=\"50\" ROWS=\"6\" value=\"$c_msg\"></TEXTAREA></TD>\n";
	$content .= "</TR>\n";

	# ���e�^����{�^��
	$content .= "<TR bgcolor=\"$tg_clr\"><TD>\n";
	$content .= "<SMALL>�폜�p�X���[�h</SMALL>\n";
	$content .= "<INPUT type=\"password\" name=\"dpas\" size=\"10\" value=\"$c_dpas\">\n";
	$content .= "<INPUT type=\"submit\" value=\"���e\">\n";
	$content .= "<INPUT type=\"reset\" value=\"���\">\n";
	$content .= "</TD></TR>\n";

	# �e�[�u���̎w��i�I���j
	$content .= "</TABLE>\n";
	$content .= "</TD></TR>\n";
	$content .= "</TABLE>\n";
	$content .= "</TD></TR>\n";
	$content .= "</TABLE>\n";

	# �t�H�[���^�O�i�I���j
	$content .= "</FORM>\n";

	# ���ӏ���
	$content .= "<div align=\"center\"> \n";
	$content .= "���̒[���ł����邽�߁A�R���p�N�g�ɋL�����܂��傤�I\n";
	$content .= "</div>\n";

	# �t�b�^�[�o��
	&footer;
}

#------------------------------------------------------------------------------
# ���e�m�F�iPC�j
#------------------------------------------------------------------------------
sub pc_write {
	# �w�b�_�[�o��
	$headtype = 0;
	&header;

	# �^�C�g���\��
	if ($pc_img) {
		$content .= "<div align=\"center\"> <img src=\"$pc_img\"></div><BR>\n";
		$content .= "<div align=\"center\"> �������݊���</div><BR>\n";
	} else {
		$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"1\" width=\"100\%\">\n";
		$content .= "<TR><TH bgcolor=\"$tf_clr\">\n";
		$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"2\" width=\"100\%\">\n";
		$content .= "<TR><TH bgcolor=\"$tb_clr\">\n";
		$content .= "<FONT color=\"$ti_clr\">$pc_title�|�������݊���</FONT>\n";
		$content .= "</TH></TR>\n</TABLE>\n";
		$content .= "</TH></TR>\n</TABLE><BR>\n";
	}

	# ���b�Z�[�W
	$content .= "<BR>\n";
	if ($new == $res) {
		$content .= "<div align=\"center\"> �ȉ��̃��b�Z�[�W��V�K�ɓ��e���܂���</div>\n";
	} else {
		$content .= "<div align=\"center\"> �ȉ��̃��b�Z�[�W�����X���܂���</div>\n";
	}
	$content .= "<BR>\n";

	# �g�̕\��
	$content .= "<TABLE border=\"0\" cellpadding=\"1\" cellspacing=\"0\" width=\"80%\" align=\"center\">\n";
	$content .= "<TR><TD bgcolor=\"$tf_clr\">\n";
	$content .= "<TABLE border=\"0\" cellpadding=\"10\" cellspacing=\"0\" width=\"100%\">\n";
	$content .= "<TR><TD bgcolor=\"$tg_clr\">\n";
	$content .= "<TABLE border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">\n";

	# ���s�̎n��
	$content .= "<TR><TD bgcolor=\"$tg_clr\">\n";

	# �L���ԍ��̕\��
	$content .= "No.$new\n";

	# �\��̕\��
	$content .= "<FONT color=\"$dai_clr\">$dai</FONT>\n";

	# ���O�̕\��
	$content .= "<strong>$name\n";
	
	if ($trip ne '') {
		$content .= " ��</strong>$trip\n";
	} else {
		$content .= "</strong>\n";
	}
	
	# ���[���A�h���X�̕\��
	if ($in{'mail'} ne '') {
		$content .= "<A href=\"mailto\:$in{'mail'}\">";
		if ($pc_mimg) {
			$content .= "<img border=\"0\" src=\"$pc_mimg\" alt=\"MAIL\">";
		} else {
			$content .= "[mail]";
		}
		$content .= "</A>\n";
	}

	# �z�[���y�[�W�̕\��
	if ($in{'url'} ne ''){
		if ($autolink) { &autolink( $in{'url'} ); }
		$content .= "$in{'url'}\n"; 
	}

	# �[���̕\��
	$content .= "<SMALL>[$agent_name]</SMALL>\n";

	# �������ݓ����̕\��
	$content .= "<SMALL>($date $time)</SMALL>\n";

	# ���s�̏I���
	$content .= "</TD></TR>\n";

	# �R�����g�̕\��
	$msg =~ s/\n/<BR>/g;
	if ($autolink) { &autolink( $msg ); }
	$content .= "<TR><TD bgcolor=\"$tg_clr\">\n";
	$content .= "<BLOCKQUOTE>\n$msg\n</BLOCKQUOTE>\n";
	$content .= "</TD></TR>\n";

	# �g�̏I���
	$content .= "</TABLE>\n</TD></TR>\n</TABLE>\n</TD></TR>\n</TABLE>\n";

	# �߂�
	$content .= "<BR><div align=\"center\"> <A href=\"$script\">�߂�</A></div>\n";

	# �t�b�^�[�o��
	&footer;
}

#------------------------------------------------------------------------------
# �����t�H�[���iPC�j
#------------------------------------------------------------------------------
sub pc_sform {
	# �w�b�_�[�o��
	$headtype = 0;
	&header;

	# �^�C�g���\��
	if ($pc_img) {
		$content .= "<div align=\"center\"> <img src=\"$pc_img\"></div><BR>\n";
		$content .= "<div align=\"center\"> �����t�H�[��</div><BR>\n";
	} else {
		$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"1\" width=\"100%\">\n";
		$content .= "<TR><TH bgcolor=\"$tf_clr\">\n";
		$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"2\" width=\"100%\">\n";
		$content .= "<TR><TH bgcolor=\"$tb_clr\">\n";
		$content .= "<FONT color=\"$ti_clr\">$pc_title�|�����t�H�[��</FONT>\n";
		$content .= "</TH></TR>\n</TABLE>\n";
		$content .= "</TH></TR>\n</TABLE><BR>\n";
	}

	# �@�\�o�[�\��
	&topmenu;

	# �����@�\����
	$content .= "<BR>\n";
	$content .= "<div align=\"center\"> \n";
	$content .= "�������������͂��A�����{�^���������Ă��������B<BR>\n";
	$content .= "������͔��p�X�y�[�X�ŋ�؂��ē��͂��ĉ������B�@<BR>\n";
	$content .= "</div>\n";
	$content .= "<BR>\n";

	# �t�H�[���^�O
	$content .= "<FORM action=\"$script\" method=\"$method\">\n";
	$content .= "<INPUT type=\"hidden\" name=\"mode\" value=\"seek\">\n";

	# �e�[�u���̎w��
	$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"1\" align=\"center\">\n";
	$content .= "<TR bgcolor=\"$tf_clr\"><TD>\n";
	$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"10\" align=\"center\">\n";
	$content .= "<TR bgcolor=\"$tg_clr\"><TD>\n";
	$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"1\" align=\"center\">\n";

	# ��������
	$content .= "<TR bgcolor=\"$tg_clr\">\n";
	$content .= "<TD colspan=\"2\"><strong>���������F</strong></TD>\n";
	$content .= "</TR>\n";

	# AND�`�F�b�N
	$content .= "<TR bgcolor=\"$tg_clr\">\n";
	$content .= "<TD>\n";
	$content .= "<INPUT type=\"radio\" name=\"cond\" value=\"and\" checked>�@<strong>AND����</strong>\n";
	$content .= "</TD>\n";
	$content .= "</TR>\n";

	# OR�`�F�b�N
	$content .= "<TR bgcolor=\"$tg_clr\">\n";
	$content .= "<TD>\n";
	$content .= "<INPUT type=\"radio\" name=\"cond\" value=\"or\">�@<strong>OR����</strong>\n";
	$content .= "</TD>\n";
	$content .= "</TR>\n";

	# �d�؂��
	$content .= "<TR bgcolor=\"$tg_clr\">\n";
	$content .= "<TD><HR size=\"1\"></TD>\n";
	$content .= "</TR>\n";

	# ����������
	$content .= "<TR bgcolor=\"$tg_clr\">\n";
	$content .= "<TD><strong>����������F</strong></TD>\n";
	$content .= "</TR>\n";

	# �������������
	$content .= "<TR bgcolor=\"$tg_clr\">\n";
	$content .= "<TD><INPUT name=\"string\" size=\"40\"></TD>\n";
	$content .= "</TR>\n";

	# �����^����{�^��
	$content .= "<TR bgcolor=\"$tg_clr\"><TH>\n";
	$content .= "<INPUT type=\"submit\" value=\"����\">\n";
	$content .= "<INPUT type=\"reset\" value=\"���\">\n";
	$content .= "</TH></TR>\n";

	# �e�[�u���̎w��i�I���j
	$content .= "</TABLE>\n";
	$content .= "</TD></TR>\n";
	$content .= "</TABLE>\n";
	$content .= "</TD></TR>\n";
	$content .= "</TABLE>\n";

	# �t�H�[���^�O�i�I���j
	$content .= "</FORM>\n";

	# �t�b�^�[�o��
	&footer;
}
#------------------------------------------------------------------------------
# �������ʕ\���iPC�j
#------------------------------------------------------------------------------
sub pc_sview {
	# �w�b�_�[�o��
	$headtype = 0;
	&header;

	# ���Ԃ̎擾
	&get_time;

	# �^�C�g���\��
	if ($pc_img) {
		$content .= "<div align=\"center\"> <img src=\"$pc_img\"></div><BR>\n";
		$content .= "<div align=\"center\"> ��������</div><BR>\n";
	} else {
		$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"1\" width=\"100\%\">\n";
		$content .= "<TR><TH bgcolor=\"$tf_clr\">\n";
		$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"2\" width=\"100\%\">\n";
		$content .= "<TR><TH bgcolor=\"$tb_clr\">\n";
		$content .= "<FONT color=\"$ti_clr\">$pc_title�|��������</FONT>\n";
		$content .= "</TH></TR>\n</TABLE>\n";
		$content .= "</TH></TR>\n</TABLE><BR>\n";
	}

	# �@�\�o�[�\��
	&topmenu;

	# �g�̐ݒ�i���x�������̂��ʓ|�������̂Łj
	$s_tab = "<BR>\n";
	$s_tab .= "<TABLE border=\"0\" cellpadding=\"1\" cellspacing=\"0\" width=\"80%\" align=\"center\">\n";
	$s_tab .= "<TR><TD bgcolor=\"$tf_clr\">\n";
	$s_tab .= "<TABLE border=\"0\" cellpadding=\"10\" cellspacing=\"0\" width=\"100%\">\n";
	$s_tab .= "<TR><TD bgcolor=\"$tg_clr\">\n";
	$s_tab .= "<TABLE border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">\n";
	$e_tab = "</TABLE>\n</TD></TR>\n</TABLE>\n</TD></TR>\n</TABLE>\n";

	# �ϐ��̏����ݒ�
	$num     = 0;			# �L����
	$num_max = $#new +1;	# ���[�L����

	# ����\��
	$content .= "<div align=\"center\"> �����̌��� $num_max ���̃��b�Z�[�W�������Ɉ�v���܂����B</div>\n";
	$content .= "<div align=\"center\"> <FONT color=\"$li_clr\">�ڍ�</FONT>��I������ƋL���̂���c���[���{���ł��܂��B</div>\n";
	$content .= "<div align=\"center\"> $new_time���Ԉȓ��̏����݂ɂ�<FONT color=\"$new_clr\">NEW</FONT>�}�[�N��\\�����܂��B</div>\n";

	# ���������̕\��
	$content .= "$s_tab";
	$content .= "<TR><TD><strong>��������</strong></TD></TR>\n";
	$content .= "<TR><TD><BLOCKQUOTE>\n";
	foreach $str (@string) {
		$content .= "$str ";
	}
	$content .= "</BLOCKQUOTE></TD></TR>\n";
	$content .= "$e_tab";

	while ($num < $num_max) {
		# �e�s�𕪊����A�z��Ɋi�[
		@column = split(/<>/,$new[$num]);

		# �e�[�u���n��
		$content .= "$s_tab";

		# ���s�̎n��
		$content .= "<TR><TD bgcolor=\"$tg_clr\">\n";

		# ���eNo.�̕\��
		$content .= "No.$column[0]\n";

		# �\��̕\��
		$content .= "<FONT color=\"$dai_clr\">$column[5]</FONT>\n";

		# ���O�̕\��
		$content .= "<strong>$column[4]\n";
		
		if ($column[15] ne '') {
			$content .= " ��</strong>$column[15]\n";
		} else {
			$content .= "</strong>\n";
		}

		# ���[���A�h���X�̕\��
		if ($column[7] ne '') {
			$content .= "<A href=\"mailto\:$column[7]\">";
			if ($pc_mimg) {
				$content .= "<img border=\"0\" src=\"$pc_mimg\" alt=\"MAIL\">";
			} else {
				$content .= "[mai�@l]\n";
			}
			$content .= "</A>\n";
		}

		# �z�[���y�[�W�̕\��
		if (($column[8] ne '') && ($column[9] == 0)){
			if ($autolink) { &autolink( $column[8] ); }
			$content .= "$column[8]\n"; 
		}

		# �[���̕\��
		$content .= "<SMALL>[$column[9]]</SMALL>\n";

		# �������ݓ����̕\��
		$content .= "<SMALL>$column[2] $column[3]</SMALL>\n";

		# NEW�}�[�N�̕\��
		if (($times - $column[13]) < $new_time * 3600) {
			$content .= "<FONT color=\"$new_clr\">NEW</FONT>\n";
		}

		# �c���[��\�����郊���N�̕\��
		if ($column[16] ne "1") {
			$content .= "<A href=\"$script?mode=form&amp;res=$column[1]\">�ԐM</A>\n";
		} else {
			$content .= "<A href=\"$script?mode=view&amp;tree=$column[1]\">�ڍ�</A>\n";
		}

		# ���s�̏I���
		$content .= "</TD></TR>\n";

		# �R�����g�̕\��
		if ($autolink) { &autolink( $column[6] ); }
		$content .= "<TR><TD bgcolor=\"$tg_clr\">\n";
		$content .= "<BLOCKQUOTE>\n$column[6]\n</BLOCKQUOTE>\n";
		$content .= "</TD></TR>\n";

		# �e�[�u���I���
		$content .= "$e_tab";

		$num++;
	}

	# �L�����Ȃ��ꍇ�̏���
	if ($num == 0) {
		$content .= "$s_tab";
		$content .= "<TR><TD bgcolor=\"$tg_clr\">\n";
		$content .= "<BLOCKQUOTE>���������Ɉ�v���郁�b�Z�[�W�͂���܂���ł����B</BLOCKQUOTE>\n";
		$content .= "</TD></TR>\n";
		$content .= "$e_tab";
	}

	# ���[�U�폜�g�̕\��
	$content .= "<div align=\"center\"> <SMALL>\n";
	$content .= "<FORM action=\"$script\" method=\"$method\">\n";
	$content .= "<INPUT type=\"hidden\" name=\"func\" value=\"user_delete\">\n";
	$content .= "���[�U�폜�F�e������͂��č폜�������Ă��������B<BR>\n";
	$content .= "�L���ԍ��F<INPUT name=\"num\" size=\"4\">\n";
	$content .= "�p�X���[�h�F<INPUT type=\"password\" name=\"dpas\" size=\"10\">\n";
	$content .= "<INPUT type=\"submit\" value=\"�폜\">\n";
	$content .= "<INPUT type=\"reset\" value=\"���\">\n";
	$content .= "</SMALL></div>\n";

	# �t�b�^�[�o��
	&footer;
}

#------------------------------------------------------------------------------
# �p�X���[�h���̓t�H�[���iPC�j
#------------------------------------------------------------------------------
sub passform {
	# �w�b�_�[�o��
	$headtype = 0;
	&header;

	# �^�C�g���\��
	if ($pc_img) {
		$content .= "<div align=\"center\"> <img src=\"$pc_img\"></div><BR>\n";
		$content .= "<div align=\"center\"> �p�X���[�h���̓t�H�[��</div><BR>\n";
	} else {
		$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"1\" width=\"100\%\">\n";
		$content .= "<TR><TH bgcolor=\"$tf_clr\">\n";
		$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"2\" width=\"100\%\">\n";
		$content .= "<TR><TH bgcolor=\"$tb_clr\">\n";
		$content .= "<FONT color=\"$ti_clr\">$pc_title�|�p�X���[�h���̓t�H�[��</FONT>\n";
		$content .= "</TH></TR>\n</TABLE>\n";
		$content .= "</TH></TR>\n</TABLE><BR>\n";
	}

	# ���̓e�[�u��
	$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"0\" width=\"100%\" height=\"50%\">\n";
	$content .= "<TR><TD align=\"center\" valign=\"center\"><div align=\"center\"> \n";
	$content .= "�p�X���[�h����͂��A����{�^���������Ă��������B<BR>\n";
	# �t�H�[���^�O
	$content .= "<FORM action=\"$script\" method=\"$method\">\n";
	$content .= "<INPUT type=\"hidden\" name=\"mode\" value=\"admin\">\n";
	$content .= "<INPUT type=\"hidden\" name=\"func\" value=\"check\">\n";
	$content .= "<INPUT type=\"password\" name=\"psw\" size=\"20\">\n";
	$content .= "<INPUT type=\"submit\" value=\"����\">\n";
	$content .= "<INPUT type=\"reset\" value=\"���\">\n";
	$content .= "</FORM>\n";
	$content .= "</TD></TR>\n";
	$content .= "</TABLE>\n";

	# �t�b�^�[�o��
	&footer;
}


#------------------------------------------------------------------------------
# �Ǘ��t�H�[���iPC�j
#------------------------------------------------------------------------------
sub admin {
	# �w�b�_�[�o��
	$headtype = 0;
	&header;

	# �^�C�g���\��
	if ($pc_img) {
		$content .= "<div align=\"center\"> <img src=\"$pc_img\"></div><BR>\n";
		$content .= "<div align=\"center\"> �Ǘ��t�H�[��</div><BR>\n";
	} else {
		$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"1\" width=\"100\%\">\n";
		$content .= "<TR><TH bgcolor=\"$tf_clr\">\n";
		$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"2\" width=\"100\%\">\n";
		$content .= "<TR><TH bgcolor=\"$tb_clr\">\n";
		$content .= "<FONT color=\"$ti_clr\">$pc_title�|�Ǘ��t�H�[��</FONT>\n";
		$content .= "</TH></TR>\n</TABLE>\n";
		$content .= "</TH></TR>\n</TABLE><BR>\n";
	}

	# �@�\�o�[�\��
	&topmenu;

	# �R�����g
	$content .= "<BR>\n";
	$content .= "<div align=\"center\"> ���p�������@\�\\��I�����ĉ������B</div>\n";
	$content .= "<BR>\n";

	# �e�[�u���̎w��
	$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"1\" align=\"center\">\n";
	$content .= "<TR bgcolor=\"$tf_clr\"><TD>\n";
	$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"10\" align=\"center\">\n";
	$content .= "<TR bgcolor=\"$tg_clr\"><TD>\n";
	$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"1\" align=\"center\">\n";

	# �Ǘ��t�@�C�����J��
	open (IN,"$pswfile") || &error (open_er);
	@line = <IN>;
	close(IN);

	# �f�o�C�X���X�V�����@# 08.02.15 �ǉ�
	$content .= "<TR bgcolor=\"$tg_clr\">\n";
	$content .= "<TD colspan=\"3\">\n";
	$content .= "<STRONG>�f�o�C�X���X�V����</STRONG>\n";
	$content .= "</TD>\n";
	$content .= "<TD>\n";
	$content .= "<FORM action=\"$script\" method=\"$method\">\n";
	$content .= "<INPUT type=\"hidden\" name=\"mode\" value=\"update\">\n";
#	$content .= "<INPUT type=\"hidden\" name=\"psw\" value=\"$in{'psw'}\">\n";
	$content .= "<INPUT type=\"submit\" value=\"�I��\">\n";
	$content .= "</FORM>\n";
	$content .= "</TD>\n";
	$content .= "</TR>\n";

	# �L���폜�����\��
	$content .= "<TR bgcolor=\"$tg_clr\">\n";
	$content .= "<TD colspan=\"3\">\n";
	$content .= "<STRONG>�L���폜����</STRONG>\n";
	$content .= "</TD>\n";
	$content .= "<TD>\n";
	$content .= "<FORM action=\"$script\" method=\"$method\">\n";
	$content .= "<INPUT type=\"hidden\" name=\"mode\" value=\"dform\">\n";
#	$content .= "<INPUT type=\"hidden\" name=\"psw\" value=\"$in{'psw'}\">\n";
	$content .= "<INPUT type=\"submit\" value=\"�I��\">\n";
	$content .= "</FORM>\n";
	$content .= "</TD>\n";
	$content .= "</TR>\n";

	# �p�X���[�h�ύX�����\��
	$content .= "<TR bgcolor=\"$tg_clr\">\n";
	$content .= "<TD colspan=\"4\">\n";
	$content .= "<STRONG>�p�X���[�h�ύX����</STRONG>\n";
	$content .= "</TD>\n";
	$content .= "</TR>\n";

	# �p�X���[�h�ύX�t�H�[��
	$content .= "<FORM action=\"$script\" method=\"$method\">\n";
	$content .= "<INPUT type=\"hidden\" name=\"mode\" value=\"admin\">\n";
	$content .= "<INPUT type=\"hidden\" name=\"func\" value=\"change\">\n";
#	$content .= "<INPUT type=\"hidden\" name=\"psw\" value=\"$in{'psw'}\">\n";
	$content .= "<TR bgcolor=\"$tg_clr\">\n";
	$content .= "<TD>�@</TD>\n";
	$content .= "<TD>�V�Í�</TD>\n";
	$content .= "<TD><INPUT type=\"password\" name=\"pswa\" size=\"20\"></TD>\n";
	$content .= "<TD><INPUT type=\"reset\" value=\"���\"></TD>\n";
	$content .= "</TR>\n";
	$content .= "<TR bgcolor=\"$tg_clr\">\n";
	$content .= "<TD>�@</TD>\n";
	$content .= "<TD>�m�F�p</TD>\n";
	$content .= "<TD><INPUT type=\"password\" name=\"pswb\" size=\"20\"></TD>\n";
	$content .= "<TD><INPUT type=\"submit\" value=\"�ύX\"></TD>\n";
	$content .= "</TR>\n";
	$content .= "</FORM>\n";

	@column = split(/<>/,$line[1]);
	$num = $#column;
	if ($num) {
		# ��K�،�폜�����\��
		$content .= "<TR bgcolor=\"$tg_clr\">\n";
		$content .= "<TD colspan=\"4\">\n";
		$content .= "<STRONG>��K�،�폜</STRONG>\n";
		$content .= "</TD>\n";
		$content .= "</TR>\n";

		# ��K�،�폜�t�H�[��
		$loop = 0;
		while ($loop < $num) {
			$content .= "<TR bgcolor=\"$tg_clr\">\n";
			$content .= "<TD>�@</TD>\n";
			$content .= "<TD align=\"right\">�E</TD>\n";
			$content .= "<TD>$column[$loop]</TD>\n";
			$content .= "<FORM action=\"$script\" method=\"$method\">\n";
			$content .= "<INPUT type=\"hidden\" name=\"mode\" value=\"admin\">\n";
			$content .= "<INPUT type=\"hidden\" name=\"func\" value=\"del_word\">\n";
			$content .= "<INPUT type=\"hidden\" name=\"loop\" value=\"$loop\">\n";
#			$content .= "<INPUT type=\"hidden\" name=\"psw\" value=\"$in{'psw'}\">\n";
			$content .= "<TD><INPUT type=\"submit\" value=\"�폜\"></TD>\n";
			$content .= "</TR>\n";
			$content .= "</FORM>\n";
			$loop++;
		}
	}

	# ��K�،�폜�����\��
	$content .= "<TR bgcolor=\"$tg_clr\">\n";
	$content .= "<TD colspan=\"4\">\n";
	$content .= "<STRONG>��K�،�ǉ�</STRONG>\n";
	$content .= "</TD>\n";
	$content .= "</TR>\n";

	# ��K�،�ǉ��t�H�[��
	$content .= "<FORM action=\"$script\" method=\"$method\">\n";
	$content .= "<INPUT type=\"hidden\" name=\"mode\" value=\"admin\">\n";
	$content .= "<INPUT type=\"hidden\" name=\"func\" value=\"add_word\">\n";
#	$content .= "<INPUT type=\"hidden\" name=\"psw\" value=\"$in{'psw'}\">\n";
	$content .= "<TR bgcolor=\"$tg_clr\">\n";
	$content .= "<TD>�@</TD>\n";
	$content .= "<TD>��K�،�</TD>\n";
	$content .= "<TD><INPUT type=\"text\" name=\"word\" size=\"20\"></TD>\n";
	$content .= "<TD><INPUT type=\"submit\" value=\"�ǉ�\"></TD>\n";
	$content .= "</TR>\n";
	$content .= "</FORM>\n";

	# �e�[�u���̎w��i�I���j
	$content .= "</TABLE>\n";
	$content .= "</TD></TR>\n";
	$content .= "</TABLE>\n";
	$content .= "</TD></TR>\n";
	$content .= "</TABLE>\n";

	# �t�b�^�[�o��
	&footer;
}

#------------------------------------------------------------------------------
# �Ǘ��t�H�[���iPC�j
#------------------------------------------------------------------------------
sub adminmes {
	# �w�b�_�[�o��
	$headtype = 0;
	&header;

	# �^�C�g���\��
	if ($pc_img) {
		$content .= "<div align=\"center\"> <img src=\"$pc_img\"></div><BR>\n";
		$content .= "<div align=\"center\"> �Ǘ��t�H�[��</div><BR>\n";
	} else {
		$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"1\" width=\"100\%\">\n";
		$content .= "<TR><TH bgcolor=\"$tf_clr\">\n";
		$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"2\" width=\"100\%\">\n";
		$content .= "<TR><TH bgcolor=\"$tb_clr\">\n";
		$content .= "<FONT color=\"$ti_clr\">$pc_title�|�Ǘ��t�H�[��</FONT>\n";
		$content .= "</TH></TR>\n</TABLE>\n";
		$content .= "</TH></TR>\n</TABLE><BR>\n";
	}

	# �@�\�o�[�\��
	&topmenu;

	# �R�����g
	$content .= "<BR>\n";
	$content .= "<div align=\"center\"> �p�X���[�h�ύX�����B�ēx���O�C�����Ă��������B</div>\n";
	$content .= "<BR>\n";


	# �e�[�u���̎w��i�I���j
	$content .= "</TABLE>\n";
	$content .= "</TD></TR>\n";
	$content .= "</TABLE>\n";
	$content .= "</TD></TR>\n";
	$content .= "</TABLE>\n";

	# �t�b�^�[�o��
	&footer;
}

#------------------------------------------------------------------------------
# �폜�t�H�[���iPC�j
#------------------------------------------------------------------------------
sub dform {
	# �w�b�_�[�o��
	$headtype = 0;
	&header;

	# �^�C�g���\��
	if ($pc_img) {
		$content .= "<div align=\"center\"> <img src=\"$pc_img\"></div><BR>\n";
		$content .= "<div align=\"center\"> �폜�t�H�[��</div><BR>\n";
	} else {
		$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"1\" width=\"100%\">\n";
		$content .= "<TR><TH bgcolor=\"$tf_clr\">\n";
		$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"2\" width=\"100%\">\n";
		$content .= "<TR><TH bgcolor=\"$tb_clr\">\n";
		$content .= "<FONT color=\"$ti_clr\">$pc_title�|�폜�t�H�[��</FONT>\n";
		$content .= "</TH></TR>\n</TABLE>\n";
		$content .= "</TH></TR>\n</TABLE><BR>\n";
	}

	# �@�\�o�[�\��
	&topmenu;

	# ���O�t�@�C�����I�[�v������B
	open (IN,"$logfile") || &error (open_er);
	@line = <IN>;
	close(IN);
	
	# �ϐ��̏����ݒ�
	$count   = shift(@line);	# ���O�J�E���g�𕪗�
	$num     = 0;				# �L����
	$num_max = @line;			# ���[�L����
	$num_t   = 0;				# �c���[��
	$page    = $in{'page'};		# �y�[�W�̎w��
	$num_pag = 1;				# �y�[�W�̃J�E���g

	# �y�[�W�̎w��̂Ȃ��ꍇ�͎n�߂̃y�[�W�ɂ���B
	if ($page eq "") { $page = 1; }

	# �g�̎n��
	$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"0\" align=\"center\">\n";
	$content .= "<TR>\n";

	# �߂�{�^��
	$content .= "<FORM action=\"$script\" method=\"$method\">\n";
	$content .= "<INPUT type=\"hidden\" name=\"mode\" value=\"admin\">\n";
	$content .= "<TD>\n";
	$content .= "<INPUT type=\"submit\" value=\"�߂�\">\n";
	$content .= "</TD>\n";
	$content .= "</FORM>\n";

	# �t�H�[���^�O
	$content .= "<FORM action=\"$script\" method=\"$method\">\n";
	$content .= "<INPUT type=\"hidden\" name=\"mode\" value=\"dform\">\n";
	$content .= "<INPUT type=\"hidden\" name=\"func\" value=\"delete\">\n";
#	$content .= "<INPUT type=\"hidden\" name=\"psw\" value=\"$in{'psw'}\">\n";
	$content .= "<INPUT type=\"hidden\" name=\"page\" value=\"$page\">\n";

	# �폜�^����{�^��
	$content .= "<TD>\n";
	$content .= "<INPUT type=\"submit\" value=\"�폜\">\n";
	$content .= "</TD>\n";
	$content .= "<TD>\n";
	$content .= "<INPUT type=\"reset\" value=\"���\">\n";
	$content .= "</TD>\n";

	# �g�̏I���
	$content .= "</TR>\n</TABLE>\n<BR>\n";

	# �g�̎n��
	$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"0\" align=\"center\">\n";
	$content .= "<TR bgcolor=\"$tf_clr\"><TD>\n";
	$content .= "<TABLE border=\"0\" cellspacing=\"1\" cellpadding=\"2\">\n";

	# ���ڍs��\��
	$content .= "<TR bgcolor=\"$tg_clr\">\n";
	$content .= "<TD><SMALL>�ꊇ</SMALL></TD>\n";
	$content .= "<TD><SMALL>����</SMALL></TD>\n";
	$content .= "<TD><SMALL>��</SMALL></TD>\n";
	$content .= "<TD><SMALL>No.</SMALL></TD>\n";
	$content .= "<TD><SMALL>����</SMALL></TD>\n";
	$content .= "<TD><SMALL>�薼</SMALL></TD>\n";
	$content .= "<TD><SMALL>���O</SMALL></TD>\n";
	$content .= "<TD><SMALL>�g���b�v</small></td>\n";
	$content .= "<TD><SMALL>�{��</SMALL></TD>\n";
	$content .= "<TD><SMALL>ML</SMALL></TD>\n";
	$content .= "<TD><SMALL>HP</SMALL></TD>\n";
	$content .= "<TD><SMALL>�[��/UA</SMALL></TD>\n";
	$content .= "<TD><SMALL>�z�X�g��/IP�A�h���X</SMALL></TD>\n";
	$content .= "</TR>\n";

	while ($num < $num_max) {
		# �e�s�𕪊����A�z��Ɋi�[
		@column = split(/<>/,$line[$num]);

		# �y�[�W�̃J�E���g
		if ($column[0] == $column[1]) {
			if ($num_t == $max_dform) {
				$num_t = 0;
				$num_pag++;
			}
			$num_t++;
		}

		if ($num_pag == $page) {
			# �s�̎n��
			$content .= "<TR bgcolor=$tg_clr>\n";

			# �c���[�\����\��
			if ($column[0] == $column[1]){
				$content .= "<TD><SMALL>";
				$content .= "<INPUT type=\"checkbox\" name=\"tree$column[1]\" value=\"1\">";
				$content .= "</SMALL></TD>\n";
				
				$content .= "<TD><SMALL>";
				if ($column[16] == "1"){
					$content .= "off<INPUT type=\"checkbox\" name=\"tree$column[1]\" value=\"3\">";
				} else {
					$content .= "on<INPUT type=\"checkbox\" name=\"tree$column[1]\" value=\"2\">";
				}
				$content .= "</SMALL></TD>\n";
		}else {
				$content .= "<TD><SMALL>��</SMALL></TD>\n";
				$content .= "<TD><SMALL>��</SMALL></TD>\n";
		}

			# �폜�p�̃`�F�b�N�{�b�N�X�\��
			$content .= "<TD><SMALL><INPUT type=\"checkbox\" name=\"col$column[0]\" value=\"1\"></SMALL></TD>\n";

			# ���eNo.�̕\��
			$content .= "<TD><SMALL>$column[0]</SMALL></TD>\n";

			# �������ݓ����̕\��
			$content .= "<TD><SMALL>$column[2]<BR>$column[3]</SMALL></TD>\n";

			# �\��̕\��
			$column[5] =~ s/<BR>//g;
			$column[5] =~ s/(....................)(.*)/$1/;
			$content .= "<TD><SMALL><FONT color=\"$dai_clr\">$column[5] </SMALL></TD>\n";

			# ���O�̕\��
			$content .= "<TD><SMALL>$column[4]</SMALL></TD>\n";
			
			# �g���b�v�̕\��
			$content .= "<td><small>$column[15]</small></td>\n";
			
			# �R�����g�̕\��
			$column[6] =~ s/<BR>//g;
			$column[6] =~ s/(........................................)(.*)/$1/;
			$content .= "<TD><SMALL>$column[6] </SMALL></TD>\n";

			# ���[���A�h���X�̕\��
			if ($column[7] ne '') {
				$content .= "<TD><SMALL><A href=\"mailto\:$column[7]\">";
				if ($pc_mimg ne '') {
					$content .= "<img border=\"0\" src=\"$pc_mimg\" alt=\"$column[7]\">";
				} else {
					$content .= "��";
				}
				$content .= "</A></SMALL></TD>\n";
			} else {
				$content .= "<TD><SMALL>�@</SMALL></TD>\n";
			}

			# �z�[���y�[�W�̕\��
			if ($column[8] ne '') {
				&autolink( $column[8] );
				$content .= "<TD>$column[8]</TD>\n";
			} else {
				$content .= "<TD><SMALL>�@</SMALL></TD>\n";
			}

			if($column[14] ne '') {
				# �[���̕\��
				$content .= "<TD><SMALL>[$column[9]]<BR>$column[14]</SMALL></TD>\n";
			}
			else{
				# �[���̕\��
				$content .= "<TD><SMALL>[$column[9]]</SMALL></TD>\n";
			}
			
			# �z�X�g��/IP�A�h���X�̕\��
			$content .= "<TD><SMALL>$column[10]<BR>$column[11]</SMALL></TD>\n";

			# �s�̏I���
			$content .= "</TR>\n";
		}
		$num++;
	}

	# �L�����Ȃ��ꍇ�̏���
	if (($num == 0) || ($num_pag < $page)) {
		$content .= "$s_tab";
		$content .= "<TR><TD bgcolor=\"$tg_clr\" colspan=\"11\">\n";
		$content .= "<BLOCKQUOTE>���e�L���͗L��܂���</BLOCKQUOTE>\n";
		$content .= "</TD></TR>\n";
	}

	# �g�̕\���i�I���j
	$content .= "</TABLE>\n</TD></TR>\n</TABLE>";

	# �t�H�[���^�O�i�I���j
	$content .= "</FORM>\n";

	# �y�[�W�\��
	if ($num_pag != 1) {
		$content .= "<BR><TABLE border=\"0\" cellpadding=\"0\" cellspacing=\"0\" align=\"center\">";
		$content .= "<TR><TD valign=\"top\"><SMALL>";
		$content .= "�y�[�W�w��F";
		$content .= "</SMALL></TD><TD><SMALL>";
		$num = 1;	# �y�[�W�J�E���g
		$numc = 0;	# ���s�̂��߂̃J�E���g
		while ($num <= $num_pag) {
			if ($num < 10) { $num = "0" . "$num"; }
			if ($page == $num) {
				# ���݃y�[�W��ԐF�ŕ\��
				$content .= "<FONT color=\"$new_clr\">$num</FONT>\n";
			} else {
				# �ʂ̃y�[�W�������N
				$content .= "<A href=\"$script?mode=dform\&amp;page=$num\">$num</A>\n";
#				$content .= "<A href=\"$script?mode=dform\&amp;page=$num\&amp;psw=$in{'psw'}\">$num</A>\n";
			}
			# 10�y�[�W���ƂɃJ�E���g����B
			if ($num =~ /0$/) { $numc++; }
			# 20�y�[�W���Ƃɉ��s������
			if ($numc == 2) { $numc = 0; $content .= "<BR>\n"; }
			$num++;
		}
		$content .= "</SMALL></TD></TR></TABLE>\n";
	}

	# �t�b�^�[�o��
	&footer;
}

#------------------------------------------------------------------------------
# �ʕ\���iPC�j
#------------------------------------------------------------------------------
sub pc_view {
	# �w�b�_�[�o��
	$headtype = 0;
	&header;

	# �^�C�g���\��
	if ($pc_img) {
		$content .= "<div align=\"center\"> <img src=\"$pc_img\"></div><BR>\n";
		$content .= "<div align=\"center\"> �ʕ\\��</div><BR>\n";
	} else {
		$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"1\" width=\"100\%\">\n";
		$content .= "<TR><TH bgcolor=\"$tf_clr\">\n";
		$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"2\" width=\"100\%\">\n";
		$content .= "<TR><TH bgcolor=\"$tb_clr\">\n";
		$content .= "<FONT color=\"$ti_clr\">$pc_title�|�ʕ\\��</FONT>\n";
		$content .= "</TH></TR>\n</TABLE>\n";
		$content .= "</TH></TR>\n</TABLE><BR>\n";
	}

	# �@�\�o�[�\��
	&topmenu;


	# ����\��
	$content .= "<div align=\"center\"> �ʂ̕\\���ł��B�ԐM�������ƃc���[�ɕԐM���܂��B</div>\n";
	$content .= "<div align=\"center\"> $new_time���Ԉȓ��̏����݂ɂ�<FONT color=\"$new_clr\">NEW</FONT>�}�[�N��\\�����܂��B</div><BR>\n";

	# �g�̕\��
	$content .= "<TABLE border=\"0\" cellpadding=\"1\" cellspacing=\"0\" width=\"80%\" align=\"center\">\n";
	$content .= "<TR><TD bgcolor=\"$tf_clr\">\n";
	$content .= "<TABLE border=\"0\" cellpadding=\"10\" cellspacing=\"0\" width=\"100%\">\n";
	$content .= "<TR><TD bgcolor=\"$tg_clr\">\n";
	$content .= "<TABLE border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">\n";

	# ���X���̃c���[��\��
	open (IN,"$logfile") || &error (open_er);
	@line = <IN>;
	close(IN);
	
	$count   = shift(@line);
	$num     = 0;		# �L����
	$num_max = $#line;	# �ő�L����

	while ($num <= $num_max) {
		# �e�s�𕪊����A�z��Ɋi�[
		@column = split(/<>/,$line[$num]);

		# �c���[�������^�\��
		if (($column[1] == $in{'tree'}) || ($column[0] == $in{'no'})) {
			# �d�ؐ�
			if (($column[0] != $column[1]) && ($in{'tree'})) {
				$content .= "<TR><TD bgcolor=\"$tg_clr\" colspan=\"2\">\n";
				$content .= "<HR size=\"1\" width=\"95%\">\n";
				$content .= "</TD></TR>\n";
			}

			# ���s�̎n��
			$content .= "<TR><TD bgcolor=\"$tg_clr\">\n";

			# �L���ԍ��̕\��
			$content .= "No.$column[0]\n";

			# �\��̕\��
			$content .= "<FONT color=\"$dai_clr\">$column[5]</FONT>\n";

			# ���O�̕\��
			$content .= "<strong>$column[4]\n";
			
			if ($column[15] ne '') {
				$content .= " ��</strong>$column[15]\n";
			} else {
				$content .= "</strong>\n";
			}

			# ���[���A�h���X�̕\��
			if ($column[7] ne '') {
				$content .= "<A href=\"mailto\:$column[7]\">";
				if ($pc_mimg) {
					$content .= "<img border=\"0\" src=\"$pc_mimg\" alt=\"MAIL\">";
				} else {
					$content .= "[mail]\n";
				}
				$content .= "</A>\n";
			}

			# �z�[���y�[�W�̕\��
			if ($column[8] ne ''){
				if ($autolink) { &autolink( $column[8] ); }
				$content .= "$column[8]\n"; 
			}

			# �[���̕\��
			$content .= "<SMALL>[$column[9]]</SMALL>\n";

			# �������ݓ����̕\��
			$content .= "<SMALL>$column[2] $column[3]</SMALL>\n";

			# �ԐM
			if ($column[0] == $column[1] && $column[16] ne "1") {
				$content .= "<A href=\"$script?mode=form&amp;res=$column[1]\">�ԐM</A>\n";
			}

			# ���s�̏I���
			$content .= "</TD></TR>\n";

			# �R�����g�̕\��
			if ($autolink) { &autolink( $column[6] ); }
			$content .= "<TR><TD bgcolor=\"$tg_clr\">\n";
			$content .= "<BLOCKQUOTE>\n$column[6]\n</BLOCKQUOTE>\n";
			$content .= "</TD></TR>\n";

		}
		$num++;
	}

	# �g�̕\���i�I���j
	$content .= "</TABLE>\n</TD></TR>\n</TABLE>\n</TD></TR>\n</TABLE>\n";

	$content .= "<BR>\n<div align=\"center\"> ";
	$content .= "<A href=\"javascript:history.back()\">���ǂ�</A>";
	$content .= "</div>\n<BR>\n";

	# ���[�U�폜�g�̕\��
	$content .= "<div align=\"center\"> <SMALL>\n";
	$content .= "<FORM action=\"$script\" method=\"$method\">\n";
	$content .= "<INPUT type=\"hidden\" name=\"func\" value=\"user_delete\">\n";
	$content .= "���[�U�폜�F�e������͂��č폜�������Ă��������B<BR>\n";
	$content .= "�L���ԍ��F<INPUT name=\"num\" size=\"4\">\n";
	$content .= "�p�X���[�h�F<INPUT type=\"password\" name=\"dpas\" size=\"10\">\n";
	$content .= "<INPUT type=\"submit\" value=\"�폜\">\n";
	$content .= "<INPUT type=\"reset\" value=\"���\">\n";
	$content .= "</SMALL></div>\n";

	# �t�b�^�[�o��
	&footer;
}

#------------------------------------------------------------------------------
# �c���[�\���iPC�j
#------------------------------------------------------------------------------
sub pc_tree {
	# ���O�t�@�C�����I�[�v������
	open (IN,"$logfile") || &error (open_er);
	@line = <IN>;
	close(IN);

	# �w�b�_�[�o��
	$headtype = 0;
	&header;

	# ���Ԃ̎擾
	&get_time;

	# �^�C�g���\��
	if ($pc_img) {
		$content .= "<div align=\"center\"> <img src=\"$pc_img\"></div><BR>\n";
		$content .= "<div align=\"center\"> �c���[�\\��</div><BR>\n";
	} else {
		$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"1\" width=\"100%\" summary=\"tree\">\n";
		$content .= "<TR><TH bgcolor=\"$tf_clr\">\n";
		$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"2\" width=\"100%\" summary=\"tree\">\n";
		$content .= "<TR><TH bgcolor=\"$tb_clr\">\n";
		$content .= "<FONT color=\"$ti_clr\">$pc_title�|�c���[�\\��</FONT>\n";
		$content .= "</TH></TR>\n</TABLE>\n";
		$content .= "</TH></TR>\n</TABLE><BR>\n";
	}

	# �@�\�o�[�\��
	&topmenu;
	
	# ����\��
	$content .= "<div align=\"center\"> �P�y�[�W�ɍő�$max_tree���̃c���[��\\�����܂��B</div>\n";
	$content .= "<div align=\"center\"> $new_time���Ԉȓ��̏����݂ɂ�<FONT color=\"$new_clr\">NEW</FONT>�}�[�N��\\�����܂��B</div>\n";
	$content .= "<div align=\"center\"> <FONT color=\"$li_clr\">$top_mark</FONT>�������ƃc���[���A<FONT color=\"$dai_clr\">�薼</FONT>�������Ɗe�L����\\�����܂��B</div>\n";
	$content .= "<div align=\"center\"> �L���������݂��f��B</div>\n";

	# �ϐ��̏����ݒ�
	$count   = shift(@line);	# ���O�J�E���g�𕪗�
	$num     = 0;				# �L����
	$num_max = @line;			# ���[�L����
	$num_t   = 0;				# �c���[�̃J�E���g
	$page    = $in{'page'};		# �y�[�W�w��
	$num_pag = 1;				# �y�[�W�̃J�E���g

	# �y�[�W�w��̂Ȃ��ꍇ�͎n�߂̃y�[�W�ɂ���B
	if ($page eq "") { $page = 1; }

	# ���X�g�J�n
	$content .= "<BLOCKQUOTE>\n";
	$content .= "<DL>\n";

	while ($num < $num_max) {
		# �e�s�𕪊����A�z��Ɋi�[
		@column = split(/<>/,$line[$num]);

		if ($column[0] == $column[1]) {
			if ($num_t == $max_tree) {
				$num_t = 0;
				$num_pag++;
			}
			$num_t++;
		}

		if ($num_pag == $page) {
			if ($column[0] == $column[1]) {
				$content .= "<DT>\n";
				$content .= "<A href=\"$script?mode=view&amp;tree=$column[1]&amp;page=$page\">$top_mark</A>\n";
				$dai_tmp = "RE:$column[5]";
			} else {
				$content .= "<DD>\n$res_mark\n";
			}

			# ���eNo.�̕\��
			$content .= "No.$column[0]\n";

			# �薼�⊮�@�\
			if (($dai_aid) && ($column[5] eq $dai_tmp)) {
				$column[5] = $column[6] ;
				$column[5] =~ s/<BR>//g;
				$column[5] =~ s/(....................)(.*)/$1/;
			}

			# �\��̕\��
			$content .= "<A href=\"$script?mode=view&amp;no=$column[0]&amp;page=$page\">\n";
			$content .= "<FONT color=\"$dai_clr\">$column[5] </FONT>\n";
			$content .= "</A>\n";

			# ���O�̕\��
			$content .= "<strong>$column[4]\n";
			
			if ($column[15] ne '') {
				$content .= " ��</strong>$column[15]\n";
			} else {
				$content .= "</strong>\n";
			}

			# ���[���A�h���X�̕\��
			if ($column[7] ne '') {
				$content .= "<A href=\"mailto\:$column[7]\">";
				if ($pc_mimg) {
					$content .= "<img border=\"0\" src=\"$pc_mimg\" alt=\"MAIL\">";
				} else {
					$content .= "[mail]\n";
				}
				$content .= "</A>\n";
			}

			# �z�[���y�[�W�̕\��
			if ($column[8] ne '') {
				if ($autolink) { &autolink( $column[8] ); }
				$content .= "$column[8]\n"; 
			}

			# �[���̕\��
			$content .= "<SMALL>[$column[9]]</SMALL>\n";

			# �������ݓ����̕\��
			$content .= "<SMALL>$column[2] $column[3]</SMALL>\n";

			# NEW�}�[�N�̕\��
			if (($times - $column[13]) < $new_time * 3600) {
				$content .= "<FONT color=\"$new_clr\">NEW</FONT>\n";
			}

			# �ԐM
			if ($column[0] == $column[1] && $column[16] ne "1") { 
				$content .= "<A href=\"$script?mode=form&amp;res=$column[0]\">�ԐM</A>\n";
			}

			if ($column[0] == $column[1] && $column[16] ne "1"){
				$content .= "</DT>\n";
			} else {
				$content .= "</DD>\n";
			}
		}
		$num++;
	}

	# �L�����Ȃ��ꍇ�̏���
	if ($num == 0) {
		$content .= "$s_tab";
		$content .= "<DT>���e�L���͗L��܂���</DT>\n";
	}

	# ���X�g�I���
	$content .= "</DL>\n";
	$content .= "</BLOCKQUOTE>\n";

	# �y�[�W�\��
	if ($num_pag != 1) {
		$content .= "<BR><TABLE border=\"0\" cellpadding=\"0\" cellspacing=\"0\" align=\"center\" summary=\"page�w��\">";
		$content .= "<TR><TD valign=\"top\"><SMALL>";
		$content .= "�y�[�W�w��F";
		$content .= "</SMALL></TD><TD><SMALL>";
		$num = 1;	# �y�[�W�J�E���g
		$numc = 0;	# ���s�̂��߂̃J�E���g
		while ($num <= $num_pag) {
			if ($num < 10) { $num = "0" . "$num"; }
			if ($page == $num) {
				# ���݃y�[�W��ԐF�ŕ\��
				$content .= "<FONT color=\"$new_clr\">$num</FONT>\n";
			} else {
				# �ʂ̃y�[�W�������N
				$content .= "<A href=\"$script?mode=tree\&amp;page=$num\">$num</A>\n";
			}
			# 10�y�[�W���ƂɃJ�E���g����B
			if ($num =~ /0$/) { $numc++; }
			# 20�y�[�W���Ƃɉ��s������
			if ($numc == 2) { $numc = 0; $content .= "<BR>\n"; }
			$num++;
		}
		$content .= "</SMALL></TD></TR></TABLE>\n";
	}

	# ���[�U�폜�g�̕\��
	$content .= "<div align=\"center\">\n";
	$content .= "<FORM action=\"$script\" method=\"$method\"><SMALL>\n";
	$content .= "<INPUT type=\"hidden\" name=\"func\" value=\"user_delete\">\n";
	$content .= "���[�U�폜�F�e������͂��č폜�������Ă��������B<BR>\n";
	$content .= "�L���ԍ��F<INPUT name=\"num\" size=\"4\" value=\"\">\n";
	$content .= "�p�X���[�h�F<INPUT type=\"password\" name=\"dpas\" size=\"10\" value=\"\">\n";
	$content .= "<INPUT type=\"submit\" value=\"�폜\">\n";
	$content .= "<INPUT type=\"reset\" value=\"���\">\n";
	$content .= "</SMALL></form></div>\n";

	# �t�b�^�[�o��
	&footer;
}

#------------------------------------------------------------------------------
# �ꊇ�\���iPC�j
#------------------------------------------------------------------------------
sub pc_all {
	# ���O�t�@�C�����I�[�v������
	open (IN,"$logfile") || &error (open_er);
	@line = <IN>;
	close(IN);

	# �w�b�_�[�o��
	$headtype = 0;
	&header;

	# ���Ԃ̎擾
	&get_time;

	# �^�C�g���\��
	if ($pc_img) {
		$content .= "<div align=\"center\"> <img src=\"$pc_img\"></div><BR>\n";
		$content .= "<div align=\"center\"> ���ׂĕ\\��</div><BR>\n";
	} else {
		$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"1\" width=\"100%\">\n";
		$content .= "<TR><TH bgcolor=\"$tf_clr\">\n";
		$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"2\" width=\"100%\">\n";
		$content .= "<TR><TH bgcolor=\"$tb_clr\">\n";
		$content .= "<FONT color=$ti_clr>$pc_title�|���ׂĕ\\��</FONT>\n";
		$content .= "</TH></TR>\n</TABLE>\n";
		$content .= "</TH></TR>\n</TABLE><BR>\n";
	}

	# �@�\�o�[�\��
	&topmenu;

	# ����\��
	$content .= "<div align=\"center\"> �P�y�[�W�ɍő�$max_view���̃c���[��\\�����܂��B</div>\n";
	$content .= "<div align=\"center\"> $new_time���Ԉȓ��̏����݂ɂ�<FONT color=\"$new_clr\">NEW</FONT>�}�[�N��\\�����܂��B</div>\n";

	# �g�̐ݒ�i���x�������̂��ʓ|�������̂Łj
	$s_tab = "<BR>\n";
	$s_tab .= "<TABLE border=\"0\" cellpadding=\"1\" cellspacing=\"0\" width=\"80%\" align=\"center\">\n";
	$s_tab .= "<TR><TD bgcolor=\"$tf_clr\">\n";
	$s_tab .= "<TABLE border=\"0\" cellpadding=\"10\" cellspacing=\"0\" width=\"100%\">\n";
	$s_tab .= "<TR><TD bgcolor=\"$tg_clr\">\n";
	$s_tab .= "<TABLE border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">\n";
	$e_tab = "</TABLE>\n</TD></TR>\n</TABLE>\n</TD></TR>\n</TABLE>\n";

	# �ϐ��̏����ݒ�
	$count   = shift(@line);	# ���O�J�E���g�𕪗�
	$num     = 0;				# �L����
	$num_max = @line;			# ���[�L����
	$num_t   = 0;				# �c���[�̃J�E���g
	$page    = $in{'page'};		# �y�[�W�w��
	$num_pag = 1;				# �y�[�W�̃J�E���g

	# �y�[�W�w��̂Ȃ��ꍇ�͎n�߂̃y�[�W�ɂ���B
	if ($page eq "") { $page = 1; }

	while ($num < $num_max) {
		# �e�s�𕪊����A�z��Ɋi�[
		@column = split(/<>/,$line[$num]);

		if ($column[0] == $column[1]) {
			if ($num_t == $max_view) {
				$num_t = 0;
				$num_pag++;
			}
			$num_t++;
		}

		if ($num_pag == $page) {
			if ($column[0] == $column[1]) {
				# �g�̕\���i�I���j
				if ($num_t != 0) { $content .= "$e_tab"; }

				# �g�̕\���i�n�߁j
				$content .= "$s_tab";
			}

			# �d�ؐ�
			if ($column[0] != $column[1]) {
				$content .= "<TR><TD bgcolor=\"$tg_clr\" colspan=\"2\">\n";
				$content .= "<HR size=\"1\" width=\"95%\">\n";
				$content .= "</TD></TR>\n";
			}

			# ���s�̎n��
			$content .= "<TR><TD bgcolor=\"$tg_clr\">\n";

			# ���eNo.�̕\��
			$content .= "No.$column[0]\n";

			# �\��̕\��
			$content .= "<FONT color=\"$dai_clr\">$column[5]</FONT>\n";

			# ���O�̕\��
			$content .= "<strong>$column[4]\n";
			
			if ($column[15] ne '') {
				$content .= " ��</strong>$column[15]\n";
			} else {
				$content .= "</strong>\n";
			}

			# ���[���A�h���X�̕\��
			if ($column[7] ne '') {
				$content .= "<A href=\"mailto\:$column[7]\">";
				if ($pc_mimg) {
					$content .= "<img border=\"0\" src=\"$pc_mimg\" alt=\"MAIL\">";
				} else {
					$content .= "[mail]\n";
				}
				$content .= "</A>\n";
			}

			# �z�[���y�[�W�̕\��
			if ($column[8] ne '') {
				if ($autolink) { &autolink( $column[8] ); }
				$content .= "$column[8]\n"; 
			}

			# �[���̕\��
			$content .= "<SMALL>[$column[9]]</SMALL>\n";

			# �������ݓ����̕\��
			$content .= "<SMALL>$column[2] $column[3]</SMALL>\n";

			# NEW�}�[�N�̕\��
			if (($times - $column[13]) < $new_time * 3600) {
				$content .= "<FONT color=\"$new_clr\">NEW</FONT>\n";
			}

			# �ԐM
			if ($column[0] == $column[1] && $column[16] ne "1"){
				$content .= "<A href=\"$script?mode=form&amp;res=$column[0]\">�ԐM</A>\n";
			}

			# ���s�̏I���
			$content .= "</TD></TR>\n";

			# �R�����g�̕\��
			if ($autolink) { &autolink( $column[6] ); }
			$content .= "<TR><TD bgcolor=\"$tg_clr\">\n";
			$content .= "<BLOCKQUOTE>\n$column[6]\n</BLOCKQUOTE>\n";
			$content .= "</TD></TR>\n";
		}
		$num++;
	}

	# �L�����Ȃ��ꍇ�̏���
	if ($num == 0) {
		$content .= "$s_tab";
		$content .= "<TR><TD bgcolor=\"$tg_clr\">\n";
		$content .= "<BLOCKQUOTE>���e�L���͗L��܂���</BLOCKQUOTE>\n";
		$content .= "</TD></TR>\n";
	}

	# �g�̕\���i�I���j
	$content .= "$e_tab";

	# �y�[�W�\��
	if ($num_pag != 1) {
		$content .= "<BR><TABLE border=\"0\" cellpadding=\"0\" cellspacing=\"0\" align=\"center\">";
		$content .= "<TR><TD valign=\"top\"><SMALL>";
		$content .= "�y�[�W�w��F";
		$content .= "</SMALL></TD><TD><SMALL>";
		$num = 1;	# �y�[�W�J�E���g
		$numc = 0;	# ���s�̂��߂̃J�E���g
		while ($num <= $num_pag) {
			if ($num < 10) { $num = "0" . "$num"; }
			if ($page == $num) {
				# ���݃y�[�W��ԐF�ŕ\��
				$content .= "<FONT color=\"$new_clr\">$num</FONT>\n";
			} else {
				# �ʂ̃y�[�W�������N
				$content .= "<A href=\"$script?mode=all\&amp;page=$num\">$num</A>\n";
			}
			# 10�y�[�W���ƂɃJ�E���g����B
			if ($num =~ /0$/) { $numc++; }
			# 20�y�[�W���Ƃɉ��s������
			if ($numc == 2) { $numc = 0; $content .= "<BR>\n"; }
			$num++;
		}
		$content .= "</SMALL></TD></TR></TABLE>\n";
	}

	# ���[�U�폜�g�̕\��
	$content .= "<div align=\"center\"> <SMALL>\n";
	$content .= "<FORM action=\"$script\" method=\"$method\">\n";
	$content .= "<INPUT type=\"hidden\" name=\"func\" value=\"user_delete\">\n";
	$content .= "���[�U�폜�F�e������͂��č폜�������Ă��������B<BR>\n";
	$content .= "�L���ԍ��F<INPUT name=\"num\" size=\"4\">\n";
	$content .= "�p�X���[�h�F<INPUT type=\"password\" name=\"dpas\" size=\"10\">\n";
	$content .= "<INPUT type=\"submit\" value=\"�폜\">\n";
	$content .= "<INPUT type=\"reset\" value=\"���\">\n";
	$content .= "</SMALL></div>\n";

	# �t�b�^�[�o��
	&footer;
}


#------------------------------------------------------------------------------
# �X�p���h�~�������i�K���iPC�j
#------------------------------------------------------------------------------

sub wkeychk{
	unless ($in{'wkey'} eq $wkey){
	&error(wkey_er);
	}
}


#------------------------------------------------------------------------------
# �f�o�C�X���X�V�������ʕ\��(PC)
#------------------------------------------------------------------------------
# 08.02.15 �V�K�쐬
sub updateResult{
	# �w�b�_�[�o��
	$headtype = 0;
	&header;

		
	# �^�C�g���\��
	if ($pc_img) {
		$content .= "<div align=\"center\"> <img src=\"$pc_img\"></div><BR>\n";
		$content .= "<div align=\"center\"> �f�o�C�X���X�V����</div><BR>\n";
	} else {
		$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"1\" width=\"100%\">\n";
		$content .= "<TR><TH bgcolor=\"$tf_clr\">\n";
		$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"2\" width=\"100%\">\n";
		$content .= "<TR><TH bgcolor=\"$tb_clr\">\n";
		$content .= "<FONT color=$ti_clr>$pc_title�|�f�o�C�X���X�V����</FONT>\n";
		$content .= "</TH></TR>\n</TABLE>\n";
		$content .= "</TH></TR>\n</TABLE><BR>\n";
	}

	if($deviceUpdateFlag){
		# ������
		$content .= "<BR>\n";
		$content .= "<TABLE border=\"0\" cellpadding=\"1\" cellspacing=\"0\" width=\"80%\" align=\"center\">\n";
		$content .= "<TR><TD bgcolor=\"$tf_clr\">\n";
		$content .= "<TABLE border=\"0\" cellpadding=\"10\" cellspacing=\"0\" width=\"100%\">\n";
		$content .= "<TR><TD bgcolor=\"$tg_clr\">\n";
		$content .= "<TABLE border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">\n";
		$content .= "<TR><TD bgcolor=\"$tg_clr\">\n";
		$content .= "<BLOCKQUOTE>�ŐV�f�[�^�ɍX�V���܂����B</BLOCKQUOTE>\n";
		$content .= "</TD></TR>\n";
		$content .= "</TABLE>\n</TD></TR>\n</TABLE>\n</TD></TR>\n</TABLE>\n";

	} else {
		# ���łɍŐV�ł̎�
		$content .= "<BR>\n";
		$content .= "<TABLE border=\"0\" cellpadding=\"1\" cellspacing=\"0\" width=\"80%\" align=\"center\">\n";
		$content .= "<TR><TD bgcolor=\"$tf_clr\">\n";
		$content .= "<TABLE border=\"0\" cellpadding=\"10\" cellspacing=\"0\" width=\"100%\">\n";
		$content .= "<TR><TD bgcolor=\"$tg_clr\">\n";
		$content .= "<TABLE border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">\n";
		$content .= "<TR><TD bgcolor=\"$tg_clr\">\n";
		$content .= "<BLOCKQUOTE>���łɍŐV�f�[�^�ł��B</BLOCKQUOTE>\n";
		$content .= "</TD></TR>\n";
		$content .= "</TABLE>\n</TD></TR>\n</TABLE>\n</TD></TR>\n</TABLE>\n";

	}

	# �t�b�^�[�o��
	&footer;

}


1;
