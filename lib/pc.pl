$pcver = "1.03";
# 検索結果から直接レスフォームにいけるように改良
#------------------------------------------------------------------------------
# 投稿フォーム（PC）
#------------------------------------------------------------------------------
sub pc_form {
	# ヘッダー出力
	$headtype = 0;
	&header;

	# タイトル表示
	if ($pc_img) {
		$content .= "<div align=\"center\"> <img src=\"$pc_img\"></div><br>\n";
		$content .= "<div align=\"center\"> 投稿フォーム</div><br>\n";
	} else {
		$content .= "<table border=\"0\" cellspacing=\"0\" cellpadding=\"1\" width=\"100\%\">\n";
		$content .= "<tr><th bgcolor=\"$tf_clr\">\n";
		$content .= "<table border=\"0\" cellspacing=\"0\" cellpadding=\"2\" width=\"100\%\">\n";
		$content .= "<tr><th bgcolor=\"$tb_clr\">\n";
		$content .= "<font color=\"$ti_clr\">$pc_title－投稿フォーム</font>\n";
		$content .= "</th></tr>\n</table>\n";
		$content .= "</th></tr>\n</table><br>\n";
	}

	# 機能バー表示
	&topmenu;

	if((!$in{'res'}) &&(!$in{'edno'})){
		# 新規書込み
		$content .= "<BR>\n";
		$content .= "<div align=\"center\"> 新規書込み</div>\n";
		if($UseWKeyChk){
			$content .= "<div align=\"center\"> 書き込みキーワードは『$wkey』です。</div>\n";
		}
		$content .= "<div align=\"center\"> 広告書き込みお断り</div>\n";
		$content .= "<BR>\n";
	}elsif($in{'edno'}){
		# 編集フォーム
		$content .= "<BR>\n";
		$content .= "<div align=\"center\"> 記事の編集</div>\n";
		$content .= "<BR>\n";
		
	}else{
		# レス元の文章を表示
		open (IN,"$logfile") || &error (open_er);
		@line = <IN>;
		close(IN);
		
		$count   = shift(@line);
		$num     = 0;		# 記事数
		$num_max = $#line;	# 最大記事数
		$res_dai = "";		# レス記事の題名

		# 枠の表示
		$content .= "<BR>\n";
		if($UseWKeyChk){
			$content .= "<div align=\"center\"> 書き込みキーワードは『$wkey』です。</div>\n";
		}
		$content .= "<div align=\"center\"> 以下のツリーに返信</div>\n";
		$content .= "<BR>\n";
		$content .= "<TABLE border=\"0\" cellpadding=\"1\" cellspacing=\"0\" width=\"80%\" align=\"center\">\n";
		$content .= "<TR><TD bgcolor=\"$tf_clr\">\n";
		$content .= "<TABLE border=\"0\" cellpadding=\"10\" cellspacing=\"0\" width=\"100%\">\n";
		$content .= "<TR><TD bgcolor=\"$tg_clr\">\n";
		$content .= "<TABLE border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">\n";

		while ($num <= $num_max) {
			# 各行を分割し、配列に格納
			@column = split(/<>/,$line[$num]);

			# レス記事を検索／表示
			if($column[1] == $in{'res'}) {
				# 仕切線
				if ($column[0] != $column[1]) {
					$content .= "<TR><TD bgcolor=\"$tg_clr\" colspan=\"2\">\n";
					$content .= "<HR size=\"1\" width=\"95%\">\n";
					$content .= "</TD></TR>\n";
				}

				if ($column[0] == $column[1]) {
					$res_dai = "RE:$column[5]";
				}

				# 情報行の始め
				$content .= "<TR><TD bgcolor=\"$tg_clr\">\n";

				# 記事番号の表示
				$content .= "No.$column[0]\n";

				# 表題の表示
				$content .= "<FONT color=\"$dai_clr\">$column[5]</FONT>\n";

				# 名前の表示
				$content .= "<strong>$column[4]</strong>\n";

				# メールアドレスの表示
				if ($column[7] ne '') {
					$content .= "<a href=\"mailto\:$column[7]\">";
					if ($pc_mimg) {
						$content .= "<img border=\"0\" src=\"$pc_mimg\" alt=\"MAIL\">";
					} else {
						$content .= "[mail]\n";
					}
					$content .= "</A>\n";
				}

				# ホームページの表示
				if ($column[8] ne ''){
					if ($autolink) { &autolink( $column[8] ); }
					$content .= "$column[8]\n"; 
				}

				# 端末の表示
				$content .= "<SMALL>[$column[9]]</SMALL>\n";

				# 書きこみ日時の表示
				$content .= "<SMALL>$column[2] $column[3]</SMALL>\n";

				# 情報行の終わり
				$content .= "</TD></TR>\n";

				# コメントの表示
				if ($autolink) { &autolink( $column[6] ); }
				$content .= "<TR><TD bgcolor=\"$tg_clr\">\n";
				$content .= "<BLOCKQUOTE>\n$column[6]\n</BLOCKQUOTE>\n";
				$content .= "</TD></TR>\n";

			}
			$num++;
		}
		# 枠の表示（終わり）
		$content .= "</TABLE>\n</TD></TR>\n</TABLE>\n</TD></TR>\n</TABLE>\n";
	}

	
	if($in{'edno'}){
		$edit = $in{'edno'};

		# 記事読み出し処理
		# ファイルのオープン
		open (IN, $logfile) || &error("ファイル｢$file｣が開けません");
		@line = <IN>;
		close(IN);
		
		foreach (@line) {
			if ($_ !~ /$edit/) { next; }
				@line = split(/<>/,$line[$num]);
			last;
		}

		if ($ed_new eq $ed_dres) { &error("親記事の編集はできません") };
		
		$c_name = "$column[4]";
		$c_dai = "$column[5]";
		$c_mail = "$column[7]";
		$c_url = "$column[8]";
		$c_msg = "$column[6]";
			
		
	}
	# クッキーの取得
	elsif ($use_cookie) { &get_cookie; }

	# フォームタグ
	$content .= "<FORM action=\"$script\" method=\"$method\">\n";
	$content .= "<INPUT type=\"hidden\" name=\"mode\" value=\"write\">\n";
	$content .= "<INPUT type=\"hidden\" name=\"res\" value=\"$in{'res'}\">\n";

	# テーブルの指定
	$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"1\" align=\"center\">\n";
	$content .= "<TR bgcolor=\"$tf_clr\"><TD>\n";
	$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"10\" align=\"center\">\n";
	$content .= "<TR bgcolor=\"$tg_clr\"><TD>\n";
	$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"1\" align=\"center\">\n";

	# 名前入力
	$content .= "<TR bgcolor=\"$tg_clr\">\n";
	$content .= "<TD>\n";
	$content .= "<strong>お名前</strong>　<INPUT name=\"name\" size=\"15\" value=\"$c_name\">";
	if($UseWKeyChk){
		$content .= "<strong>keyword</strong>　<INPUT name=\"wkey\" size=\"15\" value=\"はずれ\">";
	}
	$content .= "　<SMALL>必須</SMALL>\n";
	$content .= "</TD>\n";
	$content .= "</TR>\n";

	# 題名入力
	$content .= "<TR bgcolor=\"$tg_clr\">\n";
	$content .= "<TD>\n";
	$content .= "<strong>題　名</strong>　<INPUT name=\"dai\" size=\"25\" value=\"$res_dai\" value=\"$c_dai\">";
	$content .= "　<SMALL>必須</SMALL>\n";
	$content .= "</TD>\n";
	$content .= "</TR>\n";

	# メールアドレス入力
	$content .= "<TR bgcolor=$tg_clr>\n";
	$content .= "<TD>\n";
	$content .= "<strong>メール</strong>　<INPUT name=\"mail\" size=\"25\" value=\"$c_mail\">\n";
	$content .= "</TD>\n";
	$content .= "</TR>\n";

	# ホームページアドレス入力
	$content .= "<TR bgcolor=\"$tg_clr\">\n";
	$content .= "<TD>\n";
	$content .= "<strong>ＵＲＬ</strong>　<INPUT name=\"url\" size=\"40\" value=\"http://$c_url\">\n";
	$content .= "</TD>\n";
	$content .= "</TR>\n";

	# メッセージ入力
	$content .= "<TR bgcolor=\"$tg_clr\">\n";
	$content .= "<TD><strong>メッセージ</strong></TD>\n";
	$content .= "</TR>\n";
	$content .= "<TR bgcolor=\"$tg_clr\">\n";
	$content .= "<TD><TEXTAREA name=\"msg\" COLS=\"50\" ROWS=\"6\" value=\"$c_msg\"></TEXTAREA></TD>\n";
	$content .= "</TR>\n";

	# 投稿／取消ボタン
	$content .= "<TR bgcolor=\"$tg_clr\"><TD>\n";
	$content .= "<SMALL>削除パスワード</SMALL>\n";
	$content .= "<INPUT type=\"password\" name=\"dpas\" size=\"10\" value=\"$c_dpas\">\n";
	$content .= "<INPUT type=\"submit\" value=\"投稿\">\n";
	$content .= "<INPUT type=\"reset\" value=\"取消\">\n";
	$content .= "</TD></TR>\n";

	# テーブルの指定（終わり）
	$content .= "</TABLE>\n";
	$content .= "</TD></TR>\n";
	$content .= "</TABLE>\n";
	$content .= "</TD></TR>\n";
	$content .= "</TABLE>\n";

	# フォームタグ（終わり）
	$content .= "</FORM>\n";

	# 注意書き
	$content .= "<div align=\"center\"> \n";
	$content .= "他の端末でも見るため、コンパクトに記入しましょう！\n";
	$content .= "</div>\n";

	# フッター出力
	&footer;
}

