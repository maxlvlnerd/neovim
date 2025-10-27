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

(fn cmp-add-icon [ctx]
  (var icon ctx.kind_icon)
  (if (vim.tbl_contains [:Path] ctx.source_name)
      (let [(dev-icon _) ((. (require :nvim-web-devicons) :get_icon) ctx.label)]
        (when dev-icon (set icon dev-icon)))
      (set icon ((. (require :lspkind) :symbolic) ctx.kind {:mode :symbol})))
  (.. icon ctx.icon_gap))

(fn cmp-highlight [ctx]
  (var hl ctx.kind_hl)
  (when (vim.tbl_contains [:Path] ctx.source_name)
    (local (dev-icon dev-hl)
           ((. (require :nvim-web-devicons) :get_icon) ctx.label))
    (when dev-icon (set hl dev-hl)))
  hl)

(fn neorg-finder []
  (let [neorg (require :neorg)
        dirman (neorg.modules.get_module :core.dirman)
        [workspace cwd] (dirman.get_current_workspace)
        workspace-files (dirman.get_norg_files workspace)]
    (icollect [_ v (ipairs workspace-files)]
      {:text (tostring (v:relative_to cwd false)) :file (tostring v)})))

{: plug
 : noremap
 : load-lazy
 : new-cmd
 : cmp-highlight
 : cmp-add-icon
 : neorg-finder}
