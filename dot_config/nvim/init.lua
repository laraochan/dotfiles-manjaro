local path_package = vim.fn.stdpath('data') .. '/site'
local mini_path = path_package .. '/pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    'https://github.com/nvim-mini/mini.nvim', mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require("mini.deps").setup({ path = { package = path_package } })

local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
	vim.o.termguicolors = true
	vim.cmd.colorscheme("minicyan")
end)
now(function() require("mini.notify").setup() end)
now(function() require("mini.icons").setup() end)
now(function() require("mini.tabline").setup() end)
now(function() require("mini.statusline").setup() end)
now(function() require("mini.diff").setup() end)

later(function() require("mini.comment").setup() end)
later(function() require("mini.pairs").setup() end)
later(function() require("mini.pick").setup() end)
later(function() require("mini.completion").setup() end)

now(function()
	add("neovim/nvim-lspconfig")
	
	vim.lsp.enable("vtsls")
end)

later(function()
	add({
		source = "nvim-treesitter/nvim-treesitter",
		checkout = "master",
		monitor = "main",
		hooks = { post_checkout = function() vim.cmd("TSUpdate") end }
	})
	require("nvim-treesitter.configs").setup({
		ensure_installed = { "lua", "vimdoc" },
		highlight = { enable = true },
	})
end)

vim.o.clipboard = "unnamedplus"
vim.o.cursorline = true
vim.o.number = true
vim.o.signcolumn = "yes"
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.smartindent = true
