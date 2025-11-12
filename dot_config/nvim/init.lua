vim.g.mapleader = " "

local denopsSrc = "~/.cache/dpp/repos/github.com/vim-denops/denops.vim"
local denopsHello = "~/.cache/dpp/repos/github.com/vim-denops/denops-helloworld.vim"

vim.opt.runtimepath:append(denopsSrc)
vim.opt.runtimepath:append(denopsHello)

local dppSrc = "~/.cache/dpp/repos/github.com/Shougo/dpp.vim"
local dppInstaller = "~/.cache/dpp/repos/github.com/Shougo/dpp-ext-installer"
local dppLocal = "~/.cache/dpp/repos/github.com/Shougo/dpp-ext-local"
local dppLazy = "~/.cache/dpp/repos/github.com/Shougo/dpp-ext-lazy"
local dppToml = "~/.cache/dpp/repos/github.com/Shougo/dpp-ext-toml"
local dppGit = "~/.cache/dpp/repos/github.com/Shougo/dpp-protocol-git"

vim.opt.runtimepath:append(dppSrc)
vim.opt.runtimepath:append(dppInstaller)
vim.opt.runtimepath:append(dppLocal)
vim.opt.runtimepath:append(dppLazy)
vim.opt.runtimepath:append(dppToml)
vim.opt.runtimepath:append(dppGit)

local dppBase = "~/.cache/dpp"
local dppConfig = "~/.config/nvim/dpp.ts"

local dpp = require("dpp")

if dpp.load_state(dppBase) then
  vim.api.nvim_create_autocmd("User", {
    pattern = "DenopsReady",
    callback = function()
      vim.notify("dpp load_state() is failed")
      dpp.make_state(dppBase, dppConfig)
    end,
  })
end

vim.api.nvim_create_autocmd("User", {
  pattern = "Dpp:makeStatePost",
  callback = function()
      vim.notify("dpp make_state() is done")
  end,
})

-- install
vim.api.nvim_create_user_command('DppInstall', "call dpp#async_ext_action('installer', 'install')", {})
-- update
vim.api.nvim_create_user_command(
  'DppUpdate', 
  function(opts)
    local args = opts.fargs
    vim.fn['dpp#async_ext_action']('installer', 'update', { names = args })
  end, 
  { nargs = '*' }
)

vim.cmd("filetype indent plugin on")
vim.cmd("syntax on")

vim.o.clipboard = "unnamedplus"
vim.o.mouse = "a"
vim.o.termguicolors = true
vim.o.cursorline = true
vim.o.number = true
vim.o.signcolumn = "yes"
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.autoindent = true

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
