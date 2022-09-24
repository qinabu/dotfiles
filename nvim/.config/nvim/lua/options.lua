local M = {}

function M.bootstrap()
	-- Basic
	vim.opt.shm:append("I") -- blank :intro
	vim.o.clipboard = "unnamedplus"
	vim.o.paste = false
	vim.o.encoding = "utf-8"
	vim.cmd [[set spelllang=en_us,ru_yo]]
	vim.o.maxmempattern = 5000

	vim.o.keymap = "russian-jcukenmac" -- <c-l> for change language
	vim.o.iminsert = 0
	vim.o.imsearch = 0

	vim.o.autoread = true
	-- Update a buffer's contents on focus if it changed outside of Vim.
	vim.cmd [[autocmd! FocusGained,BufEnter * if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif]]

	vim.opt.path:append("**")
	vim.o.backupdir = "/tmp/nvim/,."
	vim.o.writebackup = false
	vim.o.directory = "/tmp/nvim/,."
	vim.o.swapfile = false
	vim.o.undodir = "/tmp/nvim/"
	vim.o.undofile = true

	vim.o.wildmenu = true
	vim.o.wildmode = "full"

	-- Edit
	vim.o.autoindent = true
	vim.o.backspace = "indent,eol,start"
	vim.o.completeopt = "menuone,noinsert,noselect,preview"
	vim.o.formatoptions = "tcqrn1" -- t:textwidth, c:textwith comments, q:comments, r:auto indent, n:lists, 1:don't break one-letter word.

	-- expandtab = true
	vim.o.smarttab = true
	vim.o.tabstop = 8
	vim.o.shiftwidth = 8 -- << >>

	-- showmatch = true
	-- matchtime = 10
	vim.o.virtualedit = "block"
	vim.o.whichwrap = "b,s,<,>"
	vim.opt.matchpairs:append("<:>")

	vim.o.spell = false

	-- UI
	vim.o.cursorline = true
	vim.o.showmode = false
	vim.o.showcmd = false
	-- vim.o.fillchars = 'vert:▞,horiz:▞,eob: '
	vim.o.fillchars = 'eob: '
	-- vim.o.background = 'dark'
	vim.o.termguicolors = true
	vim.o.mouse = 'a'
	vim.o.scrolloff = 2 -- offset lines
	vim.o.laststatus = 3 -- status line (one global)
	-- vim.cmd [[set laststatus=3]]
	vim.o.wrap = false

	-- vim.o.signcolumn = 'number'
	vim.o.signcolumn = 'yes:2'
	vim.o.numberwidth = 3

	vim.o.number = false
	vim.o.relativenumber = false

	vim.o.errorbells = true
	vim.o.visualbell = true

	vim.o.hlsearch = true
	vim.o.incsearch = true
	vim.o.ignorecase = true
	vim.o.smartcase = true

	vim.o.splitbelow = true
	vim.o.splitright = true

	vim.o.updatetime = 100
	vim.o.timeoutlen = 2000
	vim.o.ttimeoutlen = 10

	-- vim.o.listchars = "space: ,eol: ,tab:» ,trail:·,multispace:···•" -- ·-
	-- vim.o.list = false

	-- indent-blankline.nvim oriented
	vim.o.listchars = "space: ,eol: ,tab:  ,trail:·,multispace:···•" -- ·-
	vim.o.list = true

	vim.diagnostic.config {
		['float'] = true,
		['severity_sort'] = true,
	}
end

return M
