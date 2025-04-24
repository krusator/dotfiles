return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"nvim-telescope/telescope-live-grep-args.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local action_state = require("telescope.actions.state")
		local finders = require("telescope.finders")
		local pickers = require("telescope.pickers")
		local sorters = require("telescope.config").values.generic_sorter
		local utils = require("telescope.utils")
		local builtin = require("telescope.builtin")

		telescope.setup({
			defaults = {
				path_display = { "filename_first" },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
					},
				},
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--hidden", -- thats the new thing
				},
				layout_config = {
					width = 0.95,
					preview_width = 0.3
				},
			},
			pickers = {
				find_files = {
					file_ignore_patterns = { "node_modules", ".git" },
					hidden = true,
				},
				live_grep = {
				},
				buffers = {
					mappings = {
						i = {
							["<c-d>"] = actions.delete_buffer + actions.move_to_top,
						},
					},
				},
			},
			width = 0.95,
		})

		telescope.load_extension("fzf")
		telescope.load_extension("live_grep_args")

		-- Set keymaps
		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
		keymap.set("n", "<leader>fh", function()
			builtin.live_grep({ cwd = utils.buffer_dir() })
		end, { desc = "Fuzzy find files in current buffer's directory" })
		keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
		keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
		keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
		keymap.set("n", "<leader>fD", "<cmd>Telescope diagnostics<cr>", { desc = "Show all diagnostics" })
		keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<cr>", { desc = "Fuzzy find git branches" })
		keymap.set("n", "<leader><space>", builtin.buffers, { desc = "[ ] Find existing buffers" })
		keymap.set("n", "<leader>fg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", { desc = "Find string in dir -> \"my string\" in_here" })
	end,
}
