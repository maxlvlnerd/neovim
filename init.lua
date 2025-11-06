-- [nfnl] init.fnl
 package.preload["boiler"] = package.preload["boiler"] or function(...) local function noremap(maps) for _, v in ipairs(maps) do vim.keymap.set((v.mode or ""), v.key, v.action, {silent = true, desc = v.desc}) end return nil end local function plug(name, opts) _G["plugin-specs"][name] = vim.tbl_extend("force", _G["plugin-specs"][name], opts) return nil end local function load_lazy() local lazy = require("lazy") local plugs do local tbl_26_ = {} local i_27_ = 0 for _, v in pairs(_G["plugin-specs"]) do local val_28_ = v if (nil ~= val_28_) then i_27_ = (i_27_ + 1) tbl_26_[i_27_] = val_28_ else end end plugs = tbl_26_ end return lazy.setup({checker = {enabled = true}, rocks = {enabled = false}, profiling = {loader = true, require = true}, spec = plugs}) end local function new_cmd(name, cb) return vim.api.nvim_create_user_command(name, cb, {}) end return {plug = plug, noremap = noremap, ["load-lazy"] = load_lazy, ["new-cmd"] = new_cmd} end local _local_2_ = require("boiler") local plug = _local_2_.plug local new_cmd = _local_2_["new-cmd"] local load_lazy = _local_2_["load-lazy"] local noremap = _local_2_.noremap vim.g.mapleader = " "



 do
 local function _3_()
 local config = require("mini.basics")
 return config.setup() end plug("mini.nvim", {config = _3_})
 plug("nfnl", {ft = "fennel"})


 local function _4_(_, opts) vim.opt.rtp:prepend(_G["tree-sitter-path"])

 local ts = require("nvim-treesitter.configs")
 return ts.setup(opts) end plug("nvim-treesitter", {opts = {highlight = {enable = true}}, config = _4_})
 plug("typescript-tools.nvim", {opts = {}})

 local function neorg_finder()
 local neorg = require("neorg")
 local dirman = neorg.modules.get_module("core.dirman")
 local _let_5_ = dirman.get_current_workspace() local workspace = _let_5_[1] local cwd = _let_5_[2]
 local workspace_files = dirman.get_norg_files(workspace)
 local tbl_26_ = {} local i_27_ = 0 for _, v in ipairs(workspace_files) do
 local val_28_ = {text = tostring(v:relative_to(cwd, false)), file = tostring(v)} if (nil ~= val_28_) then i_27_ = (i_27_ + 1) tbl_26_[i_27_] = val_28_ else end end return tbl_26_ end


 local function _7_() return Snacks.lazygit() end
 local function _8_() return Snacks.picker.smart() end
 local function _9_() return Snacks.picker.grep() end
 local function _10_() return Snacks.picker.buffers() end
 local function _11_() return Snacks.picker.diagnostics() end
 local function _12_() return Snacks.picker.neorg() end plug("snacks.nvim", {keys = {{"<leader>gg", _7_, desc = "Lazygit"}, {"<leader><space>", _8_}, {"<leader>fg", _9_}, {"<leader>,", _10_}, {"<leader>ld", _11_}, {"<leader>no", _12_}}, priority = 1000, opts = {lazygit = {enabled = true}, picker = {sources = {neorg = {finder = neorg_finder}}}}, lazy = false})




 plug("neorg", {opts = {load = {["core.defaults"] = {}, ["core.concealer"] = {}, ["core.esupports.metagen"] = {config = {type = "auto"}}, ["external.interim-ls"] = {config = {completion_provider = {enable = true, documentation = true}}}, ["core.completion"] = {config = {engine = {module_name = "external.lsp-completion"}}}, ["core.dirman"] = {config = {workspaces = {main = "~/persist/logs/notes"}, default_workspace = "main"}}}}})












 local function _13_() vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
 return nil end

 local function _14_()
 return require("conform").format({async = true}) end plug("conform.nvim", {cmd = "ConformInfo", event = "BufWritePre", init = _13_, keys = {{"<leader>f", _14_, desc = "Format buffer", mode = ""}}, opts = {default_format_opts = {lsp_format = "fallback"}, format_on_save = {timeout_ms = 500}, formatters_by_ft = {fennel = {"fnlfmt"}, nix = {"alejandra"}, typescript = {"prettierd"}}}})









 local function cmp_add_icon(ctx)
 local icon = ctx.kind_icon
 if vim.tbl_contains({"Path"}, ctx.source_name) then
 local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
 if dev_icon then icon = dev_icon else end else
 icon = require("lspkind").symbolic(ctx.kind, {mode = "symbol"}) end
 return (icon .. ctx.icon_gap) end

 local function cmp_highlight(ctx)
 local hl = ctx.kind_hl
 if vim.tbl_contains({"Path"}, ctx.source_name) then

 local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
 if dev_icon then hl = dev_hl else end else end
 return hl end

 plug("blink.cmp", {opts_extend = {"sources.default"}, opts = {completion = {documentation = {auto_show = true, auto_show_delay_ms = 500}, menu = {draw = {components = {kind_icon = {text = cmp_add_icon, highlight = cmp_highlight}}, columns = {{"kind_icon"}, {"label", "label_description", "source_name", gap = 1}}}}}, sources = {default = {"lsp", "path", "buffer"}}}}) end












 load_lazy()
 vim.lsp.enable("fennel_ls") vim.opt.signcolumn = "number" vim.opt.number = true vim.opt.relativenumber = true vim.opt.hlsearch = false




 vim.cmd.colorscheme("oxocarbon")

 local function _19_()
 local exrc = (vim.fn.getcwd() .. "/.nvim.lua")
 if vim.secure.read(exrc) then
 return vim.cmd.source(exrc) else return nil end end new_cmd("SourceExrc", _19_)

 noremap({{key = "n", action = "j"}, {key = "e", action = "k"}, {key = "o", action = "l"}})
 local function _21_() return vim.lsp.buf.definition() end return noremap({{key = "grd", action = _21_}})
