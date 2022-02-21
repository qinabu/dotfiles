local packer_installed = require('configs').packer_install()

-- ./lua/configs.lua
-- ./lua/options.lua
-- ./lua/keys.lua

-- ./lua/lsp-config.lua
-- ./lua/telescope-config.lua
-- ./lua/cmp-config.lua
-- ./lua/testing.lua

local function unpackPacker(use)
	use { 'wbthomason/packer.nvim', opt = false }

	-- [[ UI ]] --
	-- Window size toggler :MaximizerToggle
	use { 'szw/vim-maximizer' }
	use { 'sainnhe/everforest', config = 'require("configs").everforest()' }
	use { 'nvim-lualine/lualine.nvim',
		requires = { { 'stevearc/aerial.nvim' } },
		config = 'require("configs").lualine()',
	}
	use { 'folke/zen-mode.nvim', config = 'require("configs").zen_mode()' }

	-- File manager
	use { 'kyazdani42/nvim-tree.lua', config = 'require("configs").nvim_tree()' }
	use { 'nvim-telescope/telescope.nvim',
		requires = {
			{ 'nvim-lua/plenary.nvim' },
			{ 'nvim-telescope/telescope-fzf-native.nvim' },
			{ 'nvim-telescope/telescope-file-browser.nvim' }
			-- {'nvim-telescope/telescope-frecency.nvim'},
			-- {'tami5/sqlite.lua'},
		},
		config = 'require("telescope-config").config()',
	}
	use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
	use { 'simeji/winresizer', config = 'require("keys").winresizer()' }

	-- TODO
	use { 'nvim-lua/lsp-status.nvim' }


	-- [[ EDIT ]]
	-- Fast jumps
	use { 'justinmk/vim-sneak', config = 'require("configs").sneak()' }
	use { 'dyng/ctrlsf.vim', config = 'require("configs").ctrlsf()' }
	-- Comment / uncomment
	use { 'tpope/vim-commentary' }
	use { 'tpope/vim-surround' }
	use { 'tpope/vim-repeat' }


	-- [[ LSP ]] --
	use { 'neovim/nvim-lspconfig' }
	-- LSP servers installer
	use { 'williamboman/nvim-lsp-installer',
		requires = {
			{ 'hrsh7th/cmp-nvim-lsp' },
			{ 'stevearc/aerial.nvim' },
		},
		config = 'require("lsp-config").config()',
	}


	-- [[ Lint ]]
	-- use { "tami5/lspsaga.nvim" }
	-- use { "folke/trouble.nvim" }


	-- [[ COMPLETION ]] --
	use { "hrsh7th/nvim-cmp",
		requires = {
			{ 'hrsh7th/cmp-nvim-lsp' },
			{ 'hrsh7th/cmp-nvim-lua' },
			{ 'hrsh7th/cmp-buffer' },
			{ 'hrsh7th/cmp-path' },
			{ 'hrsh7th/cmp-cmdline' },
			{ 'hrsh7th/cmp-nvim-lsp-document-symbol' },

			-- [[ Snippets ]] --
			{ 'L3MON4D3/LuaSnip' },
			{ 'saadparwaiz1/cmp_luasnip' },
		},
		config = 'require("cmp-config").config()'
	}


	-- [[ LANGUAGES ]] --
	-- https://tree-sitter.github.io/tree-sitter/
	use { 'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate',
		config = 'require("configs").nvim_treesitter()',
	}
	-- :TSPlaygroundToggle
	use { 'nvim-treesitter/playground' }
	-- Shows function name on the top
	use { 'romgrk/nvim-treesitter-context', config = 'require("keys").nvim_ts_hint_textobject()' }
	-- Region selection: m
	use { 'mfussenegger/nvim-ts-hint-textobject', config = 'require("configs").nvim_ts_hint_textobject()' }


	-- use {'nvim-treesitter/nvim-treesitter-textobjects'}
	-- use {'theHamsta/nvim-dap-virtual-text'}
	-- use { 'rafcamlet/nvim-luapad' }


	-- [[ VCS ]]
	use { 'tpope/vim-fugitive',
		requires = {
			{ 'nvim-lua/plenary.nvim' },
			{ 'ruifm/gitlinker.nvim' },
		},
		config = 'require("configs").fugitive()',
	}
	use { 'lewis6991/gitsigns.nvim',
		requires = { { 'nvim-lua/plenary.nvim' } },
		config = 'require("configs").gitsigns()',
	}

	-- [[ DEBUG / TESTINGS ]]
	use { 'mfussenegger/nvim-dap',
		requires = {
			{ 'vim-test/vim-test' },
			{ 'nvim-treesitter/nvim-treesitter' },
			{ 'theHamsta/nvim-dap-virtual-text' },
			{ 'leoluz/nvim-dap-go' },
		},
		config = 'require("testing").testing()'
	}


	-- [[ NOTE TAKING ]]
	use { 'renerocksai/telekasten.nvim',
		requires = {
			{ 'renerocksai/calendar-vim' },
			{ 'nvim-telescope/telescope.nvim' },
		},
		config = 'require("configs").telekasten()',
	}


	-- Sync the first lauch
	if packer_installed then
		require('packer').sync()
	end
end

require('packer').startup({
	unpackPacker,
	['config'] = {
		['log'] = {
			['level'] = 'error'
		},
	},
})

require('configs').bootstrap()
require('options').bootstrap()
require('keys').bootstrap()
--
