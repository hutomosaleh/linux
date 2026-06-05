local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

configs.setup({
	-- Auto-install parsers silently when a file is opened (no startup warnings)
	auto_install = true,
	highlight = {
		enable = true,
		disable = { "css" },
	},
	indent = { enable = true, disable = { "python", "css" } },
})
