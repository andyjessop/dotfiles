return {
	-- 1. Core plugin
	"dyng/ctrlsf.vim",

	-- 4. Configuration
	config = function()
		vim.api.nvim_set_keymap("n", "<Leader>og", ":OpenInGHFile <CR>", { silent = true, noremap = true })
	end,
}
