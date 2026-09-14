-- Plugins loaded straight from a local, actively developed checkout — kept
-- entirely outside the lazy.nvim-managed `plugins/` directory on purpose.
--
-- Prepending to 'runtimepath' works regardless of plugin manager (lazy.nvim,
-- vim.pack, or none at all), unlike lazy.nvim's `dir = ...` spec field, which
-- is a lazy.nvim-specific mechanism. This keeps the local-dev workflow
-- (edits are picked up live, no install/update step) independent of
-- whatever manages the rest of the plugins.

-- terragrunt-ls: https://github.com/gruntwork-io/terragrunt-ls
local terragrunt_ls_dir = vim.fn.expand("~/Projects/peng/terragrunt-ls")
if vim.fn.isdirectory(terragrunt_ls_dir) == 1 then
  vim.opt.rtp:prepend(terragrunt_ls_dir)

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "hcl",
    once = true,
    callback = function()
      local terragrunt_ls = require("terragrunt-ls")
      terragrunt_ls.setup({
        cmd_env = {
          -- TG_LS_LOG = vim.fn.expand("/tmp/terragrunt-ls.log"),
        },
      })
      if terragrunt_ls.client then
        vim.api.nvim_create_autocmd("FileType", {
          pattern = "hcl",
          callback = function()
            vim.lsp.buf_attach_client(0, terragrunt_ls.client)
          end,
        })
      end
    end,
  })
end
