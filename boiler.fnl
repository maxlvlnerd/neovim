(fn noremap [maps]
  "Defines noremap keybinds for all of the specified mode, key, and action pairs"
  (each [_ v (ipairs maps)]
    (vim.keymap.set (or v.mode "") v.key v.action {:silent true :desc v.desc})))

(fn plug [name opts]
  "Define lazy.nvim spec options for a plugin"
  (tset _G.plugin-specs name (vim.tbl_extend :force (. _G.plugin-specs name)
                                             opts)))

(fn load-lazy []
  "Simplifies lazy setup"
  (let [lazy (require :lazy)
        plugs (icollect [_ v (pairs _G.plugin-specs)]
                v)]
    (lazy.setup {:checker {:enabled true}
                 :rocks {:enabled false}
                 :profiling {:loader true :require true}
                 :spec plugs})))

(fn new-cmd [name cb]
  (vim.api.nvim_create_user_command name cb {}))

{: plug : noremap : load-lazy : new-cmd}
