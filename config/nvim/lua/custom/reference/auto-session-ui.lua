return {
  'MinecraftPotatoe/AutosessionUI.nvim',
  ---@type auto-session-ui.opts
  opts = {},
  init = function()
    -- This is an example how your config could look like
    -- Set your keybindings here
    local wk = require 'which-key'
    wk.add {
      -- { "<leader>s", group = "Sessions", icon = "" },
      { '<leader>sp', desc = 'Pick session', callback = ':AutosessionUI pick<CR>' },
      -- { "<leader>sa", desc = "Add/Rename session", callback = ":AutosessionUI add<CR>" },
      -- { "<leader>sr", desc = "Remove session", callback = ":AutosessionUI remove<CR>" },
      -- { "<leader>sf", desc = "Toggle current session as favorite", callback = ":AutosessionUI favorite<CR>" },
    }
  end,
  dependencies = {
    'rmagatti/auto-session',
    'nvim-telescope/telescope.nvim', -- for using the telescope picker
  },
}
