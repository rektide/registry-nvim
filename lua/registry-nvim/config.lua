local M = {}

local config = {
  listen_registry_key = "listen_registery",
}

function M.get_registry()
  return config.listen_registry_key
end

function M.get_config()
  return config
end

return M
