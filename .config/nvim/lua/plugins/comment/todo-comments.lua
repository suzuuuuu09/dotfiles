return {
	"folke/todo-comments.nvim",
	cmd = { "TodoTrouble", "TodoTelescope" },
	event = { "BufReadPost", "BufNewFile" },
	opts = {},
	dependencies = { "nvim-lua/plenary.nvim" },
}
-- TODO: Add custom keywords for better task management
-- FIXME: Integrate with issue tracker
-- NOTE: Review this configuration periodically
-- HACK: Temporary workaround for performance issues
-- BUG: Fix the highlighting issue in dark mode
-- TEST: Write unit tests for new functions
-- WARNING: Ensure proper error handling in critical sections
-- INFO: Document the configuration settings for users
-- PERF: Monitor performance metrics during usage
-- OPTIMIZE: Refactor code for better readability and maintainability
