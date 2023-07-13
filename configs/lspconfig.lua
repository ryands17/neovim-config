local on_attach = require('plugins.configs.lspconfig').on_attach
local capabilities = require('plugins.configs.lspconfig').capabilities

local lspconfig = require 'lspconfig'

-- if you just want default config for the servers then put them in a table
local servers = {
  html = {},
  cssls = {},
  -- tsserver = {
  --   root_dir = function(fname)
  --     return lspconfig.util.root_pattern('tsconfig.json')(fname) or
  --         lspconfig.util.root_pattern('package.json', 'jsconfig.json', '.git')(
  --           fname
  --         ) or
  --         vim.fn.getcwd()
  --   end
  -- },
  emmet_ls = {
    filetypes = { 'css', 'html', 'javascriptreact', 'svelte', 'pug', 'typescriptreact', 'vue' },
    init_options = {
      html = {
        options = {
          -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
          ['bem.enabled'] = false,
          ['output.attributeQuotes'] = 'double'
        },
      },
    }
  },
  jsonls = {
    filetypes = { 'json', 'jsonc' },
    settings = {
      json = {
        -- Schemas https://www.schemastore.org
        schemas = require('schemastore').json.schemas()
      }
    },
    setup = {
      commands = {
        Format = {
          function()
            vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line '$', 0 })
          end,
        },
      },
    },
  },
}

for lsp, config in pairs(servers) do
  lspconfig[lsp].setup(
    vim.tbl_deep_extend('force', { on_attach = on_attach, capabilities = capabilities }, config)
  )
end