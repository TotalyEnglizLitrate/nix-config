return {
  {
    "github/copilot.vim",
    event = "InsertEnter",
    config = function()
      -- Enable Copilot for specific filetypes
      vim.g.copilot_filetypes = {
        ["*"] = false,
        ["javascript"] = true,
        ["typescript"] = true,
        ["lua"] = true,
        ["rust"] = true,
        ["c"] = true,
        ["c#"] = true,
        ["c++"] = true,
        ["go"] = true,
        ["python"] = true,
        ["nix"] = true,
        ["yaml"] = true,
        ["json"] = true,
        ["html"] = true,
        ["css"] = true,
        ["scss"] = true,
        ["vue"] = true,
        ["svelte"] = true,
        ["php"] = true,
        ["sh"] = true,
        ["bash"] = true,
        ["fish"] = true,
        ["dockerfile"] = true,
        ["markdown"] = true,
      }

      -- Copilot keymaps
      vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false
      })
      vim.g.copilot_no_tab_map = true

      -- Additional Copilot settings
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_tab_fallback = ""
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "github/copilot.vim" },
      { "nvim-lua/plenary.nvim" },
      { "folke/which-key.nvim" },
    },
    event = "VeryLazy",
    config = function()
      require("CopilotChat").setup({
        debug = false,
        window = {
          layout = 'vertical',
          width = 0.4,
          height = 0.6,
        },
        mappings = {
          complete = {
            detail = 'Use @<Tab> or /<Tab> for options.',
            insert = '<Tab>',
          },
          close = {
            normal = 'q',
            insert = '<C-c>'
          },
          reset = {
            normal = '<C-r>',
            insert = '<C-r>'
          },
          submit_prompt = {
            normal = '<CR>',
            insert = '<C-m>'
          },
          accept_diff = {
            normal = '<C-y>',
            insert = '<C-y>'
          },
          yank_diff = {
            normal = 'gy',
          },
          show_diff = {
            normal = 'gd'
          },
          show_system_prompt = {
            normal = 'gp'
          },
          show_user_selection = {
            normal = 'gs'
          },
        },
      })

      -- CopilotChat keymaps
      local chat = require("CopilotChat")
      local wk = require("which-key")
      
      -- Register Copilot group with which-key
      wk.add({
        { "<leader>c", group = "Copilot" },
        { "<leader>cc", function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then
            chat.ask(input, { selection = require("CopilotChat.select").buffer })
          end
        end, desc = "Quick chat", mode = { "n", "v" } },
        { "<leader>ct", "<cmd>CopilotChatToggle<cr>", desc = "Toggle" },
        { "<leader>ce", "<cmd>CopilotChatExplain<cr>", desc = "Explain code", mode = { "n", "v" } },
        { "<leader>cr", "<cmd>CopilotChatReview<cr>", desc = "Review code", mode = { "n", "v" } },
        { "<leader>cf", "<cmd>CopilotChatFix<cr>", desc = "Fix code", mode = { "n", "v" } },
        { "<leader>co", "<cmd>CopilotChatOptimize<cr>", desc = "Optimize code", mode = { "n", "v" } },
        { "<leader>cd", "<cmd>CopilotChatDocs<cr>", desc = "Generate docs", mode = { "n", "v" } },
        { "<leader>cT", "<cmd>CopilotChatTests<cr>", desc = "Generate tests", mode = { "n", "v" } },
        { "<leader>cm", "<cmd>CopilotChatCommit<cr>", desc = "Generate commit message" },
        { "<leader>cR", "<cmd>CopilotChatReset<cr>", desc = "Reset chat" },
      })
    end,
  },
}