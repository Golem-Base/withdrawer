{
  description = "op.nix / Optimism dev environment with Nix!";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    inputs@{ flake-parts, systems, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = (import systems);

      perSystem =
        { self', pkgs, ... }:
        {
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              go
              go-tools
              gopls
              gotools
            ];
          };

          packages.default = pkgs.buildGoModule {
            pname = "withdrawer";
            version = "0.0.0";

            src = ./.;

            vendorHash = "sha256-qsrOL2dCTj3PQqdteCoVq2GtsLT8F/yTQW5+PRL6Jmk=";

            doCheck = false;

            ldflags = [
              "-s"
              "-w"
            ];

            meta = {
              description = "Golang utility for proving and finalizing withdrawals from op-stack chains";
              homepage = "https://github.com/base/withdrawer";
              mainProgram = "withdrawer";
            };
          };

        };
    };
}
