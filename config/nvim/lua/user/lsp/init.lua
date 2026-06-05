local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
	return
end

require("user.lsp.handlers").setup()
require("user.lsp.mason")
-- NOTE: user.lsp.null-ls is loaded by the none-ls.nvim plugin's own config
-- (see plugins.lua). Requiring it here too caused a circular load:
-- lspconfig -> user.lsp -> null-ls -> require("null-ls") triggers the
-- none-ls plugin -> its config requires user.lsp.null-ls again mid-load.
