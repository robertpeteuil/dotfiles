-- .nvim.lua - project specific nvim config

-- show hidden files in neotree by default
vim.g.project_neotree_show_hidden = true

-- show gitignored files in neotree
vim.g.project_neotree_show_gitignored = true

local project = vim.fn.getcwd()
local docs = vim.uv.fs_realpath(project .. "/docs")
local ceilings = {}

if docs then
	table.insert(ceilings, vim.fs.dirname(docs))
end

if vim.env.GIT_CEILING_DIRECTORIES and vim.env.GIT_CEILING_DIRECTORIES ~= "" then
	table.insert(ceilings, vim.env.GIT_CEILING_DIRECTORIES)
end

if #ceilings > 0 then
	vim.env.GIT_CEILING_DIRECTORIES = table.concat(ceilings, ":")
end
