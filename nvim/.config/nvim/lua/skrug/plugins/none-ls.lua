return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
	},
	config = function()
		local null_ls = require("null-ls")

		null_ls.setup({
			sources = {
				require("none-ls.diagnostics.eslint_d"),
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.prettier,
				null_ls.builtins.diagnostics.checkstyle
				-- null_ls.source.filetypes({ "lua" }),
				-- null_ls.source.command({ "ls", "-l" }),
				-- null_ls.source.command({ "echo", "hello" }),
			},
		})
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(ev)
				local opts = { buffer = ev.buf, silent = true }
				opts.desc = "Format code"
				vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, opts)
			end,
		})
	end,
}
