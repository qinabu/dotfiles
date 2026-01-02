require('plugins').add {
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
				-- "rust",
				-- "python",
				-- "hcl",
				-- "yaml",
				-- "json",
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
}
