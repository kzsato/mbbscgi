#------------------------------------------------------------------------------
# 投稿フォーム（EZweb）
#------------------------------------------------------------------------------
sub wap_form {
	# ヘッダー出力
	$headtype = 1;
	&header;

	# クッキー取得
	if ($use_cookie) { &get_cookie; }

	# URLのクッキー処理
	if ($url !~ /^http/) {
		$c_url = "http://" . $c_url;
	}

	# 投稿指定
	$dest = "$script?time=$times";	# URL+ダミー
	$data = "mode=write";			# モード指定
	$data .= "\&amp;name=\$name";		# 名前
	$data .= "\&amp;dai=\$dai";			# 題名
	$data .= "\&amp;msg=\$msg";			# 本文
	$data .= "\&amp;mail=\$mail";		# メールアドレス
	$data .= "\&amp;url=\$wurl";		# ホームページ
	$data .= "\&amp;dpas=\$dpas";		# 削除パスワード
	$data .= "\&amp;res=$in{'res'}";	# レス番号の指定

	$res_dai = "";
	if($in{'res'}){
		# レス元の文章を表示
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
	}

	if (($c_name) && ($c_ver == 1)) {
		$vars = "name=$c_name\&amp;dai=\&amp;msg=\&amp;mail=$c_mail\&amp;wurl=$c_url\&amp;dpas=$c_dpas";
	} else {
		$vars = "dai=\&amp;msg=";
	}

	# 事前処理
	$content .= "<NODISPLAY>\n";
	$content .= "<ACTION type=\"accept\" task=\"go\" dest=\"#form\" vars=\"$vars\">\n";
	$content .= "</NODISPLAY>\n";

	# 投稿フォーム出力
	$content .= "<CHOICE name=\"form\" method=\"$list_method\" title=\"$wap_title\" bookmark=\"$fscript\">\n";
	$content .= "<ACTION type=\"soft1\" task=\"go\" dest=\"$script\" label=\"戻る\">\n";
	$content .= "<CE task=\"go\" dest=\"#ename\" label=\"入力\" receive=\"name\">名前:\$name\n";
	$content .= "<CE task=\"go\" dest=\"#edai\" label=\"入力\" receive=\"dai\">題名:\$dai\n";
	$content .= "<CE task=\"go\" dest=\"#emsg\" label=\"入力\" receive=\"msg\">本文:\$msg\n";
	$content .= "<CE task=\"go\" dest=\"#email\" label=\"入力\" receive=\"mail\">mail:\$mail\n";
	$content .= "<CE task=\"go\" dest=\"#eurl\" label=\"入力\" receive=\"wurl\">URL :\$wurl\n";
	$content .= "<CE task=\"go\" dest=\"#epas\" label=\"入力\" receive=\"dpas\">暗号:\$dpas\n";
	$content .= "<CE task=\"go\" dest=\"$dest\" method=\"$method\" postdata=\"$data\" label=\"投稿\">投稿する\n";
	$content .= "</CHOICE>\n";

	# 名前入力
	$content .= "<ENTRY KEY=\"name\" name=\"ename\" title=\"$wap_title\" bookmark=\"$fscript\" DEFAULT=\"$c_name\">\n";
	$content .= "<ACTION type=\"accept\" task=\"go\" dest=\"#form\">\n";
	$content .= "お名前\n";
	$content .= "</ENTRY>\n";

	# 題名入力
	$content .= "<ENTRY KEY=\"dai\" name=\"edai\" title=\"$wap_title\" bookmark=\"$fscript\" DEFAULT=\"$res_dai\">\n";
	$content .= "<ACTION type=\"accept\" task=\"go\" dest=\"#form\">\n";
	$content .= "題名\n";
	$content .= "</ENTRY>\n";

	# 本文入力
	$content .= "<ENTRY KEY=\"msg\" name=\"emsg\" title=\"$wap_title\" bookmark=\"$fscript\">\n";
	$content .= "<ACTION type=\"accept\" task=\"go\" dest=\"#form\">\n";
	$content .= "本文\n";
	$content .= "</ENTRY>\n";

	# メールアドレス入力
	$content .= "<ENTRY KEY=\"mail\" name=\"email\" title=\"$wap_title\" bookmark=\"$fscript\" format=\"*x\" DEFAULT=\"$c_mail\">\n";
	$content .= "<ACTION type=\"accept\" task=\"go\" dest=\"#form\">\n";
	$content .= "メールアドレス\n";
	$content .= "</ENTRY>\n";

	# ホームページアドレス入力
	$content .= "<ENTRY KEY=\"wurl\" name=\"eurl\" title=\"$wap_title\" bookmark=\"$fscript\" format=\"*x\" DEFAULT=\"$c_url\">\n";
	$content .= "<ACTION type=\"accept\" task=\"go\" dest=\"#form\">\n";
	$content .= "ホームページ\n";
	$content .= "</ENTRY>\n";

	# 削除パスワード入力
	$content .= "<ENTRY KEY=\"dpas\" name=\"epas\" title=\"$wap_title\" bookmark=\"$fscript\" format=\"*x\" DEFAULT=\"$c_dpas\">\n";
	$content .= "<ACTION type=\"accept\" task=\"go\" dest=\"#form\">\n";
	$content .= "削除パスワード\n";
	$content .= "</ENTRY>\n";

	# フッター出力
	&footer;
}

