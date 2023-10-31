local opt = vim.opt
local g = vim.g
local key = vim.keymap
local autocmd = vim.api.nvim_create_autocmd

g.mapleader = ","
g.rust_recommended_style = false
opt.relativenumber = true

-- allows neovim to access the system clipboard
opt.clipboard = "unnamedplus"
-- ignore compiled files
opt.wildignore = { "*.o", "*.a", "__pycache__" }
-- Remap VIM 0 to first non-blank character
key.set("n", "0", "^")
-- Set "Enter" to change the current word
key.set("n", "<Enter>", "ciw")

-- other vim options
opt.smarttab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.softtabstop = 2

-- folds
opt.foldenable = true
opt.foldmethod = "indent"
opt.foldlevelstart = 99

-- Auto resize panes when resizing nvim window
autocmd("VimResized", {
	pattern = "*",
	command = "tabdo wincmd =",
})

-- Always open file at last cursor position
autocmd("BufReadPost", {
	pattern = "",
	command = [[if line("'\"") > 1 && line("'\"") <= line("$")
   exe 'normal! g`"zvzz'
   endif]],
})

-- Set 4 spaces for Python, Kotlin
autocmd("FileType", {
	pattern = { "python", "java", "kotlin" },
	callback = function()
		opt.tabstop = 4
		opt.shiftwidth = 4
		opt.softtabstop = 4
	end,
})

-- Open telescope file finder if no file is open
autocmd("VimEnter", {
	callback = function()
		if vim.fn.argv(0) == "" then
			require("telescope.builtin").find_files()
		end
	end,
})

-- Set italics for code keywords
local function mod_hl(hl_name, opts)
	local is_ok, hl_def = pcall(vim.api.nvim_get_hl_by_name, hl_name, true)

	if is_ok then
		vim.api.nvim_set_hl(0, hl_name, vim.tbl_extend("force", hl_def or {}, opts))
	end
end

autocmd({ "VimEnter", "ColorScheme" }, {
	group = vim.api.nvim_create_augroup("HighlightColor", { clear = true }),
	pattern = "*",
	callback = function()
		mod_hl("TSKeywordReturn", { bold = true, italic = true })
		mod_hl("TSConstBuiltin", { bold = true, italic = true })
		mod_hl("TSFuncBuiltin", { bold = true, italic = true })
		mod_hl("TSTypeBuiltin", { bold = true, italic = true })
		mod_hl("TSBoolean", { bold = true, italic = true })

		mod_hl("TSType", { italic = true, bold = true })
		mod_hl("Type", { italic = true, bold = true })
		mod_hl("TSKeyword", { italic = true })
		mod_hl("Keyword", { italic = true, bold = true })
		mod_hl("TSParameter", { italic = true })
		mod_hl("TSLabel", { italic = true })
		mod_hl("TSAttribute", { bold = true, italic = true })
		mod_hl("TSVariableBuiltin", { italic = true })
		mod_hl("TSTagAttribute", { italic = true })

		mod_hl("TSComment", { italic = true })
		mod_hl("Comment", { italic = true })
		mod_hl("SpecialComment", { italic = true })
		mod_hl("TSConstructor", { bold = true })
		mod_hl("TSOperator", { bold = true })

		mod_hl("TSInclude", { italic = true })
		mod_hl("TSConditional", { italic = true })
		mod_hl("TSVariableBuiltin", { italic = true })
		mod_hl("TSKeywordFunction", { italic = true })

		mod_hl("semshiBuiltin", { italic = true })
		vim.api.nvim_set_hl(0, "semshiAttribute", { link = "TSAttribute" })
	end,
})

-- reload file on external changes
autocmd({ "CursorHold", "FocusGained" }, { command = "checktime" })
