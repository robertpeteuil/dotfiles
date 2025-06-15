-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  See `:help wincmd` for a list of all window commands
--  configured in `custom/plugins/tmux-navigator.lua`

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- ------------------------------------------------
-- PERSONAL OPTIONS

-- keymap to insert date into register d
vim.keymap.set('n', '<leader>d', function()
  vim.fn.setreg('d', os.date '%Y-%m-%d', 'c')
end, { desc = 'Update register timestamp' })

-- leader key mappings
vim.keymap.set('n', '<leader>b', ':Neotree buffers<CR>', { desc = 'Explore [B]uffers' })

-- Meta keybinds require setting iTerm profile key bindings to send Esc+ for left option key
vim.keymap.set('n', '<M-j>', ':m .+1<CR>==') -- move line down
vim.keymap.set('n', '<M-k>', ':m .-2<CR>==') -- move line up

-- END PERSONAL
-- ------------------------------------------------

-- vim: ts=2 sts=2 sw=2 et
