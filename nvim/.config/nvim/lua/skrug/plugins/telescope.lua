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
					"--glob",
					"!**/.git/*",
					"--glob",
					"!**/node_modules/*",
				},
				layout_config = {
					width = 0.95,
					preview_width = 0.3
				},
			},
			pickers = {
				find_files = {
					hidden = true,
					find_command = {
						"rg",
						"--files",
						"--hidden",
						"--glob",
						"!**/.git/*",
						"--glob",
						"!**/node_modules/*",
					},
					file_ignore_patterns = { "^%.git/", "^node_modules/" },
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
		
		-- CodeCompanion Model Picker – opens a new chat with the selected adapter/model
		keymap.set("n", "<leader>am", function()
			local models = {
				-- ── Anthropic Claude ──────────────────────────────────────────
				{ adapter = "copilot",               model = "claude-sonnet-4-6",  display = "Claude Sonnet 4.6   ★ default  (Anthropic)" },
				{ adapter = "copilot_claude_sonnet45", model = "claude-sonnet-4-5", display = "Claude Sonnet 4.5              (Anthropic)" },
				{ adapter = "copilot_claude_sonnet4",  model = "claude-sonnet-4",   display = "Claude Sonnet 4                (Anthropic)" },
				{ adapter = "copilot_claude_haiku45",  model = "claude-haiku-4-5",  display = "Claude Haiku 4.5    fast       (Anthropic)" },
				{ adapter = "copilot_claude_opus46",   model = "claude-opus-4-6",   display = "Claude Opus 4.6     powerful   (Anthropic)" },
				{ adapter = "copilot_claude_opus45",   model = "claude-opus-4-5",   display = "Claude Opus 4.5               (Anthropic)" },
				-- ── OpenAI GPT-5.x ────────────────────────────────────────────
				{ adapter = "copilot_gpt54",        model = "gpt-5.4",          display = "GPT-5.4              latest     (OpenAI)" },
				{ adapter = "copilot_gpt54mini",    model = "gpt-5.4-mini",     display = "GPT-5.4 mini         fast       (OpenAI)" },
				{ adapter = "copilot_gpt53codex",   model = "gpt-5.3-codex",    display = "GPT-5.3 Codex        LTS/code   (OpenAI)" },
				{ adapter = "copilot_gpt52codex",   model = "gpt-5.2-codex",    display = "GPT-5.2 Codex        code       (OpenAI)" },
				{ adapter = "copilot_gpt52",        model = "gpt-5.2",          display = "GPT-5.2                         (OpenAI)" },
				{ adapter = "copilot_gpt5mini",     model = "gpt-5-mini",       display = "GPT-5 mini                      (OpenAI)" },
				-- ── OpenAI GPT-4.x ────────────────────────────────────────────
				{ adapter = "copilot_gpt41",        model = "gpt-4.1",          display = "GPT-4.1                         (OpenAI)" },
				-- ── Google Gemini ─────────────────────────────────────────────
				{ adapter = "copilot_gemini25pro",  model = "gemini-2.5-pro",   display = "Gemini 2.5 Pro                  (Google)" },
				{ adapter = "copilot_gemini3flash", model = "gemini-3-flash",   display = "Gemini 3 Flash       preview    (Google)" },
				{ adapter = "copilot_gemini31pro",  model = "gemini-3.1-pro",   display = "Gemini 3.1 Pro       preview    (Google)" },
				-- ── xAI Grok ──────────────────────────────────────────────────
				{ adapter = "copilot_grok",         model = "grok-code-fast-1", display = "Grok Code Fast 1                (xAI)" },
			}

			pickers.new({}, {
				prompt_title = "CodeCompanion – Copilot Models",
				finder = finders.new_table({
					results = models,
					entry_maker = function(entry)
						return {
							value   = entry,
							display = entry.display .. "  (" .. entry.model .. ")",
							ordinal = entry.display,
						}
					end,
				}),
				sorter = sorters({}),
				attach_mappings = function(prompt_bufnr, _)
					actions.select_default:replace(function()
						local selection = action_state.get_selected_entry()
						actions.close(prompt_bufnr)
						if selection then
							vim.schedule(function()
								vim.cmd("CodeCompanionChat " .. selection.value.adapter)
								vim.notify("CodeCompanion: " .. selection.value.display)
							end)
						end
					end)
					return true
				end,
			}):find()
		end, { desc = "Open CodeCompanion Chat with Model" })
	end,
}
