return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    require("which-key").setup({
      mappings = true,
      keys = {},
    })
  end,
}
