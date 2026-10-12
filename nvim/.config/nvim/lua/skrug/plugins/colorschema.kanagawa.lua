return {
	"rebelot/kanagawa.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		-- setup must run before loading the colorscheme, otherwise its options are ignored
		require("kanagawa").setup({
			transparent = true, -- do not set background color
			theme = "wave", -- Load "wave" theme when 'background' option is not set
			background = { -- map the value of 'background' option to a theme
				dark = "wave", -- try "dragon" !
				light = "lotus",
			},
		})
		vim.cmd([[colorscheme kanagawa]])
	end,
}
