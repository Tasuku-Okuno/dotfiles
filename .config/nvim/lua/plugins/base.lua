return {
  -- LSP設定（Neovim 0.11+ 対応）
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- Neovim 0.11+ の新しい方法
      vim.lsp.config('pyright', {
        cmd = { "pyright-langserver", "--stdio" },
        filetypes = { "python" },
        root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            },
          },
        },
      })
      vim.lsp.enable('pyright')

      -- LSPがアタッチされたときのキーマップ
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local bufnr = args.buf
          vim.keymap.set("n", "<leader>d", function()
            require("telescope.builtin").lsp_definitions()
          end, { buffer = bufnr, desc = "Go to definition (Telescope)" })

          vim.keymap.set("n", "<leader>r", function()
            require("telescope.builtin").lsp_references()
          end, { buffer = bufnr, desc = "Find references (Telescope)" })

          vim.keymap.set("n", "K", vim.diagnostic.open_float, { buffer = bufnr, desc = "Show diagnostics under cursor" })
        end,
      })
    end,
  },
  -- Treesitter（Neovim 0.11+ 対応）
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "python", "lua", "javascript", "typescript", "json", "yaml", "bash" },
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },
  -- 補完
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = { expand = function(args) end },
        mapping = {
          ["<C-j>"] = cmp.mapping.select_next_item(),
          ["<C-k>"] = cmp.mapping.select_prev_item(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        },
        sources = { { name = "nvim_lsp" } },
        completion = { autocomplete = { cmp.TriggerEvent.TextChanged } },
      })
    end,
  },
  -- スニペット
  { "L3MON4D3/LuaSnip" },
  -- 検索
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local actions = require('telescope.actions')
      local builtin = require('telescope.builtin')

      require('telescope').setup({
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
            },
            n = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
            }
          }
        }
      })

      vim.keymap.set('n', '<leader>f', builtin.find_files, {})
      vim.keymap.set('n', '<leader>/', builtin.live_grep, {})
      vim.keymap.set('n', '<leader>b', builtin.buffers, {})
      vim.keymap.set('n', '<leader>h', builtin.help_tags, {})
      vim.keymap.set("n", "<leader>g", function()
        builtin.grep_string({ search = vim.fn.expand("<cword>") })
      end, { desc = "Search word under cursor in project" })
      -- vim-fugativeの内容をTelescopeで表示
      vim.keymap.set('n', '<leader>Gl', builtin.git_commits, { desc = "Git log" })
      vim.keymap.set('n', '<leader>Gs', builtin.git_status, { desc = "Git status" })
      vim.keymap.set('n', '<leader>Gc', builtin.git_bcommits, { desc = "このファイルの履歴" })
    end
  },
  -- ツリー表示
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      vim.keymap.set('n', '<leader>e', ":Neotree toggle<CR>", { desc = "Toggle NeoTree" })
      vim.keymap.set('n', '<leader>o', ":Neotree reveal<CR>", { desc = "Reveal current file in NeoTree" })
    end
  },

  -- リンター（flake8）
  {
    "mfussenegger/nvim-lint",
    config = function()
      require("lint").linters_by_ft = {
        python = { "flake8" }
      }
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave", "TextChanged" }, {
        pattern = { "*.py" },
        callback = function()
          require("lint").try_lint()
        end,
      })
    end
  },

  -- フォーマッター（black, isort）
  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          python = { "isort", "black" }
        },
        format_on_save = {
          timeout_ms = 1000,
          lsp_fallback = true,
        },
      })
    end
  },

  -- デバッガー
  {
    "mfussenegger/nvim-dap",
    dependencies = { "mfussenegger/nvim-dap-python" },
    config = function()
      require("dap-python").setup("python")
      
      local dap = require("dap")
      vim.keymap.set("n", "<leader>Db", dap.toggle_breakpoint, { desc = "ブレークポイント" })
      vim.keymap.set("n", "<leader>Dc", dap.continue, { desc = "デバッグ開始/続行" })
      vim.keymap.set("n", "<leader>Dn", dap.step_over, { desc = "次の行" })
      vim.keymap.set("n", "<leader>Di", dap.step_into, { desc = "関数の中に入る" })
      vim.keymap.set("n", "<leader>Do", dap.step_out, { desc = "関数から出る" })
      vim.keymap.set("n", "<leader>Dr", dap.repl.open, { desc = "REPL開く" })
      vim.keymap.set("n", "<leader>Dx", dap.terminate, { desc = "デバッグ終了" })
    end
  },

  -- デバッガーUI
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      local dapui = require("dapui")
      dapui.setup()
      
      local dap = require("dap")
      dap.listeners.after.event_initialized["dapui"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui"] = function() dapui.close() end
    end
  },

  -- Git 連携
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        on_attach = function(bufnr)
          local gs = require("gitsigns")
          
          vim.keymap.set("n", "]c", gs.next_hunk, { buffer = bufnr, desc = "次の変更へ" })
          vim.keymap.set("n", "[c", gs.prev_hunk, { buffer = bufnr, desc = "前の変更へ" })
          vim.keymap.set("n", "<leader>Gp", gs.preview_hunk, { buffer = bufnr, desc = "変更をプレビュー" })
          vim.keymap.set("n", "<leader>Gr", gs.reset_hunk, { buffer = bufnr, desc = "変更を取り消し" })
          vim.keymap.set("n", "<leader>Gb", gs.blame_line, { buffer = bufnr, desc = "この行の blame" })
        end
      })
      -- 色を直接定義
      vim.api.nvim_set_hl(0, "GitSignsAdd", { ctermfg = "green" })
      vim.api.nvim_set_hl(0, "GitSignsChange", { ctermfg = "yellow" })
      vim.api.nvim_set_hl(0, "GitSignsDelete", { ctermfg = "red" })
    end
  },
  -- Git コマンド
  {
    "tpope/vim-fugitive",
    config = function()
      vim.keymap.set("n", "<leader>GB", ":Git blame<CR>", { desc = "全体 blame" })
    end
  },
}
