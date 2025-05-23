return {
	"nvim-tree/nvim-tree.lua",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		local nvimtree = require("nvim-tree")

		-- recommended settings from nvim-tree documentation
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		nvimtree.setup({
			view = {
				adaptive_size = true,
				width = {
					min = 30, -- Set your desired minimum width here
					max = 80, -- Optional: Set a maximum width if desired
				},
				relativenumber = true,
			},
			-- change folder arrow icons
			renderer = {
				indent_markers = {
					enable = true,
				},
				icons = {
					glyphs = {
						git = {
							unstaged = "•",
							staged = "s",
							unmerged = "um",
							renamed = "r",
							deleted = "⁃",
							ignored = "◦",
							untracked = "⦾",
						},
						folder = {
							arrow_closed = "◆", -- arrow when folder is closed
							arrow_open = "◇", -- arrow when folder is open
						},
						modified = " ∘",
					},
				},
			},
			-- disable window_picker for
			-- explorer to work well with
			-- window splits
			actions = {
				open_file = {
					window_picker = {
						enable = false,
					},
				},
			},
			filters = {
				custom = { ".DS_Store" },
			},
			git = {
				ignore = false,
			},
			modified = {
				enable = true,
			},
		})

		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" }) -- toggle file explorer
		keymap.set(
			"n",
			"<leader>ef",
			"<cmd>NvimTreeFindFile<CR>zz<C-w>p",
			{ desc = "Toggle file explorer on current file" }
		) -- toggle file explorer on current file
		keymap.set("n", "<leader>er", "<cmd>NvimTreeFindFile<CR>zz", { desc = "Toggle file explorer on current file" }) -- toggle file explorer on current file
		keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>zz", { desc = "Collapse file explorer" }) -- collapse file explorer
		keymap.set("n", "<leader>eo", "<cmd>NvimTreeOpen<CR>zz", { desc = "Open file explorer" })
	end,
}
