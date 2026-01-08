local M = {}

local config = require("registry-nvim.config")
local registry = require("registry-nvim.registry")

function M.check()
  vim.health.start("registry-nvim")

  if config.has_neoconf() then
    vim.health.ok("neoconf.nvim is available")
  else
    vim.health.error("neoconf.nvim is not installed or not loaded")
  end

  local has_plenary, _ = pcall(require, "plenary.async")
  if has_plenary then
    vim.health.ok("plenary.nvim is available")
  else
    vim.health.warn("plenary.nvim is not available - cleanup functionality will be limited")
  end

  if config.has_neoconf() then
    local reg = registry.get_all()
    if type(reg) == "table" then
      vim.health.ok(string.format("Registry contains %d socket(s)", #reg))

      if #reg == 0 then
        vim.health.info("Registry is empty - no listen servers currently tracked")
      end
    else
      vim.health.error("Registry data is not a table")
    end
  end

  local server_socket = vim.v.servername
  if server_socket and server_socket ~= "" then
    vim.health.ok("Current instance has listen server: " .. server_socket)
  else
    vim.health.info("Current instance does not have a listen server")
  end
end

return M
