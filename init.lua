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
plug("conjure", {ft = "fennel"})
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
local function _10_(_, opts)
  local tele = require("telescope")
  tele.setup(opts)
  return tele.load_extension("fzf")
end
plug("telescope.nvim", {keys = {{"<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Telescope find files"}, {"<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Telescope live grep"}, {"<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Telescope buffers"}, {"<leader>ld", "<cmd>Telescope diagnostics<cr>", desc = "Telescope lsp diagnostics"}}, config = _10_, lazy = false})
plug("typescript-tools.nvim", {opts = {}})
local function _11_()
  return {"treesitter", "indent"}
end
plug("nvim-ufo", {opts = {provider_selector = _11_}})
load_lazy()
local function _12_()
  local exrc = (vim.fn.getcwd() .. "/.nvim.lua")
  if vim.secure.read(exrc) then
    return vim.cmd.source(exrc)
  else
    return nil
  end
end
new_cmd("SourceExrc", _12_)
noremap({{key = "n", action = "j"}, {key = "e", action = "k"}, {key = "o", action = "l"}})
noremap({{key = "zR", action = require("ufo").openAllFolds, desc = "Open all folds"}})
noremap({{key = "zM", action = require("ufo").closeAllFolds, desc = "Close all folds"}})
vim.lsp.enable("fennel_ls")
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.signcolumn = "number"
vim.opt.number = true
vim.opt.relativenumber = true
return vim.cmd.colorscheme("oxocarbon")
