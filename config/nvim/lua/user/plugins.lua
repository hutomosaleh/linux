return {
	-- Colorschemes (all loaded eagerly so you can switch between them anytime)
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
	},
	{
		"lunarvim/darkplus.nvim",
		lazy = false,
		priority = 1000,
	},
	{
		"sainnhe/gruvbox-material",
		lazy = false,
		priority = 1000,
		config = function()
			-- Set gruvbox-material as the default colorscheme
			vim.g.gruvbox_material_background = "medium"
			vim.g.gruvbox_material_enable_italic = 1
		end,
	},

	-- Core library (used by many plugins)
	{ "nvim-lua/plenary.nvim", lazy = true },

	-- Icons (used by many UI plugins)
	{ "nvim-tree/nvim-web-devicons", lazy = true },

	-- Git
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("user.gitsigns")
		end,
	},

	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("user.telescope")
		end,
	},

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("user.treesitter")
		end,
	},

	-- LSP: Mason (language server installer)
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		build = ":MasonUpdate",
		config = function()
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
		end,
	},

	-- LSP: lspconfig
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			require("user.lsp")
		end,
	},

	-- LSP: mason-lspconfig bridge (loaded as dependency of nvim-lspconfig)
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = true,
		dependencies = { "williamboman/mason.nvim" },
	},

	-- LSP: none-ls (formatters/linters, community fork of null-ls)
	{
		"nvimtools/none-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("user.lsp.null-ls")
		end,
	},

	-- LSP: highlight other uses of word under cursor
	{
		"RRethy/vim-illuminate",
		event = { "BufReadPost", "BufNewFile" },
	},

	-- Rust
	{
		"mrcjkb/rustaceanvim",
		ft = "rust",
	},

	-- Completion: nvim-cmp + sources
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"saadparwaiz1/cmp_luasnip",
			"L3MON4D3/LuaSnip",
			"rafamadriz/friendly-snippets",
		},
		config = function()
			require("user.cmp")
		end,
	},
	{ "hrsh7th/cmp-buffer", lazy = true },
	{ "hrsh7th/cmp-path", lazy = true },
	{ "hrsh7th/cmp-nvim-lsp", lazy = true },
	{ "hrsh7th/cmp-nvim-lua", lazy = true },
	{ "saadparwaiz1/cmp_luasnip", lazy = true },
	{
		"L3MON4D3/LuaSnip",
		lazy = true,
		build = "make install_jsregexp",
	},
	{ "rafamadriz/friendly-snippets", lazy = true },

	-- Editor: autopairs
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("user.autopairs")
		end,
	},

	-- Editor: commenting
	{
		"numToStr/Comment.nvim",
		keys = { "gc", "gb" },
		dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
		config = function()
			require("user.comment")
		end,
	},
	{ "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },

	-- UI: file explorer (loaded eagerly so auto-open autocmd registers before VimEnter)
	{
		"nvim-tree/nvim-tree.lua",
		lazy = false,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("user.nvim-tree")
			-- Auto-open nvim-tree on startup (when no file argument given)
			vim.api.nvim_create_autocmd("VimEnter", {
				once = true,
				callback = function()
					if vim.fn.argc() == 0 then
						pcall(function()
							require("nvim-tree.api").tree.open()
						end)
					end
				end,
			})
		end,
	},

	-- UI: bufferline (tabs)
	{
		"akinsho/bufferline.nvim",
		event = "BufReadPost",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("user.bufferline")
		end,
	},

	-- UI: statusline
	{
		"nvim-lualine/lualine.nvim",
		event = "UIEnter",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("user.lualine")
		end,
	},

	-- UI: terminal
	-- Loaded on VeryLazy (not just cmd) so the _LAZYGIT_TOGGLE / _NODE_TOGGLE /
	-- etc. global functions used by the <leader>g and <leader>t keymaps exist.
	{
		"akinsho/toggleterm.nvim",
		event = "VeryLazy",
		cmd = { "ToggleTerm", "TermExec" },
		config = function()
			require("user.toggleterm")
		end,
	},

	-- UI: indent guides
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("user.indentline")
		end,
	},

	-- UI: dashboard (loaded eagerly so it registers before VimEnter)
	{
		"goolord/alpha-nvim",
		lazy = false,
		config = function()
			require("user.alpha")
		end,
	},

	-- UI: which-key
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		dependencies = { "echasnovski/mini.icons" },
		config = function()
			require("user.whichkey")
		end,
	},
	{
		"echasnovski/mini.icons",
		lazy = true,
		config = function()
			require("mini.icons").setup()
		end,
	},

	-- Project management
	{
		"ahmedkhalf/project.nvim",
		cmd = "ProjectRoot",
		config = function()
			require("user.project")
		end,
	},

	-- Markdown preview
	{
		"iamcco/markdown-preview.nvim",
		build = "cd app && npm install",
		ft = "markdown",
		cmd = { "MarkdownPreview", "MarkdownPreviewToggle", "MarkdownPreviewStop" },
	},
}
