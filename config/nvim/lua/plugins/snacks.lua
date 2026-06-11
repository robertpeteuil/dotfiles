return {
  ---@module "snacks"
  'folke/snacks.nvim',
  lazy = false,
  priority = 1000, -- Load early to ensure keymaps are registered
  -- optional = true,
  opts = {
    input = {}, -- Enhances `ask()`
    picker = { -- Enhances `select()`
      actions = {},
      win = {
        input = {
          keys = {},
        },
      },
    },
  },
}
