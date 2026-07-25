# Publish Nix GUI applications as macOS aliases

Disable Home Manager's application copying and publish Nix-installed GUI applications as macOS aliases in `/Applications/Nix Apps` during activation. Ordinary symlinks are difficult to use through Spotlight and Launch Services, while copying application bundles would diverge from a layout where the Nix store is the source of truth, so use aliases. Recreate the collection of aliases from the current system closure each time so removed applications do not remain in `/Applications/Nix Apps`.
