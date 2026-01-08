describe("registry-nvim.monitor", function()
  local monitor = require("registry-nvim.monitor")

  it("should have get_current_server_socket function", function()
    assert.is_not_nil(monitor.get_current_server_socket)
    assert.is_function(monitor.get_current_server_socket)
  end)

  it("should have register_current_server function", function()
    assert.is_not_nil(monitor.register_current_server)
    assert.is_function(monitor.register_current_server)
  end)

  it("should have init function", function()
    assert.is_not_nil(monitor.init)
    assert.is_function(monitor.init)
  end)

  it("should have start function", function()
    assert.is_not_nil(monitor.start)
    assert.is_function(monitor.start)
  end)

  it("should have stop function", function()
    assert.is_not_nil(monitor.stop)
    assert.is_function(monitor.stop)
  end)

  it("should return string or nil from get_current_server_socket", function()
    local socket = monitor.get_current_server_socket()
    if socket then
      assert.is_string(socket)
    else
      assert.is_nil(socket)
    end
  end)
end)
