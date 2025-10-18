{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
    lib = pkgs.lib;
    # from nixpkgs
    normalize-plugin = x:
      {
        deps = [];
        plug = null;
      }
      // (
        if (x ? plug)
        then x
        else {plug = x;}
      );
    with-deps = p: deps: {
      deps = deps;
      plug = p;
    };
    extra-programs = with pkgs; [fennel-ls fnlfmt alejandra rust-analyzer typescript prettierd nodejs];
    my-plugins = with pkgs.vimPlugins; [
      parinfer-rust
      mini-nvim
      nvim-lspconfig
      nfnl
      conjure
      oxocarbon-nvim
      conform-nvim
      rustaceanvim
      snacks-nvim
      (with-deps neorg [
        (pkgs.vimUtils.buildVimPlugin {
          inherit (pkgs.luajitPackages.lua-utils-nvim) pname version src;
        })

        (pkgs.vimUtils.buildVimPlugin {
          inherit (pkgs.luajitPackages.pathlib-nvim) pname version src;
          doCheck = false;
        })

        (pkgs.vimUtils.buildVimPlugin {
          inherit (pkgs.luajitPackages.nvim-nio) pname version src;
        })
      ])
      (nvim-treesitter.withPlugins (p: [p.fennel p.nix p.rust p.typescript p.tsx p.tree-sitter-norg p.tree-sitter-norg-meta]))
      (with-deps typescript-tools-nvim [plenary-nvim nvim-lspconfig])
      (with-deps nvim-ufo [promise-async])
      (nvim-treesitter.withPlugins (p: [p.fennel p.nix p.rust]))
      (with-deps blink-cmp [lspkind-nvim nvim-web-devicons])
      (with-deps telescope-nvim [plenary-nvim nvim-web-devicons telescope-fzf-native-nvim])
    ];
    plugins-normalized = pkgs.lib.map normalize-plugin my-plugins;
    tree-sitter-grammars = let
      ts = pkgs.lib.findFirst (p: p.plug.pname == "nvim-treesitter") null plugins-normalized;
    in
      ts.plug.dependencies or [];
    # {plug, deps} -> lazy.nvim plugin spec
    make-lazy-spec = deps: p: {
      name = p.pname;
      dir = toString p;
      dependencies = map (make-lazy-spec []) deps;
    };
    gen-plugin-specs = plugins:
      lib.pipe plugins [
        (map (p: {"${p.plug.pname}" = make-lazy-spec p.deps p.plug;}))
        # [attrset] -> attrset
        (lib.foldl' (acc: x: acc // x) {})
      ];
    # taken from https://github.com/crazazy/nixos-config/blob/05b4834d8c32adc4a56f97dfa003af983c03b1b9/lib/serialize.nix
    serialize = x:
      if lib.isAttrs x
      then "{ ${lib.concatStringsSep "," (map (k: "[\"${k}\"] = ${serialize x.${k}}") (lib.attrNames x))} }"
      else if lib.isList x
      then "{ ${lib.concatStringsSep "," (map serialize x)} }"
      else ''"${toString x}"'';
  in
    with pkgs; {
      bundled-tree-sitter-grammars = symlinkJoin {
        name = "bundled-tree-sitter-grammars";
        paths = tree-sitter-grammars;
      };
      generated-plugin-specs = ''
        vim.opt.rtp:prepend("${vimPlugins.lazy-nvim}")
        _G["tree-sitter-path"] = "${self.bundled-tree-sitter-grammars}"
        _G["plugin-specs"] = ${serialize (gen-plugin-specs plugins-normalized)}
      '';
      merged-init-lua = writeText "init.lua" (lib.concatLines [self.generated-plugin-specs (builtins.readFile ./init.lua)]);
      packages.x86_64-linux.neovim = symlinkJoin {
        name = "nvim";
        paths = [neovim-unwrapped];
        nativeBuildInputs = [makeWrapper];
        postBuild = ''
          wrapProgram $out/bin/nvim \
            --add-flags '-u' \
            --add-flags '${self.merged-init-lua}' \
            --suffix PATH : ${lib.makeBinPath extra-programs} \
        '';
      };
      packages.x86_64-linux.default = self.packages.x86_64-linux.neovim;
    };
}
