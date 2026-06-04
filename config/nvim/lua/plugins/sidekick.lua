return {
  'folke/sidekick.nvim',
  lazy = false,
  -- pin commit to ensure NES works
  --   source: https://github.com/folke/sidekick.nvim/issues/300
  commit = '6b69c42',
  -- dev = true,
  opts = {
    cli = {
      win = {
        -- size if mux.create = 'terminal'
        split = { width = 60 },
      },
      mux = {
        backend = 'tmux',
        enabled = true,
        create = 'split',
        -- size if mux.create = 'split'
        split = { size = 0.4 },
      },
      tools = {
        pi = { -- start pi using a login shell
          cmd = { '/bin/zsh', '-lic', 'exec pi' },
        },
      },
    },
  },
  keys = {
    -- sidekick cli commands
    {
      '<leader>aa',
      function()
        require('sidekick.cli').toggle { name = 'pi', focus = true }
      end,
      desc = '[a]ttach pi',
    },
    {
      '<leader>ac',
      function()
        require('sidekick.cli').select { filter = { installed = true } }
      end,
      desc = 'attach [C]LI (installed)',
    },
    {
      '<leader>ad',
      function()
        require('sidekick.cli').close()
      end,
      desc = '[d]etach CLI',
    },
    {
      '<leader>ap',
      function()
        require('sidekick.cli').prompt()
      end,
      desc = 'Sidekick Prompt',
      mode = { 'n', 'x' },
    },
    -- sidekick send commands
    {
      '<leader>at',
      function()
        require('sidekick.cli').send { msg = '{this}', focus = true }
      end,
      mode = { 'x', 'n' },
      desc = 'Send This',
    },
    {
      '<leader>af',
      function()
        require('sidekick.cli').send { msg = '{file}', focus = true }
      end,
      desc = 'Send File',
    },
    {
      '<leader>av',
      function()
        require('sidekick.cli').send { msg = '{selection}' }
      end,
      mode = { 'x' },
      desc = 'Send Visual Selection',
    },
    -- sidekick Next Edit Commands (NES) commands
    {
      '<tab>',
      function()
        -- if there is a next edit, jump to it, otherwise apply it if any
        if require('sidekick').nes_jump_or_apply() then
          return -- jumped or applied
        end
        -- if you are using Neovim's native inline completions
        if vim.lsp.inline_completion.get() then
          return
        end
        -- fall back to normal tab
        return '<tab>'
      end,
      mode = { 'i', 'n' },
      expr = true,
      desc = 'Goto/Apply Next Edit Suggestion',
    },
    {
      '<leader>anx',
      function()
        require('sidekick.nes').clear()
      end,
      desc = 'Clear Next Edit Suggestions',
    },
    {
      '<leader>ant',
      function()
        require('sidekick.nes').toggle()
      end,
      desc = 'Toggle Next Edit Suggestions',
    },
    {
      '<leader>ann',
      function()
        require('sidekick.nes').update()
      end,
      desc = 'Request new edits from LSP server (if any)',
    },
    -- sidekick commands when mux.create is set to 'terminal'
    -- {
    --   '<c-.>',
    --   function()
    --     require('sidekick.cli').focus()
    --   end,
    --   mode = { 'n', 'x', 'i', 't' },
    --   desc = 'Sidekick Switch Focus',
    -- },
    -- {
    --   '<leader>ac',
    --   function()
    --     require('sidekick.cli').toggle { name = 'claude', focus = true }
    --   end,
    --   desc = 'Claude Code Toggle',
    -- },
  },
}
