-- Plug-ins are loaded and configured by Lazy-nvim.
-- Mason v2 installs servers *and* enables them automatically.
return {

	-- ───────────────── Mason ────────────────
	{
		"williamboman/mason.nvim", -- still the canonical repo
		version = ">=2.0.0",
		build = ":MasonUpdate", -- update the registry after :Lazy sync
		opts = { ui = { icons = { installed = "✓", pending = "➜", uninstalled = "✗" } } },
	},

	-- Mason ↔ LSP bridge
	{
		"mason-org/mason-lspconfig.nvim",
		version = "^2.0.0",
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			ensure_installed = {
				"lua_ls",
				"rust_analyzer",
				"ts_ls", -- ← was “tsserver”
			},
			-- automatic_enable = true   (default)
		},
	},

	-- Extra binaries (formatters / linters / DAP / …)
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		version = ">=1.0.0",
		dependencies = { "williamboman/mason.nvim" },
		opts = {
			ensure_installed = {
				-- formatters
				"prettier",
				"biome",
				"stylua",
				"black",
				"isort",
				-- linters
				"pylint",
				"eslint_d",
			},
		},
	},

	-- ───────────────── LSP client ────────────
	{
		"neovim/nvim-lspconfig",
		version = ">=2.0.0",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", -- completion capabilities
			"nvim-telescope/telescope.nvim", -- picker used in mappings
			{ "antosha417/nvim-lsp-file-operations", config = true },
			{ "folke/neodev.nvim", opts = {} }, -- Lua runtimes for plugins
		},
		config = function()
			require("andy.core.lsp")
		end, -- central logic (see §2)
	},
}
