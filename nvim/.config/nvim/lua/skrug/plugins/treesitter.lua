return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  config = function()
    -- Neovim 0.12+: highlight and indent are built-in via vim.treesitter.
    -- nvim-treesitter is used only for parser installation.
    require("nvim-treesitter").setup({
      auto_install = true,
      sync_install = false,
      ensure_installed = {
        "json",
        "javascript",
        "typescript",
        "tsx",
        "yaml",
        "html",
        "css",
        "prisma",
        "markdown",
        "markdown_inline",
        "graphql",
        "bash",
        "lua",
        "vim",
        "dockerfile",
        "gitignore",
        "query",
        "vimdoc",
        "c",
        "java",
        "php",
        "phpdoc",
        "regex",
        "twig",
        "diff",
        "gotmpl",
        "helm",
        "go",
      },
    })

    require("nvim-ts-autotag").setup()

    -- Neovim 0.12 broke nvim-treesitter directive handlers: `add_directive` now
    -- ignores `all=false`, so handlers always receive TSNode[] arrays instead of
    -- a single TSNode. Re-register the affected directives with array-aware logic.
    local function resolve_node(v)
      if not v then return nil end
      return type(v) == "userdata" and v or v[1]
    end

    local non_ft_aliases = { ex = "elixir", pl = "perl", sh = "bash", uxn = "uxntal", ts = "typescript" }
    local html_script_langs = {
      importmap = "json",
      module = "javascript",
      ["application/ecmascript"] = "javascript",
      ["text/ecmascript"] = "javascript",
    }

    vim.treesitter.query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
      local node = resolve_node(match[pred[2]])
      if not node then return end
      local alias = vim.treesitter.get_node_text(node, bufnr):lower()
      local ft = vim.filetype.match { filename = "a." .. alias }
      metadata["injection.language"] = ft or non_ft_aliases[alias] or alias
    end, { force = true })

    vim.treesitter.query.add_directive("set-lang-from-mimetype!", function(match, _, bufnr, pred, metadata)
      local node = resolve_node(match[pred[2]])
      if not node then return end
      local type_attr = vim.treesitter.get_node_text(node, bufnr)
      local configured = html_script_langs[type_attr]
      if configured then
        metadata["injection.language"] = configured
      else
        local parts = vim.split(type_attr, "/", {})
        metadata["injection.language"] = parts[#parts]
      end
    end, { force = true })

    vim.treesitter.query.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
      local id = pred[2]
      local node = resolve_node(match[id])
      if not node then return end
      local text = vim.treesitter.get_node_text(node, bufnr, { metadata = metadata[id] }) or ""
      if not metadata[id] then metadata[id] = {} end
      metadata[id].text = string.lower(text)
    end, { force = true })
  end,
}
