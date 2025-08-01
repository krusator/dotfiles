-- return {
--   {
--     -- Theme inspired by Atom
--     "navarasu/onedark.nvim",
--     priority = 1000,
--     config = function()
--       vim.cmd.colorscheme("onedark")
--     end,
--   },
-- }
-- return {
-- 	"folke/tokyonight.nvim",
-- 	lazy = false,
-- 	priority = 1000,
-- 	config = function()
-- 		vim.cmd([[colorscheme tokyonight-storm]])
-- 	end,
-- 	-- config = function()
-- 	--   require("lualine").setup({
-- 	--   options = {
-- 	--     theme = "auto",
-- 	--   },
-- 	-- })
-- 	-- end,
-- }
-- return {
-- 	"rebelot/kanagawa.nvim",
-- 	lazy = false,
-- 	priority = 1000,
-- 	config = function()
-- 		vim.cmd([[colorscheme kanagawa]])
-- 		require("kanagawa").setup({
-- 			theme = "dragon", -- Load "wave" theme when 'background' option is not set
-- 			background = { -- map the value of 'background' option to a theme
-- 				dark = "wave", -- try "dragon" !
-- 				light = "lotus",
-- 			},
-- 		})
-- 	end,
-- 	-- config = function()
-- 	--   require("lualine").setup({
-- 	--   options = {
-- 	--     theme = "auto",
-- 	--   },
-- 	-- })
-- 	-- end,
-- }
return {
	"EdenEast/nightfox.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("nightfox").setup({
			-- theme = "nightfox", -- Load "wave" theme when 'background' option is not set
			-- theme = "carbonfox", -- Load "wave" theme when 'background' option is not set
			-- background = {    -- map the value of 'background' option to a theme
			-- 	dark = "carbonfox", -- try "dragon" !
			-- 	light = "dayfox",
			-- },
			options = {
				styles = {
					comments = "italic",
				},
			},
			palettes = {
				all = {
					comment = "#B6B09F",
				},
			},
		})
		vim.cmd("colorscheme carbonfox")
	end,
	-- config = function()
	--   require("lualine").setup({
	--   options = {
	--     theme = "auto",
	--   },
	-- })
	-- end,
}
