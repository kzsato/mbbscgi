#------------------------------------------------------------------------------
# 投稿フォーム（i-mode、J-Sky、ドットi）
#------------------------------------------------------------------------------
sub c_form {
	# ヘッダー出力
	$headtype = 0;
	&header;

	# クッキー取得
	if ($use_cookie) { &get_cookie; }
	$c_url = "http://" . $c_url;

	# J-Sky(ステーション非対応機)はGETのみ対応なのでMETHODを変更
	if ($agent == 3) { $method = 'GET'; }

	# フォームタグ
	$content .= "<FORM action=\"$script\" method=\"$method\">\n";
	$content .= "<INPUT type=\"hidden\" name=\"mode\" value=\"write\">\n";

	# 表示の中央寄せ
	$content .= "<CENTER>\n";

	$res_dai = "";
	if($in{'res'}){
		# レス元の文章を検索
		open (IN,"$logfile") || &error (open_er);
		@line = <IN>;
		close(IN);

		# ログカウントを分離
		$count   = shift(@line);

		# レスした番号の記事を探す
		$num = 0;
		foreach $col (@line) {
			@column = split(/<>/,$col);
			if ($column[0] == $in{'res'}) {
				$res_dai = "RE\:$column[5]";	# 親記事題名登録
				last;
			}
			$num++;
		}
		$content .= "<INPUT type=\"hidden\" name=\"res\" value=\"$in{'res'}\">\n";
		$content .= "｢レス書込み｣<BR>\n";
	} else {
		$content .= "｢新規書込み｣<BR>\n";
	}

	

	# フォーマットの指定
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

	# 名前入力
	$content .= "名前";
	$content .= "<INPUT type=\"text\" name=\"name\" value=\"$c_name\" size=\"$sizea\" $kana>";
	$content .= "<BR>\n";

	# 題名入力
	$content .= "題名";
	$content .= "<INPUT type=\"text\" name=\"dai\" value=\"$res_dai\" size=\"$sizea\" $kana>";
	$content .= "<BR>\n";

	# 本文入力
	$content .= "本文　　　　　　\n";
	$content .= "<TEXTAREA name=\"msg\" cols=\"$sizec\" rows=\"2\" $kana>";
	$content .= "</TEXTAREA><BR>\n";

	# メールアドレス入力
	$content .= "$mail_mark";
	$content .= "<INPUT type=\"text\" name=\"mail\" value=\"$c_mail\" size=\"$sizeb\" maxlength=\"100\" $alpha>";
	$content .= "<BR>\n";

	# ホームページアドレス入力
	$content .= "$home_mark";
	$content .= "<INPUT type=\"text\" name=\"url\" value=\"$c_url\" size=\"$sizeb\" maxlength=\"100\"  $alpha>";
	$content .= "<BR>\n";

	# 削除パスワード入力
	$content .= "$key_mark";
	$content .= "<INPUT type=\"$password\" name=\"dpas\" size=\"$sizeb\" value=\"$c_dpas\">";
	$content .= "<BR>\n";

	# 投稿／取消ボタン
	$content .= "<CENTER>\n";
	$content .= "<INPUT type=\"submit\" value=\"投稿\">\n";
	$content .= "<INPUT type=\"reset\" value=\"取消\">\n";
	$content .= "</CENTER>\n";

	# フォームタグ終わり
	$content .= "</FORM>\n";

	# 表示の中央寄せ終わり
	$content .= "</CENTER>\n";

	# フッター出力
	&footer;

	# 画面出力
	&c_print;
}

#------------------------------------------------------------------------------
# 書込み確認（i-mode、J-Sky、ドットi）
#------------------------------------------------------------------------------
sub c_write {
	# ヘッダー出力
	$headtype = 0;
	&header;

	# 内容の表示
	$content .= "<CENTER>";
	$content .= "確認\n";
	$content .= "No$new";					# 記事番号
	$content .= "</CENTER>\n";
	$content .= "題名:$dai<BR>\n";			# 題名
	$content .= "名前:$name\n";				# 名前
	$content .= "<HR>\n";					# 仕切り線
	if ($autolink) { &autolink( $msg ); }	# 自動リンク機能
	$content .= "$msg\n";					# 記事
	$content .= "<HR>\n";					# 仕切り線

	$content .= "「$agent_name」\n";			# 端末表示

	# メール表示
	if ($in{'mail'} ne "") {
		$content .= "$mail_mark $in{'mail'}<BR>\n";
	}

	# ホーム表示
	if ($in{'url'} ne "") {
		$content .= "$home_mark $in{'url'}<BR>\n";
	}

	# 戻り
	$content .= "<CENTER><A href=\"$script\">確認</A></CENTER>\n";

	# フッター出力
	&footer;

	# 画面出力
	&c_print;
}

