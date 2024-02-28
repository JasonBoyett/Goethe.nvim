# Goethe 🖌️🎨

Johnathan Wolfgang von Goethe is the author of _Theory of Colours_.
But more importantly he also lends his name to this NeoVim plugin
that helps persist and manage your editor's color theme.

## Why

Treditinoally you set your color theme as part of your NeoVim config and
in order to change it you would have to edit your configuration file.
Goethe allows you to smiply change the theme directly in your editor either
with a vim command or using [telescope](https://github.com/nvim-telescope/telescope.nvim)
and have those changes persist in later sessions.

## Use and configuration

### Lazy

```lua
{
    "JasonBoyett/Goethe.nvim",
    opts = {
        default_theme = "vscode", -- the theme that will load if your saved theme cannot be found
        auto_persist = true, -- when true your theme will be saved automatically. When false it will have to be done manually
        override_group = { -- hilight groups that will override your theme
            group = "comment", -- the group you wish to override
            tbl = { fg = "#9c7322" } -- a table of the overrides to be applied
        }
    }
}
```

### Commands

```vimscript
:PersistTheme
```

If you want to manually chose when your theme is saved goethe exposes a vim
command "PersisTheme" that allows you to do so.
