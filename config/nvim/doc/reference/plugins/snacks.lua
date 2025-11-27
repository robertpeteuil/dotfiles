return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- scroll = {
    --   -- your scroll configuration comes here
    --   -- or leave it empty to use the default settings
    --   -- refer to the configuration section below
    -- },
    gh = {
      enabled = true,
      -- your gh configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    picker = {
      enabled = true,
      sources = {
        gh_issue = {
          -- your gh_issue picker configuration comes here
          -- or leave it empty to use the default settings
        },
        gh_pr = {
          -- your gh_pr picker configuration comes here
          -- or leave it empty to use the default settings
        },
      },
    },
  },
  keys = {
    {
      '<leader>gi',
      function()
        Snacks.picker.gh_issue()
      end,
      desc = 'GitHub Issues (open)',
    },
    {
      '<leader>gI',
      function()
        Snacks.picker.gh_issue { state = 'all' }
      end,
      desc = 'GitHub Issues (all)',
    },
    {
      '<leader>gp',
      function()
        Snacks.picker.gh_pr()
      end,
      desc = 'GitHub Pull Requests (open)',
    },
    {
      '<leader>gP',
      function()
        Snacks.picker.gh_pr { state = 'all' }
      end,
      desc = 'GitHub Pull Requests (all)',
    },
  },
}
