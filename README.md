# This is a personal vibecoded repo, beware.

## Cache Binary Builder for XLibre on NixOS.

Builds [XLibre](https://github.com/X11Libre) (the X.Org server fork) for
`nixos-26.05` and `nixos-unstable`, and publishes the result to Cachix —
so you don't have to compile everything locally.

## Credits

- [X11Libre](https://github.com/X11Libre) — the server and drivers themselves.
- [takagemacoed/xlibre-overlay](https://codeberg.org/takagemacoed/xlibre-overlay) —
  packages all of this for Nix. This repo just builds what that overlay
  already defines and publishes it to a cache; nothing more.

## Using the cache

```nix
substituters = [ "https://sanjihiko-xlibre.cachix.org" ];
trusted-public-keys = [
  "sanjihiko-xlibre.cachix.org-1:hUlKNVrl+r+1sGnCb/6jcK3M/0RdzK3kRa8YWZCijc8="
];
```

To actually consume XLibre in a config, point at
[`xlibre-overlay`](https://codeberg.org/takagemacoed/xlibre-overlay)
directly (`?ref=main` or `?ref=dev-26.11`), not this repo — this repo
only exists to keep the cache warm.
