{ config, lib, ... }:

let
  cfg = config.userConfig;

  userConfigType = lib.types.submodule {
    options = {
      username = lib.mkOption {
        type = lib.types.str;
        description = "System username";
        example = "junr03";
      };

      name = lib.mkOption {
        type = lib.types.str;
        description = "Full name";
        example = "Jose Ulises Nino Rivera";
      };

      email = lib.mkOption {
        type = lib.types.str;
        description = "Email address";
        example = "junr03@users.noreply.github.com";
      };

      sshKey = lib.mkOption {
        type = lib.types.str;
        description = "SSH public key";
        example = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5...";
      };
    };
  };
in
{
  options = {
    userConfig = lib.mkOption {
      type = userConfigType;
      description = "User configuration for the system";
      default = {
        username = "junr03";
        name = "Jose Ulises Nino Rivera";
        email = "junr03@users.noreply.github.com";
        sshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOk8iAnIaa1deoc7jw8YACPNVka1ZFJxhnU4G74TmS+p";
      };
    };
  };
}

