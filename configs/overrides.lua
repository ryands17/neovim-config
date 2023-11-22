local key = vim.keymap
local icons = require("custom.configs.icons")
local MASON_PATH = vim.fn.expand("$HOME/.local/share/nvim/mason/packages")

local M = {}

M.treesitter = {
	ensure_installed = {
		"vim",
		"lua",
		"html",
		"css",
		"javascript",
		"typescript",
		"tsx",
		"markdown",
		"markdown_inline",
		"astro",
		"rust",
		"json",
		"python",
	},
	indent = {
		enable = true,
		-- disable = {
		--   "python"
		-- },
	},
	disable = function(lang, bufnr) --
		return vim.api.nvim_buf_line_count(bufnr) > 50000
	end,
}

M.mason = {
	ensure_installed = {
		-- lua stuff
		"lua-language-server",
		"stylua",

		-- web dev stuff
		"css-lsp",
		"html-lsp",
		"typescript-language-server",
		"deno",
		"prettier",
		"emmet-ls",
		"json-lsp",
		"astro",

		-- rust
		"rust-analyzer",
		"codelldb",
	},
}

local function nvim_tree_attach(bufnr)
	local api = require("nvim-tree.api")
	-- automatically open file on creation
	api.events.subscribe(api.events.Event.FileCreated, function(file)
		vim.cmd("edit " .. file.fname)
	end)

	-- open fold or file if exists
	local function open_folder_or_file()
		local node = api.tree.get_node_under_cursor()

		if node.nodes ~= nil then
			-- expand or collapse folder
			api.node.open.edit()
		else
			-- open file
			api.node.open.edit()
			-- Close the tree if file was opened
			api.tree.close()
		end
	end

	-- open as vsplit on current node
	local function vsplit_preview()
		local node = api.tree.get_node_under_cursor()

		if node.nodes ~= nil then
			-- expand or collapse folder
			api.node.open.edit()
		else
			-- open file as vsplit
			api.node.open.vertical()
		end

		-- Finally refocus on tree if it was lost
		api.tree.focus()
	end

	local function opts(desc)
		return {
			desc = "nvim-tree: " .. desc,
			buffer = bufnr,
			noremap = true,
			silent = true,
			nowait = true,
		}
	end

	-- default mappings
	api.config.mappings.default_on_attach(bufnr)

	-- custom mappings
	vim.keymap.set("n", "l", open_folder_or_file, opts("Open"))
	vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close directory"))
	vim.keymap.set("n", "L", vsplit_preview, opts("VSplit preview"))
	vim.keymap.set("n", "H", api.tree.collapse_all, opts("Close"))
end

M.nvimtree = {
	on_attach = nvim_tree_attach,
	renderer = {
		add_trailing = false,
		group_empty = false,
		highlight_git = true,
		full_name = false,
		highlight_opened_files = "none",
		root_folder_label = ":t",
		indent_width = 2,
		indent_markers = {
			enable = false,
			inline_arrows = true,
			icons = {
				corner = "└",
				edge = "│",
				item = "│",
				none = " ",
			},
		},
		icons = {
			webdev_colors = true,
			git_placement = "before",
			padding = " ",
			symlink_arrow = " ➛ ",
			show = {
				file = true,
				folder = true,
				folder_arrow = true,
				git = true,
			},
			glyphs = {
				default = icons.ui.Text,
				symlink = icons.ui.FileSymlink,
				bookmark = icons.ui.BookMark,
				folder = {
					arrow_closed = icons.ui.TriangleShortArrowRight,
					arrow_open = icons.ui.TriangleShortArrowDown,
					default = icons.ui.Folder,
					open = icons.ui.FolderOpen,
					empty = icons.ui.EmptyFolder,
					empty_open = icons.ui.EmptyFolderOpen,
					symlink = icons.ui.FolderSymlink,
					symlink_open = icons.ui.FolderOpen,
				},
				git = {
					unstaged = icons.git.FileUnstaged,
					staged = icons.git.FileStaged,
					unmerged = icons.git.FileUnmerged,
					renamed = icons.git.FileRenamed,
					untracked = icons.git.FileUntracked,
					deleted = icons.git.FileDeleted,
					ignored = icons.git.FileIgnored,
				},
			},
		},
		special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
		symlink_destination = true,
	},

	hijack_directories = {
		enable = false,
		auto_open = true,
	},

	update_focused_file = {
		enable = true,
		debounce_delay = 15,
		update_root = true,
		ignore_list = {},
	},

	diagnostics = {
		enable = true,
		show_on_dirs = false,
		show_on_open_dirs = true,
		debounce_delay = 50,
		severity = {
			min = vim.diagnostic.severity.HINT,
			max = vim.diagnostic.severity.ERROR,
		},
		icons = {
			hint = icons.diagnostics.BoldHint,
			info = icons.diagnostics.BoldInformation,
			warning = icons.diagnostics.BoldWarning,
			error = icons.diagnostics.BoldError,
		},
	},

	filters = {
		dotfiles = false,
		git_clean = false,
		no_buffer = false,
		custom = { "node_modules", "\\.cache" },
		exclude = {},
	},

	filesystem_watchers = {
		enable = true,
		debounce_delay = 50,
		ignore_dirs = {},
	},

	git = {
		enable = true,
		ignore = false,
		show_on_dirs = true,
		show_on_open_dirs = true,
		timeout = 200,
	},
	actions = {
		use_system_clipboard = true,
		change_dir = {
			enable = true,
			global = false,
			restrict_above_cwd = false,
		},
		expand_all = {
			max_folder_discovery = 300,
			exclude = {},
		},
		file_popup = {
			open_win_config = {
				col = 1,
				row = 1,
				relative = "cursor",
				border = "shadow",
				style = "minimal",
			},
		},
		open_file = {
			quit_on_open = false,
			resize_window = false,
			window_picker = {
				enable = true,
				picker = "default",
				chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
				exclude = {
					filetype = { "notify", "lazy", "qf", "diff", "fugitive", "fugitiveblame" },
					buftype = { "nofile", "terminal", "help" },
				},
			},
		},
		remove_file = {
			close_window = true,
		},
	},
}

