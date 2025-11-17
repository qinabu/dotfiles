require('plugins').add {
	'nvim-telescope/telescope.nvim', tag = '0.1.8',
	dependencies = {
		'nvim-lua/plenary.nvim',
		'nvim-telescope/telescope-file-browser.nvim',
		'nvim-telescope/telescope-ui-select.nvim',
		'nvim-telescope/telescope-dap.nvim',
		{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
	},
	config = function()
		local tscope = require('telescope')
		local actions = require('telescope.actions')
		local fb_actions = require('telescope._extensions.file_browser.actions')
		tscope.setup {
			defaults = {
				layout_strategy = 'vertical',
				layout_config = {
					vertical = { height = 0.95, width = 0.95, prompt_position = 'top' },
					center = { width = 0.9999, height = 0.9999, prompt_position = 'top' },
					bottom_pane = { height = 0.9999, width = 0.9999 },
				},
				sorting_strategy = 'ascending',
				prompt_prefix = '',
				-- path_display = 'truncate',

				file_ignore_patterns = { '.git/' },
				hidden = true,
				mappings = {
					i = {
						-- ['<c-l>'] = { '<cmd>:norm i<c-^><esc>', type = 'command' },
						-- <c-l> = '<c-^>',
						['<C-/>'] = actions.which_key,
					},
					n = {
						-- <c-l> = ':startinsert <c-^><esc>',
						['<C-/>'] = actions.which_key,
						['o'] = actions.select_default,
						-- <C-H> = actions.toggle_hidden,
					},
				},
			},
			pickers = {
				live_grep = {
					additional_args = function(_)
						return { '--hidden' }
					end
				},
			},
			extensions = {
				fzf = {
					fuzzy = true, -- false will only do exact matching
					override_generic_sorter = true, -- override the generic sorter
					override_file_sorter = true, -- override the file sorter
					case_mode = 'smart_case', -- or 'ignore_case' or 'respect_case'
					-- the default case_mode is 'smart_case'
				},
				file_browser = {
					theme = 'ivy',
					hijack_netrw = true,
					layout_config = {
						height = 0.8,
						-- vertical = {
						-- 	height = 70,
						-- }
					},
					mappings = {
						['i'] = {
							-- 	<c-n> = require('telescope.actions').results_scrolling_down,
							-- 	<c-p> = require('telescope.actions').results_scrolling_up,
							['<c-e>'] = fb_actions.toggle_browser,
							['<C-f>'] = false,
						},
						['n'] = {
							['f'] = false,
							['h'] = fb_actions.goto_parent_dir,
							['e'] = fb_actions.toggle_browser,
							['.'] = fb_actions.toggle_hidden,
							['l'] = actions.select_default,
						},
					},
					hidden = true,
					dir_icon = '▸',
					-- dir_icon = ' ',
					grouped = true,
					follow_symlinks = true,
					select_buffer = true,
					hide_parent_dir = true,
					prompt_path = true,
					-- depth = 1,
					-- folder_browser = {
					-- 	files = true,
					-- },
				},
				['ui-select'] = {
					require('telescope.themes').get_dropdown {}
				},
			},
		}

		tscope.load_extension('fzf')
		tscope.load_extension('file_browser')
		tscope.load_extension('ui-select')
	end,
}
