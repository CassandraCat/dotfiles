local M = {}

M.config = function()
  local status_ok, trbl = pcall(require, "trouble")
  if not status_ok then
    return
  end

  trbl.setup {
    focus = true,
    preview = {
      type = "float",
      relative = "editor",
      border = "rounded",
      title = "Preview",
      title_pos = "center",
      position = { 0, -2 },
      size = { width = 0.4, height = 0.3 },
      zindex = 200,
    },
    modes = {
      lsp_references = { auto_jump = false },
      lsp_definitions = { auto_jump = false },
      lsp_implementations = { auto_jump = false },
      lsp_declarations = { auto_jump = false },
      lsp_incoming_calls = { auto_jump = false },
      lsp_outgoing_calls = { auto_jump = false },

      diagnostics_buffer = {
        mode = "diagnostics", -- inherit from diagnostics mode
        filter = { buf = 0 }, -- filter diagnostics to the current buffer
      },
    },
  }

  if lvim.transparent_window then
    vim.cmd [[ hi! TroubleNormal guibg=NONE ]]
    vim.cmd [[ hi! TroubleNormalNC guibg=NONE ]]
  end
end

return M
