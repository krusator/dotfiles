local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local builtin = require("telescope.builtin")
local M = {}
local function open_tmux_session(prompt_bufnr)
    local selected_entry = action_state.get_selected_entry()
    local dir = selected_entry[1]
    actions.close(prompt_bufnr)

    local session_name = dir:match("([^/]+)$")
    local handle = io.popen('tmux list-sessions -F "#{session_name}"')
    local result = handle:read("*a")
    handle:close()

    if result:find(session_name) then
        os.execute("tmux switch-client -t " .. session_name)
    else
        os.execute("tmux new-session -c " .. dir .. " -s " .. session_name .. " -d")
        os.execute("tmux send-keys -t " .. session_name .. ' "nvim ." Enter')
        os.execute("tmux switch-client -t " .. session_name)
    end
end

M.project_to_tmux = function()
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

return M
