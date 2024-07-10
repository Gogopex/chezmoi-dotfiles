return {
  { "folke/neodev.nvim", opts = {} },
  { "folke/zen-mode.nvim" },
  { "mrjones2014/smart-splits.nvim" },
  { "folke/neodev.nvim", opts = {} },
  -- disable trouble
  { "folke/trouble.nvim", enabled = true },
  {
    "rcarriga/nvim-notify",
    enabled = false,
  },
  { "ellisonleao/gruvbox.nvim" },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },
  { "mrjones2014/smart-splits.nvim", module = false },
  { "folke/which-key.nvim", enabled = false },
  -- {
  --   "folke/which-key.nvim",
  --   event = "VeryLazy",
  --   init = function()
  --     vim.o.timeout = true
  --     vim.o.timeoutlen = 1000
  --   end,
  --   opts = {},
  -- },
  -- {
  --   "nvim-lualine/lualine.nvim",
  --   options = { theme = "gruvbox-dark" },
  --   event = "VeryLazy",
  --   opts = function(_, opts)
  --     table.insert(opts.sections.lualine_x, "😄")
  --   end,
  -- },
  { "nvim-lualine/lualine.nvim", enabled = false },
  {
    "mbbill/undotree",
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      setup = {
        clangd = function(_, opts)
          opts.capabilities.offsetEncoding = { "utf-16" }
        end,
      },
    },
  },
}
