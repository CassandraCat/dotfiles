local M = {}

M.config = function()
  local status_ok, move = pcall(require, "mini.move")
  if not status_ok then
    return
  end

  move.setup {
    -- Module mappings. Use `''` (empty string) to disable one.
    mappings = {
      -- Move visual selection in Visual mode.
      left = "<S-M-h>",
      right = "<S-M-l>",
      down = "<S-M-j>",
      up = "<S-M-k>",

      -- Move current line in Normal mode
      line_left = "",
      line_right = "",
      line_down = "<S-M-j>",
      line_up = "<S-M-k>",
    },
    -- Options which control moving behavior
    options = {
      -- Automatically reindent selection during linewise vertical move
      reindent_linewise = true,
    },
  }
end

return M
