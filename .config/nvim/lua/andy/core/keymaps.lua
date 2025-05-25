vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down" }) -- increment
keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- leave cursor on same word after *
vim.keymap.set("n", "*", function()
	local pos = vim.api.nvim_win_get_cursor(0)
	vim.cmd("keepjumps normal! *")
	vim.api.nvim_win_set_cursor(0, pos)
end, { noremap = true, silent = true, desc = "Search word under cursor without jumping" })

-- Table to store the last cursor position for each buffer
local last_positions = {}

-- Function to update the last position when leaving a buffer
local function update_last_position()
	local bufnr = vim.api.nvim_get_current_buf()
	local cursor = vim.api.nvim_win_get_cursor(0)
	last_positions[bufnr] = cursor
end

-- Set up an autocommand to update the last position when leaving a buffer
vim.api.nvim_create_autocmd({ "BufLeave" }, {
	callback = update_last_position,
})

function list_buffers_in_quickfix()
	local buffers = vim.api.nvim_list_bufs()
	local qf_list = {}

	for _, bufnr in ipairs(buffers) do
		if vim.api.nvim_buf_is_loaded(bufnr) then
			local bufname = vim.api.nvim_buf_get_name(bufnr)
			if bufname ~= "" then
				local position = last_positions[bufnr] or { 1, 1 }
				table.insert(qf_list, {
					bufnr = bufnr,
					filename = bufname,
					lnum = position[1],
					col = position[2],
					text = "Buffer " .. bufnr,
				})
			end
		end
	end

	vim.fn.setqflist(qf_list)
	vim.cmd("copen")
end

vim.api.nvim_create_user_command("ListBuffers", list_buffers_in_quickfix, {})
vim.keymap.set("n", "<leader>lb", ":ListBuffers<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>lc", ":cclose<CR>", { noremap = true, silent = true })

-- keep cursor in middle when cycling through search results
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- keep paste source after pasting
vim.keymap.set("n", "<leader>p", '"_dP')

-- yank into system register for pasting across apps
vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>y", '"+y')
