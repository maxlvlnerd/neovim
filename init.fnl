(local {: plug
        : cmp-add-icon
        : cmp-highlight
        : new-cmd
        : load-lazy
        : noremap
        : neorg-finder} (require :boiler))

(set vim.g.mapleader " ")
(macro setup! [a b c]
  `(do
     ,a
     ,b
     ,c))

(setup! (do
          (plug :nfnl {:ft :fennel})
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
          (plug :nvim-treesitter
                {:opts {:highlight {:enable true}}
                 :config (fn [_ opts]
                           (vim.opt.rtp:prepend _G.tree-sitter-path)
                           (let [ts (require :nvim-treesitter.configs)]
                             (ts.setup opts)))})
          (plug :mini.nvim
                {:config (fn []
                           (let [config (require :mini.basics)]
                             (config.setup)))})
          (plug :conform.nvim
                {:cmd :ConformInfo
                 :event :BufWritePre
                 :init (fn []
                         (set vim.o.formatexpr
                              "v:lua.require'conform'.formatexpr()"))
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
          ;        :webhooked/kanso.nvim
          (plug :typescript-tools.nvim {:opts {}})
          (plug :nvim-ufo
                {:opts {:provider_selector (fn [] [:treesitter :indent])}})
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
          (plug :neorg
                {:opts {:load {:core.defaults {}
                               :core.concealer {}
                               :external.interim-ls {:config {:completion_provider {:enable true
                                                                                    :documentation true}}}
                               :core.completion {:config {:engine {:module_name :external.lsp-completion}}}
                               :core.dirman {:config {:workspaces {:main "~/persist/logs/notes"}
                                                      :default_workspace :main}}}}})
          (load-lazy))
        (do
          (vim.lsp.enable :fennel_ls)
          (set vim.opt.foldlevel 99)
          (set vim.opt.foldlevelstart 99)
          (set vim.opt.signcolumn :number)
          (set vim.opt.number true)
          (set vim.opt.relativenumber true)
          (vim.cmd.colorscheme :oxocarbon))
        (do
          (new-cmd :SourceExrc
                   (fn []
                     (let [exrc (.. (vim.fn.getcwd) :/.nvim.lua)]
                       (when (vim.secure.read exrc)
                         (vim.cmd.source exrc)))))
          (noremap [{:key :n :action :j}
                    {:key :e :action :k}
                    {:key :o :action :l}])
          (noremap [{:key :grd :action #(vim.lsp.buf.definition)}])
          (noremap [{:key :zR
                     :action (. (require :ufo) :openAllFolds)
                     :desc "Open all folds"}])
          (noremap [{:key :zM
                     :action (. (require :ufo) :closeAllFolds)
                     :desc "Close all folds"}])))
