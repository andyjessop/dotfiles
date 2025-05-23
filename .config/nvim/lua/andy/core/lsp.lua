-- Centralised LSP settings for every server.   Neovim ≥ 0.11 required.
-- Mason-lspconfig v2 calls vim.lsp.enable() automatically after these configs
-- are defined; you do *not* need setup_handlers() any more.

-- 1 ───── Capabilities (add completion via cmp-nvim-lsp) ─────────────────────
local capabilities = vim.lsp.protocol.make_client_capabilities()
pcall(function()
	capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
end)

-- 2 ───── Diagnostics appearance ─────────────────────────────────────────────
local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

vim.diagnostic.config({
	float = { border = "rounded" },
	underline = true,
	signs = true,
	update_in_insert = false,
})

-- 3 ───── Buffer-local key-maps when a server attaches ───────────────────────
local function on_attach(_, bufnr)
	local map = function(mode, lhs, rhs, desc)
		vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc and ("LSP: " .. desc) or nil })
	end

	map("n", "gR", "<cmd>Telescope lsp_references<CR>", "references")
	map("n", "gh", vim.lsp.buf.hover, "hover (intellisense)")
	map("n", "gD", vim.lsp.buf.declaration, "declaration")
	map("n", "gd", "<cmd>Telescope lsp_definitions<CR>", "definitions")
	map("n", "gi", "<cmd>Telescope lsp_implementations<CR>", "implementations")
	map("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", "type definitions")
	map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "code actions")
	map("n", "<leader>rn", vim.lsp.buf.rename, "rename symbol")
	map("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", "buffer diagnostics")
	map("n", "<leader>d", vim.diagnostic.open_float, "line diagnostics")
	map("n", "[d", vim.diagnostic.goto_prev, "prev diagnostic")
	map("n", "]d", vim.diagnostic.goto_next, "next diagnostic")
	map("n", "K", vim.lsp.buf.hover, "hover documentation")
	map("n", "<leader>rs", ":LspRestart<CR>", "restart LSP")
end

-- 4 ───── Per-server configurations ( vim.lsp.config ) ───────────────────────
local cfg = vim.lsp.config -- new helper in Neovim 0.11

-- Lua
cfg("lua_ls", {
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
			completion = { callSnippet = "Replace" },
			workspace = { checkThirdParty = false },
			runtime = { version = "LuaJIT" },
		},
	},
})

-- Rust (no custom settings needed for now)
cfg("rust_analyzer", {
	on_attach = on_attach,
	capabilities = capabilities,
})
--
-- TypeScript / JavaScript -----------------------------
cfg("ts_ls", { -- ← was “tsserver”
	on_attach = on_attach,
	capabilities = capabilities,
	init_options = { hostInfo = "neovim" },
	-- optional extra settings
	settings = {
		typescript = {
			inlayHints = { includeInlayParameterNameHints = "all" },
		},
		javascript = {
			inlayHints = { includeInlayParameterNameHints = "all" },
		},
	},
})

-- Add more servers here if desired, e.g.
-- cfg("tsserver", { on_attach = on_attach, capabilities = capabilities })

-- Nothing else is required: Mason automatically enables every installed
-- server as soon as its config exists.
