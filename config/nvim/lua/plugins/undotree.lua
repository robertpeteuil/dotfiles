return {
  'mbbill/undotree',
  config = function()
    vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = '[U]ndotree', silent = true })
    -- TODO: create custom function
    --        toggle on undotree
    --          get neotree status - save
    --          neotree hide if needed
    --          show undotree
    --        toggle off undotree
    --          hide undotree
    --          restore neotree if necesary
  end,
}
