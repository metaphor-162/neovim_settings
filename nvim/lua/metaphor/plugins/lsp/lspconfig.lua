return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		-----------------------------------------------------------------------
		-- Neovim 0.11 新API (vim.lsp.config + vim.lsp.start)
		-----------------------------------------------------------------------
		local util = require("lspconfig.util")
		local mason_lspconfig = require("mason-lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		-----------------------------------------------------------------------
		-- 現在バッファの offset_encoding を取得（あなたの元コードを維持）
		-----------------------------------------------------------------------
		local function current_encoding(bufnr)
			local clients = vim.lsp.get_clients({ bufnr = bufnr })
			if not clients or #clients == 0 then
				return "utf-16"
			end
			for _, c in ipairs(clients) do
				if c.server_capabilities and c.server_capabilities.definitionProvider then
					return c.offset_encoding or "utf-16"
				end
			end
			return clients[1].offset_encoding or "utf-16"
		end

		-----------------------------------------------------------------------
		-- Swift: sourcekit-lsp を xcrun 経由で取得
		-----------------------------------------------------------------------
		local function find_sourcekit()
			local h = io.popen("xcrun -f sourcekit-lsp 2>/dev/null")
			local p = h and h:read("*l") or nil
			if h then
				h:close()
			end
			return (p and #p > 0) and p or "sourcekit-lsp"
		end

		-----------------------------------------------------------------------
		-- LspAttach: キーマップ（あなたの元コードを維持）
		-----------------------------------------------------------------------
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local opts = { buffer = ev.buf, silent = true }
				local keymap = vim.keymap

				opts.desc = "定義へジャンプ"
				keymap.set("n", "gd", function()
					vim.lsp.buf.definition({
						reuse_win = true,
						position_encoding = current_encoding(ev.buf),
					})
				end, opts)

				opts.desc = "実装へジャンプ"
				keymap.set("n", "gi", function()
					vim.lsp.buf.implementation({
						position_encoding = current_encoding(ev.buf),
					})
				end, opts)

				opts.desc = "型定義へジャンプ"
				keymap.set("n", "gt", function()
					vim.lsp.buf.type_definition({
						position_encoding = current_encoding(ev.buf),
					})
				end, opts)

				opts.desc = "参照を表示"
				keymap.set("n", "gR", function()
					vim.lsp.buf.references(nil, {
						position_encoding = current_encoding(ev.buf),
					})
				end, opts)

				opts.desc = "宣言に移動"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
				opts.desc = "コードアクション"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
				opts.desc = "リネーム"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
				opts.desc = "バッファ診断"
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)
				opts.desc = "行診断"
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
				opts.desc = "前の診断"
				keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
				opts.desc = "次の診断"
				keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
				opts.desc = "ホバー"
				keymap.set("n", "K", vim.lsp.buf.hover, opts)
				opts.desc = "LSP再起動"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
			end,
		})

		-----------------------------------------------------------------------
		-- Diagnostic アイコン
		-----------------------------------------------------------------------
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		local capabilities = cmp_nvim_lsp.default_capabilities()

		-----------------------------------------------------------------------
		-- すべての LSP サーバ設定を vim.lsp.config に登録 (新API)
		-----------------------------------------------------------------------
		local function make(server, opts)
			opts.capabilities = capabilities
			vim.lsp.config[server] = opts
		end

		--------------------------
		-- ★ TypeScript (ts_ls)
		--------------------------
		make("ts_ls", {
			root_dir = util.root_pattern("tsconfig.json", "jsconfig.json", "package.json", ".git"),
			single_file_support = false,
			on_attach = function(client, bufnr)
				vim.api.nvim_create_autocmd("BufWritePost", {
					group = vim.api.nvim_create_augroup("ts_ls_auto_change", { clear = true }),
					pattern = { "*.js", "*.ts", "*.tsx" },
					callback = function(ctx)
						if client and client.notify then
							client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
						end
					end,
				})
			end,
		})

		--------------------------
		-- ★ Svelte
		--------------------------
		make("svelte", {
			root_dir = util.root_pattern("svelte.config.js", "svelte.config.mjs", "package.json", ".git"),
			on_attach = function(client, bufnr)
				vim.api.nvim_create_autocmd("BufWritePost", {
					group = vim.api.nvim_create_augroup("svelte_auto_change", { clear = true }),
					pattern = { "*.js", "*.ts" },
					callback = function(ctx)
						if client and client.notify then
							client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
						end
					end,
				})
			end,
		})

		--------------------------
		-- ★ GraphQL
		--------------------------
		make("graphql", {
			filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
		})

		--------------------------
		-- ★ Emmet
		--------------------------
		make("emmet_ls", {
			filetypes = {
				"html",
				"typescriptreact",
				"javascriptreact",
				"css",
				"sass",
				"scss",
				"less",
				"svelte",
			},
		})

		--------------------------
		-- ★ Lua
		--------------------------
		make("lua_ls", {
			settings = {
				Lua = {
					diagnostics = { globals = { "vim" } },
					completion = { callSnippet = "Replace" },
				},
			},
		})

		--------------------------
		-- ★ Go (gopls)
		--------------------------
		make("gopls", {
			root_dir = util.root_pattern("go.work", "go.mod", ".git"),
			settings = {
				gopls = {
					analyses = { unusedparams = true },
					staticcheck = true,
				},
			},
		})

		--------------------------
		-- ★ Prisma (prismals)
		--------------------------
		make("prismals", {
			filetypes = { "prisma" },
		})

		--------------------------
		-- ★ Python (pyright)
		--------------------------
		make("pyright", {
			root_dir = util.root_pattern(
				"pyproject.toml",
				"setup.py",
				"setup.cfg",
				"requirements.txt",
				"Pipfile",
				".git"
			),
		})

		--------------------------
		-- ★ HTML
		--------------------------
		make("html", {
			filetypes = { "html", "htm", "templ" },
		})

		--------------------------
		-- ★ TailwindCSS
		--------------------------
		make("tailwindcss", {
			root_dir = util.root_pattern(
				"tailwind.config.js",
				"tailwind.config.cjs",
				"postcss.config.js",
				"package.json",
				".git"
			),
		})

		--------------------------
		-- ★ Swift (sourcekit)
		--------------------------
		make("sourcekit", {
			cmd = { find_sourcekit() },
			filetypes = { "swift" },
			root_dir = util.root_pattern("Package.swift", "*.xcodeproj", "*.xcworkspace", ".git"),
			single_file_support = false,
		})

		-----------------------------------------------------------------------
		-- mason-lspconfig → 自動で vim.lsp.start() を呼ぶ
		-----------------------------------------------------------------------
		mason_lspconfig.setup({
			handlers = {
				function(server)
					vim.lsp.start(vim.lsp.config[server])
				end,
			},
		})
	end,
}
