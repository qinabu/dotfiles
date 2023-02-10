F = {}
M = {}

local map = vim.keymap.set

local NSE = { noremap = true, silent = true, expr = true }
local NS = { noremap = true, silent = true }
local N = { noremap = true }

-- TODO:
-- luasnip
--
-- https://github.com/ziontee113/syntax-tree-surfer -- movements
--
-- use { 'ThePrimeagen/harpoon', config = 'require("configs").harpoon()' }
-- use {
-- 	'nvim-neotest/neotest',
-- 	requires = {
-- 		'mfussenegger/nvim-dap',
-- 		'nvim-neotest/neotest-go',
-- 		'nvim-neotest/neotest-python',
-- 		'nvim-neotest/neotest-vim-test',

-- 		'nvim-lua/plenary.nvim',
-- 		'nvim-treesitter/nvim-treesitter',
-- 		'antoinemadec/FixCursorHold.nvim'
-- 	},
-- 	config = 'require("configs").neotest()'
-- }


function F.unpackPacker(use)
	use { 'wbthomason/packer.nvim', opt = false }

	-- [[ UI ]] --
	-- use { 'sainnhe/gruvbox-material', config = F.gruvbox_material }
	use { 'sainnhe/everforest', config = F.everforest }
	use { 'folke/zen-mode.nvim', config = F.zen_mode }
	use { 'szw/vim-maximizer' } -- :MaximizerToggle
	use { 'itchyny/vim-qfedit' }
	use { 'kevinhwang91/nvim-bqf', ft = 'qf', config = function() require('bqf').setup {} end }
	use { 'simeji/winresizer', config = M.winresizer }
	use { 'nvim-lualine/lualine.nvim', config = F.lualine }
	use { 'kyazdani42/nvim-tree.lua', config = F.nvim_tree }
	use { 'nvim-telescope/telescope.nvim',
		requires = {
			{ 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
			'nvim-lua/plenary.nvim',
			'nvim-telescope/telescope-file-browser.nvim',
			'nvim-telescope/telescope-ui-select.nvim',
			'nvim-telescope/telescope-dap.nvim',
		},
		config = F.telescope,
	}

	-- [[ EDIT ]]
	use { 'phaazon/hop.nvim', config = F.hop }
	use { 'dyng/ctrlsf.vim', config = F.ctrlsf } -- find & replace
	use { 'tpope/vim-commentary' } -- comments
	use { 'tpope/vim-surround' }
	use { 'tpope/vim-repeat' }

	-- [[ LSP ]] --
	use { 'neovim/nvim-lspconfig',
		requires = {
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',
			'folke/neodev.nvim',

			'hrsh7th/nvim-cmp',
			'hrsh7th/cmp-nvim-lsp',
			'stevearc/aerial.nvim',
			'ray-x/lsp_signature.nvim',
			'j-hui/fidget.nvim',
		},
		config = F.lspconfig,
	}

	-- [[ LINT ]]
	-- ...

	-- [[ COMPLETION ]] --
	use { 'hrsh7th/nvim-cmp',
		requires = {
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
		config = function() F.cmp() end,
	}

	-- [[ LANGUAGES ]]
	use { 'nvim-treesitter/nvim-treesitter',
		requires = {
			'nvim-treesitter/playground', -- :TSPlaygroundToggle
			'nvim-treesitter/nvim-treesitter-textobjects',
			'romgrk/nvim-treesitter-context',
			'mfussenegger/nvim-ts-hint-textobject', -- Scope selection by m
			'jubnzv/virtual-types.nvim',
		},
		run = ':TSUpdate',
		config = F.treesitter,
	}
	use { 'jjo/vim-cue' }
	-- https://mermaid-js.github.io/ -- https://mermaid.live/
	use { 'iamcco/markdown-preview.nvim',
		run = function() vim.fn["mkdp#util#install"]() end,
	}

	-- [[ VCS ]]
	use { 'tpope/vim-fugitive',
		requires = {
			'nvim-lua/plenary.nvim',
			'ruifm/gitlinker.nvim',
		},
		config = F.fugitive,
	}
	use { 'lewis6991/gitsigns.nvim',
		requires = { 'nvim-lua/plenary.nvim' },
		-- config = require("configs").gitsigns,
		config = F.gitsigns,
	}
	use { 'sindrets/diffview.nvim',
		requires = { 'nvim-lua/plenary.nvim' },
		config = F.diffview,
		-- config = require("configs").diffview,
	}

	-- [[ DEBUG / TESTINGS ]]
	use { 'mfussenegger/nvim-dap',
		requires = {
			'vim-test/vim-test',
			'nvim-treesitter/nvim-treesitter',
			'theHamsta/nvim-dap-virtual-text',
			'nvim-telescope/telescope-dap.nvim',
			'leoluz/nvim-dap-go',
		},
		config = F.dap,
	}
	-- [[ NOTE TAKING ]]
	use { 'renerocksai/telekasten.nvim',
		requires = { 'nvim-telescope/telescope.nvim' },
		config = F.telekasten,
	}
end

function M.bootstrap()
	vim.g.mapleader = " "
	map('', '<space>', '<nop>', NS)

	-- Vim
	map('n', '<leader>q', ':qall<cr>', N)
	map('n', '<leader>Q', ':qall!<cr>', N)

	map('n', '<leader>bq', ':bdelete<cr>', N)
	map('n', '<leader>bQ', ':bdelete!<cr>', N)

	map('n', '<leader>tq', ':tabclose<cr>', N)
	map('n', '<leader>tQ', ':tabclose!<cr>', N)

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
	map('n', '<c-o>', '<c-o>zz', N) -- Window modification prefix
	map('n', '<c-i>', '<c-i>zz', N) -- Window modification prefix

	map('n', '<leader>w', '<c-w>', N) -- Window modification prefix
	map('n', '<leader>w?', ':help CTRL-W<cr>', N) -- Window modification prefix

	map('n', '<leader>h', '<c-w>h', NS)
	map('n', '<leader>l', '<c-w>l', NS)
	map('n', '<leader>j', '<c-w>j', NS)
	map('n', '<leader>k', '<c-w>k', NS)

	map('n', '<ScrollWheelUp>', '<c-y>', NS)
	map('n', '<ScrollWheelDown>', '<c-e>', NS)

	map('n', '<leader>p', '<c-^>zz', NS) -- previous buffer

	map('n', '<leader>d', ':NvimTreeFindFileToggle<cr>', NS)
	-- map('n', '<leader>d', ':NvimTreeFindFile<cr>', NS)

	-- Options
	map('n', '<leader>oO', ':only<cr>', NS)
	map('n', '<leader>oo', ':MaximizerToggle!<cr>', NS)

	map('n', '<leader>on', ':setlocal number!<cr>', NS)
	map('n', '<leader>oN', ':setlocal relativenumber!<cr>', NS)

	map('n', '<leader>os', ':setlocal spell!<cr>', NS)

	map('n', '<leader>ol', ':setlocal list!<cr>', NS)
	map('n', '<leader>ow', ':setlocal nowrap! linebreak!<cr>', NS)

	map('n', '<leader>oc', ':lua vim.wo.colorcolumn = (vim.wo.colorcolumn == "" and "72,80,100,120" or "")<cr>', NS)
	map('n', '<leader>ot', ':lua vim.opt.tabstop = (vim.opt.tabstop:get() ~= 8 and 8 or 4)<cr>', NS)

	-- Command line
	map('n', '<leader>;', ':', N) -- Command line
	map('v', '<leader>;', ':', N) -- Command line
	map('n', "<leader>'", '@:', N) -- Repeat last command
	map('n', "<leader>1", ':!', N) -- Exec
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
	map('n', '<leader>s', ':write<cr>', N) -- Write changes
	map('n', '<leader><leader>s', ':noautocmd write<cr>', N) -- Write buffer as is
	map('n', '<leader>S', ':wall<cr>', N) -- Write chages of all buffers
	map('n', '<leader>bd', ':bdelete<cr>', N) -- Delete current buffer

	-- Edit
	map('i', '<esc>', '<esc>`^', NS) -- Keep cursor on the same positioni

	map('n', 'j', 'gj', NS)
	map('n', 'k', 'gk', NS)
	map('i', '<down>', '<c-o>gj', NS)
	map('i', '<up>', '<c-o>gk', NS)

	map('n', '<leader>ee', '*Ncgn', NS)
	map('v', '<leader>ee', "\"sy:let @/='\\V'.@s<CR>cgn", NS)
	map('v', '<leader>er', '"hy:%s/<C-r>h//gc<left><left><left>', N)

	map('v', 'K', ":move '<-2<cr>gv=gv", NS)
	map('v', 'J', ":move '>+1<cr>gv=gv", NS)

	map('v', 'p', '"_dP', NS) -- TODO: if selection at the end of line P should be replaced with p
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
	map('v', '<c-l>', '$', N)



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

	map('n', '<leader>)', ':silent! colder<cr>', NS)
	map('n', '<leader>(', ':silent! cnewer<cr>', NS)
end

function M.hop()
	-- map('n', 's', ':HopChar1<cr>', NS)
	map('n', 's', ':HopChar2<cr>', NS)
	-- map('n', 'S', ':lua require("hop").hint_words({keys="fjdkslaghruty"})<cr>', NS)
	map('n', 'S', ':lua require("hop").hint_words()<cr>', NS)
end

function M.harpoon()
	-- map('n', '<leader>m', ':lua require("harpoon.ui").toggle_quick_menu()<cr>', NS)
	-- map('n', '<leader>h', ':lua require("harpoon.mark").add_file()<cr>', NS)
end

function M.treesitter()
	-- mfussenegger/nvim-ts-hint-textobject
	-- require("tsht").config.hint_keys = { "a", "s", "d", "f", "j", "k", "l", "g", "h" }
	require("tsht").config.hint_keys = { "f", "j", "d", "k", "s", "l", "a", "g", "h" }
	map('o', 'm', ':<c-u>lua require("tsht").nodes()<cr>', NS)
	map('v', 'm', ':lua require("tsht").nodes()<cr>', NS)
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
	map('n', 'gr', ':lua vim.lsp.buf.references()<cr>', NS)
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
	map('n', '<leader>fF', ':Telescope<cr>', NS)
	map('n', '<leader>ft', ':Telescope tagstack initial_mode=normal<cr>', NS)
	map('n', '<leader>ff', ':Telescope find_files hidden=true<cr>', NS)
	map('n', '<leader>fg', ':Telescope live_grep hidden=true<cr>', NS)
	map('n', '<leader>f/', ':Telescope current_buffer_fuzzy_find<cr>', NS)
	map('n', '<leader>fk', ':Telescope keymaps<cr>', NS)
	map('n', '<leader>fh', ':Telescope git_status initial_mode=normal<cr>', NS)
	map('n', '<leader>fd', ':Telescope file_browser theme=ivy initial_mode=normal<cr>', NS)
	map('n', '<leader>fr', ':Telescope file_browser theme=ivy initial_mode=normal path=%:p:h<cr>', NS)
	map('n', '<leader>fs', ':Telescope lsp_document_symbols symbol_width=60<cr>', NS)
	map('n', '<leader>fw', ':Telescope lsp_dynamic_workspace_symbols symbol_width=60 fname_width=50<cr>', NS)
	map('n', '<leader>fb', ':Telescope buffers initial_mode=normal<cr>', NS)
	map('n', '<leader>fm', ':Telescope marks initial_mode=normal<cr>', NS)
	map('n', '<leader>fj', ':Telescope jumplist initial_mode=normal<cr>', NS)
	map('n', '<leader>fa', ':Telescope man_pages<cr>', NS)

end

function M.luasnip()
	-- expand or jump
	-- map('i', '<tab>', "luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<tab>'", { expr = true })

	-- select mode jumps
	map('s', '<tab>', '<cmd>lua require("luasnip").jump(1)<cr>', {})
	map('s', '<s-tab>', '<cmd>lua require("luasnip").jump(-1)<cr>', {})

	-- choose variants
	map('i', '<C-n>', '<Plug>luasnip-next-choice', {})
	map('s', '<C-n>', '<Plug>luasnip-next-choice', {})
	map('i', '<C-p>', '<Plug>luasnip-prev-choice', {})
	map('s', '<C-p>', '<Plug>luasnip-prev-choice', {})

	-- map('i', '<c-.>', "luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<c-.>'", { expr = true })
	-- map('s', '<c-.>', "luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<c-.>'", { expr = true })

	map('i', '<c-,>', "luasnip#choice_active() ? '<Plug>luasnip-prev-choice' : '<c-,>'", { expr = true })
	map('s', '<c-,>', "luasnip#choice_active() ? '<Plug>luasnip-prev-choice' : '<c-,>'", { expr = true })
end

function M.neotest()
	map('n', '<leader><leader>tt', ':lua require("neotest").run.run()<cr>', NS)
	map('n', '<leader><leader>tT', ':lua require("neotest").run.run(vim.fn.expand("%"))<cr>', NS)
	map('n', '<leader><leader>td', ':lua require("neotest").run.run({strategy = "dap"})<cr>', NS)
	map('n', '<leader><leader>tw', ':lua require("neotest").summary.toggle()<cr>', NS)

end

function M.testing()
	-- DAP
	map('n', '<leader>tf', ':Telescope dap commands<cr>', NS)
	map('n', '<leader>tq', ':lua require("dap").close()<cr>:DapVirtualTextDisable<cr>', NS)

	map('n', '<leader>tg', ':lua require("dap-go").debug_test()<cr>', NS)

	map('n', '<leader>td', ':DapVirtualTextEnable<cr>:lua require("dap").continue()<cr>', NS)
	map('n', '<leader>tD', ':DapVirtualTextEnable<cr>:lua require("dap").run_last()<cr>', NS)
	map('n', '<leader>tc', ':DapVirtualTextEnable<cr>:lua require("dap").run_to_cursor()<cr>', NS)

	map('n', '<leader>]', ':lua require("dap").step_over()<cr>', NS)
	map('n', '<leader>}', ':lua require("dap").step_into()<cr>', NS)
	map('n', '<leader>[', ':lua require("dap").step_out()<cr>', NS)

	map('n', '<leader>tb', ':lua require("dap").toggle_breakpoint()<cr>', NS)
	map('n', '<leader>tB', ':lua require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))<cr>', NS)
	map('n', '<leader>tL', ':lua require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<cr>', NS)
	map('n', '<leader>tr', ':lua require("dap").repl.open()<cr>', NS)

	-- VIM-TEST
	map('n', '<leader>tt', ':TestNearest -v<cr>', NS)
	map('n', '<leader>tT', ':TestFile -v<cr>', NS)
	map('n', '<leader>tl', ':TestLast -v<cr>', NS)
	map('n', '<leader>tv', ':TestVisit<cr>', NS)
end

function M.winresizer()
	vim.g.winresizer_start_key = '<leader>we'
end

function M.ctrlsf()
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
	map('n', '<leader>gl', ':0Gclog<cr>', NS)
	map('n', '<leader>gL', ':Gclog<cr>', NS)

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

function M.aerial()
	-- Toggle the aerial window with <leader>a
	-- map('n', '<leader>9', ':AerialToggle left<cr>', NS)
	map('n', '<leader>-', ':AerialToggle left<cr>', NS)
	-- Jump forwards/backwards with '{' and '}'
	map('n', '<leader>9', ':AerialPrev<cr>', NS)
	map('n', '<leader>0', ':AerialNext<cr>', NS)
	-- Jump up the tree with '[[' or ']]'
	-- map('n', '[[', ':AerialPrevUp<cr>', NS)
	-- map('n', ']]', ':AerialNextUp<cr>', NS)
end

function M.telekasten()

	map('n', '<leader>nn', ':lua require("telekasten").panel()<cr>', NS)

	-- add note
	map('n', '<leader>nA', ':lua require("telekasten").new_note()<cr>', NS)
	map('n', '<leader>na', ':lua require("telekasten").new_templated_note()<cr>', NS)

	-- find
	map('n', '<leader>nf', ':lua require("telekasten").find_notes()<cr>', NS)
	map('n', '<leader>nF', ':lua require("telekasten").search_notes()<cr>', NS)

	-- today
	map('n', '<leader>nt', ':lua require("telekasten").goto_today()<cr>', NS)
	map('n', '<leader>nd', ':lua require("telekasten").find_daily_notes()<cr>', NS)

	-- week
	map('n', '<leader>nw', ':lua require("telekasten").goto_thisweek()<cr>', NS)
	map('n', '<leader>nW', ':lua require("telekasten").find_weekly_notes()<cr>', NS)

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
	-- Basic
	vim.opt.shm:append("I") -- blank :intro
	vim.o.clipboard = "unnamed"
	vim.o.paste = false
	vim.o.encoding = "utf-8"
	vim.cmd [[set spelllang=en_us,ru_yo]]
	vim.o.maxmempattern = 5000

	vim.o.keymap = "russian-jcukenmac" -- <c-l> for change language
	vim.o.iminsert = 0
	vim.o.imsearch = 0
	vim.o.inccommand = 'split'

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
	-- t:textwidth, c:textwith comments, q:comments, r:auto indent, n:lists, 1:don't break one-letter word.
	-- vim.o.formatoptions = "tcqrn1"
	vim.o.formatoptions = "qjrn1"
	vim.o.textwidth = 100

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
	vim.o.termguicolors = true
	vim.o.mouse = 'a'
	vim.o.cursorline = true
	vim.o.showmode = false
	vim.o.showcmd = false
	-- vim.o.fillchars = 'vert:▞,horiz:▞,eob: '
	vim.o.fillchars = 'eob: '
	-- vim.o.background = 'dark'
	vim.o.scrolloff = 3 -- offset lines
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

	-- vim.o.listchars = "eol: ,space: ,lead:┊,trail:·,nbsp:◇,tab:  ,extends:▸,precedes:◂,multispace:···•,leadmultispace:┊ ,"
	vim.o.listchars = "eol: ,space: ,lead:┊,trail:·,nbsp:◇,tab:❭ ,multispace:···•,leadmultispace:┊ ,"
	vim.o.list = true

	vim.diagnostic.config({
		float = true,
		virtual_text = false, -- default is true
		severity_sort = true, -- default is false
	})

	F.packerStartup()
	F.debug()
	F.lspconfig()
	M.bootstrap()
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

function F.packerStartup()
	local installed = false
	local path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

	if vim.fn.empty(vim.fn.glob(path)) > 0 then
		vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', path }
		installed = (vim.v.shell_error == 0)
	end

	vim.cmd [[packadd packer.nvim]]

	vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
		group = vim.api.nvim_create_augroup('packerUserConfig', {}),
		pattern = { 'init.lua' },
		command = 'PackerCompile | source $MYVIMRC',
	})

	local packer = require('packer')
	packer.startup({ F.unpackPacker, config = {
		log = { level = 'error' },
	} })
	-- Sync the first lauch
	if installed then
		packer.sync()
	end
