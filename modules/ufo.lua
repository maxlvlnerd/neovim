-- [nfnl] modules/ufo.fnl
 package.preload["boiler"] = package.preload["boiler"] or function(...) local function noremap(maps) for _, v in ipairs(maps) do vim.keymap.set((v.mode or ""), v.key, v.action, {silent = true, desc = v.desc}) end return nil end local function plug(name, opts) _G["plugin-specs"][name] = vim.tbl_extend("force", _G["plugin-specs"][name], opts) return nil end local function load_lazy() local lazy = require("lazy") local plugs do local tbl_21_ = {} local i_22_ = 0 for _, v in pairs(_G["plugin-specs"]) do local val_23_ = v if (nil ~= val_23_) then i_22_ = (i_22_ + 1) tbl_21_[i_22_] = val_23_ else end end plugs = tbl_21_ end return lazy.setup({checker = {enabled = true}, rocks = {enabled = false}, profiling = {loader = true, require = true}, spec = plugs}) end local function new_cmd(name, cb) return vim.api.nvim_create_user_command(name, cb, {}) end return {plug = plug, noremap = noremap, ["load-lazy"] = load_lazy, ["new-cmd"] = new_cmd} end local _local_2_ = require("boiler") local plug = _local_2_["plug"] local noremap = _local_2_["noremap"]
 local function _3_() return {"treesitter", "indent"} end plug("nvim-ufo", {opts = {provider_selector = _3_}})


 local function _4_() return require("ufo").openAllFolds("desc", "Open all folds") end noremap({{key = "zR", action = _4_}})


 local function _5_() return require("ufo").closeAllFolds("desc", "Close all folds") end return noremap({{key = "zM", action = _5_}})
