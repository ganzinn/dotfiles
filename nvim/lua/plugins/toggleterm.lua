return {
  -- ターミナル表示
  'akinsho/toggleterm.nvim',
  version = "*",
  config = function()
    require('toggleterm').setup({
      open_mapping = [[<c-\>]],
    })
    local Terminal  = require('toggleterm.terminal').Terminal
    local lazygit = Terminal:new({
      cmd = "lazygit",
      dir = "git_dir",
      direction = "float",
      float_opts = { border = "double" },
      -- function to run on opening the terminal
      on_open = function(term)
        vim.cmd("startinsert!")
        vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
      end,
      -- function to run on closing the terminal
      on_close = function()
        vim.cmd("startinsert!")
        -- neo-treeのgit statusを更新
        pcall(function()
          require("neo-tree.events").fire_event("git_event")
        end)
      end,
    })

    vim.keymap.set("n", "<leader>gg", function()
      lazygit:toggle()
    end, {noremap = true, silent = true, desc = 'Lazygitを開く'})
  end
}
