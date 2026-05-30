-- [[ Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight text when yanking
--   See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Refresh neo-tree after lazygit changes
vim.api.nvim_create_autocmd({ 'BufLeave' }, {
  pattern = { '*lazygit*' },
  group = vim.api.nvim_create_augroup('git_refresh_neotree', { clear = true }),
  callback = function()
    require('neo-tree.sources.filesystem.commands').refresh(require('neo-tree.sources.manager').get_state 'filesystem')
  end,
})

-- Prevent neo-tree from appearing in the buffer list
--    source: https://github.com/nvim-lualine/lualine.nvim/issues/1372
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'neo-tree',
  callback = function()
    -- Set the buffer to be unlisted
    vim.opt_local.buflisted = false
  end,
  desc = 'Prevent neo-tree from appearing in the buffer list',
})

-- Enable terminal progress bar for LSP progress
--    source: https://old.reddit.com/r/neovim/comments/1rcvliq/ghostty_lsp_progress_bar/o73wdkc/
vim.api.nvim_create_autocmd('LspProgress', {
  callback = function(ev)
    local value = ev.data.params.value or {}
    if not value.kind then
      return
    end

    local status = value.kind == 'end' and 0 or 1
    local percent = value.percentage or 0

    local osc_seq = string.format('\27]9;4;%d;%d\a', status, percent)

    if os.getenv 'TMUX' then
      osc_seq = string.format('\27Ptmux;\27%s\27\\', osc_seq)
    end

    io.stdout:write(osc_seq)
    io.stdout:flush()
  end,
})

-- Add a JSONL-only keymap to pretty-view the current buffer using jq
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  desc = 'Register JSONL pretty-view keymap',
  group = vim.api.nvim_create_augroup('jsonl_pretty_view_keymap', { clear = true }),
  pattern = '*.jsonl',
  callback = function(ev)
    vim.keymap.set('n', '<leader>bj', function()
      local lines = vim.api.nvim_buf_get_lines(ev.buf, 0, -1, false)
      local input = table.concat(lines, '\n')

      local out = vim.fn.systemlist({ 'jq', '.' }, input)

      if vim.v.shell_error ~= 0 then
        vim.notify(table.concat(out, '\n'), vim.log.levels.ERROR)
        return
      end

      vim.cmd 'tabnew'
      local buf = vim.api.nvim_get_current_buf()

      vim.bo[buf].buftype = 'nofile'
      vim.bo[buf].bufhidden = 'wipe'
      vim.bo[buf].swapfile = false
      vim.bo[buf].filetype = 'json'

      vim.api.nvim_buf_set_lines(buf, 0, -1, false, out)
      vim.bo[buf].modifiable = false
    end, {
      buffer = ev.buf,
      desc = 'Pretty view JSONL buffer',
    })
  end,
})

-- vim: ts=2 sts=2 sw=2 et
