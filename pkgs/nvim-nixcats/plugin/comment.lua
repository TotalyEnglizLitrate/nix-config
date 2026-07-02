if not nixCats('general') then
  return
end
require('Comment').setup({
  toggler = { line = '<C-/>' },
  opleader = { line = '<C-/>' }
})