#------------------------------------------------------------------------------
# 投稿確認（PC）
#------------------------------------------------------------------------------
sub pc_write {
	# ヘッダー出力
	$headtype = 0;
	&header;

	# タイトル表示
	if ($pc_img) {
		$content .= "<div align=\"center\"> <img src=\"$pc_img\"></div><BR>\n";
		$content .= "<div align=\"center\"> 書き込み完了</div><BR>\n";
	} else {
		$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"1\" width=\"100\%\">\n";
		$content .= "<TR><TH bgcolor=\"$tf_clr\">\n";
		$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"2\" width=\"100\%\">\n";
		$content .= "<TR><TH bgcolor=\"$tb_clr\">\n";
		$content .= "<FONT color=\"$ti_clr\">$pc_title－書きこみ完了</FONT>\n";
		$content .= "</TH></TR>\n</TABLE>\n";
		$content .= "</TH></TR>\n</TABLE><BR>\n";
	}

	# メッセージ
	$content .= "<BR>\n";
	if ($new == $res) {
		$content .= "<div align=\"center\"> 以下のメッセージを新規に投稿しました</div>\n";
	} else {
		$content .= "<div align=\"center\"> 以下のメッセージをレスしました</div>\n";
	}
	$content .= "<BR>\n";

	# 枠の表示
	$content .= "<TABLE border=\"0\" cellpadding=\"1\" cellspacing=\"0\" width=\"80%\" align=\"center\">\n";
	$content .= "<TR><TD bgcolor=\"$tf_clr\">\n";
	$content .= "<TABLE border=\"0\" cellpadding=\"10\" cellspacing=\"0\" width=\"100%\">\n";
	$content .= "<TR><TD bgcolor=\"$tg_clr\">\n";
	$content .= "<TABLE border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">\n";

	# 情報行の始め
	$content .= "<TR><TD bgcolor=\"$tg_clr\">\n";

	# 記事番号の表示
	$content .= "No.$new\n";

	# 表題の表示
	$content .= "<FONT color=\"$dai_clr\">$dai</FONT>\n";

	# 名前の表示
	$content .= "<strong>$name\n";
	
	if ($trip ne '') {
		$content .= " ◆</strong>$trip\n";
	} else {
		$content .= "</strong>\n";
	}
	
	# メールアドレスの表示
	if ($in{'mail'} ne '') {
		$content .= "<A href=\"mailto\:$in{'mail'}\">";
		if ($pc_mimg) {
			$content .= "<img border=\"0\" src=\"$pc_mimg\" alt=\"MAIL\">";
		} else {
			$content .= "[mail]";
		}
		$content .= "</A>\n";
	}

	# ホームページの表示
	if ($in{'url'} ne ''){
		if ($autolink) { &autolink( $in{'url'} ); }
		$content .= "$in{'url'}\n"; 
	}

	# 端末の表示
	$content .= "<SMALL>[$agent_name]</SMALL>\n";

	# 書きこみ日時の表示
	$content .= "<SMALL>($date $time)</SMALL>\n";

	# 情報行の終わり
	$content .= "</TD></TR>\n";

	# コメントの表示
	$msg =~ s/\n/<BR>/g;
	if ($autolink) { &autolink( $msg ); }
	$content .= "<TR><TD bgcolor=\"$tg_clr\">\n";
	$content .= "<BLOCKQUOTE>\n$msg\n</BLOCKQUOTE>\n";
	$content .= "</TD></TR>\n";

	# 枠の終わり
	$content .= "</TABLE>\n</TD></TR>\n</TABLE>\n</TD></TR>\n</TABLE>\n";

	# 戻る
	$content .= "<BR><div align=\"center\"> <A href=\"$script\">戻る</A></div>\n";

	# フッター出力
	&footer;
}

