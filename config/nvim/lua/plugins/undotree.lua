return {
  'mbbill/undotree',
  config = function()
    vim.g.undotree_SplitWidth = 35

    -- Custom Function to auto-hide to toggle undotree and neo-tree simulataneously
    --    toggling ON undotree will auto-hide neo-tree if visible
    --    togglinf OFF undotree will auto-show neo-tree if it was visible
    local neo_tree_was_open = false
    local neo_tree_width = nil

    local function get_neo_tree_win()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local ft = vim.bo[buf].filetype
        if ft == 'neo-tree' then
          return win
        end
      end
      return nil
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
        local neo_tree_win = get_neo_tree_win()
        if neo_tree_win then
          neo_tree_was_open = true
          neo_tree_width = vim.api.nvim_win_get_width(neo_tree_win)
          vim.g.undotree_SplitWidth = neo_tree_width + 0
          vim.cmd 'Neotree close'
        else
          neo_tree_was_open = false
          neo_tree_width = nil
        end
        vim.cmd 'UndotreeShow'
        vim.cmd 'UndotreeFocus'
      else
        vim.cmd 'UndotreeHide'
        if neo_tree_was_open then
          vim.cmd 'Neotree action=show toggle reveal'
          neo_tree_was_open = false
        end
        neo_tree_width = nil
      end
    end

    vim.keymap.set('n', '<leader>u', toggle_undotree_with_neo_tree, { desc = '[u]ndotree' })
  end,
}
