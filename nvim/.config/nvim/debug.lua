local home = os.getenv("HOME")

local bundles = {

  vim.fn.glob(home .. "/.local/share/nvim/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", true),
}

vim.list_extend(
  bundles,
  vim.split(vim.fn.glob(home .. "/.local/share/nvim/mason/packages/java-test/extension/server/*.jar", true), "\n")
)
local config = {
  init_options = {
    bundles = bundles,
  },
}
print(vim.inspect(config))
