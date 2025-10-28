(local {: plug} (require :boiler))

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

(plug :blink.cmp
      {:opts_extend [:sources.default]
       :opts {:completion {:documentation {:auto_show true
                                           :auto_show_delay_ms 500}
                           :menu {:draw {:components {:kind_icon {:text cmp-add-icon
                                                                  :highlight cmp-highlight}}
                                         :columns [[:kind_icon]
                                                   {1 :label
                                                    2 :label_description
                                                    :gap 1
                                                    3 :source_name}]}}}
              :sources {:default [:lsp :path :buffer]}}})