#------------------------------------------------------------------------------
# 投稿確認（EZweb）
#------------------------------------------------------------------------------
sub wap_write {
	# ヘッダー出力
	$headtype = 0;

	# なんだかしらんがエラーするから特別対策（汗
#	$agent = 1;
	&header;

	$content .= "<DISPLAY name=\"written\" title=\"$wap_title\" bookmark=\"$fscript\">\n";
	$content .= "<ACTION type=\"accept\" task=\"go\" dest=\"$script\" label=\"確認\">\n";
	# 投稿番号表示
	$content .= "<CENTER>投稿完了 No.$new\n";

	# 題名/投稿者の表示
	# 全角７(半角14)文字以下なら中央揃え、それ以外はラインで表示
	$n_over = 0;
	$d_over = 0;
	if ($dai =~ /(..............)(.*)/) { $d_over = 1; }
	if ($name =~ /(..............)(.*)/) { $n_over = 1; }
	$dai =~ s/\$/\&\#36\;/g;
	$name =~ s/\$/\&\#36\;/g;

	# WARPや、LINEで改行してしまう為場合分けして表示
	if (($d_over) && ($n_over)) {
		$content .= "<LINE>\n";
		$content .= "｢$dai｣<BR>\n";
		$content .= "$name\n<WRAP>\n";
	} elsif (($d_over) && (!$n_over)) {
		$content .= "<LINE>\n";
		$content .= "｢$dai｣\n<WRAP>\n";
		$content .= "<CENTER>$name<BR>\n";
	} elsif ((!$d_over) && ($n_over)) {
		$content .= "<BR>\n";
		$content .= "<CENTER>｢$dai｣\n<LINE>\n";
		$content .= "$name\n<WRAP>\n";
	} else {
		$content .= "<BR>\n";
		$content .= "<CENTER>｢$dai｣<BR>\n";
		$content .= "<CENTER>$name<BR>\n";
	}

	# 記事の表示
	$content .= "<CENTER>----------------<BR>\n";
	if ($autolink) { &autolink( $msg ); }
	$msg =~ s/\$/\&\#36\;/g;
	$content .= "$msg<BR>\n";
	$content .= "<CENTER>----------------<BR>\n";

	# 投稿日時の表示
	$content .= "<CENTER>$date $time<BR>\n";

	# 投稿端末の表示
	$content .= "<CENTER>「$agent_name」\n";

	# メールアドレスの表示
	$content .= "<LINE>\n";
	if ($in{'mail'} ne "") {
		$content .= "<img icon=108>$in{'mail'}";
		$content .= "<BR>\n";
	}

	# ホームページアドレスの表示
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

	# フッター出力
	&footer;
}

#------------------------------------------------------------------------------
# 検索フォーム（EZweb）
#------------------------------------------------------------------------------
sub wap_sform {
	# ヘッダー出力
	$headtype = 1;
	&header;

	# 投稿指定
	$dest = "$script?mode=seek";	# モード指定
	$dest .= "\&amp;cond=\$cond";		# 検索条件
	$dest .= "\&amp;string=\$string";	# 検索文字列

	# 事前処理
	$content .= "<NODISPLAY name=\"before\">\n";
	$content .= "<ACTION type=\"accept\" task=\"go\" dest=\"#seek_form\" vars=\"cond=and\&amp;string=\" REL=\"next\">\n";
	$content .= "</NODISPLAY>\n";

	# 検索フォーム出力
	$content .= "<CHOICE name=\"seek_form\" method=\"$list_method\" title=\"$wap_title\" bookmark=\"$fscript\">\n";
	$content .= "<ACTION type=\"soft1\" task=\"go\" dest=\"$script\" label=\"戻る\">\n";
	$content .= "検索文字列を入力し、検索してください\n";
	$content .= "<CE task=\"gosub\" dest=\"#econ\" label=\"入力\" receive=\"cond\">条件:\$cond\n";
	$content .= "<CE task=\"go\" dest=\"#estr\" label=\"入力\" receive=\"string\">文字:\$string\n";
	$content .= "<CE task=\"go\" dest=\"$dest\" label=\"検索\">検索開始\n";
	$content .= "</CHOICE>\n";

	# 検索条件入力
	$content .= "<CHOICE KEY=\"cond\" name=\"econ\" method=\"$list_method\" title=\"$wap_title\" bookmark=\"$fscript\">\n";
	$content .= "<CE task=\"RETURN\" label=\"選択\" retvals=\"and\">AND検索\n";
	$content .= "<CE task=\"RETURN\" label=\"選択\" retvals=\"or\">OR検索\n";
	$content .= "</CHOICE>\n";

	# 検索文字列入力
	$content .= "<ENTRY KEY=\"string\" name=\"estr\" title=\"$wap_title\" bookmark=\"$fscript\">\n";
	$content .= "<ACTION type=\"accept\" task=\"go\" dest=\"#seek_form\">\n";
	$content .= "検索文字列\n";
	$content .= "</ENTRY>\n";

	# フッター出力
	&footer;
}

