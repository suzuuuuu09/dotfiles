# Share Vim-style navigation across applications

Where possible, align `h/j/k/l`, leader keys, and mode switches across Neovim, WezTerm, Herdr, AeroSpace, and Yazi. Caps Lock toggles a persistent Navigation Mode instead of requiring a held chord, and its LED indicates whether the mode is active. This reduces hand strain while retaining an explicit warning that ordinary text input is temporarily replaced by navigation commands. When adding the same key behavior to a new application, limit it to combinations that do not conflict with the application's important defaults.
