local M = {}

local has_neoconf, neoconf = pcall(require, "neoconf")

local config = {
  listen_registry_key = "listen_registery",
}

function M.has_neoconf()
  return has_neoconf
end

function M.get_registry_key()
  return config.listen_registry_key
end

function M.get_registry()
  if not has_neoconf then
    vim.notify("neoconf not available", vim.log.levels.ERROR)
    return {}
  end

  local settings = neoconf.get(config.listen_registry_key)
  return settings or {}
end

function M.add_to_registry(socket)
  if not has_neoconf then
    vim.notify("neoconf not available", vim.log.levels.ERROR)
    return false
  end

  local registry = M.get_registry()

  for _, existing in ipairs(registry) do
    if existing == socket then
      return true
    end
  end

  table.insert(registry, socket)
  return M.update_registry(registry)
end

function M.remove_from_registry(socket)
  if not has_neoconf then
    vim.notify("neoconf not available", vim.log.levels.ERROR)
    return false
  end

  local registry = M.get_registry()
  local new_registry = {}

  for _, existing in ipairs(registry) do
    if existing ~= socket then
      table.insert(new_registry, existing)
    end
  end

  return M.update_registry(new_registry)
end

function M.update_registry(registry)
  if not has_neoconf then
    vim.notify("neoconf not available", vim.log.levels.ERROR)
    return false
  end

  neoconf.set(config.listen_registry_key, registry)
  return true
end

function M.get_config()
  return config
end

return M
