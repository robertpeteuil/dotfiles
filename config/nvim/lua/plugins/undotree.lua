return {
  'mbbill/undotree',
  config = function()
    vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = '[u]ndotree', silent = true })
    -- TODO: create custom function
    --        hide neo-tree '<cmd>Neotree action=close<CR>'
    --        toggle undotree: vim.cmd.UndotreeToggle
    --        show undotree - <cmd>UndotreeShow<cr>
    --        hide undotree - <cmd>UndotreeHide<cr>
  end,
}
