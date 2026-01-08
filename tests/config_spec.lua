describe("registry-nvim.config", function()
  local config = require("registry-nvim.config")

  it("should have a registry key", function()
    local key = config.get_registry_key()
    assert.equals("listen_registery", key)
  end)

  it("should return config object", function()
    local cfg = config.get_config()
    assert.is_not_nil(cfg)
    assert.equals("listen_registery", cfg.listen_registry_key)
  end)

  it("should have get_registry function", function()
    assert.is_not_nil(config.get_registry)
    assert.is_function(config.get_registry)
  end)

  it("should have add_to_registry function", function()
    assert.is_not_nil(config.add_to_registry)
    assert.is_function(config.add_to_registry)
  end)

  it("should have remove_from_registry function", function()
    assert.is_not_nil(config.remove_from_registry)
    assert.is_function(config.remove_from_registry)
  end)

  it("should have update_registry function", function()
    assert.is_not_nil(config.update_registry)
    assert.is_function(config.update_registry)
  end)

  it("should have has_neoconf function", function()
    assert.is_not_nil(config.has_neoconf)
    assert.is_function(config.has_neoconf)
  end)
end)
