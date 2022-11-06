local M = {}

local function default_on_attach(client, bufnr)
	-- map keys
	require("keys").lsp()
	-- signature helps
	require("lsp_signature").on_attach({
		bind = true,
		handler_opts = {
			border = "rounded"
		},
		floating_window = true,
		hint_enable = false,
		hint_prefix = '█ ',
	}, bufnr)

	-- aerial symbols
	-- require("aerial").on_attach(client, bufnr)
	require("virtualtypes").on_attach(client, bufnr)

	-- format on save
	-- if client.supports_method('textDocument/documentHighlight') then
	-- P(client.resolved_capabilities)
	-- see https://github.com/neovim/neovim/pull/17814/files#diff-a12755025a01c2415c955ca2d50e3d40f9e26df70f712231085d3ff96b2bc837R821
	if client.server_capabilities.documentHighlightProvider then
		vim.cmd [[autocmd CursorMoved <buffer> lua pcall(vim.lsp.buf.clear_references); pcall(vim.lsp.buf.document_highlight)]]
		-- vim.cmd [[autocmd CursorHold  <buffer> lua pcall(vim.lsp.buf.document_highlight)]]
		-- vim.cmd[[autocmd CursorHoldI <buffer> lua pcall(vim.lsp.buf.document_highlight)]]
	end
	if client.server_capabilities.documentFormattingProvider then
		vim.cmd [[autocmd BufWritePre <buffer> lua pcall(vim.lsp.buf.format)]]
	end
	if type(client.server_capabilities.codeLensProvider) == 'table' then
		vim.schedule_wrap(vim.lsp.codelens.run)
		vim.schedule_wrap(vim.lsp.codelens.refresh)
		vim.cmd [[autocmd BufEnter,InsertLeave,BufWritePost <buffer> lua vim.schedule_wrap(vim.lsp.codelens.refresh)]]
	end
end

local custom = {
	-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sumneko_lua
	['sumneko_lua'] = function()

		local runtime_path = vim.split(package.path, ';')
		table.insert(runtime_path, "lua/?.lua")
		table.insert(runtime_path, "lua/?/init.lua")

		return {
			['on_attach'] = default_on_attach,
			['settings'] = {
				['Lua'] = {
					['runtime'] = {
						-- Tell the language server which version of Lua you're using
						-- (most likely LuaJIT in the case of Neovim)
						['version'] = 'LuaJIT',
						-- Setup your lua path
						-- ['path'] = runtime_path,
						['path'] = vim.split(package.path, ';'),
					},
					['diagnostics'] = {
						-- Get the language server to recognize the `vim` global
						['globals'] = { 'vim' },
					},
					['workspace'] = {
						-- Make the server aware of Neovim runtime files
						['library'] = vim.api.nvim_get_runtime_file("", true),
					},
					-- Do not send telemetry data containing a randomized but unique identifier
					['telemetry'] = {
						['enable'] = false,
					},
				},
			},
		}
	end,

	-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#gopls
	['gopls'] = function()
		return {
			['on_attach'] = default_on_attach,
			['cmd'] = { "gopls", "serve" },
			-- ['root_dir'] = require('lspconfig/util').root_pattern("go.work", "go.mod", ".git"),
			['settings'] = {
				['gopls'] = { -- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
					['experimentalPostfixCompletions'] = true,
					-- ['experimentalWorkspaceModule'] = true,
					['templateExtensions'] = { 'gotpl', 'gotmpl' },
					-- ['buildFlags'] = {'integration'},
					['gofumpt'] = true,
					['staticcheck'] = true,
					['analyses'] = {
						-- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
						-- disabled by default:
						['unusedparams'] = true, --
						['shadow'] = true, --
						['fieldalignment'] = true, --
						['nilness'] = true, --
						['unusedwrite'] = true, --
						['useany'] = true, --
					},
					['codelenses'] = {
						['gc_details'] = true,
						-- ['gc_details'] = false,
						['generate'] = true,
						['regenerate_cgo'] = true,
						['test'] = true,
						['tidy'] = true,
						['vendor'] = true,
						['upgrade_dependency'] = true,
					},
				},
			},
		}
	end,

	-- ['yamlls'] = function()
	-- 	return {
	-- 		['on_attach'] = default_on_attach,
	-- 		['settings'] = {
	-- 			['schemas'] = {
	-- 				['https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json'] = { '/*.k8s.yaml' },
	-- 				-- { ['kubernetes'] } = { '*.yaml' },
	-- 			},
	-- 		},
	-- 	}
	-- end,

	['pyright'] = function() return {} end,
	['rust_analyzer'] = function() return {} end,
	['terraformls'] = function() return {} end,
	['tflint'] = function() return {} end,
	['bashls'] = function() return {} end,
	['yamlls'] = function() return {} end,
	['marksman'] = function() return {} end,
}


function M.config()
	require("nvim-lsp-installer").setup({})
	local lspconfig = require("lspconfig")

	local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

	for name, config in pairs(custom) do
		local opts = config()
		opts['capabilities'] = capabilities
		if opts['on_attach'] == nil then
			opts['on_attach'] = default_on_attach
		end
		lspconfig[name].setup(opts)
	end

	require("aerial").setup({
		['on_attach'] = function()
			require("keys").aerial()
		end,
		['default_bindings'] = true,
		-- ['filter_kind'] = false, -- show all symbolls
		['highlight_on_hover'] = true,
		-- ['close_behavior'] = 'global',
		-- ['placement_editor_edge'] = false,
		['layout'] = {
			['placement'] = 'edge',
			['placement_editor_edge'] = false,
		}
	})

	-- diagnostic config
	vim.diagnostic.config({
		['virtual_text'] = false, -- default is true
		['severity_sort'] = false, -- default is false
	})

	require("fidget").setup({
		['text'] = {
			['spinner'] = 'noise',
			['done'] = '█',
		},
		['window'] = {
			['blend'] = 0,
		}
	})
end

return M
