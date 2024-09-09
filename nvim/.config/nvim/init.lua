F = {}
M = {}

local map = vim.keymap.set

local NSE = { noremap = true, silent = true, expr = true }
local NS = { noremap = true, silent = true }
local N = { noremap = true }

function F.unpackLazy()
	return {

		-- UI
		-- {
		-- 	'folke/which-key.nvim',
		-- 	event = 'VimEnter', -- Sets the loading event to 'VimEnter'
		-- 	config = function() -- This is the function that runs, AFTER loading
		-- 		require('which-key').setup()
		--
		-- 		-- Document existing key chains
		-- 		-- require('which-key').register {
		-- 		-- 	['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
		-- 		-- 	['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
		-- 		-- 	['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
		-- 		-- 	['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
		-- 		-- 	['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
		-- 		-- }
		-- 	end,
		-- },
		{ 'sainnhe/everforest',  config = F.everforest_true },
		{ 'folke/zen-mode.nvim', config = F.zen_mode },
		{ 'szw/vim-maximizer' }, -- :MaximizerToggle
		{ 'simeji/winresizer',   init = M.winresizer },
		{ 'itchyny/vim-qfedit' }, -- edit quickfix
		{
			'kevinhwang91/nvim-bqf',
			ft = 'qf',
			config = M.bqf_quickfix
		},
		{ 'nvim-lualine/lualine.nvim',   config = function() vim.defer_fn(F.lualine, 100) end, },
		-- { 'lewis6991/satellite.nvim' },
		{ 'norcalli/nvim-colorizer.lua', config = F.colorizer },
		{
			'notjedi/nvim-rooter.lua',
			config = function()
				require 'nvim-rooter'.setup({
					exclude_filetypes = { 'ctrlsf', 'git', 'fugitiveblame' },
					fallback_to_parent = true,
				})
			end
		},
		{
			'nvim-telescope/telescope.nvim',
			branch = '0.1.x',
			config = F.telescope,
			dependencies = {
				'nvim-lua/plenary.nvim',
				'nvim-telescope/telescope-file-browser.nvim',
				'nvim-telescope/telescope-ui-select.nvim',
				'nvim-telescope/telescope-dap.nvim',
				{
					'nvim-telescope/telescope-fzf-native.nvim',
					build = 'make',
					-- build =
					-- 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
				},
			},
		},

		-- EDIT
		{ 'phaazon/hop.nvim',      config = F.hop },
		{ 'dyng/ctrlsf.vim',       config = F.ctrlsf }, -- find & replace
		{ 'numToStr/Comment.nvim', config = F.comment },
		{
			"kylechui/nvim-surround",
			version = "*", -- Use for stability; omit to use `main` branch for the latest features
			event = "VeryLazy",
			config = function()
				require("nvim-surround").setup({
					-- Configuration here, or leave empty to use defaults
				})
			end
		},

		-- LSP
		{
			'neovim/nvim-lspconfig',
			config = F.lspconfig,
			dependencies = {
				'williamboman/mason.nvim',
				'williamboman/mason-lspconfig.nvim',
				'folke/neodev.nvim', -- vim lua sdk
				'hrsh7th/nvim-cmp',
				'hrsh7th/cmp-nvim-lsp',
				-- 'stevearc/aerial.nvim',
				'ray-x/lsp_signature.nvim',
				{ 'j-hui/fidget.nvim', ['tag'] = 'legacy' },
				-- 'VidocqH/lsp-lens.nvim',
			},
		},

		-- COMPLETION
		{
			'hrsh7th/nvim-cmp',
			config = F.cmp,
			dependencies = {
				'hrsh7th/cmp-nvim-lsp',
				'hrsh7th/cmp-nvim-lua',
				'hrsh7th/cmp-buffer',
				'hrsh7th/cmp-path',
				'hrsh7th/cmp-cmdline',
				'hrsh7th/cmp-nvim-lsp-document-symbol',

				'L3MON4D3/LuaSnip', -- Snippets
				'saadparwaiz1/cmp_luasnip',
				'honza/vim-snippets', -- Snippet collection
			},
		},
		-- { 'tzachar/cmp-ai',         dependencies = 'nvim-lua/plenary.nvim',                 config = F.cmp_ai },
		-- { 'hrsh7th/nvim-cmp',       dependencies = 'tzachar/cmp-ai' },
		--
		-- { 'github/copilot.vim',     config = F.copilot },
		{ "zbirenbaum/copilot.lua", cmd = "Copilot",                                        event = "InsertEnter", config = F.copilot, },
		{ "zbirenbaum/copilot-cmp", config = function() require("copilot_cmp").setup() end, },
		{ 'David-Kunz/gen.nvim',    config = F.gen },

		-- LANGUAGES
		{
			'nvim-treesitter/nvim-treesitter',
			config = F.treesitter,
			dependencies = {
				'nvim-treesitter/playground', -- :TSPlaygroundToggle
				'nvim-treesitter/nvim-treesitter-textobjects',
				'kiyoon/treesitter-indent-object.nvim',
				'romgrk/nvim-treesitter-context',
				'mfussenegger/nvim-ts-hint-textobject', -- Scope selection by m
				'jubnzv/virtual-types.nvim',
			},
			build = ':TSUpdate',
		},
		-- { 'jjo/vim-cue' },
		{
			'iamcco/markdown-preview.nvim',
			build = function() vim.fn["mkdp#util#install"]() end,
		},

		-- VCS
		{
			'tpope/vim-fugitive',
			config = F.fugitive,
			dependencies = {
				'nvim-lua/plenary.nvim',
				'ruifm/gitlinker.nvim',
			},
		},
		{
			'lewis6991/gitsigns.nvim',
			config = F.gitsigns,
			dependencies = { 'nvim-lua/plenary.nvim' },
		},
		{
			'sindrets/diffview.nvim',
			config = F.diffview,
			dependencies = { 'nvim-lua/plenary.nvim' },
		},

		-- DEBUG / TESTINGS
		{
			'mfussenegger/nvim-dap',
			config = F.dap,
			dependencies = {
				'vim-test/vim-test',
				'nvim-treesitter/nvim-treesitter',
				'theHamsta/nvim-dap-virtual-text',
				'leoluz/nvim-dap-go',
			},
		},
		-- NOTE TAKING
		{
			'renerocksai/telekasten.nvim',
			config = F.telekasten,
			dependencies = { 'nvim-telescope/telescope.nvim' },
		},
		{ 'potamides/pantran.nvim', config = F.translate },

	}
end

function M.bootstrap()
	map('', '<space>', '<nop>', NS)

	-- Vim
	map('n', '<leader>q', ':qall<cr>', N)
	map('n', '<leader>Q', ':qall!<cr>', N)

	map('n', '<leader>bq', ':bdelete<cr>', N)
	map('n', '<leader>bQ', ':bdelete!<cr>', N)

	-- map('n', '<leader>tq', ':tabclose<cr>', N)
	-- map('n', '<leader>tQ', ':tabclose!<cr>', N)

	-- map('n', '<leader><esc>', ':silent quit<cr>', N)

	_G.Reload = function()
		for name, _ in pairs(package.loaded) do
			if name:match('^cnull') then
				package.loaded[name] = nil
			end
		end

		-- for name, _ in pairs(package.loaded) do
		-- 	if name:match('lualine') then -- or name:match('^lsp') or name:match('^plugins') then
		-- 		package.loaded[name] = nil
		-- 	end
		-- end

		dofile(vim.env.MYVIMRC)
		vim.notify("Reloaded", vim.log.levels.INFO)
	end

	map('n', '<leader><leader><', ':lua Reload()<cr>', NS)
	map('n', '<leader><leader>,', ':edit $MYVIMRC<CR>', NS)
	map('n', '<leader><leader>.', ':call chdir(expand("%:p:h")) | pwd<CR>', N)

	-- Lang (see keymap)
	map('i', '<c-l>', '<c-^>', NS)
	map('c', '<c-l>', '<c-^>', NS)
	map('n', '<c-l>', 'i<c-^><esc>', NS)

	-- Navigation
	map('n', '<c-o>', '<c-o>zz', N)        -- Window modification prefix
	map('n', '<c-i>', '<c-i>zz', N)        -- Window modification prefix

	map('n', '<leader>w', '<c-w>', N)      -- Window modification prefix
	map('n', '<leader>w?', ':help CTRL-W<cr>', N) -- Window modification prefix

	map('n', '<leader>tl', ':tabnext<cr>', N)
	map('n', '<leader>th', ':-tabnext<cr>', N)
	map('n', '<leader>tq', ':tabclose<cr>', N)

	map('n', '<leader>h', '<c-w>h', NS)
	map('n', '<leader>l', '<c-w>l', NS)
	map('n', '<leader>j', '<c-w>j', NS)
	map('n', '<leader>k', '<c-w>k', NS)

	map('n', '<ScrollWheelUp>', '<c-y>', NS)
	map('n', '<ScrollWheelDown>', '<c-e>', NS)

	-- map('n', '<leader>p', '<c-^>zz', NS) -- previous buffer
	map('n', '<leader>p', '<c-^>', NS) -- previous buffer

	-- map('n', '<leader>d', ':NvimTreeFindFileToggle<cr>', NS)
	-- map('n', '<leader>d', ':Neotree toggle reveal<cr>', NS)
	-- map('n', '<leader>d', ':NvimTreeFindFile<cr>', NS)

	-- Options
	map('n', '<leader>oO', ':only<cr>', NS)
	map('n', '<leader>oo', ':MaximizerToggle!<cr>', NS)

	map('n', '<leader>on', ':set number!<cr>', NS)
	map('n', '<leader>oN', ':set relativenumber!<cr>', NS)

	map('n', '<leader>os', ':setlocal spell!<cr>', NS)

	local listchars_saved = ""
	_G.listchars_toggle = function()
		if vim.o.listchars == _G.listchars_alternative then
			vim.o.listchars = listchars_saved
		else
			listchars_saved = vim.o.listchars
			vim.o.listchars = _G.listchars_alternative
		end
	end
	map('n', '<leader>ol', ':lua _G.listchars_toggle()<cr>', NS)
	-- map('n', '<leader>ol', ':setlocal list!<cr>', NS)
	map('n', '<leader>ow', ':setlocal nowrap! linebreak!<cr>', NS)

	map('n', '<leader>oc', ':lua vim.wo.colorcolumn = (vim.wo.colorcolumn == "" and "72,80,100,120" or "")<cr>', NS)
	map('n', '<leader>ot', ':lua vim.opt.tabstop = (vim.opt.tabstop:get() ~= 8 and 8 or 4)<cr>', NS)

	-- Command line
	map('n', '<leader>;', ':', N)       -- Command line
	map('v', '<leader>:', 'q:', N)      -- Command history
	map('v', '<leader>/', 'q:', N)      -- Command history
	map('n', "<leader>'", '@:', N)      -- Repeat last command
	map('n', "<leader>1", ':!', N)      -- Exec
	map('n', "<leader>!", ':split term://', N) -- Exec
	-- map('n', '<leader><leader>;', ':!', N) -- Command terminal line

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
	map('n', '<leader>s', ':write<cr>', N)            -- Write changes
	map('n', '<leader>S', ':wall<cr>', N)             -- Write chages of all buffers
	map('n', '<leader><leader>s', ':noautocmd write<cr>', N) -- Write buffer as is
	map('n', '<leader><leader>S', ':noautocmd wall<cr>', N) -- Write buffer as is
	map('n', '<leader>bd', ':bdelete<cr>', N)         -- Delete current buffer

	-- Edit
	map('i', '<esc>', '<esc>`^', NS) -- Keep cursor on the same positioni

	map({ 'n', 'v' }, 'j', 'gj', NS)
	map({ 'n', 'v' }, 'k', 'gk', NS)
	map('i', '<down>', '<c-o>gj', NS)
	map('i', '<up>', '<c-o>gk', NS)

	map('n', '<leader>ee', '*Ncgn', NS)                       -- change a word under cursor
	map('v', '<leader>ee', "\"sy:let @/='\\V'.@s<CR>cgn", NS) -- change selected as first
	map('v', '<leader>er', '"hy:%s/<C-r>h//gc<left><left><left>', N) -- substitute command for selected
	map('n', '<leader>ew', ':%s/\\s\\+$//e<cr>', N)           -- remove trailing spaces
	map('v', '<leader>ew', ':s/\\s\\+$//e<cr>', N)            -- remove trailing spaces for selection

	map('v', 'K', ":move '<-2<cr>gv=gv", NS)
	map('v', 'J', ":move '>+1<cr>gv=gv", NS)

	-- map('v', 'p', '"_dP', NS) -- TODO: if selection at the end of line P should be replaced with p
	map('v', 'p', '"_dp', NS) -- TODO: if selection at the end of line P should be replaced with p
	map('n', 'x', '"_x', NS)
	map('n', 'X', '"_X', NS)
	map('n', 'Q', 'q', N)

	-- Searching
	-- map('n', '<leader>/', ":let @/=''<cr>", NS)
	map('n', '<leader>/', ":noh<cr>", NS)
	map('n', '<c-j>', ':silent exe "norm *" | exe "nohl"<cr>', NS)
	map('n', '<c-k>', ':silent exe "norm #" | exe "nohl"<cr>', NS)

	map('n', '<c-h>', '^', N)
	map('n', '<c-l>', '$', N)
	map('v', '<c-h>', '^', N)
	map('v', '<c-l>', 'g_', N)



	-- quicklist & loclist
	local close_lists = function()
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

	_G.QuickFix_toggle = function()
		if not close_lists() then
			vim.cmd [[copen]]
		end
	end
	_G.LocList_toggle = function()
		if not close_lists() then
			local _, err = pcall(vim.cmd, [[lopen]])
			if err then
				print('loc list is empty')
			end
		end
	end

	map('n', '<leader>c', ':lua QuickFix_toggle()<cr>', NS)
	map('n', '<leader>C', ':lua LocList_toggle()<cr>', NS)

	-- map('n', '<leader>.', ':silent! cnext<cr>', NS)
	-- map('n', '<leader>,', ':silent! cprevious<cr>', NS)

	-- map('n', '<leader><', ':silent! colder<cr>', NS)
	-- map('n', '<leader>>', ':silent! cnewer<cr>', NS)

	map('n', ')', ':silent! cnext<cr>', NS)
	map('n', '(', ':silent! cprevious<cr>', NS)

	map('n', '<leader>0', ':silent! cnewer<cr>', NS) -- c-9 doesn't work
	map('n', '<leader>9', ':silent! colder<cr>', NS) -- c-0 doesn't work
end

function M.gen()
	map('v', '<leader>i', ':Gen<CR>')
	map('n', '<leader>i', ':Gen<CR>')
end

function M.bqf_quickfix()
	require('bqf').setup {
		auto_enable = true,
		auto_resize_height = false,
		func_map = {
			pscrollup = '<C-u>',
			pscrolldown = '<C-d>',
		},
		preview = {
			show_title = true,
			-- border = 'none',
			winblend = 0,
		}
	}
end

function M.hop()
	-- map('n', 's', ':HopChar1<cr>', NS)
	map('n', 's', ':HopChar2<cr>', NS)
	map('n', 'S', ':lua require("hop").hint_words({keys="fjdkslaghruty"})<cr>', NS)
	-- map('n', 's', ':lua require("hop").hint_words()<cr>', NS)
end

function M.translate()
	local pantran = require("pantran")
	map('n', 'trr', ':Pantran target=ru<cr>', NS)
	map('n', 'tre', ':Pantran target=en<cr>', NS)
	map('v', 'trr', ':Pantran target=ru<cr>', NS)
	map('v', 'tre', ':Pantran target=en<cr>', NS)

	map('n', 'trt', pantran.motion_translate, NSE)
	map('v', 'trt', pantran.motion_translate, NSE)
end

function M.treesitter()
	-- mfussenegger/nvim-ts-hint-textobject
	-- require("tsht").config.hint_keys = { "a", "s", "d", "f", "j", "k", "l", "g", "h" }
	require("tsht").config.hint_keys = { "f", "j", "d", "k", "s", "l", "a", "g", "h" }
	map('o', 'm', ':<c-u>lua require("tsht").nodes()<cr>', NS)
	map('v', 'm', ':lua require("tsht").nodes()<cr>', NS)

	-- indent object
	local iobj = require 'treesitter_indent_object.textobj'
	map({ 'x', 'o' }, 'ai', function() iobj.select_indent_outer() end)
	map({ 'x', 'o' }, 'aI', function() iobj.select_indent_outer(true) end)
	map({ 'x', 'o' }, 'ii', function() iobj.select_indent_inner() end)
	map({ 'x', 'o' }, 'iI', function() iobj.select_indent_inner(true, 'V') end)
end

function M.lsp()
	-- help / hint
	map('n', 'K', ':lua vim.lsp.buf.hover()<cr>', NS)
	-- map('n', '<c-k>', ':lua vim.lsp.buf.signature_help()<cr>', NS)

	-- diagnostics
	map('n', 'gl', ':lua vim.diagnostic.open_float()<cr>', NS)
	map('n', 'gL', ':lua vim.diagnostic.setqflist()<cr>', NS)
	map('n', '[d', ':lua vim.diagnostic.goto_prev()<cr>', NS)
	map('n', ']d', ':lua vim.diagnostic.goto_next()<cr>', NS)

	-- go to
	map('n', 'gr', ':lua vim.lsp.buf.references({includeDeclaration=false})<cr>', NS)
	map('n', 'gD', ':lua vim.lsp.buf.declaration()<cr>', NS)
	map('n', 'gd', ':lua vim.lsp.buf.definition()<cr>', NS)
	map('n', 'gi', ':lua vim.lsp.buf.implementation()<cr>', NS)
	map('n', 'gy', ':lua vim.lsp.buf.type_definition()<cr>', NS)

	map('n', 'gI', ':lua vim.lsp.buf.incoming_calls()<cr>', NS)
	map('n', 'gO', ':lua vim.lsp.buf.outgoing_calls()<cr>', NS)

	-- edit actions
	map('n', '<leader>ea', ':lua vim.lsp.buf.code_action()<cr>', NS) -- telescope
	map('n', '<leader>er', ':lua vim.lsp.buf.rename()<cr>', NS)
	map('n', '<leader>ef', ':lua vim.lsp.buf.format();print("Formatted")<cr>', N)
	map('n', '<leader>ec', ':lua vim.lsp.codelens.refresh();vim.lsp.codelens.run()<cr>', NS)
end

function M.telescope()
	-- map('n', '<leader>ea', ':Telescope lsp_code_actions<cr>', NS)
	map('n', '<leader>es', ':Telescope spell_suggest<cr>', NS)
	map('n', 'f<leader>', ':Telescope<cr>', NS)
	map('n', 'ft', ':Telescope tagstack initial_mode=normal<cr>', NS)
	map('n', 'ff', ':Telescope find_files hidden=true<cr>', NS)
	map('n', 'fF', ':Telescope find_files hidden=true search_dirs=%:h<cr>', NS)
	map('n', 'fg', ':Telescope live_grep hidden=true<cr>', NS)
	map('n', 'fG', ':Telescope live_grep hidden=true search_dirs=%:h<cr>', NS)
	map('n', 'f/', ':Telescope current_buffer_fuzzy_find<cr>', NS)
	map('n', 'fk', ':Telescope keymaps<cr>', NS)
	map('n', 'fh', ':Telescope git_status<cr>', NS) --  initial_mode=normal
	map('n', 'fd',
		':Telescope file_browser theme=ivy layout_config={height=0.8} initial_mode=normal select_buffer=true<cr>',
		NS)
	map('n', 'fl', ':Telescope diagnostics initial_mode=normal<cr>', NS)
	map('n', 'fr',
		':Telescope file_browser theme=ivy layout_config={height=0.8} initial_mode=normal path=%:p:h select_buffer=true<cr>',
		NS)
	map('n', 'fs', ':Telescope lsp_document_symbols symbol_width=60<cr>', NS)
	map('n', 'fw', ':Telescope lsp_dynamic_workspace_symbols symbol_width=60 fname_width=50<cr>', NS)
	map('n', 'fb', ':Telescope buffers initial_mode=normal<cr>', NS)
	map('n', 'fB', ':Telescope git_branches initial_mode=normal<cr>', NS)
	map('n', 'fm', ':Telescope marks initial_mode=normal<cr>', NS)
	map('n', 'fj', ':Telescope jumplist initial_mode=normal<cr>', NS)
	map('n', 'fa', ':Telescope man_pages<cr>', NS)

	-- map('n', 'fh', ':Telescope harpoon marks<cr>', NS)
	-- map('n', 'fo', ':lua require("harpoon.ui").toggle_quick_menu()<cr>', NS)
	-- map('n', 'fO', ':lua require("harpoon.mark").add_file()<cr>', NS)
end

function M.luasnip()
	-- -- expand or jump
	-- -- map('i', '<tab>', "luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<tab>'", { expr = true })

	-- select mode jumps
	-- -- map('s', '<tab>', '<cmd>lua require("luasnip").jump(1)<cr>', {})
	-- -- map('s', '<s-tab>', '<cmd>lua require("luasnip").jump(-1)<cr>', {})

	-- choose variants
	-- see F.cmp
	-- map('i', '<C-n>', '<Plug>luasnip-next-choice', {})
	-- map('s', '<C-n>', '<Plug>luasnip-next-choice', {})
	-- map('i', '<C-p>', '<Plug>luasnip-prev-choice', {})
	-- map('s', '<C-p>', '<Plug>luasnip-prev-choice', {})

	-- -- map('i', '<c-.>', "luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<c-.>'", { expr = true })
	-- -- map('s', '<c-.>', "luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<c-.>'", { expr = true })

	-- map('i', '<c-,>', "luasnip#choice_active() ? '<Plug>luasnip-prev-choice' : '<c-,>'", { expr = true })
	-- map('s', '<c-,>', "luasnip#choice_active() ? '<Plug>luasnip-prev-choice' : '<c-,>'", { expr = true })
end

function M.testing()
	-- DAP
	map('n', '<leader>tf', ':Telescope dap commands<cr>', NS)
	map('n', '<leader>tq', ':lua require("dap").close()<cr>:DapVirtualTextDisable<cr>', NS)
	map('n', '<leader>tv', ':DapVirtualTextToggle<cr>', NS)

	map('n', '<leader>tg', ':lua require("dap-go").debug_test()<cr>', NS)

	map('n', '<leader>td', ':DapVirtualTextEnable<cr>:lua require("dap").continue()<cr>', NS)
	map('n', '<leader>tD', ':DapVirtualTextEnable<cr>:lua require("dap").run_last()<cr>', NS)
	map('n', '<leader>tc', ':DapVirtualTextEnable<cr>:lua require("dap").run_to_cursor()<cr>', NS)

	map('n', '<leader>]', ':lua require("dap").step_over()<cr>', NS)
	map('n', '<leader>}', ':lua require("dap").step_into()<cr>', NS)
	map('n', '<leader>[', ':lua require("dap").step_out()<cr>', NS)

	map('n', '<leader>tb', ':lua require("dap").toggle_breakpoint()<cr>', NS)
	map('n', '<leader>tB', ':lua require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))<cr>', NS)
	map('n', '<leader>tL', ':lua require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<cr>',
		NS)
	map('n', '<leader>tr', ':lua require("dap").repl.open()<cr>', NS)

	-- VIM-TEST
	map('n', '<leader>tt', ':TestNearest -v<cr>', NS)
	map('n', '<leader>tT', ':TestFile -v<cr>', NS)
	map('n', '<leader>tl', ':TestLast -v<cr>', NS)
	map('n', '<leader>tv', ':TestVisit<cr>', NS)
end

function M.winresizer()
	vim.cmd [[ let g:winresizer_start_key = '<leader>we' ]]
	-- map('n', '<leader>we', ':WinResizerStartResize<cr>', NS)
end

function M.ctrlsf()
	vim.cmd [[
		let g:ctrlsf_position = 'bottom'
		let g:ctrlsf_preview_position = 'outside'
		let g:ctrlsf_winsize = '40%'
		let g:ctrlsf_auto_preview = 0
		let g:ctrlsf_auto_focus = {
		\ "at" : "done",
		\ "duration_less_than": 1000
		\ }
	]]
	map('n', '<leader>fc', '<Plug>CtrlSFCwordExec', {})
	map('v', '<leader>fc', '<Plug>CtrlSFVwordExec', {})
	map('n', '<leader>fC', '<Plug>CtrlSFPrompt', {})
end

function M.fugitive()
	_G.Git_blame_toggle = function()
		local found = false
		for _, id in ipairs(vim.api.nvim_list_wins()) do
			if vim.bo[vim.fn.winbufnr(id)].filetype == 'fugitiveblame' then
				vim.api.nvim_win_close(id, false)
				found = true
			end
		end
		if not found then
			vim.cmd [[:Git blame]]
			vim.cmd(vim.api.nvim_replace_termcodes('normal <c-w>p', true, true, true))
		end
	end

	-- map('n', '<leader>gg', ':Git<cr>', NS)
	map('n', '<leader>gg',
		':if buflisted(bufname(".git/index")) <cr> :bd .git/index <cr> :else <cr> :Git <cr> :endif <cr>'
		, NS)
	-- map('n', '<leader>gb', ':Git blame<cr><c-w>p', NS)
	map('n', '<leader>gb', ':lua Git_blame_toggle()<cr>', NS)
	map('n', '<leader>gB', ':.GBrowse<cr>', NS)
	map('n', '<leader>gd', ':Git difftool<cr>', NS)
	map('n', '<leader>gD', ':Gvdiffsplit<cr>', NS)
	-- map('n', '<leader>gl', ':0Gclog<cr>', NS)
	-- map('n', '<leader>gL', ':Gclog<cr>', NS)
	map('n', '<leader>gl', ':DiffviewFileHistory<cr>', NS)
	map('n', '<leader>gL', ':DiffviewFileHistory %<cr>', NS)

	map('n', '<leader>gy',
		'<cmd>lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".copy_to_clipboar})<cr>'
		, NS)
	map('v', '<leader>gy',
		'<cmd>lua require"gitlinker".get_buf_range_url("v", {action_callback = require"gitlinker.actions".copy_to_clipboar})<cr>'
		, NS)
	map('n', '<leader>gY', ":let @+=expand('%') .. ':' .. line('.')<cr>", NS)
end

function M.gitsigns()
	-- Toggle line blame
	map('n', '<leader>ob', ':Gitsigns toggle_current_line_blame<cr>', NS)

	-- JUMP
	-- next / pref hunk
	-- map('n', ']h', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<cr>'", NSE)
	-- map('n', '[h', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<cr>'", NSE)
	-- map('n', ']h', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<cr>'", NSE)
	-- map('n', '[h', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<cr>'", NSE)

	map('n', ']h', function()
		if vim.wo.diff then return ']c' end
		vim.schedule(function() require('gitsigns').next_hunk() end)
		return '<Ignore>'
	end, NSE)

	map('n', '[h', function()
		if vim.wo.diff then return '[c' end
		vim.schedule(function() require('gitsigns').prev_hunk() end)
		return '<Ignore>'
	end, { expr = true })

	-- stage
	map('n', 'ghs', '<cmd>Gitsigns stage_hunk<cr>', NS)
	map('v', 'ghs', ':Gitsigns stage_hunk<cr>', NS)
	map('n', 'ghS', '<cmd>Gitsigns stage_buffer<CR>', NS) -- buffer
	-- unstage
	map('n', 'ghu', '<cmd>Gitsigns undo_stage_hunk<cr>', NS)
	map('v', 'ghu', '<cmd>Gitsigns undo_stage_hunk<CR>', NS)
	map('n', 'ghU', '<cmd>Gitsigns reset_buffer_index<CR>', NS) -- buffer
	-- reset
	map('n', 'ghr', '<cmd>Gitsigns reset_hunk<cr>', NS)
	map('v', 'ghr', ':Gitsigns reset_hunk<cr>', NS)
	map('n', 'ghR', '<cmd>Gitsigns reset_buffer<CR>', NS) -- buffer

	-- BLAME
	map('n', 'ghp', '<cmd>Gitsigns preview_hunk<CR>', NS)
	map('n', 'ghb', '<cmd>lua require"gitsigns".blame_line{full=true}<CR>', NS)

	-- TEXT OBJECT: in hunk
	map('o', 'ih', ':<C-U>Gitsigns select_hunk<cr>', NS)
	map('x', 'ih', ':<C-U>Gitsigns select_hunk<cr>', NS) -- breaks selection left-right
end

function M.telekasten()
	map('n', 'fnn', ':lua require("telekasten").panel()<cr>', NS)

	-- add note
	-- map('n', '<leader>nA', ':lua require("telekasten").new_note()<cr>', NS)
	-- map('n', '<leader>na', ':lua require("telekasten").new_templated_note()<cr>', NS)

	-- find
	map('n', 'fnf', ':lua require("telekasten").find_notes()<cr>', NS)
	map('n', 'fng', ':lua require("telekasten").search_notes()<cr>', NS)

	-- today
	-- map('n', 'fnt', ':lua require("telekasten").goto_today()<cr>', NS)
	-- map('n', 'fnd', ':lua require("telekasten").find_daily_notes()<cr>', NS)

	-- week
	map('n', 'fnw', ':lua require("telekasten").goto_thisweek()<cr>', NS)
	map('n', 'fnW', ':lua require("telekasten").find_weekly_notes()<cr>', NS)

	-- todo toggle
	map('n', '<leader>nx', ':lua require("telekasten").toggle_todo()<cr>', NS)

	-- links & tags
	map('n', '<leader>nl', ':lua require("telekasten").follow_link()<cr>', NS)
	map('n', '<leader>ni', ':lua require("telekasten").insert_link()<cr>', NS)

	map('n', '<leader>ny', ':lua require("telekasten").yank_notelink()<cr>', NS)
	map('n', '<leader>nb', ':lua require("telekasten").show_backlinks()<cr>', NS)
	map('n', '<leader>nr', ':lua require("telekasten").find_friends()<cr>', NS)
	map('n', '<leader>n[', ':lua require("telekasten").show_tags()<cr>', NS)

	-- map('n', '<leader>zI', ':lua require("telekasten").insert_img_link({ i=true })<cr>', NS)
	-- map('n', '<leader>zp', ':lua require("telekasten").preview_img()<cr>', NS)
	-- map('n', '<leader>zm', ':lua require("telekasten").browse_media()<cr>', NS)

	-- map('n', '<leader>zi', ':lua require("telekasten").paste_img_and_link()<cr>', NS)
	-- " we could define [[ in **insert mode** to call insert link
	-- " inoremap [[ <ESC>:lua require('telekasten').insert_link()<cr>', NS)
	-- " alternatively: leader [

	-- insert link
	-- map('i', '<c-[>', '<ESC>:lua require("telekasten").insert_link({ i=true })<cr>>', NS)
	-- map('i', '<c-t>', '<cmd>lua require("telekasten").show_tags({i = true})<cr>', NS)
	--
	-- map('i', '<leader>nx', '<ESC>:lua require("telekasten").toggle_todo({ i=true })<cr>', NS)
end

function M.zen_mode()
	map('n', '<leader>oz', ':ZenMode<cr>', NS)
end

--------------------------------------------------------------------------------

function F.bootstrap()
	vim.g.mapleader = " "
	-- Basic
	vim.opt.shortmess:append("I") -- don't give the intro message when starting Vim :intro
	vim.opt.shortmess:append("c") -- don't give |ins-completion-menu| messages.  For example, "-- XXX completion (YYY)", "match 1 of 2", "The only match", "Pattern not found", "Back at original", etc.
	vim.opt.clipboard = "unnamed"
	vim.opt.paste = false
	vim.opt.encoding = "utf-8"
	vim.cmd [[set spelllang=en_us,ru_yo]]
	vim.opt.maxmempattern = 5000

	vim.opt.keymap = "russian-jcukenmac" -- <c-l> for change language
	vim.opt.iminsert = 0
	vim.opt.imsearch = 0
	vim.opt.inccommand = 'split'

	vim.opt.autoread = true
	-- Update a buffer's contents on focus if it changed outside of Vim.
	vim.cmd [[autocmd! FocusGained,BufEnter * if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif]]
	vim.cmd [[autocmd! BufEnter * if &ft == 'man' | set signcolumn=no | endif]]

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
	-- t:textwidth, c:textwith comments, q:comments, r:auto indent, n:lists, 1:don't break one-letter word.
	-- vim.opt.formatoptions = "tcqrn1"
	vim.opt.formatoptions = "qjrn1"
	-- vim.opt.textwidth = 100

	-- expandtab = true
	vim.cmd [[ filetype plugin indent on ]]
	vim.g.editorconfig = false
	vim.opt.tabstop = 8
	vim.opt.smarttab = true
	vim.opt.shiftwidth = 8
	-- vim.g.smarttab = true
	-- vim.g.tabstop = 8
	-- -- vim.go.tabstop = 8
	-- vim.g.shiftwidth = 8 -- << >>

	-- showmatch = true
	-- matchtime = 10
	vim.opt.virtualedit = "block"
	vim.opt.whichwrap = "b,s,<,>"
	vim.opt.matchpairs:append("<:>")

	vim.opt.spell = false

	-- UI
	vim.opt.cmdheight = 1
	vim.opt.termguicolors = true
	vim.opt.mouse = 'nv'
	vim.opt.cursorline = true
	vim.opt.showmode = false
	vim.opt.showcmd = true
	vim.opt.showcmdloc = 'statusline'
	-- vim.opt.fillchars = 'vert:▞,horiz:▞,eob: '
	vim.opt.fillchars = 'eob: '
	-- vim.opt.background = 'dark'
	vim.opt.scrolloff = 3 -- offset lines
	vim.opt.laststatus = 3 -- status line (one global)
	-- vim.cmd [[set laststatus=3]]
	vim.opt.wrap = false

	-- vim.opt.signcolumn = 'number'
	vim.opt.signcolumn = 'yes:3'
	vim.opt.numberwidth = 3

	vim.opt.number = false
	vim.opt.relativenumber = false

	vim.opt.errorbells = false
	vim.opt.visualbell = true

	vim.opt.hlsearch = true
	vim.opt.incsearch = true
	vim.opt.ignorecase = true
	vim.opt.smartcase = true

	vim.opt.splitbelow = true
	vim.opt.splitright = true

	vim.opt.updatetime = 100
	vim.opt.timeoutlen = 500
	-- vim.opt.ttimeoutlen = 10

	_G.listchars_alternative = "eol: ,space: ,lead:┊,trail:·,nbsp:◇,tab:❭ ,multispace:···•,leadmultispace:┊ ,"
	vim.opt.listchars = "eol: ,space: ,lead: ,trail:·,nbsp: ,tab:  ,multispace: ,leadmultispace: ,"
	vim.opt.list = true

	vim.lsp.set_log_level("OFF")

	vim.diagnostic.config({
		float = { border = "rounded" },
		-- float = true,
		virtual_text = false, -- default is true
		severity_sort = true, -- default is false
	})

	F.lazySetup()
	F.debug()
	M.bootstrap()
end

function F.copilot()
	require("copilot").setup({
		suggestion = { enabled = false },
		panel = { enabled = false },
		filetypes = {
			markdown = true,
		},
	})
	-- vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
	-- 	expr = true,
	-- 	replace_keycodes = false
	-- })
	-- vim.g.copilot_no_tab_map = true

	-- map('i', '<c-i>', 'copilot#Accept("\\<CR>")', {
	-- 	expr = true,
	-- 	replace_keycodes = false
	-- })
	-- vim.g.copilot_no_tab_map = true

	-- vim.cmd [[
	--        let g:copilot_no_tab_map = v:true
	--        imap <silent><script><expr> <C-I> copilot#Accept("\<CR>")
	--        " imap <silent><script><expr> <C-.> copilot#Next("\<CR>")
	--        " imap <silent><script><expr> <C-,> copilot#Previous("\<CR>")
	-- ]]
end

function F.gen()
	-- ollama gen
	-- llama2-uncensored
	-- require('gen').model = 'llama2-uncensored'
	require('gen').model = 'gemma2:2b' -- llama3.1
	require('gen').display_mode = "split"
	require('gen').show_prompt = true
	-- require('gen').container = nil
	require('gen').prompts['Fix_Code'] = {
		prompt =
		"Fix the following code. Only ouput the result in format ```$filetype\n...\n```:\n```$filetype\n$text\n```",
		replace = true,
		extract = "```$filetype\n(.-)```"
	}
	require('gen').prompts['Магия'] = {
		prompt =
		"Переформулируй грамматически верно мысль как писатель, на русском:\n$text\n\nНапиши только ответ. Используй максимум из доступных слов. Не обрывай предложения, закончи мысль, будь лаконичен и креативен. Следуй правилу: не больше 3x слов от оригинала.",
		replace = true
	}


	M.gen()
end

function F.comment()
	require('Comment').setup()
end

function F.debug()
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

	-- O command wrapper (:O map)
	-- https://vim.fandom.com/wiki/Capture_ex_command_output
	-- :O map
	-- :O hi
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
end

function F.lazySetup()
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
	if not vim.loop.fs_stat(lazypath) then
		vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"https://github.com/folke/lazy.nvim.git",
			"--branch=stable", -- latest stable release
			lazypath,
		})
	end
	vim.opt.rtp:prepend(lazypath)
	require("lazy").setup(F.unpackLazy(), {
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

function F.everforest_true()
	-- -- vim.g.everforest_diagnostic_text_highlight = 1
	vim.g.termguicolors = true
	vim.g.everforest_transparent_background = 1
	vim.g.everforest_current_word = 'grey background'
	vim.g.everforest_enable_italic = 0
	vim.g.everforest_disable_italic_comment = 1
	vim.g.everforest_ui_contrast = 'high'

	-- vim.g.everforest_colors_override = {
	-- 	['red'] = { '#f7908b', '167' },
	-- }
	vim.cmd [[
		colorscheme everforest
		" hi! Visual ctermbg=238 guibg=#475258
		" hi! Visual term=bold,reverse cterm=bold,reverse gui=bold,reverse
		hi! Visual term=reverse cterm=reverse gui=reverse
		hi CurrentWord ctermbg=240 guibg=#424e57
		hi link BqfPreviewBorder FloatermBorder
		hi CursorLine guibg=#2f393d
		hi CursorLineNr guibg=#2f393d

		hi ExtraWhitespaceNormal ctermbg=red guibg=red
		hi link ExtraWhitespaceInsert DiffDelete
		hi link ExtraWhitespace ExtraWhitespaceNormal
		match ExtraWhitespace /\s\+$/
		autocmd InsertEnter * hi link ExtraWhitespace ExtraWhitespaceInsert
		autocmd InsertLeave * hi link ExtraWhitespace ExtraWhitespaceNormal

	]]
end

function F.everforest()
	-- -- vim.g.everforest_diagnostic_text_highlight = 1
	vim.g.termguicolors = true
	vim.g.everforest_transparent_background = 1
	vim.g.everforest_current_word = 'grey background'
	vim.g.everforest_enable_italic = 0
	vim.g.everforest_disable_italic_comment = 1
	vim.g.everforest_ui_contrast = 'high'

	-- color: https://github.com/sainnhe/everforest/blob/master/autoload/everforest.vim
	-- links: https://github.com/sainnhe/everforest/blob/master/colors/everforest.vim
	vim.g.everforest_colors_override = {
		-- ['bg2'] = { '#3a3535', '235' }, -- FloatBorder
		['bg2'] = { '#423C3C', '235' }, -- FloatBorder
	}
	-- vim.g.everforest_lightline_disable_bold = 0
	-- vim.o.colorscheme = 'everforest'
	-- vim.cmd [[ colorscheme everforest ]]
	vim.cmd [[
		colorscheme everforest
		hi! Red ctermfg=167 guifg=#f7908b
		" hi! Keyword ctermfg=168 guifg=#f88e71
		" hi! Conditional ctermfg=168 guifg=#f88e71
		" hi! Statement ctermfg=168 guifg=#f88e71
		" hi! Repeat ctermfg=168 guifg=#f88e71
		" hi! Typedef ctermfg=168 guifg=#f88e71
		" hi! Exception ctermfg=168 guifg=#f88e71

		hi! DiffDelete guifg=#e67e80 ctermfg=167
		hi! DiffChange guifg=#83c092 ctermfg=108
		hi! DiffAdd guifg=#a7c080 ctermfg=142
		hi clear VertSplit
		"hi! VertSplit guifg=#3c3836
		hi! VertSplit guifg=#544f4c
		hi CurrentWord ctermbg=240 guibg=#585858
		hi link CursorLineSign CursorLineNr
		hi Co guibg=#413c3c
		hi CursorLine guibg=#413c3c
		hi CursorLineNr guibg=#413c3c
		"hi CursorLine guibg=#3b3737
		"hi CursorLineNr guibg=#3b3737
		hi! Whitespace ctermfg=238 guifg=#4c4747
		"hi! Visual ctermfg=235 ctermbg=109 guifg=#2f383e guibg=#7fbbb3
		hi! Visual ctermbg=238 guibg=#475258
		hi link IndentBlanklineSpaceCharBlankline Whitespace
		hi link IndentBlanklineChar         Whitespace
		hi link IndentBlanklineSpaceChar    Whitespace
		hi link IndentBlanklineContextChar  Whitespace
		hi link IndentBlanklineContextStart Whitespace

		hi ExtraWhitespaceNormal ctermbg=red guibg=red
		hi link ExtraWhitespaceInsert DiffDelete
		hi link ExtraWhitespace ExtraWhitespaceNormal
		match ExtraWhitespace /\s\+$/
		autocmd InsertEnter * hi link ExtraWhitespace ExtraWhitespaceInsert
		autocmd InsertLeave * hi link ExtraWhitespace ExtraWhitespaceNormal
	]]
end

function F.hop()
	require 'hop'.setup {
		-- keys = 'jfdkslahgurie',
		keys = 'fjdkslaghrutyeiwo',
	}
	M.hop()
end

function F.translate()
	require("pantran").setup {
		ui = { width_percentage = 0.95, height_percentage = 0.6 },
		default_engine = 'google',
		engines = {
			google = {
				default_target = 'ru',
				fallback = {
					default_target = 'ru'
				},
			},
		},
	}
	M.translate()
end

function F.treesitter()
	require('nvim-treesitter.configs').setup {
		['highlight'] = {
			['enable'] = true
		},
		['ensure_installed'] = {
			"lua",
			"rust",
			"go",
			"gotmpl",
			"python",
			"hcl",
			"yaml",
			"json",
			"vimdoc",
		},

		['incremental_selection'] = {
			['enable'] = true,
			['keymaps'] = {
				['node_incremental'] = ".", -- >
				-- ['init_selection'] = "gnn",
				-- ['scope_incremental'] = "grc",
				['node_decremental'] = ",", -- <
				-- ['node_incremental'] = "grn",
				-- ['scope_incremental'] = "grc",
				-- ['node_decremental'] = "grm",
			},
		},
		['indent'] = {
			['enable'] = false
		},

		['textobjects'] = {
			['select'] = {
				['enable'] = true,

				-- Automatically jump forward to textobj, similar to targets.vim
				['lookahead'] = true,

				['keymaps'] = {
					-- You can use the capture groups defined in textobjects.scm
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					["ic"] = "@class.inner",
				},
			},
			['swap'] = {
				['enable'] = true,
				['swap_next'] = {
					["<leader>el"] = "@parameter.inner",
				},
				['swap_previous'] = {
					["<leader>eh"] = "@parameter.inner",
				},
			},
			['move'] = {
				['enable'] = true,
				-- ['set_jumps'] = true, -- whether to set jumps in the jumplist
				['goto_next_start'] = {
					["]]"] = "@function.outer",
					-- ["]m"] = "@function.outer",
					-- ["]]"] = "@class.outer",
				},
				['goto_next_end'] = {
					["]["] = "@function.outer",
					-- ["]M"] = "@function.outer",
					-- ["]["] = "@class.outer",
				},
				['goto_previous_start'] = {
					["[["] = "@function.outer",
					-- ["[m"] = "@function.outer",
					-- ["[["] = "@class.outer",
				},
				['goto_previous_end'] = {
					["[]"] = "@function.outer",
					-- ["[M"] = "@function.outer",
					-- ["[]"] = "@class.outer",
				},
			},
			['lsp_interop'] = {
				['enable'] = false,
				['border'] = 'none',
				['peek_definition_code'] = {
					-- ['K'] = "@function.outer",
					-- ['<c-k>'] = "@class.outer",
				},
			},
		},

	}

	require('treesitter_indent_object').setup()

	M.treesitter()
end

function F.ctrlsf()
	vim.cmd [[
	let g:ctrlsf_default_root = 'cwd'
	let g:ctrlsf_context = '-B 3 -A 3'
	let g:ctrlsf_compact_winsize = '30%'
	let g:ctrlsf_winsize = '30%'
	"let g:ctrlsf_auto_focus = { "at" : "start" }
	let g:ctrlsf_populate_qflist = 1
	]]

	M.ctrlsf()
end

function F.colorizer()
	require('colorizer').setup({
		'css',
		'scss',
		'html',
		'yaml',
	})
end

function F.lualine()
	require('lualine').setup {
		['options'] = {
			['icons_enabled'] = false,
			['theme'] = 'everforest',
			['section_separators'] = { left = '▘', right = '▗' },
			['component_separators'] = '',
			['globalstatus'] = true,
		},
		['sections'] = {
			-- ['lualine_a'] = { { 'mode', fmt = function(str) return str:lower(); --[[str:sub(1, 3)[:lower()]] end } },
			-- ['lualine_a'] = { { 'mode', fmt = function(str) return str:sub(1, 1) end } },
			-- ['lualine_b'] = { 'branch' },
			['lualine_a'] = {},
			['lualine_b'] = { 'branch' },
			-- ['lualine_c'] = { '%{pathshorten(fnamemodify(expand("%:h"), ":~:.")) . "/" . (expand("%") == "" ? "[new]" :expand("%:t"))}', --[['filename',]] '%l', { 'aerial', ['sep'] = '::' } },
			['lualine_c'] = {
				-- '%{fnamemodify(expand("%:h"), ":.") . "/" . (expand("%") == "" ? "[new]" :expand("%:t"))}', --[['filename',]]
				{
					'filename',
					path = 1,
					shorting_target = 25,
					symbols = { modified = '*' }
				},
				'%l:%c|%v',
				'progress',
				'%S',
				-- { 'aerial', ['sep'] = '.' }
			},
			-- ['lualine_c'] = {
			-- 	'%l:%c/%v',
			-- 	'progress',
			-- },
			['lualine_x'] = {
				'searchcount',
				{
					'diagnostics',
					diagnostics_color = {
						error = 'DiagnosticSignError', -- Changes diagnostics' error color.
						warn  = 'DiagnosticSignWarn', -- Changes diagnostics' warn color.
						info  = 'DiagnosticSignInfo', -- Changes diagnostics' info color.
						hint  = 'DiagnosticSignHint', -- Changes diagnostics' hint color.
					},
				},
				'diff',
				-- 'filetype'
			},
			['lualine_y'] = { 'filesize' },
			['lualine_z'] = {},
		},
		['inactive_sections'] = {
			['lualine_a'] = {},
			['lualine_b'] = { 'filename' },
			['lualine_c'] = { '%l' },
			['lualine_x'] = {},
			['lualine_y'] = {},
			['lualine_z'] = {}
		},
		['extensions'] = { 'quickfix' },
	}
end

function F.gitsigns()
	-- vim.api.nvim_set_hl(0, 'GitSignsAdd', { link = 'GitSignsAdd' })
	-- vim.api.nvim_set_hl(0, 'GitSignsAddLn', { link = 'GitSignsAddLn' })
	-- vim.api.nvim_set_hl(0, 'GitSignsAddNr', { link = 'GitSignsAddNr' })
	-- vim.api.nvim_set_hl(0, 'GitSignsChange', { link = 'GitSignsChange' })
	-- vim.api.nvim_set_hl(0, 'GitSignsChangeLn', { link = 'GitSignsChangeLn' })
	-- vim.api.nvim_set_hl(0, 'GitSignsChangeNr', { link = 'GitSignsChangeNr' })
	-- vim.api.nvim_set_hl(0, 'GitSignsChangedelete', { link = 'GitSignsChange' })
	-- vim.api.nvim_set_hl(0, 'GitSignsChangedeleteLn', { link = 'GitSignsChangeLn' })
	-- vim.api.nvim_set_hl(0, 'GitSignsChangedeleteNr', { link = 'GitSignsChangeNr' })
	-- vim.api.nvim_set_hl(0, 'GitSignsDelete', { link = 'GitSignsDelete' })
	-- vim.api.nvim_set_hl(0, 'GitSignsDeleteLn', { link = 'GitSignsDeleteLn' })
	-- vim.api.nvim_set_hl(0, 'GitSignsDeleteNr', { link = 'GitSignsDeleteNr' })
	-- vim.api.nvim_set_hl(0, 'GitSignsTopdelete', { link = 'GitSignsDelete' })
	-- vim.api.nvim_set_hl(0, 'GitSignsTopdeleteLn', { link = 'GitSignsDeleteLn' })
	-- vim.api.nvim_set_hl(0, 'GitSignsTopdeleteNr', { link = 'GitSignsDeleteNr' })
	-- vim.api.nvim_set_hl(0, 'GitSignsUntracked', { link = 'GitSignsAdd' })
	-- vim.api.nvim_set_hl(0, 'GitSignsUntrackedLn', { link = 'GitSignsAddLn' })
	-- vim.api.nvim_set_hl(0, 'GitSignsUntrackedNr', { link = 'GitSignsAddNr' })

	require('gitsigns').setup({
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
	})
	M.gitsigns()
end

function F.fugitive()
	require "gitlinker".setup({
		opts = {
			remote = nil, -- force the use of a specific remote
			-- adds current line nr in the url for normal mode
			add_current_line_on_normal_mode = true,
			-- callback for what to do with the url
			action_callback = require "gitlinker.actions".copy_to_clipboard,
			-- print the url after performing the action
			print_url = true,
			mappings = nil,
		},
		mappings = nil, -- "<leader>gy"
		callbacks = {
			["github.com"] = require "gitlinker.hosts".get_github_type_url,
			["gitlab.com"] = require "gitlinker.hosts".get_gitlab_type_url,
			["try.gitea.io"] = require "gitlinker.hosts".get_gitea_type_url,
			["codeberg.org"] = require "gitlinker.hosts".get_gitea_type_url,
			["bitbucket.org"] = require "gitlinker.hosts".get_bitbucket_type_url,
			["try.gogs.io"] = require "gitlinker.hosts".get_gogs_type_url,
			["git.sr.ht"] = require "gitlinker.hosts".get_srht_type_url,
			["git.launchpad.net"] = require "gitlinker.hosts".get_launchpad_type_url,
			["repo.or.cz"] = require "gitlinker.hosts".get_repoorcz_type_url,
			["git.kernel.org"] = require "gitlinker.hosts".get_cgit_type_url,
			["git.savannah.gnu.org"] = require "gitlinker.hosts".get_cgit_type_url,
			["stash.msk.avito.ru"] = function(data)
				local url = 'https://' .. data.host ..
				    string.gsub(data.repo, '([^/]+)/(.+)', '/projects/%1/repos/%2/browse/') ..
				    data.file .. '?at=' .. data.rev
				if data.lstart then
					url = url .. '#' .. data.lstart
					if data.lend then
						url = url .. '-' .. data.lend
					end
				end
				return url
			end,
		},
	})

	M.fugitive()
end

function F.telekasten()
	vim.g.calendar_no_mappings = 0

	local home = vim.fn.expand("~/Mind")
	require('telekasten').setup({
		['home'] = home,
		['take_over_my_home'] = true,
		['auto_set_filetype'] = false,
		['dailies'] = home .. '/' .. 'daily',
		['weeklies'] = home .. '/' .. 'weekly',
		['templates'] = home .. '/' .. 'templates',
		-- markdown file extension
		['extension'] = ".md",
		-- template for new notes (new_note, follow_link)
		-- set to `nil` or do not specify if you do not want a template
		['template_new_note'] = home .. '/' .. 'templates/new_note.md',
		-- template for newly created daily notes (goto_today)
		-- set to `nil` or do not specify if you do not want a template
		['template_new_daily'] = home .. '/' .. 'templates/daily.md',
		-- template for newly created weekly notes (goto_thisweek)
		-- set to `nil` or do not specify if you do not want a template
		['template_new_weekly'] = home .. '/' .. 'templates/weekly.md',
		-- image link style
		-- wiki:     ![[image name]]
		-- markdown: ![](image_subdir/xxxxx.png)
		['image_link_style'] = "markdown",
		-- integrate with calendar-vim
		['plug_into_calendar'] = true,
		['calendar_opts'] = {
			-- calendar week display mode: 1 .. 'WK01', 2 .. 'WK 1', 3 .. 'KW01', 4 .. 'KW 1', 5 .. '1'
			['weeknm'] = 4,
			-- use monday as first day of week: 1 .. true, 0 .. false
			['calendar_monday'] = 1,
			-- calendar mark: where to put mark for marked days: 'left', 'right', 'left-fit'
			['calendar_mark'] = 'left-fit',
		},
		['close_after_yanking'] = false,
		['insert_after_inserting'] = true,
		-- tag notation: '#tag', ':tag:', 'yaml-bare'
		['tag_notation'] = "#tag",
		-- command palette theme: dropdown (window) or ivy (bottom panel)
		['command_palette_theme'] = "ivy",
		-- tag list theme:
		-- get_cursor: small tag list at cursor; ivy and dropdown like above
		['show_tags_theme'] = "ivy",
		-- when linking to a note in subdir/, create a [[subdir/title]] link
		-- instead of a [[title only]] link
		['subdirs_in_links'] = true,
		-- template_handling
		-- What to do when creating a new note via `new_note()` or `follow_link()`
		-- to a non-existing note
		-- - prefer_new_note: use `new_note` template
		-- - smart: if day or week is detected in title, use daily / weekly templates (default)
		-- - always_ask: always ask before creating a note
		['template_handling'] = "smart",
		-- path handling:
		--   this applies to:
		--     - new_note()
		--     - new_templated_note()
		--     - follow_link() to non-existing note
		--
		--   it does NOT apply to:
		--     - goto_today()
		--     - goto_thisweek()
		--
		--   Valid options:
		--     - smart: put daily-looking notes in daily, weekly-looking ones in weekly,
		--              all other ones in home, except for notes/with/subdirs/in/title.
		--              (default)
		--
		--     - prefer_home: put all notes in home except for goto_today(), goto_thisweek()
		--                    except for notes with subdirs/in/title.
		--
		--     - same_as_current: put all new notes in the dir of the current note if
		--                        present or else in home
		--                        except for notes/with/subdirs/in/title.
		['new_note_location'] = "smart",
		-- should all links be updated when a file is renamed
		['rename_update_links'] = true,
	})

	vim.cmd [[
		autocmd FileType calendar setlocal signcolumn=no

		hi link tkLink markdownLinkText
		hi link tkHighlight Search
		hi link tkTag markdownBold
		]]

	M.telekasten()
end

function F.zen_mode()
	require("zen-mode").setup {
		plugins = {
			gitsigns = { enabled = true },
			options = { laststatus = 0 },
			tmux = { enabled = true },
		},
		-- tmux = { enabled = true },
		-- https://github.com/folke/zen-mode.nvim#%EF%B8%8F-configuration
	}
	M.zen_mode()
end

function F.telescope()
	local tscope = require("telescope")
	local actions = require("telescope.actions")
	local fb_actions = require("telescope._extensions.file_browser.actions")
	local opts = {
		['defaults'] = {
			['layout_strategy'] = 'vertical',
			['layout_config'] = {
				['vertical'] = {
					['prompt_position'] = 'top',
					['height'] = 0.95,
					['width'] = 0.95,
				},
				['bottom_pane'] = {
					['height'] = 0.9999,
					['width'] = 0.9999,
				},
				['center'] = {
					['width'] = 0.9999,
					['height'] = 0.9999,
					['prompt_position'] = 'top',
				},
			},
			['sorting_strategy'] = 'ascending',
			['prompt_prefix'] = '',
			-- ['path_display'] = 'truncate',

			['file_ignore_patterns'] = { '.git/' },
			['hidden'] = true,
			['mappings'] = {
				['i'] = {
					['<C-/>'] = actions.which_key
				},
				['n'] = {
					['<C-/>'] = actions.which_key,
					['o'] = actions.select_default,
					-- ['<C-H>'] = actions.toggle_hidden,
				},
			},
		},
		['pickers'] = {
			['live_grep'] = {
				['additional_args'] = function(_)
					return { "--hidden" }
				end
			},
		},
		['extensions'] = {
			['fzf'] = {
				['fuzzy'] = true, -- false will only do exact matching
				['override_generic_sorter'] = true, -- override the generic sorter
				['override_file_sorter'] = true, -- override the file sorter
				['case_mode'] = "smart_case", -- or "ignore_case" or "respect_case"
				-- the default case_mode is "smart_case"
			},
			['file_browser'] = {
				['theme'] = "ivy",
				['hijack_netrw'] = true,
				['layout_config'] = {
					['height'] = 0.8,
					-- ['vertical'] = {
					-- 	['height'] = 70,
					-- }
				},
				['mappings'] = {
					["i"] = {
						-- 	['<c-n>'] = require('telescope.actions').results_scrolling_down,
						-- 	['<c-p>'] = require('telescope.actions').results_scrolling_up,
						['<c-e>'] = fb_actions.toggle_browser,
						['<C-f>'] = false,
					},
					["n"] = {
						['f'] = false,
						['h'] = fb_actions.goto_parent_dir,
						['e'] = fb_actions.toggle_browser,
						['.'] = fb_actions.toggle_hidden,
						['l'] = actions.select_default,
					},
				},
				['hidden'] = true,
				['dir_icon'] = '▸',
				-- ['dir_icon'] = ' ',
				['grouped'] = true,
				['follow_symlinks'] = true,
				['select_buffer'] = true,
				['hide_parent_dir'] = true,
				['prompt_path'] = true,
				-- ['depth'] = 1,
				-- ['folder_browser'] = {
				-- 	['files'] = true,
				-- },
			},
			['ui-select'] = {
				require("telescope.themes").get_dropdown {
					-- even more opts
				}

				-- pseudo code / specification for writing custom displays, like the one
				-- for "codeactions"
				-- specific_opts = {
				--   [kind] = {
				--     make_indexed = function(items) -> indexed_items, width,
				--     make_displayer = function(widths) -> displayer
				--     make_display = function(displayer) -> function(e)
				--     make_ordinal = function(e) -> string
				--   },
				--   -- for example to disable the custom builtin "codeactions" display
				--      do the following
				--   codeactions = false,
				-- }
			},
		},
	}
	-- opts['defaults'] = vim.tbl_deep_extend('force', opts['defaults'], require('telescope.themes').get_dropdown({
	-- 	['width'] = 1.0,
	-- }))

	tscope.setup(opts)

	tscope.load_extension('fzf')
	tscope.load_extension('file_browser')
	tscope.load_extension('ui-select')

	-- require("harpoon").setup({})
	-- require('telescope').load_extension('harpoon')

	M.telescope()
end

function F.dap()
	require("dap-go").setup()
	require("nvim-dap-virtual-text").setup()
	vim.g['test#strategy'] = 'neovim'

	M.testing()
end

function F.lint()
	local lint = require('lint')
	lint.linters_by_ft = vim.tbl_deep_extend('force', lint.linters_by_ft, {
		-- ['markdown'] = { 'vale', },
		['go'] = { 'golangcilint' },
	})

	vim.cmd([[
		augroup lint_augroup
		autocmd!
		autocmd BufWritePost <buffer> lua require('lint').try_lint()
		augroup end
		]])
end

function F.cmp()
	-- load snippets
	require("luasnip.loaders.from_snipmate").lazy_load()

	-- completion
	local _, luasnip = pcall(require, 'luasnip')
	local cmp = require 'cmp'

	local config = {
		['window'] = {
			-- ['completion'] = cmp.config.window.bordered(),
			['documentation'] = cmp.config.window.bordered(),
		},
		['mapping'] = cmp.mapping.preset.insert({
			-- command line selection
			['<c-j>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
			['<c-k>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),

			-- insert mode selection
			['<c-n>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i' }),
			['<c-p>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i' }),

			-- info scrolling like for telescope
			['<c-u>'] = cmp.mapping.scroll_docs(-4),
			['<c-d>'] = cmp.mapping.scroll_docs(4),

			-- snipet expand
			["<tab>"] = cmp.mapping(function(fallback)
				if luasnip.expandable() then
					luasnip.expand()
				else
					fallback()
				end
			end, { "i", "s" }),

			-- snipet jumps
			["<a-l>"] = cmp.mapping(function(fallback)
				if luasnip.jumpable(1) then
					luasnip.jump(1)
				else
					fallback()
				end
			end, { "i", "s" }),
			["<a-h>"] = cmp.mapping(function(fallback)
				if luasnip.jumpable(-1) then
					luasnip.jump(-1)
				else
					fallback()
				end
			end, { "i", "s" }),

			-- snipet choices
			["<a-j>"] = cmp.mapping(function(fallback)
				if luasnip.choice_active() then
					luasnip.change_choice(1)
				else
					fallback()
				end
			end, { "i", "s" }),

			["<a-k>"] = cmp.mapping(function(fallback)
				if luasnip.choice_active() then
					luasnip.change_choice(-1)
				else
					fallback()
				end
			end, { "i", "s" }),
			["<a-q>"] = cmp.mapping(function(fallback)
				if luasnip.in_snippet() then
					luasnip.unlink_current()
				else
					fallback()
				end
			end, { "i", "s" }),

			-- confimration
			['<c-q>'] = cmp.mapping.abort(),
			['<cr>'] = cmp.mapping.confirm({ select = false }),
			['<c-y>'] = cmp.mapping.confirm({ select = true }),
		}),
		['snippet'] = {
			-- REQUIRED - you must specify a snippet engine
			['expand'] = function(args)
				require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
			end,
		},
		['sources'] = cmp.config.sources({
			{ ['name'] = 'copilot' },
			{ ['name'] = 'nvim_lsp' },
			{ ['name'] = 'nvim_lua' },
			{ ['name'] = 'luasnip' },
			{ ['name'] = 'cmp_ai' },
		}, {
			{ name = 'buffer', option = { keyword_pattern = [[\k\+]] } },
		}),
		['history'] = false,
		['preselect'] = cmp.PreselectMode.None
	}

	cmp.setup(config)

	-- `/` cmdline setup.
	cmp.setup.cmdline('/', {
		-- mapping = cmp.mapping.preset.cmdline(),
		sources = {
			{ name = 'buffer' }
		}
	})

	-- `:` cmdline setup.
	cmp.setup.cmdline(':', {
		-- mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = 'path' }
		}, {
			{ name = 'cmdline' }
		})
	})
end

function F.cmp_ai()
	local cmp_ai = require('cmp_ai.config')
	cmp_ai:setup({
		max_lines = 100,
		provider = 'Ollama',
		provider_options = {
			stream = true,
			model = 'codellama:7b-code',
		},
		notify = true,
		notify_callback = function(msg)
			vim.notify(msg)
		end,
		run_on_every_keystroke = true,
		ignored_file_types = {
			-- default is not to ignore
			-- uncomment to ignore in lua:
			-- lua = true
		},
	})
end

function F.diffview()
	require("diffview").setup({
		['use_icons'] = false,
		['icons'] = {
			['folder_closed'] = "-",
			['folder_open'] = "+",
		},
		['signs'] = {
			['fold_closed'] = "-",
			['fold_open'] = "+",
		},
	})
end

function F.lspconfig()
	require('mason').setup {
		ui = {
			width = 0.95,
			height = 0.9,
		}
	}
	require('neodev').setup {}

	local servers = {
		pyright = {},
		rust_analyzer = {},
		terraformls = {},
		tflint = {},
		bashls = {},
		jsonls = {},
		helm_ls = {},
		yamlls = {
			-- https://github.com/gorkem/yaml-language-server/blob/main/src/yamlSettings.ts#L11
			-- see interface Settings
			['yaml'] = {
				-- ['keyordering'] = false,
				-- ['key_ordering'] = false,
				['keyOrdering'] = false,
			},
		},
		marksman = {},
		dagger = {}, -- cue
		-- clangd = {},
		-- tsserver = {},
		gopls = {
			gopls = {
				-- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
				experimentalPostfixCompletions = true,
				-- experimentalWorkspaceModule = true,
				templateExtensions = { 'gotpl', 'gotmpl' },
				-- buildFlags = {'integration'},
				gofumpt = true,
				staticcheck = true,
				analyses = {
					-- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
					-- disabled by default:
					unusedparams = true, --
					unusedvariable = true,
					shadow = false, -- !!!
					fieldalignment = true, -- !!!
					nilness = true, --
					unusedwrite = true, --
					useany = true, --
				},
				codelenses = {
					gc_details = true,
					-- gc_details = false,
					generate = true,
					regenerate_cgo = true,
					test = true,
					tidy = true,
					vendor = true,
					upgrade_dependency = true,
					-- annotations = { bounds = true, escape = true, inline = true, ['nil'] = true }
				},
			},
		},
		lua_ls = {
			Lua = {
				workspace = { checkThirdParty = false },
				telemetry = { enable = false },
			},
		},
	}

	local mason = require 'mason-lspconfig'

	mason.setup {
		ensure_installed = vim.tbl_keys(servers),
	}

	local capabilities = require('cmp_nvim_lsp').default_capabilities(
		vim.lsp.protocol.make_client_capabilities()
	)

	-- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization
	-- local border = {
	-- 	{ "🭽", "FloatBorder" },
	-- 	{ "▔",  "FloatBorder" },
	-- 	{ "🭾", "FloatBorder" },
	-- 	{ "▕",  "FloatBorder" },
	-- 	{ "🭿", "FloatBorder" },
	-- 	{ "▁",  "FloatBorder" },
	-- 	{ "🭼", "FloatBorder" },
	-- 	{ "▏",  "FloatBorder" },
	-- }

	mason.setup_handlers {
		function(server_name)
			require('lspconfig')[server_name].setup {
				capabilities = capabilities,
				settings = servers[server_name],
				on_attach = function(client, bufnr)
					-- bufnr = bufnr

					-- map keys
					M.lsp()

					-- signature helps
					require("lsp_signature").on_attach({
						bind = true,
						handler_opts = {
							border = "rounded"
						},
						floating_window = true,
						hint_enable = false,
						hint_prefix = '█ ',
					}, bufnr)

					-- require 'lsp-lens'.setup({})

					-- require("virtualtypes").on_attach(client, bufnr)

					local cap = client.server_capabilities
					-- format on save
					-- see https://github.com/neovim/neovim/pull/17814/files#diff-a12755025a01c2415c955ca2d50e3d40f9e26df70f712231085d3ff96b2bc837R821
					if cap.documentHighlightProvider then
						vim.cmd [[autocmd CursorMoved <buffer> lua pcall(vim.lsp.buf.clear_references); pcall(vim.lsp.buf.document_highlight)]]
						-- vim.cmd [[autocmd CursorHold  <buffer> lua pcall(vim.lsp.buf.document_highlight)]]
						-- vim.cmd[[autocmd CursorHoldI <buffer> lua pcall(vim.lsp.buf.document_highlight)]]
					end
					if cap.documentFormattingProvider then
						vim.cmd [[autocmd BufWritePre <buffer> lua pcall(vim.lsp.buf.format)]]
					end
					-- https://github.com/neovim/neovim/pull/17814/files#diff-3319ec2c423f139a0da97179848b61fc4a17dc77951ccfe22697699992285106R261
					if type(cap.codeLensProvider) == 'table' and cap.codeLensProvider.resolveProvider then
						-- vim.schedule_wrap(vim.lsp.codelens.run)
						vim.schedule_wrap(vim.lsp.codelens.refresh)
						vim.cmd [[autocmd BufEnter,InsertLeave,BufWritePost <buffer> lua vim.schedule_wrap(vim.lsp.codelens.refresh)]]
					end
				end,
				handlers = {
					["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
						-- border = border
						border = 'rounded'
						-- focusable = false
					}),
					["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
						-- border = border
						border = 'rounded'
					}),
				},
			}
		end,
	}

	-- local null_ls = require("null-ls")
	-- null_ls.setup({
	-- 	sources = {
	-- 		null_ls.builtins.diagnostics.golangci_lint,
	-- 		-- null_ls.builtins.diagnostics.gospel,
	-- 		-- null_ls.builtins.formatting.stylua,
	-- 		-- null_ls.builtins.diagnostics.eslint,
	-- 		-- null_ls.builtins.completion.spell,
	-- 	},
	-- })

	require("fidget").setup {
		['window'] = {
			['blend'] = 0,
			-- ['border'] = 'solid',
		},
		['fmt'] = {
			['max_width'] = 50,
		}
	}

	-- require("aerial").setup({
	-- 	['on_attach'] = function()
	-- 		M.aerial()
	-- 	end,
	-- 	['default_bindings'] = true,
	-- 	-- ['filter_kind'] = false, -- show all symbolls
	-- 	['highlight_on_hover'] = true,
	-- 	-- ['close_behavior'] = 'global',
	-- 	-- ['placement_editor_edge'] = false,
	-- 	['layout'] = {
	-- 		['placement'] = 'edge',
	-- 		['placement_editor_edge'] = false,
	-- 	}
	-- })

	-- require('dim').setup {
	-- 	disable_lsp_decorations = false
	-- }
end

--
F.bootstrap()
--
