(local {: plug} (require :boiler))
(plug :conform.nvim
      {:cmd :ConformInfo
       :event :BufWritePre
       :init (fn []
               (set vim.o.formatexpr "v:lua.require'conform'.formatexpr()"))
       :keys [{1 :<leader>f
               2 (fn []
                   ((. (require :conform) :format) {:async true}))
               :desc "Format buffer"
               :mode ""}]
       :opts {:default_format_opts {:lsp_format :fallback}
              :format_on_save {:timeout_ms 500}
              :formatters_by_ft {:fennel [:fnlfmt]
                                 :nix [:alejandra]
                                 ; :rust [:rustfmt]
                                 :typescript [:prettierd]}}})
