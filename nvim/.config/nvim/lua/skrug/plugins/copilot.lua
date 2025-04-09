return {
	"github/copilot.vim",
	version = "1.41",
	config = function()
		vim.g.copilot_settings = { selectedCompletionModel = "gpt-4o-copilot" }
		-- Block the normal Copilot suggestions
		vim.api.nvim_create_augroup("github_copilot", { clear = true })
		vim.api.nvim_create_autocmd({ "FileType", "BufUnload" }, {
			group = "github_copilot",
			callback = function(args)
				vim.fn["copilot#On" .. args.event]()
			end,
		})
		vim.fn["copilot#OnFileType"]()
	end,
	cmd = "Copilot",
	event = "BufWinEnter",
	init = function()
		vim.g.copilot_no_maps = true
	end,
}
