return {
  -- Add the community repository of plugin specifications
  "AstroNvim/astrocommunity",
  -- example of imporing a plugin, comment out to use it or add your own
  -- available plugins can be found at https://github.com/AstroNvim/astrocommunity

  -- { import = "astrocommunity.colorscheme.catppuccin" },
  -- { import = "astrocommunity.completion.copilot-lua-cmp" },
  { import = "astrocommunity.editing-support.text-case-nvim" },
  {
    "ggandor/flit.nvim",
    keys = function()
      ---@type LazyKeys[]
      local ret = {}
      for _, key in ipairs { "f", "F", "t", "T" } do
        ret[#ret + 1] = { key, mode = { "n", "x", "o" }, desc = key }
      end
      return ret
    end,
    opts = { labeled_modes = "nx" },
    dependencies = {
      "ggandor/leap.nvim",
      keys = {
        { "s",  mode = { "n", "x", "o" }, desc = "Leap forward to" },
        { "S",  mode = { "n", "x", "o" }, desc = "Leap backward to" },
        { "gs", mode = { "n", "x", "o" }, desc = "Leap from windows" },
      },
      config = function(_, opts)
        local leap = require "leap"
        for k, v in pairs(opts) do
          leap.opts[k] = v
        end
        leap.add_default_mappings(true)
      end,
      dependencies = {
        "tpope/vim-repeat",
      },
    },
  },
  {
    "nvim-neotest/neotest",
    ft = { "jest" },
    dependencies = {
      "nvim-neotest/neotest-jest",
      {
        "folke/neodev.nvim",
        opts = function(_, opts)
          opts.library = opts.library or {}
          if opts.library.plugins ~= true then
            opts.library.plugins = require("astronvim.utils").list_insert_unique(opts.library.plugins, "neotest")
          end
          opts.library.types = true
        end,
      },
    },
    opts = function()
      return {
        -- your neotest config here
        adapters = {
          require "neotest-jest",
        },
      }
    end,
    config = function(_, opts)
      -- get neotest namespace (api call creates or returns namespace)
      local neotest_ns = vim.api.nvim_create_namespace "neotest"
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)
      require("neotest").setup(opts)
    end,
  }
}
