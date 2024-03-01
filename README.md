# Goethe 🖌️🎨

Johann Wolfgang von Goethe is the author of _Theory of Colours_. More importantly, he also lends his name to this NeoVim plugin that helps persist and manage your editor's color theme.

## Why

Traditionally, you set your color theme as part of your NeoVim config, and in order to change it, you would have to edit your configuration file. Goethe allows you to simply change the theme directly in your editor either with a Vim command or using [Telescope](https://github.com/nvim-telescope/telescope.nvim), and have those changes persist in later sessions.

## Use and Configuration

### 💤Lazy.nvim

Use this snippet to install Goethe.nvim using the [Lazy package manager](https://github.com/folke/lazy.nvim)

```lua
{
    "JasonBoyett/Goethe.nvim",
    dependencies = {
        {
           "nvim-telescope/telescope.nvim" -- Required for theme history feature.
        },
    },
    opts = {
        default_theme = "vscode", -- The theme that will load if your saved theme cannot be found.
        auto_persist = true, -- When true, your theme will be saved automatically. When false, it will have to be done manually.
        override_group = { -- Highlight groups that will override your theme.
            group = "Comment", -- The group you wish to override.
            tbl = { fg = "#9c7322" } -- A table of the overrides to be applied.
        },
    },
}
```

### Commands

```vimscript
:PersistTheme
```

If you want to manually choose when your theme is saved, Goethe exposes a Vim command "PersistTheme" that allows you to do so.

```vimscript
:ThemeHistory
```

Goethe keeps track of your color theme changes and offers a Vim command to view your history and select a previous theme.

```vimscript
:ThemeHistoryReset
```

This command is useful if you run into problems loading your theme history.
It will erase and re-set your history to a working, but empty state.

```vimscript
:ThemeReset
```

If you want to return to your default theme simply run this command.

### Dependencies

#### [Telescope](https://github.com/nvim-telescope/telescope.nvim)

In order to use the theme history feature, you will need to have Telescope installed.
