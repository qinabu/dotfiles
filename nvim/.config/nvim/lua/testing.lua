local M = {}

function M.testing()
	require("dap-go").setup()
	require("nvim-dap-virtual-text").setup()
	vim.g['test#strategy'] = 'neovim'

	require('keys').testing()
end

return M
