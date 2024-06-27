local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local package_json_script_picker = function(opts)
	opts = opts or {}
	-- check if package.json exists in the current directory
	local current_dir = vim.fn.expand("%:p:h")
	local package_json = vim.fn.glob(current_dir .. "/package.json")
	-- if package.json exists, read it and content of scripts
	local script_results = {}
	if package_json ~= "" then
		local package_json_content = vim.fn.json_decode(vim.fn.readfile(package_json))
		local scripts = package_json_content.scripts
		-- if scripts exists, create a table with the scripts
		if scripts then
			for key, value in pairs(scripts) do
				table.insert(script_results, { key, value })
			end
		end
	end
	-- create a new picker with the scripts
	pickers
		.new(opts, {
			prompt_title = "Npm Scripts",
			finder = finders.new_table({
				results = script_results,
				entry_maker = function(entry)
					return {
						value = entry,
						display = entry[1],
						ordinal = entry[1],
					}
				end,
			}),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(prompt_bufnr)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					print(vim.inspect(selection.value[2]))
					-- Create a new not modifiable buffer with the vim api and insert the color code
					-- local buf = vim.api.nvim_create_buf(false, true)
					-- vim.api.nvim_buf_set_lines(buf, 0, -1, false, { selection.value[2] })
					-- vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
					-- vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
					-- vim.api.nvim_buf_set_option(buf, "buflisted", false)
					-- vim.api.nvim_buf_set_option(buf, "modifiable", false)
					-- -- open the buffer in a new window under the current one
					-- vim.api.nvim_command("buffer " .. buf)
					vim.api.nvim_command("10split")
					-- execute command and show output in terminal
					vim.api.nvim_command("term " .. selection.value[2])
				end)
				return true
			end,
		})
		:find()
end

package_json_script_picker(require("telescope.themes").get_dropdown({}))