local rust_extension_path = MASON_PATH .. "/codelldb/extension"
local codelldb_path = rust_extension_path .. "/adapter/codelldb"
local liblldb_path = rust_extension_path .. "/lldb/lib/liblldb.dylib"

-- rust tools
M.rusttools = {
	server = {
		on_attach = function(client, bufnr)
			require("plugins.configs.lspconfig").on_attach(client, bufnr)

			local rt = require("rust-tools")
			-- general settings
			rt.inlay_hints.enable()

			-- Rust mappings
			key.set("n", "<leader>rc", rt.hover_actions.hover_actions, { buffer = bufnr, desc = "Hover actions" })
			key.set(
				"n",
				"<leader>rr",
				rt.code_action_group.code_action_group,
				{ buffer = bufnr, desc = "Code action group" }
			)
			key.set("n", "<leader>ro", rt.open_cargo_toml.open_cargo_toml, { desc = "Open Cargo.toml" })

			-- refresh codelens on TextChanged and InsertLeave as well
			vim.api.nvim_create_autocmd({ 'TextChanged', 'InsertLeave' }, {
				buffer = bufnr,
				callback = vim.lsp.codelens.refresh,
			})
		end,
		capabilities = require("plugins.configs.lspconfig").capabilities,
	},
	tools = {
		hover_actions = {
			auto_focus = true,
		},
	},
	dap = {
		adapter = {
			type = "server",
			port = "${port}",
			host = "127.0.0.1",
			executable = {
				command = codelldb_path,
				args = { "--liblldb", liblldb_path, "--port", "${port}" },
			},
		},
	},
}

M.conform = {
	-- Define your formatters
	formatters_by_ft = {
		lua = { "stylua" },
		-- python = { "isort", "black" },
		javascript = { { "prettier", "prettierd" } },
		javascriptreact = { { "prettier", "prettierd" } },
		typescript = { { "prettier", "prettierd" } },
		typescriptreact = { { "prettier", "prettierd" } },
		json = { { "prettier", "prettierd" } },
		jsonc = { { "prettier", "prettierd" } },
		yaml = { { "prettier", "prettierd" } },
		html = { { "prettier", "prettierd" } },
		css = { { "prettier", "prettierd" } },
		markdown = { { "prettier", "prettierd" } },
		astro = { { "prettier", "prettierd" } },
	},
	-- Set up format-on-save
	format_on_save = { timeout_ms = 1000, lsp_fallback = true, async = false },
}

-- typescript server setup
M.typescript = {
	go_to_source_definition = { fallback = true },
	server = {
		root_dir = function(fname)
			local lspconfig = require("lspconfig")

			return lspconfig.util.root_pattern("tsconfig.json")(fname)
					or lspconfig.util.root_pattern("package.json", "jsconfig.json")(fname)
		end,
		on_attach = function(client, bufnr)
			require("plugins.configs.lspconfig").on_attach(client, bufnr)

			key.set(
				"n",
				"<leader>co",
				"<cmd>TypescriptOrganizeImports<CR>",
				{ buffer = bufnr, desc = "Organize Imports" }
			)
			key.set("n", "<leader>cR", "<cmd>TypescriptRenameFile<CR>", { desc = "Rename File", buffer = bufnr })

			vim.lsp.inlay_hint(bufnr, true)
		end,
		capabilities = require("plugins.configs.lspconfig").capabilities,
		settings = {
			javascript = {
				inlayHints = {
					includeInlayEnumMemberValueHints = false,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
					includeInlayParameterNameHintsWhenArgumentMatchesName = true,
					includeInlayPropertyDeclarationTypeHints = false,
					includeInlayVariableTypeHints = false,
				},
			},
			typescript = {
				inlayHints = {
					includeInlayEnumMemberValueHints = false,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
					includeInlayParameterNameHintsWhenArgumentMatchesName = true,
					includeInlayPropertyDeclarationTypeHints = false,
					includeInlayVariableTypeHints = false,
				},
			},
		},
	},
}

M.treesj = {
	use_default_keymaps = false,
	-- Notify about possible problems or not
	notify = true,
	-- Use `dot` for repeat action
	dot_repeat = true,
}

M.better_escape = {
	mapping = { "jk", "wq" },  -- a table with mappings to use
	timeout = vim.o.timeoutlen, -- the time in which the keys must be hit in ms. Use option timeoutlen by default
	clear_empty_lines = false, -- clear line after escaping if there is only whitespace
	keys = "<Esc>",            -- keys used for escaping, if it is a function will use the result everytime
}

return M
