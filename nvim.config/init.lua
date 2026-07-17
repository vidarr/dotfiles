-- ========================================================================== --
--  1b. DEIN CUSTOM COLOR-SCHEME (Orangefarbener Haupttext + Bunte Syntax)
-- ========================================================================== --
vim.opt.guifont = "Monospace:h18"
vim.opt.background = 'dark' -- Korrigierte native Lua-Variante

local schwarz = "#0F1112"          -- Sehr tiefes, modernes Anthrazit-Schwarz
local mein_orange = "#FF8C00"      -- Das satte Orange für deinen Haupttext

-- 1. Haupttext & Hintergrund
vim.api.nvim_set_hl(0, "Normal", { fg = mein_orange, bg = schwarz }) 
vim.api.nvim_set_hl(0, "Identifier", { fg = mein_orange }) -- Variablen/Bezeichner erben dein Orange

-- 2. Syntax-Highlighting (Eigene Farben für perfekte Unterscheidbarkeit)
vim.api.nvim_set_hl(0, "Statement", { fg = "#E06C75", bold = true }) -- if, else, return (Warmes Rot)
vim.api.nvim_set_hl(0, "Keyword",   { fg = "#C678DD", bold = true }) -- function, local, def (Edles Violett)
vim.api.nvim_set_hl(0, "Function",  { fg = "#61AFEF", bold = true }) -- Funktionsnamen (Klares Blau)
vim.api.nvim_set_hl(0, "String",    { fg = "#98C379" })               -- Text/Strings (Frisches Grün)
vim.api.nvim_set_hl(0, "Constant",  { fg = "#D19A66" })               -- Zahlen & Booleans (Mattes Gold)
vim.api.nvim_set_hl(0, "Type",      { fg = "#56B6C2" })               -- Datentypen wie int, string (Cyan)
vim.api.nvim_set_hl(0, "Comment",   { fg = "#5C6370", italic = true })-- Kommentare (Dezentes Grau)
vim.api.nvim_set_hl(0, "Special",   { fg = "#E5C07B" })               -- Sonderzeichen/Klammern (Gelb)

-- 3. UI-Elemente für nvim-qt Popups
vim.api.nvim_set_hl(0, "LineNr",    { fg = "#4B5263" })               -- Zeilennummern
vim.api.nvim_set_hl(0, "Visual",    { bg = "#2C313C" })               -- Markierter Text
vim.api.nvim_set_hl(0, "Pmenu",     { fg = mein_orange, bg = "#1E222A" }) -- Blink-Popup-Hintergrund
vim.api.nvim_set_hl(0, "PmenuSel",  { fg = schwarz, bg = mein_orange })   -- Blink-Auswahl

-- ========================================================================== --
--  1. NATIVE VIM-OPTIONEN (Traditionell & Schlank)
-- ========================================================================== --
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.number = true         -- Zeilennummern anzeigen
vim.opt.mouse = 'a'           -- Mausunterstützung aktivieren
vim.opt.clipboard = 'unnamedplus' -- System-Zwischenablage nutzen
vim.opt.breakindent = true    -- Zeilenumbrüche einrücken
vim.opt.undofile = true       -- Persistent Undo
vim.opt.ignorecase = true     -- Such-Großschreibung ignorieren...
vim.opt.smartcase = true      -- ...außer es wird explizit groß geschrieben
vim.opt.updatetime = 250      -- Schnellere Reaktion für LSP-Popups
vim.opt.signcolumn = 'yes'    -- Platz für LSP-Icons links freihalten
vim.opt.termguicolors = true  -- True Color Support

-- ========================================================================== --
--  2. LAZY.NVIM BOOTSTRAP (Paketmanager installieren)
-- ========================================================================== --
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system {
    'git', 'clone', '--filter=blob:none', '--branch=stable',
    'https://github.com', lazypath
  }
end
vim.opt.rtp:prepend(lazypath)

-- ========================================================================== --
--  3. PLUGIN-KONFIGURATION & MODERNES LSP (Neovim 0.11+)
-- ========================================================================== --
require('lazy').setup({

  -- Der moderne FuzzyFinder (Ersatz für dein altes Plugin)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'FuzzyFinder: Dateien' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'FuzzyFinder: Text' })
      vim.keymap.set('n', '<leader><space>', builtin.buffers, { desc = 'FuzzyFinder: Offene Buffer' })
    end
  },

  -- BLINK.CMP (Die ultraschnelle Autovervollständigung, Ersatz für CoC)
  {
    'saghen/blink.cmp',
    version = '*', -- Nutzt stabile Releases
    opts = {
      keymap = { preset = 'default' }, -- Pfeiltasten/Tab navigieren, Enter wählt aus
      appearance = { use_nvim_cmp_as_default = true },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
    },
  },

  -- NATIVES LSP FÜR NEOVIM 0.11+ (Reiner Datenspeicher + Autoinstaller)
  {
    'neovim/nvim-lspconfig', -- Liefert nur noch die Server-Definitionen, kein Framework mehr!
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
    config = function()
      -- Definiere hier deine gewünschten Sprachen
      local servers = { 'lua_ls' } 

      -- Mason sorgt dafür, dass die Server auf deiner Festplatte landen
      require('mason').setup()
      require('mason-lspconfig').setup({
        ensure_installed = servers,
      })

      -- Globale Grundeinstellung für ALLE LSP-Clients (Verknüpfung mit blink.cmp)
      vim.lsp.config('*', {
        capabilities = require('blink.cmp').get_lsp_capabilities()
      })

      -- Aktiviere jeden Server mit der neuen, nativen Neovim 0.11 API
      for _, server_name in ipairs(servers) do
        vim.lsp.enable(server_name)
      end

      -- Shortcut-Funktion für LSP-Funktionen (wie in CoC gewohnt)
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end
          -- Deine gewohnten Navigationstasten:
          map('gd', vim.lsp.buf.definition, 'Gehe zu Definition')
          map('gr', require('telescope.builtin').lsp_references, 'Gehe zu Referenzen')
          map('K', vim.lsp.buf.hover, 'Dokumentation anzeigen (Hover)')
          map('<leader>rn', vim.lsp.buf.rename, 'Variable umbenennen')
          map('<leader>ca', vim.lsp.buf.code_action, 'Code Action ausführen')
        end,
      })
    end
  },
})

-- ========================================================================== --
--  5. FUZZY-FINDER DIREKT BEI ':e ' UND ':b ' (Telescope-Dropdown)
-- ========================================================================== --
vim.api.nvim_create_autocmd("CmdlineChanged", {
  callback = function()
    local cmd = vim.fn.getcmdline()
    
    -- Gemeinsame Einstellungen für das schicke Dropdown-Aussehen
    local dropdown_opts = require('telescope.themes').get_dropdown({
      previewer = false, -- Macht das Fenster kompakt (keine große Code-Vorschau)
      winblend = 10,     -- Leichte Transparenz für modernen Look
    })

    -- Fall 1: Datei öffnen mit ':e '
    if cmd == "e " then
      vim.fn.setcmdline("") -- Befehlszeile leeren
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", false) -- Cmdline schließen
      
      dropdown_opts.prompt_title = "Datei öffnen (:e)"
      require('telescope.builtin').find_files(dropdown_opts)

    -- Fall 2: Buffer wechseln mit ':b '
    elseif cmd == "b " then
      vim.fn.setcmdline("") -- Befehlszeile leeren
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", false) -- Cmdline schließen
      
      dropdown_opts.prompt_title = "Buffer wechseln (:b)"
      require('telescope.builtin').buffers(dropdown_opts)
    end
  end,
})

