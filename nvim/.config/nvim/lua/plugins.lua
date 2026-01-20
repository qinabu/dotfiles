local default_plugins = {
	{ 'nvim-lua/plenary.nvim' },

	-- copilot
	{
		"github/copilot.vim",
		cmd = "Copilot",
		event = "BufWinEnter",
		init = function()
			vim.g.copilot_no_maps = true
		end,
		config = function()
			-- Block the normal Copilot suggestions
			vim.api.nvim_create_augroup("github_copilot", { clear = true })
			vim.api.nvim_create_autocmd({ "FileType", "BufUnload" }, {
				group = "github_copilot",
				callback = function(args)
					vim.fn["copilot#On" .. args.event]()
				end,
			})
			vim.fn["copilot#OnFileType"]()
		end,
	},

	-- completion
	{
		'saghen/blink.cmp',
		dependencies = { "fang2hou/blink-copilot" },
		version = '1.*',
		opts = {
			signature = { enabled = true },
			fuzzy = { implementation = 'lua' },
			-- All presets have the following mappings:
			-- C-space: Open menu or open docs if already open
			-- C-n/C-p or Up/Down: Select next/previous item
			-- C-e: Hide menu
			-- C-k: Toggle signature help (if signature.enabled = true)
			keymap = {
				preset = 'default',
				['<CR>'] = {
					function(cmp)
						if cmp.get_selected_item_idx() ~= nil then
							return cmp.accept()
						end
					end,
					'fallback',
				},
				['<Tab>'] = {
					function(cmp)
						if cmp.get_selected_item_idx() ~= nil then
							return cmp.accept()
						end
					end,
					'snippet_forward',
					'fallback',
				},
			},
			completion = {
				list = {
					selection = {
						preselect = false,
						auto_insert = false,
					},
				},
				keyword = { range = 'full' },
				menu = {
					min_width = 20,
					max_height = 20,
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 50,
				},
				trigger = {
					show_on_keyword = true,
					show_on_trigger_character = true,
					show_on_insert_on_trigger_character = true,
					show_on_backspace = true,
					show_on_backspace_in_keyword = true,
					show_on_insert = false, --
				},
				ghost_text = { enabled = true },

			},
			cmdline = {
				enabled = true,
				keymap = { preset = 'cmdline' },
				sources = { 'cmdline', 'buffer' },
				completion = {
					menu = { auto_show = true },
					ghost_text = { enabled = true },
				},
			},
			sources = {
				providers = {
					-- lsp = { fallbacks = {} },
					copilot = {
						name = "copilot",
						module = "blink-copilot",
						score_offset = 100,
						async = true,
					},
				},
				default = { 'copilot', 'lsp', 'path', 'buffer' },
			},
		},
		opts_extend = { 'sources.default' }
	},

	-- telescope
	{
		'nvim-telescope/telescope.nvim',
		tag = 'v0.1.9',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-telescope/telescope-file-browser.nvim',
			'nvim-telescope/telescope-ui-select.nvim',
			'nvim-telescope/telescope-dap.nvim',
			{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
		},
		config = function()
			local telescope = require('telescope')
			local actions = require('telescope.actions')
			local fb_actions = require('telescope._extensions.file_browser.actions')
			telescope.setup {
				defaults = {
					layout_strategy = 'vertical',
					layout_config = {
						vertical = { height = 0.95, width = 0.95, prompt_position = 'top' },
						center = { width = 0.9999, height = 0.9999, prompt_position = 'top' },
						bottom_pane = { height = 0.9999, width = 0.9999 },
					},
					sorting_strategy = 'ascending',
					prompt_prefix = '',

					file_ignore_patterns = { '.git/' },
					hidden = true,
					mappings = {
						i = {
							['<C-/>'] = actions.which_key,
						},
						n = {
							['<C-/>'] = actions.which_key,
							['o'] = actions.select_default,
						},
					},
				},
				pickers = {
					live_grep = {
						additional_args = function(_)
							return { '--hidden' }
						end
					},
				},
				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = 'smart_case',
					},
					file_browser = {
						theme = 'ivy',
						hijack_netrw = true,
						layout_config = {
							height = 0.8,
						},
						mappings = {
							['i'] = {
								['<c-e>'] = fb_actions.toggle_browser,
								['<C-f>'] = false,
							},
							['n'] = {
								['f'] = false,
								['h'] = fb_actions.goto_parent_dir,
								['e'] = fb_actions.toggle_browser,
								['.'] = fb_actions.toggle_hidden,
								['l'] = actions.select_default,
								['o'] = actions.select_default,
							},
						},
						hidden = true,
						dir_icon = ' ',
						grouped = true,
						follow_symlinks = true,
						select_buffer = true,
						hide_parent_dir = true,
						prompt_path = true,
					},
					['ui-select'] = {
						require('telescope.themes').get_dropdown {}
					},
				},
			}

			telescope.load_extension('fzf')
			telescope.load_extension('file_browser')
			telescope.load_extension('ui-select')
		end,
	},

	-- treesitter
	{
		'nvim-treesitter/nvim-treesitter',
		branch = 'master',
		dependencies = {
			'nvim-treesitter/playground', -- :TSPlaygroundToggle
			'nvim-treesitter/nvim-treesitter-textobjects',
			'kiyoon/treesitter-indent-object.nvim',
			'romgrk/nvim-treesitter-context',
			'jubnzv/virtual-types.nvim',
		},
		build = ':TSUpdate',
		config = function()
			require 'nvim-treesitter'.setup()
			require 'nvim-treesitter.configs'.setup {
				ensure_installed = {
					"lua",
					"go",
					"gowork",
					"gotmpl",
					"yaml",
					"json",
					-- "rust",
					-- "python",
					-- "hcl",
					-- "vimdoc",
					-- "starlark",
				},
				highlight = { enable = true },
				incremental_selection = {
					enable = true,
					keymaps = {
						node_incremental = ".", -- >
						node_decremental = ",", -- <
					},
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
							["<leader>el"] = "@parameter.inner",
						},
						swap_previous = {
							["<leader>eh"] = "@parameter.inner",
						},
					},
					move = {
						enable = true,
						-- set_jumps = true, -- whether to set jumps in the jumplist
						goto_next_start = {
							["]]"] = "@function.outer",
						},
						goto_next_end = {
							["]["] = "@function.outer",
						},
						goto_previous_start = {
							["[["] = "@function.outer",
						},
						goto_previous_end = {
							["[]"] = "@function.outer",
						},
					},
					-- lsp_interop = {
					-- 	enable = false,
					-- 	border = 'none',
					-- 	peek_definition_code = {
					-- 		-- ['K'] = "@function.outer",
					-- 		-- ['<c-k>'] = "@class.outer",
					-- 	},
					-- },
				},

			}

			require 'treesitter-context'.setup { enable = true, multiline_threshold = 8 }
			require 'treesitter_indent_object'.setup {}
			vim.treesitter.language.register("starlark", "tiltfile")

			-- indent object
			local tobj = require 'treesitter_indent_object.textobj'
			vim.keymap.set({ 'x', 'o' }, 'ai', function() tobj.select_indent_outer() end)
			vim.keymap.set({ 'x', 'o' }, 'aI', function() tobj.select_indent_outer(true) end)
			vim.keymap.set({ 'x', 'o' }, 'ii', function() tobj.select_indent_inner() end)
			vim.keymap.set({ 'x', 'o' }, 'iI', function() tobj.select_indent_inner(true, 'V') end)
		end
	},

	-- editable quick fix list
	{ 'itchyny/vim-qfedit',   lazy = true },

	-- preview in quick fix list
	{
		'kevinhwang91/nvim-bqf',
		lazy = true,
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
				-- border = 'none',
				winblend = 0,
			}
		}
	},

	-- find and replace
	{
		'dyng/ctrlsf.vim',
		config = function()
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
		end

	},

	-- curor hop
	{
		'smoka7/hop.nvim',
		opts = { keys = 'fjdkslaghrutyeiwo' }
	},

	-- git
	{
		'lewis6991/gitsigns.nvim',
		opts = {
			signs = {
				add          = { text = '+' },
				change       = { text = '~' },
				delete       = { text = '_' },
				topdelete    = { text = '-' },
				changedelete = { text = '~' },
				untracked    = { text = '+' },
			},
			signs_staged = {
				add          = { text = '+' },
				change       = { text = '~' },
				delete       = { text = '_' },
				topdelete    = { text = '-' },
				changedelete = { text = '~' },
				untracked    = { text = '+' },
			},
			signs_staged_enable = true,
			current_line_blame = false,
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
				delay = 1000,
				ignore_whitespace = false,
			},
			preview_config = { border = 'rounded' },
		},
	},

	-- git diff
	{
		'sindrets/diffview.nvim',
		lazy = true,
		opts = {
			use_icons = false,
			icons = {
				folder_open = "+",
				folder_closed = "-",
			},
			signs = {
				fold_open = "+",
				fold_closed = "-",
			},
		},
	},

	-- git link
	{
		'ruifm/gitlinker.nvim',
		opts = { mappings = nil },
	},

	-- markdown
	{
		'iamcco/markdown-preview.nvim',
		ft = { 'markdown' },
		build = function() vim.fn['mkdp#util#install']() end,
	},

	-- note taking
	{
		'renerocksai/telekasten.nvim',
		dependencies = { 'nvim-telescope/telescope.nvim' },
		config = function()
			local home = vim.fn.expand("~/Mind")
			require 'telekasten'.setup {
				home = home,
				plug_into_calendar = false,
				dailies = home .. '/' .. 'daily',
				weeklies = home .. '/' .. 'weekly',
				templates = home .. '/' .. 'templates',
				template_new_note = home .. '/templates/new_note.md',
				template_new_daily = home .. '/templates/daily.md',
				template_new_weekly = home .. '/templates/weekly.md',
			}
		end,
	},

	-- translate
	{
		'potamides/pantran.nvim',
		opts = {
			ui = {
				width_percentage = 0.95,
				height_percentage = 0.6,
			},
			default_engine = 'google',
			engines = {
				google = {
					default_target = 'ru',
					fallback = {
						default_target = 'ru'
					},
				},
			},
		},
	},

}

local added_plugins = {}

return {
	---@param plugin table
	add = function(plugin)
		table.insert(added_plugins, plugin)
	end,

	setup = function()
		local plugins = {}
		for _, v in ipairs(default_plugins) do table.insert(plugins, v) end
		for _, v in ipairs(added_plugins) do table.insert(plugins, v) end

		-- install
		local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
		if not vim.uv.fs_stat(lazypath) then
			local out = vim.fn.system({
				'git', 'clone', '--filter=blob:none', '--branch=stable',
				'https://github.com/folke/lazy.nvim.git', lazypath,
			})
			if vim.v.shell_error ~= 0 then
				vim.api.nvim_echo({ { 'Failed to clone lazy.nvim:' .. out .. '\n', 'ErrorMsg' } }, true,
					{})
				vim.fn.getchar()
				os.exit(1)
			end
		end
		vim.opt.rtp:prepend(lazypath)

		-- setup
		require('lazy').setup {
			spec = plugins,
			local_spec = false,
			ui = {
				size = { width = 0.95, height = 0.9 },
				icons = {
					lazy = '', cmd = '⌘', plugin = '⌘', start = '⌘',
					source = '⌘', ft = '⌘', event = '⌘',
				}
			},
		}
	end
}
