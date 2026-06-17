local keyset = vim.keymap.set
local keydel = vim.keymap.del
local opts = { noremap = true, silent = true }

-- US配列用
keyset({ "n", "v" }, ";", ":")
keyset({ "n", "v" }, ":", ";")

-- Increment / Decrement
keyset("n", "+", "<C-a>", opts)
keyset("n", "-", "<C-x>", opts)

-- Window navigation
keyset({ "n", "i" }, "<C-h>", "<C-w>h", opts)
keyset({ "n", "i" }, "<C-j>", "<C-w>j", opts)
keyset({ "n", "i" }, "<C-k>", "<C-w>k", opts)
keyset({ "n", "i" }, "<C-l>", "<C-w>l", opts)

-- Better up/down
keyset("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keyset("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Clear search highlights
keyset("n", "<Esc>", "<Cmd>nohlsearch<CR><Esc>", opts)

-- Exit insert mode quickly
-- better-escape.nvimを使うのでコメントアウト
-- keyset("i", "jj","<ESC>", opts)

keyset("n", "<leader>n", "<CMD>tabedit<CR>", { desc = "New tab" })
keyset("n", "<leader>w", "<CMD>write<CR>", { desc = "Save file" })
keyset("n", "<leader>W", "<CMD>wa<CR>", { desc = "Save all files" })
keyset("n", "<leader>q", "<CMD>quit<CR>", { desc = "Quit" })
keyset("n", "<leader>Q", "<CMD>qa!<CR>", { desc = "Quit all" })
keyset("n", "<leader>c", "<CMD>close<CR>", { desc = "Close buffer" })

-- ╭─────────────────────────────────────────────────────────╮
-- │                         Buffer                          │
-- ╰─────────────────────────────────────────────────────────╯
keyset("n", "<leader>bd", "<CMD>bdelete<CR>", { desc = "Delete buffer" })

-- Select all
keyset("n", "vv", "ggVG", opts)

-- Redo
keyset("n", "U", "<C-r>", opts)

-- Delete / Change without yanking
keyset({ "n", "v" }, "d", '"_d', opts)
keyset({ "n", "v" }, "D", '"_D', opts)
keyset({ "n", "v" }, "c", '"_c', opts)
keyset({ "n", "v" }, "C", '"_C', opts)

-- Delete / Change / Yank / Visual select inner word
keyset("n", "c<space>", '"_ciw', opts)
keyset("n", "d<space>", '"_diw', opts)
keyset("n", "y<space>", "yiw", opts)
keyset("n", "v<space>", "viw", opts)

-- Paste without overwriting the default register
keyset("v", "p", [["_dp]])
keyset("v", "P", [["_dP]])

-- x to using cut to the system clipboard
keyset({ "n", "v" }, "x", '"*d', opts)
keyset({ "n", "v" }, "X", '"*D', opts)
keyset({ "n", "v" }, "xx", '"*dd', opts)

-- Stay in visual mode when indenting
keyset("v", "<", "<gv")
keyset("v", ">", ">gv")

-- Split window
keyset({ "n", "v" }, "|", "<CMD>vsplit<CR>")
keyset({ "n", "v" }, "\\", "<CMD>split<CR>")

-- Move to beginning and end of line
keyset({ "n", "v" }, "gh", "^", opts)
keyset({ "n", "v" }, "gl", "$", opts)
keyset({ "n", "v" }, "gm", "%", opts)

-- Center cursor
-- keyset("n", "n", "nzzzv", opts)
-- keyset("n", "N", "Nzzzv", opts)
-- keyset("n", "J", "mzJ`z", opts)
-- keyset("n", "<C-d>", "<C-d>zz", opts)
-- keyset("n", "<C-u>", "<C-u>zz", opts)
keyset("n", "<C-e>", vim.diagnostic.open_float, {
	desc = "Show line diagnostic",
})

-- https://eiji.page/blog/nvim-hlslens-intro/
keyset("n", "#", function()
	local current_word = vim.fn.expand("<cword>")
	vim.api.nvim_feedkeys(":%s/" .. current_word .. "//g", "n", false)
	-- :%s/word/CURSOR/g
	local ll = vim.api.nvim_replace_termcodes("<Left><Left>", true, true, true)
	vim.api.nvim_feedkeys(ll, "n", false)
	vim.opt.hlsearch = true
	hlslens.start()
end, opts)

-- 0.12.0から追加されたインクリメンタルセレクションのキーマップ
if vim.fn.has("nvim-0.12.0") == 1 then
	keyset("x", "n", "an", { remap = true, desc = "Incremental selection: expand" })
	keyset("x", "N", "in", { remap = true, desc = "Incremental selection: shrink" })
end
