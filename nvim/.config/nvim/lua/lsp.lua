-- https://neovim.io/doc/user/lsp.html#lsp-new-config

require('plugins').add {
	'mason-org/mason-lspconfig.nvim', opts = {},
	dependencies = {
		{ 'mason-org/mason.nvim', opts = {} },
		{ 'neovim/nvim-lspconfig' },
	},
}

vim.diagnostic.config {
	float = { border = 'rounded' },
	virtual_text = false,
	severity_sort = true,
}

vim.lsp.config('*', {
	root_markers = { '.git' },
	capabilities = {
		textDocument = {
			semanticTokens = { multilineTokenSupport = true }
		}
	}
})

local settings = {
	lua_ls = {
		Lua = {
			telemetry = { enable = false },
			runtime = { version = 'LuaJIT' },
			globals = {
				'vim',
				'require'
			},
			workspace = {
				checkThirdParty = false,
				library = vim.api.nvim_get_runtime_file('', true),
			},
			semanticTokens = { multilineTokenSupport = true }
		}
	},
	gopls = {
		gopls = require 'gopls-settings',
	},
}

for k, v in pairs(settings) do
	vim.lsp.config(k, { settings = v })
	vim.lsp.enable(k)
end

-- https://neovim.io/doc/user/lsp.html#lsp-config
local hlgroup = vim.api.nvim_create_augroup("my_lsp_cursor_highlight", { clear = true })
local group = vim.api.nvim_create_augroup("my_lsp", { clear = true })

vim.api.nvim_create_autocmd('LspAttach', {
	group = group,
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		local caps = client.server_capabilities or {}

		if caps.documentHighlightProvider then
			vim.api.nvim_create_autocmd('CursorMoved', {
				desc = 'lsp.lua: highlight word under cursor',
				group = hlgroup,
				buffer = args.buf,
				callback = function()
					pcall(vim.lsp.buf.clear_references)
					pcall(vim.lsp.buf.document_highlight)
				end,
			})
		end
		-- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end
		-- Auto-format ('lint') on save.
		-- Usually not needed if server supports 'textDocument/willSaveWaitUntil'.
		if not client:supports_method('textDocument/willSaveWaitUntil') and
		    client:supports_method('textDocument/formatting') then
			vim.api.nvim_create_autocmd('BufWritePre', {
				desc = 'lsp.lua: lsp format file',
				group = group,
				buffer = args.buf,
				callback = function()
					vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
				end,
			})
		end
	end,
})
