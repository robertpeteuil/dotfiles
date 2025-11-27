-- [[ Configure and install plugins ]]

require('lazy').setup({

  {
    'NMAC427/guess-indent.nvim', -- Detect tabstop and shiftwidth automatically
    opts = {},
  },

  require 'plugins.specified.blink-cmp',
  require 'plugins.specified.conform',
  require 'plugins.specified.gitsigns',
  require 'plugins.specified.lspconfig',
  require 'plugins.specified.todo-comments',

  { import = 'plugins.auto' },
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
