local M = {}

function M.config()
	local _, luasnip = pcall(require, 'luasnip')

	local cmp = require 'cmp'

	local config = {
		['mapping'] = {
			['<c-p>'] = cmp.mapping.select_prev_item(),
			['<c-n>'] = cmp.mapping.select_next_item(),
			['<c-d>'] = cmp.mapping.scroll_docs(-4),
			['<c-f>'] = cmp.mapping.scroll_docs(4),
			['<c-space>'] = cmp.mapping.complete(),
			['<c-e>'] = cmp.mapping.close(),
			['<cr>'] = cmp.mapping.confirm {
				behavior = cmp.ConfirmBehavior.Replace,
				select = true,
			},
			['<tab>'] = function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				elseif luasnip ~= nil and luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				else
					fallback()
				end
			end,
			['<s-tab>'] = function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				elseif luasnip ~= nil and luasnip.jumpable(-1) then
					luasnip.jump(-1)
				else
					fallback()
				end
			end,
		},
		['sources'] = {
			{ ['name'] = 'nvim_lsp' },
			-- { name = 'luasnip' },
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
