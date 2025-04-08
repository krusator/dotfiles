return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = false },
    dashboard = { enabled = true },
    explorer = { enabled = false },
    indent = { enabled = true },
    input = { enabled = true },
    picker = { enabled = false },
    notifier = { enabled = true, width = { min = 40, max = 0.9 }, style = "fancy" },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = false },
    statuscolumn = { enabled = true },
    words = { enabled = true },
  },
}
