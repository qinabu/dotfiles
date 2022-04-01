local M = {}

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
				['select'] = true,
			},
			['<tab>'] = cmp.mapping(function(fallback)
				if luasnip ~= nil then
					if luasnip.in_snippet() and luasnip.jumpable(1) then
						luasnip.jump(1)
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				elseif cmp.visible() then
					cmp.select_next_item()
				else
					fallback()
				end
			end, { "i", "s" }),
			['<s-tab>'] = cmp.mapping(function(fallback)
				if luasnip ~= nil then
					if luasnip.in_snippet() and luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				elseif cmp.visible() then
					cmp.select_prev_item()
				else
					fallback()
				end
			end, { "i", "s" }),
		},
		['sources'] = {
			{ ['name'] = 'nvim_lsp' },
			-- { ['name'] = 'luasnip' },
			{ ['name'] = 'buffer' },
			{ ['name'] = 'nvim_lua' },
		},
	}

	if luasnip ~= nil then
		config['snippet'] = {
			expand = function(args)
				luasnip.lsp_expand(args.body)
			end,
		}
		table.insert(config['sources'], { ['name'] = 'luasnip'})
	end

	cmp.setup(config)
end

return M
