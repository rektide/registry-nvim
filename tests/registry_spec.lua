describe("registry-nvim.registry", function()
  local registry = require("registry-nvim.registry")

  it("should have get_all function", function()
    assert.is_not_nil(registry.get_all)
    assert.is_function(registry.get_all)
  end)

  it("should have add function", function()
    assert.is_not_nil(registry.add)
    assert.is_function(registry.add)
  end)

  it("should have remove function", function()
    assert.is_not_nil(registry.remove)
    assert.is_function(registry.remove)
  end)

  it("should have update function", function()
    assert.is_not_nil(registry.update)
    assert.is_function(registry.update)
  end)

  it("should have count function", function()
    assert.is_not_nil(registry.count)
    assert.is_function(registry.count)
  end)

  it("should have clear function", function()
    assert.is_not_nil(registry.clear)
    assert.is_function(registry.clear)
  end)

  it("should have contains function", function()
    assert.is_not_nil(registry.contains)
    assert.is_function(registry.contains)
  end)

  it("should return a table from get_all", function()
    local all = registry.get_all()
    assert.is_table(all)
  end)

  it("should return a number from count", function()
    local count = registry.count()
    assert.is_number(count)
  end)

  it("should return boolean from contains", function()
    local contains = registry.contains("/tmp/test.sock")
    assert.is_boolean(contains)
  end)

  it("should reject empty socket for add", function()
    local result = registry.add("")
    assert.is_false(result)
  end)

  it("should reject nil socket for add", function()
    local result = registry.add(nil)
    assert.is_false(result)
  end)

  it("should reject empty socket for remove", function()
    local result = registry.remove("")
    assert.is_false(result)
  end)

  it("should reject nil socket for remove", function()
    local result = registry.remove(nil)
    assert.is_false(result)
  end)

  it("should reject non-table update", function()
    local result = registry.update("not a table")
    assert.is_false(result)
  end)

  it("should reject nil update", function()
    local result = registry.update(nil)
    assert.is_false(result)
  end)

  it("should return boolean from clear", function()
    local result = registry.clear()
    assert.is_boolean(result)
  end)
end)
