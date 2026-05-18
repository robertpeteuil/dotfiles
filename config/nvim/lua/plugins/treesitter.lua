local languages = {
  'bash',
  'c',
  'cpp',
  'css',
  'dockerfile',
  'fish',
  'go',
  'gomod',
  'hcl',
  'helm',
  'html',
  'ini',
  'java',
  'javascript',
  'json',
  'llvm',
  'lua',
  'make',
  'markdown',
  'markdown_inline',
  'ninja',
  'python',
  'rust',
  'scala',
  'terraform',
  'toml',
  'typescript',
  'vim',
  'vimdoc',
  'yaml',
  'zsh',
}

return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  branch = 'main',
  build = ':TSUpdate',
  config = function()
    local ts_gid = vim.api.nvim_create_augroup('treesitter_fts', { clear = true })
    vim.api.nvim_create_autocmd('FileType', {
      pattern = languages,
      callback = function()
        local nvim_ts = require 'nvim-treesitter'
        local installed_parsers = nvim_ts.get_installed()
        if not vim.list_contains(installed_parsers, vim.bo.filetype) then
          nvim_ts.install(vim.bo.filetype):wait(10000)
        end

        -- enable highlighting with treesitter for config defined 'languages'
        vim.treesitter.start()

        -- enable indentation
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
      group = ts_gid,
    })
  end,
}
