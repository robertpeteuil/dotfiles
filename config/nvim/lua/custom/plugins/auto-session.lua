return {
  'rmagatti/auto-session',
  lazy = false,
  keys = {
    -- Will use Telescope if installed or a vim.ui.select picker otherwise
    { '<leader>a', desc = 'AutoSession' },
    { '<leader>ap', '<cmd>AutoSession search<CR>', desc = 'AutoSession [P]icker' },
    { '<leader>as', '<cmd>AutoSession save<CR>', desc = 'AutoSession [S]ave' },
    { '<leader>at', '<cmd>AutoSession toggle<CR>', desc = 'AutoSession [T]oggle' },
    -- { '<leader>g', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
  },

  ---enables autocomplete for opts
  ---@module "auto-session"
  ---@type AutoSession.Config
  opts = {
    suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
    -- log_level = 'debug',
    ---@type SessionLens
    session_lens = {
      picker = 'telescope',
      load_on_setup = true,
    },
  },
}
