return {
	"almo7aya/openingh.nvim",
	config = function()
		vim.api.nvim_set_keymap("n", "<Leader>og", ":OpenInGHFile <CR>", { silent = true, noremap = true })
		vim.api.nvim_set_keymap("v", "<Leader>og", ":OpenInGHFileLines <CR>", { silent = true, noremap = true })
	end,
}
