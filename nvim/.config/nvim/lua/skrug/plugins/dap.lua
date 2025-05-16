return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"theHamsta/nvim-dap-virtual-text",
		"rcarriga/nvim-dap-ui",
		"nvim-telescope/telescope-dap.nvim",
		"theHamsta/nvim-dap-virtual-text",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")
		local virtual_text = require("nvim-dap-virtual-text")
		dapui.setup()
		virtual_text.setup()
		-- require("neodev").setup({
		-- 	library = { plugins = { "nvim-dap-ui" }, types = true },
		-- })

		vim.keymap.set("n", "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<CR>")
		vim.keymap.set("n", "<leader>dc", "<cmd>lua require('dap').continue()<CR>")
		vim.keymap.set("n", "<F8>", "<cmd>lua require('dap').continue()<CR>")
		vim.keymap.set("n", "<leader>dn", "<cmd>lua require('dap').step_over()<CR>")
		vim.keymap.set("n", "<F5>", "<cmd>lua require('dap').step_over()<CR>")
		vim.keymap.set("n", "<leader>ds", "<cmd>lua require('dap').step_into()<CR>")
		vim.keymap.set("n", "<F6>", "<cmd>lua require('dap').step_into()<CR>")
		vim.keymap.set("n", "<leader>do", "<cmd>lua require('dap').step_out()<CR>")
		vim.keymap.set("n", "<F7>", "<cmd>lua require('dap').step_out()<CR>")
		vim.keymap.set("n", "<leader>dr", "<cmd>lua require('dap').repl.toggle()<CR>")
		vim.keymap.set("n", "<leader>du", "<cmd>lua require('dapui').toggle()<CR>")
		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end
		local home = os.getenv("HOME")
		local vscode_php_debug_location = home .. "/.local/share/vscode-php-debug"
		dap.adapters.php = {
			type = "executable",
			command = "node",
			args = { vscode_php_debug_location .. "/out/phpDebug.js" },
		}
		require("dap.ext.vscode").load_launchjs(home .. "/.config/nvim/launch.json", { php = { "php" } })
		-- dap.configurations.php = {
		--   {
		--     type = "php",
		--     request = "launch",
		--     name = "Listen for Xdebug",
		--     port = 9003,
		--     stopOnEntry = true,
		--     pathMappings = {
		--       {
		--       -- ["/var/www/html"] = vim.fn.getcwd(),
		--       ["/var/www/html"] = "${workspaceFolder}",
		--       },
		--     },
		-- dap.adapters.java = function(callback)
		-- 	-- FIXME:
		-- 	-- Here a function needs to trigger the `vscode.java.startDebugSession` LSP command
		-- 	-- The response to the command must be the `port` used below
		-- 	callback({
		-- 		type = "server",
		-- 		host = "127.0.0.1",
		-- 		port = 5005,
		-- 	})
		-- end --   },
		function attach_to_debug()
			dap.configurations.java = {
				{
					type = "java",
					request = "attach",
					name = "Debug (Attach) - Remote",
					hostName = "127.0.0.1",
					port = "5005",
				},
			} -- }
		end
		vim.keymap.set("n", "<leader>da", ":lua attach_to_debug()<CR>")
	end,
}
