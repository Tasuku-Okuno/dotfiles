return {
  -- LSP設定
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")

      local on_attach = function(client, bufnr)
        -- 定義へジャンプ
        vim.keymap.set("n", "<leader>d", function()
          require("telescope.builtin").lsp_definitions()
        end, { buffer = bufnr, desc = "Go to definition (Telescope)" })

        -- 参照検索
        vim.keymap.set("n", "<leader>r", function()
          require("telescope.builtin").lsp_references()
        end, { buffer = bufnr, desc = "Find references (Telescope)" })

        -- K で診断表示
        vim.keymap.set("n", "K", vim.diagnostic.open_float, { buffer = bufnr, desc = "Show diagnostics under cursor" })
      end
      -- Python
      lspconfig.pyright.setup({
        on_attach = on_attach,
      })
    end,
  },
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "python" },
        highlight = { enable = true },
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
      local telescope = require('telescope')
      local actions = require('telescope.actions')
      local builtin = require('telescope.builtin')

      require('telescope').setup({
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,   -- 下へ
              ["<C-k>"] = actions.move_selection_previous, -- 上へ
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
    end
  },
  -- ツリー表示
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- アイコン表示
      "MunifTanjim/nui.nvim",
    },
    config = function()
      vim.keymap.set('n', '<leader>e', ":Neotree toggle<CR>", { desc = "Toggle NeoTree" })
      vim.keymap.set('n', '<leader>o', ":Neotree reveal<CR>", { desc = "Reveal current file in NeoTree" })
    end
  },
}

