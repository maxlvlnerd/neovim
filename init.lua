-- [nfnl] init.fnl
 package.preload["boiler"] = package.preload["boiler"] or function(...) local function noremap(maps) for _, v in ipairs(maps) do vim.keymap.set((v.mode or ""), v.key, v.action, {silent = true, desc = v.desc}) end return nil end local function plug(name, opts) _G["plugin-specs"][name] = vim.tbl_extend("force", _G["plugin-specs"][name], opts) return nil end local function load_lazy() local lazy = require("lazy") local plugs do local tbl_26_ = {} local i_27_ = 0 for _, v in pairs(_G["plugin-specs"]) do local val_28_ = v if (nil ~= val_28_) then i_27_ = (i_27_ + 1) tbl_26_[i_27_] = val_28_ else end end plugs = tbl_26_ end return lazy.setup({checker = {enabled = true}, rocks = {enabled = false}, profiling = {loader = true, require = true}, spec = plugs}) end local function new_cmd(name, cb) return vim.api.nvim_create_user_command(name, cb, {}) end return {plug = plug, noremap = noremap, ["load-lazy"] = load_lazy, ["new-cmd"] = new_cmd} end local _local_2_ = require("boiler") local p = _local_2_.plug local new_cmd = _local_2_["new-cmd"] local load_lazy = _local_2_["load-lazy"] local noremap = _local_2_.noremap vim.g.mapleader = " "



 do
 local function _3_()
 local config = require("mini.basics")
 return config.setup() end p("mini.nvim", {config = _3_})
 p("nfnl", {ft = "fennel"})
 p("typescript-tools.nvim", {opts = {}})

 local function neorg_finder()
 local neorg = require("neorg")
 local dirman = neorg.modules.get_module("core.dirman")
 local _let_4_ = dirman.get_current_workspace() local workspace = _let_4_[1] local cwd = _let_4_[2]
 local workspace_files = dirman.get_norg_files(workspace)
 local tbl_26_ = {} local i_27_ = 0 for _, v in ipairs(workspace_files) do
 local val_28_ = {text = tostring(v:relative_to(cwd, false)), file = tostring(v)} if (nil ~= val_28_) then i_27_ = (i_27_ + 1) tbl_26_[i_27_] = val_28_ else end end return tbl_26_ end


 local function _6_() return Snacks.lazygit() end
 local function _7_() return Snacks.picker.smart() end
 local function _8_() return Snacks.picker.grep() end
 local function _9_() return Snacks.picker.buffers() end
 local function _10_() return Snacks.picker.diagnostics() end
 local function _11_() return Snacks.picker.neorg() end p("snacks.nvim", {keys = {{"<leader>gg", _6_, desc = "Lazygit"}, {"<leader><space>", _7_}, {"<leader>fg", _8_}, {"<leader>,", _9_}, {"<leader>ld", _10_}, {"<leader>no", _11_}}, priority = 1000, opts = {lazygit = {enabled = true}, picker = {sources = {neorg = {finder = neorg_finder}}}}, lazy = false})




 p("neorg", {opts = {load = {["core.defaults"] = {}, ["core.concealer"] = {}, ["core.esupports.metagen"] = {config = {type = "auto"}}, ["external.interim-ls"] = {config = {completion_provider = {enable = true, documentation = true}}}, ["core.completion"] = {config = {engine = {module_name = "external.lsp-completion"}}}, ["core.dirman"] = {config = {workspaces = {main = "~/persist/logs/notes"}, default_workspace = "main"}}}}})









 p("conform.nvim", {opts = {default_format_opts = {lsp_format = "fallback"}, format_on_save = {timeout_ms = 500}, formatters_by_ft = {fennel = {"fnlfmt"}, nix = {"alejandra"}, typescript = {"prettierd"}}}})





 p("blink.cmp", {opts = {completion = {documentation = {auto_show = true, auto_show_delay_ms = 500}}, sources = {default = {"lsp", "path", "buffer"}}}}) end




 load_lazy()
 vim.lsp.enable("fennel_ls") vim.opt.signcolumn = "number" vim.opt.number = true vim.opt.relativenumber = true vim.opt.hlsearch = false vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"





 vim.cmd.colorscheme("oxocarbon")

 local function _12_()
 local exrc = (vim.fn.getcwd() .. "/.nvim.lua")
 if vim.secure.read(exrc) then
 return vim.cmd.source(exrc) else return nil end end new_cmd("SourceExrc", _12_)

 noremap({{key = "n", action = "j"}, {key = "e", action = "k"}, {key = "o", action = "l"}})
 local function _14_() return vim.lsp.buf.definition() end noremap({{key = "grd", action = _14_}}) vim.opt.rtp:prepend(_G["tree-sitter-path"])


 local ts = require("nvim-treesitter.configs")
 return ts.setup({highlight = {enable = true}})
