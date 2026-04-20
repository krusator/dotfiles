return {
	"neovim/nvim-lspconfig",
	dependencies = {
		-- Automatically install LSPs and related tools to stdpath for Neovim
		-- Mason must be loaded before its dependents so we need to set it up here.
		-- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
		{ "mason-org/mason.nvim", opts = {} },
		-- "mason-org/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",

		-- Useful status updates for LSP.
		{ "j-hui/fidget.nvim",    opts = {} },

		-- Allows extra capabilities provided by blink.cmp
		"saghen/blink.cmp",

		{ "antosha417/nvim-lsp-file-operations", config = true },
	},
	config = function()
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = true }),
			callback = function(event)
				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local map = function(keys, func, desc, mode)
					mode = mode or "n"
					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				-- set keybinds
				-- opts.desc = "Show LSP references"
				map("gR", function() Snacks.picker.lsp_references() end, "[G]oto [R]eferences")
				map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
				map("gd", function() Snacks.picker.lsp_definitions() end, "[G]oto [D]efinition")
				map("gi", function() Snacks.picker.lsp_implementations() end, "[G]oto [I]mplementation")
				map("gt", function() Snacks.picker.lsp_type_definitions() end, "[G]oto [T]ype Definition")
				map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "v" })
				map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame variable under cursor")
				map("<leader>D", function() Snacks.picker.diagnostics_buffer() end, "[D]iagnostics for current buffer")
				map("<leader>dl", vim.diagnostic.open_float, "[d]iagnostics for [l]ine")
				-- Using < / > instead of [ / ] — easier on German keyboard layout (no AltGr needed)
				map("<d", vim.diagnostic.goto_prev, "[P]revious [d]iagnostic")
				map(">d", vim.diagnostic.goto_next, "[N]ext [d]iagnostic")
				map("K", vim.lsp.buf.hover, "Show documentation for what is under cursor")
				map("<leader>rs", function() vim.cmd("LspRestart") end, "Restart LSP")
				map("gO", function() Snacks.picker.lsp_symbols() end, "Open Document Symbols")
				map("gW", function() Snacks.picker.lsp_workspace_symbols() end, "Open Workspace Symbols")

				-- The following two autocommands are used to highlight references of the
				-- word under your cursor when your cursor rests there for a little while.
				--    See `:help CursorHold` for information about when this is executed
				--
				-- When you move your cursor, the highlights will be cleared (the second autocommand).
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if
						client
						and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
				then
					local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.clear_references,
					})

					vim.api.nvim_create_autocmd("LspDetach", {
						group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
						callback = function(event2)
							vim.lsp.buf.clear_references()
							vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
						end,
					})
				end

				-- The following code creates a keymap to toggle inlay hints in your
				-- code, if the language server you are using supports them
				--
				-- This may be unwanted, since they displace some of your code
				if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
					map("<leader>th", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
					end, "[T]oggle Inlay [H]ints")
				end
			end,
		})

		-- local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		-- for type, icon in pairs(signs) do
		-- 	local hl = "DiagnosticSign" .. type
		-- 	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		-- end
		vim.diagnostic.config({
			severity_sort = true,
			float = { border = "rounded", source = "if_many" },
			underline = { severity = vim.diagnostic.severity.ERROR },
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "󰅚 ",
					[vim.diagnostic.severity.WARN] = "󰀪 ",
					[vim.diagnostic.severity.INFO] = "󰋽 ",
					[vim.diagnostic.severity.HINT] = "󰌶 ",
					-- [vim.diagnostic.severity.ERROR] = "  ",
					-- [vim.diagnostic.severity.WARN] = "  ",
					-- [vim.diagnostic.severity.INFO] = "󰠠  ",
					-- [vim.diagnostic.severity.HINT] = "  ",
				},
			},
			virtual_text = {
				source = "if_many",
				spacing = 2,
				format = function(diagnostic)
					return diagnostic.message
				end,
			},
		})
		local original_capabilities = vim.lsp.protocol.make_client_capabilities()
		local capabilities = require("blink.cmp").get_lsp_capabilities(original_capabilities)
		vim.lsp.enable("jdtls")
		vim.lsp.enable("lua_ls")
		vim.lsp.enable("phpactor")
		vim.lsp.config("jdtls", {
			capabilities = capabilities,
		})
		vim.lsp.config("lua_ls", {
			-- cmd = { ... },
			-- filetypes = { ... },
			capabilities = capabilities,
			settings = {
				Lua = {
					completion = {
						callSnippet = "Replace",
					},
					diagnostics = {
						globals = { "vim" },
					},
					-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
					-- diagnostics = { disable = { 'missing-fields' } },
				},
			},
		})
		vim.lsp.config("phpactor", {
			-- cmd = { ... },
			-- filetypes = { ... },
			root_dir = vim.fs.root(0, { ".ddev" }),
			capabilities = capabilities,
		})
		vim.lsp.enable("bashls")
		vim.lsp.config("bashls", {
			-- cmd = { ... },
			-- filetypes = { ... },
			capabilities = capabilities,
			cmd = { "bash-language-server", "start" },
			filetypes = { "bash", "sh" },
		})
		vim.lsp.enable("twiggy_language_server")
		vim.lsp.config("twiggy_language_server", {
			capabilities = capabilities,
			root_dir = vim.fs.root(0, { ".ddev" }),
		})
		-- vim.lsp.enable("docker-language-server")
		vim.lsp.enable("gopls")
		vim.lsp.config("gopls", {
			capabilities = capabilities,
			settings = {
				gopls = {
					analyses = {
						unusedparams = true,
					},
					staticcheck = true,
					gofumpt = true,
				},
			},
		})
		vim.lsp.enable("ts_ls")
		vim.lsp.config("ts_ls", { capabilities = capabilities })
		vim.lsp.enable("terraformls")
		vim.lsp.config("terraformls", { capabilities = capabilities })
		-- vim.lsp.config("docker-language-server", {
		-- 	capabilities = capabilities,
		-- 	cmd = { "docker-language-server", "start", "--stdio" },
		-- 	filetypes = { "dockerfile", "yaml.docker-compose" },
		-- 	root_markers = {
		-- 		"Dockerfile",
		-- 		"docker-compose.yaml",
		-- 		"docker-compose.yml",
		-- 		"compose.yaml",
		-- 		"compose.yml",
		-- 		"docker-bake.json",
		-- 		"docker-bake.hcl",
		-- 		"docker-bake.override.json",
		-- 		"docker-bake.override.hcl",
		-- 	},
		-- })
		-- vim.lsp.enable('GitHub Copilot')
		-- vim.lsp.config('GitHub Copilot', {})
	end,
}
