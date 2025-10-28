-- https://dev.to/delphinus35/dont-use-dependencies-in-lazynvim-4bk0
-- https://neovim.io/doc/user/lsp.html#lsp-new-config

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local out = vim.fn.system({
		"git", "clone",
		"--depth=1",
		"--filter=blob:none",
		"--branch=stable",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out,                            "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

local default_plugins = {
	{ 'nvim-lua/plenary.nvim', lazy = true }
}

return {
	setup = function(spec)
		require("lazy").setup({
			spec = vim.tbl_extend("force", default_plugins, spec),
			local_spec = false,
			ui = {
				size = {
					width = 0.95,
					height = 0.9,
				},
				icons = {
					lazy = "",
					cmd = "⌘",
					plugin = "⌘",
					start = "⌘",
					source = "⌘",
					ft = "⌘",
					event = "⌘",
				}
			},
		})
	end

}
