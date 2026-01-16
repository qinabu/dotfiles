-- https://cmp.saghen.dev/configuration/reference.html
require('plugins').add {
	'saghen/blink.cmp',
	version = '1.*',
	opts = {
		-- All presets have the following mappings:
		-- C-space: Open menu or open docs if already open
		-- C-n/C-p or Up/Down: Select next/previous item
		-- C-e: Hide menu
		-- C-k: Toggle signature help (if signature.enabled = true)
		keymap = { preset = 'default' },
		signature = { enabled = true },
		fuzzy = { implementation = 'lua' },
		completion = {
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 50,
			},
			trigger = {
				show_on_keyword = true,
				show_on_trigger_character = true,
				show_on_insert_on_trigger_character = true,
			},
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
				-- defaults to `{ 'buffer' }`
				lsp = { fallbacks = {} }
			},
			default = { 'lsp', 'path', 'buffer', 'omni' },
			-- default = { 'lsp', 'path', 'snippets', 'buffer' },
		},
	},
	opts_extend = { 'sources.default' }
}
