# xh.lib v1.501 - 001 05.09.09
#------------------------------------------------------------------------------
# 投稿フォーム（xhtml）
#------------------------------------------------------------------------------
sub x_form {
	# ヘッダー出力
	$headtype = 1;
	&header;

	# クッキー取得
	if ($use_cookie) { &get_user_data; }
	$c_url = "http://" . $c_url;

	# フォームタグ
	$content .= "<form action=\"$script\" method=\"$method\">\n";
	$content .= "<input type=\"hidden\" name=\"mode\" value=\"write\" />\n";

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
		$content .= "<input type=\"hidden\" name=\"res\" value=\"$in{'res'}\">\n";
		$content .= "｢No.$in{'res'}へのレス書込み｣<br />\n";
	} else {
		$content .= "｢新規書込み｣<br />\n";
	}

	

	# フォーマットの指定
	$kana = 'format="*M"';
	$alpha = 'format="*m"';
	$password = 'password';
	$passal = 'format="*x"';
	$sizea = 12;
	$sizeb = 14;
	$sizec = 16;


	# 名前入力
	$content .= "名前\n";
	$content .= "<input type=\"text\" name=\"name\" value=\"$c_name\" size=\"$sizea\" $kana>";
	$content .= "<br />\n";

	# 題名入力
	$content .= "題名\n";
	$content .= "<input type=\"text\" name=\"dai\" value=\"$res_dai\" size=\"$sizea\" $kana>";
	$content .= "<br />\n";

	# 本文入力
	$content .= "本文\n";
	$content .= "<textarea name=\"msg\" cols=\"$sizec\" rows=\"2\" $kana>";
	$content .= "</textarea><br />\n";

	# メールアドレス入力
	$content .= "$mail_mark";
	$content .= "<input type=\"text\" name=\"mail\" value=\"$c_mail\" size=\"$sizeb\" maxlength=\"100\" $alpha>";
	$content .= "<br />\n";

	# ホームページアドレス入力
	$content .= "$home_mark";
	$content .= "<input type=\"text\" name=\"url\" value=\"$c_url\" size=\"$sizeb\" maxlength=\"100\"  $alpha>";
	$content .= "<br />\n";

	# 削除パスワード入力
	$content .= "$key_mark";
	$content .= "<input type=\"$password\" name=\"dpas\" size=\"$sizeb\" value=\"$c_dpas\" $passal>";
	$content .= "<br />\n";

	# 投稿／取消ボタン
	$content .= "<center>\n";
	$content .= "<input type=\"submit\" value=\"投稿\">\n";
	$content .= "<input type=\"reset\" value=\"取消\">\n";
	$content .= "</center>\n";

	# フォームタグ終わり
	$content .= "</form>\n";

	# フッター出力
	&footer;

	# 画面出力
	
}

#------------------------------------------------------------------------------
# 書込み確認（xhtml）
#------------------------------------------------------------------------------
sub x_write {
	# ヘッダー出力
	$headtype = 0;
	&header;

	# 特別メニュー
	$content .= "<wml:do type=\"ACCEPT\" label=\"確認\">\n";
	$content .= "<go href=\"$script\" />\n";
	$content .= "</wml:do>\n";

	# 内容の表示
	$content .= "<center>";
	$content .= "確認\n";
	$content .= "No$new";					# 記事番号
	# メール表示
	if ($in{'res'} ne "") {
		$content .= "No.$in{'res'}へのレス\n";
	}
	$content .= "</center>\n";
	$content .= "題名:$dai<br />\n";			# 題名
	$content .= "名前:$name\n";				# 名前
	$content .= "<hr />\n";					# 仕切り線
	if ($autolink) { &autolink( $msg ); }	# 自動リンク機能
	$content .= "$msg\n";					# 記事
	$content .= "<hr />\n";					# 仕切り線

	$content .= "「$agent_name」\n";			# 端末表示

	# メール表示
	if ($in{'mail'} ne "") {
		$content .= "$mail_mark<br />$in{'mail'}<br />\n";
	}

	# ホーム表示
	if ($in{'url'} ne "") {
		$content .= "$home_mark<br />$in{'url'}<br />\n";
	}

	# 戻り
	$content .= "<center><a href=\"$script\" title=\"確認\">確認</a></center>\n";

	# フッター出力
	&footer;

	# 画面出力
	
}

