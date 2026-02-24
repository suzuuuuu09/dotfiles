vim.api.nvim_create_user_command('Config', function ()
	vim.cmd('edit ' .. vim.fn.stdpath('config'))
end, { nargs = 0, desc = "Open Neovim Config" })

-- Snacks Pickerを使って設定ファイルを探す
vim.api.nvim_create_user_command('ConfigSearch', function ()
	require('snacks.picker').files({
		cwd = vim.fn.stdpath('config'),
		prompt_title = 'Search Neovim Config',
	})
end, { nargs = 0, desc = "Search Neovim Config" })

vim.api.nvim_create_user_command('BreadcrumbsToggle', function()
  if vim.wo.winbar == '' then
		print("Enabling Breadcrumbs!")
    vim.wo.winbar = nil
		-- 現在のバッファを保存
    local current_buf = vim.api.nvim_get_current_buf()
		-- 一時的なバッファを作成
    vim.cmd('enew')
    local temp_buf = vim.api. nvim_get_current_buf()
		-- 保存しておいたバッファに戻る
    vim.api.nvim_set_current_buf(current_buf)
		-- 一時的なバッファを削除
    vim.api.nvim_buf_delete(temp_buf, { force = true })
  else
		print("Disabling Breadcrumbs!")
    vim.wo.winbar = ''
  end
end, { nargs = 0, desc = "Toggle Breadcrumbs" })

-- vim.api.nvim_create_user_command("ToggleStatusBar", function()
-- 	if vim.o.laststatus == 3 then
-- 		vim.opt.laststatus = 0
-- 	else
-- 		vim.opt.laststatus = 3
-- 	end
-- end, { nargs = 0, force = true })
