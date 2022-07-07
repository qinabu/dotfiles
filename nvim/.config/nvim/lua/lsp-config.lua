local M = {}

local function default_on_attach(client, bufnr)
	-- map keys
	require("keys").lsp()
	-- signature helps
	require("lsp_signature").on_attach({
		bind = true,
		handler_opts = {
			border = "rounded"
		}
	}, bufnr)
	-- format on save
	-- if client.supports_method('textDocument/documentHighlight') then
	-- P(client.resolved_capabilities)
	if client.resolved_capabilities.document_highlight then
		vim.cmd [[autocmd CursorMoved <buffer> lua pcall(vim.lsp.buf.clear_references); pcall(vim.lsp.buf.document_highlight)]]
		-- vim.cmd [[autocmd CursorHold  <buffer> lua pcall(vim.lsp.buf.document_highlight)]]
		-- vim.cmd[[autocmd CursorHoldI <buffer> lua pcall(vim.lsp.buf.document_highlight)]]
	end
	if client.resolved_capabilities.document_highlight then
		vim.cmd [[autocmd BufWritePre <buffer> lua pcall(vim.lsp.buf.formatting_sync)]]
	end
	if client.resolved_capabilities.code_lens then
		pcall(vim.lsp.codelens.refresh)
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

	['yamlls'] = function()
		return {
			['on_attach'] = default_on_attach,
			['settings'] = {
				['schemas'] = {
					['https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json'] = { '/*.k8s.yaml' },
					-- { ['kubernetes'] } = { '*.yaml' },
				},
			},
		}
	end,
}


function M.config()
	require("nvim-lsp-installer").setup {}
	local lspconfig = require("lspconfig")

	local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

	for name, config in pairs(custom) do
		local opts = config()
		opts['capabilities'] = capabilities
		lspconfig[name].setup(opts)
	end

	M.aerial()

	-- diagnostic config
	vim.diagnostic.config({
		['virtual_text'] = false, -- true by default
		['severity_sort'] = false, -- false by default
	})

end

function M.aerial()

	-- aerial
	require("aerial").setup({
		['on_attach'] = function()
			require("keys").aerial()
		end,
		['default_bindings'] = true,
		-- ['filter_kind'] = false, -- show all symbolls
		-- :help SymbolKind
		['filter_kind'] = {
			"Class",
			"Constructor",
			"Enum",
			"Function",
			"Interface",
			"interface", --
			"Module",
			"Method",
			"Struct",
		},

		['highlight_on_hover'] = true,
		['close_behavior'] = 'global',
		['placement_editor_edge'] = true,
	})
end

-- function M.config2()
-- 	-- lsp isntall
-- 	-- TODO: change due to https://github.com/williamboman/nvim-lsp-installer/discussions/636
-- 	require("nvim-lsp-installer").on_server_ready(function(server)

-- 		local capabilities = vim.lsp.protocol.make_client_capabilities()
-- 		capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown", "plaintext" }
-- 		capabilities.textDocument.completion.completionItem.snippetSupport = true
-- 		capabilities.textDocument.completion.completionItem.preselectSupport = true
-- 		capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
-- 		capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
-- 		capabilities.textDocument.completion.completionItem.deprecatedSupport = true
-- 		capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
-- 		capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
-- 		capabilities.textDocument.completion.completionItem.resolveSupport = {
-- 			properties = {
-- 				"documentation",
-- 				"detail",
-- 				"additionalTextEdits",
-- 			},
-- 		}

-- 		local ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
-- 		if ok then
-- 			capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
-- 		end

-- 		local opts = {
-- 			-- ['capabilities'] = capabilities,
-- 			['capabilities'] = require("cmp_nvim_lsp").update_capabilities(capabilities),
-- 			['flags'] = { --?
-- 				['debounce_text_changes'] = 150,
-- 			}
-- 		}

-- 		local custom_fn = custom[server.name] or nil
-- 		if custom_fn ~= nil then
-- 			-- print("enable "..server.name)
-- 			opts = vim.tbl_deep_extend('force', opts, custom_fn(server))
-- 		end
-- 		opts['on_attach'] = function(client, bufnr)
-- 			-- map keys
-- 			require("keys").lsp()
-- 			-- aerial code navigator
-- 			require("aerial").on_attach(client, bufnr)
-- 			-- type annotation in virtual text
-- 			require("virtualtypes").on_attach(client, bufnr)
-- 			-- signature helps
-- 			require("lsp_signature").on_attach({
-- 				bind = true,
-- 				handler_opts = {
-- 					border = "rounded"
-- 				}
-- 			}, bufnr)
-- 			-- format on save
-- 			-- if client.supports_method('textDocument/documentHighlight') then
-- 			-- P(client.resolved_capabilities)
-- 			if client.resolved_capabilities.document_highlight then
-- 				vim.cmd [[autocmd CursorMoved <buffer> lua pcall(vim.lsp.buf.clear_references); pcall(vim.lsp.buf.document_highlight)]]
-- 				-- vim.cmd [[autocmd CursorHold  <buffer> lua pcall(vim.lsp.buf.document_highlight)]]
-- 				-- vim.cmd[[autocmd CursorHoldI <buffer> lua pcall(vim.lsp.buf.document_highlight)]]
-- 			end
-- 			if client.resolved_capabilities.document_highlight then
-- 				vim.cmd [[autocmd BufWritePre <buffer> lua pcall(vim.lsp.buf.formatting_sync)]]
-- 			end
-- 			if client.resolved_capabilities.code_lens then
-- 				pcall(vim.lsp.codelens.run)
-- 				vim.cmd [[autocmd BufEnter,InsertLeave,BufWritePost <buffer> lua vim.schedule_wrap(vim.lsp.codelens.refresh)]]
-- 			end
-- 		end


-- 		server:setup(opts)
-- 		require("aerial").setup({
-- 			on_attach = function()
-- 				require("keys").aerial()
-- 			end,
-- 			default_bindings = true,
-- 		})
-- 	end)

-- 	-- diagnostic config
-- 	vim.diagnostic.config({
-- 		['virtual_text'] = false,
-- 		['severity_sort'] = true,
-- 	})
-- end

return M
