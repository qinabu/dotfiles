local M = {}

function M.bootstrap()
	-- Basic
	vim.opt.clipboard = "unnamedplus"
	vim.opt.paste = false

	vim.opt.encoding = "utf-8"
	vim.opt.spelllang = "en_us,ru_yo"
	vim.opt.maxmempattern = 5000

	vim.opt.path:append("**")
	vim.opt.backupdir = "/tmp/nvim/,."
	vim.opt.writebackup = false
	vim.opt.directory = "/tmp/nvim/,."
	vim.opt.swapfile = false
	vim.opt.undodir = "/tmp/nvim/"
	vim.opt.undofile = true

	vim.opt.wildmenu = true
	vim.opt.wildmode = "full"

	-- Edit
	vim.opt.autoindent = true
	vim.opt.backspace = "indent,eol,start"
	vim.opt.completeopt = "menuone,noinsert,noselect,preview"
	vim.opt.formatoptions = "tcqrn1" -- t:textwidth, c:textwith comments, q:comments, r:auto indent, n:lists, 1:don't break one-letter word.

	-- expandtab = true
	vim.opt.smarttab = true
	vim.opt.tabstop = 8
	vim.opt.shiftwidth = 8 -- << >>

	-- showmatch = true
	-- matchtime = 10
	vim.opt.virtualedit = "block"
	vim.opt.whichwrap = "b,s,<,>"
	vim.opt.matchpairs:append("<:>")

	vim.opt.spell = false

	-- UI
	vim.opt.fillchars = 'vert: '
	-- vim.opt.background = 'dark'
	vim.opt.termguicolors = true
	vim.opt.mouse = 'a'
	vim.opt.laststatus = 2 -- status line
	vim.opt.scrolloff = 2 -- offset lines
	vim.opt.wrap = false

	-- vim.opt.signcolumn = 'number'
	vim.opt.signcolumn = 'yes:2'
	vim.opt.numberwidth = 3

	vim.opt.number = false
	vim.opt.relativenumber = false

	vim.opt.errorbells = true
	vim.opt.visualbell = true

	vim.opt.hlsearch = true
	vim.opt.incsearch = true
	vim.opt.ignorecase = true
	vim.opt.smartcase = true

	vim.opt.splitbelow = true
	vim.opt.splitright = true

	vim.opt.updatetime = 100
	vim.opt.timeoutlen = 2000
	vim.opt.ttimeoutlen = 10

	vim.opt.listchars = "tab:  ,space: ,eol: "
	vim.opt.list = true

	vim.diagnostic.config {
		['float'] = true,
		['severity_sort'] = true,
	}
end

return M
