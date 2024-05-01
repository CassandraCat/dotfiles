local M = {}

M.config = function()
  local status_ok, animate = pcall(require, "mini.animate")
  if not status_ok then
    return
  end

  animate.setup {
    -- Cursor path
    cursor = {
      enable = true,
    },

    -- Vertical scroll
    scroll = {
      -- Whether to enable this animation
      enable = true,
    },

    -- Window resize
    resize = {
      -- Whether to enable this animation
      enable = true,
    },

    -- Window open
    open = {
      -- Whether to enable this animation
      enable = true,
    },

    -- Window close
    close = {
      -- Whether to enable this animation
      enable = true,
    },
  }
end

return M
