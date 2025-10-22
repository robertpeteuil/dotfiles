-- [[ Configure and install plugins ]]

require('lazy').setup({

  {
    'NMAC427/guess-indent.nvim', -- Detect tabstop and shiftwidth automatically
    opts = {},
  },

  require 'kickstart.plugins.blink-cmp',
  require 'kickstart.plugins.conform',
  require 'kickstart.plugins.gitsigns',
  require 'kickstart.plugins.lspconfig',
  require 'kickstart.plugins.todo-comments',
  require 'kickstart.plugins.tokyonight',
  require 'kickstart.plugins.treesitter',

  -- Moved to custom/plugins dir for Customization
  -- require 'kickstart.plugins.indent_line',
  -- require 'kickstart.plugins.neo-tree',
  -- require 'kickstart.plugins.which-key',
  -- require 'kickstart.plugins.telescope',
  -- require 'kickstart.plugins.mini',

  -- Stopped using - moved to reference dir
  -- require 'kickstart.plugins.autopairs',
  -- require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.lint',

  { import = 'custom.plugins' },
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- vim: ts=2 sts=2 sw=2 et
