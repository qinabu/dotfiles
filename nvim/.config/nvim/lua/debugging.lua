require('plugins').add {
	'mfussenegger/nvim-dap',
	dependencies = {
		'leoluz/nvim-dap-go',
		'theHamsta/nvim-dap-virtual-text',
		'rcarriga/nvim-dap-ui',
		'nvim-neotest/nvim-nio',
	},
	config = function()
		require('dap-go').setup({
			-- delve = {
			-- 	args = { '-tags=test,mockery' },
			-- 	build_flags = { '-tags=test,mockery' },
			-- }
		})
		require('nvim-dap-virtual-text').setup()
		require('dapui').setup()
	end,
}

require('plugins').add {
	'vim-test/vim-test',
	config = function()
		vim.cmd [[
		let g:test#strategy = 'neovim_sticky'
		let g:test#neovim_sticky#reopen_window = 1
		let test#go#options = '-tags=test,mockery'
		]]
	end
}

require('plugins').add {
	'andythigpen/nvim-coverage',
	opts = {
		summary = { min_coverage = 80.0 },
		lang = {
			go = { coverage_file = 'coverage.txt' },
		},
	},
}
