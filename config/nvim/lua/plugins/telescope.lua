-- NOTE: Plugins can specify dependencies.
--
-- The dependencies are proper plugin specifications as well - anything
-- you do for a plugin at the top level, you can do for a dependency.
--
-- Use the `dependencies` key to specify the dependencies of a particular plugin

return {
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    version = '*',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'ThePrimeagen/git-worktree.nvim',
      {
        'isak102/telescope-git-file-history.nvim',
        dependencies = {
          'nvim-lua/plenary.nvim',
          'tpope/vim-fugitive',
        },
      },
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      local extensions = require('telescope').extensions

      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
        -- pickers = {}
        defaults = {
          -- initial_mode = 'normal',
          vimgrep_arguments = {
            'rg',
            '--hidden',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            -- '!**/.git/*',
          },
        },
        pickers = {
          buffers = {
            -- initial_mode = 'normal', -- use NORMAL mode for buffer picker
            show_all_buffers = true,
            sort_lastused = true,
            previewer = true,
            -- enable closing selected buffer with d (Normal) and Control-d (Insert)
            --   ref: https://github.com/nvim-telescope/telescope.nvim/pull/828
            mappings = {
              n = {
                ['d'] = 'delete_buffer',
              },
              i = {
                ['<c-d>'] = 'delete_buffer',
              },
            },
          },
          find_files = {
            hidden = true,
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- Enable git-file-history extension and keymaps
      pcall(require('telescope').load_extension, 'git_file_history')
      vim.keymap.set('n', '<leader>gf', extensions.git_file_history.git_file_history, { desc = 'show [f]ile history' })

      -- Enable git-worktree extension and keymaps
      pcall(require('telescope').load_extension, 'git_worktree')
      vim.keymap.set('n', '<leader>gw', extensions.git_worktree.git_worktrees, { desc = 'switch [w]orktree' })
      vim.keymap.set('n', '<leader>gW', extensions.git_worktree.create_git_worktree, { desc = 'create [W]orktrees' })

      -- procession seach integration
      -- pcall(require('telescope').load_extension, 'prosession')
      -- vim.keymap.set('n', '<Leader>sp', '<cmd>Telescope prosession<CR>', { desc = 'search [P]rosessions' })

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = 'search [h]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = 'search [k]eymaps' })
      -- adjust telescope search to leader S T
      vim.keymap.set('n', '<leader>st', builtin.builtin, { desc = 'search select [t]elescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = 'search current [w]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = 'search by [g]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = 'search [d]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = 'search [r]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = 'search recent files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] find open buffers' })

      -- Custom find files that includes hidden, but excludes .git
      --   source 1: https://old.reddit.com/r/neovim/comments/nspg8o/telescope_find_files_not_showing_hidden_files/
      --   source 2: https://github.com/creativenull/dotfiles/blob/4fc5971029604ff1c338cfe0c6c2c333d9ee3ec4/.config/nvim-nightly/lua/creativenull/plugins/config/telescope.lua#L17
      vim.keymap.set('n', '<leader>sf', function()
        builtin.find_files {
          find_command = { 'rg', '--files', '--iglob', '!.git', '--hidden' },
        }
      end, { desc = 'search [f]iles' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          -- winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] search buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = 'search [/] in open files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = 'search [n]eovim files' })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
