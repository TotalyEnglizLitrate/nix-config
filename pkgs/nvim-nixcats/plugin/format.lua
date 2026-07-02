if not nixCats('general') then
  return
end
local conform = require("conform")
conform.setup({
  formatters_by_ft = {
    -- NOTE: download some formatters in lspsAndRuntimeDeps
    -- and configure them here
    lua = { "stylua" },
    python = { "black" },
    rust = { "rustfmt" },
    -- templ = { "templ" },
    -- Conform will run multiple formatters sequentially
    -- Use a sub-list to run only the first available formatter
    -- javascript = { { "prettierd", "prettier" } },
  },
})
vim.keymap.set({ "n", "v" }, "<leader>cf", function()
  conform.format({
    lsp_fallback = true,
    async = false,
    timeout_ms = 1000,
  })
end, { desc = "Format File" })
