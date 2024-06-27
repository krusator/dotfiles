return {
	"christoomey/vim-tmux-navigator",
	cmd = {
		"TmuxNavigateLeft",
		"TmuxNavigateDown",
		"TmuxNavigateUp",
		"TmuxNavigateRight",
		"TmuxNavigatePrevious",
	},
	keys = {
		{ "<S-Left>", "<cmd>TmuxNavigateLeft<cr>" },
		{ "<S-Down>", "<cmd>TmuxNavigateDown<cr>" },
		{ "<S-Up>", "<cmd>TmuxNavigateUp<cr>" },
		{ "<S-Right>", "<cmd>TmuxNavigateRight<cr>" },
	},
}
