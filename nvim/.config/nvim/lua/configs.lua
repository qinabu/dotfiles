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

function M.everforest()
	-- -- vim.g.everforest_diagnostic_text_highlight = 1
	vim.g.termguicolors = true
	vim.g.everforest_transparent_background = 1
	vim.g.everforest_current_word = 'grey background'
	vim.g.everforest_enable_italic = 0
	vim.g.everforest_disable_italic_comment = 1
	vim.cmd [[
	colorscheme everforest
	hi! DiffDelete guifg=#e67e80 ctermfg=167
	hi! DiffChange guifg=#83c092 ctermfg=108
	hi! DiffAdd guifg=#a7c080 ctermfg=142
	hi clear VertSplit
	"hi! VertSplit guifg=#3c3836
	hi! VertSplit guifg=#544f4c
	hi CurrentWord ctermbg=240 guibg=#585858
	hi link CursorLineSign CursorLineNr
	hi CursorLine guibg=#413c3c
	hi CursorLineNr guibg=#413c3c
	"hi CursorLine guibg=#3b3737
	"hi CursorLineNr guibg=#3b3737
	hi! Whitespace ctermfg=238 guifg=#4c4747
	]]
end

function M.gruvbit()
	vim.cmd [[
	let g:gruvbit_transp_bg = v:true
	colorscheme gruvbit
	hi link LspReferenceText Visual
	hi link LspReferenceRead Visual
	hi link LspReferenceWrite Visual
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
	local map = require('nvim-tree.config').nvim_tree_callback
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
					['folder'] = false,
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
						['default'] = '>',
						['open'] = 'v',
						['empty'] = '+',
						['empty_open'] = '-',
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
		['view'] = {
			['hide_root_folder'] = false,
			['auto_resize'] = false,
			['signcolumn'] = 'no',
			-- ['update_cwd'] = true,
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
		['git'] = {
			['enable'] = true,
			['ignore'] = false,
		},
		['update_cwd'] = false,
		['update_focused_file'] = {
			['enable'] = true,
			['update_cwd'] = true,
			['ignore_list'] = {},
		},
	}
end

function M.treesitter()
	require('nvim-treesitter.configs').setup {
		['highlight'] = {
			['enable'] = false
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
				['enable'] = true,
				['border'] = 'none',
				['peek_definition_code'] = {
					['K'] = "@function.outer",
					['<c-k>'] = "@class.outer",
				},
			},
		},

	}

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

	-- local everforest = require('lualine.themes.everforest')
	-- everforest.normal.c.red = '#e67e80'

	require('lualine').setup {
		['options'] = {
			['icons_enabled'] = false,
			['theme'] = 'everforest',
			['section_separators'] = { left = '▘', right = '▗' },
			-- component_separators'] = { left = '▞', right = '▞' },
			['component_separators'] = '',
			['globalstatus'] = true,
		},
		['sections'] = {
			['lualine_a'] = { { 'mode', fmt = function(str) return str:lower(); --[[str:sub(1, 3)[:lower()]] end } },
			['lualine_b'] = { 'branch', 'diff' },
			['lualine_c'] = { '%{pathshorten(fnamemodify(expand("%:h"), ":~:.")) . "/" . (expand("%") == "" ? "[new]" :expand("%:t"))}', --[['filename',]] '%l', { 'aerial', ['sep'] = '::' } },
			['lualine_x'] = { 'diagnostics', 'filesize', 'filetype' },
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

function M.gitsigns()
	require('gitsigns').setup({
		signs = {
			add          = { hl = 'GitSignsAdd', text = '+', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
			change       = { hl = 'GitSignsChange', text = '~', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
			delete       = { hl = 'GitSignsDelete', text = '-', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
			topdelete    = { hl = 'GitSignsDelete', text = '-', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
			changedelete = { hl = 'GitSignsChange', text = '~', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
		},
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

function M.zen_mode()
	require("zen-mode").setup {
		gitsigns = { enabled = true },
		tmux = { enabled = true },
		-- https://github.com/folke/zen-mode.nvim#%EF%B8%8F-configuration
	}
	require("keys").zen_mode()
end

function M.telescope()
	local opts = {
		['defaults'] = {
			['layout_strategy'] = 'bottom_pane',
			['layout_config'] = {
				['bottom_pane'] = {
					['height'] = 0.7,
				}
			},
			['file_ignore_patterns'] = { '^./.git/' },
			['hidden'] = true,
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
				-- ['mappings'] = {
				-- 	["i"] = {
				-- 		['<c-n>'] = require('telescope.actions').results_scrolling_down,
				-- 		['<c-p>'] = require('telescope.actions').results_scrolling_up,
				-- 	},
				-- 	["n"] = {
				-- 		['<c-n>'] = require('telescope.actions').results_scrolling_down,
				-- 		['<c-p>'] = require('telescope.actions').results_scrolling_up,
				-- 	},
				-- },
				['dir_icon'] = '░',
				['grouped'] = true,
				['depth'] = 1,
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
	opts['defaults'] = vim.tbl_deep_extend('force', opts['defaults'], require('telescope.themes').get_ivy())

	require('telescope').setup(opts)
	require('telescope').load_extension('fzf')
	require('telescope').load_extension('file_browser')
	require('telescope').load_extension('ui-select')

	require('keys').telescope()
end

function M.dap()
	require("dap-go").setup()
	require("nvim-dap-virtual-text").setup()
	vim.g['test#strategy'] = 'neovim'

	require('keys').testing()
end

function M.lint()
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

function M.cmp()
	local function has_words_before()
		local line, col = unpack(vim.api.nvim_win_get_cursor(0))
		return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
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
			['<C-b>'] = cmp.mapping.scroll_docs(-4),
			['<C-f>'] = cmp.mapping.scroll_docs(4),
			['<C-Space>'] = cmp.mapping.complete(),
			['<C-e>'] = cmp.mapping.abort(),
			['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
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
			{ ['name'] = 'nvim_lsp' },
			{ ['name'] = 'nvim_lua' },
			{ ['name'] = 'luasnip' }, -- For luasnip users.
			-- { name = 'vsnip' }, -- For vsnip users.
			-- { name = 'ultisnips' }, -- For ultisnips users.
			-- { name = 'snippy' }, -- For snippy users.
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
	}

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
		mapping = cmp.mapping.preset.cmdline(),
		sources = {
			{ name = 'buffer' }
		}
	})

	-- `:` cmdline setup.
	cmp.setup.cmdline(':', {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = 'path' }
		}, {
			{ name = 'cmdline' }
		})
	})

end

function M.diffview()
	require("diffview").setup({
		['use_icons'] = false,
		['icons'] = {
			['folder_closed'] = "-",
			['folder_open'] = "+",
		},
	})
end

return M
