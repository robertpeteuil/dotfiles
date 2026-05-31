-- [[ Setting options ]]

-- Make line numbers default
vim.o.number = true
-- relative line numbers
vim.o.relativenumber = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- hide mode - in status line
vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule fter `UiEnter`
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets whitespace character display
vim.o.list = true
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }  -- original
-- vim.opt.listchars = { tab = '· ', trail = '·', nbsp = '␣' }  -- gen 1 - dot
vim.opt.listchars = { tab = '  ', trail = '·', nbsp = '␣' } -- gen 2 - none

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- Confirmation dialog
vim.o.confirm = true

-- set indent = 2 spaces
vim.o.tabstop = 2 -- A TAB character looks like 2 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 2 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 2 -- Number of spaces inserted when indenting

-- hide ~ at end of buffer
vim.opt.fillchars:append { eob = ' ' }

-- auto-session options
vim.o.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'

-- vim: ts=2 sts=2 sw=2 et
