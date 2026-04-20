return {
  {
    "gruntwork-io/terragrunt-ls",
    dir = vim.fn.expand("~/Projects/peng/terragrunt-ls"),
    ft = "hcl",
    config = function()
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
  },
}
