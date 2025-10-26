require "boot"
require "plugins"
require "keymaps"

vim.loader.enable()
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
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter' }, {
	pattern = '*',
	callback = function()
		local m = vim.fn.mode()
		if m ~= 'c' and m ~= 'r' and m ~= 'r?' and m ~= '!' and vim.fn.mode() ~= 't' and vim.fn.getcmdwintype() == '' then
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
vim.opt.path:append('**')

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

local function toggler(alt, getter, setter)
	local buf = alt
	return function()
		local cur = getter()
		setter(buf)
		buf = cur
	end
end

vim.opt.list = true
vim.opt.listchars = 'eol: ,space: ,lead: ,trail:·,nbsp: ,tab:  ,multispace: ,leadmultispace: ,'
_G.my_toggle_listchars = toggler(
	'eol: ,space: ,lead:┊,trail:·,nbsp:◇,tab:❭ ,multispace:···•,leadmultispace:┊ ,',
	function() return vim.opt.listchars end,
	function(v) vim.opt.listchars = v end
)

vim.diagnostic.config({
	float = { border = 'rounded' },
	virtual_text = false,
	severity_sort = true,
})

function M.lazy()
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
	if not (vim.uv or vim.loop).fs_stat(lazypath) then
		local out = vim.fn.system({
			"git", "clone",
			"--depth=1",
			"--filter=blob:none",
			"--branch=stable",
			"https://github.com/folke/lazy.nvim.git",
			lazypath,
		})
		if vim.v.shell_error ~= 0 then
			vim.api.nvim_echo({
				{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
				{ out,                            "WarningMsg" },
				{ "\nPress any key to exit..." },
			}, true, {})
			vim.fn.getchar()
			os.exit(1)
		end
	end
	vim.opt.rtp:prepend(lazypath)
end

local default_plugins = {
	{ 'nvim-lua/plenary.nvim' }
}

require("lazy").setup({
	spec = vim.tbl_extend("force", default_plugins, {}),
	ui = {
		size = {
			width = 0.95,
			height = 0.9,
		},
		icons = {
			lazy = "",
			cmd = "⌘",
			plugin = "⌘",
			start = "⌘",
			source = "⌘",
			ft = "⌘",
			event = "⌘",
		}
	},
})
