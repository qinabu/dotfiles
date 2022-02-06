local M = {}

local map = vim.api.nvim_set_keymap

local NS = { noremap = true, silent = true }
local N = { noremap = true }

function M.bootstrap()
	vim.g.mapleader=" "
	vim.api.nvim_set_keymap('', '<space>', '<nop>', NS)

	-- Vim
	map('n', '<leader>q', ':qall<cr>', N)
	map('n', '<leader>Q', ':qall!<cr>', N)

	map('n', '<leader><esc>', ':quit<cr>', N)

	-- map('n', '<leader><esc>b', ':bdelete<cr>', N)
	-- map('n', '<leader><esc>B', ':bdelete!<cr>', N)

	map('n', '<leader><leader>,', ':edit $MYVIMRC<CR>', NS)
	map('n', '<leader><leader>.', ':call chdir(expand("%:p:h")) | pwd<CR>', NS)

	-- Navigation
	map('n', '<leader>w', '<c-w>', N) -- Window modification prefix
	map('n', '<leader>w?', ':help CTRL-W<cr>', N) -- Window modification prefix

	map('n', '<leader>h', '<c-w><c-h>', NS)
	map('n', '<leader>l', '<c-w><c-l>', NS)
	map('n', '<leader>j', '<c-w><c-j>', NS)
	map('n', '<leader>k', '<c-w><c-k>', NS)

	map('n', '<ScrollWheelUp>', '<c-y>', NS)
	map('n', '<ScrollWheelDown>', '<c-e>', NS)

	map('n', '<leader>.', ':cnext<cr>', NS)
	map('n', '<leader>,', ':cprevious<cr>', NS)
	-- map('n', '.', ':cnext<cr>', NS)
	-- map('n', ',', ':cprevious<cr>', NS)
	map('n', '<leader>d', ':NvimTreeFindFileToggle<cr>', NS)

	-- Options
	map('n', '<leader>oO', ':only<cr>', NS)
	map('n', '<leader>oo', ':MaximizerToggle<cr>', NS)

	map('n', '<leader>on', ':setlocal number!<cr>', NS)
	map('n', '<leader>oN', ':setlocal relativenumber!<cr>', NS)

	-- Command line
	map('n', '<leader>;', ':', N)  -- Command line
	map('n', "<leader>'", '@:', N) -- Repeat last command

	map('c', '<c-a>', '<home>', N)
	map('c', '<c-d>', '<del>', N)
	map('c', '<c-e>', '<end>', N)
	map('c', '<c-f>', '<right>', N)
	map('c', '<c-b>', '<left>', N)
	map('c', '<c-b>', '<s-left>', N)
	map('c', '<m-b>', '<s-left>', N)
	map('c', '<c-f>', '<s-right>', N)
	map('c', '<m-f>', '<s-right>', N)

	-- Buffer
	map('n', '<leader>s', ':write<cr>', N) -- Write changes
	map('n', '<leader>S', ':wall<cr>', N) -- Write chages of all buffers

	-- Edit
	map('i', '<esc>', '<esc>`^', NS) -- Keep cursor on the same positioni

	map('n', 'j', 'gj', NS)
	map('n', 'k', 'gk', NS)
	map('i', '<down>', '<c-o>gj', NS)
	map('i', '<up>', '<c-o>gk', NS)

	map('n', '<leader>ee', '*Ncgn', NS)
	map('v', '<leader>ee', "\"sy:let @/='\\V'.@s<CR>cgn", NS)

	map('v', 'K', ":move '<-2<cr>gv=gv", NS)
	map('v', 'J', ":move '>+1<cr>gv=gv", NS)

	map('v', 'p', '"_dP', NS)
	map('n', 'x', '"_x', NS)
	map('n', 'X', '"_X', NS)
	map('n', 'Q', 'q', N)

	-- Searching
	map('n', '<leader>/', ":let @/=''<cr>", NS)

	-- Options toggling
	map('n', '<leader>os', ':setlocal spell!<cr>', NS)

	map('n', '<leader>ol', ':setlocal list!<cr>', NS)
	map('n', '<leader>ow', ':setlocal nowrap! linebreak!<cr>', NS)

	-- quicklist & loclist
	local close_lists = function ()
		local found = false
		for _, id in ipairs(vim.api.nvim_list_wins()) do
			local t = vim.fn.win_gettype(vim.fn.win_id2win(id))
			if t == 'quickfix' or t == 'loclist' then
				vim.api.nvim_win_close(id, false)
				found = true
			end
		end
		return found
	end

	_G.QuickFix_toggle = function ()
		if not close_lists() then
			vim.cmd[[copen]]
		end
	end
	_G.LocList_toggle = function ()
		if not close_lists() then
			local _, err = pcall(vim.cmd, [[lopen]])
			if err then
				print('loc list is empty')
			end
		end
	end

	map('n', '<leader>c', ':lua QuickFix_toggle()<cr>', NS)
	map('n', '<leader>C', ':lua LocList_toggle()<cr>', NS)
end

function M.nvim_ts_hint_textobject()
	-- mfussenegger/nvim-ts-hint-textobject
	map('o', 'm', ':<c-u>lua require("tsht").nodes()<cr>', NS)
	map('v', 'm', ':lua require("tsht").nodes()<cr>', NS)
