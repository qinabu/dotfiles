-- disable the default keymaps
-- https://neovim.io/doc/user/lsp.html#_config
for _, bind in ipairs({ "grn", "gra", "gri", "grr", "grt" }) do
	pcall(vim.keymap.del, "n", bind)
end

local function map(mode, lhs, rhs, opt)
	local opts = { noremap = true, silent = true }
	if type(opt) == 'string' then opts['desc'] = opt end
	if type(opt) == 'table' then opts = opt end
	vim.keymap.set(mode, lhs, rhs, opts)
end

local function n(lhs, rhs, opt) map('n', lhs, rhs, opt) end
local function i(lhs, rhs, opt) map('i', lhs, rhs, opt) end
local function v(lhs, rhs, opt) map('v', lhs, rhs, opt) end


-- vim
map({}, '<space>', '<nop>')

n('<leader>q', ':qall<cr>', 'quit')
n('<leader>Q', ':qall!<cr>', 'quit!')

n('<leader>bq', ':bdelete<cr>', 'close buffer')
n('<leader>bQ', ':bdelete!<cr>', 'close buffer!')

n('<leader><leader>,', ':edit $MYVIMRC<CR>', 'edit config')
n('<leader><leader>.', ':call chdir(expand("%:p:h")) | pwd<CR>', 'cd .')


-- lang
map({ 'i', 'c' }, '<c-l>', '<c-^>', 'switch lang')
map('n', '<c-l>', 'i<c-^><esc>', 'switch lang') -- todo: collision c-l


-- navigation
n('<leader>w', '<c-w>', 'c-w')
n('<leader>w?', ':help CTRL-W<cr>', 'c-w help')
n('<leader>we', ':WinResizerStartResize<cr>', 'resize window')

n('<leader>tl', ':tabnext<cr>', 'tab next')
n('<leader>th', ':-tabnext<cr>', 'tab prev')
n('<leader>tq', ':tabclose<cr>', 'tab close')

n('<leader>h', '<c-w>h')
n('<leader>l', '<c-w>l')
n('<leader>j', '<c-w>j')
n('<leader>k', '<c-w>k')

n('<ScrollWheelUp>', '<c-y>')
n('<ScrollWheelDown>', '<c-e>')

n('<leader>p', '<c-^>', 'prev buffer')

n('<leader>c', function()
	if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
		vim.cmd('cclose')
	else
		vim.cmd('copen')
	end
end, 'quickfix')


-- options / toggles
n('<leader>oO', ':only<cr>', 'only window')
n('<leader>oo', ':MaximizerToggle!<cr>', 'maximizer') -- szw/vim-maximizer
n('<leader>on', ':set number!<cr>', 'numbers')
n('<leader>oN', ':set relativenumber!<cr>', 'relative numbers')
n('<leader>os', ':setlocal spell!<cr>', 'spell check')
n('<leader>ol', require("options").toggle_listchars, 'list chars')
n('<leader>ow', ':setlocal nowrap! linebreak!<cr>', 'wrap')
n('<leader>oc', function()
	vim.wo.colorcolumn = (vim.wo.colorcolumn == '' and "72,80,100,120" or '')
end, 'columns')
n('<leader>oC', ":setlocal <C-R>=&conceallevel ? 'conceallevel=0' : 'conceallevel=2'<CR><CR>", 'conceal level')
n('<leader>ot', function()
	vim.opt.tabstop = (vim.opt.tabstop:get() ~= 8 and 8 or 4)
end, 'tabstop width')


-- buffer
n('<leader>s', ':write<cr>', 'save')
n('<leader>S', ':wall<cr>', 'save all')
n('<leader><leader>s', ':noautocmd write<cr>', 'save as is')
n('<leader><leader>S', ':noautocmd wall<cr>', 'save all as is')
n('<leader>bd', ':bdelete<cr>', 'delete buffer')


