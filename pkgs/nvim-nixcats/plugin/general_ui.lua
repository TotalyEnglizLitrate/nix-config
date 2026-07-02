if not nixCats('general') then
  return
end

local transparent = true
local style_str = 'transparent'

require('tokyonight').setup({
  style = 'night',
  transparent = transparent,
  terminal_colors = true,
  styles = {
    comments = {
      italic = true,
      bold = true
    },
    functions = { bold = true },
    keywords = { bold = true },
    sidebars = style_str,
    floats = style_str,
  },
  lualine_bold = true
})

vim.cmd('colorscheme tokyonight')

vim.g.startuptime_event_width = 0
vim.g.startuptime_tries = 10
vim.g.startuptime_exe_path = nixCats.packageBinPath

require('mini.pairs').setup()
require('mini.icons').setup()
require('mini.ai').setup()

local transparent = { a = {fg = 'none'}, c = { bg = 'none'}}

require('lualine').setup({
  options = {
    icons_enabled = true,
    theme = {
      normal = transparent,
      insert = transparent,
      visual = transparent,
      replace = transparent,
      command = transparent,
      inactive = transparent,
    },
    component_separators = '',
    section_separators = '',
    always_divide_middle = true,
    globalstatus = true,
    disabled_filetypes = {
      'Outline',
      'snacks_dashboard',
      'snacks_terminal'
    }
  },
  sections = {
    lualine_c = {
      {
        'filename', path = 1, status = true,
      },
    },
  },
  inactive_sections = {
    lualine_b = {
      {
        'filename', path = 3, status = true,
      },
    },
    lualine_x = {'filetype'},
  },
})


require('noice').setup({
  presets = {{ bottom_search = true }},
  views = {
    cmdline_popup = {
      position = {
        row = -2,
        col = '50%',
      },
      win_options = {
        winblend = 0,
      }
    },
    cmdline_popupmenu = {
      position = {
        row = -5,
        col = '50%'
      },
      win_options = {
        winblend = 0,
      }
    },
    mini = {
      win_options = {
        winblend = 0,
      }
    }
  },
  lsp = {
    override = {
      ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
      ['vim.lsp.util.stylize_markdown'] = true,
      ['cmp.entry.get_documentation'] = true,
    },
    hover = { enabled = false },
    signature = { enabled = false },
    message = { enabled = false },
    progress = { enabled = false },
  }
})

vim.cmd([[hi StatusLine guibg=NONE ctermbg=NONE]])

require('which-key').setup({})
require('which-key').add{
  { '<leader>a', group = 'ai'},
  { '<leader>a_', hidden = true },
  { '<leader>b', group = 'buffer commands' },
  { '<leader>c', group = 'code' },
  { '<leader>c_', hidden = true },
  { '<leader>d', group = 'document' },
  { '<leader>d_', hidden = true },
  { '<leader>g', group = 'git' },
  { '<leader>g_', hidden = true },
  { '<leader>r', group = 'rename' },
  { '<leader>r_', hidden = true },
  { '<leader>s', group = 'search' },
  { '<leader>s_', hidden = true },
  { '<leader>w', group = 'workspace' },
  { '<leader>w_', hidden = true },
}
