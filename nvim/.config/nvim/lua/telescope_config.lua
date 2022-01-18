local M = {}

function M.config()
	require('telescope').setup{
		['layout_strategy'] = 'bottom_pane'
	}
	require('keys').telescope()
end

return M
