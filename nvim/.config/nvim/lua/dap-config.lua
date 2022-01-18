local M = {}

function M.config()
	require('dap-go').setup()
	require('keys').dap()
end

return M
