return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local gs = require("gitsigns")
    gs.setup()

    -- Navigation
    vim.keymap.set("n", ">h", gs.next_hunk, { desc = "Next hunk" })
    vim.keymap.set("n", "<h", gs.prev_hunk, { desc = "Prev hunk" })

    -- Hunk actions
    vim.keymap.set("n", "<leader>gh", gs.preview_hunk, { desc = "Preview hunk" })
    -- vim.keymap.set("n", "<leader>gs", gs.stage_hunk, { desc = "Stage hunk" })
    vim.keymap.set("n", "<leader>gr", gs.reset_hunk, { desc = "Reset hunk" })
    -- vim.keymap.set("v", "<leader>gs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Stage hunk (visual)" })
    vim.keymap.set("v", "<leader>gr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Reset hunk (visual)" })
    vim.keymap.set("n", "<leader>gS", gs.stage_buffer, { desc = "Stage buffer" })
    vim.keymap.set("n", "<leader>gR", gs.reset_buffer, { desc = "Reset buffer" })
    -- vim.keymap.set("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })

    -- Blame
    vim.keymap.set("n", "<leader>gb", gs.blame_line, { desc = "Blame line" })
    vim.keymap.set("n", "<leader>gB", function() gs.blame_line({ full = true }) end, { desc = "Blame line (full)" })
    vim.keymap.set("n", "<leader>gtb", gs.toggle_current_line_blame, { desc = "Toggle line blame" })

    -- Diff
    vim.keymap.set("n", "<leader>gd", gs.diffthis, { desc = "Diff this" })
    vim.keymap.set("n", "<leader>gD", function() gs.diffthis("~") end, { desc = "Diff this ~" })

    -- Text object
    vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk" })
  end,
}