#------------------------------------------------------------------------------
# 検索フォーム（PC）
#------------------------------------------------------------------------------
sub pc_sform {
	# ヘッダー出力
	$headtype = 0;
	&header;

	# タイトル表示
	if ($pc_img) {
		$content .= "<div align=\"center\"> <img src=\"$pc_img\"></div><BR>\n";
		$content .= "<div align=\"center\"> 検索フォーム</div><BR>\n";
	} else {
		$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"1\" width=\"100%\">\n";
		$content .= "<TR><TH bgcolor=\"$tf_clr\">\n";
		$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"2\" width=\"100%\">\n";
		$content .= "<TR><TH bgcolor=\"$tb_clr\">\n";
		$content .= "<FONT color=\"$ti_clr\">$pc_title－検索フォーム</FONT>\n";
		$content .= "</TH></TR>\n</TABLE>\n";
		$content .= "</TH></TR>\n</TABLE><BR>\n";
	}

	# 機能バー表示
	&topmenu;

	# 検索機能説明
	$content .= "<BR>\n";
	$content .= "<div align=\"center\"> \n";
	$content .= "検索文字列を入力し、検索ボタンを押してください。<BR>\n";
	$content .= "文字列は半角スペースで区切って入力して下さい。　<BR>\n";
	$content .= "</div>\n";
	$content .= "<BR>\n";

	# フォームタグ
	$content .= "<FORM action=\"$script\" method=\"$method\">\n";
	$content .= "<INPUT type=\"hidden\" name=\"mode\" value=\"seek\">\n";

	# テーブルの指定
	$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"1\" align=\"center\">\n";
	$content .= "<TR bgcolor=\"$tf_clr\"><TD>\n";
	$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"10\" align=\"center\">\n";
	$content .= "<TR bgcolor=\"$tg_clr\"><TD>\n";
	$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"1\" align=\"center\">\n";

	# 検索条件
	$content .= "<TR bgcolor=\"$tg_clr\">\n";
	$content .= "<TD colspan=\"2\"><strong>検索条件：</strong></TD>\n";
	$content .= "</TR>\n";

	# ANDチェック
	$content .= "<TR bgcolor=\"$tg_clr\">\n";
	$content .= "<TD>\n";
	$content .= "<INPUT type=\"radio\" name=\"cond\" value=\"and\" checked>　<strong>AND検索</strong>\n";
	$content .= "</TD>\n";
	$content .= "</TR>\n";

	# ORチェック
	$content .= "<TR bgcolor=\"$tg_clr\">\n";
	$content .= "<TD>\n";
	$content .= "<INPUT type=\"radio\" name=\"cond\" value=\"or\">　<strong>OR検索</strong>\n";
	$content .= "</TD>\n";
	$content .= "</TR>\n";

	# 仕切り線
	$content .= "<TR bgcolor=\"$tg_clr\">\n";
	$content .= "<TD><HR size=\"1\"></TD>\n";
	$content .= "</TR>\n";

	# 検索文字列
	$content .= "<TR bgcolor=\"$tg_clr\">\n";
	$content .= "<TD><strong>検索文字列：</strong></TD>\n";
	$content .= "</TR>\n";

	# 検索文字列入力
	$content .= "<TR bgcolor=\"$tg_clr\">\n";
	$content .= "<TD><INPUT name=\"string\" size=\"40\"></TD>\n";
	$content .= "</TR>\n";

	# 検索／取消ボタン
	$content .= "<TR bgcolor=\"$tg_clr\"><TH>\n";
	$content .= "<INPUT type=\"submit\" value=\"検索\">\n";
	$content .= "<INPUT type=\"reset\" value=\"取消\">\n";
	$content .= "</TH></TR>\n";

	# テーブルの指定（終わり）
	$content .= "</TABLE>\n";
	$content .= "</TD></TR>\n";
	$content .= "</TABLE>\n";
	$content .= "</TD></TR>\n";
	$content .= "</TABLE>\n";

	# フォームタグ（終わり）
	$content .= "</FORM>\n";

	# フッター出力
	&footer;
}
#------------------------------------------------------------------------------
# 検索結果表示（PC）
#------------------------------------------------------------------------------
sub pc_sview {
	# ヘッダー出力
	$headtype = 0;
	&header;

	# 時間の取得
	&get_time;

	# タイトル表示
	if ($pc_img) {
		$content .= "<div align=\"center\"> <img src=\"$pc_img\"></div><BR>\n";
		$content .= "<div align=\"center\"> 検索結果</div><BR>\n";
	} else {
		$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"1\" width=\"100\%\">\n";
		$content .= "<TR><TH bgcolor=\"$tf_clr\">\n";
		$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"2\" width=\"100\%\">\n";
		$content .= "<TR><TH bgcolor=\"$tb_clr\">\n";
		$content .= "<FONT color=\"$ti_clr\">$pc_title－検索結果</FONT>\n";
		$content .= "</TH></TR>\n</TABLE>\n";
		$content .= "</TH></TR>\n</TABLE><BR>\n";
	}

	# 機能バー表示
	&topmenu;

	# 枠の設定（何度も書くのが面倒くさいので）
	$s_tab = "<BR>\n";
	$s_tab .= "<TABLE border=\"0\" cellpadding=\"1\" cellspacing=\"0\" width=\"80%\" align=\"center\">\n";
	$s_tab .= "<TR><TD bgcolor=\"$tf_clr\">\n";
	$s_tab .= "<TABLE border=\"0\" cellpadding=\"10\" cellspacing=\"0\" width=\"100%\">\n";
	$s_tab .= "<TR><TD bgcolor=\"$tg_clr\">\n";
	$s_tab .= "<TABLE border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">\n";
	$e_tab = "</TABLE>\n</TD></TR>\n</TABLE>\n</TD></TR>\n</TABLE>\n";

	# 変数の初期設定
	$num     = 0;			# 記事数
	$num_max = $#new +1;	# 投票記事数

	# 解説表示
	$content .= "<div align=\"center\"> 検索の結果 $num_max 件のメッセージが条件に一致しました。</div>\n";
	$content .= "<div align=\"center\"> <FONT color=\"$li_clr\">詳細</FONT>を選択すると記事のあるツリーを閲覧できます。</div>\n";
	$content .= "<div align=\"center\"> $new_time時間以内の書込みには<FONT color=\"$new_clr\">NEW</FONT>マークを表\示します。</div>\n";

	# 検索条件の表示
	$content .= "$s_tab";
	$content .= "<TR><TD><strong>検索条件</strong></TD></TR>\n";
	$content .= "<TR><TD><BLOCKQUOTE>\n";
	foreach $str (@string) {
		$content .= "$str ";
	}
	$content .= "</BLOCKQUOTE></TD></TR>\n";
	$content .= "$e_tab";

	while ($num < $num_max) {
		# 各行を分割し、配列に格納
		@column = split(/<>/,$new[$num]);

		# テーブル始め
		$content .= "$s_tab";

		# 情報行の始め
		$content .= "<TR><TD bgcolor=\"$tg_clr\">\n";

		# 投稿No.の表示
		$content .= "No.$column[0]\n";

		# 表題の表示
		$content .= "<FONT color=\"$dai_clr\">$column[5]</FONT>\n";

		# 名前の表示
		$content .= "<strong>$column[4]\n";
		
		if ($column[15] ne '') {
			$content .= " ◆</strong>$column[15]\n";
		} else {
			$content .= "</strong>\n";
		}

		# メールアドレスの表示
		if ($column[7] ne '') {
			$content .= "<A href=\"mailto\:$column[7]\">";
			if ($pc_mimg) {
				$content .= "<img border=\"0\" src=\"$pc_mimg\" alt=\"MAIL\">";
			} else {
				$content .= "[mai　l]\n";
			}
			$content .= "</A>\n";
		}

		# ホームページの表示
		if (($column[8] ne '') && ($column[9] == 0)){
			if ($autolink) { &autolink( $column[8] ); }
			$content .= "$column[8]\n"; 
		}

		# 端末の表示
		$content .= "<SMALL>[$column[9]]</SMALL>\n";

		# 書きこみ日時の表示
		$content .= "<SMALL>$column[2] $column[3]</SMALL>\n";

		# NEWマークの表示
		if (($times - $column[13]) < $new_time * 3600) {
			$content .= "<FONT color=\"$new_clr\">NEW</FONT>\n";
		}

		# ツリーを表示するリンクの表示
		if ($column[16] ne "1") {
			$content .= "<A href=\"$script?mode=form&amp;res=$column[1]\">返信</A>\n";
		} else {
			$content .= "<A href=\"$script?mode=view&amp;tree=$column[1]\">詳細</A>\n";
		}

		# 情報行の終わり
		$content .= "</TD></TR>\n";

		# コメントの表示
		if ($autolink) { &autolink( $column[6] ); }
		$content .= "<TR><TD bgcolor=\"$tg_clr\">\n";
		$content .= "<BLOCKQUOTE>\n$column[6]\n</BLOCKQUOTE>\n";
		$content .= "</TD></TR>\n";

		# テーブル終わり
		$content .= "$e_tab";

		$num++;
	}

	# 記事がない場合の処理
	if ($num == 0) {
		$content .= "$s_tab";
		$content .= "<TR><TD bgcolor=\"$tg_clr\">\n";
		$content .= "<BLOCKQUOTE>検索条件に一致するメッセージはありませんでした。</BLOCKQUOTE>\n";
		$content .= "</TD></TR>\n";
		$content .= "$e_tab";
	}

	# ユーザ削除枠の表示
	$content .= "<div align=\"center\"> <SMALL>\n";
	$content .= "<FORM action=\"$script\" method=\"$method\">\n";
	$content .= "<INPUT type=\"hidden\" name=\"func\" value=\"user_delete\">\n";
	$content .= "ユーザ削除：各項を入力して削除を押してください。<BR>\n";
	$content .= "記事番号：<INPUT name=\"num\" size=\"4\">\n";
	$content .= "パスワード：<INPUT type=\"password\" name=\"dpas\" size=\"10\">\n";
	$content .= "<INPUT type=\"submit\" value=\"削除\">\n";
	$content .= "<INPUT type=\"reset\" value=\"取消\">\n";
	$content .= "</SMALL></div>\n";

	# フッター出力
	&footer;
}

#------------------------------------------------------------------------------
# パスワード入力フォーム（PC）
#------------------------------------------------------------------------------
sub passform {
	# ヘッダー出力
	$headtype = 0;
	&header;

	# タイトル表示
	if ($pc_img) {
		$content .= "<div align=\"center\"> <img src=\"$pc_img\"></div><BR>\n";
		$content .= "<div align=\"center\"> パスワード入力フォーム</div><BR>\n";
	} else {
		$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"1\" width=\"100\%\">\n";
		$content .= "<TR><TH bgcolor=\"$tf_clr\">\n";
		$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"2\" width=\"100\%\">\n";
		$content .= "<TR><TH bgcolor=\"$tb_clr\">\n";
		$content .= "<FONT color=\"$ti_clr\">$pc_title－パスワード入力フォーム</FONT>\n";
		$content .= "</TH></TR>\n</TABLE>\n";
		$content .= "</TH></TR>\n</TABLE><BR>\n";
	}

	# 入力テーブル
	$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"0\" width=\"100%\" height=\"50%\">\n";
	$content .= "<TR><TD align=\"center\" valign=\"center\"><div align=\"center\"> \n";
	$content .= "パスワードを入力し、決定ボタンを押してください。<BR>\n";
	# フォームタグ
	$content .= "<FORM action=\"$script\" method=\"$method\">\n";
	$content .= "<INPUT type=\"hidden\" name=\"mode\" value=\"admin\">\n";
	$content .= "<INPUT type=\"hidden\" name=\"func\" value=\"check\">\n";
	$content .= "<INPUT type=\"password\" name=\"psw\" size=\"20\">\n";
	$content .= "<INPUT type=\"submit\" value=\"決定\">\n";
	$content .= "<INPUT type=\"reset\" value=\"取消\">\n";
	$content .= "</FORM>\n";
	$content .= "</TD></TR>\n";
	$content .= "</TABLE>\n";

	# フッター出力
	&footer;
}


