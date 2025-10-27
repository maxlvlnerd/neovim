(local {: new-cmd : load-lazy : noremap} (require :boiler))
(macro setup! [modules]
  (let [modules (icollect [_ name (ipairs modules)]
                  `(require ,(.. :modules. name)))]
    `(do
       ,modules
       (load-lazy))))

(set vim.g.mapleader " ")
(setup! [:basics
         :nfnl
         :blink
         :treesitter
         :conform
         :typescript
         :ufo
         :snacks
         :neorg])

(vim.lsp.enable :fennel_ls)
(set vim.opt.foldlevel 99)
(set vim.opt.foldlevelstart 99)
(set vim.opt.signcolumn :number)
(set vim.opt.number true)
(set vim.opt.relativenumber true)
(set vim.opt.hlsearch false)
(vim.cmd.colorscheme :oxocarbon)

(new-cmd :SourceExrc (fn [])
         (let [exrc (.. (vim.fn.getcwd) :/.nvim.lua)]
           (when (vim.secure.read exrc)
             (vim.cmd.source exrc))))

(noremap [{:key :n :action :j} {:key :e :action :k} {:key :o :action :l}])
(noremap [{:key :grd :action #(vim.lsp.buf.definition)}])
