(local {: plug} (require :boiler))
(plug :nvim-treesitter {:opts {:highlight {:enable true}}
                        :config (fn [_ opts]
                                  (vim.opt.rtp:prepend _G.tree-sitter-path)
                                  (let [ts (require :nvim-treesitter.configs)]
                                    (ts.setup opts)))})
