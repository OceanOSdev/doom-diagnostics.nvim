# doom-diagnostics.nvim

Fix errors to heal Doomguy

A Neovim plugin that turns your diagnostics into Doomguy’s health.

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
    "3rd/image.nvim",
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

## Future improvements

* Configurable positioning
* Animation between states
* Theming / highlighting support

---

## License

MIT
