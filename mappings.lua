local M = {}

M.general = {
	n = {
		["<leader>s"] = { ":w<cr>", "Save buffer" },
		["<leader>X"] = { ":q!<cr>", "Close window" },
		["<C-d>"] = { "<C-d>zz" },
		-- easy execution of macros on the register "q"
		["<space>"] = { "@q", "Repeat macro" },
		-- move current line / block with Alt-j/k ala vscode.
		["<A-j>"] = { ":m .+1<cr>==" },
		["<A-k>"] = { ":m .-2<cr>==" },
		-- mappings for vim-tmux-navigator
		["<C-h>"] = { "<cmd>TmuxNavigateLeft<cr>", "window left" },
		["<C-j>"] = { "<cmd>TmuxNavigateDown<cr>", "window down" },
		["<C-k>"] = { "<cmd>TmuxNavigateUp<cr>", "window up" },
		["<C-l>"] = { "<cmd>TmuxNavigateRight<cr>", "window right" },
		-- toggle theme
		["<leader>wt"] = {
			function()
				require("base46").toggle_theme()
			end,
			"Toggle theme",
		},
		-- toggle tree
		-- ["<leader>e"] = { "<cmd> NvimTreeToggle<cr>", "Toggle nvimtree" },
		-- open oil in current directory
		["<leader>e"] = { "<cmd>Oil<cr>", "Open file explorer" },
	},
	v = {
		["<leader>p"] = { '"_dP', "Paste without losing clip" },
	},
}

M.gitsigns = {
	n = {
		["<leader>gs"] = {
			function()
				require("gitsigns").stage_hunk()
			end,
			"Stage Hunk",
		},
		["<leader>gu"] = {
			function()
				require("gitsigns").undo_stage_hunk()
			end,
			"Undo Stage Hunk",
		},
		["<leader>gr"] = {
			function()
				require("gitsigns").reset_hunk()
			end,
			"Reset Hunk",
		},
		["<leader>gp"] = {
			function()
				require("gitsigns").preview_hunk()
			end,
			"Preview Hunk",
		},
		["<leader>gt"] = {
			function()
				require("gitsigns").toggle_deleted()
			end,
			"Toggle deleted",
		},
	},
	v = {
		["<leader>gs"] = {
			function()
				require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end,
			"Stage Hunk",
		},
		["<leader>gr"] = {
			function()
				require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end,
			"Reset Hunk",
		},
	},
}

M.quickfix = {
	n = {
		["<leader>co"] = { ":copen<cr>", "Open q window" },
		["<leader>cw"] = { ":cw<cr>", "Open q window on err" },
		["<leader>cl"] = { ":ccl<cr>", "Close q window" },
		["]q"] = { ":cn<cr>", "Next item" },
		["[q"] = { ":cp<cr>", "Previous item" },
		-- ["<leader>cr"] = { ":.cc<cr>", "Item under cursor" },
	},
}

M.harpoon = {
	n = {
		["<leader>mm"] = {
			function()
				require("harpoon.mark").add_file()
			end,
			"Add mark",
		},
		["<leader>mu"] = {
			function()
				require("harpoon.ui").toggle_quick_menu()
			end,
			"Toggle menu",
		},
		["<Tab>"] = {
			function()
				require("harpoon.ui").nav_next()
			end,
			"Next file",
		},
		["<S-Tab>"] = {
			function()
				require("harpoon.ui").nav_prev()
			end,
			"Previous file",
		},
	},
}

M.trouble = {
	n = {
		["<leader>tt"] = { "<cmd>TroubleToggle<cr>", "trouble" },
		["<leader>tr"] = { "<cmd>Trouble lsp_references<cr>", "References" },
		["<leader>tf"] = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
		["<leader>tc"] = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
		["<leader>tq"] = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
		["<leader>tl"] = { "<cmd>Trouble loclist<cr>", "LocationList" },
		["<leader>tw"] = { "<cmd>Trouble workspace_diagnostics<cr>", "Workspace Diagnostics" },
		["<leader>to"] = { "<cmd>TodoTrouble<cr>", "Comment list" },
		["<leader>ts"] = { "<cmd>TodoTelescope<cr>", "Comment list - telescope" },
	},
}

