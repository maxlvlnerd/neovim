(local {: plug} (require :boiler))
(plug :mini.nvim {:config (fn []
                            (let [config (require :mini.basics)]
                              (config.setup)))})

;        :webhooked/kanso.nvim
