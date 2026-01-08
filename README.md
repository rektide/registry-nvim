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

## Configuration

The plugin uses `neoconf` for configuration. The listen registry is stored in global settings:

```lua
-- Global settings managed by neoconf
listen_registery = {
  "/tmp/nvim.sock",
  "/run/user/1000/nvim.1234.sock"
}
```

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
