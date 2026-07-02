if not nixCats('general') then
  return
end

local highlights = {
  background = { bg = "none" },
  fill = { bg = "none" },
  buffer_selected = { bg = "none", fg = "#fab387", bold = true, italic = false },
  buffer_visible = { bg = "none", fg = "#a6adc8" },
  close_button = { bg = "none" },
  close_button_selected = { bg = "none" },
  close_button_visible = { bg = "none" },
  duplicate = { bg = "none" },
  duplicate_selected = { bg = "none" },
  duplicate_visible = { bg = "none" },
  error = { bg = "none" },
  error_selected = { bg = "none" },
  error_visible = { bg = "none" },
  hint = { bg = "none" },
  hint_selected = { bg = "none" },
  hint_visible = { bg = "none" },
  indicator_selected = { bg = "none" },
  indicator_visible = { bg = "none" },
  info = { bg = "none" },
  info_selected = { bg = "none" },
  info_visible = { bg = "none" },
  modified = { bg = "none" },
  modified_selected = { bg = "none" },
  modified_visible = { bg = "none" },
  numbers = { bg = "none" },
  numbers_selected = { bg = "none" },
  numbers_visible = { bg = "none" },
  offset_separator = { bg = "none" },
  pick = { bg = "none" },
  pick_selected = { bg = "none" },
  pick_visible = { bg = "none" },
  separator = { bg = "none" },
  separator_selected = { bg = "none" },
  separator_visible = { bg = "none" },
  tab = { bg = "none" },
  tab_close = { bg = "none" },
  tab_selected = { bg = "none" },
  tab_separator = { bg = "none" },
  tab_separator_selected = { bg = "none" },
  trunc_marker = { bg = "none" },
  warning = { bg = "none" },
  warning_selected = { bg = "none" },
  warning_visible = { bg = "none" },
}

local sep_style = ""

highlights = {
  buffer_selected = { bold = true, italic = false },
}
sep_style = "slant"

require("bufferline").setup({
  highlights = highlights,
  options = {
    diagnostics = "nvim_lsp",
    separator_style = sep_style,
    numbers = function(opts)
      return string.format('%s.', opts.ordinal)
    end,
    indicator = {
      icon = "▎",
      style = "icon",
      close_button_visible = false,
    },
    offsets = {
      {
	filetype = "snacks-picker-list",
	text = "File Explorer",
	text_align = "left",
	separator = true
      }
    },
    show_buffer_icons = true,
    color_icons = true,
    show_buffer_close_icons = false,
  },
})

vim.keymap.set("n", "<leader>bp", "<cmd>:BufferLinePick<cr>", { desc = "Buffer Line Pick" })
vim.keymap.set("n", "<leader>qc", "<cmd>:bp | bd #<cr>", { desc = "Buffer close" })
vim.keymap.set("n", "<leader>bP", "<cmd>BufferLineTogglePin<cr>", { desc = "Buffer Pin" })
vim.keymap.set("n", "<leader>bd", "<cmd>BufferLineSortByDirectory<cr>", { desc = "Buffer Sort by dir" })
vim.keymap.set("n", "<leader>be", "<cmd>BufferLineSortByExtension<cr>", { desc = "Buffer Sort by ext" })
vim.keymap.set("n", "<leader>bt", "<cmd>BufferLineSortByTabs<cr>", { desc = "Buffer Sort by Tabs" })
vim.keymap.set("n", "<leader>bL", "<cmd>BufferLineCloseRight<cr>", { desc = "Buffer close all to right" })
vim.keymap.set("n", "<leader>bH", "<cmd>BufferLineCloseLeft<cr>", { desc = "Buffer close all to left" })
vim.keymap.set(
	"n",
	"<leader>bc",
	"<cmd>BufferLineCloseOther<cr>",
	{ desc = "Buffer close all except the current buffer" }
)
vim.keymap.set("n", "<a-s-h>", "<cmd>BufferLineMovePrev<cr>", { desc = "Move buffer to left" })
vim.keymap.set("n", "<a-s-l>", "<cmd>BufferLineMoveNext<cr>", { desc = "Move buffer to right" })
vim.keymap.set("n", "<s-h>", ":BufferLineCyclePrev<cr>", { desc = "Buffer Previous" })
vim.keymap.set("n", "<s-l>", ":BufferLineCycleNext<cr>", { desc = "Buffer Next" })
vim.keymap.set("n", "<leader><tab>q", "<cmd>tabclose<cr>", { desc = "Close Tab" })
vim.keymap.set("n", "<leader><tab>n", "<cmd>tabnew<cr>", { desc = "New Tab" })
vim.keymap.set("n", "<leader><tab>j", "<cmd>tabn<cr>", { desc = "Next Tab" })
vim.keymap.set("n", "<leader><tab>k", "<cmd>tabp<cr>", { desc = "Previous Tab" })
vim.keymap.set("n", "<leader>qw", "<cmd>q<cr>", { desc = "Close Window" })
vim.keymap.set("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit" })
