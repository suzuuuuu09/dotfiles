local opt = vim.opt

-- 行をまたいで移動できるようにする
opt.whichwrap:append("b,s,h,l,<,>,[,],~")

opt.clipboard = "unnamedplus"

-- 基本設定
opt.number = true                          -- 行番号を表示
opt.relativenumber = true                  -- 相対番号表示
opt.cursorcolumn = true                    -- カーソルの列を強調
opt.cursorline = true                      -- カーソルの行を強調
opt.guifont = "UDEV Gothic 35NFLG Regular" -- フォント

opt.wrap = false                           -- 折り返し無効
opt.scrolloff = 5                          -- スクロールオフセット

-- インデント
opt.shiftwidth = 2
opt.tabstop = 2
opt.autoindent = true
opt.smartindent = true

opt.winblend = 0
opt.pumblend = 0

-- コマンドライン
opt.wildmenu = true    -- コマンドラインで補完
opt.signcolumn = "yes" -- 常にサインカラムを表示

opt.fillchars = {
	eob = " ", -- End of Buffer の ~ を非表示
	fold = " ", -- 折りたたまれた行の表示
	foldopen = "", -- 折りたたみを開く記号
	foldsep = " ", -- 折りたたみの区切り記号
	foldclose = "", -- 折りたたみを閉じる記号
}

-- 不可視文字の表示
opt.list = true
opt.listchars = { tab = "▸ ", trail = "·", extends = "»", precedes = "«", nbsp = "␣" }

opt.foldcolumn = "1" -- 折りたたみ用の列を表示
opt.foldlevel = 99   -- 初期状態ですべての折りたたみを開く
opt.foldlevelstart = 99
opt.foldenable = true

vim.o.shell = "fish"
vim.o.shellcmdflag = "-c"
vim.o.shellredir = "> %s 2>&1"
