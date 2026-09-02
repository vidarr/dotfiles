vim.cmd('source /usr/share/nvim-qt/runtime/plugin/nvim_gui_shim.vim')

vim.opt.autochdir = true

vim.opt.textwidth = 80
vim.opt.colorcolumn = "80"

vim.opt.cursorline = true
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2d3139" })

vim.opt.guifont = "Monospace:h18"
vim.opt.background = 'dark'

local black = "#0F1112"
local orange = "#FF8C00"

vim.api.nvim_set_hl(0, "Normal", { fg = orange, bg = black }) 
vim.api.nvim_set_hl(0, "Identifier", { fg = orange })

vim.api.nvim_set_hl(0, "Statement", { fg = "#E06C75", bold = true })
vim.api.nvim_set_hl(0, "Keyword",   { fg = "#C678DD", bold = true })
vim.api.nvim_set_hl(0, "Function",  { fg = "#61AFEF", bold = true })
vim.api.nvim_set_hl(0, "String",    { fg = "#98C379" })
vim.api.nvim_set_hl(0, "Constant",  { fg = "#D19A66" })
vim.api.nvim_set_hl(0, "Type",      { fg = "#56B6C2" })
vim.api.nvim_set_hl(0, "Comment",   { fg = "#5C6370", italic = true })
vim.api.nvim_set_hl(0, "Special",   { fg = "#E5C07B" })

-- 3. UI-Elemente für nvim-qt Popups
vim.api.nvim_set_hl(0, "LineNr",    { fg = "#4B5263" })
vim.api.nvim_set_hl(0, "Visual",    { bg = "#2C313C" })
vim.api.nvim_set_hl(0, "Pmenu",     { fg = orange, bg = "#1E222A" })
vim.api.nvim_set_hl(0, "PmenuSel",  { fg = black, bg = orange })

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.number = true
vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamedplus'
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.updatetime = 250
vim.opt.signcolumn = 'yes'
vim.opt.termguicolors = true

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system {
        'git', 'clone', '--filter=blob:none', '--branch=stable',
        'https://github.com', lazypath
    }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({

    {
        "chentoast/marks.nvim",
        config = true
    };

    {
        "powerman/vim-plugin-ansiesc",
        lazy = false,
    },
    {
    "ibhagwan/fzf-lua",
    -- nvim-web-devicons sorgt für schöne Datei-Icons in der Liste
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- Aktiviert die Standardkonfiguration
      require("fzf-lua").setup({
        -- Hier kannst du später Anpassungen eintragen
      })

      -- Wichtige Tastenkombinationen (Keymaps) definieren:
      local fzf = require("fzf-lua")
      vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "Fzf: Buffer listen" })
      vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "Fzf: Dateien suchen" })
      vim.keymap.set("n", "<leader>fg", fzf.live_grep, { desc = "Fzf: Live Grep (Textsuche)" })
    end,
  },

  -- {
  --     'nvim-telescope/telescope.nvim',
  --     branch = '0.1.x',
  --     dependencies = { 'nvim-lua/plenary.nvim' },
  --     config = function()
  --         local builtin = require('telescope.builtin')
  --         vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'FuzzyFinder: Dateien' })
  --         vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'FuzzyFinder: Text' })
  --         vim.keymap.set('n', '<leader><space>', builtin.buffers, { desc = 'FuzzyFinder: Offene Buffer' })
  --     end
  -- },
  {
    'gelguy/wilder.nvim',
    config = function()
      local wilder = require('wilder')
      wilder.setup({modes = {':', '/', '?'}})
      wilder.set_option('renderer', wilder.popupmenu_renderer({
        highlighter = wilder.basic_highlighter(),
        left = {' ', wilder.popupmenu_devicons()}, -- Show file icons
      }))
    end
  },

  {
    'saghen/blink.cmp',
    version = '*',
    opts = {
      keymap = { preset = 'default' },
      appearance = { use_nvim_cmp_as_default = true },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
    },
  },

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
    config = function()
      local servers = { 'lua_ls', 'clangd' } 

      require('mason').setup()

      local lspconfig = require('lspconfig')

      local capabilities = require('blink.cmp').get_lsp_capabilities()

      require('mason-lspconfig').setup({
        ensure_installed = servers,
        handlers = {


          function(server_name)
            lspconfig[server_name].setup({
              capabilities = capabilities,
            })

          end,

          -- Spezifische Konfiguration für clangd
          ["clangd"] = function()
            lspconfig.clangd.setup({
              -- cmd = { "clangd", "--fallback-style={ ColumnLimit: 80 }" },
              cmd = { "clangd", "--background-index", "--header-insertion=iwyu"} ,  -- "--log=verbose" },
              root_dir = lspconfig.util.root_pattern('.clang-format', '.git', 'compile_commands.json') or vim.fn.getcwd,
              on_attach = function(client, bufnr)
                -- Automatisch beim Speichern formatieren
                vim.api.nvim_create_autocmd("BufWritePre", {
                  buffer = bufnr,
                  callback = function()
                    vim.lsp.buf.format({ bufnr = bufnr, async = false })
                  end,
                })
              end,
            })
          end,


        }
      })

      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end
          map('gd', vim.lsp.buf.definition, 'Gehe zu Definition')
          -- map('gr', require('telescope.builtin').lsp_references, 'Gehe zu Referenzen')
          map('K', vim.lsp.buf.hover, 'Dokumentation anzeigen (Hover)')
          map('<leader>rn', vim.lsp.buf.rename, 'Variable umbenennen')
          map('<leader>ca', vim.lsp.buf.code_action, 'Code Action ausführen')
          map('G=', function()
            vim.lsp.buf.format({ bufnr = event.buf, async = true })
          end, 'Code mit LSP formatieren')
        end,
      })

    end
  },

  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" }, -- Optionale fertige Snippets
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- LSP-Quelle für nvim-cmp
      "saadparwaiz1/cmp_luasnip", -- Verbindet Luasnip mit nvim-cmp
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      -- Lädt die friendly-snippets, falls installiert
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(), -- Menü manuell öffnen
          ["<C-e>"] = cmp.mapping.abort(),        -- Menü schließen
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Auswählen mit Enter
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" }, -- Zeigt LSP-Vorschläge an
          { name = "luasnip" },  -- Zeigt Snippets an
        }),
      })
    end,
  },
})

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Show LSP errors as pop-up" })
vim.keymap.set('n', '<leader>o', '<cmd>LspClangdSwitchSourceHeader<CR>', { desc = 'Switch between c/c++ headers and sources' })