#------------------------------------------------------------------------------
# 検索結果表示（EZweb）
#------------------------------------------------------------------------------
sub wap_sview {
	# ヘッダー表示
	$headtype = 0;
	&header;

	# 時間の取得
	&get_time;

	# カード始め
	$content .= "<CHOICE name=\"tree\" method=\"$list_method\" title=\"$wap_title\" bookmark=\"$fscript\">\n";


	# 変数の初期設定
	$num     = 0;				# 記事数
	$num_max = @new;			# 投票記事数
	$num_p   = 0;				# ページカウント(通し)
	$num_peg = 1;				# ページカウント
	$page    = $in{'page'};		# ページ指定

	# ページの指定が無い場合は、最初のページを表示
	if ($page eq "") { $page = 1; }

	# 検索結果総数表示
	$content .= "<CENTER>検索結果：$num_max件\n";

	# ページ数を計算
	$page_max = int($num_max / $max_line);
	if (($page_max * $max_line) < $num_max) { $page_max++; }

	# ページ表示
	if ($page_max > 1) { $content .= "<BR>\n<CENTER>$page／$page_max頁\n"; }

	while ($num < $num_max) {
		# ページめくり
		if ($num_p == $max_line) {
			$num_p = 0;
			$num_peg++;
		}
		$num_p++;

		if ($num_peg == $page) {
			# 各行を分割し、配列に格納
			@column = split(/<>/,$new[$num]);

			# 個別表示へのリンク
			$dest = "$script?mode=view&amp;num=$column[0]";
			$content .= "<CE task=\"gosub\" dest=\"$dest\" label=\"表\示\">";

			# 新着記事チェック
			if (($times - $column[13]) < $new_time * 3600) {
				$content .= "$new_mark ";
			} else {
				$content .= "$top_mark ";
			}

			# 記事表示
			$column[4] =~ s/\$/\&\#36\;/g;
			$column[5] =~ s/\$/\&\#36\;/g;

			# 名前の表示
			$content .= "No.column[0] $column[5]/$column[4]";
			
			if ($column[15] ne '') {
				$content .= " ◆$column[15]-$column[2]\n";
			} else {
				$content .= "-$column[2]\n";
			}
		}
		$num++;
	}

	# ページ移動
	if ($num_peg != 1) {
		$dest = "$script?mode=seek";	# モード指定
		$dest .= "\&amp;cond=\$cond";		# 検索条件
		$dest .= "\&amp;string=\$string";	# 検索文字列
		# 次ページ
		if ($page != $num_peg) {
			$next = $page + 1;
			$ndest = "$dest" . "\&amp;page=$next";	# ページ指定
			$content .= "<CE task=\"go\" dest=\"$ndest\" label=\"次へ\">次ページ\n";
		}
		# 前ページ
		if ($page != 1) {
			$prev = $page - 1;
			$pdest = "$dest" . "\&amp;page=$prev";	# ページ指定
			$content .= "<CE task=\"go\" dest=\"$pdest\" label=\"前へ\">前ページ\n";
		}
	}

	# 記事がない場合の処理
	if ($num == 0) { $content .= "投稿記事は有りません<BR>\n"; }

	# 戻り
	$content .= "<CE task=\"go\" dest=\"$script\" label=\"戻る\">Topに戻る\n";

	# カード終わり
	$content .= "</CHOICE>\n";

	# フッター表示
	&footer;
}

