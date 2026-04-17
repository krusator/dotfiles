return {
  "olimorris/codecompanion.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim",
    "folke/snacks.nvim",
    "nvim-tree/nvim-web-devicons",
    "zbirenbaum/copilot.lua",
    {
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = { insert_mode = true },
          use_absolute_path = true,
        },
      },
    },
    -- {
    --   "MeanderingProgrammer/render-markdown.nvim",
    --   opts = {
    --     file_types = { "markdown", "codecompanion" },
    --   },
    --   ft = { "markdown", "codecompanion" },
    -- },
  },
  keys = {
    { "<leader>ai", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "Toggle AI Chat" },
    { "<leader>aa", "<cmd>CodeCompanionActions<cr>",     mode = { "n", "v" }, desc = "AI Actions" },
    { "<leader>ac", "<cmd>CodeCompanionChat<cr>",        mode = { "n", "v" }, desc = "New AI Chat" },
  },
  opts = {
    adapters = {
      -- Default: Claude Sonnet 4.6 (latest stable Claude)
      copilot = function()
        return require("codecompanion.adapters").extend("copilot", {
          schema = { model = { default = "claude-sonnet-4-6" } },
        })
      end,
      -- ── Anthropic Claude ──────────────────────────────────────────────
      copilot_claude_haiku45 = function()
        return require("codecompanion.adapters").extend("copilot", {
          name = "copilot_claude_haiku45",
          schema = { model = { default = "claude-haiku-4-5" } },
        })
      end,
      copilot_claude_sonnet4 = function()
        return require("codecompanion.adapters").extend("copilot", {
          name = "copilot_claude_sonnet4",
          schema = { model = { default = "claude-sonnet-4" } },
        })
      end,
      copilot_claude_sonnet45 = function()
        return require("codecompanion.adapters").extend("copilot", {
          name = "copilot_claude_sonnet45",
          schema = { model = { default = "claude-sonnet-4-5" } },
        })
      end,
      copilot_claude_sonnet46 = function()
        return require("codecompanion.adapters").extend("copilot", {
          name = "copilot_claude_sonnet46",
          schema = { model = { default = "claude-sonnet-4-6" } },
        })
      end,
      copilot_claude_opus45 = function()
        return require("codecompanion.adapters").extend("copilot", {
          name = "copilot_claude_opus45",
          schema = { model = { default = "claude-opus-4-5" } },
        })
      end,
      copilot_claude_opus46 = function()
        return require("codecompanion.adapters").extend("copilot", {
          name = "copilot_claude_opus46",
          schema = { model = { default = "claude-opus-4-6" } },
        })
      end,
      -- ── OpenAI GPT-5.x ───────────────────────────────────────────────
      copilot_gpt54 = function()
        return require("codecompanion.adapters").extend("copilot", {
          name = "copilot_gpt54",
          schema = { model = { default = "gpt-5.4" } },
        })
      end,
      copilot_gpt54mini = function()
        return require("codecompanion.adapters").extend("copilot", {
          name = "copilot_gpt54mini",
          schema = { model = { default = "gpt-5.4-mini" } },
        })
      end,
      copilot_gpt53codex = function()
        return require("codecompanion.adapters").extend("copilot", {
          name = "copilot_gpt53codex",
          schema = { model = { default = "gpt-5.3-codex" } },
        })
      end,
      copilot_gpt52codex = function()
        return require("codecompanion.adapters").extend("copilot", {
          name = "copilot_gpt52codex",
          schema = { model = { default = "gpt-5.2-codex" } },
        })
      end,
      copilot_gpt52 = function()
        return require("codecompanion.adapters").extend("copilot", {
          name = "copilot_gpt52",
          schema = { model = { default = "gpt-5.2" } },
        })
      end,
      copilot_gpt5mini = function()
        return require("codecompanion.adapters").extend("copilot", {
          name = "copilot_gpt5mini",
          schema = { model = { default = "gpt-5-mini" } },
        })
      end,
      -- ── OpenAI GPT-4.x ───────────────────────────────────────────────
      copilot_gpt41 = function()
        return require("codecompanion.adapters").extend("copilot", {
          name = "copilot_gpt41",
          schema = { model = { default = "gpt-4.1" } },
        })
      end,
      -- ── Google Gemini ─────────────────────────────────────────────────
      copilot_gemini25pro = function()
        return require("codecompanion.adapters").extend("copilot", {
          name = "copilot_gemini25pro",
          schema = { model = { default = "gemini-2.5-pro" } },
        })
      end,
      copilot_gemini3flash = function()
        return require("codecompanion.adapters").extend("copilot", {
          name = "copilot_gemini3flash",
          schema = { model = { default = "gemini-3-flash" } },
        })
      end,
      copilot_gemini31pro = function()
        return require("codecompanion.adapters").extend("copilot", {
          name = "copilot_gemini31pro",
          schema = { model = { default = "gemini-3.1-pro" } },
        })
      end,
      -- ── xAI Grok ─────────────────────────────────────────────────────
      copilot_grok = function()
        return require("codecompanion.adapters").extend("copilot", {
          name = "copilot_grok",
          schema = { model = { default = "grok-code-fast-1" } },
        })
      end,
    },
    strategies = {
      chat = {
        adapter = "copilot",
        slash_commands = {
          ["file"]    = { opts = { provider = "telescope" } },
          ["buffer"]  = { opts = { provider = "telescope" } },
          ["symbols"] = { opts = { provider = "telescope" } },
        },
        tools = {
          ["editor"]     = { enabled = true },
          ["files"]      = { enabled = true },
          ["cmd_runner"] = { enabled = true },
          ["grep"]       = { enabled = true },
        },
      },
      inline = { adapter = "copilot" },
      cmd    = { adapter = "copilot" },
    },
    display = {
      diff = {
        enabled = true,
      },
    },
  },
}
