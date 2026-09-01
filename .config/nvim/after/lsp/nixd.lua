local config_path = vim.uv.fs_realpath(vim.fn.stdpath("config"))
local flake_root = config_path and vim.fs.dirname(vim.fs.dirname(config_path))
local flake_ref = string.format("%q", "git+file://" .. (flake_root or vim.fn.expand("~/dotfiles")))

return {
	settings = {
		nixd = {
			nixpkgs = {
				expr = ("import (builtins.getFlake %s).inputs.nixpkgs { }"):format(flake_ref),
			},
			formatting = {
				command = { "alejandra" },
			},
		},
	},
}
