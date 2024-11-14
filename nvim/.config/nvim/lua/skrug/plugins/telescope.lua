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
			},
			pickers = {
				find_files = {
					file_ignore_patterns = { "node_modules", ".git" },
					hidden = true,
				},
				live_grep = {
					file_ignore_patterns = { ".git", "node_modules" },
					additional_args = function(opts)
						return { "--hidden" }
					end,
				},
				buffers = {
					mappings = {
						i = {
							["<c-d>"] = actions.delete_buffer + actions.move_to_top,
						},
					},
				},
			},
		})

		telescope.load_extension("fzf")
		telescope.load_extension("live_grep_args")

		-- Custom function to list directories and open tmux sessions
		local function open_tmux_session(prompt_bufnr)
			local selected_entry = action_state.get_selected_entry()
			local dir = selected_entry[1]
			actions.close(prompt_bufnr)

			-- Extract the directory name for the session name
			local session_name = dir:match("([^/]+)$")

			-- Get the list of existing tmux sessions
			local handle = io.popen('tmux list-sessions -F "#{session_name}"')
			local result = handle:read("*a")
			handle:close()

			-- Check if a session for the directory already exists
			if result:find(session_name) then
				-- Switch to the existing session
				os.execute("tmux switch-client -t " .. session_name)
			else
				-- Create a new session and switch to it
				os.execute("tmux new-session -c " .. dir .. " -s " .. session_name .. " -d")
				os.execute("tmux send-keys -t " .. session_name .. ' "nvim ." Enter')
				os.execute("tmux switch-client -t " .. session_name)
			end
		end

		local function find_directories()
			builtin.find_files({
				prompt_title = "Find Directories",
				cwd = "/Users/krugs/projects",
				attach_mappings = function(_, map)
					map("i", "<CR>", open_tmux_session)
					map("n", "<CR>", open_tmux_session)
					return true
				end,
				find_command = { "find", "/Users/krugs/projects", "-type", "d", "-maxdepth", "1" },
			})
		end

		-- Define your list of shell commands
		local shell_commands = {
			"ls -la",
			"pwd",
			"echo 'Hello, World!'",
			"date",
			"uname -a",
			"./import_prod_db.sh -t jelmolich -l",
      "./updating.sh all",
      "ddev launch",
      "ddev drush cr",
		}

		-- Function to execute a command asynchronously and show output in a floating window
		-- Custom function to list and execute shell commands
		-- Function to execute a command asynchronously and show output in a floating window
		local function execute_command_async(prompt_bufnr)
			local selected_entry = action_state.get_selected_entry()
			local command = selected_entry[1]
			actions.close(prompt_bufnr)

			-- Create a buffer for the floating window
			local buf = vim.api.nvim_create_buf(false, true)
			local width = vim.o.columns
			local height = vim.o.lines
			local win_height = math.ceil(height * 0.8)
			local win_width = math.ceil(width * 0.8)
			local row = math.ceil((height - win_height) / 2)
			local col = math.ceil((width - win_width) / 2)

			local opts = {
				style = "minimal",
				relative = "editor",
				width = win_width,
				height = win_height,
				row = row,
				col = col,
				border = "rounded",
			}

			local win = vim.api.nvim_open_win(buf, true, opts)

			-- Set key mappings to close the floating window

			-- Use termopen to handle ANSI color codes and automatic scrolling
			vim.fn.termopen(command, {
				on_exit = function()
          vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>bd!<CR>", { noremap = true, silent = true })
          vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "<cmd>bd!<CR>", { noremap = true, silent = true })
          vim.api.nvim_win_set_cursor(win, { vim.api.nvim_buf_line_count(buf), 0 })
					vim.api.nvim_buf_set_lines(buf, -1, -1, false, { "Command finished." })
          -- scroll to the bottom of the buffer
				end,
			})

		end

		local function list_shell_commands()
			pickers
				.new({}, {
					prompt_title = "Shell Commands",
					finder = finders.new_table({
						results = shell_commands,
					}),
					sorter = sorters({}),
					attach_mappings = function(_, map)
						map("i", "<CR>", execute_command_async)
						map("n", "<CR>", execute_command_async)
						return true
					end,
				})
				:find()
		end

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
		keymap.set("n", "<leader>fg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")
		keymap.set("n", "<leader>op", find_directories, { desc = "Find directories and open tmux session" })
		keymap.set("n", "<leader>sc", list_shell_commands, { desc = "List and execute shell commands" })
	end,
}
