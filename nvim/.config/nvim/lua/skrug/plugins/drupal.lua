return {
    "jdrupal-dev/drupal.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require("drupal").setup({
            services_cmp_trigger_character = "@",
            get_drush_executable = function(current_dir)
                return "ddev drush"
            end,
        })
        -- Check if the autocmd feature is available
        if vim.fn.has("autocmd") == 1 then
            -- Create an augroup named 'module'
            vim.api.nvim_create_augroup("module", { clear = true })
            vim.api.nvim_create_augroup('php_settings', { clear = true })


            -- Define a list of file extensions to be associated with the PHP filetype
            local drupal_filetypes = { "*.module", "*.install", "*.test", "*.inc", "*.profile", "*.view" }

            -- Iterate over each file extension and create an autocommand for it
            for _, pattern in ipairs(drupal_filetypes) do
                vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
                    pattern = pattern,
                    command = "set filetype=php",
                    group = "module",
                })
                vim.api.nvim_create_autocmd("FileType", {
                    pattern = pattern,
                    group = "php_settings",
                    callback = function()
                        -- Use spaces instead of tabs
                        vim.opt_local.expandtab = true

                        -- Number of spaces that a <Tab> in the file counts for
                        vim.opt_local.tabstop = 2

                        -- Number of spaces to use for each step of (auto)indent
                        vim.opt_local.shiftwidth = 2

                        -- Copy indent from current line when starting a new line
                        vim.opt_local.autoindent = true

                        -- Make indenting smarter
                        vim.opt_local.smartindent = true
                    end,
                })
            end
        end

        -- Enable syntax highlighting
        vim.cmd("syntax on")
    end,
}
