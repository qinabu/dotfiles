local packer_installed = require('configs').packer_install()

require('configs').bootstrap() -- ./lua/configs.lua
require('options').bootstrap() -- ./lua/options.lua
require('keys').bootstrap()    -- ./lua/keys.lua

-- ./lua/lsp-config.lua
-- ./lua/telescope-config.lua
-- ./lua/cmp-config.lua
-- ./lua/dap-config.lua
require('packer').startup({function(use)
	use {'wbthomason/packer.nvim', opt = false }


	-- [[ UI ]] --
	-- Window size toggler :MaximizerToggle
	use {'szw/vim-maximizer'}
	-- use {'baskerville/bubblegum', config = function()
	-- 	vim.g.colors_name = 'bubblegum-256-dark'
	-- end}
	-- use {'junegunn/seoul256.vim',
	-- 	config = 'require("configs").seoul256()',
	-- }
	-- Gruvbit colorscheme based on gruvbox
	use {'habamax/vim-gruvbit',
		-- config = 'require("configs").gruvbit()',
	}
	use {'sainnhe/everforest',
		config = 'require("configs").everforest()'
	}

	-- File manager
	use {'kyazdani42/nvim-tree.lua',
		config = 'require("configs").nvim_tree()',
	}
	use {'nvim-telescope/telescope.nvim',
		requires = {
			{'nvim-lua/plenary.nvim'},
			{'nvim-telescope/telescope-fzf-native.nvim'},
			{'nvim-telescope/telescope-file-browser.nvim'}
			-- {'nvim-telescope/telescope-frecency.nvim'},
			-- {'tami5/sqlite.lua'},
		},
		config = 'require("telescope-config").config()',
	}
	use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

	use {'simeji/winresizer',
		config = 'require("keys").winresizer()'
	}

	-- TODO
	use {'nvim-lua/lsp-status.nvim'}


	-- [[ Edit ]]
	-- Fast jumps
	use {'justinmk/vim-sneak',
		config = 'require("configs").sneak()',
	}
	use {'dyng/ctrlsf.vim',
		config = 'require("configs").ctrlsf()',
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
	use {'romgrk/nvim-treesitter-context',
		config = 'require("keys").nvim_ts_hint_textobject()',
	}
	-- Region selection: m
	use {'mfussenegger/nvim-ts-hint-textobject',
		config = 'require("configs").nvim_ts_hint_textobject()',
	}


	-- use {'nvim-treesitter/nvim-treesitter-textobjects'}
	-- use {'theHamsta/nvim-dap-virtual-text'}
	use {'rafcamlet/nvim-luapad'}


	-- [[ VCS ]]
	use {'tpope/vim-fugitive',
		config = 'require("keys").fugitive()',
	}
	use {'lewis6991/gitsigns.nvim',
		requires = { {'nvim-lua/plenary.nvim'} },
		config = function () require('gitsigns').setup({
			current_line_blame = true,
			keymaps = {
				-- Default keymap options
				noremap = true,

				['n ]h'] = { expr = true, "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'"},
				['n [h'] = { expr = true, "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'"},

				['n ghs'] = '<cmd>Gitsigns stage_hunk<CR>',
				['v ghs'] = ':Gitsigns stage_hunk<CR>',
				['n ghr'] = '<cmd>Gitsigns reset_hunk<CR>',
          			['v ghr'] = ':Gitsigns reset_hunk<CR>',
				['n ghu'] = '<cmd>Gitsigns undo_stage_hunk<CR>',

				['n ghS'] = '<cmd>Gitsigns stage_buffer<CR>',
				['n ghU'] = '<cmd>Gitsigns reset_buffer_index<CR>',
				['n ghR'] = '<cmd>Gitsigns reset_buffer<CR>',

				['n ghp'] = '<cmd>Gitsigns preview_hunk<CR>',
				['n ghb'] = '<cmd>lua require"gitsigns".blame_line{full=true}<CR>',

				-- Text objects
				['o ih'] = ':<C-U>Gitsigns select_hunk<CR>',
				['x ih'] = ':<C-U>Gitsigns select_hunk<CR>'
			},
		}) end

	}

	-- [[ DAP ]]
	use {'mfussenegger/nvim-dap',
		requires = { {'leoluz/nvim-dap-go'} },
		config = 'require("dap-config").config()'
	}



	-- Sync the first lauch
	if packer_installed then
		require('packer').sync()
	end
end,
['config'] = { ['log'] = { ['level'] = 'warn' } }
})

