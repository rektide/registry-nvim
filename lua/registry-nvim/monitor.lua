local M = {}

local registry = require("registry-nvim.registry")
local config = require("registry-nvim.config")
local cleanup = require("registry-nvim.cleanup")

local augroup = vim.api.nvim_create_augroup("RegistryNvimMonitor", { clear = true })

function M.get_current_server_socket()
  return vim.v.servername
end

function M.register_current_server()
  local socket = M.get_current_server_socket()
  if socket and socket ~= "" then
    if not registry.contains(socket) then
      registry.add(socket)
      vim.notify("Registered listen server: " .. socket, vim.log.levels.INFO)
      vim.schedule(function()
        cleanup.cleanup_registry()
      end)
    end
  end
end

function M.init()
  M.register_current_server()
end

function M.start()
  vim.api.nvim_create_autocmd("VimEnter", {
    group = augroup,
    callback = function()
      vim.schedule(function()
        M.register_current_server()
      end)
    end,
  })

  vim.api.nvim_create_autocmd("User", {
    group = augroup,
    pattern = "RemoteConnected",
    callback = function()
      vim.schedule(function()
        M.register_current_server()
      end)
    end,
  })
end

function M.stop()
  vim.api.nvim_clear_autocmds({ group = augroup })
end

return M
