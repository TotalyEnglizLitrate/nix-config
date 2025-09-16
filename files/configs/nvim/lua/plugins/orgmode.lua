return {
  {
    "nvim-orgmode/orgmode",
    ft = { "org" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("orgmode").setup({
        org_agenda_files = "~/org/agenda/*",
        org_default_notes_file = "~/org/refile.org",
      })
    end,
  },
  {
    "lukas-reineke/headlines.nvim",
    ft = { "org" },
    config = function()
      require("headlines").setup()
    end,
  },
  {
    "akinsho/org-bullets.nvim",
    ft = { "org" },
    config = function()
      require("org-bullets").setup()
    end,
  },
}
