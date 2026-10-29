vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		local bufnr = args.buf

		local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)
		if #lines == 0 then
			return
		end
		local first_line = lines[1]

		if first_line:match("AutoFormat:%s*ON%s*$") then
			local current_win = vim.api.nvim_get_current_win()
			local cursor_pos = vim.api.nvim_win_get_cursor(current_win)

			local success, _ = pcall(vim.lsp.buf.format, { bufnr = bufnr, async = false })

			if success then
				pcall(vim.api.nvim_win_set_cursor, current_win, cursor_pos)
				vim.notify("[AutoFormat] Successfully formatted", vim.log.levels.INFO)
			else
				vim.notify("[AutoFormat] Formatting failed. Is LSP active?", vim.log.levels.WARN)
			end
		end
	end,
})

vim.notify("Module autoformat loaded")