#------------------------------------------------------------------------------
# 検索フォーム（i-mode、J-Sky、ドットi）
#------------------------------------------------------------------------------
sub c_sform {
	# ヘッダー出力
	$headtype = 0;
	&header;

	# フォーマットの指定
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

	# 表示の中央寄せ
	$content .= "<CENTER>\n";

	# タイトル
	$content .= "｢記事の検索｣<BR>\n";

	# 注意書き
	$content .= "複数文字列は<BR>\n";
	$content .= "スペース区切<BR>\n";

	# J-Sky(ステーション非対応機)はGETのみ対応なのでMETHODを変更
	if ($agent == 3) { $method = 'GET'; }

	# フォームの開始
	$content .= "<FORM action=\"$script\" method=\"$method\">\n";
	$content .= "<INPUT type=\"hidden\" name=\"mode\" value=\"seek\">\n";

	# 検索条件指定
	$content .= "<INPUT type=\"radio\" name=\"cond\" value=\"and\" CHECKED>";
	$content .= "and検索<BR>\n";
	$content .= "<INPUT type=\"radio\" name=\"cond\" value=\"or\">";
	$content .= "or 検索<BR>\n";

	# 検索文字列入力
	$content .= "検索文字列　　";
	if ($agent != 3) { $content .= "　"; }
	$content .= "<BR>\n";
	$content .= "<INPUT type=\"text\" name=\"string\" size=\"$size\" $alpha><BR>\n";

	# 検索／取消ボタン
	$content .= "<INPUT type=\"submit\" value=\"検索\">\n";
	$content .= "<INPUT type=\"reset\" value=\"取消\"><BR>\n";

	# フォームタグ終わり
	$content .= "</FORM>\n";

	# 表示の中央寄せ終わり
	$content .= "</CENTER>\n";

	# フッター出力
	&footer;

	# 画面出力
	&c_print;
}

#------------------------------------------------------------------------------
# 検索結果表示（i-mode、J-Sky、ドットi）
#------------------------------------------------------------------------------
sub c_sview {
	# ヘッダー表示
	$headtype = 0;
	&header;

	# 時間の取得
	&get_time;

	# 変数の初期設定
	$num     = 0;				# 記事数
	$num_max = @new;			# 投票記事数
	$num_p   = 0;				# ページカウント(通し)
	$num_peg = 1;				# ページカウント
	$page    = $in{'page'};		# ページ指定

	# ページの指定が無い場合は、最初のページを表示
	if ($page eq "") { $page = 1; }

	# 検索結果総数表示
	$content .= "<CENTER>";
	$content .= "一致：$num_max件<BR>\n";

	# ページ数を計算
	$page_max = int($num_max / $cmax_line);
	if (($page_max * $cmax_line) < $num_max) { $page_max++; }

	# ページ表示
	if ($page_max > 1) { $content .= "$page／$page_max頁<BR>\n"; }
	$content .= "</CENTER>";

	# 検索文字列
	$content .= "<HR>\n";
	$content .= "$strings\n";
	$content .= "<HR>\n";

	while ($num < $num_max) {
		# ページめくり
		if ($num_p == $cmax_line) {
			$num_p = 0;
			$num_peg++;
		}
		$num_p++;

		if ($num_peg == $page) {
			# 各行を分割し、配列に格納
			@column = split(/<>/,$new[$num]);

			# 個別表示へのリンク
			$dest = "$script?mode=view";	# モード指定
			$dest .= "\&amp;num=$column[0]";	# 記事指定
			$content .= "<A href=\"$dest\">";

			# 新着記事チェック
			if (($times - $column[13]) < $new_time * 3600) {
				$content .= "$new_mark";
			} else {
				$content .= "$top_mark";
			}

			# 文字短縮処理
			$column[4] =~ s/(....)(.*)/$1 /;
			$column[5] =~ s/(........)(.*)/$1 /;

			# 記事表示
			$content .= "$column[5]$column[4]</A><BR>\n";
		}
		$num++;
	}

	# 中央揃え
	$content .= "<CENTER>\n";

	# 記事がない場合の処理
	if ($num == 0) { $content .= "一致記事無し<BR>\n"; }

	# ページ移動
	if ($num_peg != 1) {
		$dest = "$script?mode=seek";	# モード指定
		$dest .= "\&amp;cond=$cond";		# 検索条件
		$dest .= "\&amp;string=$strings";	# 検索文字列
		if ($page != 1) {
			$prev = $page - 1;
			$pdest = "$dest" . "\&amp;page=$prev";	# ページ指定
			$content .= "[<A href=\"$pdest\">前</A>]";
		} else { $content .= "[　]"; }
		if ($page != $num_peg) {
			$next = $page + 1;
			$ndest = "$dest" . "\&amp;page=$next";	# ページ指定
			$content .= "[<A href=\"$ndest\">次</A>]";
		} else { $content .= "[　]"; }
	} else { $content .= "[　][　]"; }
	$content .= "[　]";

	# 戻り
	$content .= "[<A href=\"$script\">戻</A>]";

	# 中央揃え
	$content .= "</CENTER>\n";

	# フッター表示
	&footer;

	# 画面出力
	&c_print;
}

