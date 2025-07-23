-- ~/.config/nvim/lua/plugins/flash.lua

return {
  "folke/flash.nvim",
  -- @type Flash.Config
  opts = {
    labels = "uhetidonaspg.cyf,r;lkmjwxbqv'z",
    modes = {
      char = {
        enabled = false,
      },
    },
  },
  keys = {
    { "s", mode = { "n", "x", "o" }, false },
    { "S", mode = { "n", "x", "o" }, false },
    { "r", mode = { "o" }, false },
    { "R", mode = { "x", "o" }, false },
    { "<c-s>", mode = { "c" }, false },
    {
      "t",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump()
      end,
      desc = "Flash Jump",
    },
    {
      "T",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump({
          remote_op = {
            restore = true,
            motion = true,
          },
        })
      end,
      desc = "Flash Remote (In Operator Pending Mode)",
    },
    {
      "k",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump({
          search = { mode = "search", max_length = 0 },
          label = { after = { 0, 0} },
          pattern = "^\\s*\\zs."
        })
      end,
      desc = "Flash Jump to Line Start",
    },
    -- {
    --   "K",
    --   mode = { "n", "x", "o" },
    --   function()
    --     require("flash").jump({
    --       search = { mode = "search", max_length = 0 },
    --       label = { after = { 0, 0} },
    --       pattern = "$"
    --     })
    --   end,
    --   desc = "Flash Jump to Line End",
    -- },
    {
      "j",
      mode = { "n", "x", "o" },
      function()
        require("flash").treesitter_search()
      end,
      desc = "Flash Treesitter Jump",
    },
    {
      "J",
      mode = { "n", "x", "o" },
      function()
        require("flash").treesitter_search({
          remote_op = {
            restore = true,
            motion = true,
          },
        })
      end,
      desc = "Flash Treesitter Remote (In Operator Pending Mode)",
    },
    -- {
    --   "w",
    --   mode = { "n", "x", "o" },
    --   function()
    --     require("flash").jump({
    --       search = {
    --         mode = function(str)
    --           return "\\<" .. str
    --         end,
    --       },
    --     })
    --   end,
    --   desc = "Flash Jump to Word Start",
    -- },
    -- {
    --   "W",
    --   mode = { "n", "x", "o" },
    --   function()
    --     require("flash").jump({
    --       search = {
    --         mode = function(str)
    --           return str .. ">\\"
    --         end,
    --       },
    --     })
    --   end,
    --   desc = "Flash Jump to Word End",
    -- },
  },
}

