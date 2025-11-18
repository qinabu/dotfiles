F = {}

function F.boot()
	F.helpers()
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
			'szw/vim-maximizer', -- + expanding windows
			event = 'VeryLazy',
		},
		{
			'itchyny/vim-qfedit', -- + allows to remove lines
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
			'kevinhwang91/nvim-bqf', -- + quckfix preview
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
			event = 'VeryLazy',
			opts = {
				options = {
					icons_enabled = false,
					theme = 'everforest',
					section_separators = { left = '▘', right = '▗' },
					component_separators = '',
					globalstatus = true,
				},
				sections = {
					lualine_a = { function() return ' MVIM ' end },
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
							}
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
			'norcalli/nvim-colorizer.lua', -- +
			event = 'VeryLazy',
			opts = { 'css', 'scss', 'html', 'yaml' }
		},
		{
			'notjedi/nvim-rooter.lua', -- +
			opts = {
				rooter_patterns = { '.git', 'go.mod' },
				exclude_filetypes = { 'help', 'man', 'ctrlsf', 'git', 'fugitiveblame', '' },
				fallback_to_parent = true,
			}
		},

		{
			'folke/snacks.nvim',
			-- priority = 1000,
			lazy = true,
			opts = {
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
				bigfile = { enabled = true },
				scratch = { enabled = false }, --
				-- dashboard = { enabled = true },
				explorer = { enabled = true },
				-- indent = { enabled = true },
				input = { enabled = true },
				picker = {
					enabled = true,
					layout = {
						preset = "ivy_split",
						width = 0.8,
						height = 0.8,
					},
				},
				notifier = { enabled = true },
				quickfile = { enabled = true },
				scope = { enabled = true },
				-- scroll = { enabled = true },
				statuscolumn = { enabled = true },
				words = { enabled = true },

			},
			keys = {
				-- Top Pickers & Explorer
				{ "ff",         function() Snacks.picker.smart() end,                 desc = "Smart Find Files" },
				{ "fb",         function() Snacks.picker.buffers() end,               desc = "Buffers" },
				{ "fg",         function() Snacks.picker.grep() end,                  desc = "Grep" },
				{ "fc",         function() Snacks.picker.command_history() end,       desc = "Command History" },
				{ "fn",         function() Snacks.picker.notifications() end,         desc = "Notification History" },
				{ "fe",         function() Snacks.explorer() end,                     desc = "File Explorer" },
				-- find
				-- { "<leader>fc",      function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
				-- { "<leader>ff",      function() Snacks.picker.files() end,                                   desc = "Find Files" },
				-- { "fg", function() Snacks.picker.git_files() end,                               desc = "Find Git Files" },
				{ "fp",         function() Snacks.picker.projects() end,              desc = "Projects" },
				{ "fr",         function() Snacks.picker.recent() end,                desc = "Recent" },
				-- git
				-- { "<leader>gb",      function() Snacks.picker.git_branches() end,                            desc = "Git Branches" },
				-- { "<leader>gl",      function() Snacks.picker.git_log() end,                                 desc = "Git Log" },
				-- { "<leader>gL",      function() Snacks.picker.git_log_line() end,                            desc = "Git Log Line" },
				-- { "<leader>gs",      function() Snacks.picker.git_status() end,                              desc = "Git Status" },
				-- { "<leader>gS",      function() Snacks.picker.git_stash() end,                               desc = "Git Stash" },
				-- { "<leader>gd",      function() Snacks.picker.git_diff() end,                                desc = "Git Diff (Hunks)" },
				-- { "<leader>gf",      function() Snacks.picker.git_log_file() end,                            desc = "Git Log File" },
				-- Grep
				-- { "<leader>sb",      function() Snacks.picker.lines() end,                                   desc = "Buffer Lines" },
				-- { "<leader>sB",      function() Snacks.picker.grep_buffers() end,                            desc = "Grep Open Buffers" },
				-- { "<leader>sg",      function() Snacks.picker.grep() end,                                    desc = "Grep" },
				-- { "<leader>sw",      function() Snacks.picker.grep_word() end,                               desc = "Visual selection or word", mode = { "n", "x" } },
				-- search
				{ '<leader>s"', function() Snacks.picker.registers() end,             desc = "Registers" },
				{ '<leader>s/', function() Snacks.picker.search_history() end,        desc = "Search History" },
				{ "<leader>sa", function() Snacks.picker.autocmds() end,              desc = "Autocmds" },
				{ "<leader>sb", function() Snacks.picker.lines() end,                 desc = "Buffer Lines" },
				{ "<leader>sc", function() Snacks.picker.command_history() end,       desc = "Command History" },
				{ "<leader>sC", function() Snacks.picker.commands() end,              desc = "Commands" },
				{ "<leader>sd", function() Snacks.picker.diagnostics() end,           desc = "Diagnostics" },
				{ "<leader>sD", function() Snacks.picker.diagnostics_buffer() end,    desc = "Buffer Diagnostics" },
				{ "<leader>sh", function() Snacks.picker.help() end,                  desc = "Help Pages" },
				{ "<leader>sH", function() Snacks.picker.highlights() end,            desc = "Highlights" },
				{ "<leader>si", function() Snacks.picker.icons() end,                 desc = "Icons" },
				{ "<leader>sj", function() Snacks.picker.jumps() end,                 desc = "Jumps" },
				{ "<leader>sk", function() Snacks.picker.keymaps() end,               desc = "Keymaps" },
				{ "<leader>sl", function() Snacks.picker.loclist() end,               desc = "Location List" },
				{ "<leader>sm", function() Snacks.picker.marks() end,                 desc = "Marks" },
				{ "<leader>sM", function() Snacks.picker.man() end,                   desc = "Man Pages" },
				{ "<leader>sp", function() Snacks.picker.lazy() end,                  desc = "Search for Plugin Spec" },
				{ "<leader>sq", function() Snacks.picker.qflist() end,                desc = "Quickfix List" },
				{ "<leader>sR", function() Snacks.picker.resume() end,                desc = "Resume" },
				{ "<leader>su", function() Snacks.picker.undo() end,                  desc = "Undo History" },
				{ "<leader>uC", function() Snacks.picker.colorschemes() end,          desc = "Colorschemes" },
				-- LSP
				{ "gd",         function() Snacks.picker.lsp_definitions() end,       desc = "Goto Definition" },
				{ "gD",         function() Snacks.picker.lsp_declarations() end,      desc = "Goto Declaration" },
				{ "gr",         function() Snacks.picker.lsp_references() end,        nowait = true,                  desc = "References" },
				{ "gI",         function() Snacks.picker.lsp_implementations() end,   desc = "Goto Implementation" },
				{ "gy",         function() Snacks.picker.lsp_type_definitions() end,  desc = "Goto T[y]pe Definition" },
				{ "gs",         function() Snacks.picker.lsp_symbols() end,           desc = "LSP Symbols" },
				{ "gw",         function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
				-- Other
				{ "<leader>z",  function() Snacks.zen() end,                          desc = "Toggle Zen Mode" },
				{ "<leader>Z",  function() Snacks.zen.zoom() end,                     desc = "Toggle Zoom" },
				{ "<leader>.",  function() Snacks.scratch() end,                      desc = "Toggle Scratch Buffer" },
				{ "<leader>S",  function() Snacks.scratch.select() end,               desc = "Select Scratch Buffer" },
				{ "<leader>n",  function() Snacks.notifier.show_history() end,        desc = "Notification History" },
				-- { "<leader>bd",      function() Snacks.bufdelete() end,                                      desc = "Delete Buffer" },
				-- { "<leader>cR",      function() Snacks.rename.rename_file() end,                             desc = "Rename File" },
				{ "<leader>gB", function() Snacks.gitbrowse() end,                    desc = "Git Browse",            mode = { "n", "v" } },
				-- { "<leader>gg",      function() Snacks.lazygit() end,                                        desc = "Lazygit" },
				-- { "<leader>un",      function() Snacks.notifier.hide() end,                                  desc = "Dismiss All Notifications" },
				-- { "<c-/>",           function() Snacks.terminal() end,                                       desc = "Toggle Terminal" },
				-- { "<c-_>",           function() Snacks.terminal() end,                                       desc = "which_key_ignore" },
				{ "]]",         function() Snacks.words.jump(vim.v.count1) end,       desc = "Next Reference",        mode = { "n", "t" } },
				{ "[[",         function() Snacks.words.jump(-vim.v.count1) end,      desc = "Prev Reference",        mode = { "n", "t" } },
			},
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
			event = 'VeryLazy',
		},
		{
			'kylechui/nvim-surround',
			event = 'VeryLazy',
		},

		-- todo
		-- LSP
		{
			'mason-org/mason-lspconfig.nvim',
			dependencies = {
				{ 'mason-org/mason.nvim', opts = {} },
				{ 'neovim/nvim-lspconfig' },
			},
			config = function()
				vim.lsp.config('lua_ls', {
					-- Server-specific settings. See `:help lsp-quickstart`
					settings = {
						Lua = {
							diagnostics = {
								globals = { 'vim' },
							},
							workspace = {
								-- Make the server aware of Neovim runtime files
								library = vim.api.nvim_get_runtime_file('', true),
							},
							telemetry = { enable = false },
						},
					},
				})
				require("mason-lspconfig").setup {
					ensure_installed = { 'lua_ls', 'gopls' },
				}
				vim.api.nvim_create_autocmd('LspAttach', {
					callback = function(ev)
						local client = vim.lsp.get_client_by_id(ev.data.client_id)
						--
					end
				})
			end
		},
		-- {
		--     "mason-org/mason-lspconfig.nvim",
		--     opts = {},
		--     dependencies = {
		-- 	{ "mason-org/mason.nvim", opts = {} },
		-- 	"neovim/nvim-lspconfig",
		--     },
		--     config = function()
		-- 	    require("mason-lspconfig").setup {
		-- 		    automatic_enable = {
		-- 			exclude = {
		-- 			    "lua_ls",
		-- 			    "gopls"
		-- 			}
		-- 		    }
		-- 		}
		-- 	require("mason-lspconfig").setup {
		-- 	    ensure_installed = { "lua_ls", "gopls" },
		-- 	}
		--
		-- 	end
		-- },
		-- {
		-- 	'williamboman/mason.nvim',
		-- 	dependencies = { 'mason-org/mason-lspconfig.nvim' },
		-- 	config = function()
		-- 		local settings = {
		-- 			lua_ls = {
		-- 				settings = {
		-- 					Lua = {
		-- 						telemetry = { enable = false },
		-- 						diagnostics = { disable = { 'missing-fields' } },
		-- 						hint = { enable = true },
		-- 						workspace = { checkThirdParty = false },
		-- 					},
		-- 				},
		-- 			},
		-- 		}
		-- 		require('mason').setup()
		-- 		require('mason-lspconfig').setup({
		-- 			ensure_installed = vim.tbl_keys(settings or {})
		-- 		})
		--
		-- 		for k, v in pairs(settings) do
		-- 			vim.lsp.config(k, v)
		-- 			vim.lsp.enable(k)
		-- 		end
		--
		-- 		vim.diagnostic.config({ virtual_text = true })
		-- 		require('mason').setup()
		-- 		require('mason-lspconfig').setup({
		-- 			automatic_enable = true,
		-- 			ensure_installed = {
		-- 				'lua_ls',
		-- 				'gopls',
		-- 			},
		-- 		})
		-- 	end,
		-- },
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
		-- 		'andythigpen/nvim-coverage',
		-- 	},
		-- },
		-- {
		-- 	'andythigpen/nvim-coverage',
		-- 	version = '*',
		-- 	config = function()
		-- 		require('coverage').setup({
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
		-- 	'zbirenbaum/copilot.lua',
		-- 	cmd = 'Copilot',
		-- 	event = 'InsertEnter',
		-- 	config = F.copilot,
		-- },
		-- { 'zbirenbaum/copilot-cmp', config = function() require('copilot_cmp').setup() end, },
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
				'nvim-treesitter/playground',
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
						swap_next = { ['<leader>el'] = '@parameter.inner' },
						swap_previous = { ['<leader>eh'] = '@parameter.inner' },
					},
					move = {
						enable = true,
						goto_next_start = { [']]'] = '@function.outer' },
						goto_next_end = { [']['] = '@function.outer' },
						goto_previous_start = { ['[['] = '@function.outer' },
						goto_previous_end = { ['[]'] = '@function.outer' },
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
			event = 'VeryLazy',
			opts = { mappings = nil },
		},
		{
			'lewis6991/gitsigns.nvim',
			event = 'VeryLazy',
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
		-- 	event = 'VeryLazy',
		-- 	config = F.telekasten,
		-- 	dependencies = {
		-- 		'nvim-telescope/telescope.nvim',
		-- 		'jbyuki/venn.nvim',
		-- 	},
		-- },
		{ 'potamides/pantran.nvim', config = F.translate },
	}
end

function F.lsp_keymaps()
end

function F.keymaps()
	vim.g.mapleader = ' '
	vim.opt.timeoutlen = 500
	-- vim.opt.ttimeoutlen = 10

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


	-- options
	n('<leader>oO', ':only<cr>', 'only window')
	n('<leader>oo', ':MaximizerToggle!<cr>', 'maximizer') -- szw/vim-maximizer
	n('<leader>on', ':set number!<cr>', 'numbers')
	n('<leader>oN', ':set relativenumber!<cr>', 'relative numbers')
	n('<leader>os', ':setlocal spell!<cr>', 'spell check')
	n('<leader>ol', F.toggle_listchars, 'list chars')
	n('<leader>ow', ':setlocal nowrap! linebreak!<cr>', 'wrap')
	n('<leader>oc', function() vim.wo.colorcolumn = (vim.wo.colorcolumn == '' and "72,80,100,120" or '') end,
		'columns')
	n('<leader>oC', ":setlocal <C-R>=&conceallevel ? 'conceallevel=0' : 'conceallevel=2'<CR><CR>", 'conceal level')
	n('<leader>ot', function() vim.opt.tabstop = (vim.opt.tabstop:get() ~= 8 and 8 or 4) end, 'tabstop width')


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
	n('<leader>1', ':!', 'exec command')
	n('<leader>!', ':split term://', 'terminal command')
	vim.api.nvim_create_autocmd('CmdwinEnter', {
		pattern = '*',
		callback = function()
			map('n', '<esc>', '<c-w>q', { buffer = true, silent = true, })
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
	vim.opt.scrolloff = 2 -- offset lines
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
		float = { border = 'rounded' },
		virtual_text = false,
		severity_sort = true,
	})
end

function F.plugins()
	local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
	if not vim.loop.fs_stat(lazypath) then
		vim.fn.system({
			'git', 'clone', '--filter=blob:none',
			'https://github.com/folke/lazy.nvim.git',
			'--branch=stable', lazypath,
		})
	end
	vim.opt.rtp:prepend(lazypath)
	require('lazy').setup({
		spec = F.lazy_plugins(),
		ui = {
			size = { width = 0.95, height = 0.9 },
			icons = {
				lazy = '',
				cmd = '⌘',
				plugin = '⌘',
				start = '⌘',
				source = '⌘',
				ft = '⌘',
				event = '⌘',
			}
		},
	})
end

function F.helpers()
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
