return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
		},
		config = function()
			-- Formatter/Tools, die ":LspEnsure" bei Bedarf über Mason installiert
			local ensure_tools = {
				"gopls",
				"jdtls",
				"clangd",
				"tinymist",
				"lua-language-server",
				"marksman",
				"stylua",
				"gofumpt",
				"goimports",
				"typstyle",
				"clang-format",
				"google-java-format",
				"prettier",
				"tree-sitter-cli", -- zum Kompilieren der Treesitter-Parser
				"sqls",
				"templ",
				"htmx-lsp",
				"oxlint",
				"typescript-language-server",
			}
			-- Nur auf Anforderung (:LspEnsure) installieren -- ein Registry-Refresh
			-- bei jedem Start kostet einen Netzwerk-Roundtrip.
			vim.api.nvim_create_user_command("LspEnsure", function()
				local registry = require("mason-registry")
				registry.refresh(function()
					for _, name in ipairs(ensure_tools) do
						local ok, pkg = pcall(registry.get_package, name)
						if ok and not pkg:is_installed() then
							pkg:install()
						end
					end
				end)
			end, { desc = "Fehlende LSP-/Formatter-Tools via Mason installieren" })

			vim.diagnostic.config({
				virtual_text = { spacing = 2 },
				severity_sort = true,
				float = { border = "rounded" },
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = " ",
						[vim.diagnostic.severity.WARN] = " ",
						[vim.diagnostic.severity.INFO] = " ",
						[vim.diagnostic.severity.HINT] = " ",
					},
				},
			})

			vim.lsp.enable({
				"gopls",
				"jdtls",
				"clangd",
				"tinymist",
				"lua_ls",
				"marksman",
				"sqls",
				"templ",
				"htmx",
				"oxlint",
				"ts_ls",
			})
		end,
	},
}
