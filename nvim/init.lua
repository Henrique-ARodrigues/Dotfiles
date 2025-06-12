-- Bootstrap do lazy.nvim (instala automaticamente se não tiver)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- última versão estável
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Configura plugins com lazy.nvim
require("lazy").setup({
  -- Tema agradável e moderno
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("onedark").setup({ style = "dark" })
      require("onedark").load()
    end,
  },

  -- Suporte LSP para C/C++ (clangd)
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("lspconfig").clangd.setup({})
    end,
  },

  -- Autocompletar com luasnip + nvim-cmp
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
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
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
        },
      })
    end,
  },

  -- Destaque de sintaxe rápido e moderno (treesitter)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "c", "cpp", "lua", "bash" },
        highlight = { enable = true },
      })
    end,
  },

  -- Autopairs (com integração com treesitter)
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true, -- integração com treesitter
        map_cr = true,   -- quebra de linha automática entre {}
      })
    end,
  },

  -- Barra de status simples e bonita
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = { theme = "onedark" },
      })
    end,
  },

  -- Ícones para arquivos
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },
})

-- Configurações básicas do Neovim
vim.opt.number = true           -- Números nas linhas
vim.opt.relativenumber = true   -- Número relativo
vim.opt.expandtab = true        -- Usar espaços em vez de tabs
vim.opt.shiftwidth = 4          -- Tamanho da indentação
vim.opt.tabstop = 4             -- Tamanho do tab
vim.opt.smartindent = true      -- Indentação inteligente
vim.opt.wrap = false            -- Não quebrar linha visualmente
vim.opt.cursorline = true       -- Destacar linha atual
vim.opt.termguicolors = true    -- Suporte a 24bit colors
vim.opt.signcolumn = "yes"      -- Coluna para sinais sempre visível

-- Atalhos úteis para LSP (quando estiver ativo)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local buf = args.buf
    local opts = { buffer = buf, remap = false }

    local keymap = vim.keymap.set
    keymap("n", "gd", vim.lsp.buf.definition, opts)
    keymap("n", "K", vim.lsp.buf.hover, opts)
    keymap("n", "<leader>r", vim.lsp.buf.rename, opts)
    keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    keymap("n", "gr", vim.lsp.buf.references, opts)
    keymap("n", "[d", vim.diagnostic.goto_prev, opts)
    keymap("n", "]d", vim.diagnostic.goto_next, opts)
    keymap("n", "<leader>q", vim.diagnostic.setloclist, opts)
  end,
})

