if not nixCats('general') then
  return
end
require("snacks").setup({
  picker = {},
  bigfile = {},
  dashboard = {
    sections = {
      { section = "header" },
      { section = "keys", gap = 1, padding = 1,  },
      { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
      { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
      {
        pane = 2,
        icon = " ",
        title = "Git Status",
        section = "terminal",
        enabled = function()
          return Snacks.git.get_root() ~= nil
        end,
        cmd = "git status --short --branch --renames",
        height = 5,
        padding = 1,
        ttl = 5 * 60,
        indent = 3,
      },
    },
  },
  explorer = { replace_netrw = true, },
  lazygit = {},
  terminal = {},
  rename = {},
  notifier = {},
  indent = {},
  gitbrowse = {},
  scope = {},
  scroll = {},
  quickfile = {}
})
vim.keymap.set({"n", "v", "i", "t"}, "<c-\\>", function()
  if Snacks.terminal.list() then
    Snacks.terminal.toggle()
  else
    Snacks.terminal.open()
  end
end, { desc = 'Snacks Toggle Terminal' })
vim.keymap.set({"n", "v", "i", "t"}, "<c-\\>", function()
  Snacks.terminal.open()
end, { desc = 'Snacks Terminal' })

vim.keymap.set("n", "<leader>gg", Snacks.lazygit.open, { desc = 'Snacks LazyGit' })
vim.keymap.set("n", "<leader>e", Snacks.explorer.open , { desc = 'Snacks file explorer' })
-- find
vim.keymap.set('n', "<leader>sF", Snacks.picker.files, { desc = "Find Files" })
vim.keymap.set('n', "<leader>sf", Snacks.picker.smart, { desc = "Smart Find Files" })
vim.keymap.set('n', "<leader>sG", Snacks.picker.git_files, { desc = "Find Git Files" })
-- Grep
vim.keymap.set('n', "<leader>sb", Snacks.picker.lines, { desc = "Buffer Lines" })
vim.keymap.set('n', "<leader>sB", Snacks.picker.grep_buffers, { desc = "Grep Open Buffers" })
vim.keymap.set('n', "<leader>sg", Snacks.picker.grep, { desc = "Grep" })
vim.keymap.set({ "n", "x" }, "<leader>sw", Snacks.picker.grep_word, { desc = "Visual selection or ord" })
-- search
vim.keymap.set('n', "<leader>sd", Snacks.picker.diagnostics, { desc = "Diagnostics" })
vim.keymap.set('n', "<leader>sD", Snacks.picker.diagnostics_buffer, { desc = "Buffer Diagnostics" })
vim.keymap.set('n', "<leader>sh", Snacks.picker.help, { desc = "Help Pages" })
vim.keymap.set('n', "<leader>sj", Snacks.picker.jumps, { desc = "Jumps" })
vim.keymap.set('n', "<leader>sk", Snacks.picker.keymaps, { desc = "Keymaps" })
vim.keymap.set('n', "<leader>sl", Snacks.picker.loclist, { desc = "Location List" })
vim.keymap.set('n', "<leader>sm", Snacks.picker.marks, { desc = "Marks" })
vim.keymap.set('n', "<leader>sM", Snacks.picker.man, { desc = "Man Pages" })
vim.keymap.set('n', "<leader>sq", Snacks.picker.qflist, { desc = "Quickfix List" })
vim.keymap.set('n', "<leader>sR", Snacks.picker.resume, { desc = "Resume" })
vim.keymap.set('n', "<leader>su", Snacks.picker.undo, { desc = "Undo History" })
