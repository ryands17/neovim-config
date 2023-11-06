local overrides = require("custom.configs.overrides")

---@type NvPluginSpec[]
local plugins = {
	-- Navigate between vim and tmux panes
	{
		"christoomey/vim-tmux-navigator",
		lazy = false,
	},
	-- Beautiful notifications and todos in neovim
	{
		"rcarriga/nvim-notify",
		lazy = false,
		init = function()
			vim.notify = require("notify")
		end,
	},

	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
		event = "BufEnter",
	},

	-- Important LSP setup
	-- This plugin is for formatting files
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = overrides.conform,
	},

	{
		"neovim/nvim-lspconfig",
		config = function()
			require("plugins.configs.lspconfig")
			require("custom.configs.lspconfig")
		end, -- Override to setup mason-lspconfig
	},

	-- LSP plugins installer
	{
		"williamboman/mason.nvim",
		opts = overrides.mason,
	},

	-- Code highlighting and context awareness
	{
		"nvim-treesitter/nvim-treesitter",
		opts = overrides.treesitter,
	},

	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		event = "BufEnter",
	},

	{
		"ThePrimeagen/harpoon",
		keys = { "<leader>" },
		dependencies = { "nvim-lua/plenary.nvim" },
		event = "BufEnter",
	},

	-- File explorer and cool icons
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = overrides.nvimtree,
		cmd = { "NvimTreeToggle" },
	},

	{ "nvim-tree/nvim-web-devicons" },

	-- Make entering normal mode better
	{
		"max397574/better-escape.nvim",
		event = "InsertEnter",
		opts = overrides.better_escape,
	},

	-- Jump to places easily
	{
		"ggandor/leap.nvim",
		name = "leap",
		event = "BufEnter",
		config = function()
			require("leap").add_default_mappings()
		end,
	},

	-- Rust related plugins
	{
		"rust-lang/rust.vim",
		ft = { "rust" },
		init = function()
			vim.g.rustfmt_autosave = 1
		end,
	},

	{
		"simrat39/rust-tools.nvim",
		ft = { "rust" },
		dependencies = { "neovim/nvim-lspconfig" },
		opts = overrides.rusttools,
	},

	-- TypeScript plugin with better options
	{
		"jose-elias-alvarez/typescript.nvim",
		ft = { "typescript", "javascript", "typescriptreact", "javascriptreact", "astro" },
		dependencies = { "neovim/nvim-lspconfig" },
		opts = overrides.typescript,
	},

	-- Debugging adapter
	{
		"mfussenegger/nvim-dap",
		dependencies = { "williamboman/mason.nvim" },
		ft = { "typescript", "javascript", "typescriptreact", "javascriptreact", "astro", "rust", "python" },
		init = function()
			require("custom.configs.debugging")
		end,
	},

	-- Debugging UI to make things easy
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap" },
	},

	-- JSON schema support
	{
		"b0o/schemastore.nvim",
		ft = { "json", "jsonc" },
	},

	-- Vim surround and repeat for easy changes and repeats
	{
		"tpope/vim-surround",
		-- change the value of `timeoutlen` if it's not triggering correctly, see https://github.com/tpope/vim-surround/issues/117
		event = "BufEnter",
		init = function()
			vim.o.timeoutlen = 500
		end,
	},

	{
		"tpope/vim-repeat",
		event = "BufEnter",
	},

	-- Helpful diagnostics
	{
		"folke/trouble.nvim",
		cmd = "TroubleToggle",
	},

	{
		"folke/which-key.nvim",
		keys = { "<leader>", '"', "'", "`", "c", "v", "g" },
		init = function()
			require("core.utils").load_mappings("whichkey")
		end,
		config = function(_, opts)
			dofile(vim.g.base46_cache .. "whichkey")
			require("which-key").setup(opts)

			require("which-key").register({
				c = { name = "Custom+Quickfix" },
				d = { name = "Debugging" },
				f = { name = "Find" },
				g = { name = "Git" },
				l = { name = "Lsp" },
				m = { name = "Harpoon" },
				r = { name = "MoreLsp" },
				s = { name = "Splits" },
				t = { name = "Trouble" },
			}, { prefix = "<leader>" })
		end,
	},

	-- Easy code toggling
	{
		"Wansmer/treesj",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
		opts = overrides.treesj,
	},

	-- for an amazing Git experience
	{
		"tpope/vim-fugitive",
		cmd = {
			"G",
			"Git",
			"Gdiffsplit",
			"Gread",
			"Gwrite",
			"Ggrep",
			"GMove",
			"GDelete",
			"GBrowse",
			"GRemove",
			"GRename",
			"Glgrep",
			"Gedit",
		},
	},

	-- To make a plugin not be loaded
	-- {
	--   "NvChad/nvim-colorizer.lua",
	--   enabled = false
	-- },

	-- All NvChad plugins are lazy-loaded by default
	-- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`, `event`, or set `lazy = false`
	-- If you want a plugin to load on startup, add `lazy = false` to a plugin spec, for example
	-- {
	--   "mg979/vim-visual-multi",
	--   lazy = false,
	-- }
}

return plugins
