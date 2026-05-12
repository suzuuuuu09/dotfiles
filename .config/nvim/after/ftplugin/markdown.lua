local opt = vim.opt

-- 折り返し
opt.wrap = true

-- NOTE: Marpのウォッチモードで保存時に更新されなかったため、更新されるようにするための設定
-- 保存時にファイルをバックアップするようにする
opt.backupcopy = "yes"
