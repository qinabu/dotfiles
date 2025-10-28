require("lazy").load({
	plugins = {
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
			hi CursorLine guibg=#2f393d
			hi CursorLineNr guibg=#2f393d

			hi ExtraWhitespaceNormal ctermbg=red guibg=red
			hi link ExtraWhitespaceInsert DiffDelete
			hi link ExtraWhitespace ExtraWhitespaceNormal
			match ExtraWhitespace /\s\+$/
			autocmd InsertEnter * hi link ExtraWhitespace ExtraWhitespaceInsert
			autocmd InsertLeave * hi link ExtraWhitespace ExtraWhitespaceNormal
		]]
		end
	}
})
