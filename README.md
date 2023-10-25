# nvim-px-to-rem

> Easily work with rem in your css files

<div align="center">
https://github.com/jsongerber/nvim-px-to-rem/assets/18051702/ae464980-2486-4ad0-9a85-f198767b16e1
</div>

## ⚡️ Features

- Easily convert px to rem as you type (require [nvim-cmp](https://github.com/hrsh7th/nvim-cmp))
- Convert px to rem on a single value or a whole line
- Visualize your rem values in a virtual text

## 📋 Installation

<div align="center">
<table>
<thead>
<tr>
<th>Package manager</th>
<th>Snippet</th>
</tr>
</thead>
<tbody>
<tr>
<td>

[wbthomason/packer.nvim](https://github.com/wbthomason/packer.nvim)

</td>
<td>

```lua
use {"jsongerber/nvim-px-to-rem"}
```

</td>
</tr>
<tr>
<td>

[junegunn/vim-plug](https://github.com/junegunn/vim-plug)

</td>
<td>

```lua
Plug "jsongerber/nvim-px-to-rem"
```

</td>
</tr>
<tr>
<td>

[folke/lazy.nvim](https://github.com/folke/lazy.nvim)

</td>
<td>

```lua
require("lazy").setup({"jsongerber/nvim-px-to-rem"})
```

</td>
</tr>
</tbody>
</table>
</div>

## ☄ Getting started

> Describe how to use the plugin the simplest way

## ⚙ Configuration

> **Note**: The options are also available in Neovim by calling `:h nvim-px-to-rem.options`

```lua
-- Those are the default values and can be ommited
require("nvim-px-to-rem").setup({
    font_size = 16,
    decimal_count = 3,
    show_virtual_text = true,
    add_cmp_source = true,
    disable_keymaps = false,
    filetypes = {
        "css",
        "scss",
        "sass",
    },
})
```

| Option              | Description                                                                                                      | Default value             |
| ------------------- | ---------------------------------------------------------------------------------------------------------------- | ------------------------- |
| `font_size`         | The font size used to convert px to rem                                                                          | `16`                      |
| `decimal_count`     | The number of decimal to keep when converting px to rem                                                          | `3`                       |
| `show_virtual_text` | Show the rem value in a virtual text                                                                             | `true`                    |
| `add_cmp_source`    | Add a nvim-cmp source to convert px to rem as you type (require [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)) | `true`                    |
| `disable_keymaps`   | Disable the default keymaps                                                                                      | `false`                   |
| `filetypes`         | The filetypes to enable the plugin on                                                                            | `{"css", "scss", "sass"}` |

## 🧰 Commands

| Command          | Description                         |
| ---------------- | ----------------------------------- |
| `:PxToRemCursor` | Convert px to rem under cursor      |
| `:PxToRemLine`   | Convert px to rem on the whole line |

## 📚 Keymaps

| Keymap        | Description                         |
| ------------- | ----------------------------------- |
| `<leader>px`  | Convert px to rem under cursor      |
| `<leader>pxl` | Convert px to rem on the whole line |

You can disable the default keymaps by setting `disable_keymaps` to `true` and then create your own:

```lua
-- Those are the default keymaps, you can change them to whatever you want
vim.api.nvim_set_keymap("n", "<leader>px", ":PxToRemCursor<CR>", {noremap = true})
vim.api.nvim_set_keymap("n", "<leader>pxl", ":PxToRemLine<CR>", {noremap = true})
```

## ⌨ Contributing

PRs and issues are always welcome. Make sure to provide as much context as possible when opening one.

## 🎭 Motivations

Inspired by the VS Code plugin [px to rem & rpx & vw (cssrem)](https://marketplace.visualstudio.com/items?itemName=cipchk.cssrem)
There is two vim plugin to convert px to (r)em but those were missing some feature I wanted such as the virtual text and the nvim-cmp integration:

- [vim-px-to-em](https://github.com/chiedo/vim-px-to-em)
- [vim-px-to-rem](https://github.com/Oldenborg/vim-px-to-rem)

## 📝 TODO

- [ ] Use Treesitter

## 📜 License

MIT © [jsongerber](https://github.com/jsongerber/nvim-px-to-rem/blob/master/LICENSE)
