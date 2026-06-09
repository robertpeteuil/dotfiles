-- [[ Keymaps ]]
--
--    additional keymaps defined in plugin definitions in plugins/
--    See `:help vim.keymap.set()`
--

-- ######## Misc -------------------------------------------

-- remap ZZ to confirm quit
vim.keymap.set('n', 'ZZ', '<Cmd>confirm qall<CR>', { desc = 'Quit all, prompting to save changes', silent = true })

-- Clear highlights on search
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic current line (float)
vim.keymap.set('n', '<leader>d', '<cmd>lua vim.diagnostic.open_float(0, {scope="line"})<CR>', { desc = '[d]iagnotic (float)', silent = true })

-- Diagnostics (kickstart default)
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in builtin terminal
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('t', '<C-n>', [[<C-\><C-n>]], { noremap = true, silent = true, desc = 'Exit terminal mode' })

-- -- Buffer Local Keymaps (WhichKey)
-- vim.keymap.set('n', '<leader>?', function()
--   require('which-key').show { global = false }
-- end, { desc = 'buffer local keymaps (whichkey)' })

-- ######## Search -----------------------------------------
--
-- Search TODOs with Telescope
vim.keymap.set('n', '<leader>sT', '<cmd>TodoTelescope<CR>', { desc = 'search [T]ODO comments', silent = true })

-- ######## Toggles ----------------------------------------
--
-- toggle transparency
--   required loading 'xiyaowong/transparent.nvim' from "custom/plugins/init.lue"
vim.keymap.set('n', '<leader>tt', '<cmd>TransparentToggle<CR>==', { desc = 'toggle [t]ransparency', silent = true })

-- toggle markdown rendering
vim.keymap.set('n', '<leader>tm', '<cmd>RenderMarkdown toggle<cr>', { desc = 'toggle [m]arkdown render', silent = true })

-- Toggle boolean value
vim.keymap.set('n', '<leader>tv', function()
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
end, { desc = 'toggle boolean [v]alue', silent = true })

-- ######## Buffer Related ---------------------------------
--
-- Close current buffer and switch to last buffer
--    note: <cmd> specification breaks functionality
vim.keymap.set('n', '<leader>bd', ':<C-U>bprevious <bar> bdelete #<CR>==', { desc = 'buffer [d]elete', silent = true })

-- Pretty view JSONL (only available in JSONL buffers
--   <leader>bj keymap mapped in `nvim/lua/autocommands.lua:57:1`

-- ######## Editing ----------------------------------------
--
-- Yank date into register d -- disabled 20260517
vim.keymap.set('n', '<leader>yd', function()
  vim.fn.setreg('d', os.date '%Y-%m-%d', 'c')
end, { desc = 'yank [d]ate to register d' })

-- Yank full path of current buffer to clipboard
vim.keymap.set('n', '<leader>yp', '<cmd>let @+ = expand("%:p")<CR>==', { desc = 'yank [p]ath', silent = true })

-- Yank file reference (relative path + line + column) to clipboard
vim.keymap.set('n', '<leader>yf', function()
  local ref = vim.fn.expand '%:.' .. ':' .. vim.fn.line '.' .. ':' .. vim.fn.col '.'
  vim.fn.setreg('+', ref)
  vim.notify('Copied: ' .. ref)
end, { desc = 'Copy file reference' })

-- Paste from yank-specific buffer
vim.keymap.set({ 'n', 'x' }, '<leader>p', [["0p]], { desc = '[p]aste yank register' })

-- Move lines up/down
--    note: meta-key requires terminal config
--      iTerm - profile key-bindings: left option key sends Esc+
--      ghostty - `macos-option-as-alt = true` in config
vim.keymap.set('n', '<M-j>', '<cmd>m .+1<CR>==', { silent = true })
vim.keymap.set('n', '<M-k>', '<cmd>m .-2<CR>==', { silent = true })

-- ######## Terminal ---------------------------------------

-- Toggle terminal width
local term_wide = false
local term_original_width = nil
local EXTRA_COLS = 40

local function find_term_win()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].buftype == 'terminal' then
      return win
    end
  end
end

local function toggle_terminal_width()
  local term_win = find_term_win()
  if not term_win then
    return
  end

  if not term_wide then
    term_original_width = vim.api.nvim_win_get_width(term_win)
    vim.api.nvim_win_call(term_win, function()
      vim.cmd(EXTRA_COLS .. 'wincmd >')
    end)
    term_wide = true
  else
    if term_original_width then
      vim.api.nvim_win_set_width(term_win, term_original_width)
    end
    term_wide = false
  end
end

vim.keymap.set('n', '<leader>tw', toggle_terminal_width, { desc = 'toggle [t]erminal width' })
-- note: terminal-mode hotkey is Ctrl-/ but defined as <C-_>
vim.keymap.set('t', '<C-_>', toggle_terminal_width, { desc = 'toggle [t]erminal width' })

-- vim: ts=2 sts=2 sw=2 et
