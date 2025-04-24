F = {}

function F.boot()
	F.functions()
	F.settings()
	F.plugins()
	F.keymaps()
end

function F.lazy_plugins()
	return {
		-- deps
		'nvim-lua/plenary.nvim',

		-- ui
		{
			'sainnhe/everforest', -- +
			init = function()
				vim.g.termguicolors = true
				vim.g.everforest_transparent_background = 1
				vim.g.everforest_current_word = 'grey background'
				vim.g.everforest_enable_italic = 0
				vim.g.everforest_disable_italic_comment = 1
				vim.g.everforest_ui_contrast = 'high'
			end,
			config = function()
				vim.cmd('colorscheme everforest')

				vim.api.nvim_set_hl(0, 'Visual', { reverse = true })
				vim.api.nvim_set_hl(0, 'CurrentWord', { ctermbg = 240, bg = '#424e57' })
				vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#2f393d' })
				vim.api.nvim_set_hl(0, 'CursorLineNr', { bg = '#2f393d' })
				vim.api.nvim_set_hl(0, 'ExtraWhitespaceNormal', { ctermbg = 'red', bg = 'red' })

				vim.api.nvim_set_hl(0, 'BqfPreviewBorder', { link = 'FloatermBorder' })
				vim.api.nvim_set_hl(0, 'ExtraWhitespaceInsert', { link = 'DiffDelete' })
				vim.api.nvim_set_hl(0, 'ExtraWhitespace', { link = 'ExtraWhitespaceNormal' })

				vim.fn.matchadd('ExtraWhitespace', [[\s\+$]])

				vim.api.nvim_create_autocmd(
					'InsertEnter', {
						pattern = '*',
						callback = function()
							vim.api.nvim_set_hl(0, 'ExtraWhitespace',
								{ link = 'ExtraWhitespaceInsert' })
						end,
					})

				vim.api.nvim_create_autocmd(
					'InsertLeave', {
						pattern = '*',
						callback = function()
							vim.api.nvim_set_hl(0, 'ExtraWhitespace',
								{ link = 'ExtraWhitespaceNormal' })
						end,
					})
			end,
		},
		{
			'szw/vim-maximizer',
			event = 'VeryLazy',
		},
		{
			'itchyny/vim-qfedit',
			event = 'VeryLazy',
		},
		{
			'folke/zen-mode.nvim', -- +
			event = 'VeryLazy',
			opts = {
				plugins = {
					gitsigns = { enabled = true },
					options = { laststatus = 0 },
					tmux = { enabled = true },
				},
			},
		},
		{
			'simeji/winresizer', -- +
			init = function()
				vim.g.winresizer_start_key = ''
				vim.g.winresizer_vert_resize = 5
				vim.g.winresizer_horiz_resize = 2
			end,
		},
		{
			'kevinhwang91/nvim-bqf', -- +
			ft = 'qf',
			opts = {
				auto_enable = true,
				auto_resize_height = false,
				func_map = {
					pscrollup = '<c-u>',
					pscrolldown = '<c-d>',
				},
				preview = {
					show_title = true,
					winblend = 0,
				},
			},
		},
		{
			'nvim-lualine/lualine.nvim',
			event = "VeryLazy",
			opts = {
				options = {
					icons_enabled = false,
					theme = 'everforest',
					section_separators = { left = '▘', right = '▗' },
					component_separators = '',
					globalstatus = true,
				},
				sections = {
					lualine_a = { function() return ' M ' end },
					lualine_b = { 'branch' },
					lualine_c = {
						{ 'filename', path = 1, shorting_target = 25, symbols = { modified = '*' } },
						'%l:%c|%v',
						'progress',
						'%S',
					},
					lualine_x = {
						'searchcount',
						{
							'diagnostics',
							diagnostics_color = {
								error = 'DiagnosticSignError',
								warn  = 'DiagnosticSignWarn',
								info  = 'DiagnosticSignInfo',
								hint  = 'DiagnosticSignHint',
							},
						},
						'diff',
					},
					-- todo
					-- ['lualine_y'] = { 'filesize', F.codecompanionLualine },
					lualine_z = {},
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = { 'filename' },
					lualine_c = { '%l' },
					lualine_x = {},
					lualine_y = {},
					lualine_z = {}
				},
				extensions = { 'quickfix' },
			},
		},
		{
			'norcalli/nvim-colorizer.lua',
			event = "VeryLazy",
			opts = { 'css', 'scss', 'html', 'yaml' }
		},
		{
			'notjedi/nvim-rooter.lua',
			opts = {
				rooter_patterns = { 'go.mod', '.git' },
				exclude_filetypes = { 'ctrlsf', 'git', 'fugitiveblame', '' },
				fallback_to_parent = true,
			}
		},

		-- todo
		-- {
		-- 	'nvim-telescope/telescope.nvim',
		-- 	branch = '0.1.x',
		-- 	dependencies = {
		-- 		'nvim-telescope/telescope-file-browser.nvim',
		-- 		'nvim-telescope/telescope-ui-select.nvim',
		-- 		'nvim-telescope/telescope-dap.nvim',
		-- 		{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
		-- 	},
		-- 	config = F.telescope,
		-- },

		-- edit
		{
			'phaazon/hop.nvim',
			opts = { keys = 'fjdkslaghrutyeiwo' }
		},
		{
			'dyng/ctrlsf.vim',
			init = function()
				vim.g.ctrlsf_default_root = 'cwd'
				vim.g.ctrlsf_context = '-B 3 -A 3'
				vim.g.ctrlsf_compact_winsize = '30%'
				vim.g.ctrlsf_winsize = '30%'
				vim.g.ctrlsf_populate_qflist = 1
			end
		},
		{
			'numToStr/Comment.nvim',
			event = "VeryLazy",
		},
		{
			"kylechui/nvim-surround",
			event = "VeryLazy",
		},

		-- todo
		-- LSP
		-- {
		-- 	'neovim/nvim-lspconfig',
		-- 	config = F.lspconfig,
		-- 	dependencies = {
		-- 		'williamboman/mason.nvim',
		-- 		'williamboman/mason-lspconfig.nvim',
		-- 		'folke/neodev.nvim', -- vim lua sdk
		-- 		'hrsh7th/nvim-cmp',
		-- 		'hrsh7th/cmp-nvim-lsp',
		-- 		'ray-x/lsp_signature.nvim',
		-- 		{ 'j-hui/fidget.nvim', ['tag'] = 'legacy' },
		-- 		"andythigpen/nvim-coverage",
		-- 	},
		-- },
		-- {
		-- 	"andythigpen/nvim-coverage",
		-- 	version = "*",
		-- 	config = function()
		-- 		require("coverage").setup({
		-- 			auto_reload = true,
		-- 		})
		-- 	end,
		-- },

		-- COMPLETION
		-- {
		-- 	'hrsh7th/nvim-cmp',
		-- 	config = F.cmp,
		-- 	dependencies = {
		-- 		'hrsh7th/cmp-nvim-lsp',
		-- 		'hrsh7th/cmp-nvim-lua',
		-- 		'hrsh7th/cmp-buffer',
		-- 		'hrsh7th/cmp-path',
		-- 		'hrsh7th/cmp-cmdline',
		-- 		'hrsh7th/cmp-nvim-lsp-document-symbol',
		--
		-- 		'L3MON4D3/LuaSnip', -- Snippets
		-- 		'saadparwaiz1/cmp_luasnip',
		-- 		'honza/vim-snippets', -- Snippet collection
		-- 	},
		-- },
		-- {
		-- 	"zbirenbaum/copilot.lua",
		-- 	cmd = "Copilot",
		-- 	event = "InsertEnter",
		-- 	config = F.copilot,
		-- },
		-- { "zbirenbaum/copilot-cmp", config = function() require("copilot_cmp").setup() end, },

		{
			'olimorris/codecompanion.nvim',
			event = 'VeryLazy',
			dependencies = { 'nvim-treesitter/nvim-treesitter' },
			opts = {
				display = { diff = { enabled = false } },
				strategies = {
					chat = { adapter = 'qwen' },
					inline = { adapter = 'qwen' },
				},
				adapters = {
					qwen = function()
						return require('codecompanion.adapters').extend('ollama', {
							name = 'qwen',
							schema = {
								model = { default = 'qwen2.5-coder:1.5b' },
								num_ctx = { default = 32 * 1024 },
							},
						})
					end
				},
			},
		},

		-- LANGUAGES
		{
			'nvim-treesitter/nvim-treesitter',
			dependencies = {
				'nvim-treesitter/playground', -- :TSPlaygroundToggle
				'nvim-treesitter/nvim-treesitter-textobjects',
				'kiyoon/treesitter-indent-object.nvim',
				'romgrk/nvim-treesitter-context',
				'mfussenegger/nvim-ts-hint-textobject',
				'jubnzv/virtual-types.nvim',
			},
			build = ':TSUpdate',
			main = 'nvim-treesitter.configs', -- {main}.setup({opts})
			opts = {
				highlight = { enable = true },
				ensure_installed = {
					'go',
					'gotmpl',
					'gowork',
					'hcl',
					'json',
					'lua',
					'python',
					'rust',
					'vimdoc',
					'yaml',
				},
				incremental_selection = {
					enable = true,
					keymaps = { node_incremental = '.', node_decremental = ',' },
				},
				indent = { enable = false },
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							['af'] = '@function.outer',
							['if'] = '@function.inner',
							['ac'] = '@class.outer',
							['ic'] = '@class.inner',
						},
					},
					swap = {
						enable = true,
						swap_next = {
							['<leader>el'] = '@parameter.inner',
						},
						swap_previous = {
							['<leader>eh'] = '@parameter.inner',
						},
					},
					move = {
						enable = true,
						goto_next_start = {
							[']]'] = '@function.outer',
						},
						goto_next_end = {
							[']['] = '@function.outer',
						},
						goto_previous_start = {
							['[['] = '@function.outer',
						},
						goto_previous_end = {
							['[]'] = '@function.outer',
						},
					},
				},
			},
		},
		{
			'iamcco/markdown-preview.nvim',
			cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
			ft = { 'markdown' },
			build = function()
				vim.fn['mkdp#util#install']()
			end,
		},

		-- VCS
		{
			'ruifm/gitlinker.nvim',
			event = "VeryLazy",
			opts = { mappings = nil },
		},
		{
			'lewis6991/gitsigns.nvim',
			event = "VeryLazy",
			opts = {
				signs = {
					add          = { text = '+' },
					change       = { text = '~' },
					delete       = { text = '_' },
					topdelete    = { text = '-' },
					changedelete = { text = '~' },
					untracked    = { text = '+' },
				},
				signs_staged_enable = false,
				current_line_blame = false,
				current_line_blame_opts = {
					virt_text = true,
					virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
					delay = 1000,
					ignore_whitespace = false,
				},
			},
		},
		{
			'sindrets/diffview.nvim',
			opts = {
				use_icons = false,
				icons = { folder_closed = '-', folder_open = '+' },
				signs = { fold_closed = '-', fold_open = '+' },
			},
		},

		-- DEBUG / TESTINGS
		-- todo
		-- {
		-- 	'mfussenegger/nvim-dap',
		-- 	config = F.dap,
		-- 	dependencies = {
		-- 		'vim-test/vim-test',
		-- 		'nvim-treesitter/nvim-treesitter',
		-- 		'theHamsta/nvim-dap-virtual-text',
		-- 		'leoluz/nvim-dap-go',
		-- 	},
		-- },
		-- NOTE TAKING
		-- {
		-- 	'renerocksai/telekasten.nvim',
		-- 	event = "VeryLazy",
		-- 	config = F.telekasten,
		-- 	dependencies = {
		-- 		'nvim-telescope/telescope.nvim',
		-- 		'jbyuki/venn.nvim',
		-- 	},
		-- },
		{ 'potamides/pantran.nvim', config = F.translate },

	}
