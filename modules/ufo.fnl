(local {: plug : noremap} (require :boiler))
(plug :nvim-ufo {:opts {:provider_selector (fn [] [:treesitter :indent])}})

(noremap [{:key :zR
           :action #((. (require :ufo) :openAllFolds) :desc "Open all folds")}])

(noremap [{:key :zM
           :action #((. (require :ufo) :closeAllFolds) :desc "Close all folds")}])