#------------------------------------------------------------------------------
# 親記事リスト表示（EZweb）
#------------------------------------------------------------------------------
sub wap_list {
	# ヘッダー表示
	$headtype = 0;
	&header;

	# 時間の取得
	&get_time;

	# カード始め
	$content .= "<CHOICE name=\"list\" method=\"$list_method\" title=\"$wap_title\" bookmark=\"$fscript\">\n";

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
	$tpage   = $in{'tpage'};	# 親記事リストページ指定
	$num_c   = 0;				# ツリー記事数カウント
	$new_chk = 0;				# 新着記事のチェック

	# ページ指定のない場合は始めのページにする。
	if ($tpage eq "") { $tpage = 1; }

	# ソフトキーの設定
	$content .= "<ACTION type=\"soft1\" task=\"prev\" dest=\"$script\" label=\"戻る\">\n";

	$dest = "$script?mode=form";
	$content .= "<ACTION type=\"soft2\" task=\"go\" dest=\"$dest\" label=\"新規\">\n";

	# タイトル表示
	$content .= "<CENTER>";
	if (($ENV{'HTTP_X_UP_DEVCAP_ISCOLOR'}) && ($wap_png)){
		$content .= "<img src=\"$wap_png\" alt=\"[$wap_title]\">\n";
	} elsif ($wap_bmp) {
		$content .= "<img src=\"$wap_bmp\" alt=\"[$wap_title]\">\n";
	} else {
		$content .= "｢$wap_title｣\n";
	}

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
				$content .= "<CE task=\"go\" dest=\"$dest\" label=\"表\示\" >";
				if ($new_chk) { $content .= "$new_mark"; }
				if (!$new_chk) { $content .= "$top_mark"; }
				$dai =~ s/\$/\&\#36\;/g;

				# 記事表示
				if (!$list_view_mode){
					if ($ez_by) { $content .= "$num_c件 $dai by $name\n"; }
					if (!$ez_by) { $content .= "$num_c件 $dai\n"; }
				}
				if ($list_view_mode){
					if ($ez_by) { $content .= "$dai($num_c) by $name $date$time\n"; }
					if (!$ez_by) { $content .= "$dai($num_c) $date$time\n"; }
				}

			}

			# 各値の初期化
			$new_chk = 0;	# 新着記事チェッククリア
			$num_c = 0;		# ツリー記事数カウントクリア

			# 親記事の表示項目を保存
			$head = $column[0];	# 親記事番号
			$dai  = $column[5];	# 親記事題名
			if ($ez_by) { $name  = "$column[4]"; }	# 親記事投稿者名

			# ページめくり
			if ($num_p == $max_line) {
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

	# ページ表示
	if ($num_pag != 1) {
		$dest = "$script?mode=list";	# モード指定
		# 次ページ
		if ($num_pag != $tpage) {
			$next = $tpage + 1;
			$ndest = $dest ."\&amp;tpage=$next";
			$content .= "<CE task=\"go\" dest=\"$ndest\" label=\"次へ\">次($next)ページ\n";
		}

		# 前ページ
		if ($tpage != 1) {
			$prev = $tpage - 1;
			$pdest = $dest ."\&amp;tpage=$prev";
			$content .= "<CE task=\"go\" dest=\"$pdest\" label=\"前へ\">前($prev)ページ\n";
		}
	}
	

	# 記事がない場合の処理
	if ($num == 0) { $content .= "投稿記事は有りません<BR>\n"; }

	# 新規書込み項目
	$content .= "<CE task=\"go\" dest=\"$script?mode=form\" label=\"書込\">新規書込み\n";

	# 戻り
	$dest = "$script?mode=menu";
	$content .= "<CE task=\"go\" dest=\"$dest\" label=\"Menu\">Menuへ\n";

	# カード終わり
	$content .= "</CHOICE>\n";

	# フッター表示
	&footer;
}