end

function F.keymaps()
	vim.g.mapleader = ' '
	vim.opt.timeoutlen = 500
	-- vim.opt.ttimeoutlen = 10

	local function map(mode, lhs, rhs, opt)
		opts = { noremap = true, silent = true }
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


	-- options
	n('<leader>oO', ':only<cr>', 'only window')
	n('<leader>oo', ':MaximizerToggle!<cr>', 'maximizer') -- szw/vim-maximizer
	n('<leader>on', ':set number!<cr>', 'numbers')
	n('<leader>oN', ':set relativenumber!<cr>', 'relative numbers')
	n('<leader>os', ':setlocal spell!<cr>', 'spell check')
	n('<leader>ol', ':lua F.toggle_listchars()<cr>', 'list chars')
	n('<leader>ow', ':setlocal nowrap! linebreak!<cr>', 'wrap')
	n('<leader>oc', ':lua vim.wo.colorcolumn = (vim.wo.colorcolumn == "" and "72,80,100,120" or "")<cr>', 'columns')
	n("<leader>oC", ":setlocal <C-R>=&conceallevel ? 'conceallevel=0' : 'conceallevel=2'<CR><CR>", 'conceal level')
	n('<leader>ot', ':lua vim.opt.tabstop = (vim.opt.tabstop:get() ~= 8 and 8 or 4)<cr>', 'tabstop width')


	-- buffer
	n('<leader>s', ':write<cr>', 'save')
	n('<leader>S', ':wall<cr>', 'save all')
	n('<leader><leader>s', ':noautocmd write<cr>', 'save as is')
	n('<leader><leader>S', ':noautocmd wall<cr>', 'save all as is')
	n('<leader>bd', ':bdelete<cr>', 'delete buffer')


	-- command line
	n('<leader>;', ':', { noremap = true, desc = 'command line' })
	n('<leader>l', 'q:', 'command history')
	n("<leader>'", '@:', 'repeat last command')
	n("<leader>1", ':!', 'exec command')
	n("<leader>!", ':split term://', 'terminal command')
	vim.api.nvim_create_autocmd("CmdwinEnter", {
		pattern = "*",
		callback = function()
			map("n", "<esc>", "<c-w>q", { buffer = true, silent = true, })
		end
	})

	map('c', '<c-a>', '<home>')
	map('c', '<c-d>', '<del>')
	map('c', '<c-e>', '<end>')
	map('c', '<c-f>', '<right>')
	map('c', '<c-b>', '<left>')
	map('c', '<c-b>', '<s-left>')
	map('c', '<m-b>', '<s-left>')
	map('c', '<c-f>', '<s-right>')
	map('c', '<m-f>', '<s-right>')


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

	-- v('p', '"_dP') -- TODO: if selection at the end of line P should be replaced with p
	v('p', '"_dp') -- TODO: if selection at the end of line P should be replaced with p
	n('x', '"_x')
	n('X', '"_X')
	n('Q', 'q')

	n('vv', 'V', 'linewise select')

	n('<c-,>', '^', 'to the beginning of the line')
	v('<c-.>', '^', 'to the beginning of the line')
	n('<c-,>', '$', 'to the end of the line')
	v('<c-.>', 'g_', 'to the end of the line')


	-- search
	n('<leader>/', ":noh<cr>", 'no highlight')
	n('<c-j>', ':silent exe "norm *" | exe "nohl"<cr>', 'next the word')
	n('<c-k>', ':silent exe "norm #" | exe "nohl"<cr>', 'prev the word')
