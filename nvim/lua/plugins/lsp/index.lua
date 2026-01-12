return {
  -- Mason: LSPサーバーのインストール管理
  {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonUninstall" },
    build = ":MasonUpdate",
    opts = {},
  },

  -- Mason-lspconfig: サーバーの自動インストール・有効化
  {
    "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = {
        "ruby_lsp",
        "ts_ls",
        "lua_ls",
      },
      automatic_enable = true,
    },
  },

  -- nvim-lspconfig: LSP設定データ（runtimepathに追加）
  {
    "neovim/nvim-lspconfig",
    lazy = true,
  },

  -- LSP共通設定
  {
    "hrsh7th/cmp-nvim-lsp",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- 診断関連キーマップ（グローバル設定、LSPアタッチ不要）
      vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "診断をフロートで表示" })
      vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "診断をロケーションリストに表示" })

      -- 全サーバー共通のcapabilities
      vim.lsp.config("*", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })

      -- Lua固有設定
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = { enable = false },
          },
        },
      })

      -- TypeScript固有設定（診断メッセージを日本語化）
      vim.lsp.config("ts_ls", {
        init_options = {
          locale = "ja",
        },
      })

      -- LSPアタッチ時のキーマップ（デフォルトにないもののみ）
      -- デフォルト: K, grn, grr, gri, gra, gO, <C-s>, [d, ]d, [D, ]D
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = ev.buf, silent = true, desc = "定義へジャンプ" })
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = ev.buf, silent = true, desc = "宣言へジャンプ" })
          vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { buffer = ev.buf, silent = true, desc = "型定義へジャンプ" })
          vim.keymap.set("n", "<leader>lf", function()
            vim.lsp.buf.format({ async = true })
          end, { buffer = ev.buf, silent = true, desc = "フォーマット" })
        end,
      })

      -- 診断表示の設定
      vim.opt.updatetime = 250

      vim.diagnostic.config({
        virtual_text = false,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = true,
        },
      })

      -- カーソルホバーで診断を自動表示
      -- vim.api.nvim_create_autocmd("CursorHold", {
      --   callback = function()
      --     vim.diagnostic.open_float(nil, { focus = false })
      --   end,
      -- })
    end,
  },

  -- nvim-cmp: 補完エンジン
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
      })
    end,
  },

  -- LuaSnip: スニペットエンジン
  {
    "L3MON4D3/LuaSnip",
    lazy = true,
    build = "make install_jsregexp",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
}
