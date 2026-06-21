{
  description = "Rustlings dev environment (NixOS)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          # rustc, cargo and clippy MUST come from the same pin, otherwise
          # clippy refuses to run against a mismatched compiler.
          packages = with pkgs; [
            rustc
            cargo
            clippy
            rustfmt
            rust-analyzer
            rustlings
          ];

          # Let rust-analyzer find the standard library source for go-to-def.
          RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";

          shellHook = ''
            echo "rustlings dev shell ready -> run 'rustlings' or 'rustlings watch'"
          '';
        };
      });
}
