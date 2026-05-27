-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.opt.cursorline = true

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.log",
  callback = function()
    vim.api.nvim_set_hl(0, "LogFileLineError", { bg = "#990000", fg = "#FFFF00", bold = true })
    vim.api.nvim_set_hl(0, "LogFileLineWarn", { bg = "#FFFF00", fg = "#505050", bold = true })
    vim.fn.matchadd("LogFileLineError", [=[.*ERROR.*]=])
    vim.fn.matchadd("LogFileLineWarn", [=[.*WARN.*]=])
  end,
})
