return {
  'numToStr/Comment.nvim',
  config = function()
    require('Comment').setup()
    vim.keymap.del('n', 'gc')
    vim.keymap.del('n', 'gb')
    local wk = require 'which-key'
    wk.add {
      { 'gb', group = 'Comment toggle blockwise' },
      { 'gc', group = 'Comment toggle linewise' },
    }
  end,
}
