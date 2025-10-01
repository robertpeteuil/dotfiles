return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  -- cmd = 'Neotree',
  -- init = function()
  --   vim.api.nvim_create_autocmd('BufEnter', {
  --     -- make a group to be able to delete it later
  --     group = vim.api.nvim_create_augroup('NeoTreeInit', { clear = true }),
  --     callback = function()
  --       local f = vim.fn.expand '%:p'
  --       if vim.fn.isdirectory(f) ~= 0 then
  --         vim.cmd('Neotree current dir=' .. f)
  --         -- neo-tree is loaded now, delete the init autocmd
  --         vim.api.nvim_clear_autocmds { group = 'NeoTreeInit' }
  --       end
  --     end,
  --   })
  -- end,
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  ---@module "neo-tree"
  ---@type neotree.Config?
  opts = {
    auto_clean_after_session_restore = true, -- Automatically clean up broken neo-tree buffers saved in sessions
    close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
    -- enable_cursor_hijack = true, -- If enabled neotree will keep the cursor on the first letter of the filename when moving in the tree.
    filesystem = {
      hijack_netrw_behavior = 'open_current',
      follow_current_file = {
        enabled = true, -- This will find and focus the file in the active buffer every time
        -- the current file is changed while the tree is open.
        leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
      },
      filtered_items = {
        visible = false, -- when true, they will just be displayed differently than normal items
        hide_dotfiles = false,
        hide_gitignored = true,
        hide_hidden = true, -- only works on Windows for hidden files/directories
        hide_by_name = {
          '.git',
          --"node_modules"
        },
        hide_by_pattern = { -- uses glob style patterns
          --"*.meta",
          --"*/src/*/tsconfig.json",
        },
        always_show = { -- remains visible even if other settings would normally hide it
          --".gitignored",
        },
        always_show_by_pattern = { -- uses glob style patterns
          --".env*",
        },
        never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
          '.DS_Store',
        },
        never_show_by_pattern = { -- uses glob style patterns
          --".null-ls_*",
        },
      },
      window = {
        mappings = {
          ['\\'] = 'close_window',
          -- Sources:
          -- https://github.com/nvim-neo-tree/neo-tree.nvim/discussions/163#discussioncomment-4747082
          -- https://github.com/nvim-neo-tree/neo-tree.nvim/discussions/163#discussioncomment-7663286
          -- Jump up to parent directory on file or closed directory, or close on open directory
          ['h'] = function(state)
            local node = state.tree:get_node()
            if (node.type == 'directory' or node:has_children()) and node:is_expanded() then
              state.commands.toggle_node(state)
            else
              require('neo-tree.ui.renderer').focus_node(state, node:get_parent_id())
            end
          end,
          -- Open on file or closed directory, or jump down to top subdirectory on open directory
          ['l'] = function(state)
            local node = state.tree:get_node()
            if node.type == 'directory' or node:has_children() then
              if not node:is_expanded() then
                state.commands.toggle_node(state)
              else
                require('neo-tree.ui.renderer').focus_node(state, node:get_child_ids()[1])
              end
            else
              require('neo-tree.sources.filesystem.commands').open(state)
            end
          end,
          -- ['<S-Tab>'] = 'prev_source',
          -- ['<Tab>'] = 'next_source',
        },
      },
    },
    use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes
  },
}
