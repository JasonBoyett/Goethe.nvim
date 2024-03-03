# Goethe 🖌️🎨

Johann Wolfgang von Goethe is the author of _Theory of Colours_. More importantly, he also lends his name to this NeoVim plugin that helps persist and manage your editor's color theme.

## Why

Traditionally, you set your color theme as part of your NeoVim config, and in order to change it, you would have to edit your configuration file. Goethe allows you to simply change the theme directly in your editor either with a Vim command or using [Telescope](https://github.com/nvim-telescope/telescope.nvim), and have those changes persist in later sessions.

## Use and Configuration

### 💤Lazy.nvim

Use this snippet to install Goethe.nvim using the [Lazy package manager](https://github.com/folke/lazy.nvim):

base configuration with all default options

```lua
{
    "JasonBoyett/Goethe.nvim",
    dependencies = {
        {
           "nvim-telescope/telescope.nvim", -- Required for the theme history feature.
        },
        {
            "nvim-lua/plenary.nvim" -- Required for Telescope
        },
    },
    opts = {
        default_theme = "default",
        auto_persist = true,
    },
}
```

example custom configuration

```lua
{
    "JasonBoyett/Goethe.nvim",
    dependencies = {
        {
           "nvim-telescope/telescope.nvim", -- Required for the theme history feature.
        },
        {
            "nvim-lua/plenary.nvim" -- Required for Telescope
        },
    },
    opts = {
        default_theme = "vscode", -- The theme that will load if your saved theme cannot be found.
        auto_persist = true, -- When true, your theme will be saved automatically. When false, it will have to be done manually.
        override_group = { -- Highlight groups that will override your theme.
            {
                group = "comment", -- The group you wish to override.
                tbl = { fg = "#9c7322" } -- A table of the overrides to be applied.
            },
            {
                group = "conditional",
                theme = { italic = true },
            },
        },
        theme_overrides = { -- Some themes have variants that you may wish to use instead of the base theme. Use this option to override the main theme with its variant.
            {
                theme = "tokyonight", -- The theme you wish to override.
                variant = "tokyonight-storm", -- The theme variant you wish to override the original theme.
            },
            {
                theme = "ayu",
                variant = "ayu-dark",
            },
        }
    },
}
```

### Understanding `theme_overrides`

The `theme_overrides` option in Goethe.nvim allows you to specify that when certain themes are selected, a specific variant of that theme should be used instead. This is particularly useful for themes that offer multiple variants but do not explicitly change the `g:colors_name` variable to reflect the chosen variant. By specifying theme overrides, you ensure Goethe accurately persists your exact theme preferences, including any specific variants, across sessions.

For example, if you prefer the "tokyonight-storm" variant over the default "tokyonight" theme, configuring `theme_overrides` allows Goethe to remember and apply "tokyonight-storm" even though NeoVim's `g:colors_name` might only recognize it as "tokyonight". This feature supports multiple overrides, enabling a customized and nuanced theme setup tailored to your preferences.

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

This command is useful if you run into problems loading your theme history. It will erase and reset your history to a working, but empty state.

```vimscript
:ThemeReset
```

If you want to return to your default theme, simply run this command.

### Dependencies

#### [Telescope](https://github.com/nvim-telescope/telescope.nvim)

To utilize the theme history feature, you will need to have Telescope installed.
We recommend installing and configuring Telescope separately from your Goethe configuration,
as it offers a multitude of excellent options and constitutes a fundamental part of
the NeoVim ecosystem. Diving into Telescope’s configuration can greatly enhance your
editing environment, providing powerful search and navigation capabilities tailored to
your preferences.
