return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	opts = {
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
		copilot_model = "gpt-41-copilot",
		server_opts_overrides = {
			settings = {
				telemetry = {
					telemetryLevel = "off",
				},
			},
		},
	},
}
