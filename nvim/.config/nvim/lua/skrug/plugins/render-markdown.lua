return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
	ft = { "markdown", "codecompanion" },
	config = function()
		---@module 'render-markdown'
		---@type render.md.UserConfig
		require("render-markdown").setup({
			latex = { enabled = false },
			file_types = { "markdown", "codecompanion" },
		})
	end,
}
