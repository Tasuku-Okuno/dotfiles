vim.opt.termguicolors = false
vim.opt.syntax = "on"
vim.opt.expandtab = true      -- タブをスペースに変換
vim.opt.tabstop = 2           -- タブ文字はスペース 4 個分
vim.opt.shiftwidth = 2        -- 自動インデント時の幅
vim.opt.softtabstop = 2       -- Tab キーを押したときのスペース数
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

vim.cmd([[colorscheme darkblue]])

vim.opt.clipboard = "unnamedplus"
vim.keymap.set({ "n", "x" }, "c", '"_c', { noremap = true, silent = true })
vim.keymap.set("n", "C", '"_C', { noremap = true, silent = true })

require("config.lazy")
