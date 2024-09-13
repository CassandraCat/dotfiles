local M = {}

local create_aucmd = vim.api.nvim_create_autocmd

M.config = function()
  local user = vim.env.USER
  vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
      require("user.theme").telescope_theme {}
      if lvim.builtin.dap.active then
        require("user.dev_icons").define_dap_signs()
      end
      if lvim.use_icons == false and lvim.builtin.custom_web_devicons then
        require("user.dev_icons").set_icon()
      end
    end,
  })
  vim.api.nvim_clear_autocmds { pattern = "lir", group = "_filetype_settings" }
  vim.api.nvim_clear_autocmds { pattern = "*", group = "_lvim_colorscheme" }
  vim.api.nvim_create_augroup("_lvim_user", {})

  -- Autocommands
  if lvim.builtin.nonumber_unfocus then
    create_aucmd("WinEnter", { group = "_lvim_user", pattern = "*", command = "set relativenumber number cursorline" })
    create_aucmd(
      "WinLeave",
      { group = "_lvim_user", pattern = "*", command = "set norelativenumber nonumber nocursorline" }
    )
  end

  if lvim.transparent_window then
    create_aucmd("VimEnter", {
      group = "_lvim_user",
      pattern = "*",
      callback = function()
        local colorScheme = lvim.colorscheme
        local highlight_groups = {
          NormalFloat = "",
          WhichKeyFloat = "",
          CmpBorder = "",
          CmpPmenu = "",
          PmenuSbar = "",
          PmenuThumb = "",
          PmenuSel = "",
        }

        local function apply_highlights(groups, guibg, guifg)
          for group, fg in pairs(groups) do
            if fg ~= "" then
              vim.cmd(string.format("highlight %s guifg=%s guibg=%s", group, fg, guibg))
            else
              vim.cmd(string.format("highlight %s guibg=%s", group, guibg))
            end
          end
        end

        local color_schemes = {
          ["rose-pine"] = { PmenuSel = "#84Cee4", guibg = "#03080f" },
          ["tokyonight-moon"] = { PmenuSel = "#565f89", guibg = "#03080f" },
          ["catppuccin-mocha"] = { PmenuSel = "#6E6C7E", guibg = "#03080f" },
          ["kanagawa"] = { PmenuSel = "#938AA9", guibg = "#03080f" },
        }

        local selected_scheme = color_schemes[colorScheme] or color_schemes.default

        vim.schedule(function()
          highlight_groups.PmenuSel = selected_scheme.PmenuSel
          apply_highlights(highlight_groups, selected_scheme.guibg)
        end)
      end,
    })
  end

  if lvim.builtin.bigfile.active == false then
    vim.cmd [[
  " disable syntax highlighting in big files
  function! DisableSyntaxTreesitter()
      if exists(':TSBufDisable')
          exec 'TSBufDisable autotag'
          exec 'TSBufDisable highlight'
      endif

      set foldmethod=manual
      syntax clear
      syntax off
      filetype off
      set noundofile
      set noswapfile
      set noloadplugins
      set lazyredraw
  endfunction

  augroup BigFileDisable
      autocmd!
      autocmd BufReadPre,FileReadPre * if getfsize(expand("%")) > 1024 * 1024 | exec DisableSyntaxTreesitter() | endif
  augroup END
    ]]
  end

  if lvim.builtin.sql_integration.active then
    -- Add vim-dadbod-completion in sql files
    create_aucmd("FileType", {
      group = "_lvim_user",
      pattern = { "sql", "mysql", "plsql" },
      command = "lua require('cmp').setup.buffer { sources = { { name = 'vim-dadbod-completion' } } }",
    })
  end
  create_aucmd("TextYankPost", {
    group = "_general_settings",
    pattern = "*",
    desc = "Highlight text on yank",
    callback = function()
      require("vim.highlight").on_yank { higroup = "Search", timeout = 40 }
    end,
  })
  create_aucmd("BufWritePre", {
    group = "_lvim_user",
    pattern = { "/tmp/*", "COMMIT_EDITMSG", "MERGE_MSG", "*.tmp", "*.bak" },
    callback = function()
      vim.opt_local.undofile = false
    end,
  })

  create_aucmd("TermOpen", {
    group = "_lvim_user",
    pattern = "term://*",
    command = "lua require('user.keybindings').set_terminal_keymaps()",
  })
  if lvim.builtin.metals.active then
    create_aucmd("Filetype", {
      group = "_lvim_user",
      pattern = { "scala", "sbt" },
      callback = require("user.metals").start,
    })
  end
  create_aucmd("FileType", {
    group = "_lvim_user",
    pattern = "toml",
    command = "lua require('cmp').setup.buffer { sources = { { name = 'crates' } } }",
  })

  local codelens_viewer = "lua require('user.codelens').show_line_sign()"
  -- NOTE: don't give corporate code to the devil
  if user and user == "crazycatzhang" then
    if lvim.builtin.sell_your_soul_to_devil.active or lvim.builtin.tabnine.active then
      create_aucmd("UIEnter", {
        group = "_lvim_user",
        pattern = { "*" },
        callback = function()
          local dirpath = vim.fn.expand "%:p:h"
          if string.find(dirpath, user .. "/dev/src/git.") ~= nil then
            if lvim.builtin.sell_your_soul_to_devil.active then
              vim.cmd "Copilot disable"
            end
            if lvim.builtin.tabnine.active then
              require("cmp_tabnine.config"):setup { ignored_file_types = { "*" }, run_on_every_keystroke = false }
              lvim.builtin.cmp.sources = {
                { name = "nvim_lsp" },
                { name = "buffer", max_item_count = 5, keyword_length = 5 },
                { name = "path", max_item_count = 5 },
                { name = "luasnip", max_item_count = 3 },
                { name = "nvim_lua" },
                { name = "calc" },
                { name = "emoji" },
                { name = "treesitter" },
                { name = "latex_symbols" },
                { name = "crates" },
                { name = "orgmode" },
              }
            end
          end
        end,
      })
    end
    create_aucmd("CursorHold", {
      group = "_lvim_user",
      pattern = { "*.rs", "*.go", "*.ts", "*.tsx" },
      command = codelens_viewer,
    })
  end
