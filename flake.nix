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
      # Pass through everything the overlay exposes (xserver + all drivers)
      packages.${system} = xlibre-overlay.packages.${system};
    };
}
