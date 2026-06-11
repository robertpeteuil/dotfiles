return {
  'supermaven-inc/supermaven-nvim',
  dependencies = {
    {
      'saghen/blink.compat',
      version = '2.*',
      lazy = true,
      opts = {},
    },
  },
  opts = {
    disable_inline_completion = true,
    disable_keymaps = true,
    ignore_filetypes = {
      gitcommit = true,
      gitrebase = true,
      help = true,
      markdown = true,
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
