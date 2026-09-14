-- vim.cmd("let g:netrw_liststyle = 3")
local opt = vim.opt -- for conciseness

-- line numbers
opt.relativenumber = true -- show relative line numbers
opt.number = true -- shows absolute line number on cursor line (when relative number is on)

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

-- line wrapping
opt.wrap = false -- disable line wrapping

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive
opt.hlsearch = true
opt.incsearch = true

-- cursor line
opt.cursorline = true -- highlight the current cursor line
opt.scrolloff = 8
-- appearance

-- turn on termguicolors for nightfly colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- folding based on Treesitter's syntax tree instead of indent/manual
-- (foldlevel=99 keeps everything open by default; use zc/zM to fold)
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99
opt.foldlevelstart = 99

-- rounded border for all floating windows (hover, checkhealth, Mason UI, ...)
vim.o.winborder = "rounded"

-- live preview of :substitute in a split before confirming
opt.inccommand = "split"

-- turn off swapfile
opt.swapfile = false

-- Save undo history
vim.o.undofile = true

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- make whitespaces visible
vim.opt.list = true
vim.opt.listchars = { tab = '▸ ', trail = '·', extends = '❯', precedes = '❮', nbsp = '␣', eol = '↲' }
--
-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})
-- -- mark inactive pane with different background
-- vim.cmd('highlight NormalNC guibg=#2e2e2e guifg=#a0a0a0')

vim.filetype.add({
  extension = {
    gotmpl = 'gotmpl',
  },
  pattern = {
    [".*/templates/.*%.tpl"] = "helm",
    [".*/templates/.*%.ya?ml"] = "helm",
    ["helmfile.*%.ya?ml"] = "helm",
  },
})
