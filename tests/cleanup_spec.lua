describe("registry-nvim.cleanup", function()
  local cleanup = require("registry-nvim.cleanup")

  it("should have cleanup_registry function", function()
    assert.is_not_nil(cleanup.cleanup_registry)
    assert.is_function(cleanup.cleanup_registry)
  end)

  it("should have check_socket_valid function", function()
    assert.is_not_nil(cleanup.check_socket_valid)
    assert.is_function(cleanup.check_socket_valid)
  end)

  it("should return false for empty socket", function()
    local valid = cleanup.check_socket_valid("")
    assert.is_false(valid)
  end)

  it("should return false for nil socket", function()
    local valid = cleanup.check_socket_valid(nil)
    assert.is_false(valid)
  end)

  it("should return boolean for valid socket check", function()
    local valid = cleanup.check_socket_valid("/tmp/nonexistent.sock")
    assert.is_boolean(valid)
  end)

  it("should return boolean from cleanup_registry", function()
    local result = cleanup.cleanup_registry()
    assert.is_boolean(result)
  end)

  it("should reject non-existent socket", function()
    local valid = cleanup.check_socket_valid("/tmp/definitely-not-a-socket-12345.sock")
    assert.is_false(valid)
  end)
end)
