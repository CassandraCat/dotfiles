local M = {}

M.config = function()
  local neoclip_req = { "kkharji/sqlite.lua" }
  if lvim.builtin.neoclip.enable_persistent_history == false then
    neoclip_req = {}
  end
  lvim.plugins = {
    {
      "folke/tokyonight.nvim",
      config = function()
        require("user.theme").tokyonight()
        local _time = os.date "*t"
        if (_time.hour >= 9 and _time.hour < 17) and lvim.builtin.time_based_themes then
          lvim.colorscheme = "tokyonight-moon"
        end
      end,
    },
    {
      "rose-pine/neovim",
      name = "rose-pine",
      config = function()
        require("user.theme").rose_pine()
        local _time = os.date "*t"
        if (_time.hour >= 1 and _time.hour < 9) and lvim.builtin.time_based_themes then
          lvim.colorscheme = "rose-pine"
        end
      end,
    },
    {
      "catppuccin/nvim",
      name = "catppuccin",
      config = function()
        require("user.theme").catppuccin()
        local _time = os.date "*t"
        if (_time.hour >= 17 and _time.hour < 21) and lvim.builtin.time_based_themes then
          lvim.colorscheme = "catppuccin-mocha"
        end
      end,
    },
    {
      "rebelot/kanagawa.nvim",
      config = function()
        require("user.theme").kanagawa()
        local _time = os.date "*t"
        if
          ((_time.hour >= 21 and _time.hour < 24) or (_time.hour >= 0 and _time.hour < 1))
          and lvim.builtin.time_based_themes
        then
          lvim.colorscheme = "kanagawa"
        end
      end,
    },
    {
      "ray-x/lsp_signature.nvim",
      config = function()
        require("user/lsp_signature").config()
      end,
      event = { "BufRead", "BufNew" },
    },
    {
      "vladdoster/remember.nvim",
      config = function()
        require("remember").setup {}
      end,
      enabled = lvim.builtin.lastplace.active,
    },
    {
      "folke/todo-comments.nvim",
      dependencies = "nvim-lua/plenary.nvim",
      config = function()
        require("user.todo_comments").config()
      end,
      event = "BufRead",
    },
    {
      "folke/trouble.nvim",
      config = function()
        require("user.trouble").config()
      end,
      event = "VeryLazy",
      cmd = "Trouble",
      enabled = lvim.builtin.trouble.active,
    },
    {
      "ggandor/leap.nvim",
      config = function()
        require("user.leap").config()
      end,
      enabled = lvim.builtin.motion_provider == "leap",
    },
    {
      "phaazon/hop.nvim",
      event = "VeryLazy",
      cmd = { "HopChar1CurrentLineAC", "HopChar1CurrentLineBC", "HopChar2MW", "HopWordMW" },
      config = function()
        require("user.hop").config()
      end,
      enabled = lvim.builtin.motion_provider == "hop",
    },
    {
      "simrat39/symbols-outline.nvim",
      config = function()
        require("user.symbols_outline").config()
      end,
      event = "BufReadPost",
      enabled = lvim.builtin.tag_provider == "symbols-outline",
    },
    {
      "tzachar/cmp-tabnine",
      build = "./install.sh",
      dependencies = "hrsh7th/nvim-cmp",
      config = function()
        local tabnine = require "cmp_tabnine.config"
        tabnine:setup {
          max_lines = 1000,
          max_num_results = 10,
          sort = true,
        }
      end,
      lazy = true,
      event = "InsertEnter",
      enabled = lvim.builtin.tabnine.active,
    },
    {
      "folke/twilight.nvim",
      lazy = true,
      config = function()
        require("user.twilight").config()
      end,
    },
    {
      "kevinhwang91/nvim-bqf",
      event = "WinEnter",
      config = function()
        require("user.bqf").config()
      end,
    },
    {
      "mrcjkb/rustaceanvim",
      init = function()
        require("user.rust_tools").config()
      end,
      ft = { "rust", "rs" },
      enabled = lvim.builtin.rust_programming.active,
    },
    {
      "maan2003/lsp_lines.nvim",
      lazy = true,
      config = function()
        require("lsp_lines").setup()
      end,
      enabled = lvim.builtin.lsp_lines,
    },
    {
      "folke/zen-mode.nvim",
      lazy = true,
      cmd = "ZenMode",
      config = function()
        require("user.zen").config()
      end,
    },
    {
      "nvim-pack/nvim-spectre",
      lazy = true,
      config = function()
        require("user.spectre").config()
      end,
    },
    {
      "norcalli/nvim-colorizer.lua",
      config = function()
        require("user.colorizer").config()
      end,
      event = "BufReadPre",
    },
    {
      "olimorris/persisted.nvim",
      event = "BufReadPre",
      lazy = true,
      config = function()
        require("user.persist").config()
      end,
      enabled = lvim.builtin.persistence.active,
    },
    {
      "andweeb/presence.nvim",
      config = function()
        require("user.presence").config()
      end,
      enabled = lvim.builtin.presence.active,
    },
    { "mfussenegger/nvim-jdtls", ft = "java" },
    {
      "kristijanhusak/orgmode.nvim",
      keys = { "go", "gC" },
      ft = { "org" },
      config = function()
        require("user.orgmode").setup()
      end,
      enabled = lvim.builtin.orgmode.active,
    },
    {
      "danymat/neogen",
      lazy = true,
      config = function()
        require("neogen").setup {
          enabled = true,
        }
      end,
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
        config = function()
          require("nvim-treesitter.install").prefer_git = true
        end,
      },
    },
    {
      "vim-test/vim-test",
      cmd = { "TestNearest", "TestFile", "TestSuite", "TestLast", "TestVisit" },
      config = function()
        require("user.vim_test").config()
      end,
      enabled = (lvim.builtin.test_runner.active and lvim.builtin.test_runner.runner == "ultest"),
    },
    {
      -- NOTE: This plugin is not maintained anymore, you might wanna use https://github.com/pmizio/typescript-tools.nvim
      "jose-elias-alvarez/typescript.nvim",
      ft = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
      },
      lazy = true,
      config = function()
        require("user.tss").config()
      end,
      enabled = (lvim.builtin.web_programming.active and lvim.builtin.web_programming.extra == "typescript.nvim"),
    },
    {
      "vuki656/package-info.nvim",
      config = function()
        require("package-info").setup()
      end,
      lazy = true,
      event = { "BufReadPre", "BufNew" },
      enabled = lvim.builtin.web_programming.active,
    },
    {
      "lervag/vimtex",
      init = function()
        require("user.tex").init()
      end,
      config = function()
        vim.cmd "call vimtex#init()"
      end,
      ft = "tex",
      event = "VeryLazy",
      enabled = lvim.builtin.latex.active,
    },
    {
      "nvim-neotest/neotest",
      config = function()
        require("user.ntest").config()
      end,
      dependencies = {
        { "nvim-neotest/neotest-plenary" },
      },
      event = { "BufReadPost", "BufNew" },
      enabled = (lvim.builtin.test_runner.active and lvim.builtin.test_runner.runner == "neotest"),
    },
    { "nvim-neotest/neotest-go", event = { "BufEnter *.go" } },
    { "nvim-neotest/neotest-python", event = { "BufEnter *.py" } },
    { "rouge8/neotest-rust", event = { "BufEnter *.rs" } },
    { "lawrence-laz/neotest-zig", event = { "BufEnter *.zig" } },
    {
      "rcarriga/vim-ultest",
      cmd = { "Ultest", "UltestSummary", "UltestNearest" },
      dependencies = { "vim-test/vim-test" },
      build = ":UpdateRemotePlugins",
      lazy = true,
      event = { "BufEnter *_test.*,*_spec.*,*est_*.*" },
      enabled = (lvim.builtin.test_runner.active and lvim.builtin.test_runner.runner == "ultest"),
    },
    {
      "akinsho/flutter-tools.nvim",
      dependencies = "nvim-lua/plenary.nvim",
      config = function()
        require("user.flutter_tools").config()
      end,
      ft = "dart",
    },
    {
      "RishabhRD/nvim-cheat.sh",
      dependencies = "RishabhRD/popfix",
      config = function()
        vim.g.cheat_default_window_layout = "vertical_split"
      end,
      lazy = true,
      cmd = { "Cheat", "CheatWithoutComments", "CheatList", "CheatListWithoutComments" },
      keys = "<leader>?",
      enabled = lvim.builtin.cheat.active,
    },
    {
      "AckslD/nvim-neoclip.lua",
      config = function()
        require("user.neoclip").config()
      end,
      lazy = true,
      keys = "<leader>y",
      dependencies = neoclip_req,
      enabled = lvim.builtin.neoclip.active,
    },
    {
      "kristijanhusak/vim-dadbod-completion",
      enabled = lvim.builtin.sql_integration.active,
    },
    {
      "kristijanhusak/vim-dadbod-ui",
      cmd = {
        "DBUIToggle",
        "DBUIAddConnection",
        "DBUI",
        "DBUIFindBuffer",
        "DBUIRenameBuffer",
      },
      init = function()
        vim.g.db_ui_use_nerd_fonts = 1
        vim.g.db_ui_show_database_icon = 1
      end,
      dependencies = {
        {
          "tpope/vim-dadbod",
          lazy = true,
        },
      },
      lazy = true,
      enabled = lvim.builtin.sql_integration.active,
    },
    {
      "karb94/neoscroll.nvim",
      config = function()
        require("neoscroll").setup {
          easing_function = "quadratic",
          hide_cursor = true,
        }
      end,
      event = "BufRead",
      enabled = lvim.builtin.smooth_scroll == "neoscroll",
    },
    {
      "declancm/cinnamon.nvim",
      config = function()
        require("cinnamon").setup {
          keymaps = { basic = true, extra = false },
          options = {
            mode = "window",
          },
        }
      end,
      event = "BufRead",
      enabled = lvim.builtin.smooth_scroll == "cinnamon",
    },
    {
      "github/copilot.vim",
      config = function()
        require("user.copilot").config()
      end,
      enabled = lvim.builtin.sell_your_soul_to_devil.active or lvim.builtin.sell_your_soul_to_devil.prada,
    },
    {
      "zbirenbaum/copilot.lua",
      dependencies = { "zbirenbaum/copilot-cmp", "nvim-cmp" },
      config = function()
        local cmp_source = { name = "copilot", group_index = 2 }
        table.insert(lvim.builtin.cmp.sources, cmp_source)
        vim.defer_fn(function()
          require("copilot").setup()
        end, 100)
      end,
      enabled = lvim.builtin.sell_your_soul_to_devil.prada,
    },
    {
      "ThePrimeagen/harpoon",
      dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-lua/popup.nvim" },
      },
      enabled = lvim.builtin.harpoon.active,
    },
    {
      "sindrets/diffview.nvim",
      lazy = true,
      cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
      keys = { "<leader>gd", "<leader>gh" },
      config = function()
        require("user.diffview").config()
      end,
      enabled = lvim.builtin.fancy_diff.active,
    },
    {
      "chipsenkbeil/distant.nvim",
      lazy = true,
      build = { "DistantInstall" },
      cmd = { "DistantLaunch", "DistantRun" },
      config = function()
        require("distant").setup {
          ["*"] = vim.tbl_extend(
            "force",
            require("distant.settings").chip_default(),
            { mode = "ssh" } -- use SSH mode by default
          ),
        }
      end,
      enabled = lvim.builtin.remote_dev.active,
    },
    {
      "abzcoding/nvim-mini-file-icons",
      config = function()
        require("nvim-web-devicons").setup()
      end,
      enabled = lvim.builtin.custom_web_devicons or not lvim.use_icons,
    },
    { "mtdl9/vim-log-highlighting", ft = { "text", "log" } },
    {
      "yamatsum/nvim-cursorline",
      lazy = true,
      event = "BufWinEnter",
      enabled = lvim.builtin.cursorline.active,
    },
    {
      "abecodes/tabout.nvim",
      config = function()
        require("user.tabout").config()
      end,
    },
    {
      "kevinhwang91/nvim-hlslens",
      config = function()
        require("user.hlslens").config()
      end,
      event = "BufReadPost",
      enabled = lvim.builtin.hlslens.active,
    },
    {
      "chrisbra/csv.vim",
      ft = { "csv" },
      enabled = lvim.builtin.csv_support,
    },
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      lazy = true,
      event = "BufReadPre",
      dependencies = "nvim-treesitter",
    },
    {
      "sidebar-nvim/sidebar.nvim",
      config = function()
        require("user.sidebar").config()
      end,
      -- event = "BufRead",
      enabled = lvim.builtin.sidebar.active,
    },
    {
      "skywind3000/asynctasks.vim",
      dependencies = {
        { "skywind3000/asyncrun.vim" },
      },
      init = function()
        vim.cmd [[
          let g:asyncrun_open = 8
          let g:asynctask_template = '~/.config/lvim/task_template.ini'
          let g:asynctasks_extra_config = ['~/.config/lvim/tasks.ini']
        ]]
      end,
      event = { "BufRead", "BufNew" },
      enabled = lvim.builtin.task_runner == "async_tasks",
    },
    {
      "scalameta/nvim-metals",
      dependencies = { "nvim-lua/plenary.nvim" },
      enabled = lvim.builtin.metals.active,
    },
    {
      "jbyuki/instant.nvim",
      event = "BufRead",
      enabled = lvim.builtin.collaborative_editing.active,
    },
    {
      "nvim-telescope/telescope-file-browser.nvim",
      enabled = lvim.builtin.file_browser.active,
    },
    {
      "nvim-telescope/telescope-live-grep-args.nvim",
    },
    {
      "j-hui/fidget.nvim",
      config = function()
        require("user.fidget_spinner").config()
      end,
    },
    {
      "michaelb/sniprun",
      build = "bash ./install.sh",
      enabled = lvim.builtin.sniprun.active,
    },
    {
      "liuchengxu/vista.vim",
      init = function()
        require("user.vista").config()
      end,
      event = "BufReadPost",
      enabled = lvim.builtin.tag_provider == "vista",
    },
    {
      "p00f/clangd_extensions.nvim",
      ft = { "c", "cpp", "objc", "objcpp", "h", "hpp" },
      enabled = lvim.builtin.cpp_programming.active,
    },
    {
      "saecki/crates.nvim",
      event = { "BufRead Cargo.toml" },
      dependencies = { { "nvim-lua/plenary.nvim" } },
      config = function()
        require("user.crates").config()
      end,
      enabled = lvim.builtin.rust_programming.active,
    },
    {
      "hrsh7th/cmp-cmdline",
      enabled = lvim.builtin.fancy_wild_menu.active,
    },
    {
      "mrjones2014/legendary.nvim",
      config = function()
        require("user.legendary").config()
      end,
      event = "VimEnter",
      enabled = lvim.builtin.legendary.active,
    },
    {
      "stevearc/dressing.nvim",
      lazy = true,
      config = function()
        require("user.dress").config()
      end,
      enabled = lvim.builtin.dressing.active,
      event = "BufWinEnter",
    },
    {
      "kdheepak/cmp-latex-symbols",
      dependencies = "hrsh7th/nvim-cmp",
      ft = "tex",
    },
    {
      "ThePrimeagen/refactoring.nvim",
      lazy = true,
      ft = { "typescript", "javascript", "lua", "c", "cpp", "go", "python", "java", "php" },
      event = "BufReadPost",
      config = function()
        require("refactoring").setup {}
      end,
      enabled = lvim.builtin.refactoring.active,
    },
    {
      "b0o/incline.nvim",
      config = function()
        require("user.incline").config()
      end,
      enabled = lvim.builtin.winbar_provider == "filename",
    },
    {
      "fgheng/winbar.nvim",
      config = function()
        require("user.winb").config()
      end,
      event = { "InsertEnter", "CursorHoldI" },
      enabled = lvim.builtin.winbar_provider == "treesitter",
    },
    {
      "SmiteshP/nvim-gps",
      -- module_pattern = { "gps", "nvim-gps" },
      config = function()
        require("user.gps").config()
      end,
      dependencies = "nvim-treesitter/nvim-treesitter",
      event = { "InsertEnter", "CursorHoldI" },
      enabled = lvim.builtin.winbar_provider == "treesitter",
    },
    {
      "SmiteshP/nvim-navic",
      config = function()
        require("user.navic").config()
      end,
      dependencies = "neovim/nvim-lspconfig",
      event = { "InsertEnter", "CursorHoldI" },
      enabled = false,
    },
    {
      "vimpostor/vim-tpipeline",
      enabled = lvim.builtin.tmux_lualine,
    },
    {
      "stevearc/overseer.nvim",
      config = function()
        require("user.ovs").config()
      end,
      enabled = lvim.builtin.task_runner == "overseer",
    },
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v2.x",
      cmd = "Neotree",
      dependencies = {
        "MunifTanjim/nui.nvim",
      },
      config = function()
        require("user.neotree").config()
      end,
      enabled = lvim.builtin.tree_provider == "neo-tree",
    },
    { "MunifTanjim/nui.nvim" },
    {
      "folke/noice.nvim",
      event = "VeryLazy",
      config = function()
        require("user.noice").config()
      end,
      dependencies = {
        "rcarriga/nvim-notify",
        config = function()
          local notify = require "notify"
          notify.setup {
            on_open = function(win)
              vim.api.nvim_win_set_config(win, { border = "none" })
            end,
            background_colour = "#202020",
            fps = 60,
            level = 2,
            minimum_width = 50,
            render = "compact",
            stages = "fade_in_slide_out",
            timeout = 3000,
            top_down = true,
          }
        end,
      },
      enabled = lvim.builtin.noice.active,
    },
    {
      "olexsmir/gopher.nvim",
      config = function()
        require("gopher").setup {
          commands = {
            go = "go",
            gomodifytags = "gomodifytags",
            gotests = "gotests",
            impl = "impl",
            iferr = "iferr",
          },
        }
      end,
      ft = { "go", "gomod" },
      event = { "BufRead", "BufNew" },
      enabled = lvim.builtin.go_programming.active,
    },
    {
      "leoluz/nvim-dap-go",
      config = function()
        require("dap-go").setup()
      end,
      ft = { "go", "gomod" },
      event = { "BufRead", "BufNew" },
      enabled = lvim.builtin.go_programming.active,
    },
    {
      "AckslD/swenv.nvim",
      enabled = lvim.builtin.python_programming.active,
      ft = "python",
      event = { "BufRead", "BufNew" },
    },
    {
      "mfussenegger/nvim-dap-python",
      config = function()
        local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/")
        require("dap-python").setup(mason_path .. "packages/debugpy/venv/bin/python")
        require("dap-python").test_runner = "pytest"
      end,
      ft = "python",
      event = { "BufRead", "BufNew" },
      enabled = lvim.builtin.python_programming.active,
    },
    {
      "mxsdev/nvim-dap-vscode-js",
      ft = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
      },
      lazy = true,
      event = { "BufReadPre", "BufNew" },
      config = function()
        require("dap-vscode-js").setup {
          debugger_path = vim.fn.stdpath "data" .. "/mason/packages/js-debug-adapter",
          debugger_cmd = { "js-debug-adapter" },
          adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
        }
      end,
      enabled = lvim.builtin.web_programming.active,
    },
    {
      "smjonas/inc-rename.nvim",
      lazy = true,
      cmd = "IncRename",
      config = function()
        require("inc_rename").setup()
      end,
      enabled = lvim.builtin.noice.active,
    },
    {
      "m-demare/hlargs.nvim",
      lazy = true,
      event = "VeryLazy",
      config = function()
        require("hlargs").setup {
          excluded_filetype = { "TelescopePrompt", "guihua", "guihua_rust", "clap_input" },
        }
      end,
      dependencies = { "nvim-treesitter/nvim-treesitter" },
      enabled = lvim.builtin.colored_args,
    },
    {
      "cshuaimin/ssr.nvim",
      lazy = true,
      config = function()
        require("ssr").setup {
          min_width = 50,
          min_height = 5,
          keymaps = {
            close = "q",
            next_match = "n",
            prev_match = "N",
            replace_all = "<leader><cr>",
          },
        }
      end,
      event = { "BufReadPost", "BufNew" },
    },
    {
      "Civitasv/cmake-tools.nvim",
      config = function()
        require("user.cle").cmake_config()
      end,
      ft = { "c", "cpp", "objc", "objcpp", "h", "hpp" },
      enabled = lvim.builtin.cpp_programming.active,
    },
    {
      "raimon49/requirements.txt.vim",
      event = "VeryLazy",
      enabled = lvim.builtin.python_programming.active,
    },
    {
      "Selyss/mind.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        require("user.mind").config()
      end,
      event = "VeryLazy",
      enabled = lvim.builtin.mind.active,
    },
    {
      "ibhagwan/fzf-lua",
      config = function()
        -- calling `setup` is optional for customization
        local ff = require "user.fzf"
        require("fzf-lua").setup(vim.tbl_deep_extend("keep", vim.deepcopy(ff.active_profile), ff.default_opts))
      end,
      enabled = not lvim.builtin.telescope.active,
    },
    {
      "folke/flash.nvim",
      event = "VeryLazy",
      keys = require("user.flash").keys,
      enabled = lvim.builtin.motion_provider == "flash",
    },
    {
      "piersolenski/wtf.nvim",
      dependencies = {
        "MunifTanjim/nui.nvim",
      },
      event = "VeryLazy",
      opts = {
        popup_type = "vertical",
      },
      keys = {
        {
          "gw",
          mode = { "n" },
          function()
            require("wtf").ai()
          end,
          desc = "Debug diagnostic with AI",
        },
        {
          mode = { "n" },
          "gW",
          function()
            require("wtf").search()
          end,
          desc = "Search diagnostic with Google",
        },
      },
      enabled = lvim.builtin.sell_your_soul_to_devil.openai,
    },
    {
      "james1236/backseat.nvim",
      config = function()
        require("backseat").setup {
          highlight = {
            icon = "󰳃 ",
            group = "SpecialComment",
          },
        }
      end,
      event = "VeryLazy",
      enabled = lvim.builtin.sell_your_soul_to_devil.openai,
    },
    {
      "lukas-reineke/indent-blankline.nvim",
      name = "new-indent",
      main = "ibl",
      config = function()
        require("user.indent_blankline").setup()
      end,
      enabled = lvim.builtin.indentlines.mine,
    },
    {
      "Wansmer/symbol-usage.nvim",
      event = "LspAttach",
      enabled = lvim.builtin.symbols_usage.active,
      config = function()
        require("user.symbol_use").config()
      end,
    },
    {
      "hedyhli/outline.nvim",
      config = function()
        require("user.outline").config()
      end,
      event = "BufReadPost",
      enabled = lvim.builtin.tag_provider == "outline",
    },
    {
      "pmizio/typescript-tools.nvim",
      ft = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
      },
      lazy = true,
      config = function()
        require("user.typtools").config()
      end,
      enabled = (lvim.builtin.web_programming.active and lvim.builtin.web_programming.extra == "typescript-tools.nvim"),
    },
    {
      "SR-Mystar/yazi.nvim",
      lazy = true,
      cmd = "Yazi",
      opts = {
        border = "none",
      },
      keys = {},
    },
    {
      "kylechui/nvim-surround",
      version = "*",
      event = "VeryLazy",
      config = function()
        require("nvim-surround").setup {}
      end,
    },
    {
      "preservim/vim-markdown",
      ft = "markdown",
      dependencies = { "godlygeek/tabular" },
    },
    {
      "mg979/vim-visual-multi",
    },
    {
      "nvim-neotest/nvim-nio",
      enabled = lvim.builtin.dap.active,
    },
    {
      "echasnovski/mini.animate",
      version = "*",
      config = function()
        require("user.mini_animate").config()
      end,
      enabled = lvim.builtin.mini_animate.active,
    },
    {
      "echasnovski/mini.move",
      version = "*",
      config = function()
        require("user.mini_move").config()
      end,
      enabled = lvim.builtin.mini_move.active,
    },
    {
      "echasnovski/mini.indentscope",
      version = "*",
      config = function()
        require("user.mini_indentscope").config()
      end,
      enabled = lvim.builtin.mini_indentscope.active,
    },
    {
      "echasnovski/mini.completion",
      version = "*",
      config = function()
        require("user.mini_completion").config()
      end,
      enabled = lvim.builtin.mini_completion.active,
    },
    {
      "echasnovski/mini.icons",
      version = false,
      config = function()
        require("mini.icons").setup()
      end,
      enabled = lvim.builtin.mini_icons.active,
    },
    {
      "kawre/leetcode.nvim",
      build = ":TSUpdate html",
      dependencies = {
        "nvim-telescope/telescope.nvim",
        "nvim-lua/plenary.nvim", -- required by telescope
        "MunifTanjim/nui.nvim",

        -- optional
        "nvim-treesitter/nvim-treesitter",
        "rcarriga/nvim-notify",
        "nvim-tree/nvim-web-devicons",
      },
      opts = require "user.leetcode",
      enabled = lvim.builtin.leetcode.active,
    },
    {
      "OXY2DEV/markview.nvim",
      lazy = false,
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
      },
      config = function()
        local presets = require "markview.presets"
        require("markview").setup {
          checkboxes = presets.checkboxes.nerd,
          headings = presets.headings.glow,
        }
      end,
      enabled = lvim.builtin.markdown.active,
    },
    {
      "abzcoding/project.nvim",
      name = "new-project",
      branch = "fix/nvim-12",
      config = function()
        require("user.project").config()
      end,
      enabled = not lvim.builtin.project.active and lvim.builtin.project.mine,
    },
    {
      "folke/which-key.nvim",
      name = "whhk",
      event = "VeryLazy",
      commit = "0119a83f6cd097701ff13044be4e1effc8dffe02",
      pin = true,
      config = function()
        require("user.which").config()
      end,
      enabled = not lvim.builtin.which_key.active and lvim.builtin.which_key.mine,
    },
    {
      "OXY2DEV/helpview.nvim",
      lazy = true,
      ft = "help",
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
      },
      enabled = lvim.builtin.markdown.active,
    },
  }
end

return M
