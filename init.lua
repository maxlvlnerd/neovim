-- [nfnl] init.fnl
local function noremap(maps)
  for _, v in ipairs(maps) do
    vim.keymap.set((v.mode or ""), v.key, v.action, {silent = true, desc = v.desc})
  end
  return nil
end
local function plug(name, opts)
  _G["plugin-specs"][name] = vim.tbl_extend("force", _G["plugin-specs"][name], opts)
  return nil
end
local function load_lazy()
  local lazy = require("lazy")
  local plugs
  do
    local tbl_21_ = {}
    local i_22_ = 0
    for _, v in pairs(_G["plugin-specs"]) do
      local val_23_ = v
      if (nil ~= val_23_) then
        i_22_ = (i_22_ + 1)
        tbl_21_[i_22_] = val_23_
      else
      end
    end
    plugs = tbl_21_
  end
  return lazy.setup({checker = {enabled = true}, rocks = {enabled = false}, profiling = {loader = true, require = true}, spec = plugs})
end
local function new_cmd(name, cb)
  return vim.api.nvim_create_user_command(name, cb, {})
end
local function cmp_add_icon(ctx)
  local icon = ctx.kind_icon
  if vim.tbl_contains({"Path"}, ctx.source_name) then
    local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
    if dev_icon then
      icon = dev_icon
    else
    end
  else
    icon = require("lspkind").symbolic(ctx.kind, {mode = "symbol"})
  end
  return (icon .. ctx.icon_gap)
end
local function cmp_highlight(ctx)
  local hl = ctx.kind_hl
  if vim.tbl_contains({"Path"}, ctx.source_name) then
    local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
    if dev_icon then
      hl = dev_hl
    else
    end
  else
  end
  return hl
end
vim.g.mapleader = " "
plug("nfnl", {ft = "fennel"})
plug("blink.cmp", {opts_extend = {"sources.default"}, opts = {completion = {documentation = {auto_show = true, auto_show_delay_ms = 500}, menu = {draw = {components = {kind_icon = {text = cmp_add_icon, highlight = cmp_highlight}}, columns = {{"kind_icon"}, {"label", "label_description", "source_name", gap = 1}}}}}, sources = {default = {"lsp", "path", "buffer"}}}})
local function _6_(_, opts)
  vim.opt.rtp:prepend(_G["tree-sitter-path"])
  local ts = require("nvim-treesitter.configs")
  return ts.setup(opts)
end
plug("nvim-treesitter", {opts = {highlight = {enable = true}}, config = _6_})
local function _7_()
  local config = require("mini.basics")
  return config.setup()
end
plug("mini.nvim", {config = _7_})
local function _8_()
  vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  return nil
end
local function _9_()
  return require("conform").format({async = true})
end
plug("conform.nvim", {cmd = "ConformInfo", event = "BufWritePre", init = _8_, keys = {{"<leader>f", _9_, desc = "Format buffer", mode = ""}}, opts = {default_format_opts = {lsp_format = "fallback"}, format_on_save = {timeout_ms = 500}, formatters_by_ft = {fennel = {"fnlfmt"}, nix = {"alejandra"}, typescript = {"prettierd"}}}})
plug("typescript-tools.nvim", {opts = {}})
local function _10_()
  return {"treesitter", "indent"}
end
plug("nvim-ufo", {opts = {provider_selector = _10_}})
local function neorg_finder()
  local neorg = require("neorg")
  local dirman = neorg.modules.get_module("core.dirman")
  local _let_11_ = dirman.get_current_workspace()
  local workspace = _let_11_[1]
  local cwd = _let_11_[2]
  local workspace_files = dirman.get_norg_files(workspace)
  local tbl_21_ = {}
  local i_22_ = 0
  for _, v in ipairs(workspace_files) do
    local val_23_ = {file = tostring(v)}
    if (nil ~= val_23_) then
      i_22_ = (i_22_ + 1)
      tbl_21_[i_22_] = val_23_
    else
    end
  end
  return tbl_21_
end
local function _13_()
  return Snacks.lazygit()
end
local function _14_()
  return Snacks.picker.smart()
end
local function _15_()
  return Snacks.picker.grep()
end
local function _16_()
  return Snacks.picker.buffers()
end
local function _17_()
  return Snacks.picker.diagnostics()
end
local function _18_()
  return Snacks.picker.neorg()
end
plug("snacks.nvim", {keys = {{"<leader>gg", _13_, desc = "Lazygit"}, {"<leader><space>", _14_}, {"<leader>fg", _15_}, {"<leader>,", _16_}, {"<leader>ld", _17_}, {"<leader>no", _18_}}, priority = 1000, opts = {lazygit = {enabled = true}, picker = {sources = {neorg = {finder = neorg_finder}}}}, lazy = false})
plug("neorg", {opts = {load = {["core.defaults"] = {}, ["core.concealer"] = {}, ["external.interim-ls"] = {config = {completion_provider = {enable = true, documentation = true}}}, ["core.completion"] = {config = {engine = {module_name = "external.lsp-completion"}}}, ["core.dirman"] = {config = {workspaces = {main = "~/persist/logs/notes"}, default_workspace = "main"}}}}})
load_lazy()
local function _19_()
  local exrc = (vim.fn.getcwd() .. "/.nvim.lua")
  if vim.secure.read(exrc) then
    return vim.cmd.source(exrc)
  else
    return nil
  end
end
new_cmd("SourceExrc", _19_)
noremap({{key = "n", action = "j"}, {key = "e", action = "k"}, {key = "o", action = "l"}})
local function _21_()
  return vim.lsp.buf.definition()
end
noremap({{key = "grd", action = _21_}})
noremap({{key = "zR", action = require("ufo").openAllFolds, desc = "Open all folds"}})
noremap({{key = "zM", action = require("ufo").closeAllFolds, desc = "Close all folds"}})
vim.lsp.enable("fennel_ls")
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.signcolumn = "number"
vim.opt.number = true
vim.opt.relativenumber = true
return vim.cmd.colorscheme("oxocarbon")