end

function F.settings()
	-- clipboard
	vim.opt.clipboard = 'unnamed'
	vim.opt.paste = false

	-- ui
	vim.opt.shortmess:append('I') -- no intro message
	vim.opt.shortmess:append('c') -- less verbose search
	vim.cmd [[autocmd! BufEnter * if &ft == 'man' | set signcolumn=no | endif]]
	vim.opt.cmdheight = 1
	vim.opt.termguicolors = true
	vim.opt.mouse = 'nv'
	vim.opt.cursorline = true
	vim.opt.showmode = false
	vim.opt.showcmd = true
	vim.opt.showcmdloc = 'statusline'
	vim.opt.fillchars = 'eob: '
	vim.opt.scrolloff = 3 -- offset lines
	vim.opt.laststatus = 3 -- status line
	vim.opt.wrap = false
	vim.opt.signcolumn = 'yes:3'
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
	vim.opt.keymap = 'russian-jcukenmac' -- <c-l> switch language
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
	vim.cmd [[autocmd! FocusGained,BufEnter * if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif]]

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

	vim.opt.list = true
	vim.opt.listchars = 'eol: ,space: ,lead: ,trail:·,nbsp: ,tab:  ,multispace: ,leadmultispace: ,'
	F.toggle_listchars = F.toggler(
		'eol: ,space: ,lead:┊,trail:·,nbsp:◇,tab:❭ ,multispace:···•,leadmultispace:┊ ,',
		function() return vim.opt.listchars end,
		function(v) vim.opt.listchars = v end
	)

	vim.diagnostic.config({
		float = { border = "rounded" },
		virtual_text = false,
		severity_sort = true,
	})
