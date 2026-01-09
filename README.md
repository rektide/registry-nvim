# registry-nvim

registry-nvim helps you coordinate multiple Neovim instances by automatically tracking all listen servers. This enables workflows where you need to send commands, content, or data to every running Neovim session from the command line or external tools. Common use cases include synchronizing clipboard content across all Neovim instances, executing bulk operations, or coordinating editor state from shell scripts.

## Features

- **Automatic Discovery & Tracking**
  - Automatically discovers all Neovim instances with listen servers
  - Self-registration model where each instance adds itself to the registry
  - Works across all Neovim instances on your system

- **Global Registry via neoconf**
  - Uses neoconf.nvim to maintain a persistent, global registry
  - Registry stored under `listen_registery` key in global settings
  - Shared across all Neovim instances with plugin installed

- **Automatic Cleanup**
  - Automatically removes stale sockets when new instances register
  - Validates socket existence using plenary.nvim async operations
  - Keeps registry clean without manual intervention

- **CLI Tool for Content Distribution**
  - Send stdin content to all registered Neovim instances
  - Supports filtering with regex patterns and environment guards
  - Choose target registers for each send operation

## Usage

registry-nvim runs automatically when installed. Each Neovim instance registers its listen server on startup and maintains a global registry via neoconf. The registry is cleaned automatically when new instances register.

### Dependencies

The plugin requires these external libraries:

- **neoconf.nvim** - Required for storing the listen registry in global settings
- **plenary.nvim** - Required for async socket validation and cleanup

### Manual Commands

- `:RegistryCleanup` - Manually clean up stale listen sockets from the registry (rarely needed as cleanup runs automatically)

### CLI Tool: registry-send

The `scripts/registry-send` script sends content from stdin to all Neovim instances in the registry. This is useful for synchronizing clipboard data, sending commands, or distributing content across all your Neovim sessions.

**CLI Dependencies:**
- `jq` - For parsing neoconf JSON configuration
- `nvim` - For server communication with Neovim instances

**Basic Usage:**

```bash
# Send text to all sessions' clipboard register
echo "Hello from terminal" | ./scripts/registry-send

# Send to a specific register
echo "Important text" | ./scripts/registry-send -r +

# Only send if content matches a regex pattern
echo "error" | ./scripts/registry-send -match "^error"
```

**Advanced Features:**

```bash
# Environment guard - only send if environment variable matches
export CLIPBOARD_STATE=enabled
echo "Sensitive data" | ./scripts/registry-send -e CLIPBOARD_STATE=enabled

# Combine multiple flags
echo "data" | ./scripts/registry-send -r + -match "^data:" -e SYNC_ENABLED=true

# Use with clipboard tools
pbpaste | ./scripts/registry-send  # macOS
xclip -o | ./scripts/registry-send  # Linux

# Send file contents
cat config.txt | ./scripts/registry-send
```

### Programmatic Usage

The Lua API provides direct access to the registry:

```lua
local registry = require("registry-nvim")

-- Get all registered sockets
local sockets = registry.get_all()

-- Add a socket manually
registry.add("/tmp/nvim.sock")

-- Remove a socket manually
registry.remove("/tmp/nvim.sock")

-- Check if a socket is registered
if registry.contains("/tmp/nvim.sock") then
  print("Socket is registered")
end

-- Get count of registered sockets
local count = registry.count()

-- Clear all sockets
registry.clear()

-- Manually trigger cleanup
registry.cleanup()
```

### Advanced Workflows

**Monitoring Control:**

```lua
-- Stop monitoring temporarily
require("registry-nvim").stop_monitor()

-- Do some work...

-- Restart monitoring
require("registry-nvim").start_monitor()
```

**Periodic Cleanup (Custom):**

```lua
-- Add additional periodic cleanup to your config
vim.api.nvim_create_autocmd("User", {
  pattern = "RegistryCleanup",
  callback = function()
    require("registry-nvim").cleanup()
  end,
})
```

## Configuration

The plugin uses `neoconf` for configuration. The listen registry is stored in global settings:

```lua
-- Global settings managed by neoconf
listen_registery = {
  "/tmp/nvim.sock",
  "/run/user/1000/nvim.1234.sock"
}
```

### Lazy.nvim Configuration

```lua
{
  'yourusername/registry-nvim',
  dependencies = {
    'folke/neoconf.nvim',
    'nvim-lua/plenary.nvim',
  },
  config = function()
    local registry = require('registry-nvim')

    -- Basic setup
    registry.setup()

    -- Or with manual control of monitoring
    registry.setup()
    -- Later in your config:
    registry.start_monitor()
  end,
}
```

## Discovery

registry-nvim uses **self-registration** to discover listen servers. Each Neovim instance registers itself when it starts, rather than actively scanning the system for running instances.

### How Discovery Works

**1. Initial Socket Detection / Registration**

- Called once during plugin setup to ensure current instance is tracked immediately
- The plugin reads the current instance's listen server path from `vim.v.servername`
- This contains the path to the Unix domain socket (e.g., `/run/user/1000/nvim.12345.sock`)
- Only Neovim instances with listen servers are tracked

**2. Autocmd Triggers**

- **VimEnter**: Registers the current instance on startup (scheduled to run after full initialization)
- **User RemoteConnected**: Re-registers when a remote client connects to this instance

### Important Notes

- **Requires Plugin Installation**: Each Neovim instance must have registry-nvim installed to be discovered
- **No Active Scanning**: The plugin doesn't scan filesystems or monitor socket directories
- **Accumulative Registry**: The registry builds up over time as instances start and stop
- **Automatic Cleanup**: Stale sockets are removed automatically when new instances register themselves

### Discovery Flow

```
Neovim starts → registry-nvim loads → reads vim.v.servername
→ adds to neoconf registry → persists across sessions
```

### What's Not Implemented

The following discovery mechanisms are **not** implemented:

- Filesystem scanning for socket files
- IPC discovery of other Neovim instances
- Directory monitoring for new sockets
- Network-level discovery

The current approach is simple, reliable, and requires minimal overhead, but depends on each Neovim instance having the plugin installed.

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  'yourusername/registry-nvim',
  dependencies = {
    'folke/neoconf.nvim',
    'nvim-lua/plenary.nvim',
  },
  config = function()
    require('registry-nvim').setup()
  end,
}
```

## Architecture

The plugin is organized into modular components:

- `registry.lua` - Main registry module
- `monitor.lua` - Listen server discovery and monitoring
- `cleanup.lua` - Async socket validation and cleanup
- `config.lua` - Configuration management
- `health.lua` - Neovim healthcheck
- `init.lua` - Plugin initialization

## Development

### Healthcheck

Run the healthcheck to verify plugin status:

```vim
:checkhealth registry-nvim
```

## Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

## License

MIT

## Author

Created to improve multi-instance Neovim workflow management.
