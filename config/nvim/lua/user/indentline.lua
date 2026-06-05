local status_ok, ibl = pcall(require, "ibl")
if not status_ok then
	return
end

-- HACK: work-around so indent line doesn't show through colorcolumn
-- https://github.com/lukas-reineke/indent-blankline.nvim/issues/59
vim.wo.colorcolumn = "99999"

ibl.setup({
	indent = {
		char = "▏",
	},
	scope = {
		enabled = true,
		show_start = true,
		show_end = false,
	},
	exclude = {
		buftypes = { "terminal", "nofile" },
		filetypes = {
			"help",
			"startify",
			"dashboard",
			"packer",
			"neogitstatus",
			"NvimTree",
			"Trouble",
			"lazy",
			"alpha",
			"toggleterm",
		},
	},
	whitespace = {
		remove_blankline_trail = false,
	},
})
