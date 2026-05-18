-- Highlight todo, notes, etc in comments
return {
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },

    -- PERF: fully optimised
    -- FIX: ddddddasdasdasdasdasda
    -- FIXME: dddddd
    -- HACK: hmmm, this looks a bit funky
    -- TODO: What else?
    -- NOTE: adding a note
    -- WARNING: ???
  },
}
-- vim: ts=2 sts=2 sw=2 et
