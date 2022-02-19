local M = {}

function M.packer_install()
	local installed = false
	local path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

	if vim.fn.empty(vim.fn.glob(path)) > 0 then
		local url = 'https://github.com/wbthomason/packer.nvim'
		installed = vim.fn.system({ 'git', 'clone', '--depth', '1', url, path })
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

	-- close terminal in case of zero exit code
	-- vim.cmd[[
	-- autocmd TermClose * if !v:event.status | exe 'bdelete! '..expand('<abuf>') | endif
	-- ]]

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

-- function M.gruvbit()
-- 	vim.g.termguicolors = true
-- 	vim.cmd [[
--                 let g:gruvbit_transp_bg = v:true
--                 colorscheme gruvbit
--                 hi link LspReferenceText Pmenu
--                 hi link LspReferenceRead Pmenu
--                 hi link LspReferenceWrite Pmenu
-- 		hi! clear VertSplit
--         	hi Function cterm=bold gui=bold guifg=#83a598 ctermfg=109
--                 hi! link Special Tag
--         ]];
-- end

function M.everforest()
	-- -- vim.g.everforest_diagnostic_text_highlight = 1
	vim.g.termguicolors = true
	vim.g.everforest_current_word = 'grey background'
	vim.g.everforest_transparent_background = 1
	vim.g.everforest_enable_italic = 0
	vim.g.everforest_disable_italic_comment = 1
	vim.cmd [[
	colorscheme everforest
	hi clear VertSplit
	hi! VertSplit guifg=#3c3836
	hi CurrentWord ctermbg=238 guibg=#444444
	hi link CursorLineSign CursorLineNr
	]]
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
		['disable_netrw'] = false,
		['default'] = '',
		['symlink'] = '=',
		['git'] = {
			['unstaged'] = '[m]',
			['staged'] = '[M]',
			['unmerged'] = '[u]',
			['renamed'] = '[➜]',
			['untracked'] = '[u]',
			['deleted'] = '[d]',
		},
		['folder'] = {
			['arrow_open'] = '-',
			['arrow_closed'] = '+',
			['default'] = '>',
			['open'] = 'v',
			['empty'] = '+',
			['empty_open'] = '-',
			['symlink'] = '*',
			['symlink_open'] = '-',
		},
		['lsp'] = {
			['hint'] = 'H',
			['info'] = 'I',
			['warning'] = 'W',
			['error'] = 'E',
		}
	}

	local map = require('nvim-tree.config').nvim_tree_callback
	require('nvim-tree').setup {
		['disable_netrw'] = false,
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
			['auto_resize'] = false,
			['mappings'] = {
				['list'] = {
					{ ['key'] = ']h', cb = map('next_git_item') },
					{ ['key'] = '[h', cb = map('prev_git_item') },
					{ ['key'] = 'l', cb = map('edit') },
					{ ['key'] = 'h', cb = map('close_node') },
					{ ['key'] = 'd', cb = nil },
					{ ['key'] = 'D', cb = map('remove') },
					{ ['key'] = 'R', cb = map('refresh') },
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
			['upate_cwd'] = true,
		},
	}
end

function M.nvim_treesitter()
	require('nvim-treesitter.configs').setup {
		['highlight'] = {
			['enable'] = false
		}
	}
end

function M.nvim_ts_hint_textobject()
	require("tsht").config.hint_keys = { "a", "s", "d", "f", "j", "k", "l", "g", "h" }
	require("keys").nvim_ts_hint_textobject()
end

function M.ctrlsf()
	vim.g.ctrlsf_context = '-B 3 -A 3'
	vim.g.ctrlsf_compact_winsize = '30%'
	vim.g.ctrlsf_winsize = '30%'
	-- vim.g.ctrlsf_auto_focus = { "at" : "start" }
	vim.g.ctrlsf_populate_qflist = 1

	require("keys").ctrlsf()
end

function M.lualine()

	local everforest = require('lualine.themes.gruvbox')
	everforest.normal.c.red = '#e67e80'

	require('lualine').setup {
		options = {
			icons_enabled = false,
			theme = everforest,
			section_separators = { left = '▘', right = '▗' },
			-- component_separators = { left = '▞', right = '▞' },
			component_separators = '',
		},
		sections = {
			lualine_a = { { 'mode', fmt = function(str) return str:lower(); --[[str:sub(1, 3)[:lower()]] end } },
			lualine_b = { 'branch', 'diff' },
			lualine_c = { 'filename', '%l', { 'aerial', ['sep'] = '::' } },
			lualine_x = { 'diagnostics', 'filesize', 'filetype' },
			lualine_y = { 'progress' },
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
	}
end

function M.gitsigns()
	require('gitsigns').setup({
		current_line_blame = false,
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
			delay = 1000,
			ignore_whitespace = false,
		},
	})
	require("keys").gitsigns()
end

function M.fugitive()
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

	require("keys").fugitive()
end

function M.telekasten()
	vim.g.calendar_no_mappings = 1

	local home = vim.fn.expand("~/.local/mind")
	require('telekasten').setup({
		['home'] = home,
		['take_over_my_home'] = true,
		['auto_set_filetype'] = true,
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
			['calendar_monday'] = 2,
			-- calendar mark: where to put mark for marked days: 'left', 'right', 'left-fit'
			['calendar_mark'] = 'left-fit',
		},

		-- telescope actions behavior
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

	require("keys").telekasten()

	-- vim.cmd([[
	-- augroup calendar_fix_signcolumn
	-- autocmd!
	-- autocmd WinNew.lua source $MYVIMRC | PackerCompile
	-- augroup end
	-- ]])
end

return M
