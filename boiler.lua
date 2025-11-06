-- [nfnl] boiler.fnl
 local function noremap(maps)

 for _, v in ipairs(maps) do
 vim.keymap.set((v.mode or ""), v.key, v.action, {silent = true, desc = v.desc}) end return nil end

 local function plug(name, opts)

 _G["plugin-specs"][name] = vim.tbl_extend("force", _G["plugin-specs"][name], opts) return nil end


 local function load_lazy()

 local lazy = require("lazy") local plugs
 do local tbl_26_ = {} local i_27_ = 0 for _, v in pairs(_G["plugin-specs"]) do
 local val_28_ = v if (nil ~= val_28_) then i_27_ = (i_27_ + 1) tbl_26_[i_27_] = val_28_ else end end plugs = tbl_26_ end
 return lazy.setup({checker = {enabled = true}, rocks = {enabled = false}, profiling = {loader = true, require = true}, spec = plugs}) end




 local function new_cmd(name, cb)
 return vim.api.nvim_create_user_command(name, cb, {}) end

 return {plug = plug, noremap = noremap, ["load-lazy"] = load_lazy, ["new-cmd"] = new_cmd}