#------------------------------------------------------------------------------
# 親記事リスト表示（i-mode、J-Sky、ドットi）
#------------------------------------------------------------------------------
sub c_list {
	# ヘッダー表示
	$headtype = 0;
	&header;

	# 時間の取得
	&get_time;

	# ログファイルをオープンする
	open (IN,"$logfile") || &error (open_er);
	@line = <IN>;
	close(IN);
	
	# 変数の初期設定
	$count   = shift(@line);	# ログカウントを分離
	$num     = 0;				# 記事数
	$num_max = @line;			# 投票記事数
	$num_p   = 0;				# ページのカウント(通し)
	$num_pag = 1;				# ページのカウント
	$tpage   = $in{'tpage'};	# ページ指定
	$num_c   = 0;				# ツリー記事数カウント
	$new_chk = 0;				# 新着記事のチェック

	# ページ指定のない場合は始めのページにする。
	if ($tpage eq "") { $tpage = 1; }

	# タイトル表示
	$content .= "<CENTER>｢親記事リスト｣</CENTER>";

	# 親記事の表示ループ
	while ($num <= $num_max) {
		# 各行を分割し、配列に格納
		@column = split(/<>/,$line[$num]);

		# 親記事チェック
		if ($column[0] == $column[1]) {
			# ページ一致チェック
			if (($num_pag == $tpage) && ($head ne "")) {
				if ($num_c == 1) {
					$dest = "$script?mode=view";	# モード指定
					$dest .= "\&amp;num=$head";			# 記事指定
					$dest .= "\&amp;only=yes";			# 個別記事指定
				} else {
					$dest = "$script?mode=tree";	# モード指定
					$dest .= "\&amp;tree=$head";		# ツリー指定
					$dest .= "\&amp;tpage=$tpage";		# 親記事リストページ保存
				}
				$content .= "<A href=\"$dest\">";
				if ($new_chk) { $content .= "$new_mark"; }
				if (!$new_chk) { $content .= "$top_mark"; }

				if (!$list_view_mode) {				
					if ($chtml_by) { $content .= " $num_c件 $dai by $name"; }
					if (!$chtml_by) { $content .= " $num_c件 $dai"; }
				}
				if ($list_view_mode) {
					if ($chtml_by) { $content .= " $dai($num_c) by $name $date$time"; }
					if (!$chtml_by) { $content .= " $dai($num_c) $date$time"; }
				}

				

				$content .= "</A><BR>\n";
			}

			# 親記事の表示項目を保存
			$head = $column[0];	# 親記事番号
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
			$dai  = $column[5];	# 親記事題名
			$name  = $column[4];	# 親記事投稿者名

			# 各値の初期化
			$new_chk = 0;	# 新着記事チェッククリア
			$num_c = 0;		# ツリー記事数カウントクリア

			# ページめくり
			if ($num_p == $cmax_line) {
				$num_p = 0;
				$num_pag++;
			}
			$num_p++;
		}

		# 新着記事チェック
		if (($times - $column[13]) < $new_time * 3600) {
			$new_chk = 1;
		}
		$num_c++;
		$num++;
	}

	# 記事がない場合の処理
	if ($num == 0) { $content .= "投稿記事無し<BR>\n"; }

	# 中央寄せ
	$content .= "<CENTER>";

	# ページ表示
	if ($num_pag != 1) {
		$dest = "$script?mode=list";	# モード指定
		# 前ページ
		if ($tpage != 1) {
			$prev = $tpage - 1;
			$pdest = "$dest"."\&amp;tpage=$prev";	# ページ指定
			$content .= "[<A HREF=\"$pdest\">前</A>/";
		} else { $content .= "[　/"; }
		# 次ページ
		if ($num_pag != $tpage) {
			$next = $tpage + 1;
			$ndest = "$dest"."\&amp;tpage=$next";	# ページ指定
			$content .= "<A HREF=\"$ndest\">次</A>/";
		} else { $content .= "　/"; }
	} else { $content .= "[　/　/"; }
	$content .= "　/";

	# 戻り
	$content .= "<A href=\"$script?mode=menu\">ﾒﾆｭｰ</A>/<A href=\"$script?mode=form\">新規</A>]";

	# 中央寄せ終わり
	$content .= "</CENTER>";

	# フッター表示
	&footer;
	&c_print;
}

