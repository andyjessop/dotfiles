return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		-- Function to check for config files
		local function has_config(config_files)
			for _, file in ipairs(config_files) do
				if vim.fn.filereadable(vim.fn.getcwd() .. "/" .. file) == 1 then
					return true
				end
			end
			return false
		end

		-- Function to determine the appropriate linter
		local function get_linter()
			if has_config({ "biome.json" }) then
				return { "biomejs" }
			elseif has_config({ ".eslintrc", ".eslintrc.js", ".eslintrc.json", ".eslintrc.yaml", ".eslintrc.yml" }) then
				return { "eslint" }
			else
				return {} -- No linter if no config found
			end
		end

		-- Set up linters dynamically
		local function setup_linters()
			local js_linter = get_linter()
			lint.linters_by_ft = {
				javascript = js_linter,
				typescript = js_linter,
				javascriptreact = js_linter,
				typescriptreact = js_linter,
				python = { "pylint" },
			}
		end

		-- Initial setup
		setup_linters()

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				setup_linters() -- Reconfigure linters before linting
				lint.try_lint()
				vim.api.nvim__redraw({ flush = true })
			end,
		})

		vim.keymap.set("n", "<leader>L", function()
			setup_linters() -- Reconfigure linters before linting
			lint.try_lint()
			vim.api.nvim__redraw({ flush = true })
		end, { desc = "Trigger linting for current file" })
	end,
}
