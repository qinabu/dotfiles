local M = {}

local function k(mode)
	return function(...)
		vim.api.nvim_set_keymap(mode, ...)
	end
end

local nkey, ikey, ckey, vkey, okey = k('n'), k('i'), k('c'), k('v'), k('o')

local NS = { noremap = true, silent = true }
local N = { noremap = true }

function M.bootstrap()
	vim.g.mapleader=" "
	vim.api.nvim_set_keymap('', '<space>', '<nop>', NS)

	-- Vim
	nkey('<leader>q', ':qall<cr>', N)
	nkey('<leader>Q', ':qall!<cr>', N)

	nkey('<leader><esc>', ':quit<cr>', N)

	-- nkey('<leader><esc>b', ':bdelete<cr>', N)
	-- nkey('<leader><esc>B', ':bdelete!<cr>', N)

	nkey('<leader><leader>,', ':edit $MYVIMRC<CR>', NS)
	nkey('<leader><leader>.', ':call chdir(expand("%:p:h")) | pwd<CR>', NS)

	-- Navigation
	nkey('<leader>w', '<c-w>', N) -- Window modification prefix
	nkey('<leader>w?', ':help CTRL-W<cr>', N) -- Window modification prefix

	nkey('<leader>h', '<c-w><c-h>', NS)
	nkey('<leader>l', '<c-w><c-l>', NS)
	nkey('<leader>j', '<c-w><c-j>', NS)
	nkey('<leader>k', '<c-w><c-k>', NS)

	nkey('<ScrollWheelUp>', '<c-y>', NS)
	nkey('<ScrollWheelDown>', '<c-e>', NS)

	nkey('<leader>.', ':cnext<cr>', NS)
	nkey('<leader>,', ':cprevious<cr>', NS)
	-- nkey('.', ':cnext<cr>', NS)
	-- nkey(',', ':cprevious<cr>', NS)
	nkey('<leader>d', ':NvimTreeFindFileToggle<cr>', NS)

	-- Options
	nkey('<leader>oO', ':only<cr>', NS)
	nkey('<leader>oo', ':MaximizerToggle<cr>', NS)

	nkey('<leader>on', ':setlocal number!<cr>', NS)
	nkey('<leader>oN', ':setlocal relativenumber!<cr>', NS)

	-- Command line
	nkey('<leader>;', ':', N)  -- Command line
	nkey("<leader>'", '@:', N) -- Repeat last command

	ckey('<c-a>', '<home>', N)
	ckey('<c-e>', '<end>', N)
	ckey('<c-b>', '<s-left>', N)
	ckey('<c-f>', '<s-right>', N)
	ckey('<c-d>', '<del>', N)

	-- Buffer
	nkey('<leader>s', ':write<cr>', N) -- Write changes
	nkey('<leader>S', ':wall<cr>', N) -- Write chages of all buffers

	-- Edit
	ikey('<esc>', '<esc>`^', NS) -- Keep cursor on the same positioni

	nkey('j', 'gj', NS)
	nkey('k', 'gk', NS)
	ikey('<down>', '<c-o>gj', NS)
	ikey('<up>', '<c-o>gk', NS)

	nkey('<leader>ee', '*Ncgn', NS)
	vkey('<leader>ee', "\"sy:let @/='\\V'.@s<CR>cgn", NS)

	vkey('K', ":move '<-2<cr>gv=gv", NS)
	vkey('J', ":move '>+1<cr>gv=gv", NS)

	vkey('p', '"_dP', NS)
	nkey('x', '"_x', NS)
	nkey('X', '"_X', NS)
	nkey('Q', 'q', N)

	-- Searching
	nkey('<leader>/', ":let @/=''<cr>", NS)

	-- Options toggling
	nkey('<leader>os', ':setlocal spell!<cr>', NS)

	nkey('<leader>ol', ':setlocal list!<cr>', NS)
	nkey('<leader>ow', ':setlocal nowrap! linebreak!<cr>', NS)


	-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
	-- mfussenegger/nvim-ts-hint-textobject
	-- text objects based on treesitter: for example: dm [then select a highlited letter]
	okey('m', ':<c-u>lua require("tsht").nodes()<cr>', NS)
	vkey('m', ':lua require("tsht").nodes()<cr>', NS)
	-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
end

function M.lsp()
	-- help / hint
	nkey('K', ':lua vim.lsp.buf.hover()<cr>', NS)
	nkey('<c-k>', ':lua vim.lsp.buf.signature_help()<cr>', NS)

	-- diagnostics
	nkey('gl', ':lua vim.diagnostic.open_float()<cr>', NS)
	nkey('gL', ':lua vim.diagnostic.setqflist()<cr>', NS)
	nkey('[d', ':lua vim.diagnostic.goto_prev()<cr>', NS)
	nkey(']d', ':lua vim.diagnostic.goto_next()<cr>', NS)

	-- go to
	nkey('gr', ':lua vim.lsp.buf.references()<cr>', NS)
	nkey('gD', ':lua vim.lsp.buf.declaration()<cr>', NS)
	nkey('gd', ':lua vim.lsp.buf.definition()<cr>', NS)
	nkey('gi', ':lua vim.lsp.buf.implementation()<cr>', NS)
	nkey('gy', ':lua vim.lsp.buf.type_definition()<cr>', NS)

	nkey('ghi',':lua vim.lsp.buf.incoming_calls()<cr>', NS)
	nkey('gho',':lua vim.lsp.buf.outgoing_calls()<cr>', NS)

	-- edit actions
	nkey('<leader>ea', ':lua vim.lsp.buf.code_action()<cr>', NS)
	nkey('<leader>er', ':lua vim.lsp.buf.rename()<cr>', NS)
	nkey('<leader>ef', ':lua vim.lsp.buf.formatting()<cr>', NS)

	-- range_code_action
	-- range_formatting

	vim.cmd[[
	autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()
	autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
	autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references(); vim.lsp.buf.document_highlight()
	]]

	-- workspace / sources directories
	-- nkey('<leader>wa', ':lua vim.lsp.buf.add_workspace_folder()<cr>', NS)
	-- nkey('<leader>wr', ':lua vim.lsp.buf.remove_workspace_folder()<cr>', NS)
	-- nkey('<leader>wl', ':lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>', NS)

end

return M

