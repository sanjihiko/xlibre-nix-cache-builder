{
  description = "Build XLibre (via takagemacoed/xlibre-overlay, stable and unstable branches) and publish to a binary cache";

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
    # Our own recent nixpkgs, used only to override the unstable
    # overlay's pin below - deliberately NOT applied to stable.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # main: upstream's branch pinned for stable NixOS (nixos-26.05).
    # No follows here: keeps upstream's own tested/pinned nixpkgs.
    xlibre-overlay-stable.url = "git+https://codeberg.org/takagemacoed/xlibre-overlay?ref=main";

    # dev-26.11: upstream's branch tracking nixos-unstable/26.11.
    # Follows our recent nixpkgs deliberately: upstream updates this
    # branch's own pin infrequently (no unstable test machine on their
    # end), so staying on their pin means we'd rarely match a fresh
    # personal nixos-unstable. This trades upstream's safety margin for
    # freshness - if a future nixpkgs refactor breaks it, only the
    # unstable-* builds fail (the tolerant build loop handles that
    # per-package), stable-* is unaffected either way.
    xlibre-overlay-unstable = {
      url = "git+https://codeberg.org/takagemacoed/xlibre-overlay?ref=dev-26.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, xlibre-overlay-stable, xlibre-overlay-unstable }:
    let
      system = "x86_64-linux";

      # Prefix every package name from a given upstream package set,
      # so the two channels don't collide in our own output set.
      prefixPackages = prefix: pkgs:
        builtins.listToAttrs (map
          (name: { name = "${prefix}-${name}"; value = pkgs.${name}; })
          (builtins.attrNames pkgs));
    in
    {
      # stable stays on upstream's own pinned nixpkgs; unstable follows
      # ours (see comment on the input above).
      packages.${system} =
        (prefixPackages "stable" xlibre-overlay-stable.packages.${system})
        // (prefixPackages "unstable" xlibre-overlay-unstable.packages.${system});
    };
}
