(local {: plug : neorg-finder} (require :boiler))
(plug :snacks.nvim
      {:keys [{1 :<leader>gg 2 #(Snacks.lazygit) :desc :Lazygit}
              {1 :<leader><space> 2 #(Snacks.picker.smart)}
              {1 :<leader>fg 2 #(Snacks.picker.grep)}
              {1 "<leader>," 2 #(Snacks.picker.buffers)}
              {1 :<leader>ld 2 #(Snacks.picker.diagnostics)}
              {1 :<leader>no 2 #(Snacks.picker.neorg)}]
       :lazy false
       :priority 1000
       :opts {:lazygit {:enabled true}
              :picker {:sources {:neorg {:finder neorg-finder}}}}})
