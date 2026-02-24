local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- US配列用
keymap.set({ "n", "v" }, ";", ":")
keymap.set({ "n", "v" }, ":", ";")

-- Increment / Decrement
keymap.set("n", "+", "<C-a>", opts)
keymap.set("n", "-", "<C-x>", opts)

-- Window navigation
keymap.set({ "n", "i" }, "<C-h>", "<C-w>h", opts)
keymap.set({ "n", "i" }, "<C-j>", "<C-w>j", opts)
keymap.set({ "n", "i" }, "<C-k>", "<C-w>k", opts)
keymap.set({ "n", "i" }, "<C-l>", "<C-w>l", opts)

-- Better up/down
keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Clear search highlights
keymap.set("n", "<Esc>", "<Cmd>nohlsearch<CR><Esc>", opts)

-- Exit insert mode quickly
-- better-escape.nvimを使うのでコメントアウト
-- keymap.set("i", "jj","<ESC>", opts)

keymap.set("n", "<leader>n", "<CMD>tabedit<CR>", { desc = "New tab" })
keymap.set("n", "<leader>w", "<CMD>write<CR>", { desc = "Save file" })
keymap.set("n", "<leader>W", "<CMD>wa<CR>", { desc = "Save all files" })
keymap.set("n", "<leader>q", "<CMD>quit<CR>", { desc = "Quit" })
keymap.set("n", "<leader>Q", "<CMD>qa!<CR>", { desc = "Quit all" })
keymap.set("n", "<leader>c", "<CMD>close<CR>", { desc = "Close buffer" })

-- ╭─────────────────────────────────────────────────────────╮
-- │                         Buffer                          │
-- ╰─────────────────────────────────────────────────────────╯
keymap.set("n", "<leader>bd", "<CMD>bdelete<CR>", { desc = "Delete buffer" })

-- Select all
keymap.set("n", "vv", "ggVG", opts)

-- Redo
keymap.set("n", "U", "<C-r>", opts)

-- Delete / Change without yanking
keymap.set({ "n", "v" }, "d", '"_d', opts)
keymap.set({ "n", "v" }, "D", '"_D', opts)
keymap.set({ "n", "v" }, "c", '"_c', opts)
keymap.set({ "n", "v" }, "C", '"_C', opts)

-- Delete / Change / Yank / Visual select inner word
keymap.set("n", "c<space>", '"_ciw', opts)
keymap.set("n", "d<space>", '"_diw', opts)
keymap.set("n", "y<space>", "yiw", opts)
keymap.set("n", "v<space>", "viw", opts)

-- Paste without overwriting the default register
keymap.set("v", "p", [["_dp]])
keymap.set("v", "P", [["_dP]])

-- x to using cut to the system clipboard
keymap.set({ "n", "v" }, "x", '"*d', opts)
keymap.set({ "n", "v" }, "X", '"*D', opts)
keymap.set({ "n", "v" }, "xx", '"*dd', opts)

-- Stay in visual mode when indenting
keymap.set("v", "<", "<gv")
keymap.set("v", ">", ">gv")

-- Split window
keymap.set({ "n", "v" }, "|", "<CMD>vsplit<CR>")
keymap.set({ "n", "v" }, "\\", "<CMD>split<CR>")

-- Move to beginning and end of line
keymap.set({ "n", "v" }, "gh", "^", opts)
keymap.set({ "n", "v" }, "gl", "$", opts)

-- Center cursor
-- keymap.set("n", "n", "nzzzv", opts)
-- keymap.set("n", "N", "Nzzzv", opts)
-- keymap.set("n", "J", "mzJ`z", opts)
-- keymap.set("n", "<C-d>", "<C-d>zz", opts)
-- keymap.set("n", "<C-u>", "<C-u>zz", opts)
