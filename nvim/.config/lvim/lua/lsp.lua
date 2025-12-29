-- https://neovim.io/doc/user/lsp.html#lsp-new-config

require('plugins').add {
	'mason-org/mason-lspconfig.nvim', opts = {},
	dependencies = {
		{ 'mason-org/mason.nvim', opts = {} },
		{ 'neovim/nvim-lspconfig' },
	},
}

vim.diagnostic.config {
	-- float = { border = 'single' },
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
		gopls = {
			-- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
			experimentalPostfixCompletions = true,
			-- experimentalWorkspaceModule = true,
			templateExtensions = { 'gotpl', 'gotmpl', 'go.tpl', 'go.tmpl' },
			buildFlags = { '-tags=integration test mockery all' },
			gofumpt = true,
			staticcheck = true,
			analyses = {
				-- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
				-- disabled by default:
				unusedparams = true, --
				unusedvariable = true,
				shadow = false, -- !!!
				-- fieldalignment = true, -- !!!
				nilness = true, --
				unusedwrite = true, --
				useany = true, --
			},
			codelenses = {
				gc_details = true,
				-- gc_details = false,
				generate = true,
				regenerate_cgo = true,
				test = true,
				tidy = true,
				vendor = true,
				upgrade_dependency = true,
				-- annotations = { bounds = true, escape = true, inline = true, ['nil'] = true }
			},
			workspaceFiles = {
				'**/BUILD',
				'**/WORKSPACE',
				'**/*.{bzl,bazel}',
			},
			directoryFilters = {
				'-bazel-bin',
				'-bazel-out',
				'-bazel-testlogs',
				'-bazel-pedregal',
			},
		}
	},
}

for k, v in pairs(settings) do
	vim.lsp.config(k, { settings = v })
	vim.lsp.enable(k)
end

-- https://neovim.io/doc/user/lsp.html#lsp-config
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('my.lsp', {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		local caps = client.server_capabilities or {}

		local agroup = vim.api.nvim_create_augroup('MyLsp', { clear = true })

		if caps.documentHighlightProvider then
			vim.api.nvim_create_autocmd('CursorMoved', {
				group = agroup,
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
				group = agroup,
				buffer = args.buf,
				callback = function()
					vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
				end,
			})
		end
	end,
})
