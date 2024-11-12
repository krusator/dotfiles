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
          file_ignore_patterns = { 'node_modules', '.git' },
          hidden = true,
        },
        live_grep = {
          file_ignore_patterns = { '.git', 'node_modules' },
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
      local action_state = require('telescope.actions.state')
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
        os.execute('tmux switch-client -t ' .. session_name)
      else
        -- Create a new session and switch to it
        os.execute('tmux new-session -c ' .. dir .. ' -s ' .. session_name .. ' -d')
        os.execute('tmux send-keys -t ' .. session_name .. ' "nvim ." Enter')
        os.execute('tmux switch-client -t ' .. session_name)
      end
    end

    local function find_directories()
      require('telescope.builtin').find_files({
        prompt_title = "Find Directories",
        cwd = "/Users/krugs/Projects",
        attach_mappings = function(_, map)
          map('i', '<CR>', open_tmux_session)
          map('n', '<CR>', open_tmux_session)
          return true
        end,
        find_command = {'find', '/Users/krugs/Projects', '-type', 'd', '-maxdepth', '1' }
      })
    end

    -- Set keymaps
    local keymap = vim.keymap -- for conciseness

    keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
    keymap.set("n", "<leader>fh", function() builtin.live_grep({ cwd = utils.buffer_dir() }) end, { desc = "Fuzzy find files in current buffer's directory" })
    keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
    keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
    keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
    keymap.set("n", "<leader>fD", "<cmd>Telescope diagnostics<cr>", { desc = "Show all diagnostics" })
    keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<cr>", { desc = "Fuzzy find git branches" })
    keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
    keymap.set("n", "<leader>fg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")
    keymap.set("n", "<leader>op", find_directories, { desc = "Find directories and open tmux session" })
  end,
  }