#------------------------------------------------------------------------------
# 管理フォーム（PC）
#------------------------------------------------------------------------------
sub admin {
	# ヘッダー出力
	$headtype = 0;
	&header;

	# タイトル表示
	if ($pc_img) {
		$content .= "<div align=\"center\"> <img src=\"$pc_img\"></div><BR>\n";
		$content .= "<div align=\"center\"> 管理フォーム</div><BR>\n";
	} else {
		$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"1\" width=\"100\%\">\n";
		$content .= "<TR><TH bgcolor=\"$tf_clr\">\n";
		$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"2\" width=\"100\%\">\n";
		$content .= "<TR><TH bgcolor=\"$tb_clr\">\n";
		$content .= "<FONT color=\"$ti_clr\">$pc_title－管理フォーム</FONT>\n";
		$content .= "</TH></TR>\n</TABLE>\n";
		$content .= "</TH></TR>\n</TABLE><BR>\n";
	}

	# 機能バー表示
	&topmenu;

	# コメント
	$content .= "<BR>\n";
	$content .= "<div align=\"center\"> 利用したい機\能\を選択して下さい。</div>\n";
	$content .= "<BR>\n";

	# テーブルの指定
	$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"1\" align=\"center\">\n";
	$content .= "<TR bgcolor=\"$tf_clr\"><TD>\n";
	$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"10\" align=\"center\">\n";
	$content .= "<TR bgcolor=\"$tg_clr\"><TD>\n";
	$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"1\" align=\"center\">\n";

	# 管理ファイルを開く
	open (IN,"$pswfile") || &error (open_er);
	@line = <IN>;
	close(IN);

	# デバイス情報更新処理　# 08.02.15 追加
	$content .= "<TR bgcolor=\"$tg_clr\">\n";
	$content .= "<TD colspan=\"3\">\n";
	$content .= "<STRONG>デバイス情報更新処理</STRONG>\n";
	$content .= "</TD>\n";
	$content .= "<TD>\n";
	$content .= "<FORM action=\"$script\" method=\"$method\">\n";
	$content .= "<INPUT type=\"hidden\" name=\"mode\" value=\"update\">\n";
#	$content .= "<INPUT type=\"hidden\" name=\"psw\" value=\"$in{'psw'}\">\n";
	$content .= "<INPUT type=\"submit\" value=\"選択\">\n";
	$content .= "</FORM>\n";
	$content .= "</TD>\n";
	$content .= "</TR>\n";

	# 記事削除処理表示
	$content .= "<TR bgcolor=\"$tg_clr\">\n";
	$content .= "<TD colspan=\"3\">\n";
	$content .= "<STRONG>記事削除処理</STRONG>\n";
	$content .= "</TD>\n";
	$content .= "<TD>\n";
	$content .= "<FORM action=\"$script\" method=\"$method\">\n";
	$content .= "<INPUT type=\"hidden\" name=\"mode\" value=\"dform\">\n";
#	$content .= "<INPUT type=\"hidden\" name=\"psw\" value=\"$in{'psw'}\">\n";
	$content .= "<INPUT type=\"submit\" value=\"選択\">\n";
	$content .= "</FORM>\n";
	$content .= "</TD>\n";
	$content .= "</TR>\n";

	# パスワード変更処理表示
	$content .= "<TR bgcolor=\"$tg_clr\">\n";
	$content .= "<TD colspan=\"4\">\n";
	$content .= "<STRONG>パスワード変更処理</STRONG>\n";
	$content .= "</TD>\n";
	$content .= "</TR>\n";

	# パスワード変更フォーム
	$content .= "<FORM action=\"$script\" method=\"$method\">\n";
	$content .= "<INPUT type=\"hidden\" name=\"mode\" value=\"admin\">\n";
	$content .= "<INPUT type=\"hidden\" name=\"func\" value=\"change\">\n";
#	$content .= "<INPUT type=\"hidden\" name=\"psw\" value=\"$in{'psw'}\">\n";
	$content .= "<TR bgcolor=\"$tg_clr\">\n";
	$content .= "<TD>　</TD>\n";
	$content .= "<TD>新暗号</TD>\n";
	$content .= "<TD><INPUT type=\"password\" name=\"pswa\" size=\"20\"></TD>\n";
	$content .= "<TD><INPUT type=\"reset\" value=\"取消\"></TD>\n";
	$content .= "</TR>\n";
	$content .= "<TR bgcolor=\"$tg_clr\">\n";
	$content .= "<TD>　</TD>\n";
	$content .= "<TD>確認用</TD>\n";
	$content .= "<TD><INPUT type=\"password\" name=\"pswb\" size=\"20\"></TD>\n";
	$content .= "<TD><INPUT type=\"submit\" value=\"変更\"></TD>\n";
	$content .= "</TR>\n";
	$content .= "</FORM>\n";

	@column = split(/<>/,$line[1]);
	$num = $#column;
	if ($num) {
		# 非適切語削除処理表示
		$content .= "<TR bgcolor=\"$tg_clr\">\n";
		$content .= "<TD colspan=\"4\">\n";
		$content .= "<STRONG>非適切語削除</STRONG>\n";
		$content .= "</TD>\n";
		$content .= "</TR>\n";

		# 非適切語削除フォーム
		$loop = 0;
		while ($loop < $num) {
			$content .= "<TR bgcolor=\"$tg_clr\">\n";
			$content .= "<TD>　</TD>\n";
			$content .= "<TD align=\"right\">・</TD>\n";
			$content .= "<TD>$column[$loop]</TD>\n";
			$content .= "<FORM action=\"$script\" method=\"$method\">\n";
			$content .= "<INPUT type=\"hidden\" name=\"mode\" value=\"admin\">\n";
			$content .= "<INPUT type=\"hidden\" name=\"func\" value=\"del_word\">\n";
			$content .= "<INPUT type=\"hidden\" name=\"loop\" value=\"$loop\">\n";
#			$content .= "<INPUT type=\"hidden\" name=\"psw\" value=\"$in{'psw'}\">\n";
			$content .= "<TD><INPUT type=\"submit\" value=\"削除\"></TD>\n";
			$content .= "</TR>\n";
			$content .= "</FORM>\n";
			$loop++;
		}
	}

	# 非適切語削除処理表示
	$content .= "<TR bgcolor=\"$tg_clr\">\n";
	$content .= "<TD colspan=\"4\">\n";
	$content .= "<STRONG>非適切語追加</STRONG>\n";
	$content .= "</TD>\n";
	$content .= "</TR>\n";

	# 非適切語追加フォーム
	$content .= "<FORM action=\"$script\" method=\"$method\">\n";
	$content .= "<INPUT type=\"hidden\" name=\"mode\" value=\"admin\">\n";
	$content .= "<INPUT type=\"hidden\" name=\"func\" value=\"add_word\">\n";
#	$content .= "<INPUT type=\"hidden\" name=\"psw\" value=\"$in{'psw'}\">\n";
	$content .= "<TR bgcolor=\"$tg_clr\">\n";
	$content .= "<TD>　</TD>\n";
	$content .= "<TD>非適切語</TD>\n";
	$content .= "<TD><INPUT type=\"text\" name=\"word\" size=\"20\"></TD>\n";
	$content .= "<TD><INPUT type=\"submit\" value=\"追加\"></TD>\n";
	$content .= "</TR>\n";
	$content .= "</FORM>\n";

	# テーブルの指定（終わり）
	$content .= "</TABLE>\n";
	$content .= "</TD></TR>\n";
	$content .= "</TABLE>\n";
	$content .= "</TD></TR>\n";
	$content .= "</TABLE>\n";

	# フッター出力
	&footer;
}

