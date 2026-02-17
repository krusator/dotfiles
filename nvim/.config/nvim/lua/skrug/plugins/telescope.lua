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
		
		-- Custom Avante Models Picker
		keymap.set("n", "<leader>am", function()
			local ok, avante_config = pcall(require, "avante.config")
			if not ok then
				vim.notify("Avante not available", vim.log.levels.ERROR)
				return
			end
			
			local models = {}
			local config = avante_config.options or avante_config
			local current_provider = config.provider
			local current_model = config.model or (config.providers and config.providers[current_provider] and config.providers[current_provider].model)
			
			-- Get all configured providers
			local providers_to_check = {}
			if config.providers then
				for provider_name, _ in pairs(config.providers) do
					table.insert(providers_to_check, provider_name)
				end
			end
			
			-- Try to get available models from each provider
			for _, provider_name in ipairs(providers_to_check) do
				local provider_ok, provider = pcall(require, "avante.providers." .. provider_name)
				if provider_ok and provider.list_models then
					-- Try to get models dynamically
					local models_ok, provider_models = pcall(function()
						return provider:list_models()
					end)
					
					if models_ok and provider_models then
						for _, model_info in ipairs(provider_models) do
							local model_id = model_info.id or model_info.name or model_info.display_name
							table.insert(models, {
								provider = provider_name,
								model = model_id,
								display_name = model_info.display_name or model_id,
								is_current = (current_provider == provider_name and current_model == model_id)
							})
						end
					else
						-- Fallback: use configured model
						local provider_config = config.providers[provider_name]
						if provider_config and provider_config.model then
							table.insert(models, {
								provider = provider_name,
								model = provider_config.model,
								display_name = provider_config.model,
								is_current = (current_provider == provider_name)
							})
						end
					end
				else
					-- Fallback: use configured model
					local provider_config = config.providers[provider_name]
					if provider_config and provider_config.model then
						table.insert(models, {
							provider = provider_name,
							model = provider_config.model,
							display_name = provider_config.model,
							is_current = (current_provider == provider_name)
						})
					end
				end
			end
			
			if #models == 0 then
				vim.notify("No Avante models found", vim.log.levels.WARN)
				return
			end
			
			pickers.new({}, {
				prompt_title = "Avante Models",
				finder = finders.new_table({
					results = models,
					entry_maker = function(entry)
						local display_text = string.format("[%s] %s", entry.provider, entry.display_name or entry.model)
						if entry.is_current then
							display_text = "* " .. display_text
						end
						return {
							value = entry,
							display = display_text,
							ordinal = entry.provider .. " " .. (entry.display_name or entry.model),
						}
					end,
				}),
				sorter = sorters({}),
				attach_mappings = function(prompt_bufnr, map)
					actions.select_default:replace(function()
						local selection = action_state.get_selected_entry()
						actions.close(prompt_bufnr)
						if selection then
							-- Use vim.schedule to defer the call and avoid callback issues
							vim.schedule(function()
								local ok, err = pcall(function()
									-- First switch provider, then optionally set the model
									require("avante.providers").refresh(selection.value.provider)
									-- Update the model in config if different from default
									require("avante.config").override({ 
										provider = selection.value.provider,
										model = selection.value.model
									})
									vim.notify(string.format("Switched to: %s (%s)", selection.value.display_name or selection.value.model, selection.value.provider))
								end)
								if not ok then
									vim.notify("Error switching provider: " .. tostring(err), vim.log.levels.ERROR)
								end
							end)
						end
					end)
					return true
				end,
			}):find()
		end, { desc = "Show Avante Models with Telescope" })
	end,
}
