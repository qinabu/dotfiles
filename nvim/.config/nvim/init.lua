local packer_installed = require('configs').packer_install()

require('configs').bootstrap()
require('options').bootstrap()
require('keys').bootstrap()

require('packer').startup({function(use)
	use {'wbthomason/packer.nvim', opt = false }


	-- [[ UI ]] --
	-- Window size toggler :MaximizerToggle
	use {'szw/vim-maximizer'}
	-- Gruvbit colorscheme based on gruvbox
	use {'habamax/vim-gruvbit',
		config = 'require("configs").gruvbit()',
	}
	-- File manager
	use {'kyazdani42/nvim-tree.lua',
		config = 'require("configs").nvim_tree()',
	}

	-- TODO
	use {'nvim-lua/lsp-status.nvim'}


	-- [[ Edit ]]
	-- Fast jumps
	use {'justinmk/vim-sneak',
		config = 'require("configs").sneak()',
	}
	-- Comment / uncomment
	use {'tpope/vim-commentary'}


	-- [[ LSP ]] --
	use {'neovim/nvim-lspconfig'}
	-- LSP servers installer
	use {'williamboman/nvim-lsp-installer',
		requires = {
			{"hrsh7th/cmp-nvim-lsp"},
		},
		config = 'require("lsp-config").config()',
	}


	-- [[ Lint ]]
	-- use { "tami5/lspsaga.nvim" }
        -- use { "folke/trouble.nvim" }


	-- [[ Completion ]] --
 	use {"hrsh7th/nvim-cmp",
		requires = {
			{"hrsh7th/cmp-nvim-lsp"},
			{"hrsh7th/cmp-nvim-lua"},
			{"hrsh7th/cmp-buffer"},
			{"hrsh7th/cmp-path"},
			{"hrsh7th/cmp-cmdline" },
			{"hrsh7th/cmp-nvim-lsp-document-symbol"},

			-- [[ Snippets ]] --
			{'L3MON4D3/LuaSnip'},
			{'saadparwaiz1/cmp_luasnip'},
		},
		config = 'require("cmp-config").config()'
	}


	-- [[ Languages ]] --
	-- https://tree-sitter.github.io/tree-sitter/
	use {'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate',
		config = 'require("configs").nvim_treesitter()',
	}
	-- :TSPlaygroundToggle
	use {'nvim-treesitter/playground'}
	-- Shows function name on the top
	use {'romgrk/nvim-treesitter-context'}
	-- Region selection: m
	use {'mfussenegger/nvim-ts-hint-textobject',
		config = 'require("configs").nvim_ts_hint_textobject()',
	}


	-- use {'nvim-treesitter/nvim-treesitter-textobjects'}
	-- use {'theHamsta/nvim-dap-virtual-text'}
	use {'rafcamlet/nvim-luapad'}

	-- Sync the first lauch
	if packer_installed then
		require('packer').sync()
	end
end,
['config'] = { ['log'] = { ['level'] = 'warn' } }
})

