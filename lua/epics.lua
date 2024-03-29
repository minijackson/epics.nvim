M = {
	options = {
		ensure_ts_installed = true,
	},
}

local function register_treesitter_grammars()
	local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

	parser_config.epics_cmd = {
		install_info = {
			url = "https://github.com/minijackson/tree-sitter-epics",
			location = "epics-cmd",
			files = { "src/parser.c" },
		},
	}

	parser_config.epics_db = {
		install_info = {
			url = "https://github.com/minijackson/tree-sitter-epics",
			location = "epics-db",
			files = { "src/parser.c" },
		},
	}

	parser_config.epics_msi_substitution = {
		install_info = {
			url = "https://github.com/minijackson/tree-sitter-epics",
			location = "epics-msi-substitution",
			files = { "src/parser.c" },
		},
	}

	parser_config.epics_msi_template = {
		install_info = {
			url = "https://github.com/minijackson/tree-sitter-epics",
			location = "epics-msi-template",
			files = { "src/parser.c" },
		},
	}

	parser_config.snl = {
		install_info = {
			url = "https://github.com/minijackson/tree-sitter-epics",
			location = "snl",
			files = { "src/parser.c" },
		},
	}

	parser_config.streamdevice_proto = {
		install_info = {
			url = "https://github.com/minijackson/tree-sitter-epics",
			location = "streamdevice-proto",
			files = { "src/parser.c" },
		},
	}

	if M.options.ensure_ts_installed then
		local ts_install = require "nvim-treesitter.install"
		ts_install.ensure_installed {
			"epics_cmd",
			"epics_db",
			"epics_msi_substitution",
			"epics_msi_template",
			"streamdevice_proto",
			"snl",
		}
	end
end

local function register_ftdetect()
	vim.filetype.add({
		extension = {
			cmd = "epics_cmd",

			db = "epics_db",
			dbd = "epics_db",
			template = "epics_db",

			sub = "epics_msi_substitution",
			subs = "epics_msi_substitution",
			substitutions = "epics_msi_substitution",

			-- TODO: has collision
			st = "snl",
			stt = "snl",

			proto = function(_path, bufnr)
				-- Check if some lines are "#" comments
				-- Because protobuf files are also named *.proto
				for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
					if line:match "%s*#" then
						return "streamdevice_proto"
					end
				end
			end
		}
	})
end

function M.setup(opts)
	vim.deprecate("minijackson/epics.nvim", "epics-extensions/epics.nvim", "never", "epics.nvim")

	vim.validate { opts = { opts, "table" } }

	for given_key, _ in pairs(opts) do
		if not M.options[given_key] then
			error("Unsupported epics.nvim option: " .. given_key)
		end
	end

	M.options = vim.tbl_extend("force", M.options, opts)

	register_treesitter_grammars()
	register_ftdetect()
end

return M
