local map = vim.keymap.set
local documents = require("config.documents")

-- Standard
map("n", ";", ":", { desc = "Command mode" })
map("i", "jk", "<ESC>")
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Suche-Highlight aus" })

-- Fenster-Navigation (<C-h/j/k/l>) kommt von vim-tmux-navigator (plugins/motion.lua)

-- Explorer (Snacks, ersetzt NvimTree)
map("n", "<leader>e", function()
  Snacks.explorer()
end, { desc = "Explorer" })

-- Picker (Snacks, ersetzt Telescope)
map("n", "<leader>ff", function()
  Snacks.picker.files()
end, { desc = "Find Files" })
map("n", "<leader>fw", function()
  Snacks.picker.grep()
end, { desc = "Grep" })
map("n", "<leader>fb", function()
  Snacks.picker.buffers()
end, { desc = "Buffers" })
map("n", "<leader>fo", function()
  Snacks.picker.recent()
end, { desc = "Recent Files" })
map("n", "<leader>fh", function()
  Snacks.picker.help()
end, { desc = "Help" })
map("n", "<leader>fk", function()
  Snacks.picker.keymaps()
end, { desc = "Keymaps" })
map("n", "<leader>fc", function()
  Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Nvim-Config" })

function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  -- Drücke <Esc> im Terminal, um in den Normal-Mode des Terminals zu wechseln
  vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], opts)

  -- Ermöglicht Fenster-Navigation direkt aus dem Terminal-Modus
  vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
end

-- Wendet die Keymaps automatisch an, sobald ein Toggleterm-Fenster öffnet
vim.cmd("autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()")

-- Git
map("n", "<leader>gg", function()
  Snacks.lazygit()
end, { desc = "Lazygit" })
map("n", "<leader>gm", function()
  print(vim.fn.system("git checkout main && git fetch && git pull"))
end, { desc = "Git: main + fetch + pull" })

-- Dokumente (LaTeX/Typst/PDF): kompilieren und extern öffnen
map("n", "<leader>do", documents.open_pdf, { desc = "Open PDF (kompilieren + extern)" })
map("n", "<leader>dc", documents.compile, { desc = "Nur kompilieren" })
map("n", "<leader>dp", documents.pick_pdf, { desc = "PDF-Palette" })

-- Markdown
map("n", "<leader>mf", function()
  vim.system({ "open", "-a", "MarkEdit", vim.fn.expand("%:p") })
end, { desc = "In MarkEdit öffnen" })

-- Buffer manuell formatieren (z.B. Markdown-Tabellen via prettier ausrichten)
map({ "n", "v" }, "<leader>cf", function()
  require("conform").format({ lsp_format = "fallback" })
end, { desc = "Format Buffer" })

-- Diagnostics (LSP-Keymaps stehen in config/autocmds.lua, nur mit aktivem LSP)
map("n", "<leader>fd", function()
  Snacks.picker.diagnostics()
end, { desc = "Diagnostics" })
