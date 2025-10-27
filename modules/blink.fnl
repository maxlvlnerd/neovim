(local {: plug : cmp-add-icon : cmp-highlight} (require :boiler))

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
