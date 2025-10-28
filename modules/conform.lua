-- [nfnl] modules/conform.fnl
 package.preload["boiler"] = package.preload["boiler"] or function(...) local function noremap(maps) for _, v in ipairs(maps) do vim.keymap.set((v.mode or ""), v.key, v.action, {silent = true, desc = v.desc}) end return nil end local function plug(name, opts) _G["plugin-specs"][name] = vim.tbl_extend("force", _G["plugin-specs"][name], opts) return nil end local function load_lazy() local lazy = require("lazy") local plugs do local tbl_21_ = {} local i_22_ = 0 for _, v in pairs(_G["plugin-specs"]) do local val_23_ = v if (nil ~= val_23_) then i_22_ = (i_22_ + 1) tbl_21_[i_22_] = val_23_ else end end plugs = tbl_21_ end return lazy.setup({checker = {enabled = true}, rocks = {enabled = false}, profiling = {loader = true, require = true}, spec = plugs}) end local function new_cmd(name, cb) return vim.api.nvim_create_user_command(name, cb, {}) end return {plug = plug, noremap = noremap, ["load-lazy"] = load_lazy, ["new-cmd"] = new_cmd} end local _local_2_ = require("boiler") local plug = _local_2_["plug"]



 local function _3_() vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
 return nil end

 local function _4_()
 return require("conform").format({async = true}) end return plug("conform.nvim", {cmd = "ConformInfo", event = "BufWritePre", init = _3_, keys = {{"<leader>f", _4_, desc = "Format buffer", mode = ""}}, opts = {default_format_opts = {lsp_format = "fallback"}, format_on_save = {timeout_ms = 500}, formatters_by_ft = {fennel = {"fnlfmt"}, nix = {"alejandra"}, typescript = {"prettierd"}}}})
