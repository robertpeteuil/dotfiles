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

-- Special paste from yank buffer
vim.keymap.set({ 'n', 'x' }, '<leader>p', [["0p]], { desc = '[P]aste from yank register' })

-- keymap to toggle boolean value
vim.keymap.set('n', '<leader>T', function()
  local toggles = {
    ['true'] = 'false',
    ['always'] = 'never',
    ['yes'] = 'no',
    ['1'] = '0',
    ['on'] = 'off',
    ['&&'] = '||',
    ['+'] = '-',
    ['<'] = '>',
    ['<='] = '>=',
    ['let'] = 'const',
  }

  local cword = vim.fn.expand '<cword>'
  local newWord
  for word, opposite in pairs(toggles) do
    if cword == word then
      newWord = opposite
    end
    if cword == opposite then
      newWord = word
    end
  end
  if newWord then
    local prevCursor = vim.api.nvim_win_get_cursor(0)
    vim.cmd.normal { '"_ciw' .. newWord, bang = true }
    vim.api.nvim_win_set_cursor(0, prevCursor)
  end
end, { desc = '[T]oggle Boolean Value', silent = true })

-- keymap to insert date into register d
vim.keymap.set('n', '<leader>d', function()
  vim.fn.setreg('d', os.date '%Y-%m-%d', 'c')
end, { desc = 'Update register timestamp' })

-- keymap to copy full path of current buffer to clipboard
-- vim.keymap.set('n', '<leader>c', ':let @+ = expand("%:p")<CR>==', { desc = '[C]opy Buffer Full Path' })
vim.keymap.set('n', '<leader>yp', ':let @+ = expand("%:p")<CR>==', { desc = '[Y]ank [P]ath', silent = true })

-- close current buffer and switch to last buffer
vim.keymap.set('n', '<leader>bd', ':<C-U>bprevious <bar> bdelete #<CR>==', { desc = '[B]uffer [D]elete', silent = true })

-- leader key mappings
-- vim.keymap.set('n', '<leader>b', ':Neotree buffers<CR>', { desc = 'Explore [B]uffers' })

-- Meta keybinds require terminal settings
--    iTerm - profile key bindings to send Esc+ for left option key
--    ghostty - add `macos-option-as-alt = true` to config

-- toggle transparency
--   required loading 'xiyaowong/transparent.nvim' from "custom/plugins/init.lue"
vim.keymap.set('n', '<M-t>', ':TransparentToggle<CR>==', { desc = 'Toggle [T]ransparency', silent = true })

-- move lines up/down
vim.keymap.set('n', '<M-j>', ':m .+1<CR>==', { silent = true })
vim.keymap.set('n', '<M-k>', ':m .-2<CR>==', { silent = true })

-- END PERSONAL
-- ------------------------------------------------

-- vim: ts=2 sts=2 sw=2 et
