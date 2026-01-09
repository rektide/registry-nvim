local M = {}

local monitor = require("registry-nvim.monitor")
local cleanup = require("registry-nvim.cleanup")
local config = require("registry-nvim.config")

function M.setup(opts)
  opts = opts or {}

  config.setup(opts)

  if not config.has_neoconf() then
    vim.notify("registry-nvim requires neoconf.nvim", vim.log.levels.ERROR)
    return M
  end

  monitor.init()

  vim.api.nvim_create_user_command("RegistryCleanup", function()
    cleanup.cleanup_registry()
  end, {
    desc = "Clean up stale listen sockets from the registry",
  })

  return M
end

function M.start_monitor()
  monitor.start()
end

function M.stop_monitor()
  monitor.stop()
end

function M.cleanup()
  return cleanup.cleanup_registry()
end

return M
