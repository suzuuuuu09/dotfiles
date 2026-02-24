-- すべてのLSPにキーマップを設定
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local bufnr = args.buf
		local opts = { buffer = bufnr, silent = true }

		-- キーマップ
		vim.keymap.set("n", "K", vim.lsp.buf.hover,
			vim.tbl_extend("force", opts, { desc = "Hover document" }))

		vim.keymap.set("n", "gd", vim.lsp.buf.definition,
			vim.tbl_extend("force", opts, { desc = "Go to definition" }))

		vim.keymap.set("n", "gD", vim.lsp.buf.declaration,
			vim.tbl_extend("force", opts, { desc = "Go to declaration" }))

		vim.keymap.set("n", "gi", vim.lsp.buf.implementation,
			vim.tbl_extend("force", opts, { desc = "Go to implementation" }))

		vim.keymap.set("n", "gr", vim.lsp.buf.references,
			vim.tbl_extend("force", opts, { desc = "Show references" }))

		vim.keymap.set({ "n", "v" }, "<leader>la",
			require("tiny-code-action").code_action,
			vim.tbl_extend("force", opts, { desc = "Code action" }))

		vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename,
			vim.tbl_extend("force", opts, { desc = "Rename symbol" }))

		vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format,
			vim.tbl_extend("force", opts, { desc = "Format buffer" }))

		vim.keymap.set("n", "[d", vim.diagnostic.goto_prev,
			vim.tbl_extend("force", opts, { desc = "Previous diagnosti" }))

		vim.keymap.set("n", "]d", vim.diagnostic.goto_next,
			vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))

		vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float,
			vim.tbl_extend("force", opts, { desc = "Show diagnostic in float" }))
	end,
})

-- vim.lsp.enabledがtrueの場合、LSPは自動的に有効化されるため
-- このautocmdは不要（Neovim 0.11.x）

-- 行番号を強制的に表示
-- vim.api.nvim_create_autocmd({"VimEnter", "BufEnter"}, {
--   callback = function()
--     vim.opt.number = true
--     vim.opt.relativenumber = true
--   end,
-- })

-- ヤンクしたときにハイライト表示
vim.api.nvim_create_autocmd("TextYankPost", {
	pattern = "*",
	group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
	callback = function()
		vim.highlight.on_yank({ timeout = 200 })
	end,
})

--[[ -- インサートに入ったときに相対行番号を無効化
vim.api.nvim_create_autocmd("InsertEnter", {
	pattern = "*",
	callback = function()
		vim.opt.relativenumber = false
	end,
})

-- インサートを出たときに相対行番号を有効化
vim.api.nvim_create_autocmd("InsertLeave", {
	pattern = "*",
	callback = function()
		vim.opt.relativenumber = true
	end,
}) ]]

-- ターミナルにフォーカスしたときのキーバインド
vim.api.nvim_create_autocmd("TermEnter", {
	pattern = "*",
	callback = function()
		local opts = { buffer = 0 }
		local keymap = vim.keymap

		keymap.set("t", [[<C-\>]], [[<C-\><C-n>]], opts)
		keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], opts)
		keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], opts)
		keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], opts)
		keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], opts)
	end,
})

-- ファイルが外部で変更されたときに自動的に再読み込み
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
	pattern = "*",
	callback = function()
		vim.cmd.checktime()
	end,
})

-- コメント行の自動継続を無効にする
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({
			"c",
			"r",
			"o",
		})
  end,
})
