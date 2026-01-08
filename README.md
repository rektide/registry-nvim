# registry-nvim

Track all Neovim listen servers across all instances.

## Features

- Automatically discover and track listen servers across all Neovim instances
- Uses `neoconf` to maintain a global registry of active listen servers
- Cleanup capability to remove stale/invalid listen sockets
- Modular architecture with sensible file organization
- Built-in healthcheck for diagnostics
- Comprehensive help documentation

## Usage

The plugin automatically monitors and updates the listen registry. By default, listen servers are tracked in the global `neoconf` settings under the `listen-registery` property.

### Manual Commands

- `:RegistryCleanup` - Clean up stale listen sockets from the registry

### Programmatic Usage

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

**Sync clipboard from terminal:**

```bash
# Copy to all Neovim instances
pbpaste | ./scripts/registry-send

# Or with xclip on Linux
xclip -o | ./scripts/registry-send
```

**Automated cleanup:**

```lua
-- Add periodic cleanup to your config
vim.api.nvim_create_autocmd("User", {
  pattern = "RegistryCleanup",
  callback = function()
    require("registry-nvim").cleanup()
  end,
})

-- Manually trigger via:
:RegistryCleanup
```

**Custom monitoring control:**

```lua
-- Stop monitoring temporarily
require("registry-nvim").stop_monitor()

-- Do some work...

-- Restart monitoring
require("registry-nvim").start_monitor()
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

### Lazy.nvim Configuration Example

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

- Called once during plugin setup to ensure the current instance is tracked immediately
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
- **Cleanup Required**: Stale sockets remain in the registry until manually cleaned via `:RegistryCleanup`

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

## Requirements

- Neovim >= 0.9.0
- [neoconf.nvim](https://github.com/folke/neoconf.nvim)
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)

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

### CLI Tool

The `scripts/registry-send` script allows you to send content to all registered Neovim instances:

```bash
# Send text to all sessions' clipboard
echo "Hello from terminal" | ./scripts/registry-send

# Send to a specific register
echo "Important text" | ./scripts/registry-send -r +

# Only send if an environment guard matches
export CLIPBOARD_STATE=enabled
echo "Sensitive data" | ./scripts/registry-send -e CLIPBOARD_STATE=enabled

# Use in shell scripts for clipboard synchronization
cat file.txt | ./scripts/registry-send
```

**CLI Dependencies:**

- `jq` - For parsing neoconf JSON
- `nvim` - For server communication

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
