return {
  "tpope/vim-fugitive",
  config = function ()
    vim.keymap.set("n", "<leader>gc", "<cmd>Git commit .<CR>", { desc = "Git commit all" })
    vim.keymap.set("n", "<leader>gf", "<cmd>Git commit %<CR>", { desc = "Git commit current file" })
    vim.keymap.set("n", "<leader>gp", "<cmd>Git push<CR>", { desc = "Git push" })
    vim.keymap.set("n", "<leader>gu", "<cmd>Git pull<CR>", { desc = "Git pull" })
    vim.keymap.set("n", "<leader>gs", "<cmd>Git<CR>", { desc = "Git status" })
  end
}
