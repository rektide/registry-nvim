local M = {}

local config = require("registry-nvim.config")

function M.get_all()
  return config.get_registry()
end

function M.add(socket)
  if not socket or socket == "" then
    vim.notify("Cannot add empty socket to registry", vim.log.levels.WARN)
    return false
  end

  return config.add_to_registry(socket)
end

function M.remove(socket)
  if not socket or socket == "" then
    vim.notify("Cannot remove empty socket from registry", vim.log.levels.WARN)
    return false
  end

  return config.remove_from_registry(socket)
end

function M.update(new_registry)
  if type(new_registry) ~= "table" then
    vim.notify("Registry must be a table", vim.log.levels.ERROR)
    return false
  end

  return config.update_registry(new_registry)
end

function M.count()
  return #M.get_all()
end

function M.clear()
  return config.update_registry({})
end

function M.contains(socket)
  local registry = M.get_all()
  for _, s in ipairs(registry) do
    if s == socket then
      return true
    end
  end
  return false
end

return M
