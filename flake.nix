{
  description = "Build XLibre (via takagemacoed/xlibre-overlay) and publish to a binary cache";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    xlibre-overlay = {
      url = "git+https://codeberg.org/takagemacoed/xlibre-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, xlibre-overlay }:
    let
      system = "x86_64-linux";
    in
    {
      # Re-export upstream's packages as-is; check
      # `nix flake show git+https://codeberg.org/takagemacoed/xlibre-overlay`
      # if these names change.
      packages.${system} = {
        default = xlibre-overlay.packages.${system}.xlibre-xserver;
        xlibre-xserver = xlibre-overlay.packages.${system}.xlibre-xserver;
      };
    };
}
