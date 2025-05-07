return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		require("mason").setup({
			ui = { icons = { installed = "✓", pending = "➜", uninstalled = "✗" } },
		})
		require("mason-lspconfig").setup({
			ensure_installed = { "lua_ls", "rust_analyzer" }, -- only LSP servers
		})
		require("mason-tool-installer").setup({
			ensure_installed = {
				"prettier",
				"biome",
				"stylua", -- formatters
				"black",
				"isort",
				"pylint",
				"eslint_d", -- linters
			},
		})
	end,
}
