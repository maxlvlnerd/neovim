(local {: plug : new-cmd : load-lazy : noremap} (require :boiler))

(set vim.g.mapleader " ")
;; plugins
(do
  (plug :mini.nvim {:config (fn []
                              (let [config (require :mini.basics)]
                                (config.setup)))})
  (plug :nfnl {:ft :fennel})
  (plug :nvim-treesitter
        {:opts {:highlight {:enable true}}
         :config (fn [_ opts]
                   (vim.opt.rtp:prepend _G.tree-sitter-path)
                   (let [ts (require :nvim-treesitter.configs)]
                     (ts.setup opts)))})
  (plug :typescript-tools.nvim {:opts {}})

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
  (plug :neorg
        {:opts {:load {:core.defaults {}
                       :core.concealer {}
                       ; automatically create metadata
                       :core.esupports.metagen {:config {:type :auto}}
                       :external.interim-ls {:config {:completion_provider {:enable true
                                                                            :documentation true}}}
                       :core.completion {:config {:engine {:module_name :external.lsp-completion}}}
                       :core.dirman {:config {:workspaces {:main "~/persist/logs/notes"}
                                              :default_workspace :main}}}}})
  (plug :conform.nvim
        {:opts {:default_format_opts {:lsp_format :fallback}
                :format_on_save {:timeout_ms 500}
                :formatters_by_ft {:fennel [:fnlfmt]
                                   :nix [:alejandra]
                                   :typescript [:prettierd]}}})
  (plug :blink.cmp
        {:opts {:completion {:documentation {:auto_show true
                                             :auto_show_delay_ms 500}}
                :sources {:default [:lsp :path :buffer]}}}))

(load-lazy)
(vim.lsp.enable :fennel_ls)
(set vim.opt.signcolumn :number)
(set vim.opt.number true)
(set vim.opt.relativenumber true)
(set vim.opt.hlsearch false)
(set vim.o.formatexpr "v:lua.require'conform'.formatexpr()")
(vim.cmd.colorscheme :oxocarbon)

(new-cmd :SourceExrc (fn []
                       (let [exrc (.. (vim.fn.getcwd) :/.nvim.lua)]
                         (when (vim.secure.read exrc)
                           (vim.cmd.source exrc)))))

(noremap [{:key :n :action :j} {:key :e :action :k} {:key :o :action :l}])
(noremap [{:key :grd :action #(vim.lsp.buf.definition)}])
