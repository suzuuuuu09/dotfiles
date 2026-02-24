return {
	"barrett-ruth/live-server.nvim",
	build = "bun i -g live-server",
	cmd = { "LiveServerStart", "LiveServerStop" },
	opts = {
		args = { "--port=5500" }
	},
}
