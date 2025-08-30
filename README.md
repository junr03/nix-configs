# nix-configs

Configuration for provisioning macOS machines with [Nix](https://nixos.org), [`nix-darwin`](https://github.com/LnL7/nix-darwin), and [`home-manager`](https://github.com/nix-community/home-manager).  Secrets are managed with [`agenix`](https://github.com/ryantm/agenix).

## Repository layout

```
.
├── apps/                # helper scripts invoked via `nix run`
├── modules/             # shared modules and options
├── overlays/            # package overlays
├── flake.nix
└── flake.lock
```

## Provisioning a new Mac

1. **Decrypt blacktail keys**

   Download `rage` and `age-plugin-yubikey` and `mv` them to `/usr/local/bin`.

   Decrypt the keys

   ```sh
   rage -d -i age-yubikey-identity-32739404.txt -o blacktail blacktail.age
   rage -d -i age-yubikey-identity-32739404.txt -o blacktail.pub blacktail.pub.age
   ```

   ```sh
   rm /usr/local/bin/rage
   rm /usr/local/bin/age-yubikey-plugin
   ```

   Move the keys to `~/.ssh` from iCloud

   ```sh
   mv /Users/junr03/Library/Mobile Documents/com~apple~CloudDocs/gallatin/blacktail/blacktail ~/.ssh/
   mv /Users/junr03/Library/Mobile Documents/com~apple~CloudDocs/gallatin/blacktail/blacktail.pub ~/.ssh/
   ```

1. **Install Nix**

   Install the Xcode command line tools and Nix using the Determinate Systems installer:

   ```sh
   xcode-select --install
   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --nix-build-group-id 30000
   ```

1. **Clone this repository**

   ```sh
   git clone https://github.com/junr03/blacktail.git
   cd blacktail
   ```

1. **Build and activate the system**

   ```sh
   nix run .#build-switch
   ```

   This builds the configuration for `aarch64-darwin` and switches to the new generation.

1. **After the initial provisioning**

   - Rebuild and switch after making changes: `nix run .#build-switch`
   - Build without switching: `nix run .#build`
   - Roll back to a previous generation: `nix run .#rollback`
