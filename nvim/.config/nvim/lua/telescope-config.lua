local M = {}

function M.config()
	local opts = {
		['defaults'] = {},
		['extensions'] = {
			['fzf'] = {
				['fuzzy'] = true, -- false will only do exact matching
				['override_generic_sorter'] = true, -- override the generic sorter
				['override_file_sorter'] = true, -- override the file sorter
				['case_mode'] = "smart_case", -- or "ignore_case" or "respect_case"
				-- the default case_mode is "smart_case"
			},
			['file_browser'] = {
				['theme'] = "ivy",
				['mappings'] = {
					["i"] = {
						['<c-n>'] = require('telescope.actions').results_scrolling_down,
						['<c-p>'] = require('telescope.actions').results_scrolling_up,
					},
					["n"] = {
						['<c-n>'] = require('telescope.actions').results_scrolling_down,
						['<c-p>'] = require('telescope.actions').results_scrolling_up,
					},
				},
				['dir_icon'] = '░',
				['grouped'] = true,
				['depth'] = 1,
			},
		},
		['layout_strategy'] = 'bottom_pane'
	}
	opts['defaults'] = vim.tbl_deep_extend('force', opts['defaults'], require('telescope.themes').get_ivy())

	require('telescope').setup(opts)
	require('telescope').load_extension('fzf')
	require('telescope').load_extension('file_browser')

	require('keys').telescope()
end

return M