#------------------------------------------------------------------------------
# 個別ツリー表示（EZweb）
#------------------------------------------------------------------------------
sub wap_tree {
	# ヘッダー表示
	$headtype = 0;
	&header;

	# 時間の取得
	&get_time;

	# カード始め
	$content .= "<CHOICE name=\"tree\" method=\"$list_method\" title=\"$wap_title\">\n";

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

	# 表示ツリー指定
	$tree = $in{'tree'};

	# ソフトキーの設定
	$dest = "$script?mode=form\&amp;res=$tree";	# レス記事の指定
	$content .= "<ACTION type=\"soft1\" task=\"go\" dest=\"$dest\" label=\"レス\">\n";

	while ($num < $num_max) {
		# 各行を分割し、配列に格納
		@column = split(/<>/,$line[$num]);
		if ($column[1] == $tree) {
			# ページめくり
			if ($num_p == $max_line) {
				$num_p = 0;
				$num_pag++;
			}
			$num_p++;

			# 題名補完機能
			if ($column[0] == $column[1]) {
				$dai_tmp = "RE:$column[5]";
			}

			if ($num_pag == $page) {
				$dest = "$script?mode=view\&amp;num=$column[0]";	# 記事指定
				$content .= "<CE task=\"gosub\" dest=\"$dest\" label=\"表\示\">";
				# 親記事表示
				if ($column[0] == $column[1]) {
					if (($times - $column[13]) < $new_time * 3600) {
						$content .= "$new_mark";
					} else {
						$content .= "$top_mark";
					}
				# 子記事表示
				} else {
					if (($times - $column[13]) < $new_time * 3600) {
						$content .= "$rnew_mark";
					} else {
						$content .= "$res_mark";
					}
				}
				# 題名補完機能
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
	# ページ表示
	if ($num_pag != 1) {
		$dest = "$script?mode=tree";	# モード指定
		$dest .= "\&amp;tree=$tree";		# ツリー指定
		$dest .= "\&amp;tpage=$tpage";		# 親ツリーページ保存
		# 次ページ
		if ($num_pag != $page) {
			$next = $page + 1;
			$ndest = $dest . "\&amp;page=$next";
			$content .= "<CE task=\"go\" dest=\"$ndest\" label=\"次へ\">次($next)ページ\n";
		}
		# 前ページ
		if ($page != 1) {
			$prev = $page - 1;
			$pdest = $dest . "\&amp;page=$prev";
			$content .= "<CE task=\"go\" dest=\"$pdest\" label=\"前へ\">前($prev)ページ\n";
		}
	}
	# 戻り
	$content .= "<CE task=\"go\" dest=\"$script\" label=\"戻る\">親記事一覧に戻る\n";

	# 記事がない場合の処理
	if ($num == 0) { $content .= "投稿記事は有りません<BR>\n"; }

	# 戻り

	$dest = "$script?mode=menu";
	$content .= "<CE task=\"go\" dest=\"$dest\" label=\"戻る\">機能\一覧に戻る\n";

	# カード終わり
	$content .= "</CHOICE>\n";

	# フッター表示
	&footer;
}

#------------------------------------------------------------------------------
# 個別表示（EZweb）
#------------------------------------------------------------------------------
sub wap_view {
	# ヘッダー出力
	$headtype = 1;
	&header;

	# ログファイルをオープンする
	open (IN,"$logfile") || &error (open_er);
	@line = <IN>;
	close(IN);
	
	$count = shift(@line);	# ログカウントを分離

	# 記事番号の記事を探す
	foreach $col (@line) {
		@column = split(/<>/,$col);	# 表示行を分解
		if ($column[0] == $in{'num'}) {
			$msg_length = length($col);
			last;
		}
	}

	# 最大パケットの取得
	$max_packet = $ENV{'HTTP_X_UP_DEVCAP_MAX_PDU'};
	if ($max_packet eq "") { $max_packet = 1500; }

	# 記事が表示限界を超えたら分割表示
	if ($msg_length > $max_packet) {
		# 記事の分割サイズの計算
		$num = $msg_length / $max_packet;
		$msg_max_packet = $max_packet / $num;

		# パケットサイズを切り下げて整数にする。
		$msg_max_packet =~ s/([0-9]*)\.([0-9]*)$/$1/;

		# ページの指定
		$s_page = $in{'s_page'};
		if ($s_page eq "") { $s_page = 1; }

		# 記事の分割
		@msgs = split(/<BR>/,$column[6]);

		# 初期設定
		@s_msg = ();
		$tmp_msg = "";

		# 記事をパケットサイズで連結
		$num = 1;
		foreach $msg (@msgs){
			$tmp_msg .= "$msg<BR>";
			if (length($tmp_msg) >= $msg_max_packet) {
				$num++;
				$tmp_msg = "$msg<BR>";
			}
			$s_msg[$num] .= "$msg<BR>";
		}

		# ページ分割数の決定
		$splits = $num;

		# メッセージの指定
		$column[6] = $s_msg[$s_page];
	}

	# 内容の表示
	$content .= "<DISPLAY name=\"view\" title=\"$wap_title\" bookmark=\"$fscript\">\n";

	# レスボタンを表示
	if ($in{'only'}) {
		$dest = "$script?mode=form";	# モードの指定
		$dest .= "\&amp;res=$in{'num'}";	# レス記事の指定
		$content .= "<ACTION type=\"soft1\" task=\"go\" dest=\"$dest\" label=\"レス\">\n";

	}

	# 戻るボタンを表示
	$content .= "<ACTION type=\"accept\" task=\"prev\" label=\"戻る\">\n";

	# 記事番号の表示
	$content .= "<CENTER>記事No.$column[0]";

	# 題名/投稿者の表示
	# 全角７(半角14)文字以下なら中央揃え、それ以外はラインで表示
	$n_over = 0;
	$d_over = 0;
	if ($column[4] =~ /(..............)(.*)/) { $n_over = 1; }
	if ($column[5] =~ /(..............)(.*)/) { $d_over = 1; }
	$column[4] =~ s/\$/\&\#36\;/g;
	$column[5] =~ s/\$/\&\#36\;/g;

	# WARPや、LINEで改行してしまう為場合分けして表示
	if (($n_over) && ($d_over)) {
		$content .= "<LINE>\n";
		$content .= "｢$column[5]｣\n";
		$content .= "<BR>\n";
		$content .= "$column[4]\n";
		$content .= "<WRAP>\n";
	} elsif ((!$n_over) && ($d_over)) {
		$content .= "<LINE>\n";
		$content .= "｢$column[5]｣\n";
		$content .= "<WRAP>\n";
		$content .= "<CENTER>$column[4]\n";
		$content .= "<BR>\n";
	} elsif (($n_over) && (!$d_over)) {
		$content .= "<BR>\n";
		$content .= "<CENTER>｢$column[5]｣\n";
		$content .= "<LINE>\n";
		$content .= "$column[4]\n";
		$content .= "<WRAP>\n";
	} else {
		$content .= "<BR>\n";
		$content .= "<CENTER>｢$column[5]｣\n";
		$content .= "<BR>\n";
		$content .= "<CENTER>$column[4]\n";
		$content .= "<BR>\n";
	}

	# ページの表示
 	if ($msg_length > $max_packet) {
		$content .= "<CENTER>($s_page／$splits)<BR>\n";
	}

	# 記事の表示
	$content .= "<CENTER>----------------<BR>\n";
	if ($autolink) { &autolink( $column[6] ); }
	$column[6] =~ s/\$/\&\#36\;/g;
	$content .= "$column[6]<BR>\n";
	$content .= "<CENTER>----------------<BR>\n";

	# 投稿日時の表示
	$content .= "<CENTER>$column[2] $column[3]<BR>\n";

	# 端末の表示
	$content .= "<CENTER>「$column[9]」<BR>\n";

	# メール表示
	if ($column[7] ne "") {
		if ($atmail) {
			$content .= "<A task=\"go\" dest=\"mailto:$column[7]\" label=\"メール\">";
		} else {
			$content .= "<A task=\"go\" dest=\"device:home/goto?svc=Email&amp;SUB=sendMsg\" vars=\"TO=$column[7]\" label=\"メール\">";
		}
		$content .= "<img icon=\"108\"></A>メール<BR>\n";
	}

	# ホーム表示
	if ($column[8] ne "") {
		$content .= "<A task=\"go\" dest=\"$column[8]\" label=\"ホーム\">";
		if ($column[8] =~ /hdml|HDML|wml|WML/) {
			if ($ENV{'HTTP_X_UP_DEVCAP_ISCOLOR'}) {
				$content .= "<img icon=\"155\">";
			} else {
				$content .= "<img icon=\"161\">";
			}
		} else {
			$content .= "<img icon=\"112\">";
		}
		$content .= "</A>ホーム<BR>\n";
	}

	if ($msg_length > $max_packet) {
		$dest = "$script?mode=view";	# モード指定
		$dest .= "\&amp;num=$column[0]";	# 記事指定
		# 次ページ
		if ($s_page != $splits) {
			$next = $s_page + 1;
			$ndest = $dest . "\&amp;s_page=$next";
			$content .= "<A task=\"go\" dest=\"$ndest\" label=\"次へ\">次($next)ページ</A><BR>\n";
		}
		# 前ページ
		if ($s_page != 1) {
			$prev = $s_page - 1;
			$pdest = $dest . "\&amp;s_page=$prev";
			$content .= "<A task=\"go\" dest=\"$pdest\" label=\"前へ\">前($prev)ページ</A><BR>\n";
		}
		# 戻りリンク
		$content .= "<A task=\"return\" label=\"戻る\">選択ツリーへ戻る</A><BR>\n";
	}

	$content .= "</DISPLAY>\n";

	# フッター表示
	&footer;
}

#------------------------------------------------------------------------------
# 管理フォーム（EZweb）
#------------------------------------------------------------------------------
sub wap_admin {
	# ヘッダー表示
	$headtype = 1;
	&header;

	# カード始め
	$content .= "<CHOICE title=\"$wap_title\" bookmark=\"$fscript\">\n";

	# 戻りボタンを出力
	$content .= "<ACTION type=\"soft1\" task=\"go\" dest=\"$script\" label=\"戻る\">\n";

	# 説明表示
	$content .= "<CENTER>｢管理者機能\｣\n";

	# 記事削除
	$dest = "$script?mode=ad_dform&amp;psw=$in{'psw'}";
	$content .= "<CE task=\"go\" dest=\"$dest\" label=\"削除\">[記事削除処理]\n";

	# パスワード変更
	$dest = "$script?mode=change&amp;psw=$in{'psw'}";
	$content .= "<CE task=\"go\" dest=\"$dest\" label=\"変更\">[暗号変更処理]\n";

	# 非適切語追加
	$dest = "$script?mode=aform&amp;psw=$in{'psw'}";
	$content .= "<CE task=\"go\" dest=\"$dest\" label=\"追加\">[非適切語追加]\n";

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
			$content .= "<CE task=\"go\" dest=\"$dest\" label=\"削除\">削除-$column[$loop]\n";
			$loop++;
		}
	}

	# カード終わり
	$content .= "</CHOICE>\n";

	# フッター表示
	&footer;
	exit;
}

#------------------------------------------------------------------------------
# 非適切語追加フォーム（EZweb）
#------------------------------------------------------------------------------
sub wap_aform {
	# ヘッダー表示
	$headtype = 1;
	&header;

	# 事前処理
	$content .= "<NODISPLAY name=\"pre\">\n";
	$content .= "<ACTION type=\"accept\" task=\"go\" dest=\"#imput\" vars=\"word=\">\n";
	$content .= "</NODISPLAY>\n";

	# 入力処理
	$content .= "<ENTRY key=\"word\" name=\"imput\" title=\"$wap_title\" bookmark=\"$fscript\">\n";
	$content .= "<ACTION type=\"accept\" task=\"go\" dest=\"#post\" label=\"決定\">\n";
	$content .= "非適切語：\n";
	$content .= "</ENTRY>\n";

	# 投稿処理
	$dest = "$script?mode=admin\&amp;func=add_word\&amp;word=\$word";
	$content .= "<NODISPLAY name=\"post\">\n";
	$content .= "<ACTION type=\"accept\" task=\"go\" dest=\"$dest\">\n";
	$content .= "</NODISPLAY>\n";

	# フッター表示
	&footer;
	exit;
}

#------------------------------------------------------------------------------
# パスワード変更フォーム（EZweb）
#------------------------------------------------------------------------------
sub wap_pform {
	# ヘッダー表示
	$headtype = 1;
	&header;

	# 事前処理
	$content .= "<NODISPLAY name=\"pre\">\n";
	$content .= "<ACTION type=\"accept\" task=\"go\" dest=\"#imput\" vars=\"pswa=\&amp;pswb=\">\n";
	$content .= "</NODISPLAY>\n";

	# 入力処理
	$content .= "<ENTRY key=\"pswa\" name=\"imput\" title=\"$wap_title\" bookmark=\"$fscript\" format=\"*x\">\n";
	$content .= "<ACTION type=\"accept\" task=\"go\" dest=\"#check\" label=\"決定\">\n";
	$content .= "パスワード(入力)\n";
	$content .= "</ENTRY>\n";

	# 確認入力処理
	$content .= "<ENTRY key=\"pswb\" name=\"check\" title=\"$wap_title\" bookmark=\"$fscript\" format=\"*x\">\n";
	$content .= "<ACTION type=\"accept\" task=\"go\" dest=\"#post\" label=\"確認\">\n";
	$content .= "パスワード(確認)\n";
	$content .= "</ENTRY>\n";

	# 投稿処理
	$dest = "$script?mode=admin\&amp;func=change\&amp;pswa=\$pswa\&amp;pswb=\$pswb";
	$content .= "<NODISPLAY name=\"post\">\n";
	$content .= "<ACTION type=\"accept\" task=\"go\" dest=\"$dest\">\n";
	$content .= "</NODISPLAY>\n";

	# フッター表示
	&footer;
	exit;
}

#------------------------------------------------------------------------------
# パスワード確認フォーム（EZweb）
#------------------------------------------------------------------------------
sub wap_pass {
	# ヘッダー表示
	$headtype = 1;
	&header;

	# 事前処理
	$content .= "<NODISPLAY name=\"pre\">\n";
	$content .= "<ACTION type=\"accept\" task=\"go\" dest=\"#imput\" vars=\"psw=\">\n";
	$content .= "</NODISPLAY>\n";

	# 入力処理
	$content .= "<ENTRY key=\"psw\" name=\"imput\" title=\"$wap_title\" bookmark=\"$fscript\" format=\"*x\">\n";
	$content .= "<ACTION type=\"accept\" task=\"go\" dest=\"#post\" label=\"確認\">\n";
	$content .= "パスワード：\n";
	$content .= "</ENTRY>\n";

	# 投稿処理
	$dest = "$script?mode=admin\&amp;func=check\&amp;psw=\$psw";
	$content .= "<NODISPLAY name=\"post\">\n";
	$content .= "<ACTION type=\"accept\" task=\"go\" dest=\"$dest\">\n";
	$content .= "</NODISPLAY>\n";

	# フッター表示
	&footer;
	exit;
}

#------------------------------------------------------------------------------
# 管理者削除フォーム（EZweb）
#------------------------------------------------------------------------------
sub wap_ad_dform {
	# ヘッダー表示
	$headtype = 1;
	&header;

	# 事前処理
	$content .= "<NODISPLAY name=\"pre\">\n";
	$content .= "<ACTION type=\"accept\" task=\"go\" dest=\"#imput\" vars=\"psw=\">\n";
	$content .= "</NODISPLAY>\n";

	# 入力処理
	$content .= "<ENTRY key=\"num\" name=\"imput\" title=\"$wap_title\" bookmark=\"$fscript\" format=\"*x\">\n";
	$content .= "<ACTION type=\"accept\" task=\"go\" dest=\"#post\" label=\"確認\">\n";
	$content .= "削除記事番号：\n";
	$content .= "</ENTRY>\n";

	$dest = "$script?mode=admin\&amp;func=delete\&amp;num=\$num\&amp;admin=1";
	$content .= "<NODISPLAY name=\"post\">\n";
	$content .= "<ACTION type=\"accept\" task=\"go\" dest=\"$dest\">\n";
	$content .= "</NODISPLAY>\n";

	# フッター表示
	&footer;
	exit;
}

#------------------------------------------------------------------------------
# 削除フォーム（EZweb）
#------------------------------------------------------------------------------
sub wap_dform {
	# ヘッダー出力
	$headtype = 1;
	&header;

	# 投稿指定
	$dest = "$script?func=delete";			# 機能指定
	$dest .= "\&amp;num=\$num";					# 投稿番号
	$dest .= "\&amp;dpas=\$dpas";				# 削除パスワード
	if ($in{'admin'}) {
		$dest .= "\&amp;mode=admin\&amp;admin=1";	# モード指定
	}

	# 削除フォーム出力
	$content .= "<CHOICE name=\"dform\" method=\"$list_method\" title=\"$wap_title\" bookmark=\"$fscript\">\n";
	$content .= "<ACTION type=\"soft1\" task=\"go\" dest=\"$script\" label=\"戻る\">\n";
	$content .= "記事番号／暗号を入力し削除してください\n";
	$content .= "<CE task=\"go\" dest=\"#enum\" label=\"入力\" receive=\"num\">番号:\$num\n";
	$content .= "<CE task=\"go\" dest=\"#epas\" label=\"入力\" receive=\"dpas\">暗号:\$dpas\n";
	$content .= "<CE task=\"go\" dest=\"$dest\" label=\"削除\">記事を削除\n";

	$content .= "</CHOICE>\n";

	# 削除記事の番号入力
	$content .= "<ENTRY KEY=\"num\" name=\"enum\" title=\"$wap_title\" bookmark=\"$fscript\" format=\"*N\">\n";
	$content .= "<ACTION type=\"accept\" task=\"go\" dest=\"#dform\">\n";
	$content .= "削除記事の番号\n";
	$content .= "</ENTRY>\n";

	# 削除パスワード入力
	$content .= "<ENTRY KEY=\"dpas\" name=\"epas\" title=\"$wap_title\" bookmark=\"$fscript\" format=\"*x\">\n";
	$content .= "<ACTION type=\"accept\" task=\"go\" dest=\"#dform\">\n";
	$content .= "削除パスワード\n";
	$content .= "</ENTRY>\n";

	# フッター出力
	&footer;
}

#------------------------------------------------------------------------------
# 冒頭画面（EZweb）
#------------------------------------------------------------------------------
sub wap_title {
	# ヘッダー出力
	$headtype = 1;
	&header;

	# カードヘッダー出力
	$content .= "<CHOICE name=\"top\" method=\"$list_method\" title=\"$wap_title\" bookmark=\"$fscript\">\n";

	# ホームがある場合戻りボタンを出力
	if ($wap_home) {
		$content .= "<ACTION type=\"soft1\" task=\"go\" dest=\"$wap_home\" label=\"HOME\" icon=\"112\">\n";
	}

	$content .= "<LINE>$wap_title\Menu表\示\n";

	# ツリー表示項目
	$content .= "<CE task=\"go\" dest=\"$script?mode=list\" label=\"表\示\">";
	$content .= "[<img ICON=\"234\">ツリー表\示]\n";

	# 新規書込み項目
	$content .= "<CE task=\"go\" dest=\"$script?mode=form\" label=\"書込\">";
	$content .= "[<img ICON=\"149\">新規書込み]\n";

	# 記事の検索項目
	$content .= "<CE task=\"go\" dest=\"$script?mode=sform\" label=\"検索\">";
	$content .= "[<img ICON=\"119\">記事の検索]\n";

	# 使い方説明項目
	$content .= "<CE task=\"go\" dest=\"$wap_help\" label=\"説明\">";
	$content .= "[<img ICON=\"270\">使い方説明]\n";

	# 著作権表示
	$content .= "<CE task=\"go\" dest=\"$wap_own\" label=\"作者\">";
	$content .= "[<img ICON=\"81\">著作権表\示]\n";

	# 記事の削除項目
	$content .= "<CE task=\"go\" dest=\"$script?mode=dform\" label=\"削除\">";
	$content .= "[<img ICON=\"61\">記事の削除]\n";

	# 管理者専用項目
	$content .= "<CE task=\"go\" dest=\"$script?mode=check\" label=\"管理\">";
	$content .= "[<img ICON=\"98\">管理者専用]\n";

	# カードフッダー出力
	$content .= "</CHOICE>\n";

	# フッター出力
	&footer;
}

1;
