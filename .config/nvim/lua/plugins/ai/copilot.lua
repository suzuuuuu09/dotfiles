return {
  "github/copilot.vim",
  lazy = false,
  config = function()
    vim.g.copilot_not_tab_map = true
    vim.g.copilot_assume_mapped = true
    vim.keymap.set("i", "<C-g>", "copilot#Accept('<CR>')", { expr = true, silent = true, replace_keycodes = false })
  end,
}
