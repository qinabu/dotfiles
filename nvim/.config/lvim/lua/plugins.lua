-- https://dev.to/delphinus35/dont-use-dependencies-in-lazynvim-4bk0

local default_plugins = {
	{ 'nvim-lua/plenary.nvim' },

	-- editable quick fix list
	{ 'itchyny/vim-qfedit',   lazy = true },

	-- preview in quick fix list
	{
		'kevinhwang91/nvim-bqf',
		lazy = true,
		ft = 'qf',
		opts = {
			auto_enable = true,
			auto_resize_height = false,
			func_map = {
				pscrollup = '<c-u>',
				pscrolldown = '<c-d>',
			},
			preview = {
				show_title = true,
				-- border = 'none',
				winblend = 0,
			}
		}
	},

	-- find and replace
	{
		'dyng/ctrlsf.vim',
		config = function()
			vim.cmd [[
				let g:ctrlsf_position = 'bottom'
				let g:ctrlsf_preview_position = 'outside'
				let g:ctrlsf_winsize = '40%'
				let g:ctrlsf_auto_preview = 0
				let g:ctrlsf_auto_focus = {
				\ "at" : "done",
				\ "duration_less_than": 1000
				\ }
			]]
		end

	},

	-- curor hop
	{
		'smoka7/hop.nvim',
		opts = { keys = 'fjdkslaghrutyeiwo' }
	},

	-- git
	{
		'lewis6991/gitsigns.nvim',
		opts = {
			signs = {
				add          = { text = '+' },
				change       = { text = '~' },
				delete       = { text = '_' },
				topdelete    = { text = '-' },
				changedelete = { text = '~' },
				untracked    = { text = '+' },
			},
			signs_staged = {
				add          = { text = '+' },
				change       = { text = '~' },
				delete       = { text = '_' },
				topdelete    = { text = '-' },
				changedelete = { text = '~' },
				untracked    = { text = '+' },
			},
			signs_staged_enable = true,
			current_line_blame = false,
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
				delay = 1000,
				ignore_whitespace = false,
			},
			preview_config = { border = 'rounded' },
		},
	},

	-- git diff
	{
		'sindrets/diffview.nvim',
		lazy = true,
		opts = {
			use_icons = false,
			icons = {
				folder_open = "+",
				folder_closed = "-",
			},
			signs = {
				fold_open = "+",
				fold_closed = "-",
			},
		},
	},

	-- git link
	{
		'ruifm/gitlinker.nvim',
		opts = { mappings = nil },
	},

	-- markdown
	{
		'iamcco/markdown-preview.nvim',
		ft = { 'markdown' },
		build = function() vim.fn['mkdp#util#install']() end,
	},

	-- note taking
	{
		'renerocksai/telekasten.nvim',
		dependencies = { 'nvim-telescope/telescope.nvim' },
		config = function()
			local home = vim.fn.expand("~/Mind")
			require 'telekasten'.setup {
				home = home,
				plug_into_calendar = false,
				dailies = home .. '/' .. 'daily',
				weeklies = home .. '/' .. 'weekly',
				templates = home .. '/' .. 'templates',
				template_new_note = home .. '/templates/new_note.md',
				template_new_daily = home .. '/templates/daily.md',
				template_new_weekly = home .. '/templates/weekly.md',
			}
		end,
	},

	-- translate
	{
		'potamides/pantran.nvim',
		opts = {
			ui = {
				width_percentage = 0.95,
				height_percentage = 0.6,
			},
			default_engine = 'google',
			engines = {
				google = {
					default_target = 'ru',
					fallback = {
						default_target = 'ru'
					},
				},
			},
		},
	},

}

local added_plugins = {}

return {
	---@param plugin table
	add = function(plugin)
		table.insert(added_plugins, plugin)
	end,

	setup = function()
		local plugins = {}
		for _, v in ipairs(default_plugins) do table.insert(plugins, v) end
		for _, v in ipairs(added_plugins) do table.insert(plugins, v) end

		-- install
		local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
		if not vim.uv.fs_stat(lazypath) then
			local out = vim.fn.system({
				'git', 'clone', '--filter=blob:none', '--branch=stable',
				'https://github.com/folke/lazy.nvim.git', lazypath,
			})
			if vim.v.shell_error ~= 0 then
				vim.api.nvim_echo({ { 'Failed to clone lazy.nvim:' .. out .. '\n', 'ErrorMsg' } }, true,
					{})
				vim.fn.getchar()
				os.exit(1)
			end
		end
		vim.opt.rtp:prepend(lazypath)

		-- setup
		require('lazy').setup {
			spec = plugins,
			-- spec = vim.tbl_extend('force', default_plugins, plugins, ...),
			local_spec = false,
			ui = {
				size = { width = 0.95, height = 0.9 },
				icons = {
					lazy = '', cmd = '⌘', plugin = '⌘', start = '⌘',
					source = '⌘', ft = '⌘', event = '⌘',
				}
			},
		}
	end
}
