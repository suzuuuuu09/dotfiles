vim.filetype.add({
	pattern = {
		[".*/chezmoi/.*"] = function(path, bufnr)
			local filename = vim.fn.fnamemodify(path, ":t")

			-- .tmplの自動検知
			if filename:match("%.tmpl$") then
				local base_name = filename:gsub("%.tmpl$", "")
				base_name = base_name:gsub("^dot_", "."):gsub("^executable_dot_", ".")
				local detected_ft = vim.filetype.match({ filename = base_name })
				if detected_ft then
					return detected_ft .. ".gotmpl"
				end
				return "gotmpl"
			end

			if filename:find("^dot_") or filename:find("^executable_dot_") then
				local new_name = filename:gsub("^dot_", "."):gsub("^executable_dot_", ".")
				return vim.filetype.match({ filename = new_name })
			end
		end,
	},
})
