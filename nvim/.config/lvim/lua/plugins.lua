-- https://dev.to/delphinus35/dont-use-dependencies-in-lazynvim-4bk0

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
	local out = vim.fn.system({
		'git', 'clone', '--filter=blob:none', '--branch=stable',
		'https://github.com/folke/lazy.nvim.git', lazypath,
	})
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({ { 'Failed to clone lazy.nvim:' .. out .. '\n', 'ErrorMsg' } }, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

local default_plugins = {
	{ 'nvim-lua/plenary.nvim', lazy = true },
	{ 'itchyny/vim-qfedit',    lazy = true },
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
}

local plugins = { {} }

return {
	---@param plugin table
	add = function(plugin)
		table.insert(plugins, plugin)
	end,

	setup = function(...)
		local all_plugins = vim.tbl_extend('keep', default_plugins, plugins, ...)
		-- P(all_plugins)

		require('lazy').setup {
			spec = vim.tbl_extend('keep', default_plugins, all_plugins, ...),
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
