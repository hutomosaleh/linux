require("mason").setup({
	ui = {
		border = "none",
		icons = {
			package_installed = "◍",
			package_pending = "◍",
			package_uninstalled = "◍",
		},
	},
	log_level = vim.log.levels.INFO,
	max_concurrent_installers = 4,
})

require("mason-lspconfig").setup({
	-- Servers install automatically when you open a matching file (no startup warnings)
	automatic_installation = true,
	handlers = {
		function(server_name)
			local handlers = require("user.lsp.handlers")
			local opts = {
				on_attach = handlers.on_attach,
				capabilities = handlers.capabilities,
			}

			local has_custom, custom_opts = pcall(require, "user.lsp.settings." .. server_name)
			if has_custom then
				opts = vim.tbl_deep_extend("force", custom_opts, opts)
			end

			require("lspconfig")[server_name].setup(opts)
		end,
	},
})

-- Auto-install formatters used by null-ls (none-ls) so they're available silently.
-- black is installed separately via uv (see install.sh) since Mason's black
-- needs python3-venv, while uv is self-contained.
local ensure_tools = { "stylua", "prettier" }
local registry_ok, registry = pcall(require, "mason-registry")
if registry_ok then
	local function install_missing()
		for _, tool in ipairs(ensure_tools) do
			local ok, pkg = pcall(registry.get_package, tool)
			if ok and not pkg:is_installed() then
				pkg:install()
			end
		end
	end
	if registry.refresh then
		registry.refresh(install_missing)
	else
		install_missing()
	end
end
