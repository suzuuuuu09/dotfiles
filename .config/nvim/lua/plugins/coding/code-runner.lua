return {
	"CRAG666/code_runner.nvim",
	keys = {
		{ "<leader>rr", "<CMD>RunCode<CR>", desc = "Run current code" },
		{ "<leader>rf", "<CMD>RunFile<CR>", desc = "Run current file" },
	},
	config = function()
		require("code_runner").setup({
			filetype = {
				java = {
					"cd $dir &&",
					"javac $fileName &&",
					"java $fileNameWithoutExt &&",
					"rm $fileNameWithoutExt.class",
				},
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
						local build_dir = project_dir .. "/build"
						local commands = {
							"cd " .. project_dir .. " &&",
							"mkdir -p build &&",
							"cd build &&",
							"cmake . -DCMAKE_BUILD_TYPE=Debug > /dev/null &&",
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
