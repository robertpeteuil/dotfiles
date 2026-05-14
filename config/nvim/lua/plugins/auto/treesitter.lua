local languages = {
  'bash',
  'c',
  'cpp',
  'css',
  'dockerfile',
  'go',
  'hcl',
  'helm',
  'html',
  'java',
  'javascript',
  'json',
  'llvm',
  'lua',
  'make',
  'markdown',
  'python',
  'query',
  'regex',
  'rust',
  'terraform',
  'toml',
  'tsx',
  'typescript',
  'vimdoc',
  'yaml',
  'zig',
}

return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = { 'neovim-treesitter/treesitter-parser-registry' },
  lazy = false,
  branch = 'main',
  build = ':TSUpdate',
  config = function()
    -- guard the parser attachment
    vim.api.nvim_create_autocmd('FileType', {
      callback = function()
        pcall(vim.treesitter.start)
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" -- indentation
      end,
    })
    require('nvim-treesitter').install(languages)
  end,
}
