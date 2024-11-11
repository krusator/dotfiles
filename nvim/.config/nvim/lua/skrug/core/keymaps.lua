-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps -------------------

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk", noremap = true, silent = true })

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights", noremap = true, silent = true})

-- delete single character without copying into register
-- keymap.set("n", "x", '"_x')

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number", noremap = true, silent = true }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number", noremap = true, silent = true }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically", noremap = true, silent = true }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally", noremap = true, silent = true }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size", noremap = true, silent = true }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split", noremap = true, silent = true }) -- close current split window

-- keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" , noremap = true, silent = true}) -- open new tab
-- keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab", noremap = true, silent = true }) -- close current tab
-- keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab", noremap = true, silent = true }) --  go to next tab
-- keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab", noremap = true, silent = true }) --  go to previous tab
-- keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab", noremap = true, silent = true }) --  move current buffer to new tab

keymap.set("n", "<c-Right>", "<c-W>6>", { desc = "Tile pane to right", noremap = true, silent = true }) -- tile pane to right
--keymap.set("n", "<s-left>", "<c-W>5<", { desc = "Tile pane to left" }) -- tile pane to left
--keymap.set("n", "<s-up>", "<c-W>5+", { desc = "Tile pane to top" }) -- tile pane to top
--keymap.set("n", "<s-down>", "<c-W>5-", { desc = "Tile pane to bottom" }) -- tile pane to bottom
--
keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down in visual mode", noremap = true, silent = true }) -- move line down in visual mode
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up in visual mode", noremap = true, silent = true }) -- move line up in visual mode

keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true }) -- move cursor down half page and stay in the  middle of the screen
keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true }) -- move cursor up half page and stay in the  middle of the screen

keymap.set('n', '<leader>lw', '<cmd>set wrap!<CR>', { desc = 'Toggle line wrap', noremap = true, silent = true })
-- Keep last yanked when pasting
keymap.set('v', 'p', '"_dP', { desc = 'Keep last yanked when pasting', noremap = true, silent = true })

-- Buffers
keymap.set('n', '<leader>bc', ':bd!<CR>', { desc = "close buffer", noremap = true, silent = true })
