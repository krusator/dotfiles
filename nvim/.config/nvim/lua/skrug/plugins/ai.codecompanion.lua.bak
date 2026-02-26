return {
  "olimorris/codecompanion.nvim",

  version = "v17.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
  opts = {},
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("codecompanion").setup({
      strategies = {
        chat = {
          adapter = "copilot",
          -- adapter = "openai_responses",
        },
        inline = {
          adapter = "copilot",
          -- adapter = "openai_responses",
        },
        adapters = {
          -- openai_responses = function()
          --   return require("codecompanion.adapters").extend("openai_responses", {
          --     env = {
          --       api_key = "OPENAI_API_KEY",
          --     },
          --   })
          -- end,
          copilot = function()
            return require("codecompanion.adapters").extend("copilot", {
              schema = {
                model = {
                  default = "gpt-5-codex",
                  -- default = "gpt-4.1",
                },
              },
            })
          end,
        },
      },
    })
  end,
}
