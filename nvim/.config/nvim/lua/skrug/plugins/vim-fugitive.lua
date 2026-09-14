return {
  "tpope/vim-fugitive",
  config = function()
    local function git_in_split(args)
      return function()
        vim.cmd("botright 15new")
        vim.fn.termopen("git " .. args)
      end
    end

    vim.keymap.set("n", "<leader>cc", "<cmd>Git commit .<CR>", { desc = "Git commit all" })
    vim.keymap.set("n", "<leader>gf", "<cmd>Git commit %<CR>", { desc = "Git commit current file" })
    vim.keymap.set("n", "<leader>gp", git_in_split("push"), { desc = "Git push" })
    vim.keymap.set("n", "<leader>gu", "<cmd>Git pull<CR>", { desc = "Git pull" })
    vim.keymap.set("n", "<leader>gs", "<cmd>Git<CR>", { desc = "Git status" })
  end,
}
