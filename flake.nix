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
    # main: upstream's branch pinned for stable NixOS (nixos-26.05).
    xlibre-overlay-stable.url = "git+https://codeberg.org/takagemacoed/xlibre-overlay?ref=main";

    # dev-26.11: upstream's branch tracking nixos-unstable/26.11.
    xlibre-overlay-unstable.url = "git+https://codeberg.org/takagemacoed/xlibre-overlay?ref=dev-26.11";
  };

  outputs = { self, xlibre-overlay-stable, xlibre-overlay-unstable }:
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
      # Passed through as-is, each built against its own upstream's
      # pinned nixpkgs. No follows, no re-applying overlays ourselves.
      packages.${system} =
        (prefixPackages "stable" xlibre-overlay-stable.packages.${system})
        // (prefixPackages "unstable" xlibre-overlay-unstable.packages.${system});
    };
}
