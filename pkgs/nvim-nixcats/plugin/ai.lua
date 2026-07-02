if not nixCats('general') then
  return
end

require('CopilotChat').setup()
require('copilot').setup({
  suggestion = {
    enabled = true,
    auto_trigger = true
  },
  filetypes = {
    yaml = false,
    markdown = false,
    toml = false,
    json = false,
    jsonc = false,
    sh = function ()
      if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), '^%.env.*') then
        return false
      end
      return true
    end,
  }
})

vim.keymap.set('i', '<S-Tab>', require('copilot.suggestion').accept_word, {noremap = true, silent = true})
vim.keymap.set('i', '<C-Tab>', require('copilot.suggestion').accept_line, {noremap = true, silent = true})
vim.keymap.set('i', '<C-Enter>', require('copilot.suggestion').accept, {noremap = true, silent = true})
vim.keymap.set('i', '<S-Escape>', require('copilot.suggestion').dismiss, {noremap = true, silent = true})
vim.keymap.set('n', '<leader>at', ':Copilot toggle<CR>', {noremap = true, silent = true})

vim.keymap.set('n', '<leader>ac', ':CopilotChat<CR>', {noremap = true, silent = true})
vim.keymap.set('n', '<leader>ad', ':CopilotChatDocs<CR>', {noremap = true, silent = true})
vim.keymap.set('n', '<leader>af', ':CopilotChatFixes<CR>', {noremap = true, silent = true})
vim.keymap.set('n', '<leader>ae', ':CopilotChatExplain<CR>', {noremap = true, silent = true})
vim.keymap.set('n', '<leader>ga', ':CopilotChatCommit<CR>', {noremap = true, silent = true})
vim.keymap.set('n', '<leader>ar', ':CopilotChatReview<CR>', {noremap = true, silent = true})

vim.cmd([[ hi CopilotSuggestion guifg=#555555 ]])