#------------------------------------------------------------------------------
# 管理フォーム（PC）
#------------------------------------------------------------------------------
sub adminmes {
	# ヘッダー出力
	$headtype = 0;
	&header;

	# タイトル表示
	if ($pc_img) {
		$content .= "<div align=\"center\"> <img src=\"$pc_img\"></div><BR>\n";
		$content .= "<div align=\"center\"> 管理フォーム</div><BR>\n";
	} else {
		$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"1\" width=\"100\%\">\n";
		$content .= "<TR><TH bgcolor=\"$tf_clr\">\n";
		$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"2\" width=\"100\%\">\n";
		$content .= "<TR><TH bgcolor=\"$tb_clr\">\n";
		$content .= "<FONT color=\"$ti_clr\">$pc_title－管理フォーム</FONT>\n";
		$content .= "</TH></TR>\n</TABLE>\n";
		$content .= "</TH></TR>\n</TABLE><BR>\n";
	}

	# 機能バー表示
	&topmenu;

	# コメント
	$content .= "<BR>\n";
	$content .= "<div align=\"center\"> パスワード変更完了。再度ログインしてください。</div>\n";
	$content .= "<BR>\n";


	# テーブルの指定（終わり）
	$content .= "</TABLE>\n";
	$content .= "</TD></TR>\n";
	$content .= "</TABLE>\n";
	$content .= "</TD></TR>\n";
	$content .= "</TABLE>\n";

	# フッター出力
	&footer;
}

#------------------------------------------------------------------------------
# 削除フォーム（PC）
#------------------------------------------------------------------------------
sub dform {
	# ヘッダー出力
	$headtype = 0;
	&header;

	# タイトル表示
	if ($pc_img) {
		$content .= "<div align=\"center\"> <img src=\"$pc_img\"></div><BR>\n";
		$content .= "<div align=\"center\"> 削除フォーム</div><BR>\n";
	} else {
		$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"1\" width=\"100%\">\n";
		$content .= "<TR><TH bgcolor=\"$tf_clr\">\n";
		$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"2\" width=\"100%\">\n";
		$content .= "<TR><TH bgcolor=\"$tb_clr\">\n";
		$content .= "<FONT color=\"$ti_clr\">$pc_title－削除フォーム</FONT>\n";
		$content .= "</TH></TR>\n</TABLE>\n";
		$content .= "</TH></TR>\n</TABLE><BR>\n";
	}

	# 機能バー表示
	&topmenu;

	# ログファイルをオープンする。
	open (IN,"$logfile") || &error (open_er);
	@line = <IN>;
	close(IN);
	
	# 変数の初期設定
	$count   = shift(@line);	# ログカウントを分離
	$num     = 0;				# 記事数
	$num_max = @line;			# 投票記事数
	$num_t   = 0;				# ツリー数
	$page    = $in{'page'};		# ページの指定
	$num_pag = 1;				# ページのカウント

	# ページの指定のない場合は始めのページにする。
	if ($page eq "") { $page = 1; }

	# 枠の始め
	$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"0\" align=\"center\">\n";
	$content .= "<TR>\n";

	# 戻りボタン
	$content .= "<FORM action=\"$script\" method=\"$method\">\n";
	$content .= "<INPUT type=\"hidden\" name=\"mode\" value=\"admin\">\n";
	$content .= "<TD>\n";
	$content .= "<INPUT type=\"submit\" value=\"戻る\">\n";
	$content .= "</TD>\n";
	$content .= "</FORM>\n";

	# フォームタグ
	$content .= "<FORM action=\"$script\" method=\"$method\">\n";
	$content .= "<INPUT type=\"hidden\" name=\"mode\" value=\"dform\">\n";
	$content .= "<INPUT type=\"hidden\" name=\"func\" value=\"delete\">\n";
#	$content .= "<INPUT type=\"hidden\" name=\"psw\" value=\"$in{'psw'}\">\n";
	$content .= "<INPUT type=\"hidden\" name=\"page\" value=\"$page\">\n";

	# 削除／取消ボタン
	$content .= "<TD>\n";
	$content .= "<INPUT type=\"submit\" value=\"削除\">\n";
	$content .= "</TD>\n";
	$content .= "<TD>\n";
	$content .= "<INPUT type=\"reset\" value=\"取消\">\n";
	$content .= "</TD>\n";

	# 枠の終わり
	$content .= "</TR>\n</TABLE>\n<BR>\n";

	# 枠の始め
	$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"0\" align=\"center\">\n";
	$content .= "<TR bgcolor=\"$tf_clr\"><TD>\n";
	$content .= "<TABLE border=\"0\" cellspacing=\"1\" cellpadding=\"2\">\n";

	# 項目行を表示
	$content .= "<TR bgcolor=\"$tg_clr\">\n";
	$content .= "<TD><SMALL>一括</SMALL></TD>\n";
	$content .= "<TD><SMALL>制限</SMALL></TD>\n";
	$content .= "<TD><SMALL>個別</SMALL></TD>\n";
	$content .= "<TD><SMALL>No.</SMALL></TD>\n";
	$content .= "<TD><SMALL>日時</SMALL></TD>\n";
	$content .= "<TD><SMALL>題名</SMALL></TD>\n";
	$content .= "<TD><SMALL>名前</SMALL></TD>\n";
	$content .= "<TD><SMALL>トリップ</small></td>\n";
	$content .= "<TD><SMALL>本文</SMALL></TD>\n";
	$content .= "<TD><SMALL>ML</SMALL></TD>\n";
	$content .= "<TD><SMALL>HP</SMALL></TD>\n";
	$content .= "<TD><SMALL>端末/UA</SMALL></TD>\n";
	$content .= "<TD><SMALL>ホスト名/IPアドレス</SMALL></TD>\n";
	$content .= "</TR>\n";

	while ($num < $num_max) {
		# 各行を分割し、配列に格納
		@column = split(/<>/,$line[$num]);

		# ページのカウント
		if ($column[0] == $column[1]) {
			if ($num_t == $max_dform) {
				$num_t = 0;
				$num_pag++;
			}
			$num_t++;
		}

		if ($num_pag == $page) {
			# 行の始め
			$content .= "<TR bgcolor=$tg_clr>\n";

			# ツリー構造を表示
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
				$content .= "<TD><SMALL>↑</SMALL></TD>\n";
				$content .= "<TD><SMALL>↑</SMALL></TD>\n";
		}

			# 削除用のチェックボックス表示
			$content .= "<TD><SMALL><INPUT type=\"checkbox\" name=\"col$column[0]\" value=\"1\"></SMALL></TD>\n";

			# 投稿No.の表示
			$content .= "<TD><SMALL>$column[0]</SMALL></TD>\n";

			# 書きこみ日時の表示
			$content .= "<TD><SMALL>$column[2]<BR>$column[3]</SMALL></TD>\n";

			# 表題の表示
			$column[5] =~ s/<BR>//g;
			$column[5] =~ s/(....................)(.*)/$1/;
			$content .= "<TD><SMALL><FONT color=\"$dai_clr\">$column[5] </SMALL></TD>\n";

			# 名前の表示
			$content .= "<TD><SMALL>$column[4]</SMALL></TD>\n";
			
			# トリップの表示
			$content .= "<td><small>$column[15]</small></td>\n";
			
			# コメントの表示
			$column[6] =~ s/<BR>//g;
			$column[6] =~ s/(........................................)(.*)/$1/;
			$content .= "<TD><SMALL>$column[6] </SMALL></TD>\n";

			# メールアドレスの表示
			if ($column[7] ne '') {
				$content .= "<TD><SMALL><A href=\"mailto\:$column[7]\">";
				if ($pc_mimg ne '') {
					$content .= "<img border=\"0\" src=\"$pc_mimg\" alt=\"$column[7]\">";
				} else {
					$content .= "○";
				}
				$content .= "</A></SMALL></TD>\n";
			} else {
				$content .= "<TD><SMALL>　</SMALL></TD>\n";
			}

			# ホームページの表示
			if ($column[8] ne '') {
				&autolink( $column[8] );
				$content .= "<TD>$column[8]</TD>\n";
			} else {
				$content .= "<TD><SMALL>　</SMALL></TD>\n";
			}

			if($column[14] ne '') {
				# 端末の表示
				$content .= "<TD><SMALL>[$column[9]]<BR>$column[14]</SMALL></TD>\n";
			}
			else{
				# 端末の表示
				$content .= "<TD><SMALL>[$column[9]]</SMALL></TD>\n";
			}
			
			# ホスト名/IPアドレスの表示
			$content .= "<TD><SMALL>$column[10]<BR>$column[11]</SMALL></TD>\n";

			# 行の終わり
			$content .= "</TR>\n";
		}
		$num++;
	}

	# 記事がない場合の処理
	if (($num == 0) || ($num_pag < $page)) {
		$content .= "$s_tab";
		$content .= "<TR><TD bgcolor=\"$tg_clr\" colspan=\"11\">\n";
		$content .= "<BLOCKQUOTE>投稿記事は有りません</BLOCKQUOTE>\n";
		$content .= "</TD></TR>\n";
	}

	# 枠の表示（終わり）
	$content .= "</TABLE>\n</TD></TR>\n</TABLE>";

	# フォームタグ（終わり）
	$content .= "</FORM>\n";

	# ページ表示
	if ($num_pag != 1) {
		$content .= "<BR><TABLE border=\"0\" cellpadding=\"0\" cellspacing=\"0\" align=\"center\">";
		$content .= "<TR><TD valign=\"top\"><SMALL>";
		$content .= "ページ指定：";
		$content .= "</SMALL></TD><TD><SMALL>";
		$num = 1;	# ページカウント
		$numc = 0;	# 改行のためのカウント
		while ($num <= $num_pag) {
			if ($num < 10) { $num = "0" . "$num"; }
			if ($page == $num) {
				# 現在ページを赤色で表示
				$content .= "<FONT color=\"$new_clr\">$num</FONT>\n";
			} else {
				# 別のページをリンク
				$content .= "<A href=\"$script?mode=dform\&amp;page=$num\">$num</A>\n";
#				$content .= "<A href=\"$script?mode=dform\&amp;page=$num\&amp;psw=$in{'psw'}\">$num</A>\n";
			}
			# 10ページごとにカウントする。
			if ($num =~ /0$/) { $numc++; }
			# 20ページごとに改行を入れる
			if ($numc == 2) { $numc = 0; $content .= "<BR>\n"; }
			$num++;
		}
		$content .= "</SMALL></TD></TR></TABLE>\n";
	}

	# フッター出力
	&footer;
}

