local M = {}

M.config = function()
  if vim.fn.has "nvim-0.9" == 1 then
    vim.opt.mousescroll = { "ver:1", "hor:6" }
    vim.o.mousefocus = true
    vim.o.mousemoveevent = true
    vim.o.splitkeep = "screen"
  end

  lvim.builtin.lsp_lines = true
  vim.diagnostic.config { virtual_lines = true } -- i only want to use it explicitly ( by calling the toggle function)
  lvim.builtin.tmux_lualine = true
  if lvim.builtin.tmux_lualine then
    vim.opt.cmdheight = 0
    vim.opt.laststatus = 0
    vim.g.tpipeline_cursormoved = 1
    -- HACK: lualine hijacks the statusline, so we need to set it back to what we want
    if vim.env.TMUX then
      vim.cmd [[ autocmd VimEnter,WinEnter,BufEnter,VimResized,Filetype * setlocal laststatus=0 ]]
    end
  end
  -- NOTE: custom icons doesn't work with nerd font v3 yet
  lvim.builtin.custom_web_devicons = false
  lvim.use_icons = true -- only set to false if you know what are you doing
  lvim.builtin.sell_your_soul_to_devil.active = true
  lvim.builtin.sell_your_soul_to_devil.prada = false
  lvim.builtin.sell_your_soul_to_devil.openai = true -- NOTE: requires valid OPENAI_API_KEY environment variable
  lvim.lsp.document_highlight = false
  lvim.builtin.task_runner = "async_tasks"
  lvim.builtin.dap.active = true
  vim.g.instant_username = vim.env.USER
  lvim.builtin.global_statusline = true
  lvim.builtin.dressing.active = true
  lvim.builtin.fancy_wild_menu.active = true
  lvim.builtin.refactoring.active = true
  lvim.builtin.test_runner.runner = "neotest"
  lvim.format_on_save = {
    enabled = true,
    pattern = "*.rs",
    timeout = 2000,
    filter = require("lvim.lsp.utils").format_filter,
  }
  -- lvim.builtin.smooth_scroll = "cinnamon"
  lvim.builtin.tree_provider = "neo-tree"
  lvim.builtin.noice.active = true
  lvim.builtin.go_programming.active = true
  lvim.builtin.python_programming.active = true
  lvim.builtin.web_programming.active = true
  lvim.builtin.web_programming.extra = "typescript-tools.nvim"
  lvim.builtin.rust_programming.active = true
  lvim.builtin.cpp_programming.active = true
  lvim.builtin.borderless_cmp = true
  lvim.builtin.colored_args = true
  lvim.reload_config_on_save = false -- NOTE: i don't like this
  lvim.builtin.mind.active = true
  lvim.builtin.motion_provider = "flash"
  lvim.builtin.harpoon.active = true
  lvim.builtin.symbols_usage.active = true
  lvim.builtin.tag_provider = "outline"
  -- require("lvim.lsp.manager").setup("prosemd_lsp", {})
  lvim.builtin.fancy_diff = { active = true }
  lvim.builtin.nonumber_unfocus = true
  lvim.builtin.winbar_provider = "" -- hidden winbar
  lvim.builtin.tabnine = { active = true }
  lvim.builtin.sql_integration.active = true
  lvim.builtin.cursorline.active = true
  lvim.builtin.hlslens.active = true
  lvim.builtin.csv_support = true
  lvim.builtin.file_browser.active = true
  lvim.builtin.legendary.active = true
  lvim.builtin.cmp.cmdline.enable = true
  lvim.builtin.bigfile.active = true
  lvim.builtin.trouble.active = true
  lvim.builtin.mini = {
    animate = {
      active = true,
    },
    move = {
      active = true,
    },
    indentscope = {
      active = true,
    },
    completion = {
      active = false,
    },
  }

  -- Custom keybindings
  lvim.lsp.buffer_mappings.normal_mode["K"] = { "5k" }

  vim.g.python3_host_prog = "~/nvim-venv/bin/python"
  vim.g.ruby_host_prog = "/usr/local/lib/ruby/gems/3.1.0/bin/neovim-ruby-host"

  local pathsToAdd = {
    os.getenv "HOME" .. "/go/bin",
    "/usr/local/bin",
    os.getenv "HOME" .. "/nvim-venv/bin",
    os.getenv "HOME" .. "/Library/Application Support/Coursier/bin",
    os.getenv "HOME" .. "/.nix-profile/bin",
  }

  vim.env.PATH = vim.env.PATH .. ":" .. table.concat(pathsToAdd, ":")
end

return M
