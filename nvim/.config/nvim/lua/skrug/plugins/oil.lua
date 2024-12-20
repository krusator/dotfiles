return {
	"stevearc/oil.nvim",
	opts = {},
	-- Optional dependencies
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("oil").setup({
			-- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
			-- Set to false if you want some other plugin (e.g. netrw) to open when you edit directories.
			--	default_file_explorer = true,
			columns = {
				"icon",
				-- "permissions",
				-- "size",
				-- "mtime",
			},
			view_options = {
				show_hidden = true,
				is_always_hidden = function(name, bufnr)
					return name:match(".DS_Store")
				end,
			},
		})
		vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
	end,
}
