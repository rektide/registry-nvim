local M = {}

function M.check()
  vim.health.start("registry-nvim")

  vim.health.ok("Plugin loaded")
end

return M
