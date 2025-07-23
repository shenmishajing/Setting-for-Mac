-- ~/.config/nvim/lua/plugins/yanky.lua

return {
  "gbprod/yanky.nvim",
  keys = {
    { "p", "\"_dp", mode = { "v", "x", "s" }, desc = "Put Text After Cursor" },
    { "P", "\"_dP", mode = { "v", "x", "s" }, desc = "Put Text Before Cursor" },
  }
}
