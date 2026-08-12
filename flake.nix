{
  description = "Build XLibre (via takagemacoed/xlibre-overlay, dev-26.11 branch) and publish to a binary cache";

  # Offers this cache automatically to anyone consuming this flake,
  # same mechanism as niri-flake's cachix cache. Nix will prompt to
  # trust it once; the answer persists in trusted-settings.json.
  nixConfig = {
    extra-substituters = [ "https://sanjihiko-xlibre.cachix.org" ];
    extra-trusted-public-keys = [
      "sanjihiko-xlibre.cachix.org-1:hUlKNVrl+r+1sGnCb/6jcK3M/0RdzK3kRa8YWZCijc8="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # dev-26.11 branch: the one upstream maintains for nixos-unstable/26.11,
    # as opposed to main/dev-for-26.05 (pinned for stable 26.05) or dev
    # (25.11, deprecated). See their README's "Update of 2026-07-11" section.
    #
    # Following our own nixpkgs is officially supported on this branch
    # (upstream's README shows it as an optional line), unlike the pinned
    # main branch where it previously caused a documented breakage.
    xlibre-overlay = {
      url = "git+https://codeberg.org/takagemacoed/xlibre-overlay?ref=dev-26.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, xlibre-overlay }:
    let
      system = "x86_64-linux";
    in
    {
      packages.${system} = xlibre-overlay.packages.${system};
    };
}