#------------------------------------------------------------------------------
# 個別表示（PC）
#------------------------------------------------------------------------------
sub pc_view {
	# ヘッダー出力
	$headtype = 0;
	&header;

	# タイトル表示
	if ($pc_img) {
		$content .= "<div align=\"center\"> <img src=\"$pc_img\"></div><BR>\n";
		$content .= "<div align=\"center\"> 個別表\示</div><BR>\n";
	} else {
		$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"1\" width=\"100\%\">\n";
		$content .= "<TR><TH bgcolor=\"$tf_clr\">\n";
		$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"2\" width=\"100\%\">\n";
		$content .= "<TR><TH bgcolor=\"$tb_clr\">\n";
		$content .= "<FONT color=\"$ti_clr\">$pc_title－個別表\示</FONT>\n";
		$content .= "</TH></TR>\n</TABLE>\n";
		$content .= "</TH></TR>\n</TABLE><BR>\n";
	}

	# 機能バー表示
	&topmenu;


	# 解説表示
	$content .= "<div align=\"center\"> 個別の表\示です。返信を押すとツリーに返信します。</div>\n";
	$content .= "<div align=\"center\"> $new_time時間以内の書込みには<FONT color=\"$new_clr\">NEW</FONT>マークを表\示します。</div><BR>\n";

	# 枠の表示
	$content .= "<TABLE border=\"0\" cellpadding=\"1\" cellspacing=\"0\" width=\"80%\" align=\"center\">\n";
	$content .= "<TR><TD bgcolor=\"$tf_clr\">\n";
	$content .= "<TABLE border=\"0\" cellpadding=\"10\" cellspacing=\"0\" width=\"100%\">\n";
	$content .= "<TR><TD bgcolor=\"$tg_clr\">\n";
	$content .= "<TABLE border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">\n";

	# レス元のツリーを表示
	open (IN,"$logfile") || &error (open_er);
	@line = <IN>;
	close(IN);
	
	$count   = shift(@line);
	$num     = 0;		# 記事数
	$num_max = $#line;	# 最大記事数

	while ($num <= $num_max) {
		# 各行を分割し、配列に格納
		@column = split(/<>/,$line[$num]);

		# ツリーを検索／表示
		if (($column[1] == $in{'tree'}) || ($column[0] == $in{'no'})) {
			# 仕切線
			if (($column[0] != $column[1]) && ($in{'tree'})) {
				$content .= "<TR><TD bgcolor=\"$tg_clr\" colspan=\"2\">\n";
				$content .= "<HR size=\"1\" width=\"95%\">\n";
				$content .= "</TD></TR>\n";
			}

			# 情報行の始め
			$content .= "<TR><TD bgcolor=\"$tg_clr\">\n";

			# 記事番号の表示
			$content .= "No.$column[0]\n";

			# 表題の表示
			$content .= "<FONT color=\"$dai_clr\">$column[5]</FONT>\n";

			# 名前の表示
			$content .= "<strong>$column[4]\n";
			
			if ($column[15] ne '') {
				$content .= " ◆</strong>$column[15]\n";
			} else {
				$content .= "</strong>\n";
			}

			# メールアドレスの表示
			if ($column[7] ne '') {
				$content .= "<A href=\"mailto\:$column[7]\">";
				if ($pc_mimg) {
					$content .= "<img border=\"0\" src=\"$pc_mimg\" alt=\"MAIL\">";
				} else {
					$content .= "[mail]\n";
				}
				$content .= "</A>\n";
			}

			# ホームページの表示
			if ($column[8] ne ''){
				if ($autolink) { &autolink( $column[8] ); }
				$content .= "$column[8]\n"; 
			}

			# 端末の表示
			$content .= "<SMALL>[$column[9]]</SMALL>\n";

			# 書きこみ日時の表示
			$content .= "<SMALL>$column[2] $column[3]</SMALL>\n";

			# 返信
			if ($column[0] == $column[1] && $column[16] ne "1") {
				$content .= "<A href=\"$script?mode=form&amp;res=$column[1]\">返信</A>\n";
			}

			# 情報行の終わり
			$content .= "</TD></TR>\n";

			# コメントの表示
			if ($autolink) { &autolink( $column[6] ); }
			$content .= "<TR><TD bgcolor=\"$tg_clr\">\n";
			$content .= "<BLOCKQUOTE>\n$column[6]\n</BLOCKQUOTE>\n";
			$content .= "</TD></TR>\n";

		}
		$num++;
	}

	# 枠の表示（終わり）
	$content .= "</TABLE>\n</TD></TR>\n</TABLE>\n</TD></TR>\n</TABLE>\n";

	$content .= "<BR>\n<div align=\"center\"> ";
	$content .= "<A href=\"javascript:history.back()\">もどる</A>";
	$content .= "</div>\n<BR>\n";

	# ユーザ削除枠の表示
	$content .= "<div align=\"center\"> <SMALL>\n";
	$content .= "<FORM action=\"$script\" method=\"$method\">\n";
	$content .= "<INPUT type=\"hidden\" name=\"func\" value=\"user_delete\">\n";
	$content .= "ユーザ削除：各項を入力して削除を押してください。<BR>\n";
	$content .= "記事番号：<INPUT name=\"num\" size=\"4\">\n";
	$content .= "パスワード：<INPUT type=\"password\" name=\"dpas\" size=\"10\">\n";
	$content .= "<INPUT type=\"submit\" value=\"削除\">\n";
	$content .= "<INPUT type=\"reset\" value=\"取消\">\n";
	$content .= "</SMALL></div>\n";

	# フッター出力
	&footer;
}

