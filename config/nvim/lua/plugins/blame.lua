return {
  {
    'FabijanZulj/blame.nvim',
    lazy = false,
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('blame').setup {
        date_format = '%Y.%m.%d',
        -- relative_date_if_recent = false,
      }
    end,
  },
}
