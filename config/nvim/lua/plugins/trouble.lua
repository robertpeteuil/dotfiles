return {
  'folke/trouble.nvim',
  ---@class trouble.Config
  ---@field mode? string
  ---@field config? fun(opts:trouble.Config)
  opts = {
    warn_no_results = false,
    -- more advanced example that extends the lsp_document_symbols
    modes = {
      symbols = {
        desc = 'document symbols',
        mode = 'lsp_document_symbols',
        focus = false,
        win = {
          position = 'right',
          size = 0.3,
        },
        filter = {
          -- remove Package since luals uses it for control flow structures
          ['not'] = { ft = 'lua', kind = 'Package' },
          any = {
            -- all symbol kinds for help / markdown files
            ft = { 'help', 'markdown' },
            -- default set of symbol kinds
            kind = {
              'Class',
              'Constructor',
              'Enum',
              'Field',
              'Function',
              'Interface',
              'Method',
              'Module',
              'Namespace',
              'Package',
              'Property',
              'Struct',
              'Trait',
            },
          },
        },
      },
    },
  },
  cmd = 'Trouble',
  keys = {
    {
      '<leader>xx',
      '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
      desc = 'Buffer Diagnostics (Trouble)',
    },
    {
      '<leader>xX',
      '<cmd>Trouble diagnostics toggle<cr>',
      desc = 'Diagnostics (Trouble)',
    },
    {
      '<leader>xs',
      '<cmd>Trouble symbols toggle focus=false<cr>',
      desc = 'Symbols (Trouble)',
    },
    {
      '<leader>xl',
      '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
      desc = 'LSP Definitions / references / ... (Trouble)',
    },
    {
      '<leader>xL',
      '<cmd>Trouble loclist toggle<cr>',
      desc = 'Location List (Trouble)',
    },
    {
      '<leader>xQ',
      '<cmd>Trouble qflist toggle<cr>',
      desc = 'Quickfix List (Trouble)',
    },
  },
  --
}
