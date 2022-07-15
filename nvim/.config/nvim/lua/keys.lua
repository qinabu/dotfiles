local M = {}

local map = vim.api.nvim_set_keymap

local NSE = { noremap = true, silent = true, expr = true }
local NS = { noremap = true, silent = true }
local N = { noremap = true }

function M.bootstrap()
	vim.g.mapleader = " "
	vim.api.nvim_set_keymap('', '<space>', '<nop>', NS)

	-- Vim
	map('n', '<leader>q', ':qall<cr>', N)
	map('n', '<leader>Q', ':qall!<cr>', N)

	map('n', '<leader><esc>', ':quit<cr>', N)

	-- map('n', '<leader><esc>b', ':bdelete<cr>', N)
	-- map('n', '<leader><esc>B', ':bdelete!<cr>', N)

	map('n', '<leader><leader>,', ':edit $MYVIMRC<CR>', NS)
	map('n', '<leader><leader>.', ':call chdir(expand("%:p:h")) | pwd<CR>', N)

	-- Lang (see keymap)
	map('i', '<c-l>', '<c-^>', NS)
	map('c', '<c-l>', '<c-^>', NS)
	map('n', '<c-l>', 'i<c-^><esc>', NS)

	-- Navigation
	map('n', '<leader>w', '<c-w>', N) -- Window modification prefix
	map('n', '<leader>w?', ':help CTRL-W<cr>', N) -- Window modification prefix

	map('n', '<leader>h', '<c-w>h', NS)
	map('n', '<leader>l', '<c-w>l', NS)
	map('n', '<leader>j', '<c-w>j', NS)
	map('n', '<leader>k', '<c-w>k', NS)

	map('n', '<ScrollWheelUp>', '<c-y>', NS)
	map('n', '<ScrollWheelDown>', '<c-e>', NS)

	map('n', '<leader>p', '<c-^>zz', NS) -- previous buffer

	map('n', '<leader>.', ':cnext<cr>', NS)
	map('n', '<leader>,', ':cprevious<cr>', NS)
	-- map('n', '.', ':cnext<cr>', NS)
	-- map('n', ',', ':cprevious<cr>', NS)
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

	map('n', '<leader>ot', ':lua vim.opt.tabstop = (vim.opt.tabstop:get() ~= 8 and 8 or 4)<cr>', NS)

	-- Command line
	map('n', '<leader>;', ':', N) -- Command line
	map('n', "<leader>'", '@:', N) -- Repeat last command

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
	map('n', '<leader>S', ':wall<cr>', N) -- Write chages of all buffers

	-- Edit
	map('i', '<esc>', '<esc>`^', NS) -- Keep cursor on the same positioni

	map('n', 'j', 'gj', NS)
	map('n', 'k', 'gk', NS)
	map('i', '<down>', '<c-o>gj', NS)
	map('i', '<up>', '<c-o>gk', NS)

	map('n', '<leader>ee', '*Ncgn', NS)
	map('v', '<leader>ee', "\"sy:let @/='\\V'.@s<CR>cgn", NS)

	map('v', 'K', ":move '<-2<cr>gv=gv", NS)
	map('v', 'J', ":move '>+1<cr>gv=gv", NS)

	map('v', 'p', '"_dP', NS)
	map('n', 'x', '"_x', NS)
	map('n', 'X', '"_X', NS)
	map('n', 'Q', 'q', N)

	-- Searching
	-- map('n', '<leader>/', ":let @/=''<cr>", NS)
	map('n', '<leader>/', ":noh<cr>", NS)

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
end

function M.nvim_ts_hint_textobject()
	-- mfussenegger/nvim-ts-hint-textobject
	map('o', 'm', ':<c-u>lua require("tsht").nodes()<cr>', NS)
	map('v', 'm', ':lua require("tsht").nodes()<cr>', NS)
end

function M.lsp()
	-- help / hint
	map('n', 'K', ':lua vim.lsp.buf.hover()<cr>', NS)
	map('n', '<c-k>', ':lua vim.lsp.buf.signature_help()<cr>', NS)

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
	map('n', '<leader>ef', ':lua vim.lsp.buf.formatting_sync();print("Formatted")<cr>', N)
	map('n', '<leader>ec', ':lua vim.lsp.codelens.refresh();vim.lsp.codelens.run()<cr>', NS)


	-- range_code_action
	-- range_formatting

	-- workspace / sources directories
	-- map('n', '<leader>wa', ':lua vim.lsp.buf.add_workspace_folder()<cr>', NS)
	-- map('n', '<leader>wr', ':lua vim.lsp.buf.remove_workspace_folder()<cr>', NS)
	-- map('n', '<leader>wl', ':lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>', NS)

