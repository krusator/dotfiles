return {
    -- PHPCS installation. 
    {
        "praem90/nvim-phpcsf",
        config = function()
            vim.g.nvim_phpcs_config_phpcs_path = './vendor/bin/phpcs'
            vim.g.nvim_phpcs_config_phpcbf_path = './vendor/bin/phpcbf'
            vim.g.nvim_phpcs_config_phpcs_standard = 'Drupal' -- or path to your ruleset phpcs.xml
            vim.keymap.set('n', '<leader>pc', ":lua require'phpcs'.cs()<CR>", { noremap = true, silent = true, desc = 'Run phpcs' })
            vim.keymap.set('n', '<leader>pf', ":lua require'phpcs'.cbf()<CR>:lua require'phpcs'.cs()<CR>", { noremap = true, silent = true, desc = 'Run phpcbf' })
        end
    },
}
