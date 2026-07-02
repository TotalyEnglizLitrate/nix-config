if not nixCats('general') then
  return
end

local cord = require('cord')
cord.setup({
  display = {
    flavor = 'accent'
  },
})