-- command line
n('<leader>;', ':', 'command line')
n('<leader>l', 'q:', 'command history')
n("<leader>'", '@:', 'repeat last command')
n('<leader>1', ':!', 'exec command')
n('<leader>!', ':split term://', 'terminal command')

-- TODO: c_CTRL-F support
-- map('c', '<c-a>', '<home>')
-- map('c', '<c-d>', '<del>')
-- map('c', '<c-e>', '<end>')
-- map('c', '<c-f>', '<right>')
-- map('c', '<c-b>', '<left>')
-- map('c', '<c-b>', '<s-left>')
-- map('c', '<m-b>', '<s-left>')
-- map('c', '<c-f>', '<s-right>')
-- map('c', '<m-f>', '<s-right>')
--

-- edit
i('<esc>', '<esc>`^') -- keep cursor on the same positioni
i('<down>', '<c-o>gj')
i('<up>', '<c-o>gk')
map({ 'n', 'v' }, 'j', 'gj')
map({ 'n', 'v' }, 'k', 'gk')

n('<leader>ee', '*Ncgn', 'change current word')
v('<leader>ee', "\"sy:let @/='\\V'.@s<CR>cgn", 'change selected')
-- map('v', '<leader>er', '"hy:%s/<C-r>h//gc<left><left><left>', N) -- substitute command for selected
n('<leader>et', ':%s/\\s\\+$//e<cr>', 'remove trailing spaces')
v('<leader>et', ':s/\\s\\+$//e<cr>', 'remove trailing spaces')

v('K', ":move '<-2<cr>gv=gv", 'move up')
v('J', ":move '>+1<cr>gv=gv", 'move down')

-- overwrites
-- v('p', '"_dP') -- TODO: if selection at the end of line P should be replaced with p
v('p', '"_dp') -- TODO: if selection at the end of line P should be replaced with p
n('x', '"_x')
n('X', '"_X')
n('Q', 'q')

n('vv', 'V', 'linewise select')

n('<c-h>', '^', 'to the beginning of the line')
v('<c-h>', '^', 'to the beginning of the line')
n('<c-l>', '$', 'to the end of the line')
v('<c-l>', 'g_', 'to the end of the line')


-- search
n('<leader>/', ':noh<cr>', 'no highlight')
n('<c-j>', ':silent exe "norm *" | exe "nohl"<cr>', 'next the word')
n('<c-k>', ':silent exe "norm #" | exe "nohl"<cr>', 'prev the word')


-- lsp
n('K', function() vim.lsp.buf.hover({ border = 'rounded' }) end, 'symbol help')

-- diagnostics
n('gl', vim.diagnostic.open_float, 'diagnostic')
n('gL', vim.diagnostic.setqflist, 'diagnostic in quickfix')
n('[d', function() vim.diagnostic.jump({ count = -1, float = true }) end, 'diagnostic prep')
n(']d', function() vim.diagnostic.jump({ count = 1, float = true }) end, 'diagnostic next')

-- go to
n('gr', function() vim.lsp.buf.references({ includeDeclaration = false }) end, 'references')
n('gD', vim.lsp.buf.declaration, 'declaration')
n('gd', vim.lsp.buf.definition, 'definition')
n('gi', vim.lsp.buf.implementation, 'implementations')
n('gy', vim.lsp.buf.type_definition, 'type definition')

n('gI', vim.lsp.buf.incoming_calls, 'incoming calls')
n('gO', vim.lsp.buf.outgoing_calls, 'outgoint calls')

-- edit actions
n('<leader>ea', vim.lsp.buf.code_action, 'code action')
v('<leader>ea', vim.lsp.buf.code_action, 'code action')
n('<leader>er', vim.lsp.buf.rename, 'rename')
n('<leader>ef', vim.lsp.buf.format, 'format')
n('<leader>ec', function()
	vim.lsp.codelens.refresh();
	vim.lsp.codelens.run()
end, 'codelens')