end

function M.telescope()
	-- map('n', '<leader>ea', ':Telescope lsp_code_actions<cr>', NS)
	map('n', '<leader>es', ':Telescope spell_suggest<cr>', NS)

	map('n', '<leader>ft', ':Telescope<cr>', NS)
	map('n', '<leader>ff', ':Telescope find_files hidden=true<cr>', NS)
	map('n', '<leader>fg', ':Telescope live_grep<cr>', NS)
	map('n', '<leader>fh', ':Telescope git_status<cr>', NS)
	map('n', '<leader>fd', ':Telescope file_browser<cr>', NS)
	map('n', '<leader>fr', ':Telescope file_browser path=%:p:h<cr>', NS)
	map('n', '<leader>fs', ':Telescope lsp_document_symbols<cr>', NS)
	map('n', '<leader>fw', ':Telescope lsp_dynamic_workspace_symbols<cr>', NS)
	map('n', '<leader>fb', ':Telescope buffers<cr>', NS)
	map('n', '<leader>fm', ':Telescope marks<cr>', NS)

	-- map('n', '<leader>r', ':Telescope file_browser path=%:p:h<cr>', NS)
	-- map('n', '<leader>d', ':Telescope file_browser<cr>', NS)

end

function M.testing()
	-- DAP
	map('n', '<leader>tq', ':lua require("dap").close()<cr>:DapVirtualTextDisable<cr>', NS)

	map('n', '<leader>tg', ':lua require("dap-go").debug_test()<cr>', NS)

	map('n', '<leader>td', ':DapVirtualTextEnable<cr>:lua require("dap").continue()<cr>', NS)
	map('n', '<leader>tD', ':DapVirtualTextEnable<cr>:lua require("dap").run_last()<cr>', NS)

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
	map('n', '<leader>gg', ':if buflisted(bufname(".git/index")) <cr> :bd .git/index <cr> :else <cr> :Git <cr> :endif <cr>'
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
end

function M.gitsigns()
	-- Toggle line blame
	map('n', '<leader>ob', ':Gitsigns toggle_current_line_blame<cr>', NS)

	-- JUMP
	-- next / pref hunk
	map('n', ']h', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<cr>'", NSE)
	map('n', '[h', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<cr>'", NSE)

	-- HUNK
	-- stage
	map('n', 'ghs', '<cmd>Gitsigns stage_hunk<cr>', NS)
	map('v', 'ghs', ':Gitsigns stage_hunk<cr>', NS)
	-- unstage
	map('v', 'ghu', '<cmd>Gitsigns undo_stage_hunk<CR>', NS)
	-- reset
	map('n', 'ghr', '<cmd>Gitsigns reset_hunk<cr>', NS)
	map('v', 'ghr', ':Gitsigns reset_hunk<cr>', NS)

	-- BUFFER
	-- stage
	map('n', 'ghS', '<cmd>Gitsigns stage_buffer<CR>', NS)
	-- unstage
	map('n', 'ghU', '<cmd>Gitsigns reset_buffer_index<CR>', NS)
	-- reset
	map('n', 'ghR', '<cmd>Gitsigns reset_buffer<CR>', NS)

	-- BLAME
	map('n', 'ghp', '<cmd>Gitsigns preview_hunk<CR>', NS)
	map('n', 'ghb', '<cmd>lua require"gitsigns".blame_line{full=true}<CR>', NS)

	-- TEXT OBJECT: in hunk
	-- map('o', 'hi', ':<C-U>Gitsigns select_hunk<cr>', NS)
	-- map('x', 'hi', ':<C-U>Gitsigns select_hunk<cr>', NS) -- breaks selection left-right
end

function M.aerial()
	-- Toggle the aerial window with <leader>a
	-- map('n', '<leader>9', ':AerialToggle left<cr>', NS)
	map('n', '<leader>0', ':AerialToggle left<cr>', NS)
	-- Jump forwards/backwards with '{' and '}'
	map('n', '(', ':AerialPrev<cr>', NS)
	map('n', ')', ':AerialNext<cr>', NS)
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

	-- calendar
	map('n', '<leader>nc', ':lua require("telekasten").show_calendar()<cr>', NS)
	map('n', '<leader>nC', ':CalendarT<cr>', NS)

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

return M
