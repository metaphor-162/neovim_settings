return {
	"kdheepak/lazygit.nvim",
	cmd = {
		"LazyGit",
		"LazyGitConfig",
		"LazyGitCurrentFile",
		"LazyGitFilter",
		"LazyGitFilterCurrentFile",
	},
	-- フローティングウィンドウの境界線を装飾するためのオプション
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	-- 'keys' を使用して LazyGit のキーバインディングを設定することを推奨します
	-- これにより、コマンドが初めて実行されたときにプラグインが読み込まれます
	keys = {
		{ "<leader>lg", "<cmd>LazyGit<cr>", desc = "Lazy Git を開く" },
	},
}

-- git add -uall
-- git commit --amend -m "refs #697563  バリデーションのタイミングの変更しました, story_finish_param のis_finish のコメントを追加しました"
-- git reset --hard HEAD
-- git reset --hard {ハッシュ値}
-- // ミスってAdd したものを除去する
-- git restore --staged [ファイル名]
--
-- // 雑多なものを取り除けてみやすい
-- git log -n 4 --oneline --reverse
-- git mv fileA fileB (= mv fileA fileB + git add fileB + git rm fileA)
-- // 誰が編集したのかを知りたいとき
-- git blame {filepath}
-- // 一度Push したブランチのコミットに対して変更を行った時に, Pushしたブランチを消す (: をつける)
-- git push origin :feature/v3_5_20/hayashi/697563
-- // リモートで消されたブランチが手元で残ってしまう件を解消する
-- git remote prune　origin
--
--
-- 特定のコミットまで戻りたいとき
-- git revert --no-commit 7661eb369b58bd92cb920ee85a0c8f1120d8a97d..HEAD
-- git commit -m "Revert to 7661eb369b58bd92cb920ee85a0c8f1120d8a97d and keep specific commits"
-- git push origin main