#------------------------------------------------------------------------------
# ツリー表示（PC）
#------------------------------------------------------------------------------
sub pc_tree {
	# ログファイルをオープンする
	open (IN,"$logfile") || &error (open_er);
	@line = <IN>;
	close(IN);

	# ヘッダー出力
	$headtype = 0;
	&header;

	# 時間の取得
	&get_time;

	# タイトル表示
	if ($pc_img) {
		$content .= "<div align=\"center\"> <img src=\"$pc_img\"></div><BR>\n";
		$content .= "<div align=\"center\"> ツリー表\示</div><BR>\n";
	} else {
		$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"1\" width=\"100%\" summary=\"tree\">\n";
		$content .= "<TR><TH bgcolor=\"$tf_clr\">\n";
		$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"2\" width=\"100%\" summary=\"tree\">\n";
		$content .= "<TR><TH bgcolor=\"$tb_clr\">\n";
		$content .= "<FONT color=\"$ti_clr\">$pc_title－ツリー表\示</FONT>\n";
		$content .= "</TH></TR>\n</TABLE>\n";
		$content .= "</TH></TR>\n</TABLE><BR>\n";
	}

	# 機能バー表示
	&topmenu;
	
	# 解説表示
	$content .= "<div align=\"center\"> １ページに最大$max_tree件のツリーを表\示します。</div>\n";
	$content .= "<div align=\"center\"> $new_time時間以内の書込みには<FONT color=\"$new_clr\">NEW</FONT>マークを表\示します。</div>\n";
	$content .= "<div align=\"center\"> <FONT color=\"$li_clr\">$top_mark</FONT>を押すとツリーを、<FONT color=\"$dai_clr\">題名</FONT>を押すと各記事を表\示します。</div>\n";
	$content .= "<div align=\"center\"> 広告書き込みお断り。</div>\n";

	# 変数の初期設定
	$count   = shift(@line);	# ログカウントを分離
	$num     = 0;				# 記事数
	$num_max = @line;			# 投票記事数
	$num_t   = 0;				# ツリーのカウント
	$page    = $in{'page'};		# ページ指定
	$num_pag = 1;				# ページのカウント

	# ページ指定のない場合は始めのページにする。
	if ($page eq "") { $page = 1; }

	# リスト開始
	$content .= "<BLOCKQUOTE>\n";
	$content .= "<DL>\n";

	while ($num < $num_max) {
		# 各行を分割し、配列に格納
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

			# 投稿No.の表示
			$content .= "No.$column[0]\n";

			# 題名補完機能
			if (($dai_aid) && ($column[5] eq $dai_tmp)) {
				$column[5] = $column[6] ;
				$column[5] =~ s/<BR>//g;
				$column[5] =~ s/(....................)(.*)/$1/;
			}

			# 表題の表示
			$content .= "<A href=\"$script?mode=view&amp;no=$column[0]&amp;page=$page\">\n";
			$content .= "<FONT color=\"$dai_clr\">$column[5] </FONT>\n";
			$content .= "</A>\n";

			# 名前の表示
			$content .= "<strong>$column[4]\n";
			
			if ($column[15] ne '') {
				$content .= " ◆</strong>$column[15]\n";
			} else {
				$content .= "</strong>\n";
			}

			# メールアドレスの表示
			if ($column[7] ne '') {
				$content .= "<A href=\"mailto\:$column[7]\">";
				if ($pc_mimg) {
					$content .= "<img border=\"0\" src=\"$pc_mimg\" alt=\"MAIL\">";
				} else {
					$content .= "[mail]\n";
				}
				$content .= "</A>\n";
			}

			# ホームページの表示
			if ($column[8] ne '') {
				if ($autolink) { &autolink( $column[8] ); }
				$content .= "$column[8]\n"; 
			}

			# 端末の表示
			$content .= "<SMALL>[$column[9]]</SMALL>\n";

			# 書きこみ日時の表示
			$content .= "<SMALL>$column[2] $column[3]</SMALL>\n";

			# NEWマークの表示
			if (($times - $column[13]) < $new_time * 3600) {
				$content .= "<FONT color=\"$new_clr\">NEW</FONT>\n";
			}

			# 返信
			if ($column[0] == $column[1] && $column[16] ne "1") { 
				$content .= "<A href=\"$script?mode=form&amp;res=$column[0]\">返信</A>\n";
			}

			if ($column[0] == $column[1] && $column[16] ne "1"){
				$content .= "</DT>\n";
			} else {
				$content .= "</DD>\n";
			}
		}
		$num++;
	}

	# 記事がない場合の処理
	if ($num == 0) {
		$content .= "$s_tab";
		$content .= "<DT>投稿記事は有りません</DT>\n";
	}

	# リスト終わり
	$content .= "</DL>\n";
	$content .= "</BLOCKQUOTE>\n";

	# ページ表示
	if ($num_pag != 1) {
		$content .= "<BR><TABLE border=\"0\" cellpadding=\"0\" cellspacing=\"0\" align=\"center\" summary=\"page指定\">";
		$content .= "<TR><TD valign=\"top\"><SMALL>";
		$content .= "ページ指定：";
		$content .= "</SMALL></TD><TD><SMALL>";
		$num = 1;	# ページカウント
		$numc = 0;	# 改行のためのカウント
		while ($num <= $num_pag) {
			if ($num < 10) { $num = "0" . "$num"; }
			if ($page == $num) {
				# 現在ページを赤色で表示
				$content .= "<FONT color=\"$new_clr\">$num</FONT>\n";
			} else {
				# 別のページをリンク
				$content .= "<A href=\"$script?mode=tree\&amp;page=$num\">$num</A>\n";
			}
			# 10ページごとにカウントする。
			if ($num =~ /0$/) { $numc++; }
			# 20ページごとに改行を入れる
			if ($numc == 2) { $numc = 0; $content .= "<BR>\n"; }
			$num++;
		}
		$content .= "</SMALL></TD></TR></TABLE>\n";
	}

	# ユーザ削除枠の表示
	$content .= "<div align=\"center\">\n";
	$content .= "<FORM action=\"$script\" method=\"$method\"><SMALL>\n";
	$content .= "<INPUT type=\"hidden\" name=\"func\" value=\"user_delete\">\n";
	$content .= "ユーザ削除：各項を入力して削除を押してください。<BR>\n";
	$content .= "記事番号：<INPUT name=\"num\" size=\"4\" value=\"\">\n";
	$content .= "パスワード：<INPUT type=\"password\" name=\"dpas\" size=\"10\" value=\"\">\n";
	$content .= "<INPUT type=\"submit\" value=\"削除\">\n";
	$content .= "<INPUT type=\"reset\" value=\"取消\">\n";
	$content .= "</SMALL></form></div>\n";

	# フッター出力
	&footer;
}

