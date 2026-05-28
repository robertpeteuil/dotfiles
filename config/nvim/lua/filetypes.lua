-- [[ Filetypes ]]
--  See `:help filetype` and `:help new-filetype`

vim.filetype.add {
  filename = {
    -- docker-compose
    ['docker-compose.yml'] = 'yaml.docker-compose',
    ['docker-compose.yaml'] = 'yaml.docker-compose',
    ['compose.yml'] = 'yaml.docker-compose',
    ['compose.yaml'] = 'yaml.docker-compose',
    -- gitlab CI
    ['.gitlab-ci.yml'] = 'yaml.gitlab',
    ['.gitlab-ci.yaml'] = 'yaml.gitlab',
  },
  pattern = {
    -- docker-compose variants (e.g. docker-compose.override.yml)
    ['docker%-compose.*%.ya?ml'] = 'yaml.docker-compose',
    ['compose.*%.ya?ml'] = 'yaml.docker-compose',
    -- helm values files (commonly values.yaml or values-*.yaml under a chart)
    ['.*/templates/.*%.ya?ml'] = 'yaml.helm-values',
    ['.*/values.*%.ya?ml'] = 'yaml.helm-values',
  },
}