end

function F.gruvbox_material()
	vim.g.termguicolors = true
	vim.cmd [[
		let g:gruvbox_material_colors_override = {'fg0':['#d7cab4', 1]}
		let g:gruvbox_material_transparent_background = 1
		let g:gruvbox_material_background = 'meduim' "'soft'
		let g:gruvbox_material_foreground = 'material'
		let g:gruvbox_material_disable_italic_comment = 1
		let g:gruvbox_material_enable_bold = 1
		let g:gruvbox_material_visual = 'grey background'
		let g:gruvbox_material_diagnostic_line_highlight = 1
		let g:gruvbox_material_current_word = 'grey background'
		let g:gruvbox_material_dim_inactive_windows = 1
		set background=dark
		colorscheme gruvbox-material

		hi clear VertSplit
		hi! VertSplit guifg=#544f4c
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
		keys = 'jfdkslahgurie',
	}
	M.hop()
end

function F.nvim_tree()
	local tmap = require('nvim-tree.config').nvim_tree_callback
	require('nvim-tree').setup {
		['renderer'] = {
			['highlight_opened_files'] = 'all',
			['highlight_git'] = true,
			['root_folder_modifier'] = ':~:.',
			['add_trailing'] = true,
			['special_files'] = {},
			['icons'] = {
				['show'] = {
					['git'] = false,
					['file'] = false,
					['folder'] = true,
					['folder_arrow'] = false,
				},
				['glyphs'] = {
					['default'] = ' ',
					['symlink'] = '=',
					['git'] = {
						['unstaged'] = 'm',
						['staged'] = 'M',
						['unmerged'] = 'u',
						['renamed'] = '➜',
						['untracked'] = 'u',
						['deleted'] = 'd',
						['ignored'] = 'i',
					},
					['folder'] = {
						['arrow_open'] = '-',
						['arrow_closed'] = '+',
						-- ['default'] = '▮',
						['default'] = '▸',
						-- ['open'] = '▯',
						['open'] = '▾',
						-- ['empty'] = '▮',
						['empty'] = '▸',
						-- ['empty_open'] = '▯',
						['empty_open'] = '▾',
						['symlink'] = '=',
						['symlink_open'] = '-',
					},
				},
			},
		},
		['disable_netrw'] = false,
		['diagnostics'] = {
			['enable'] = true,
			['show_on_dirs'] = false,
			['icons'] = {
				['hint'] = 'H',
				['info'] = 'I',
				['warning'] = 'W',
				['error'] = 'E',
			},
		},
		['actions'] = {
			['open_file'] = {
				['resize_window'] = true,
			},
		},
		['view'] = {
			['width'] = {
				['min'] = "10%",
				['max'] = -1,
				['padding'] = 0,
			},
			['hide_root_folder'] = true,
			['signcolumn'] = 'no',
			['mappings'] = {
				['list'] = {
					-- { ['key'] = ']h', cb = tmap('next_git_item') },
					-- { ['key'] = '[h', cb = tmap('prev_git_item') },
					{ ['key'] = 'l', cb = tmap('edit') },
					{ ['key'] = 'h', cb = tmap('close_node') },
					{ ['key'] = 'd', cb = nil },
					{ ['key'] = 'D', cb = tmap('remove') },
					{ ['key'] = 'R', cb = tmap('refresh') },
					{ ['key'] = 'm', cb = tmap('rename') },
					{ ['key'] = 'M', cb = tmap('full_rename') },
					{ ['key'] = 'O', cb = tmap('system_open') },
					{ ['key'] = '<c-.>', cb = tmap('toggle_dotfiles') },
				},
			},
		},
		['filters'] = {
			['dotfiles'] = true,
		},
		['git'] = {
			['enable'] = true,
			['ignore'] = false,
		},
		['hijack_directories'] = {
			['enable'] = false,
		},
		['respect_buf_cwd'] = false,
		['update_cwd'] = false,
		['update_focused_file'] = {
			['enable'] = true,
			['update_cwd'] = false,
			['ignore_list'] = {},
		},
		['auto_reload_on_write'] = false
	}
end

function F.treesitter()
	require('nvim-treesitter.configs').setup {
		['highlight'] = {
			['enable'] = true
		},
		['ensure_installed'] = { "lua", "rust", "go", "python", "terraform", "yaml", "json" },
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
			['enable'] = true
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
				['set_jumps'] = true, -- whether to set jumps in the jumplist
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

	M.treesitter()
end

function F.ctrlsf()
	vim.g.ctrlsf_context = '-B 3 -A 3'
	vim.g.ctrlsf_compact_winsize = '30%'
	vim.g.ctrlsf_winsize = '30%'
	-- vim.g.ctrlsf_auto_focus = { "at" : "start" }
	vim.g.ctrlsf_populate_qflist = 1

	M.ctrlsf()
end

function F.lualine()
	require('lualine').setup {
		['options'] = {
			['icons_enabled'] = false,
			-- ['theme'] = 'everforest',
			-- ['theme'] = 'auto',
			['theme'] = 'gruvbox-material',
			['section_separators'] = { left = '▘', right = '▗' },
			-- component_separators'] = { left = '▞', right = '▞' },
			['component_separators'] = '',
			['globalstatus'] = true,
		},
		['sections'] = {
			-- ['lualine_a'] = { { 'mode', fmt = function(str) return str:lower(); --[[str:sub(1, 3)[:lower()]] end } },
			['lualine_a'] = { { 'mode', fmt = function(str) return str:sub(1, 1) end } },
			['lualine_b'] = { 'branch' },
			-- ['lualine_c'] = { '%{pathshorten(fnamemodify(expand("%:h"), ":~:.")) . "/" . (expand("%") == "" ? "[new]" :expand("%:t"))}', --[['filename',]] '%l', { 'aerial', ['sep'] = '::' } },
			['lualine_c'] = {
				'diff',
				{ 'diagnostics', diagnostics_color = {
					error = 'DiagnosticFloatingError', -- Changes diagnostics' error color.
					warn  = 'DiagnosticFloatingWarn', -- Changes diagnostics' warn color.
					info  = 'DiagnosticFloatingInfo', -- Changes diagnostics' info color.
					hint  = 'DiagnosticFloatingHint', -- Changes diagnostics' hint color.
				}, },
				{ 'filename',
					path = 1,
					shorting_target = 25,
					symbols = { modified = '*' }
				},
				-- '%{fnamemodify(expand("%:h"), ":.") . "/" . (expand("%") == "" ? "[new]" :expand("%:t"))}', --[['filename',]]
				'%l:%c/%v',
				{ 'aerial', ['sep'] = '.' }
			},
			['lualine_x'] = {
				'filesize',
				'filetype'
			},
			['lualine_y'] = { 'progress' },
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
	require('gitsigns').setup({
		signs = {
			add          = { hl = 'GitSignsAdd', text = '+', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
			change       = { hl = 'GitSignsChange', text = '~', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
			delete       = { hl = 'GitSignsDelete', text = '-', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
			topdelete    = { hl = 'GitSignsDelete', text = '-', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
			changedelete = { hl = 'GitSignsChange', text = '~', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
			untracked    = { hl = 'GitSignsAdd', text = '+', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
		},
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
		gitsigns = { enabled = true },
		tmux = { enabled = true },
		-- https://github.com/folke/zen-mode.nvim#%EF%B8%8F-configuration
	}
	M.zen_mode()
end

function F.telescope()

	local actions = require("telescope.actions")
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
					-- ['<C-H>'] = actions.toggle_hidden,
				},
			},
		},
		['pickers'] = {
			['live_grep'] = {
				['additional_args'] = function(opts)
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
				-- ['theme'] = "ivy",
				['mappings'] = {
					-- ["i"] = {
					-- 	['<c-n>'] = require('telescope.actions').results_scrolling_down,
					-- 	['<c-p>'] = require('telescope.actions').results_scrolling_up,
					-- },
					["n"] = {
						['h'] = require('telescope').extensions.file_browser.actions.goto_parent_dir,
						['l'] = require('telescope.actions').select_default,
					},
				},
				['hidden'] = true,
				['dir_icon'] = '▸',
				-- ['dir_icon'] = ' ',
				['grouped'] = true,
				-- ['depth'] = 1,
				-- ['folder_browser'] = {
				-- 	['files'] = true,
				-- },
			},
			['ui-select'] = {
				-- require("telescope.themes").get_dropdown {
				-- 	-- even more opts
				-- }

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

	require('telescope').setup(opts)
	require('telescope').load_extension('fzf')
	require('telescope').load_extension('file_browser')
	require('telescope').load_extension('ui-select')

	M.telescope()
end

function F.dap()
	require("dap-go").setup()
	require("nvim-dap-virtual-text").setup({})
	vim.g['test#strategy'] = 'neovim'

	M.testing()
end

function F.neotest()
	require("neotest").setup({
		adapters = {
			require("neotest-vim-test")({
				ignore_filetypes = { "python", "go" },
			}),
			require("neotest-go")({
				experimental = {
					test_table = true,
				},
				args = { "-count=1", "-timeout=60s" }
			}),
			require("neotest-python")({
				-- Extra arguments for nvim-dap configuration
				dap = { justMyCode = false },
				-- Command line arguments for runner
				-- Can also be a function to return dynamic values
				args = { "--log-level", "DEBUG" },
				-- Runner to use. Will use pytest if available by default.
				-- Can be a function to return dynamic value.
				runner = "pytest",

				-- Returns if a given file path is a test file.
				-- NB: This function is called a lot so don't perform any heavy tasks within it.
				-- is_test_file = function(file_path)
				-- end,

			})
		}
	})

	M.neotest()
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
	local has_words_before = function()
		local line, col = unpack(vim.api.nvim_win_get_cursor(0))
		return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
	end

	local check_backspace = function()
		local col = vim.fn.col '.' - 1
		return col == 0 or vim.fn.getline('.'):sub(col, col):match '%s'
	end
	-- load snippets
	require("luasnip.loaders.from_snipmate").lazy_load()

	-- completion
	local _, luasnip = pcall(require, 'luasnip')
	local cmp = require 'cmp'

	local config = {
		-- ['mapping'] = {
		-- 	['<c-p>'] = cmp.mapping.select_prev_item(),
		-- 	['<c-n>'] = cmp.mapping.select_next_item(),
		-- 	['<c-j>'] = cmp.mapping.scroll_docs(-4),
		-- 	['<c-k>'] = cmp.mapping.scroll_docs(4),
		-- 	['<c-space>'] = cmp.mapping.complete(),
		-- 	['<c-e>'] = cmp.mapping.close(),
		-- 	['<cr>'] = cmp.mapping.confirm {
		-- 		['behavior'] = cmp.ConfirmBehavior.Replace,
		-- 		['select'] = false,
		-- 	},
		-- 	['<tab>'] = cmp.mapping(function(fallback)
		-- 		if not luasnip.in_snippet() and luasnip.expand_or_jumpable() then
		-- 			luasnip.expand_or_jump()
		-- 		elseif cmp.visible() and not luasnip.in_snippet() then
		-- 			cmp.select_next_item()
		-- 			-- elseif luasnip.expand_or_jumpable() then
		-- 			-- 	if luasnip.in_snippet() and luasnip.jumpable(1) then
		-- 			-- 		luasnip.jump(1)
		-- 			-- 	end
		-- 			-- 	luasnip.expand_or_jump()
		-- 			-- elseif has_words_before() then
		-- 			-- 	cmp.complete()
		-- 		else
		-- 			fallback()
		-- 		end
		-- 	end, { "i", "s" }),
		-- 	-- ['<tab>'] = cmp.mapping(function(fallback)
		-- 	-- 	if luasnip ~= nil then
		-- 	-- 		if luasnip.in_snippet() and luasnip.jumpable(1) then
		-- 	-- 			luasnip.jump(1)
		-- 	-- 		elseif luasnip.expand_or_jumpable() then
		-- 	-- 			luasnip.expand_or_jump()
		-- 	-- 		else
		-- 	-- 			fallback()
		-- 	-- 		end
		-- 	-- 	elseif cmp.visible() then
		-- 	-- 		cmp.select_next_item()
		-- 	-- 	else
		-- 	-- 		fallback()
		-- 	-- 	end
		-- 	-- end, { "i", "s" }),
		-- 	["<s-tab>"] = cmp.mapping(function(fallback)
		-- 		if cmp.visible() then
		-- 			cmp.select_prev_item()
		-- 		elseif luasnip.jumpable(-1) then
		-- 			luasnip.jump(-1)
		-- 		else
		-- 			fallback()
		-- 		end
		-- 	end, { "i", "s" }),
		-- 	-- ['<s-tab>'] = cmp.mapping(function(fallback)
		-- 	-- 	if luasnip ~= nil then
		-- 	-- 		if luasnip.in_snippet() and luasnip.jumpable(-1) then
		-- 	-- 			luasnip.jump(-1)
		-- 	-- 		else
		-- 	-- 			fallback()
		-- 	-- 		end
		-- 	-- 	elseif cmp.visible() then
		-- 	-- 		cmp.select_prev_item()
		-- 	-- 	else
		-- 	-- 		fallback()
		-- 	-- 	end
		-- 	-- end, { "i", "s" }),
		-- },
		['window'] = {
			['completion'] = cmp.config.window.bordered(),
			['documentation'] = cmp.config.window.bordered(),
		},
		['mapping'] = cmp.mapping.preset.insert({
			-- command line selection
			['<c-j>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
			['<c-k>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),

			-- insert mode selection
			['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i' }),
			['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i' }),

			-- info scrolling like for telescope
			['<C-u>'] = cmp.mapping.scroll_docs(-4),
			['<C-d>'] = cmp.mapping.scroll_docs(4),

			-- confimration
			-- ['<C-Space>'] = cmp.mapping.complete(),
			-- ['<C-e>'] = cmp.mapping.abort(),
			['<cr>'] = cmp.mapping.confirm({ select = false }),
		}),

		['snippet'] = {
			-- REQUIRED - you must specify a snippet engine
			['expand'] = function(args)
				-- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
				require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
				-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
				-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
			end,
		},
		['sources'] = cmp.config.sources({
			{ ['name'] = 'luasnip' },
			{ ['name'] = 'nvim_lsp' },
			{ ['name'] = 'nvim_lua' },
			-- { name = 'vsnip' },
			-- { name = 'ultisnips' },
			-- { name = 'snippy' },
		}, {
			{ name = 'buffer' },
		}),
		-- ['sources'] = {
		-- 	{ ['name'] = 'nvim_lsp' },
		-- 	{ ['name'] = 'nvim_lua' },
		-- 	{ ['name'] = 'buffer' },
		-- 	-- { ['name'] = 'nvim_lua' },
		-- 	{ ['name'] = 'luasnip' },
		-- },
		['history'] = false,
		['preselect'] = cmp.PreselectMode.None
	}
	--
	-- if luasnip ~= nil then
	-- 	config['snippet'] = {
	-- 		['expand'] = function(args)
	-- 			luasnip.lsp_expand(args.body)
	-- 		end,
	-- 	}
	-- 	table.insert(config['sources'], { ['name'] = 'luasnip' })
	-- end

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

	M.luasnip()

end

function F.diffview()
	require("diffview").setup({
		['use_icons'] = false,
		['icons'] = {
			['folder_closed'] = "-",
			['folder_open'] = "+",
		},
	})
end

function F.lspconfig()
	require('mason').setup {}
	require('neodev').setup {}

	local servers = {
		pyright = {},
		rust_analyzer = {},
		terraformls = {},
		tflint = {},
		bashls = {},
		yamlls = {},
		marksman = {},
		-- clangd = {},
		-- tsserver = {},
		gopls = {
			gopls = { -- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
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
					shadow = true, --
					fieldalignment = true, --
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
				},
			},
		},

		sumneko_lua = {
			Lua = {
				workspace = { checkThirdParty = false },
				telemetry = { enable = false },
			},
		},
	}

	local mlsp = require 'mason-lspconfig'

	mlsp.setup {
		ensure_installed = vim.tbl_keys(servers),
	}

	local capabilities = require('cmp_nvim_lsp').default_capabilities(
		vim.lsp.protocol.make_client_capabilities()
	)

	mlsp.setup_handlers {
		function(server_name)
			require('lspconfig')[server_name].setup {
				capabilities = capabilities,
				settings = servers[server_name],
				on_attach = function(client, bufnr)
					bufnr = bufnr

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

					-- aerial symbols
					-- require("aerial").on_attach(client, bufnr)
					-- require("virtualtypes").on_attach(client, bufnr)

					-- format on save
					-- see https://github.com/neovim/neovim/pull/17814/files#diff-a12755025a01c2415c955ca2d50e3d40f9e26df70f712231085d3ff96b2bc837R821
					if client.server_capabilities.documentHighlightProvider then
						vim.cmd [[autocmd CursorMoved <buffer> lua pcall(vim.lsp.buf.clear_references); pcall(vim.lsp.buf.document_highlight)]]
						-- vim.cmd [[autocmd CursorHold  <buffer> lua pcall(vim.lsp.buf.document_highlight)]]
						-- vim.cmd[[autocmd CursorHoldI <buffer> lua pcall(vim.lsp.buf.document_highlight)]]
					end
					if client.server_capabilities.documentFormattingProvider then
						vim.cmd [[autocmd BufWritePre <buffer> lua pcall(vim.lsp.buf.format)]]
					end
					if type(client.server_capabilities.codeLensProvider) == 'table' then
						vim.schedule_wrap(vim.lsp.codelens.run)
						vim.schedule_wrap(vim.lsp.codelens.refresh)
						vim.cmd [[autocmd BufEnter,InsertLeave,BufWritePost <buffer> lua vim.schedule_wrap(vim.lsp.codelens.refresh)]]
					end

				end
			}
		end,
	}

	require("fidget").setup {
		['window'] = {
			['blend'] = 0,
			-- ['border'] = 'solid',
		},
		['fmt'] = {
			['max_width'] = 50,
		}
	}

	require("aerial").setup({
		['on_attach'] = function()
			M.aerial()
		end,
		['default_bindings'] = true,
		-- ['filter_kind'] = false, -- show all symbolls
		['highlight_on_hover'] = true,
		-- ['close_behavior'] = 'global',
		-- ['placement_editor_edge'] = false,
		['layout'] = {
			['placement'] = 'edge',
			['placement_editor_edge'] = false,
		}
	})

end

--
F.bootstrap()
--
