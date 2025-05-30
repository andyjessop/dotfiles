return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile", "BufEnter" },
	config = function()
		local conform = require("conform")

		-- Global variable to store the current formatter
		vim.g.current_formatter = "None"

		local formatters_by_ft = {
			javascript = { "prettier", "biome", "deno_fmt" },
			typescript = { "prettier", "biome", "deno_fmt" },
			javascriptreact = { "prettier", "biome", "deno_fmt" },
			typescriptreact = { "prettier", "biome", "deno_fmt" },
			-- For other file types, keep using Prettier as before
			svelte = { "prettier" },
			css = { "prettier" },
			html = { "prettier" },
			json = { "prettier", "biome" },
			yaml = { "prettier" },
			markdown = { "prettier" },
			graphql = { "prettier" },
			liquid = { "prettier" },
			lua = { "stylua" },
			python = { "isort", "black" },
		}

		conform.setup({
			formatters_by_ft = formatters_by_ft,
		})

		-- Function to find the first config file by walking up the directory tree
		local function find_first_config()
			local current_dir = vim.fn.expand("%:p:h")
			local home_dir = vim.fn.expand("$HOME")

			local config_files = {
				prettier = { ".prettierrc", ".prettierrc.json", ".prettierrc.js" },
				biome = { "biome.json" },
				deno = { "deno.json", "deno.jsonc" },
			}

			while current_dir ~= home_dir and current_dir ~= "/" do
				for formatter, patterns in pairs(config_files) do
					for _, pattern in ipairs(patterns) do
						local config_file = current_dir .. "/" .. pattern
						if vim.fn.filereadable(config_file) == 1 then
							return formatter
						end
					end
				end
				current_dir = vim.fn.fnamemodify(current_dir, ":h")
			end
			return nil
		end

		-- Function to determine the formatter based on config files and file type
		local function get_formatter()
			local filetype = vim.bo.filetype
			local available_formatters = formatters_by_ft[filetype] or {}
			local formatter = find_first_config()

			if formatter then
				if formatter == "prettier" and vim.tbl_contains(available_formatters, "prettier") then
					vim.g.current_formatter = "prettier"
					return { "prettier" }
				elseif formatter == "biome" and vim.tbl_contains(available_formatters, "biome") then
					vim.g.current_formatter = "biome"
					return { "biome" }
				elseif formatter == "deno" and vim.tbl_contains(available_formatters, "deno_fmt") then
					vim.g.current_formatter = "deno_fmt"
					return { "deno_fmt" }
				end
			end

			-- Default to the first available formatter for the file type, or prettier if none specified
			vim.g.current_formatter = available_formatters[1] or "prettier"
			return { vim.g.current_formatter }
		end

		-- Function to update the current formatter
		local function update_current_formatter()
			get_formatter()
		end

		-- Create autocmd for updating the formatter on buffer open
		vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufEnter" }, {
			callback = update_current_formatter,
		})

		-- Create autocmd for formatting on save
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*",
			callback = function(args)
				local formatters = get_formatter()
				conform.format({
					bufnr = args.buf,
					formatters = formatters,
					timeout_ms = 1000,
				})
			end,
		})

		-- Keymap for manual formatting
		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			local formatters = get_formatter()
			conform.format({
				formatters = formatters,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