#------------------------------------------------------------------------------
# 検索フォーム（xhtml）
#------------------------------------------------------------------------------
sub x_sform {
	# ヘッダー出力
	$headtype = 1;
	&header;

	# フォーマットの指定
	$alpha = 'format="*M"';
	$size = 16;

	# タイトル
	$content .= "｢記事の検索｣<br />\n";

	# 注意書き
	$content .= "複数文字列はスペース区切<br />\n";

	# フォームの開始
	$content .= "<form action=\"$script\" method=\"$method\">\n";
	$content .= "<input type=\"hidden\" name=\"mode\" value=\"seek\">\n";

	# 検索条件指定
	$content .= "<input type=\"radio\" name=\"cond\" value=\"and\" CHECKED>";
	$content .= "and検索<br />\n";
	$content .= "<input type=\"radio\" name=\"cond\" value=\"or\">";
	$content .= "or 検索<br />\n";

	# 検索文字列入力
	$content .= "検索文字列　　";
	$content .= "　";
	$content .= "<br />\n";
	$content .= "<input type=\"text\" name=\"string\" size=\"$size\" $alpha><br />\n";

	# 検索／取消ボタン
	$content .= "<input type=\"submit\" value=\"検索\">\n";
	$content .= "<input type=\"reset\" value=\"取消\"><br />\n";

	# フォームタグ終わり
	$content .= "</form>\n";

	# フッター出力
	&footer;

	# 画面出力
	
}

#------------------------------------------------------------------------------
# 検索結果表示（xhtml）
#------------------------------------------------------------------------------
sub x_sview {
	# ヘッダー表示
	$headtype = 1;
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
	$content .= "<center>";
	$content .= "一致：$num_max件<br />\n";

	# 文字数調整
	if ($cmax_line < ($text_y - 6)){ $cmax_line = ($text_y - 6 ) ;}

	# ページ数を計算
	$page_max = int($num_max / $cmax_line);
	if (($page_max * $cmax_line) < $num_max) { $page_max++; }

	# ページ表示
	if ($page_max > 1) { $content .= "$page／$page_max頁<br />\n"; }
	$content .= "</center>";

	# 検索文字列
	$content .= "<hr />\n";
	$content .= "$strings\n";
	$content .= "<hr />\n";

	$listcount = "1";

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
			$content .= "<p mode=\"nowrap\"><a href=\"$dest\" accesskey=\"$listcount\" title=\"読む\">";

			# 新着記事チェック
			if (($times - $column[13]) < $new_time * 3600) {
				$content .= "$new_mark";
			} else {
				$content .= "$top_mark";
			}

			# 文字短縮処理
			$column[4] =~ s/(.{$text_x})(.*)/$1 /;
			$column[5] =~ s/(.{$text_x})(.*)/$1 /;

			# 記事表示
			$content .= "$column[5] by $column[4]</a></p>\n";

			$listcount = $listcount + 1;

		}
		$num++;
	}

	# 記事がない場合の処理
	if ($num == 0) { $content .= "一致記事無し<br />\n"; }


	$content .= "<hr /><br />\n";

	# ページ移動
	if ($num_peg != 1) {
		$dest = "$script?mode=seek";	# モード指定
		$dest .= "\&cond=$cond";		# 検索条件
		$dest .= "\&string=$strings";	# 検索文字列
		if ($page != 1) {
			$prev = $page - 1;
			$pdest = "$dest" . "\&page=$prev";	# ページ指定

		# 特別メニュー
		$content .= "<wml:do type=\"SOFT3\" label=\"前へ\">\n";
		$content .= "<go href=\"$pdest\" />\n";
		$content .= "</wml:do>\n";
		}

		if ($page != $num_peg) {
			$next = $page + 1;
			$ndest = "$dest" . "\&page=$next";	# ページ指定

		# 特別メニュー
		$content .= "<wml:do type=\"SOFT4\" label=\"次へ\">\n";
		$content .= "<go href=\"$ndest\" />\n";
		$content .= "</wml:do>\n";

		}
	}

	# 特別メニュー
	$content .= "<wml:do type=\"SOFT5\" label=\"戻る\">\n";
	$content .= "<go href=\"$script\" />\n";
	$content .= "</wml:do>\n";

	# 特別メニュー
	$content .= "<wml:do type=\"ACCEPT\" label=\"戻る\">\n";
	$content .= "<go href=\"$script\" />\n";
	$content .= "</wml:do>\n";

	# フッター表示
	&footer;

	# 画面出力
	
}