end

M.make_run = function()
  create_aucmd("FileType", {
    group = "_lvim_user",
    pattern = { "c", "cpp" },
    callback = function()
      vim.keymap.set(
        "n",
        "<leader>m",
        "<cmd>lua require('lvim.core.terminal')._exec_toggle({cmd='make ;read',count=2,direction='float'})<CR>"
      )
      vim.keymap.set(
        "n",
        "<leader>r",
        "<cmd>lua require('lvim.core.terminal')._exec_toggle({cmd='make run;read',count=3,direction='float'})<CR>"
      )
    end,
  })
  create_aucmd("FileType", {
    group = "_lvim_user",
    pattern = "go",
    callback = function()
      vim.keymap.set(
        "n",
        "<leader>m",
        "<cmd>lua require('lvim.core.terminal')._exec_toggle({cmd='go build -v .;read',count=2,direction='float'})<CR>"
      )
      vim.keymap.set(
        "n",
        "<leader>r",
        "<cmd>lua require('lvim.core.terminal')._exec_toggle({cmd='go run .;read',count=3,direction='float'})<CR>"
      )
    end,
  })
  create_aucmd("FileType", {
    group = "_lvim_user",
    pattern = "python",
    callback = function()
      vim.keymap.set(
        "n",
        "<leader>r",
        "<cmd>lua require('lvim.core.terminal')._exec_toggle({cmd='python "
          .. vim.fn.expand "%"
          .. ";read',count=2,direction='float'})<CR>"
      )
      vim.keymap.set(
        "n",
        "<leader>m",
        "<cmd>lua require('lvim.core.terminal')._exec_toggle({cmd='echo \"compile :pepelaugh:\";read',count=2,direction='float'})<cr>"
      )
    end,
  })
end

return M
