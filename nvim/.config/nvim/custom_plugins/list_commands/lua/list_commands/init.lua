M = {}
local telescope = require("telescope")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local sorters = require("telescope.config").values.generic_sorter

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

local function execute_command_async(prompt_bufnr)
    local selected_entry = action_state.get_selected_entry()
    local command = selected_entry[1]
    actions.close(prompt_bufnr)

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

    vim.fn.termopen(command, {
        on_exit = function()
            vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>bd!<CR>", { noremap = true, silent = true })
            vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "<cmd>bd!<CR>", { noremap = true, silent = true })
            vim.api.nvim_win_set_cursor(win, { vim.api.nvim_buf_line_count(buf), 0 })
            vim.api.nvim_buf_set_lines(buf, -1, -1, false, { "Command finished." })
        end,
    })
end

local function list_shell_commands()
    pickers.new({}, {
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
    }):find()
end

M.list_commands = list_shell_commands
return M