#------------------------------------------------------------------------------
# 親記事リスト表示（xhtml）
#------------------------------------------------------------------------------
sub x_list {
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

	# 文字数調整
	if ($cmax_line < ($text_y - 2)){ $cmax_line = ($text_y - 2 ) ;}

	# タイトル表示
	$content .= "<center>｢親記事リスト｣</center>\n";

	$listcount = "1";
	$list_ico = "180";
	
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

				if ($listcount == 10){$listcount = "0";}
				if ($list_ico == 189){$list_ico = "325";}

				$content .= "<p mode=\"nowrap\"><a href=\"$dest\" accesskey=\"$listcount\" title=\"読む\"><img localsrc=\"$list_ico\"> ";
				if ($new_chk) { $content .= "$new_mark"; }
				if (!$new_chk) { $content .= "$top_mark"; }

				if (!$list_view_mode) {				
					if ($xhtml_by) { $content .= " $num_c件 $dai by $name"; }
					if (!$xhtml_by) { $content .= " $num_c件 $dai"; }
				}
				if ($list_view_mode) {
					if ($xhtml_by) { $content .= " $dai($num_c) by $name $date$time"; }
					if (!$xhtml_by) { $content .= " $dai($num_c) $date$time"; }
				}

				$content .= "</a></p>\n";
				$listcount = $listcount + 1;
				$list_ico = $list_ico + 1;
			}

			# 親記事の表示項目を保存
			$head = $column[0];	# 親記事番号
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
	if ($num == 0) { $content .= "投稿記事無し<br />\n"; }

	# ページ表示
	if ($num_pag != 1) {
		$dest = "$script?mode=list";	# モード指定
		# 次ページ
		if ($num_pag != $tpage) {
			$next = $tpage + 1;
			$ndest = "$dest"."\&amp;tpage=$next";	# ページ指定
			# 特別メニュー
			$content .= "<wml:do type=\"SOFT3\" label=\"次へ\">\n";
			$content .= "<go href=\"$ndest\" />\n";
			$content .= "</wml:do>\n";
		}

		# 前ページ
		if ($tpage != 1) {
			$prev = $tpage - 1;
			$pdest = "$dest"."\&amp;tpage=$prev";	# ページ指定
			# 特別メニュー
			$content .= "<wml:do type=\"SOFT4\" label=\"前へ\">\n";
			$content .= "<go href=\"$pdest\" />\n";
			$content .= "</wml:do>\n";
		}
	}

	# 特別メニュー
	$content .= "<wml:do type=\"SOFT5\" label=\"リロード\">\n";
	$content .= "<go href=\"$script\" />\n";
	$content .= "</wml:do>\n";

	# 特別メニュー
	$content .= "<wml:do type=\"SOFT6\" label=\"HPに戻る\">\n";
	$content .= "<go href=\"$x_home\" />\n";
	$content .= "</wml:do>\n";

	# 特別メニュー
	$content .= "<wml:do type=\"ACCEPT\" label=\"ﾘﾛｰﾄﾞ\">\n";
	$content .= "<go href=\"$script\" />\n";
	$content .= "</wml:do>\n";

	# フッター表示
	&footer;
	
}

