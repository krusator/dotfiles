return {
	"mfussenegger/nvim-lint",
	config = function()
		local lint = require("lint")
		lint.linters_by_ft = {
			java = { "checkstyle" },
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" },
		}

		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			callback = function()
				local found = vim.fn.findfile("checkstyle.xml", ".;")
				if found ~= "" then
					lint.linters.checkstyle.config_file = vim.fn.fnamemodify(found, ":p")
				end
				lint.try_lint()
			end,
		})
	end,
}
