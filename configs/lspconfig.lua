local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require("lspconfig")

-- if you just want default config for the servers then put them in a table
local servers = {
	lua_ls = {
		on_init = function(client)
			local path = client.workspace_folders[1].name
			if not vim.loop.fs_stat(path .. "/.luarc.json") and not vim.loop.fs_stat(path .. "/.luarc.jsonc") then
				client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
						runtime = {
							-- Tell the language server which version of Lua you're using
							-- (most likely LuaJIT in the case of Neovim)
							version = "LuaJIT",
						},
						-- Make the server aware of Neovim runtime files
						workspace = {
							checkThirdParty = false,
							library = {
								vim.env.VIMRUNTIME,
								[vim.fn.expand("$VIMRUNTIME/lua")] = true,
								[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
								-- "${3rd}/busted/library",
							},
						},
					},
				})

				client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
			end
			return true
		end,
	},
	html = {},
	cssls = {},
	denols = {
		root_dir = function(fname)
			return lspconfig.util.root_pattern("deno.json", "deno.jsonc")(fname)
		end,
	},
	tailwindcss = {
		filetypes = { "css", "html", "javascriptreact", "svelte", "pug", "typescriptreact", "vue", "astro" },
	},
	astro = {
		filetypes = { "astro" },
	},
	emmet_ls = {
		filetypes = { "css", "html", "javascriptreact", "svelte", "typescriptreact", "vue", "astro" },
		init_options = {
			html = {
				options = {
					-- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
					["bem.enabled"] = false,
					["output.attributeQuotes"] = "double",
				},
			},
		},
	},
	jsonls = {
		filetypes = { "json", "jsonc" },
		settings = {
			json = {
				-- Schemas https://www.schemastore.org
				schemas = require("schemastore").json.schemas(),
			},
		},
		setup = {
			commands = {
				Format = {
					function()
						vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line("$"), 0 })
					end,
				},
			},
		},
	},
}

for lsp, config in pairs(servers) do
	lspconfig[lsp].setup(vim.tbl_deep_extend("force", { on_attach = on_attach, capabilities = capabilities }, config))
end
