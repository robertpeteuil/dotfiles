return {
  'MeanderingProgrammer/render-markdown.nvim',
  ft = { 'markdown' },
  opts = {},
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'echasnovski/mini.nvim',
  },
  config = function()
    require('render-markdown').setup {
      -- Whether markdown should be rendered by default.
      enabled = true,
      -- Vim modes that will show a rendered view of the markdown file, :h mode(), for all enabled
      -- components. Individual components can be enabled for other modes. Remaining modes will be
      -- unaffected by this plugin.
      -- render_modes = { 'n', 'c' },
      completions = { lsp = { enabled = true } },
    }
  end,
}
