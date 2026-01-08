local ok, registry = pcall(require, "registry-nvim.init")
if not ok then
  return
end

registry.setup()
