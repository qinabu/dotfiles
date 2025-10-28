-- leader
vim.g.mapleader = " "
vim.g.maplocalleader = "_"
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
-- TODO: lua
vim.cmd [[autocmd! BufEnter * if &ft == 'man' | set signcolumn=no | endif]]
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
-- vim.cmd [[autocmd! FocusGained,BufEnter * if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif]]
-- TODO: fix and make it like ^
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter' }, {
	pattern = '*',
	callback = function()
		local mode = vim.fn.mode()
		if mode ~= 'c' and mode ~= 'r' and mode ~= 'r?' and mode ~= '!' and vim.fn.mode() ~= 't' and vim.fn.getcmdwintype() == '' then
			vim.cmd('checktime')
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
vim.cmd [[ filetype plugin indent on ]]
vim.opt.tabstop = 8
vim.opt.smarttab = true
vim.opt.shiftwidth = 8
vim.opt.virtualedit = 'block'
vim.opt.whichwrap = 'b,s,<,>'
vim.opt.matchpairs:append('<:>')

-- rulers
vim.opt.list = true
vim.opt.listchars = 'eol: ,space: ,lead: ,trail:·,nbsp: ,tab:  ,multispace: ,leadmultispace: ,'
local alter_listchars = 'eol: ,space: ,lead:┊,trail:·,nbsp:◇,tab:❭ ,multispace:···•,leadmultispace:┊ ,'

return {
	toggle_listchars = require("helpers").toggler(
		alter_listchars,
		function() return vim.opt.listchars end,
		function(v) vim.opt.listchars = v end
	)
}
