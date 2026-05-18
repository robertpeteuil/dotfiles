return {
  'rmagatti/auto-session',
  lazy = false,
  keys = {
    -- Will use Telescope if installed or a vim.ui.select picker otherwise
    { '<leader>ap', '<cmd>AutoSession search<CR>', desc = 'AutoSession [P]icker' },
    { '<leader>as', '<cmd>AutoSession save<CR>', desc = 'AutoSession [S]ave' },
    { '<leader>at', '<cmd>AutoSession toggle<CR>', desc = 'AutoSession [T]oggle' },
    -- { '<leader>g', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
  },

  ---enables autocomplete for opts
  ---@module "auto-session"
  ---@type AutoSession.Config
  opts = {
    enabled = true, -- Enables/disables auto creating, saving and restoring
    auto_save = true, -- Enables/disables auto saving session on exit
    auto_restore = true, -- Enables/disables auto restoring session on start
    auto_create = false, -- Enables/disables auto creating new session files. Can be a function that returns true if a new session file should be allowed
    auto_restore_last_session = false, -- On startup, loads the last saved session if session for cwd does not exist
    cwd_change_handling = false, -- Automatically save/restore sessions when changing directories
    suppressed_dirs = { '~/', '~/Versioned', '~/Downloads', '/' },
    -- log_level = 'debug',
    ---@type SessionLens
    session_lens = {
      picker = 'telescope',
      load_on_setup = true,
    },
  },
}
