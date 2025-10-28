-- [nfnl] modules/snacks.fnl
 package.preload["boiler"] = package.preload["boiler"] or function(...) local function noremap(maps) for _, v in ipairs(maps) do vim.keymap.set((v.mode or ""), v.key, v.action, {silent = true, desc = v.desc}) end return nil end local function plug(name, opts) _G["plugin-specs"][name] = vim.tbl_extend("force", _G["plugin-specs"][name], opts) return nil end local function load_lazy() local lazy = require("lazy") local plugs do local tbl_21_ = {} local i_22_ = 0 for _, v in pairs(_G["plugin-specs"]) do local val_23_ = v if (nil ~= val_23_) then i_22_ = (i_22_ + 1) tbl_21_[i_22_] = val_23_ else end end plugs = tbl_21_ end return lazy.setup({checker = {enabled = true}, rocks = {enabled = false}, profiling = {loader = true, require = true}, spec = plugs}) end local function new_cmd(name, cb) return vim.api.nvim_create_user_command(name, cb, {}) end return {plug = plug, noremap = noremap, ["load-lazy"] = load_lazy, ["new-cmd"] = new_cmd} end local _local_2_ = require("boiler") local plug = _local_2_["plug"]

 local function neorg_finder()
 local neorg = require("neorg")
 local dirman = neorg.modules.get_module("core.dirman")
 local _let_3_ = dirman.get_current_workspace() local workspace = _let_3_[1] local cwd = _let_3_[2]
 local workspace_files = dirman.get_norg_files(workspace)
 local tbl_21_ = {} local i_22_ = 0 for _, v in ipairs(workspace_files) do
 local val_23_ = {text = tostring(v:relative_to(cwd, false)), file = tostring(v)} if (nil ~= val_23_) then i_22_ = (i_22_ + 1) tbl_21_[i_22_] = val_23_ else end end return tbl_21_ end


 local function _5_() return Snacks.lazygit() end
 local function _6_() return Snacks.picker.smart() end
 local function _7_() return Snacks.picker.grep() end
 local function _8_() return Snacks.picker.buffers() end
 local function _9_() return Snacks.picker.diagnostics() end
 local function _10_() return Snacks.picker.neorg() end return plug("snacks.nvim", {keys = {{"<leader>gg", _5_, desc = "Lazygit"}, {"<leader><space>", _6_}, {"<leader>fg", _7_}, {"<leader>,", _8_}, {"<leader>ld", _9_}, {"<leader>no", _10_}}, priority = 1000, opts = {lazygit = {enabled = true}, picker = {sources = {neorg = {finder = neorg_finder}}}}, lazy = false})
