local system = vim.uv.os_uname().sysname
local platform = {
	Darwin = { icon = "", name = "macOS" },
	Linux = { icon = "", name = "Linux" },
	Windows_NT = { icon = "󰍲", name = "Windows" },
}
local platform_info = platform[system] or { icon = "󰘧", name = system }
-- Original anime-style pixel art, rotated between Neovim launches.
-- The art data lives in config.dashboard_art (palette letters per pixel).
local dashboard_art_data = require("config.dashboard_art")

local art_state = vim.fn.stdpath("state") .. "/dashboard-art"
local read_ok, previous_art_lines = pcall(vim.fn.readfile, art_state)
local previous_art = read_ok and tonumber(previous_art_lines[1]) or nil
local entropy = os.time() + vim.fn.getpid() + tonumber(vim.uv.hrtime() % 1000000)
local art_index = entropy % #dashboard_art_data + 1
if art_index == previous_art then
	art_index = art_index % #dashboard_art_data + 1
end
vim.fn.mkdir(vim.fn.fnamemodify(art_state, ":h"), "p")
pcall(vim.fn.writefile, { tostring(art_index) }, art_state)
local dashboard_art = dashboard_art_data[art_index]

-- Cache one highlight group per foreground/background color pair.
local art_hl_cache = {}
local function art_hl(fg, bg)
	local key = fg .. "/" .. (bg or "")
	local name = art_hl_cache[key]
	if not name then
		name = "DashArt" .. (vim.tbl_count(art_hl_cache) + 1)
		vim.api.nvim_set_hl(0, name, { fg = fg, bg = bg })
		art_hl_cache[key] = name
	end
	return name
end

-- Render two pixel rows per line with half-block characters, so the art keeps
-- its proportions in a terminal cell grid. The leading empty span keeps the
-- alignment padding outside the colored spans: snacks would otherwise fold
-- padding into a single span and paint its background across the full width.
local function art_lines(art)
	local lines = {}
	for y = 1, art.height, 2 do
		local top = art.pixels[y]
		local bottom = art.pixels[y + 1]
		local spans = { { "" } }
		local run, run_fg, run_bg
		for x = 1, art.width do
			local fg = art.colors[top:sub(x, x)]
			local bg = bottom and art.colors[bottom:sub(x, x)] or nil
			if run and fg == run_fg and bg == run_bg then
				run = run .. "▀"
			else
				if run then
					spans[#spans + 1] = { run, hl = art_hl(run_fg, run_bg) }
				end
				run, run_fg, run_bg = "▀", fg, bg
			end
		end
		spans[#spans + 1] = { run, hl = art_hl(run_fg, run_bg) }
		lines[#lines + 1] = spans
	end
	return lines
end

local function dashboard_logo()
	local sections = {}
	for _, line in ipairs(art_lines(dashboard_art)) do
		sections[#sections + 1] = { text = line, align = "center" }
	end
	sections[#sections + 1] = {
		text = {
			{ platform_info.icon .. "  ", hl = "Function" },
			{ "Neovim · " .. platform_info.name, hl = "Comment" },
		},
		align = "center",
		padding = 1,
	}
	return sections
end

return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@type snacks.Config
		opts = {
			terminal = { enabled = false },
			bigfile = { enabled = true },
			quickfile = { enabled = true },
			notifier = { enabled = true, timeout = 3000 },
			statuscolumn = { enabled = true },
			words = { enabled = true },
			-- Smooth scrolling
			scroll = { enabled = true },
			indent = {
				enabled = true,
				char = "▏",
				-- Aktueller Scope dezent hervorgehoben
				scope = { enabled = true, char = "▏", hl = "Comment" },
				animate = { enabled = true },
			},
			input = { enabled = true },
			picker = {
				enabled = true,
				ui_select = true,
				sources = {
					files = { hidden = true },
					explorer = {
						hidden = true,
						ignored = true,
					},
				},
			},
			explorer = {
				replace_netrw = true,
			},
			dashboard = {
				width = 110,
				sections = {
					dashboard_logo,
					{
						text = {
							{ "  " .. os.date("%H:%M"), hl = "special" },
							{ "    " .. os.date("%a, %d. %b %Y"), hl = "footer" },
						},
						align = "center",
						padding = 1,
					},
					{ section = "keys", gap = 1, padding = 1 },
					{ section = "recent_files", title = "Recent", padding = 1 },
					{ section = "startup" },
				},
			},
		},
		config = function(_, opts)
			require("snacks").setup(opts)
			-- Snacks reicht den vollen Pfad an nvim-web-devicons weiter, der
			-- Icon-Lookup erwartet aber den reinen Dateinamen. Sonst bekommen
			-- "Dockerfile", "LICENSE" usw. nur das generische Icon.
			local icon = Snacks.util.icon
			Snacks.util.icon = function(name, cat, o)
				if cat == "file" and type(name) == "string" then
					name = vim.fs.basename(name)
				end
				return icon(name, cat, o)
			end
		end,
	},
}
