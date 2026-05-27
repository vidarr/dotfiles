-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.opt.cursorline = true

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.log",
  callback = function()
    vim.api.nvim_set_hl(0, "LogFileLineError", { bg = "#990000", fg = "#FFFF00", bold = true })
    vim.api.nvim_set_hl(0, "LogFileLineWarn", { bg = "#FFFF00", fg = "#505050", bold = true })
    vim.api.nvim_set_hl(0, "LogFileLineInfo", { bg = "#004999", fg = "#FFFFFF", bold = false })
    vim.api.nvim_set_hl(0, "LogFileLineDebug", { bg = "#0080FF", fg = "#FFFFFF", bold = false })
    vim.fn.matchadd("LogFileLineError", [=[.*ERROR.*]=])
    vim.fn.matchadd("LogFileLineWarn", [=[.*WARN.*]=])
    vim.fn.matchadd("LogFileLineInfo", [=[.*INFO.*]=])
    vim.fn.matchadd("LogFileLineDebug", [=[.*DEBUG.*]=])
  end,
})
