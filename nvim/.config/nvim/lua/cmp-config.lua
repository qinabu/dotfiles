local M = {}

local function has_words_before()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

function M.config()
	-- load snippets
	require("luasnip.loaders.from_snipmate").lazy_load()

	-- completion
	local _, luasnip = pcall(require, 'luasnip')
	local cmp = require 'cmp'

	local config = {
		['mapping'] = {
			['<c-p>'] = cmp.mapping.select_prev_item(),
			['<c-n>'] = cmp.mapping.select_next_item(),
			['<c-j>'] = cmp.mapping.scroll_docs(-4),
			['<c-k>'] = cmp.mapping.scroll_docs(4),
			['<c-space>'] = cmp.mapping.complete(),
			['<c-e>'] = cmp.mapping.close(),
			['<cr>'] = cmp.mapping.confirm {
				['behavior'] = cmp.ConfirmBehavior.Replace,
				['select'] = false,
			},
			['<tab>'] = cmp.mapping(function(fallback)
				if not luasnip.in_snippet() and luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				elseif cmp.visible() and not luasnip.in_snippet() then
					cmp.select_next_item()
				-- elseif luasnip.expand_or_jumpable() then
				-- 	if luasnip.in_snippet() and luasnip.jumpable(1) then
				-- 		luasnip.jump(1)
				-- 	end
				-- 	luasnip.expand_or_jump()
				elseif has_words_before() then
					cmp.complete()
				else
					fallback()
				end
			end, { "i", "s" }),
			-- ['<tab>'] = cmp.mapping(function(fallback)
			-- 	if luasnip ~= nil then
			-- 		if luasnip.in_snippet() and luasnip.jumpable(1) then
			-- 			luasnip.jump(1)
			-- 		elseif luasnip.expand_or_jumpable() then
			-- 			luasnip.expand_or_jump()
			-- 		else
			-- 			fallback()
			-- 		end
			-- 	elseif cmp.visible() then
			-- 		cmp.select_next_item()
			-- 	else
			-- 		fallback()
			-- 	end
			-- end, { "i", "s" }),
			["<s-tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				elseif luasnip.jumpable(-1) then
					luasnip.jump(-1)
				else
					fallback()
				end
			end, { "i", "s" }),
			-- ['<s-tab>'] = cmp.mapping(function(fallback)
			-- 	if luasnip ~= nil then
			-- 		if luasnip.in_snippet() and luasnip.jumpable(-1) then
			-- 			luasnip.jump(-1)
			-- 		else
			-- 			fallback()
			-- 		end
			-- 	elseif cmp.visible() then
			-- 		cmp.select_prev_item()
			-- 	else
			-- 		fallback()
			-- 	end
			-- end, { "i", "s" }),
		},
		['sources'] = {
			{ ['name'] = 'nvim_lsp' },
			{ ['name'] = 'nvim_lua' },
			{ ['name'] = 'buffer' },
			{ ['name'] = 'nvim_lua' },
			-- { ['name'] = 'luasnip' },
		},
		['history'] = false,
	}

	if luasnip ~= nil then
		config['snippet'] = {
			['expand'] = function(args)
				luasnip.lsp_expand(args.body)
			end,
		}
		table.insert(config['sources'], { ['name'] = 'luasnip'})
	end

	cmp.setup(config)

	-- `/` cmdline setup.
	cmp.setup.cmdline('/', {
		sources = {
			{ name = 'buffer' }
		}
	})

	-- `:` cmdline setup.
	cmp.setup.cmdline(':', {
		sources = cmp.config.sources({
			{ name = 'path' }
		}, {
			{ name = 'cmdline' }
		})
	})

end

return M