#------------------------------------------------------------------------------
# 一括表示（PC）
#------------------------------------------------------------------------------
sub pc_all {
	# ログファイルをオープンする
	open (IN,"$logfile") || &error (open_er);
	@line = <IN>;
	close(IN);

	# ヘッダー出力
	$headtype = 0;
	&header;

	# 時間の取得
	&get_time;

	# タイトル表示
	if ($pc_img) {
		$content .= "<div align=\"center\"> <img src=\"$pc_img\"></div><BR>\n";
		$content .= "<div align=\"center\"> すべて表\示</div><BR>\n";
	} else {
		$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"1\" width=\"100%\">\n";
		$content .= "<TR><TH bgcolor=\"$tf_clr\">\n";
		$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"2\" width=\"100%\">\n";
		$content .= "<TR><TH bgcolor=\"$tb_clr\">\n";
		$content .= "<FONT color=$ti_clr>$pc_title－すべて表\示</FONT>\n";
		$content .= "</TH></TR>\n</TABLE>\n";
		$content .= "</TH></TR>\n</TABLE><BR>\n";
	}

	# 機能バー表示
	&topmenu;

	# 解説表示
	$content .= "<div align=\"center\"> １ページに最大$max_view件のツリーを表\示します。</div>\n";
	$content .= "<div align=\"center\"> $new_time時間以内の書込みには<FONT color=\"$new_clr\">NEW</FONT>マークを表\示します。</div>\n";

	# 枠の設定（何度も書くのが面倒くさいので）
	$s_tab = "<BR>\n";
	$s_tab .= "<TABLE border=\"0\" cellpadding=\"1\" cellspacing=\"0\" width=\"80%\" align=\"center\">\n";
	$s_tab .= "<TR><TD bgcolor=\"$tf_clr\">\n";
	$s_tab .= "<TABLE border=\"0\" cellpadding=\"10\" cellspacing=\"0\" width=\"100%\">\n";
	$s_tab .= "<TR><TD bgcolor=\"$tg_clr\">\n";
	$s_tab .= "<TABLE border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">\n";
	$e_tab = "</TABLE>\n</TD></TR>\n</TABLE>\n</TD></TR>\n</TABLE>\n";

	# 変数の初期設定
	$count   = shift(@line);	# ログカウントを分離
	$num     = 0;				# 記事数
	$num_max = @line;			# 投票記事数
	$num_t   = 0;				# ツリーのカウント
	$page    = $in{'page'};		# ページ指定
	$num_pag = 1;				# ページのカウント

	# ページ指定のない場合は始めのページにする。
	if ($page eq "") { $page = 1; }

	while ($num < $num_max) {
		# 各行を分割し、配列に格納
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
				# 枠の表示（終わり）
				if ($num_t != 0) { $content .= "$e_tab"; }

				# 枠の表示（始め）
				$content .= "$s_tab";
			}

			# 仕切線
			if ($column[0] != $column[1]) {
				$content .= "<TR><TD bgcolor=\"$tg_clr\" colspan=\"2\">\n";
				$content .= "<HR size=\"1\" width=\"95%\">\n";
				$content .= "</TD></TR>\n";
			}

			# 情報行の始め
			$content .= "<TR><TD bgcolor=\"$tg_clr\">\n";

			# 投稿No.の表示
			$content .= "No.$column[0]\n";

			# 表題の表示
			$content .= "<FONT color=\"$dai_clr\">$column[5]</FONT>\n";

			# 名前の表示
			$content .= "<strong>$column[4]\n";
			
			if ($column[15] ne '') {
				$content .= " ◆</strong>$column[15]\n";
			} else {
				$content .= "</strong>\n";
			}

			# メールアドレスの表示
			if ($column[7] ne '') {
				$content .= "<A href=\"mailto\:$column[7]\">";
				if ($pc_mimg) {
					$content .= "<img border=\"0\" src=\"$pc_mimg\" alt=\"MAIL\">";
				} else {
					$content .= "[mail]\n";
				}
				$content .= "</A>\n";
			}

			# ホームページの表示
			if ($column[8] ne '') {
				if ($autolink) { &autolink( $column[8] ); }
				$content .= "$column[8]\n"; 
			}

			# 端末の表示
			$content .= "<SMALL>[$column[9]]</SMALL>\n";

			# 書きこみ日時の表示
			$content .= "<SMALL>$column[2] $column[3]</SMALL>\n";

			# NEWマークの表示
			if (($times - $column[13]) < $new_time * 3600) {
				$content .= "<FONT color=\"$new_clr\">NEW</FONT>\n";
			}

			# 返信
			if ($column[0] == $column[1] && $column[16] ne "1"){
				$content .= "<A href=\"$script?mode=form&amp;res=$column[0]\">返信</A>\n";
			}

			# 情報行の終わり
			$content .= "</TD></TR>\n";

			# コメントの表示
			if ($autolink) { &autolink( $column[6] ); }
			$content .= "<TR><TD bgcolor=\"$tg_clr\">\n";
			$content .= "<BLOCKQUOTE>\n$column[6]\n</BLOCKQUOTE>\n";
			$content .= "</TD></TR>\n";
		}
		$num++;
	}

	# 記事がない場合の処理
	if ($num == 0) {
		$content .= "$s_tab";
		$content .= "<TR><TD bgcolor=\"$tg_clr\">\n";
		$content .= "<BLOCKQUOTE>投稿記事は有りません</BLOCKQUOTE>\n";
		$content .= "</TD></TR>\n";
	}

	# 枠の表示（終わり）
	$content .= "$e_tab";

	# ページ表示
	if ($num_pag != 1) {
		$content .= "<BR><TABLE border=\"0\" cellpadding=\"0\" cellspacing=\"0\" align=\"center\">";
		$content .= "<TR><TD valign=\"top\"><SMALL>";
		$content .= "ページ指定：";
		$content .= "</SMALL></TD><TD><SMALL>";
		$num = 1;	# ページカウント
		$numc = 0;	# 改行のためのカウント
		while ($num <= $num_pag) {
			if ($num < 10) { $num = "0" . "$num"; }
			if ($page == $num) {
				# 現在ページを赤色で表示
				$content .= "<FONT color=\"$new_clr\">$num</FONT>\n";
			} else {
				# 別のページをリンク
				$content .= "<A href=\"$script?mode=all\&amp;page=$num\">$num</A>\n";
			}
			# 10ページごとにカウントする。
			if ($num =~ /0$/) { $numc++; }
			# 20ページごとに改行を入れる
			if ($numc == 2) { $numc = 0; $content .= "<BR>\n"; }
			$num++;
		}
		$content .= "</SMALL></TD></TR></TABLE>\n";
	}

	# ユーザ削除枠の表示
	$content .= "<div align=\"center\"> <SMALL>\n";
	$content .= "<FORM action=\"$script\" method=\"$method\">\n";
	$content .= "<INPUT type=\"hidden\" name=\"func\" value=\"user_delete\">\n";
	$content .= "ユーザ削除：各項を入力して削除を押してください。<BR>\n";
	$content .= "記事番号：<INPUT name=\"num\" size=\"4\">\n";
	$content .= "パスワード：<INPUT type=\"password\" name=\"dpas\" size=\"10\">\n";
	$content .= "<INPUT type=\"submit\" value=\"削除\">\n";
	$content .= "<INPUT type=\"reset\" value=\"取消\">\n";
	$content .= "</SMALL></div>\n";

	# フッター出力
	&footer;
}


#------------------------------------------------------------------------------
# スパム防止処理第一段階ｗ（PC）
#------------------------------------------------------------------------------

sub wkeychk{
	unless ($in{'wkey'} eq $wkey){
	&error(wkey_er);
	}
}


#------------------------------------------------------------------------------
# デバイス情報更新処理結果表示(PC)
#------------------------------------------------------------------------------
# 08.02.15 新規作成
sub updateResult{
	# ヘッダー出力
	$headtype = 0;
	&header;

		
	# タイトル表示
	if ($pc_img) {
		$content .= "<div align=\"center\"> <img src=\"$pc_img\"></div><BR>\n";
		$content .= "<div align=\"center\"> デバイス情報更新処理</div><BR>\n";
	} else {
		$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"1\" width=\"100%\">\n";
		$content .= "<TR><TH bgcolor=\"$tf_clr\">\n";
		$content .= "<TABLE border=\"0\" cellspacing=\"0\" cellpadding=\"2\" width=\"100%\">\n";
		$content .= "<TR><TH bgcolor=\"$tb_clr\">\n";
		$content .= "<FONT color=$ti_clr>$pc_title－デバイス情報更新処理</FONT>\n";
		$content .= "</TH></TR>\n</TABLE>\n";
		$content .= "</TH></TR>\n</TABLE><BR>\n";
	}

	if($deviceUpdateFlag){
		# 成功時
		$content .= "<BR>\n";
		$content .= "<TABLE border=\"0\" cellpadding=\"1\" cellspacing=\"0\" width=\"80%\" align=\"center\">\n";
		$content .= "<TR><TD bgcolor=\"$tf_clr\">\n";
		$content .= "<TABLE border=\"0\" cellpadding=\"10\" cellspacing=\"0\" width=\"100%\">\n";
		$content .= "<TR><TD bgcolor=\"$tg_clr\">\n";
		$content .= "<TABLE border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">\n";
		$content .= "<TR><TD bgcolor=\"$tg_clr\">\n";
		$content .= "<BLOCKQUOTE>最新データに更新しました。</BLOCKQUOTE>\n";
		$content .= "</TD></TR>\n";
		$content .= "</TABLE>\n</TD></TR>\n</TABLE>\n</TD></TR>\n</TABLE>\n";

	} else {
		# すでに最新版の時
		$content .= "<BR>\n";
		$content .= "<TABLE border=\"0\" cellpadding=\"1\" cellspacing=\"0\" width=\"80%\" align=\"center\">\n";
		$content .= "<TR><TD bgcolor=\"$tf_clr\">\n";
		$content .= "<TABLE border=\"0\" cellpadding=\"10\" cellspacing=\"0\" width=\"100%\">\n";
		$content .= "<TR><TD bgcolor=\"$tg_clr\">\n";
		$content .= "<TABLE border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">\n";
		$content .= "<TR><TD bgcolor=\"$tg_clr\">\n";
		$content .= "<BLOCKQUOTE>すでに最新データです。</BLOCKQUOTE>\n";
		$content .= "</TD></TR>\n";
		$content .= "</TABLE>\n</TD></TR>\n</TABLE>\n</TD></TR>\n</TABLE>\n";

	}

	# フッター出力
	&footer;

}


1;
