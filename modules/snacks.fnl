(local {: plug} (require :boiler))

(fn neorg-finder []
  (let [neorg (require :neorg)
        dirman (neorg.modules.get_module :core.dirman)
        [workspace cwd] (dirman.get_current_workspace)
        workspace-files (dirman.get_norg_files workspace)]
    (icollect [_ v (ipairs workspace-files)]
      {:text (tostring (v:relative_to cwd false)) :file (tostring v)})))

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
