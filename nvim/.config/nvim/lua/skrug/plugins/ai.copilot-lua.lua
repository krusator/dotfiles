return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	config = function()
		require("copilot").setup({
			suggestion = { enabled = false },
			panel = { enabled = false },
			filetypes = {
				-- markdown = true,
				-- help = true,
				-- php = true,
				-- java = true,
				-- javascript = true,
				-- go = true,
				["*"] = true,
			},
			-- copilot_model = "gpt-41-copilot",
			-- copilot_model = "gpt-4o-copilot",
			server_opts_overrides = {
				settings = {
					telemetry = {
						telemetryLevel = "off",
					},
				},
			},
		})
	end,
}