#------------------------------------------------------------------------------
# 個別ツリー表示（i-mode、J-Sky、ドットi）
#------------------------------------------------------------------------------
sub c_tree {
	# ヘッダー表示
	$headtype = 0;
	&header;

	# ログファイルをオープンする
	open (IN,"$logfile") || &error (open_er);
	@line = <IN>;
	close(IN);
	
	# 変数の初期設定
	$count   = shift(@line);	# ログカウントを分離
	$num     = 0;				# 記事数
	$num_max = @line;			# 投票記事数
	$num_p   = 0;				# ページのカウント(通し)
	$num_pag = 1;				# ページのカウント
	$tpage   = $in{'tpage'};	# 親記事リストページ保存
	$page    = $in{'page'};		# ツリーページ指定

	# ページ指定のない場合は始めのページにする。
	if ($page eq "") { $page = 1; }

	# タイトル表示
	$content .= "<CENTER>｢個別ツリー｣</CENTER>";

	# 表示ツリー指定
	$tree = $in{'tree'};
	foreach $lin (@line) {
		# 各行を分割し、配列に格納
		@column = split(/<>/,$lin);
		if ($column[1] == $tree) {
			if ($column[16] eq "1"){
			$stopchk = "1";
			}
			# ページめくり
			if ($num_p == $cmax_line) {
				$num_p = 0;
				$num_pag++;
			}
			$num_p++;

			# 題名補完機能
			if ($column[0] == $column[1]) {
				$dai_tmp = "RE:column[5]";
			}

			# ページチェック
			if ($num_pag == $page) {
				# 個別表示へのリンク
				$dest = "$script?mode=view";	# モード指定
				$dest .= "\&amp;num=$column[0]";	# 記事指定

				$content .= "<A HREF=\"$dest\">";
				if ($column[0] == $column[1]) {
					$content .= "$top_mark";
				} else {
					if ($flag != 1) { $flag = 1; }
					$content .= "$res_mark";
				}

				# 題名補完機能
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
		$content .= "レス記事無し<BR>";
	}

	# 中央寄せ
	$content .= "<CENTER>";

	# ページ表示
	if ($num_pag != 1) {
		$dest = "$script?mode=tree";	# モード指定
		$dest .= "\&amp;tree=$tree";		# 親記事指定
		$dest .= "\&amp;tpage=$tpage";		# 親記事リストページ保存
		# 前ページ
		if ($page != 1) {
			$prev = $page - 1;
			$pdest = "$dest"."\&amp;page=$prev";	# ページ指定
			$content .= "[<A HREF=\"$pdest\">前</A>/";
		} else { $content .= "[　/"; }
		# 次ページ
		if ($num_pag != $page) {
			$next = $page + 1;
			$ndest = "$dest"."\&amp;page=$next";	# ページ指定
			$content .= "<A HREF=\"$ndest\">次</A>/";
		} else { $content .= "　/"; }
	} else { $content .= "[　/　/"; }
	# レス
	if (!$stopchk){
		$dest = "$script?mode=form\&amp;res=$tree";	# レス記事の指定
		$content .= "<A HREF=\"$dest\">返</A>/";
	}else{
		$content .= "　/";
	}
	# 戻り
	$content .= "<A href=\"$script\">戻</A>]";

	# 中央寄せ終わり
	$content .= "</CENTER>";

	# フッター表示
	&footer;
	&c_print;
}

#------------------------------------------------------------------------------
# 個別表示（i-mode、J-Sky、ドットi）
#------------------------------------------------------------------------------
sub c_view {
	# ヘッダー出力
	$headtype = 0;
	&header;

	# 時間の取得
	&get_time;

	# ログファイルをオープンする
	open (IN,"$logfile") || &error (open_er);
	@line = <IN>;
	close(IN);
	
	$count = shift(@line);	# ログカウントを分離

	# 記事番号の記事を探す
	foreach $col (@line) {
		@column = split(/<>/,$col);	# 表示行を分解
		if ($column[0] == $in{'num'}) { last; }
	}

	# 内容の表示
	$content .= "<CENTER>\n";
	$content .= "記事 No.$column[0]<BR>\n";		# 記事番号
	$content .= "｢$column[5]｣<BR>\n";			# 題名
	$content .= "$column[4]\n";					# 投稿者
	$content .= "</CENTER>\n";
	$content .= "<HR>\n";
	if ($autolink) { &autolink( $column[6] ); }	# 自動リンク機能
	$content .= "$column[6]\n";					# 記事

	# 仕切線
	$content .= "<HR>\n";

	# 中央揃え
	$content .= "<CENTER>\n";
	$content .= "$column[2] $column[3]<BR>\n";	# 投稿日時

	# 仕切線
	$content .= "<HR>\n";

	# 中央揃え
	$content .= "<CENTER>\n";
	$content .= "「$column[9]」<BR>\n";	# 端末

	# メール表示
	if ($column[7] ne "") {
		$content .= "[<A href=\"mailto:$column[7]\">$mail_mark</A>/";
	} else { $content .= "[　/"; }

	# ホーム表示
	if ($column[8] ne "") {
		&autolink( $column[8] );
		$content .= "$column[8]/";
	} else { $content .= "　/"; }

	# 削除
	$dest = "$script?mode=dform";		# モード指定
	$dest .= "\&amp;num=$column[0]";		# 記事番号指定
	$content .= "<A href=\"$dest\">削</A>/";

	if ($in{'only'} && $column[16] ne "1"){
		# レス
		$dest = "$script?mode=form\&amp;res=$column[0]";	# レス記事の指定
		$content .= "<A HREF=\"$dest\">返</A>]";
	} else {
		# 戻り
		$content .= "<A href=\"$script\">戻</A>]";
	}

	# 中央揃え終わり
	$content .= "</CENTER>\n";

	# フッター表示
	&footer;
	&c_print;
}

#------------------------------------------------------------------------------
# 削除フォーム（i-mode、J-Sky、ドットi）
#------------------------------------------------------------------------------
sub c_dform {
	# ヘッダー出力
	$headtype = 0;
	&header;

	# クッキー取得
	if ($use_cookie) { &get_cookie; }

	# フォーマットの指定
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

	# タイトル
	$content .= "<CENTER>｢記事の削除｣<BR>\n";

	# 説明
	$content .= "両項目を入力後<BR>\n";
	$content .= "削除ボタン押す<BR>\n";

	# J-Sky(ステーション非対応機)はGETのみ対応なのでMETHODを変更
	if ($agent == 3) { $method = 'GET'; }

	# フォームの開始
	$content .= "<FORM action=\"$script\" method=\"$method\">\n";
	$content .= "<INPUT type=\"hidden\" name=\"func\" value=\"del\">\n";

	# 記事番号指定
	$content .= "記事 No";
	$content .= "<INPUT type=\"text\" name=\"num\" value=\"$in{'num'}\" size=\"$sizea\" $number><BR>\n";

	# 削除パスワード入力
	$content .= "$key_mark";
	$content .= "<INPUT type=\"$password\" value=\"$c_dpas\" size=\"$sizeb\" name=\"dpas\">\n";

	# 削除／取消ボタン
	$content .= "<INPUT type=\"submit\" value=\"削除\">\n";
	$content .= "<INPUT type=\"reset\" value=\"取消\">\n";
	$content .= "</CENTER>\n";

	# フォームタグ終わり
	$content .= "</FORM>\n";

	# フッター出力
	&footer;

	# 画面出力
	&c_print;
}

#------------------------------------------------------------------------------
# 冒頭画面（i-mode、J-Sky、ドットi）
#------------------------------------------------------------------------------
sub c_title {
	# ヘッダー出力
	$headtype = 0;
	&header;

	# タイトル表示
	if ($c_img) {
		$content .= "<CENTER><img SRC=\"$c_img\" ALT=\"[$c_title]\"><BR>\n";
	} else {
		$content .= "<CENTER>｢$c_title｣<BR>\n";
	}

	# オプション名指定
	if ($agent =~ /2|4/) {
		# 項目表示
		$content .= "<A href=\"$script?mode=list\" accesskey=\"1\">";
		$content .= "$one_markツリー表\示</A><BR>\n";
		$content .= "<A href=\"$script?mode=form\" accesskey=\"2\">";
		$content .= "$two_mark新規書込み</A><BR>\n";
		$content .= "<A href=\"$script?mode=sform\" accesskey=\"3\">";
		$content .= "$three_mark記事の検索</A><BR>\n";
		$content .= "<A href=\"$script?mode=dform\" accesskey=\"4\">";
		$content .= "$four_mark記事の削除</A><BR>\n";

		# ヘルプファイルがある場合、説明項目を表示
		if ($c_help) {
			$content .= "<A href=\"$c_help\" accesskey=\"5\">";
			$content .= "$five_mark使い方説明</A><BR>\n";
		}

		# 著作権表示ファイルがある場合表示
		if ($c_own) {
			$content .= "<A href=\"$c_own\" accesskey=\"6\">";
			$content .= "$five_mark著作権表\示</A><BR>\n";
		}

		# ホームがある場合、戻り項目を表示
		if ($c_home) {
			$content .= "<A href=\"$c_home\" accesskey=\"0\">";
			$content .= "$zero_markＨＰへ戻る</A><BR>\n";
		}
	}
	if ($agent == 3) {
		# 項目表示
		$content .= "<A href=\"$script?mode=list\" directkey=\"1\">";
		$content .= "ツリー表\示</A><BR>\n";
		$content .= "<A href=\"$script?mode=form\" directkey=\"2\">";
		$content .= "新規書込み</A><BR>\n";
		$content .= "<A href=\"$script?mode=sform\" directkey=\"3\">";
		$content .= "記事の検索</A><BR>\n";
		$content .= "<A href=\"$script?mode=dform\" directkey=\"4\">";
		$content .= "記事の削除</A><BR>\n";

		# ヘルプファイルがある場合、説明項目を表示
		if ($c_help) {
			$content .= "<A href=\"$c_help\" directkey=\"5\">";
			$content .= "使い方説明</A><BR>\n";
		}

		# 著作権表示ファイルがある場合表示
		if ($c_own) {
			$content .= "<A href=\"$c_own\" directkey=\"6\">";
			$content .= "著作権表\示</A><BR>\n";
		}

		# ホームがある場合、戻り項目を表示
		if ($c_home) {
			$content .= "<A href=\"$c_home\" directkey=\"0\">";
			$content .= "ＨＰへ戻る</A><BR>\n";
		}
	}

	# フッター出力
	&footer;
	&c_print;
}

#------------------------------------------------------------------------------
# i-mode、J-Sky、ドットi用出力サブルーチン
# (注)i-modeでは、Content-lengthがHTTPヘッダに無くてはならない
#------------------------------------------------------------------------------
sub c_print {
		$len = length($content);
		print "Content-type: text/html\n";
		print "Content-length: $len\n\n";
		print $content;
		exit;
}



1;
