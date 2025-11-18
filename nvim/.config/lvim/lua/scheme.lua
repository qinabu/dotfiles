require("plugins").add {
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

		-- vim.cmd('colorscheme everforest')
		--
		-- vim.api.nvim_set_hl(0, 'Visual', { reverse = true })
		-- vim.api.nvim_set_hl(0, 'CurrentWord', { ctermbg = 240, bg = '#424e57' })
		-- vim.api.nvim_set_hl(0, 'BqfPreviewBorder', { link = 'FloatermBorder' })
		-- vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#2f393d' })
		-- vim.api.nvim_set_hl(0, 'CursorLineNr', { bg = '#2f393d' })
		--
		-- vim.api.nvim_set_hl(0, 'ExtraWhitespaceNormal', { ctermbg = 'red', bg = 'red' })
		-- vim.api.nvim_set_hl(0, 'ExtraWhitespaceInsert', { link = 'DiffDelete' })
		-- vim.api.nvim_set_hl(0, 'ExtraWhitespace', { link = 'ExtraWhitespaceNormal' })
		--
		-- local extra_whitespace_group = vim.api.nvim_create_augroup('ExtraWhitespaceGroup', { clear = true })
		--
		-- local function set_extra_whitespace_match(hl_group)
		-- 	vim.fn.matchdelete(vim.fn.match('ExtraWhitespace'))
		-- 	vim.fn.matchadd(hl_group or 'ExtraWhitespace', '\\s\\+$')
		-- end
		--
		-- set_extra_whitespace_match('ExtraWhitespaceNormal')
		--
		-- vim.api.nvim_create_autocmd('InsertEnter', {
		-- 	group = extra_whitespace_group,
		-- 	callback = function()
		-- 		vim.api.nvim_set_hl(0, 'ExtraWhitespace', { link = 'ExtraWhitespaceInsert' })
		-- 		set_extra_whitespace_match('ExtraWhitespaceInsert')
		-- 	end,
		-- 	desc = 'Highlight trailing whitespace in Insert mode',
		-- })
		--
		-- vim.api.nvim_create_autocmd('InsertLeave', {
		-- 	group = extra_whitespace_group,
		-- 	callback = function()
		-- 		vim.api.nvim_set_hl(0, 'ExtraWhitespace', { link = 'ExtraWhitespaceNormal' })
		-- 		set_extra_whitespace_match('ExtraWhitespaceNormal')
		-- 	end,
		-- 	desc = 'Highlight trailing whitespace in Normal mode',
		-- })
	end
}
