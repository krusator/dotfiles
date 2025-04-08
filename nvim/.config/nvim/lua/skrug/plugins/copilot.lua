return {
  "github/copilot.vim",
  version = "1.41",
  config = function()
    vim.g.copilot_settings = { selectedCompletionModel = "gpt-4o-copilot" }
  end,
}
