# nix-configs

Configuration for provisioning macOS machines with [Nix](https://nixos.org), [`nix-darwin`](https://github.com/LnL7/nix-darwin), and [`home-manager`](https://github.com/nix-community/home-manager).  Secrets are managed with [`agenix`](https://github.com/ryantm/agenix).

## Repository layout

```
.
├── apps/                # helper scripts invoked via `nix run`
├── hosts/               # per-host system definitions
├── modules/             # shared modules and options
├── overlays/            # package overlays
├── flake.nix
└── flake.lock
```

## Provisioning a new Mac

1. **Install Nix**

   Install the Xcode command line tools and Nix using the Determinate Systems installer:

   ```sh
   xcode-select --install
   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
   ```

   After installation, open a new terminal session. When prompted by the installer, decline the option to install Determinate Nix, as it conflicts with `nix-darwin`.

   If you instead use the official Nix installer, enable the experimental `nix-command` and `flakes` features by adding the following line to `/etc/nix/nix.conf`:

   ```
   experimental-features = nix-command flakes
   ```

2. **Clone this repository**

   ```sh
   git clone https://github.com/junr03/nix-configs.git
   cd nix-configs
   ```

3. **Personalize the configuration**

   The `apply` script replaces placeholders (user name, email, secrets repo, etc.) in the configuration files:

   ```sh
   nix run .#apply
   ```

4. **Set up SSH keys**

   Generate new keys or copy existing ones from a USB drive, then verify that they exist:

   ```sh
   # generate keys
   nix run .#create-keys

   # or copy from USB
   nix run .#copy-keys

   # verify
   nix run .#check-keys
   ```

5. **Build and activate the system**

   ```sh
   nix run .#build-switch
   ```

   This builds the configuration for `aarch64-darwin` and switches to the new generation.

6. **After the initial provisioning**

   - Rebuild and switch after making changes: `nix run .#build-switch`
   - Build without switching: `nix run .#build`
   - Roll back to a previous generation: `nix run .#rollback`

## Notes

This flake expects a separate private repository containing age-encrypted secrets, referenced by the `secrets` input. Ensure you can access this repository via SSH before running the provisioning steps.

