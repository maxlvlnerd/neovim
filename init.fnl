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

(set vim.g.mapleader " ")
(plug :conjure {:ft :fennel})
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

(plug :nvim-treesitter {:opts {:highlight {:enable true}}
                        :config (fn [_ opts]
                                  (vim.opt.rtp:prepend _G.tree-sitter-path)
                                  (let [ts (require :nvim-treesitter.configs)]
                                    (ts.setup opts)))})

(plug :mini.nvim {:config (fn []
                            (let [config (require :mini.basics)]
                              (config.setup)))})

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

;        :webhooked/kanso.nvim
(plug :telescope.nvim
      {:keys [{1 :<leader>ff
               2 "<cmd>Telescope find_files<cr>"
               :desc "Telescope find files"}
              {1 :<leader>fg
               2 "<cmd>Telescope live_grep<cr>"
               :desc "Telescope live grep"}
              {1 :<leader><space>
               2 "<cmd>Telescope buffers<cr>"
               :desc "Telescope buffers"}
              {1 :<leader>ld
               2 "<cmd>Telescope diagnostics<cr>"
               :desc "Telescope lsp diagnostics"}]
       :lazy false
       :config (fn [_ opts]
                 (let [tele (require :telescope)]
                   (tele.setup opts)
                   (tele.load_extension :fzf)))})

(plug :typescript-tools.nvim {:opts {}})
(plug :nvim-ufo {:opts {:provider_selector (fn [] [:treesitter :indent])}})
(load-lazy)

(new-cmd :SourceExrc (fn []
                       (let [exrc (.. (vim.fn.getcwd) :/.nvim.lua)]
                         (when (vim.secure.read exrc)
                           (vim.cmd.source exrc)))))

(noremap [{:key :n :action :j} {:key :e :action :k} {:key :o :action :l}])
(noremap [{:key :zR
           :action (. (require :ufo) :openAllFolds)
           :desc "Open all folds"}])

(noremap [{:key :zM
           :action (. (require :ufo) :closeAllFolds)
           :desc "Close all folds"}])

(vim.lsp.enable :fennel_ls)
(set vim.opt.foldlevel 99)
(set vim.opt.foldlevelstart 99)
(set vim.opt.signcolumn :number)
(set vim.opt.number true)
(set vim.opt.relativenumber true)
(vim.cmd.colorscheme :oxocarbon)
