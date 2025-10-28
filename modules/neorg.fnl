(local {: plug} (require :boiler))
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
