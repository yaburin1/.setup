return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			{ "theHamsta/nvim-dap-virtual-text", opts = { virt_text_pos = "eol" } },
			{ "jay-babu/mason-nvim-dap.nvim", opts = {} },
			"mfussenegger/nvim-dap-python",
		},
		keys = {
			{
				mode = { "n" },
				"<F5>",
				function()
					require("dap").continue()
				end,
			},
			{
				mode = { "n" },
				"<F10>",
				function()
					require("dap").step_over()
				end,
			},
			{
				mode = { "n" },
				"<F11>",
				function()
					require("dap").step_into()
				end,
			},
			{
				mode = { "n" },
				"<F12>",
				function()
					require("dap").step_out()
				end,
			},
			{
				mode = { "n" },
				"<leader>b",
				function()
					require("dap").toggle_breakpoint()
				end,
			},
		},
		config = function()
			local orig_notify = vim.notify
			vim.notify = function(msg, level, opts)
				if type(msg) == "string" and msg:match("Cursor position outside buffer") then
					return
				end
				orig_notify(msg, level, opts)
			end

			require("dap-python").setup("python")

			local dap = require("dap")
			local dapui = require("dapui")

			dapui.setup()

			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end

			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end

			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			local mason_path = vim.fn.stdpath("data") .. "/mason"

			-------------------------------------------------
			-- adapters
			-------------------------------------------------

			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = {
					command = mason_path .. "/packages/codelldb/extension/adapter/codelldb",
					args = { "--port", "${port}" },
				},
			}

			-------------------------------------------------
			-- C++
			-------------------------------------------------

			dap.configurations.cpp = {
				{
					name = "Launch file",
					type = "codelldb",
					request = "launch",

					program = function()
						vim.cmd("w")

						local file = vim.fn.resolve(vim.fn.expand("%:p"))
						local exe = vim.fn.expand("%:p:r")

						local result = vim.fn.system({
							"g++",
							"-g",
							"-O0",
							file,
							"-o",
							exe,
						})

						if vim.v.shell_error ~= 0 then
							vim.notify("Build failed:\n" .. result, vim.log.levels.ERROR)
							return nil
						end

						return exe
					end,

					cwd = function()
						return vim.fn.expand("%:p:h")
					end,

					stopOnEntry = false,
					runInTerminal = true,

					sourceMap = {
						["."] = function()
							return vim.fn.expand("%:p:h")
						end,
					},

					exitCommands = {},
				},
			}

			-------------------------------------------------
			-- Rust
			-------------------------------------------------

			dap.configurations.rust = {
				{
					name = "Launch",
					type = "codelldb",
					request = "launch",

					program = function()
						vim.notify("cargo build 中...", vim.log.levels.INFO)

						local result = vim.fn.system({ "cargo", "build" })

						if vim.v.shell_error ~= 0 then
							vim.notify("cargo build 失敗:\n" .. result, vim.log.levels.ERROR)
							return nil
						end

						local cargo_toml = vim.fn.getcwd() .. "/Cargo.toml"

						local name = vim.fn.system({
							"grep",
							"^name",
							cargo_toml,
						})

						name = name:match('"([^"]+)"') or ""
						name = name:gsub("%s+", "")

						if name == "" then
							vim.notify(
								"Cargo.toml からパッケージ名を取得できませんでした",
								vim.log.levels.ERROR
							)
							return nil
						end

						return vim.fn.getcwd() .. "/target/debug/" .. name
					end,

					cwd = "${workspaceFolder}",
					stopOnEntry = false,
					args = {},
				},
			}
		end,
	},
}
