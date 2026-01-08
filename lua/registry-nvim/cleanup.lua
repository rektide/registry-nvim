local M = {}

local registry = require("registry-nvim.registry")
local has_plenary, async = pcall(require, "plenary.async")

function M.check_socket_valid(socket)
  if not socket or socket == "" then
    return false
  end

  local stat = vim.loop.fs_stat(socket)
  if not stat then
    return false
  end

  if stat.type ~= "socket" then
    return false
  end

  return true
end

function M.cleanup_registry()
  if not has_plenary then
    vim.notify("plenary.nvim not available for async cleanup", vim.log.levels.ERROR)
    return false
  end

  async.run(function()
    local current_registry = registry.get_all()
    local valid_sockets = {}

    for _, socket in ipairs(current_registry) do
      if M.check_socket_valid(socket) then
        table.insert(valid_sockets, socket)
      end
    end

    local removed_count = #current_registry - #valid_sockets

    registry.update(valid_sockets)

    vim.schedule(function()
      if removed_count > 0 then
        vim.notify("Cleaned up " .. removed_count .. " stale socket(s)", vim.log.levels.INFO)
      else
        vim.notify("No stale sockets found", vim.log.levels.INFO)
      end
    end)
  end, function(err)
    if err then
      vim.notify("Cleanup error: " .. tostring(err), vim.log.levels.ERROR)
    end
  end)

  return true
end

return M
