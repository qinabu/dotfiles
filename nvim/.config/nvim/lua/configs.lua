local M = {}

function M.packer_install()
	local installed = false
	local path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

	if vim.fn.empty(vim.fn.glob(path)) > 0 then
		local url = 'https://github.com/wbthomason/packer.nvim'
		installed = vim.fn.system({'git', 'clone', '--depth', '1', url, path})
	end

	vim.cmd [[packadd packer.nvim]]

	return installed
end

function M.bootstrap()
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

	-- Reload init.lua on save
	vim.cmd([[
	augroup packer_user_config
	autocmd!
	autocmd BufWritePost init.lua source $MYVIMRC | PackerCompile
	augroup end
	]])

	-- Left padding for only vertical window
	--[[
	_G.change_fold_column = function()
		local nr = vim.fn.winnr()
		local value = '0'
		if vim.fn.winnr('h') == nr and vim.fn.winnr('l') == nr then
			value = '9' -- max
		end
		vim.opt_local.foldcolumn = value
	end
	vim.cmd[[autocmd VimEnter,WinEnter,WinClosed,WinLeave,WinNew,BufWinEnter * :lua change_fold_column()] ]
	]]
end

function M.gruvbit()
        vim.cmd [[
                let g:gruvbit_transp_bg = v:true
                colorscheme gruvbit
                hi link LspReferenceText Pmenu
                hi link LspReferenceRead Pmenu
                hi link LspReferenceWrite Pmenu
		hi! clear VertSplit
        	hi Function cterm=bold gui=bold guifg=#83a598 ctermfg=109
                hi! link Special Tag
        ]];
end

function M.sneak()
	vim.g['sneak#use_ic_scs'] = 1
	vim.g['sneak#label'] = 1
end

function M.nvim_tree()
	--vim.g.nvim_tree_indent_markers = 1
	vim.g.nvim_tree_highlight_opened_files = 1
	vim.g.nvim_tree_git_hl = 1

	vim.g.nvim_tree_root_folder_modifier = ':~:.'
	vim.g.nvim_tree_add_trailing = 1

	vim.g.nvim_tree_special_files = {}

	vim.g.nvim_tree_show_icons = {
		['git'] = 0,
		['files'] = 0,
		['folders'] = 0,
		['folder_arrows'] = 0,
	}

	vim.g.nvim_tree_icons = {
		['default'] = '',
		['symlink'] = '=',
		['git'] = {
			['unstaged'] =  '[m]',
			['staged'] =    '[M]',
			['unmerged'] =  '[u]',
			['renamed'] =   '[➜]',
			['untracked'] = '[u]',
			['deleted'] =   '[d]',
		},
		['folder'] = {
			['arrow_open'] =   '-',
			['arrow_closed'] = '+',
			['default'] =      '>',
			['open'] =         'v',
			['empty'] =        '+',
			['empty_open'] =   '-',
			['symlink'] =      '*',
			['symlink_open'] = '-',
		},
		['lsp'] = {
			['hint'] =    'H',
			['info'] =    'I',
			['warning'] = 'W',
			['error'] =   'E',
		}
	}

	local map = require('nvim-tree.config').nvim_tree_callback
	require('nvim-tree').setup{
		['diagnostics'] = {
			['enable'] = false,
			['show_on_dirs'] = false,
			['icons'] = {
				['hint'] = 'H',
				['info'] = 'I',
				['warning'] = 'W',
				['error'] = 'E',
			},
		},
		['view'] = {
			['hide_root_folder'] = true,
			['mappings'] = {
				['list'] = {
					{ ['key'] = 'l', cb = map('edit') },
					{ ['key'] = 'h', cb = map('close_node') },
					{ ['key'] = 'd', cb = nil },
					{ ['key'] = 'D', cb = map('remove') },
					{ ['key'] = 'R', cb = map('full_rename') },
					{ ['key'] = 'm', cb = map('rename') },
					{ ['key'] = 'M', cb = map('full_rename') },
					{ ['key'] = 'O', cb = map('system_open') },
					{ ['key'] = '<c-.>', cb = map('toggle_dotfiles') },
				},
			},
		},
		['filters'] = {
			['dotfiles'] = true,
		},
		['update_focused_file'] = {
			['enabled'] = true,
		},
	}
end

function M.nvim_treesitter()
	require('nvim-treesitter.configs').setup {
		['highlight'] = {
			['enable'] = true
		}
	}
end

function M.nvim_ts_hint_textobject()
	require("tsht").config.hint_keys = { "a", "s", "d", "f", "j", "k", "l", "g", "h"}
end

return M
