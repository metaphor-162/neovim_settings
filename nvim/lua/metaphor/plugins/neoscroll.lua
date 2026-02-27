-- karb94/neoscroll.nvim

return {
	"karb94/neoscroll.nvim",
	-- イベントを指定して、プラグインが読み込まれるタイミングを制御
	event = "WinScrolled",
	config = function()
		-- neoscrollの設定を行う
		require("neoscroll").setup({
			-- スクロールアニメーションにマッピングするキーを指定
			mappings = {
				"<C-u>",
				"<C-d>",
				"<C-b>",
				"<C-f>",
				"<C-y>",
				"zt",
				"zz",
				"zb",
			},
			-- スクロール中にカーソルを非表示にする
			hide_cursor = true,
			-- 下方向にスクロールするときに<EOF>で停止する
			stop_eof = true,
			-- グローバルスコープの代わりにスクロールオフのローカルスコープを使用する
			use_local_scrolloff = false,
			-- カーソルがファイルのスクロールオフの余白に到達したときにスクロールを停止する
			respect_scrolloff = false,
			-- ウィンドウがこれ以上スクロールできない場合でも、カーソルは引き続きスクロールする
			cursor_scrolls_alone = true,
			-- デフォルトのイージング関数
			easing_function = nil,
			-- スクロールアニメーションが開始する前に実行する関数
			pre_hook = nil,
			-- スクロールアニメーションが終了した後に実行する関数
			post_hook = nil,
		})
	end,
}
--
-- このコードは、`lazy.nvim`の設定ブロックとして記述されています。
--
-- 1. `"karb94/neoscroll.nvim"`は、プラグインのGitHubリポジトリを指定しています。
-- 2. `event = "WinScrolled"`は、プラグインが読み込まれるタイミングを指定しています。
--  ここでは、ウィンドウがスクロールされたときにプラグインが読み込まれます。
-- 3. `config`関数内で、`require('neoscroll').setup()`を呼び出してプラグインの設定を行います。
--    - `mappings`では、スクロールアニメーションにマッピングするキーを指定します。
--    - `hide_cursor`は、スクロール中にカーソルを非表示にするかどうかを設定します。
--    - `stop_eof`は、下方向にスクロールするときに<EOF>で停止するかどうかを設定します。
--    - `use_local_scrolloff`は、グローバルスコープの代わりにスクロールオフのローカルスコープを使用するかどうかを設定します。
--    - `respect_scrolloff`は、カーソルがファイルのスクロールオフの余白に到達したときにスクロールを停止するかどうかを設定します。
--    - `cursor_scrolls_alone`は、ウィンドウがこれ以上スクロールできない場合でも、カーソルが引き続きスクロールするかどうかを設定します。
--    - `easing_function`は、デフォルトのイージング関数を指定します。
--    - `pre_hook`と`post_hook`は、スクロールアニメーションの前後に実行する関数を指定します。
--
-- この設定を`lazy.nvim`の設定ファイルに追加し、プラグインマネージャを再起動またはソースファイルを再読み込みすることで、`neoscroll.nvim`プラグインがNeovimに導入されます。
