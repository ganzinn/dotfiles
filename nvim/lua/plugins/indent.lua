return {
  -- インデントガイドをレインボー表示
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  -- opts = {
  --   indent = { char = "▏" },
  -- },
  opts = function(_, opts)
		-- Other blankline configuration here
    opts = {
      indent = { char = "▏" }
    }
		return require("indent-rainbowline").make_opts(opts)
	end,
	dependencies = {
		"TheGLander/indent-rainbowline.nvim",
	},
}