#------------------------------------------------------------------------------
# 個別ツリー表示（xhtml）
#------------------------------------------------------------------------------
sub x_tree {
	&get_time;
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

	# 文字数調整
	if ($cmax_line < ($text_y - 2)){ $cmax_line = ($text_y - 2 ) ;}

	# タイトル表示
	$content .= "<center>｢個別ツリー｣</center>\n";

	$listcount = "1";
	$list_ico = "180";

	# 表示ツリー指定
	$tree = $in{'tree'};
	foreach $lin (@line) {
		# 各行を分割し、配列に格納
		@column = split(/<>/,$lin);
		if ($column[1] == $tree) {
			# ページめくり
			if ($num_p == $cmax_line) {
				$num_p = 0;
				$num_pag++;
			}
			$num_p++;

			# 題名補完機能
			if ($column[0] == $column[1]) {
				$dai_tmp = "RE:$column[5]";
			}

			# ページチェック
			if ($num_pag == $page) {
				# 個別表示へのリンク
				$dest = "$script?mode=view";	# モード指定
				$dest .= "\&amp;num=$column[0]";	# 記事指定

				if ($listcount == 10){$listcount = "0";}
				if ($list_ico == 189){$list_ico = "325";}
				
				$content .= "<p mode=\"nowrap\"><a href=\"$dest\" accesskey=\"$listcount\" title=\"読む\"><img localsrc=\"$list_ico\"> ";

				# 親記事表示
				if ($column[0] == $column[1]) {
					if (($times - $column[13]) < $new_time * 3600) {
						$content .= "$new_mark";
					} else {
						$content .= "$top_mark";
					}
				# 子記事表示
				} else {
					$flag = 1;
					if (($times - $column[13]) < $new_time * 3600) {
						$content .= "$rnew_mark";
					} else {
						$content .= "$res_mark";
					}
				}

				# 題名補完機能
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
		$content .= "レス記事無し<br />";
	}


	# ページ表示
	if ($num_pag != 1) {
		$dest = "$script?mode=tree";	# モード指定
		$dest .= "\&amp;tree=$tree";		# 親記事指定
		$dest .= "\&amp;tpage=$tpage";		# 親記事リストページ保存
		# 次ページ
		if ($num_pag != $page) {
			$next = $page + 1;
			$ndest = "$dest"."\&amp;page=$next";	# ページ指定

			# 特別メニュー
			$content .= "<wml:do type=\"SOFT3\" label=\"次へ\">\n";
			$content .= "<go href=\"$ndest\" />\n";
			$content .= "</wml:do>\n";
		}
		# 前ページ
		if ($page != 1) {
			$prev = $page - 1;
			$pdest = "$dest"."\&amp;page=$prev";	# ページ指定

			# 特別メニュー
			$content .= "<wml:do type=\"SOFT4\" label=\"前へ\">\n";
			$content .= "<go href=\"$pdest\" />\n";
			$content .= "</wml:do>\n";
		}
	}

	# レス
	$dest = "$script?mode=form\&amp;res=$tree";	# レス記事の指定
	$content .= "<wml:do type=\"SOFT5\" label=\"レス\">\n";
	$content .= "<go href=\"$dest\" />\n";
	$content .= "</wml:do>\n";

	# 特別メニュー
	$content .= "<wml:do type=\"SOFT6\" label=\"戻る\">\n";
	$content .= "<go href=\"$script\" />\n";
	$content .= "</wml:do>\n";

	# 特別メニュー
	$content .= "<wml:do type=\"ACCEPT\" label=\"戻る\">\n";
	$content .= "<go href=\"$script\" />\n";
	$content .= "</wml:do>\n";

	# フッター表示
	&footer;
	
}

#------------------------------------------------------------------------------
# 個別表示（xhtml）
#------------------------------------------------------------------------------
sub x_view {
	# ヘッダー出力
	$headtype = 1;
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

	# 本文の<BR>を変換
	$column[5] =~ s/<BR//g;
	$column[5] =~ s/<//g;
	$column[5] =~ s/>//g;
	$column[6] =~ s/<BR>/<br \/>/g;

	# 内容の表示
	$content .= "<center>\n";
	$content .= "記事 No.$column[0]<br />\n";		# 記事番号
	$content .= "｢$column[5]｣<br />\n";			# 題名
	$content .= "$column[4]\n";					# 投稿者
	$content .= "</center>\n";
	$content .= "<hr />\n";
	if ($autolink) { &autolink( $column[6] ); }	# 自動リンク機能
	$content .= "$column[6]\n";					# 記事

	# 仕切線
	$content .= "<hr />\n";

	# 中央揃え
	$content .= "<center>\n";

	$content .= "$column[2] $column[3]<br />\n";	# 投稿日時

	# 仕切線
	$content .= "<hr />\n";

	# 中央揃え
	$content .= "<center>\n";

	$content .= "「$column[9]」<br />\n";	# 端末

	# メール表示
	if ($column[7] ne "") {
		$content .= "[<a href=\"mailto:$column[7]\" title=\"mail\">$mail_mark</a>/";
	} else { $content .= "[　/"; }

	# ホーム表示
	if ($column[8] ne "") {
		&autolink( $column[8] );
		$content .= "$column[8]/";
	} else { $content .= "　/"; }

	# 削除
	$dest = "$script?mode=dform";		# モード指定
	$dest .= "\&num=$column[0]";		# 記事番号指定
	$content .= "<a href=\"$dest\" title=\"削除\">削</a>/";

	# レス
	$dest = "$script?mode=form\&res=$column[1]";	# レス記事の指定
	$content .= "<a href=\"$dest\" title=\"返信\">返</a>/";

	# 戻り
	$content .= "<a href=\"$script\" title=\"戻る\">戻</a>]";

	# 中央揃え終わり
	$content .= "</center>\n";

	# フッター表示
	&footer;
	
}

#------------------------------------------------------------------------------
# 削除フォーム（xhtml）
#------------------------------------------------------------------------------
sub x_dform {
	# ヘッダー出力
	$headtype = 1;
	&header;

	# クッキー取得
	if ($use_cookie) { &get_cookie; }

	$number = 'format="*N"';
	$password = 'password';
	$passal = 'format="*x"';
	$sizea = 9;
	$sizeb = 14;

	# タイトル
	$content .= "<center>｢記事の削除｣<br />\n";

	# 説明
	$content .= "両項目を入力後<br />\n";
	$content .= "削除ボタン押す<br />\n";

	# フォームの開始
	$content .= "<form action=\"$script\" method=\"$method\">\n";
	$content .= "<input type=\"hidden\" name=\"func\" value=\"delete\">\n";

	# 記事番号指定
	$content .= "記事 No";
	$content .= "<input type=\"text\" name=\"num\" value=\"$in{'num'}\" size=\"$sizea\" $number><br />\n";

	# 削除パスワード入力
	$content .= "$key_mark";
	$content .= "<input type=\"$password\" value=\"$c_dpas\" size=\"$sizeb\" name=\"dpas\" $passal>\n";

	# 削除／取消ボタン
	$content .= "<input type=\"submit\" value=\"削除\">\n";
	$content .= "<input type=\"reset\" value=\"取消\">\n";
	$content .= "</center>\n";

	# フォームタグ終わり
	$content .= "</form>\n";

	# フッター出力
	&footer;

	# 画面出力
	
}

#------------------------------------------------------------------------------
# 冒頭画面（xhtml）
#------------------------------------------------------------------------------
sub x_title {
	# ヘッダー出力
	$headtype = 1;
	&header;

	# タイトル表示
	if ($x_img) {
		$content .= "<img src=\"$x_img\" alt=\"[$x_title]\"><br />\n";
	} else {
		$content .= "｢$x_title｣<br />\n";
	}

	# オプション名指定
	# 項目表示
	$content .= "$one_mark<a href=\"$script?mode=list\" accesskey=\"1\" title=\"tree\">ツリー表\示</a><br />\n";
	$content .= "$two_mark<a href=\"$script?mode=form\" accesskey=\"2\" title=\"新規\">新規書込み</a><br />\n";
	$content .= "$three_mark<a href=\"$script?mode=sform\" accesskey=\"3\" title=\"検索\">記事の検索</a><br />\n";
	$content .= "$four_mark<a href=\"$script?mode=dform\" accesskey=\"4\" title=\"削除\">記事の削除</a><br />\n";

	# ヘルプファイルがある場合、説明項目を表示
	if ($x_help) {
		$content .= "$five_mark<a href=\"$x_help\" accesskey=\"7\" title=\"help\">使い方説明</a><br />\n";
	}

	# 著作権表示ファイルがある場合表示
	if ($x_own) {
		$content .= "$eight_mark<a href=\"$x_own\" accesskey=\"8\" title=\"(C)\">著作権表\示</a><br />\n";
	}

	# 管理者専用項目
	$content .= "$nine_mark<a href=\"$script?mode=check\" label=\"管理\" accesskey=\"9\" title=\"管理\">管理者専用</a><br />\n";

	# ホームがある場合、戻り項目を表示
	if ($x_home) {
		$content .= "$zero_mark<a href=\"$x_home\" accesskey=\"0\" title=\"戻る\">";
		$content .= "ＨＰへ戻る</a><br />\n";
	}

	# フッター出力
	&footer;
}


#------------------------------------------------------------------------------
# 管理フォーム（EZweb）
#------------------------------------------------------------------------------
sub x_admin {
	# ヘッダー表示
	$headtype = 1;
	&header;

	# 説明表示
	$content .= "<center>｢管理者機能\｣</center><br />\n";

	# 記事削除
	$dest = "$script?mode=ad_dform&amp;psw=$in{'psw'}";
	$content .= "<a href=\"$dest\" title=\"削除\">[記事削除処理]</a><br />\n";

	# パスワード変更
	$dest = "$script?mode=change&amp;psw=$in{'psw'}";
	$content .= "<a href=\"$dest\" title=\"変更\">[暗号変更処理]</a><br />\n";

	# 非適切語追加
	$dest = "$script?mode=aform&amp;psw=$in{'psw'}";
	$content .= "<a href=\"$dest\" title=\"追加\">[非適切語追加]</a><br />\n";

	# ログファイルをオープンする。
	open (IN,"$pswfile") || &error (open_er);
	@line = <IN>;
	close(IN);
	
	@column = split(/<>/,$line[1]);
	$num = $#column;

	# 非適切語削除
	if ($num) {
		$loop = 0;
		while ($loop < $num) {
			# 非適切語項目の表示
			$dest = "$script?mode=admin\&amp;func=del_word\&amp;loop=$loop&amp;psw=$in{'psw'}";
			$content .= "<a href=\"$dest\" title=\"削除\">削除-$column[$loop]<br />\n";
			$loop++;
		}
	}

	# フッター表示
	&footer;
	exit;
}

#------------------------------------------------------------------------------
# 非適切語追加フォーム（EZweb）
#------------------------------------------------------------------------------
sub x_aform {
	# ヘッダー表示
	$headtype = 1;
	&header;

	$content .= "<form action=\"$script\" method=\"$method\">\n";
	$content .= "<input type=\"hidden\" name=\"mode\" value=\"admin\">\n";
	$content .= "<input type=\"hidden\" name=\"func\" value=\"del_word\">\n";
	$content .= "<input type=\"hidden\" name=\"loop\" value=\"$loop\">\n";
	$content .= "<input type=\"submit\" value=\"削除\">\n";
	$content .= "</form>\n";

	# フッター表示
	&footer;
	exit;
}

#------------------------------------------------------------------------------
# パスワード変更フォーム（EZweb）
#------------------------------------------------------------------------------
sub x_pform {
	# ヘッダー表示
	$headtype = 1;
	&header;

	$content .= "<form action=\"$script\" method=\"$method\">\n";
	$content .= "<input type=\"hidden\" name=\"mode\" value=\"admin\">\n";
	$content .= "<input type=\"hidden\" name=\"func\" value=\"change\">\n";
	$content .= "新暗号\n";
	$content .= "$key_mark";
	$content .= "<input type=\"password\" name=\"pswa\" size=\"16\" format=\"*x\">";
	$content .= "<br />\n";
	$content .= "確認用\n";
	$content .= "<input type=\"password\" name=\"pswb\" size=\"16\" format=\"*x\"><br />\n";
	$content .= "<input type=\"submit\" value=\"変更\">\n";
	$content .= "<INPUT type=\"reset\" value=\"取消\">\n";
	$content .= "</form>\n";

	# フッター表示
	&footer;
	exit;
}

#------------------------------------------------------------------------------
# パスワード確認フォーム（EZweb）
#------------------------------------------------------------------------------
sub x_pass {
	# ヘッダー表示
	$headtype = 1;
	&header;

	# 入力テーブル
	$content .= "パスワードを入力し、決定ボタンを押してください。<BR>\n";
	# フォームタグ
	$content .= "<form action=\"$script\" method=\"$method\">\n";
	$content .= "<input type=\"hidden\" name=\"mode\" value=\"admin\">\n";
	$content .= "<input type=\"hidden\" name=\"func\" value=\"check\">\n";
	# パスワード入力
	$content .= "$key_mark";
	$content .= "<input type=\"password\" name=\"psw\" size=\"16\" format=\"*x\">";
	$content .= "<br />\n";
	$content .= "<input type=\"submit\" value=\"決定\">\n";
	$content .= "<input type=\"reset\" value=\"取消\">\n";
	$content .= "</form>\n";

	# フッター表示
	&footer;
	exit;
}

#------------------------------------------------------------------------------
# 管理者削除フォーム（EZweb）
#------------------------------------------------------------------------------
sub x_ad_dform {
	# ヘッダー表示
	$headtype = 1;
	&header;

	# フォームタグ
	$content .= "<form action=\"$script\" method=\"$method\">\n";
	$content .= "<input type=\"hidden\" name=\"mode\" value=\"admin\">\n";
	$content .= "<input type=\"hidden\" name=\"func\" value=\"delete\">\n";
	$content .= "<input name=\"num\" size=\"5\">\n";
	$content .= "<input type=\"hidden\" name=\"admin\" value=\"1\">\n";
	$content .= "<input type=\"submit\" value=\"削除\">\n";
	$content .= "</form>\n";

	# フッター表示
	&footer;
	exit;
}



1;
