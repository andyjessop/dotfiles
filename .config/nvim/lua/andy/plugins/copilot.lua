return {
	"github/copilot.vim",
	event = "InsertEnter",
	config = function()
		-- vim.g.copilot_no_tab_map = true -- disable default <Tab> mapping
		-- vim.api.nvim_set_keymap(
		-- 	"i",
		-- 	"<C-J>",
		-- 	'copilot#Accept("<CR>")',
		-- 	{ expr = true, silent = true, desc = "Accept Copilot suggestion" }
		-- )
	end,
}
