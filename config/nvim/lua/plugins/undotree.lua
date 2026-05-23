return {
  'mbbill/undotree',
  config = function()
    -- Custom Function to auto-hide to toggle undotree and neo-tree simulataneously
    --    toggling ON undotree will auto-hide neo-tree if visible
    --    togglinf OFF undotree will auto-show neo-tree if it was visible
    local neo_tree_was_open = false

    local function is_neo_tree_visible()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local ft = vim.bo[buf].filetype
        if ft == 'neo-tree' then
          return true
        end
      end
      return false
    end

    local function is_undotree_visible()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local ft = vim.bo[buf].filetype
        if ft == 'undotree' then
          return true
        end
      end
      return false
    end

    local function toggle_undotree_with_neo_tree()
      if not is_undotree_visible() then
        -- We want to show undotree
        if is_neo_tree_visible() then
          neo_tree_was_open = true
          vim.cmd 'Neotree close'
        else
          neo_tree_was_open = false
        end
        vim.cmd 'UndotreeShow'
        vim.cmd 'UndotreeFocus'
      else
        -- Undotree is visible, hide it
        vim.cmd 'UndotreeHide'
        if neo_tree_was_open then
          vim.cmd 'Neotree action=show toggle reveal'
          neo_tree_was_open = false
        end
      end
    end

    vim.keymap.set('n', '<leader>u', toggle_undotree_with_neo_tree, { desc = '[u]ndotree' })
    -- vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = '[u]ndotree', silent = true })
  end,
}
