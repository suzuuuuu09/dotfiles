return {
	"CRAG666/code_runner.nvim",
	keys = {
		{ "<leader>rr", "<CMD>RunCode<CR>", desc = "Run current code" },
		{ "<leader>rf", "<CMD>RunFile<CR>", desc = "Run current file" },
	},
	config = function()
		require("code_runner").setup({
			filetype = {
				java = function()
					local file = vim.fn.expand("%:p")
					local filename = vim.fn.expand("%:t")
					local class_name = vim.fn.expand("%:t:r")

					local package_name

					for line in io.lines(file) do
						package_name = line:match("^%s*package%s+([%w%._]+)%s*;")

						if package_name then
							break
						end
					end

					-- package宣言がない通常のJavaファイル
					if not package_name then
						local dir = vim.fn.expand("%:p:h")

						return table.concat({
							"cd " .. vim.fn.shellescape(dir),
							"javac -encoding UTF-8 " .. vim.fn.shellescape(filename),
							"java " .. vim.fn.shellescape(class_name),
						}, " && ")
					end

					-- package com.example.app; などの宣言がある場合
					-- ↓
					-- com/example/app
					local package_path = package_name:gsub("%.", "/")
					local relative_file = package_path .. "/" .. filename

					-- ファイルパスの末尾からパッケージ部分を取り除き、
					-- ソースルートを取得する
					local suffix = "/" .. relative_file
					local source_root = file:sub(1, #file - #suffix)

					local full_class_name = package_name .. "." .. class_name

					return table.concat({
						"cd " .. vim.fn.shellescape(source_root),
						"javac -encoding UTF-8 " .. vim.fn.shellescape(relative_file),
						"java " .. vim.fn.shellescape(full_class_name),
					}, " && ")
				end,
				python = "python3 -u",
				typescript = "bun run",
				rust = {
					"cd $dir &&",
					"rustc $fileName &&",
					"./$fileNameWithoutExt &&",
					"rm ./$fileNameWithoutExt",
				},
				c = function(...)
					c_base = {
						"cd $dir &&",
						"gcc $fileName -o",
						"/tmp/$fileNameWithoutExt",
					}
					local c_exec = {
						"&& /tmp/$fileNameWithoutExt &&",
						"rm /tmp/$fileNameWithoutExt",
					}
					vim.ui.input({ prompt = "Add more args:" }, function(input)
						c_base[4] = input
						vim.print(vim.tbl_extend("force", c_base, c_exec))
						require("code_runner.commands").run_from_fn(vim.list_extend(c_base, c_exec))
					end)
				end,
				cpp = function(...)
					-- CMakeLists.txtがプロジェクトルートにあるか確認
					local cmake_file = vim.fn.findfile("CMakeLists.txt", vim.fn.expand("%:p:h") .. ";")
					if cmake_file ~= "" then
						local project_dir = vim.fn.fnamemodify(cmake_file, ":p:h")
						local commands = {
							"cd " .. project_dir .. " &&",
							"mkdir -p build &&",
							"cd build &&",
							"cmake .. -DCMAKE_BUILD_TYPE=Debug > /dev/null &&",
							"cmake --build ./ &&",
							"cd .. &&",
							"./build/" .. vim.fn.expand("%:t:r"),
						}
						require("code_runner.commands").run_from_fn(commands)
					else
						-- CMakeLists.txtがない場合はclang++で直接コンパイル
						require("code_runner.commands").run_from_fn({
							"cd $dir &&",
							"clang++ $fileName -o /tmp/$fileNameWithoutExt &&",
							"/tmp/$fileNameWithoutExt &&",
							"rm /tmp/$fileNameWithoutExt",
						})
					end
				end,
			},
		})
	end,
}
