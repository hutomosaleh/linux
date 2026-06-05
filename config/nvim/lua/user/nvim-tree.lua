-- Disable netrw (nvim-tree replaces it)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
	return
end

nvim_tree.setup({
	update_focused_file = {
		enable = true,
		update_root = true,
	},
	renderer = {
		root_folder_modifier = ":t",
		icons = {
			glyphs = {
				default = "",
				symlink = "",
				folder = {
					arrow_open = "",
					arrow_closed = "",
					default = "",
					open = "",
					empty = "",
					empty_open = "",
					symlink = "",
					symlink_open = "",
				},
				git = {
					unstaged = "",
					staged = "S",
					unmerged = "",
					renamed = "➜",
					untracked = "U",
					deleted = "",
					ignored = "◌",
				},
			},
		},
	},
	diagnostics = {
		enable = true,
		show_on_dirs = true,
		icons = {
			hint = "󰌵",
			info = "",
			warning = "",
			error = "",
		},
	},
	view = {
		width = 30,
		side = "left",
		adaptive_size = true,
	},
	on_attach = function(bufnr)
		local api = require("nvim-tree.api")

		-- Default mappings
		api.config.mappings.default_on_attach(bufnr)

		-- Custom mappings
		local opts = { buffer = bufnr, noremap = true, silent = true }
		vim.keymap.set("n", "l", api.node.open.edit, opts)
		vim.keymap.set("n", "<CR>", api.node.open.edit, opts)
		vim.keymap.set("n", "o", api.node.open.edit, opts)
		vim.keymap.set("n", "h", api.node.navigate.parent_close, opts)
		vim.keymap.set("n", "v", api.node.open.vertical, opts)
	end,
})
