local M = {}

M.config = function()
  local status_ok, completion = pcall(require, "mini.completion")
  if not status_ok then
    return
  end

  completion.setup {
    -- Delay (debounce type, in ms) between certain Neovim event and action.
    -- This can be used to (virtually) disable certain automatic actions by
    -- setting very high delay time (like 10^7).
    delay = { completion = 500, info = 500, signature = 250 },

    -- Configuration for action windows:
    -- - `height` and `width` are maximum dimensions.
    -- - `border` defines border (as in `nvim_open_win()`).
    window = {
      info = { height = 25, width = 80, border = "none" },
      signature = { height = 25, width = 80, border = "none" },
    },

    -- Way of how module does LSP completion
    lsp_completion = {
      -- `source_func` should be one of 'completefunc' or 'omnifunc'.
      source_func = "completefunc",

      -- `auto_setup` should be boolean indicating if LSP completion is set up
      -- on every `BufEnter` event.
      auto_setup = false,

      -- `process_items` should be a function which takes LSP
      -- 'textDocument/completion' response items and word to complete. Its
      -- output should be a table of the same nature as input items. The most
      -- common use-cases are custom filtering and sorting. You can use
      -- default `process_items` as `MiniCompletion.default_process_items()`.
      -- process_items = --<function: filters out snippets; sorts by LSP specs>,
    },

    -- Fallback action. It will always be run in Insert mode. To use Neovim's
    -- built-in completion (see `:h ins-completion`), supply its mapping as
    -- string. Example: to use 'whole lines' completion, supply '<C-x><C-l>'.
    -- fallback_action = --<function: like `<C-n>` completion>,

    -- Module mappings. Use `''` (empty string) to disable one. Some of them
    -- might conflict with system mappings.
    mappings = {
      force_twostep = "", -- Force two-step completion
      force_fallback = "", -- Force fallback completion
    },

    -- Whether to set Vim's settings for better experience (modifies
    -- `shortmess` and `completeopt`)
    set_vim_settings = false,
  }
end

return M
