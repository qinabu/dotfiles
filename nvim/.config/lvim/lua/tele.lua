require('plugins').add {
	'nvim-telescope/telescope.nvim', tag = 'v0.1.9',
	dependencies = {
		'nvim-lua/plenary.nvim',
		'nvim-telescope/telescope-file-browser.nvim',
		'nvim-telescope/telescope-ui-select.nvim',
		'nvim-telescope/telescope-dap.nvim',
		{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
	},
	config = function()
		local telescope = require('telescope')
		local actions = require('telescope.actions')
		local fb_actions = require('telescope._extensions.file_browser.actions')
		telescope.setup {
			defaults = {
				layout_strategy = 'vertical',
				layout_config = {
					vertical = { height = 0.95, width = 0.95, prompt_position = 'top' },
					center = { width = 0.9999, height = 0.9999, prompt_position = 'top' },
					bottom_pane = { height = 0.9999, width = 0.9999 },
				},
				sorting_strategy = 'ascending',
				prompt_prefix = '',

				file_ignore_patterns = { '.git/' },
				hidden = true,
				mappings = {
					i = {
						['<C-/>'] = actions.which_key,
					},
					n = {
						['<C-/>'] = actions.which_key,
						['o'] = actions.select_default,
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
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = 'smart_case',
				},
				file_browser = {
					theme = 'ivy',
					hijack_netrw = true,
					layout_config = {
						height = 0.8,
					},
					mappings = {
						['i'] = {
							['<c-e>'] = fb_actions.toggle_browser,
							['<C-f>'] = false,
						},
						['n'] = {
							['f'] = false,
							['h'] = fb_actions.goto_parent_dir,
							['e'] = fb_actions.toggle_browser,
							['.'] = fb_actions.toggle_hidden,
							['l'] = actions.select_default,
							['o'] = actions.select_default,
						},
					},
					hidden = true,
					dir_icon = ' ',
					grouped = true,
					follow_symlinks = true,
					select_buffer = true,
					hide_parent_dir = true,
					prompt_path = true,
				},
				['ui-select'] = {
					require('telescope.themes').get_dropdown {}
				},
			},
		}

		telescope.load_extension('fzf')
		telescope.load_extension('file_browser')
		telescope.load_extension('ui-select')
	end,
}
