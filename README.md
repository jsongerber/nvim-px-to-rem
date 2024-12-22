# nvim-px-to-rem

> Easily work with rem in your css files

A Neovim plugin written in lua to convert px to rem as you type. It also provide commands and [~~keymaps~~](#-keymaps) to convert px to rem and a virtual text to visualize your rem values.

<div align="center">

https://github.com/jsongerber/nvim-px-to-rem/assets/18051702/9ac54364-2115-4c9e-8354-f0991f11c82d

</div>

## ⚡️ Features

- Easily convert px to rem as you type (require [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) or [blink.cmp](https://github.com/Saghen/blink.cmp))
- Convert px to rem on a single value or a whole line
- Visualize your rem values in a virtual text

## 📋 Installation

- With [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
    'jsongerber/nvim-px-to-rem',
    config = function()
        require('nvim-px-to-rem').setup()
    end
}
```

- With [vim-plug](https://github.com/junegunn/vim-plug)

```lua
Plug 'jsongerber/nvim-px-to-rem

" Somewhere after plug#end()
lua require('nvim-px-to-rem').setup()
```

- With [folke/lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
-- add this to your lua/plugins.lua, lua/plugins/init.lua,  or the file you keep your other plugins:
{
    'jsongerber/nvim-px-to-rem',
    config = true,
    --If you need to set some options replace the line above with:
    -- config = function()
    --     require('nvim-px-to-rem').setup()
    -- end,
}
```

## ⚙ Configuration

```lua
-- Those are the default values and can be ommited
require("nvim-px-to-rem").setup({
    root_font_size = 16,
    decimal_count = 4,
    show_virtual_text = true,
    filetypes = {
        "css",
        "scss",
        "sass",
    },
})
```

| Option              | Description                                                                                                                                    | Default value |
| ------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | ------------- |
| `root_font_size`    | The font size used to convert px to rem                                                                                                        | `16`          |
| `decimal_count`     | The number of decimal to keep when converting px to rem                                                                                        | `4`           |
| `show_virtual_text` | Show the rem value converted in px in a virtual text                                                                                           | `true`        |
| `add_cmp_source`    | Add a nvim-cmp source to convert px to rem as you type (require [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)), disable if you use blink.cmp | `true`        |

### nvim-cmp integration

<details>
<summary>Show configuration for nvim-cmp</summary>

[nvim-cmp](https://github.com/hrsh7th/nvim-cmp) to convert px to rem as you type.

```lua
require("cmp").setup({
    -- other config
    sources = cmp.config.sources({
        { name = "nvim_px_to_rem" },
        -- other sources
    }),
})

```

Do not forget to set `add_cmp_source` to `true` in the setup function

</details>

### blink.cmp integration

<details>
<summary>Show configuration for blink.cmp</summary>

[nvim-cmp](https://github.com/hrsh7th/nvim-cmp) to convert px to rem as you type.

```lua
return {
  'saghen/blink.cmp',
  dependencies = {
    'jsongerber/nvim-px-to-rem',
    -- other dependencies
    -- …
  },
  opts = {
    sources = {
      default = {
        -- you need to add this line
        'nvim-px-to-rem',
        -- your other sources
        'lsp',
        'path',
        'snippets',
        'buffer',
        'lazydev',
      },
      providers = {
        ['nvim-px-to-rem'] = {
          module = 'nvim-px-to-rem.integrations.blink',
          name = 'nvim-px-to-rem',
        },
        -- other providers
        -- …
      },
    },
  },
}
```

Do not forget to set `add_cmp_source` (which is for nvim-cmp and not blink) to `false` in the setup function

</details>

## 🧰 Commands

| Command          | Description                         |
| ---------------- | ----------------------------------- |
| `:PxToRemCursor` | Convert px to rem under cursor      |
| `:PxToRemLine`   | Convert px to rem on the whole line |

## 📚 Keymaps

> [!WARNING]
> This plugin used to provide default keymaps but it was removed as it was poorly chosen.
> If you used default keymaps you will need to set them yourself.

You can set keymaps like so:

```lua
vim.api.nvim_set_keymap("n", "<leader>pxx", ":PxToRemCursor<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>pxl", ":PxToRemLine<CR>", { noremap = true })
```

## ⌨ Contributing

PRs and issues are always welcome. Make sure to provide as much context as possible when opening one.

## 🎭 Motivations

Inspired by the VS Code plugin [px to rem & rpx & vw (cssrem)](https://marketplace.visualstudio.com/items?itemName=cipchk.cssrem).  
There is two vim plugin to convert px to \(r\)em but those were missing some feature I wanted such as the virtual text and the nvim-cmp integration:

- [vim-px-to-em](https://github.com/chiedo/vim-px-to-em)
- [vim-px-to-rem](https://github.com/Oldenborg/vim-px-to-rem)

## 📝 TODO

- [ ] Use Treesitter
- [ ] Write tests
- [ ] Write documentation

## 📜 License

MIT © [jsongerber](https://github.com/jsongerber/nvim-px-to-rem/blob/master/LICENSE)

## Shameless plug

See my other plugins:

- [thanks.nvim](https://github.com/jsongerber/thanks.nvim): A plugin to show your appreciation to the maintainers of the plugin you use.
- [telescope-ssh-config](https://github.com/jsongerber/telescope-ssh-config): A plugin to list and connect to ssh hosts with telescope.nvim.
