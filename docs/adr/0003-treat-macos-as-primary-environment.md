# Treat macOS as the primary environment

Use macOS as the baseline for daily work and static checks. Treat NixOS-WSL as an auxiliary target environment for using the shared user environment when working with Unity and similar tools on Windows. Keeping the features and checks of both environments at the same level would impose maintenance cost disproportionate to WSL usage, so that approach is not adopted. Confirm that WSL can be reconstructed through a Linux system build, without guaranteeing parity with macOS.