end

function F.plugins()
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
	if not vim.loop.fs_stat(lazypath) then
		vim.fn.system({
			"git", "clone", "--filter=blob:none",
			"https://github.com/folke/lazy.nvim.git",
			"--branch=stable", lazypath,
		})
	end
	vim.opt.rtp:prepend(lazypath)
	require("lazy").setup({
		spec = F.lazy_plugins(),
		ui = {
			size = { width = 0.95, height = 0.9 },
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
end

function F.functions()
	-- :lua P() inspect function
	-- :lua P(vim.g)
	_G.P = function(...)
		local objects = {}
		for i = 1, select('#', ...) do
			local v = select(i, ...)
			table.insert(objects, vim.inspect(v))
		end

		print(table.concat(objects, '\n'))
		return ...
	end

	-- :O command wrapper (:O map)
	-- https://vim.fandom.com/wiki/Capture_ex_command_output
	vim.cmd [[
	function! OutputSplitWindow(...)
		" this function output the result of the Ex command into a split scratch buffer
		let cmd = join(a:000, ' ')
		let temp_reg = @"

		redir @"
		silent! execute cmd
		redir END

		let output = copy(@")
		let @" = temp_reg
		if empty(output)
			echoerr "no output"
		else
			new
			setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted
			put! =output
			endif
	endfunction
	command! -nargs=+ -complete=command O call OutputSplitWindow(<f-args>)
	]]

	F.toggler = function(alt, getter, setter)
		local buf = alt
		return function()
			local cur = getter()
			setter(buf)
			buf = cur
		end
	end
end

F.boot()