end

function M.lsp()
	-- help / hint
	map('n', 'K', ':lua vim.lsp.buf.hover()<cr>', NS)
	map('n', '<c-k>', ':lua vim.lsp.buf.signature_help()<cr>', NS)

	-- diagnostics
	map('n', 'gl', ':lua vim.diagnostic.open_float()<cr>', NS)
	map('n', 'gL', ':lua vim.diagnostic.setqflist()<cr>', NS)
	map('n', '[d', ':lua vim.diagnostic.goto_prev()<cr>', NS)
	map('n', ']d', ':lua vim.diagnostic.goto_next()<cr>', NS)

	-- go to
	map('n', 'gr', ':lua vim.lsp.buf.references()<cr>', NS)
	map('n', 'gD', ':lua vim.lsp.buf.declaration()<cr>', NS)
	map('n', 'gd', ':lua vim.lsp.buf.definition()<cr>', NS)
	map('n', 'gi', ':lua vim.lsp.buf.implementation()<cr>', NS)
	map('n', 'gy', ':lua vim.lsp.buf.type_definition()<cr>', NS)

	map('n', 'ghi',':lua vim.lsp.buf.incoming_calls()<cr>', NS)
	map('n', 'gho',':lua vim.lsp.buf.outgoing_calls()<cr>', NS)

	-- edit actions
	map('n', '<leader>ea', ':lua vim.lsp.buf.code_action()<cr>', NS)
	map('n', '<leader>er', ':lua vim.lsp.buf.rename()<cr>', NS)
	map('n', '<leader>ef', ':lua vim.lsp.buf.formatting_sync()<cr>', NS)

	-- range_code_action
	-- range_formatting

	vim.cmd[[
	autocmd CursorHold  <buffer> lua pcall(vim.lsp.buf.document_highlight)
	autocmd CursorHoldI <buffer> lua pcall(vim.lsp.buf.document_highlight)
	autocmd CursorMoved <buffer> lua pcall(vim.lsp.buf.clear_references); pcall(vim.lsp.buf.document_highlight)
	]]

	-- workspace / sources directories
	-- map('n', '<leader>wa', ':lua vim.lsp.buf.add_workspace_folder()<cr>', NS)
	-- map('n', '<leader>wr', ':lua vim.lsp.buf.remove_workspace_folder()<cr>', NS)
	-- map('n', '<leader>wl', ':lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>', NS)

end

function M.telescope()
	map('n', '<leader>ft', ':Telescope<cr>', NS)
	map('n', '<leader>ff', ':Telescope find_files<cr>', NS)
	map('n', '<leader>fg', ':Telescope live_grep<cr>', NS)
	map('n', '<leader>fd', ':Telescope file_browser<cr>', NS)
end

function M.dap()
	-- map('n', '<leader>t', ':lua require("dap-go").debug_test()<cr>', NS)

	map('n', '<leader>tD', ':lua require("dap").run_last()<cr>', NS)
	map('n', '<leader>td', ':lua require("dap").continue()<cr>', NS)

	map('n', '<leader>]', ':lua require("dap").step_over()<cr>', NS)
	map('n', '<leader>}', ':lua require("dap").step_into()<cr>', NS)
	map('n', '<leader>[', ':lua require("dap").step_out()<cr>', NS)

	map('n', '<leader>tb', ':lua require("dap").toggle_breakpoint()<cr>', NS)
	map('n', '<leader>tB', ':lua require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))<cr>', NS)
	map('n', '<leader>tl', ':lua require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<cr>', NS)
	map('n', '<leader>tr', ':lua require("dap").repl.open()<cr>', NS)
end

function M.winresizer()
	vim.g.winresizer_start_key = '<c-w>W'
end

function M.ctrlsf()
	map('n', '<leader>fc', '<Plug>CtrlSFCwordExec', {})
	map('v', '<leader>fc', '<Plug>CtrlSFVwordExec', {})
	map('n', '<leader>fC', '<Plug>CtrlSFPrompt', {})
end

function M.fugitive()
	_G.Git_blame_toggle = function ()
		local found = false
		for _, id in ipairs(vim.api.nvim_list_wins()) do
			if vim.bo[vim.fn.winbufnr(id)].filetype == 'fugitiveblame' then
				vim.api.nvim_win_close(id, false)
				found = true
			end
		end
		if not found then
			vim.cmd[[:Git blame]]
			vim.cmd(vim.api.nvim_replace_termcodes('normal <c-w>p', true, true, true))
		end
	end

	map('n', '<leader>gg', ':Git', NS)
	map('n', '<leader>gb', ':Git blame<cr><c-w>p', NS)
	map('n', '<leader>gb', ':lua Git_blame_toggle()<cr>', NS)
	map('n', '<leader>gB', ':.GBrowse<cr>', NS)
	map('n', '<leader>gd', ':Git difftool<cr>', NS)
	map('n', '<leader>gD', ':Gvdiffsplit<cr>', NS)
	map('n', '<leader>gl', ':0Gclog<cr>', NS)
	map('n', '<leader>gL', ':Gclog<cr>', NS)
end

return M

