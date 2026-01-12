require('plugins').add {
	'sainnhe/everforest',
	config = function()
		-- -- vim.g.everforest_diagnostic_text_highlight = 1
		vim.g.termguicolors = true
		vim.g.everforest_transparent_background = 1
		vim.g.everforest_current_word = 'grey background'
		vim.g.everforest_enable_italic = 0
		vim.g.everforest_disable_italic_comment = 1
		vim.g.everforest_ui_contrast = 'high'

		-- vim.g.everforest_colors_override = {
		-- 	['red'] = { '#f7908b', '167' },
		-- }
		vim.cmd [[
			colorscheme everforest
			" hi! Visual ctermbg=238 guibg=#475258
			" hi! Visual term=bold,reverse cterm=bold,reverse gui=bold,reverse
			hi! Visual term=reverse cterm=reverse gui=reverse
			hi CurrentWord ctermbg=240 guibg=#424e57
			hi link BqfPreviewBorder FloatermBorder
			hi CursorLine guibg=#242b30
			hi CursorLineNr guibg=#242b30
			hi link TermCursor Visual

			hi ExtraWhitespaceNormal ctermbg=red guibg=red
			hi link ExtraWhitespaceInsert DiffDelete
			hi link ExtraWhitespace ExtraWhitespaceNormal
			match ExtraWhitespace /\s\+$/
			autocmd InsertEnter * hi link ExtraWhitespace ExtraWhitespaceInsert
			autocmd InsertLeave * hi link ExtraWhitespace ExtraWhitespaceNormal
		]]
	end
}

require('plugins').add {
	'nvim-lualine/lualine.nvim',
	opts = {
		options = {
			icons_enabled = false,
			theme = 'everforest',
			section_separators = { left = '▘', right = '▗' },
			component_separators = '',
			globalstatus = true,
		},
		sections = {
			lualine_a = {},
			lualine_b = { 'branch' },
			lualine_c = {
				{
					'filename',
					path = 1,
					shorting_target = 25,
					symbols = { modified = '*' }
				},
				'%l:%c|%v',
				'progress',
				'%S',
			},
			lualine_x = {
				'searchcount',
				{
					'diagnostics',
					diagnostics_color = {
						error = 'DiagnosticSignError',
						warn  = 'DiagnosticSignWarn',
						info  = 'DiagnosticSignInfo',
						hint  = 'DiagnosticSignHint',
					},
				},
				'diff',
			},
			lualine_y = {
				'filesize',
				{
					'lsp_status',
					show_name = false,
					icon = '',
					symbols = {
						spinner = { '░', '▓' },
						done = '',
						separator = '',
					},
				}
			},
			lualine_z = {},
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = { 'filename' },
			lualine_c = { '%l' },
			lualine_x = {},
			lualine_y = {},
			lualine_z = {}
		},
		extensions = { 'quickfix' },
	}
}
