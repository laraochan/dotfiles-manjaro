vim.g.mapleader = " "

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
now(function() require("mini.completion").setup() end)

later(function()
  local miniclue = require('mini.clue')
  miniclue.setup({
    triggers = {
      -- Leader triggers
      { mode = 'n', keys = '<Leader>' },
      { mode = 'x', keys = '<Leader>' },

      -- Built-in completion
      { mode = 'i', keys = '<C-x>' },

      -- `g` key
      { mode = 'n', keys = 'g' },
      { mode = 'x', keys = 'g' },

      -- Marks
      { mode = 'n', keys = "'" },
      { mode = 'n', keys = '`' },
      { mode = 'x', keys = "'" },
      { mode = 'x', keys = '`' },

      -- Registers
      { mode = 'n', keys = '"' },
      { mode = 'x', keys = '"' },
      { mode = 'i', keys = '<C-r>' },
      { mode = 'c', keys = '<C-r>' },

      -- Window commands
      { mode = 'n', keys = '<C-w>' },

      -- `z` key
      { mode = 'n', keys = 'z' },
      { mode = 'x', keys = 'z' },
    },

    clues = {
      -- Enhance this by adding descriptions for <Leader> mapping groups
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows(),
      miniclue.gen_clues.z(),
    },
  })
end)
later(function() require("mini.comment").setup() end)
later(function() require("mini.pairs").setup() end)
later(function()
    require("mini.files").setup()
    vim.keymap.set("n", "<Leader>e", "<Cmd>lua MiniFiles.open()<Cr>")
end)
later(function()
    require("mini.pick").setup()
    vim.keymap.set("n", "<Leader>ff", "<Cmd>Pick files<Cr>")
    vim.keymap.set("n", "<Leader>fb", "<Cmd>Pick buffers<Cr>")
end)
later(function()
    require("mini.extra").setup()
    vim.keymap.set("n", "<Leader>fd", "<Cmd>lua MiniExtra.pickers.diagnostic()<Cr>")

    vim.keymap.set("n", "<Leader>gd", "<Cmd>lua MiniExtra.pickers.lsp({ scope = 'definition' })<Cr>")
    vim.keymap.set("n", "<Leader>gD", "<Cmd>lua MiniExtra.pickers.lsp({ scope = 'type_definition' })<Cr>")
    vim.keymap.set("n", "<Leader>gr", "<Cmd>lua MiniExtra.pickers.lsp({ scope = 'references' })<Cr>")
    vim.keymap.set("n", "<Leader>gi", "<Cmd>lua MiniExtra.pickers.lsp({ scope = 'implementation' })<Cr>")
end)

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
vim.o.mouse = "a"
vim.o.cursorline = true
vim.o.number = true
vim.o.signcolumn = "yes"
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.smartindent = true

vim.o.winborder = "rounded"

vim.keymap.set("n", "<Leader>bn", "<Cmd>bn<Cr>", { desc = "move buffer next" })
vim.keymap.set("n", "<Leader>bp", "<Cmd>bp<Cr>", { desc = "move buffer prev" })
vim.keymap.set("n", "<Leader>bd", "<Cmd>bd<Cr>", { desc = "delete buffer" })

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    float = { border = "rounded" }
})

vim.keymap.set("n", "<Leader>dd", vim.diagnostic.open_float, { desc = "show diagnostic" })
vim.keymap.set("n", "<Leader>dn", vim.diagnostic.goto_next, { desc = "goto next diagnostic" })
vim.keymap.set("n", "<Leader>dp", vim.diagnostic.goto_prev, { desc = "goto prev diagnostic" })
