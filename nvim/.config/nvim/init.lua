-- ./lua/configs.lua
-- ./lua/options.lua
-- ./lua/keys.lua
-- ./lua/lsp-config.lua

require('configs').bootstrap()
require('options').bootstrap()
require('keys').bootstrap()

local packer_installed = require('configs').packer_install()
local function unpackPacker(use)
	use { 'wbthomason/packer.nvim', opt = false }

	-- [[ UI ]] --
	use { 'sainnhe/everforest', config = 'require("configs").everforest()' }
	use { 'folke/zen-mode.nvim', config = 'require("configs").zen_mode()' }
	use { 'szw/vim-maximizer' } -- Window size toggler :MaximizerToggle
	use { 'simeji/winresizer', config = 'require("keys").winresizer()' }
	use { 'nvim-lualine/lualine.nvim',
		requires = {
			{ 'stevearc/aerial.nvim' },
			{ 'nvim-lua/lsp-status.nvim' }, -- TODO: diff colors
		},
		config = 'require("configs").lualine()',
	}
	use { 'kyazdani42/nvim-tree.lua',
		requires = { { 'nyngwang/NeoRoot.lua' } },
		config = 'require("configs").nvim_tree()' }
	use { 'nvim-telescope/telescope.nvim',
		requires = {
			{ 'nvim-lua/plenary.nvim' },
			{ 'nvim-telescope/telescope-fzf-native.nvim' },
			{ 'nvim-telescope/telescope-file-browser.nvim' },
			{ 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
			{ 'nvim-telescope/telescope-ui-select.nvim' },
		},
		config = 'require("configs").telescope()',
	}

	-- [[ EDIT ]]
	use { 'justinmk/vim-sneak', config = 'require("configs").sneak()' } -- jumps
	use { 'dyng/ctrlsf.vim', config = 'require("configs").ctrlsf()' } -- find & replace
	use { 'tpope/vim-commentary' } -- comments
	use { 'tpope/vim-surround' }
	use { 'tpope/vim-repeat' }

	-- [[ LSP ]] --
	use { 'neovim/nvim-lspconfig',
		requires = {
			{ 'hrsh7th/cmp-nvim-lsp' },
			{ 'stevearc/aerial.nvim' },
			{ 'williamboman/nvim-lsp-installer' },
			{ 'ray-x/lsp_signature.nvim' },
			{ 'j-hui/fidget.nvim' },
		},
		config = 'require("lsp-config").config()',
	}

	-- [[ LINT ]]
	-- use { "tami5/lspsaga.nvim" }
	-- use { "folke/trouble.nvim" }
	-- use { 'mfussenegger/nvim-lint', config = 'require("configs").lint()' }

	-- [[ COMPLETION ]] --
	use { 'hrsh7th/nvim-cmp',
		requires = {
			{ 'hrsh7th/cmp-nvim-lsp' },
			{ 'hrsh7th/cmp-nvim-lua' },
			{ 'hrsh7th/cmp-buffer' },
			{ 'hrsh7th/cmp-path' },
			{ 'hrsh7th/cmp-cmdline' },
			{ 'hrsh7th/cmp-nvim-lsp-document-symbol' },

			{ 'L3MON4D3/LuaSnip' }, -- Snippets
			{ 'saadparwaiz1/cmp_luasnip' },
			{ 'honza/vim-snippets' }, -- Snippet collection
		},
		config = 'require("configs").cmp()'
	}

	-- [[ LANGUAGES ]] -- https://tree-sitter.github.io/tree-sitter/
	use { 'nvim-treesitter/nvim-treesitter',
		requires = {
			{ 'nvim-treesitter/playground' }, -- :TSPlaygroundToggle
			{ 'nvim-treesitter/nvim-treesitter-textobjects' },
			{ 'romgrk/nvim-treesitter-context' },
			{ 'mfussenegger/nvim-ts-hint-textobject' }, -- Scope selection by m
		},
		run = ':TSUpdate',
		config = 'require("configs").treesitter()',
	}

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
	use { 'sindrets/diffview.nvim',
		requires = {
			{ 'nvim-lua/plenary.nvim' },
		},
		config = 'require("configs").diffview()',
	}

	-- [[ DEBUG / TESTINGS ]]
	use { 'mfussenegger/nvim-dap',
		requires = {
			{ 'vim-test/vim-test' },
			{ 'nvim-treesitter/nvim-treesitter' },
			{ 'theHamsta/nvim-dap-virtual-text' },
			{ 'leoluz/nvim-dap-go' },
		},
		config = 'require("configs").dap()'
	}


	-- [[ NOTE TAKING ]]
	use { 'renerocksai/telekasten.nvim',
		requires = {
			{ 'renerocksai/calendar-vim' },
			{ 'nvim-telescope/telescope.nvim' },
		},
		config = 'require("configs").telekasten()',
	}

	use { 'justinmk/vim-dirvish' }


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
