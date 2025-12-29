-- leader
vim.g.mapleader = ' '
vim.g.maplocalleader = '_'
vim.opt.timeoutlen = 500

-- clipboard
vim.opt.clipboard = 'unnamed'
vim.opt.paste = false

-- ui
vim.opt.shortmess:append('I') -- no intro message
vim.opt.shortmess:append('c') -- less verbose search
vim.opt.cmdheight = 1
vim.opt.termguicolors = true
vim.opt.mouse = 'nv'
vim.opt.cursorline = true
vim.opt.showmode = false
vim.opt.showcmd = true
vim.opt.showcmdloc = 'statusline'
vim.opt.fillchars = 'eob: '
vim.opt.scrolloff = 2  -- offset lines
vim.opt.laststatus = 3 -- status line
vim.opt.wrap = false
vim.opt.signcolumn = 'yes:3'
vim.api.nvim_create_autocmd('BufEnter', {
	desc = 'opt.lua: no signcolumn for man pages',
	pattern = '*',
	callback = function()
		if vim.bo.filetype == 'man' then
			vim.opt_local.signcolumn = 'no'
		end
	end,
})
vim.opt.numberwidth = 3
vim.opt.number = false
vim.opt.relativenumber = false
vim.opt.errorbells = false
vim.opt.visualbell = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.lsp.set_log_level('OFF')

-- language
vim.opt.encoding = 'utf-8'
vim.opt.spelllang = { 'en_us', 'ru_yo' } -- vim.cmd [[set spelllang=en_us,ru_yo]]
vim.opt.keymap = 'russian-jcukenmac'     -- <c-l> switch language
vim.opt.iminsert = 0
vim.opt.imsearch = 0
vim.opt.spell = false

-- search
vim.opt.maxmempattern = 5000 -- .* lenght
vim.opt.inccommand = 'nosplit'
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Update a buffer's contents on focus if it changed outside of Vim.
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter' }, {
	desc = 'opt.lua: check if any buffers were changed',
	pattern = '*',
	callback = function()
		if not vim.tbl_contains({ 'c', 'r', '!', 't' }, vim.fn.mode()) and vim.fn.getcmdwintype() == '' then
			vim.cmd.checktime()
		end
	end
})

-- do / undo
vim.opt.backupdir = '/tmp/nvim/,.'
vim.opt.writebackup = false
vim.opt.directory = '/tmp/nvim/,.'
vim.opt.swapfile = false
vim.opt.undodir = '/tmp/nvim/'
vim.opt.undofile = true
vim.opt.updatetime = 100

-- filepath
-- vim.opt.path:append('**')

-- command line
vim.opt.wildmenu = true
vim.opt.wildmode = 'full'

-- edit
vim.opt.autoindent = true
vim.opt.backspace = 'indent,eol,start'
vim.opt.completeopt = 'menu,menuone,noselect'
vim.opt.formatoptions = 'tcqrn1'

-- file types
vim.g.editorconfig = false
vim.cmd.filetype('plugin', 'indent', 'on')
vim.opt.tabstop = 8
vim.opt.smarttab = true
vim.opt.shiftwidth = 8
vim.opt.virtualedit = 'block'
vim.opt.whichwrap = 'b,s,<,>'
vim.opt.matchpairs:append('<:>')

-- rulers
-- vim.opt.winborder = 'single'
vim.opt.list = true
vim.opt.listchars = 'eol: ,space: ,lead: ,trail:·,nbsp: ,tab:  ,multispace: ,leadmultispace: ,'
local alter_listchars = 'eol: ,space: ,lead:┊,trail:·,nbsp:◇,tab:❭ ,multispace:···•,leadmultispace:┊ ,'


---@param ... any
---@return any
function P(...)
	local objects = {}
	for i = 1, select('#', ...) do
		local v = select(i, ...)
		table.insert(objects, vim.inspect(v))
	end

	print(table.concat(objects, '\n'))
	return ...
end

---@param alt any
---@param getter function
---@param setter function
---@return function
function Toggler(alt, getter, setter)
	local buf = alt
	return function()
		local cur = getter()
		setter(buf)
		buf = cur
	end
end

return {
	toggle_listchars = Toggler(
		alter_listchars,
		function() return vim.opt.listchars end,
		function(v) vim.opt.listchars = v end
	)
}
