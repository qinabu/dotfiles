-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/Users/alex/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/Users/alex/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/Users/alex/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/Users/alex/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/alex/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  LuaSnip = {
    loaded = true,
    path = "/Users/alex/.local/share/nvim/site/pack/packer/start/LuaSnip",
    url = "https://github.com/L3MON4D3/LuaSnip"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/Users/alex/.local/share/nvim/site/pack/packer/start/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-cmdline"] = {
    loaded = true,
    path = "/Users/alex/.local/share/nvim/site/pack/packer/start/cmp-cmdline",
    url = "https://github.com/hrsh7th/cmp-cmdline"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/Users/alex/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-nvim-lsp-document-symbol"] = {
    loaded = true,
    path = "/Users/alex/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp-document-symbol",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp-document-symbol"
  },
  ["cmp-nvim-lua"] = {
    loaded = true,
    path = "/Users/alex/.local/share/nvim/site/pack/packer/start/cmp-nvim-lua",
    url = "https://github.com/hrsh7th/cmp-nvim-lua"
  },
  ["cmp-path"] = {
    loaded = true,
    path = "/Users/alex/.local/share/nvim/site/pack/packer/start/cmp-path",
    url = "https://github.com/hrsh7th/cmp-path"
  },
  cmp_luasnip = {
    loaded = true,
    path = "/Users/alex/.local/share/nvim/site/pack/packer/start/cmp_luasnip",
    url = "https://github.com/saadparwaiz1/cmp_luasnip"
  },
  ["ctrlsf.vim"] = {
    config = { 'require("configs").ctrlsf()' },
    loaded = true,
    path = "/Users/alex/.local/share/nvim/site/pack/packer/start/ctrlsf.vim",
    url = "https://github.com/dyng/ctrlsf.vim"
  },
  everforest = {
    config = { 'require("configs").everforest()' },
    loaded = true,
    path = "/Users/alex/.local/share/nvim/site/pack/packer/start/everforest",
    url = "https://github.com/sainnhe/everforest"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\2\n¾\5\0\0\5\0\n\0\r6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0005\4\5\0=\4\6\0035\4\a\0=\4\b\3=\3\t\2B\0\2\1K\0\1\0\fkeymaps\tn [h\1\2\1\0001&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'\texpr\2\tn ]h\1\2\1\0001&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'\texpr\2\1\0\r\nn ghs!<cmd>Gitsigns stage_hunk<CR>\nn ghb9<cmd>lua require\"gitsigns\".blame_line{full=true}<CR>\nn ghR#<cmd>Gitsigns reset_buffer<CR>\nn ghU)<cmd>Gitsigns reset_buffer_index<CR>\fnoremap\2\nn ghp#<cmd>Gitsigns preview_hunk<CR>\nn ghu&<cmd>Gitsigns undo_stage_hunk<CR>\nn ghS#<cmd>Gitsigns stage_buffer<CR>\nv ghr\29:Gitsigns reset_hunk<CR>\nn ghr!<cmd>Gitsigns reset_hunk<CR>\tx ih#:<C-U>Gitsigns select_hunk<CR>\nv ghs\29:Gitsigns stage_hunk<CR>\to ih#:<C-U>Gitsigns select_hunk<CR>\1\0\1\23current_line_blame\2\nsetup\rgitsigns\frequire\0" },
    loaded = true,
    path = "/Users/alex/.local/share/nvim/site/pack/packer/start/gitsigns.nvim",
    url = "https://github.com/lewis6991/gitsigns.nvim"
  },
  ["lsp-status.nvim"] = {
    loaded = true,
    path = "/Users/alex/.local/share/nvim/site/pack/packer/start/lsp-status.nvim",
    url = "https://github.com/nvim-lua/lsp-status.nvim"
  },
  ["nvim-cmp"] = {
    config = { 'require("cmp-config").config()' },
    loaded = true,
    path = "/Users/alex/.local/share/nvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-dap"] = {
    config = { 'require("dap-config").config()' },
    loaded = true,
    path = "/Users/alex/.local/share/nvim/site/pack/packer/start/nvim-dap",
    url = "https://github.com/mfussenegger/nvim-dap"
  },
  ["nvim-dap-go"] = {
    loaded = true,
    path = "/Users/alex/.local/share/nvim/site/pack/packer/start/nvim-dap-go",
    url = "https://github.com/leoluz/nvim-dap-go"
  },
  ["nvim-lsp-installer"] = {
    config = { 'require("lsp-config").config()' },
    loaded = true,
    path = "/Users/alex/.local/share/nvim/site/pack/packer/start/nvim-lsp-installer",
    url = "https://github.com/williamboman/nvim-lsp-installer"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/Users/alex/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-luapad"] = {
    loaded = true,
    path = "/Users/alex/.local/share/nvim/site/pack/packer/start/nvim-luapad",
    url = "https://github.com/rafcamlet/nvim-luapad"
  },
  ["nvim-tree.lua"] = {
    config = { 'require("configs").nvim_tree()' },
    loaded = true,
    path = "/Users/alex/.local/share/nvim/site/pack/packer/start/nvim-tree.lua",
    url = "https://github.com/kyazdani42/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    config = { 'require("configs").nvim_treesitter()' },
    loaded = true,
    path = "/Users/alex/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-treesitter-context"] = {
    config = { 'require("keys").nvim_ts_hint_textobject()' },
    loaded = true,
    path = "/Users/alex/.local/share/nvim/site/pack/packer/start/nvim-treesitter-context",
    url = "https://github.com/romgrk/nvim-treesitter-context"
  },
  ["nvim-ts-hint-textobject"] = {
    config = { 'require("configs").nvim_ts_hint_textobject()' },
    loaded = true,
    path = "/Users/alex/.local/share/nvim/site/pack/packer/start/nvim-ts-hint-textobject",
    url = "https://github.com/mfussenegger/nvim-ts-hint-textobject"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/Users/alex/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  playground = {
    loaded = true,
    path = "/Users/alex/.local/share/nvim/site/pack/packer/start/playground",
    url = "https://github.com/nvim-treesitter/playground"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/Users/alex/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["telescope-file-browser.nvim"] = {
    loaded = true,
    path = "/Users/alex/.local/share/nvim/site/pack/packer/start/telescope-file-browser.nvim",
    url = "https://github.com/nvim-telescope/telescope-file-browser.nvim"
  },
  ["telescope-fzf-native.nvim"] = {
    loaded = true,
    path = "/Users/alex/.local/share/nvim/site/pack/packer/start/telescope-fzf-native.nvim",
    url = "https://github.com/nvim-telescope/telescope-fzf-native.nvim"
  },
  ["telescope.nvim"] = {
    config = { 'require("telescope-config").config()' },
    loaded = true,
    path = "/Users/alex/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["vim-commentary"] = {
    loaded = true,
    path = "/Users/alex/.local/share/nvim/site/pack/packer/start/vim-commentary",
    url = "https://github.com/tpope/vim-commentary"
  },
  ["vim-fugitive"] = {
    config = { 'require("keys").fugitive()' },
    loaded = true,
    path = "/Users/alex/.local/share/nvim/site/pack/packer/start/vim-fugitive",
    url = "https://github.com/tpope/vim-fugitive"
  },
  ["vim-gruvbit"] = {
    loaded = true,
    path = "/Users/alex/.local/share/nvim/site/pack/packer/start/vim-gruvbit",
    url = "https://github.com/habamax/vim-gruvbit"
  },
  ["vim-maximizer"] = {
    loaded = true,
    path = "/Users/alex/.local/share/nvim/site/pack/packer/start/vim-maximizer",
    url = "https://github.com/szw/vim-maximizer"
  },
  ["vim-sneak"] = {
    config = { 'require("configs").sneak()' },
    loaded = true,
    path = "/Users/alex/.local/share/nvim/site/pack/packer/start/vim-sneak",
    url = "https://github.com/justinmk/vim-sneak"
  },
  winresizer = {
    config = { 'require("keys").winresizer()' },
    loaded = true,
    path = "/Users/alex/.local/share/nvim/site/pack/packer/start/winresizer",
    url = "https://github.com/simeji/winresizer"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: nvim-cmp
time([[Config for nvim-cmp]], true)
require("cmp-config").config()
time([[Config for nvim-cmp]], false)
-- Config for: vim-fugitive
time([[Config for vim-fugitive]], true)
require("keys").fugitive()
time([[Config for vim-fugitive]], false)
-- Config for: nvim-tree.lua
time([[Config for nvim-tree.lua]], true)
require("configs").nvim_tree()
time([[Config for nvim-tree.lua]], false)
-- Config for: nvim-dap
time([[Config for nvim-dap]], true)
require("dap-config").config()
time([[Config for nvim-dap]], false)
-- Config for: ctrlsf.vim
time([[Config for ctrlsf.vim]], true)
require("configs").ctrlsf()
time([[Config for ctrlsf.vim]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
require("configs").nvim_treesitter()
time([[Config for nvim-treesitter]], false)
-- Config for: nvim-treesitter-context
time([[Config for nvim-treesitter-context]], true)
require("keys").nvim_ts_hint_textobject()
time([[Config for nvim-treesitter-context]], false)
-- Config for: nvim-lsp-installer
time([[Config for nvim-lsp-installer]], true)
require("lsp-config").config()
time([[Config for nvim-lsp-installer]], false)
-- Config for: vim-sneak
time([[Config for vim-sneak]], true)
require("configs").sneak()
time([[Config for vim-sneak]], false)
-- Config for: nvim-ts-hint-textobject
time([[Config for nvim-ts-hint-textobject]], true)
require("configs").nvim_ts_hint_textobject()
time([[Config for nvim-ts-hint-textobject]], false)
-- Config for: everforest
time([[Config for everforest]], true)
require("configs").everforest()
time([[Config for everforest]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
require("telescope-config").config()
time([[Config for telescope.nvim]], false)
-- Config for: winresizer
time([[Config for winresizer]], true)
require("keys").winresizer()
time([[Config for winresizer]], false)
-- Config for: gitsigns.nvim
time([[Config for gitsigns.nvim]], true)
try_loadstring("\27LJ\2\n¾\5\0\0\5\0\n\0\r6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0005\4\5\0=\4\6\0035\4\a\0=\4\b\3=\3\t\2B\0\2\1K\0\1\0\fkeymaps\tn [h\1\2\1\0001&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'\texpr\2\tn ]h\1\2\1\0001&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'\texpr\2\1\0\r\nn ghs!<cmd>Gitsigns stage_hunk<CR>\nn ghb9<cmd>lua require\"gitsigns\".blame_line{full=true}<CR>\nn ghR#<cmd>Gitsigns reset_buffer<CR>\nn ghU)<cmd>Gitsigns reset_buffer_index<CR>\fnoremap\2\nn ghp#<cmd>Gitsigns preview_hunk<CR>\nn ghu&<cmd>Gitsigns undo_stage_hunk<CR>\nn ghS#<cmd>Gitsigns stage_buffer<CR>\nv ghr\29:Gitsigns reset_hunk<CR>\nn ghr!<cmd>Gitsigns reset_hunk<CR>\tx ih#:<C-U>Gitsigns select_hunk<CR>\nv ghs\29:Gitsigns stage_hunk<CR>\to ih#:<C-U>Gitsigns select_hunk<CR>\1\0\1\23current_line_blame\2\nsetup\rgitsigns\frequire\0", "config", "gitsigns.nvim")
time([[Config for gitsigns.nvim]], false)
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
