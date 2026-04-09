# doom-diagnostics.nvim

[![CI](https://github.com/OceanOSdev/doom-diagnostics.nvim/actions/workflows/ci.yaml/badge.svg)](https://github.com/OceanOSdev/doom-diagnostics.nvim/actions/workflows/ci.yaml)
[![Latest Release](https://img.shields.io/github/v/release/OceanOSdev/doom-diagnostics.nvim?sort=semver)](https://github.com/OceanOSdev/doom-diagnostics.nvim/releases/latest)

Fix errors to heal Doomguy

A Neovim plugin that displays a Doom-style HUD based on your diagnostics.

Originally started as a small one-off personal plugin, but I figured I'd clean it up and throw it on Github.

---

## Features

* Visual feedback based on diagnostics (errors, warnings, hints)
* Floating HUD anchored to the editor
* Optional image rendering via `image.nvim`
* ASCII fallback when images are unavailable
* Updates automatically as you work

---

## Requirements

* Neovim 0.9+
* Optional: `3rd/image.nvim` for sprite rendering

If `image.nvim` is not available, the plugin falls back to ASCII mode.

> [!NOTE]
> `image.nvim` requires additional system dependencies such as ImageMagick.

---

## Installation (lazy.nvim)

### ASCII mode

```lua
{
  "OceanOSdev/doom-diagnostics.nvim",
  opts = {
    force_ascii = true,
  },
}
```

### With image support

```lua
{
  "OceanOSdev/doom-diagnostics.nvim",
  dependencies = {
    { "3rd/image.nvim", opts = {} },  -- ensure image.nvim runs setup()
  },
  opts = {
    force_ascii = false,
  },
}
```

---

## Configuration

Default configuration:

```lua
{
  win_width = 25,
  pain_weights = {
    error = 10,
    warning = 5,
    hint = 1,
  },
  force_ascii = false,
}
```

Example:

```lua
{
  "OceanOSdev/doom-diagnostics.nvim",
  opts = {
    win_width = 30,
    pain_weights = {
      error = 20,
      warning = 5,
      hint = 0,
    },
  },
}
```

---

## Usage

Toggle the HUD:

```
:DoomToggle
```

The HUD updates automatically when:

* diagnostics change
* buffers or windows change
* an LSP client attaches

More errors -> more pain

Fewer errors -> Doomguy recovers

---

## Notes

* The HUD is hidden in special buffers (e.g. Telescope, file explorers)
* The HUD currently only appears when an LSP client is attached
* Position is fixed to the top-right corner (for now)

---

## Troubleshooting

### Images are not rendering

If the HUD is visible but no sprite appears:

- Make sure `image.nvim` is installed and loaded
- Ensure required system dependencies (e.g. ImageMagick) are installed
- Try enabling ASCII mode to confirm the plugin is working:

```lua
{
  "OceanOSdev/doom-diagnostics.nvim",
  opts = {
    force_ascii = true,
  },
}
```

---

## Future improvements

* Configurable positioning
* Animation between states
* Theming / highlighting support

---

## License

MIT