M.splits = {
	n = {
		["<leader>Sv"] = { "<cmd>vs<cr>", "Vertical split" },
		["<leader>Sh"] = { "<cmd>sp<cr>", "Horizontal split" },
		["<leader>Se"] = { "<C-w>=", "Equal size splits" },
		["<S-Left>"] = { ":vertical resize +5<cr>" },
		["<S-Right>"] = { ":vertical resize -5<cr>" },
		["<S-Up>"] = { ":resize +5<cr>" },
		["<S-Down>"] = { ":resize -5<cr>" },
	},
}

M.treesj = {
	n = {
		["<leader>lt"] = {
			function()
				require("treesj").toggle()
			end,
			"Toggle code block",
		},
	},
}

M.lsp = {
	n = {
		["gr"] = {
			function()
				require("telescope.builtin").lsp_references()
			end,
			"Telescope references",
		},
		["gR"] = {
			function()
				require("nvchad.renamer").open()
			end,
			"Rename",
		},
		["gs"] = {
			function()
				vim.lsp.buf.signature_help()
			end,
			"show signature help",
		},
		["gl"] = {
			function()
				local float = vim.diagnostic.config().float

				if float then
					local config = type(float) == "table" and float or {}
					config.scope = "line"

					vim.diagnostic.open_float(config)
				end
			end,
			"Show line diagnostics",
		},
		["<leader>cr"] = { vim.lsp.codelens.run, "Codelens actions" }
	},
}

M.dap = {
	n = {
		["<leader>dt"] = {
			function()
				require("dap").toggle_breakpoint()
			end,
			"Toggle Breakpoint",
		},
		["<leader>db"] = {
			function()
				require("dap").step_back()
			end,
			"Step Back",
		},
		["<leader>dc"] = {
			function()
				require("dap").continue()
			end,
			"Continue",
		},
		["<leader>dR"] = {
			function()
				require("dap").run_to_cursor()
			end,
			"Run to Cursor",
		},
		["<leader>dE"] = {
			function()
				require("dapui").eval(vim.fn.input("[Expression] > "))
			end,
			"Evaluate Input",
		},
		["<leader>dg"] = {
			function()
				require("dap").session()
			end,
			"Get Session",
		},
		["<leader>dC"] = {
			function()
				require("dap").set_breakpoint(vim.fn.input("[Condition] > "))
			end,
			"Conditional Breakpoint",
		},
		["<leader>dU"] = {
			function()
				require("dapui").toggle({ reset = true })
			end,
			"Toggle UI",
		},
		["<leader>dd"] = {
			function()
				require("dap").disconnect()
			end,
			"Disconnect",
		},
		["<leader>de"] = {
			function()
				require("dapui").eval()
			end,
			mode = { "n", "v" },
			"Evaluate",
		},
		["<leader>dh"] = {
			function()
				require("dap.ui.widgets").hover()
			end,
			"Hover Variables",
		},
		["<leader>dS"] = {
			function()
				require("dap.ui.widgets").scopes()
			end,
			"Scopes",
		},
		["<leader>di"] = {
			function()
				require("dap").step_into()
			end,
			"Step Into",
		},
		["<leader>do"] = {
			function()
				require("dap").step_over()
			end,
			"Step Over",
		},
		["<leader>dp"] = {
			function()
				require("dap").pause()
			end,
			"Pause",
		},
		["<leader>dq"] = {
			function()
				require("dap").close()
			end,
			"Quit",
		},
		["<leader>dr"] = {
			function()
				require("dap").repl.toggle()
			end,
			"Toggle REPL",
		},
		["<leader>du"] = {
			function()
				require("dap").step_out()
			end,
			"Step Out",
		},
		["<leader>ds"] = {
			function()
				require("dap").continue()
			end,
			"Start",
		},
		["<leader>dx"] = {
			function()
				require("dap").terminate()
			end,
			"Terminate",
		},
	},
}

return M