vim.o.pumblend = 10
vim.o.wildoptions = "pum"

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.list = true



-- local builtin = require('telescope.builtin')
--
-- vim.keymap.set('n', '<leader>fd', function()
--     local current_dir = vim.fn.expand('%:p:h')
--     builtin.find_files({ cwd = current_dir })
-- end, { desc = 'Fuzzy find in current file dir' })
--

if vim.fn.exists(':GuiFont') == 2 or vim.g.neovim_qt then

  -- Adapt font size via ctrl-+ and ctrl--
  local function adjust_font_size(amount)

    local font = vim.opt.guifont:get()[1] or "Consolas:h11"

    local name, size = font:match("([^:]+):h(%d+)")
    if name and size then
      local new_size = tonumber(size) + amount
      vim.cmd(string.format("GuiFont! %s:h%d", name, new_size))
    end
  end

  vim.keymap.set({'n', 'v', 'i'}, '<C-=>', function() adjust_font_size(1) end, { silent = true })
  vim.keymap.set({'n', 'v', 'i'}, '<C-->', function() adjust_font_size(-1) end, { silent = true })

  -- Insert-Modus (schreibt danach nahtlos weiter)
  vim.keymap.set('i', '<C-ScrollWheelUp>', function() adjust_font_size(1) end, { silent = true })
  vim.keymap.set('i', '<C-ScrollWheelDown>', function() adjust_font_size(-1) end, { silent = true })
end

vim.opt.autowriteall = true
require("autoformat")
