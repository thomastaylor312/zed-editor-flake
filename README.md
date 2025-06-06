# Zed Editor Flake

This repository provides a Nix flake for the [Zed Editor](https://zed.dev/), a high-performance, multiplayer code editor from the creators of Atom and Tree-sitter.

## Available Packages

This flake provides the following packages:

- `zed-editor`: Built from source
- `zed-editor-bin`: Pre-built binaries directly from upstream releases
- `zed-editor-fhs`: FHS-compatible environment for the source-built version
- `zed-editor-bin-fhs`: FHS-compatible environment for the binary version

## Usage

### Installing with Nix Run

```sh
nix run github:HPsaucii/zed-editor-flake

nix run github:HPsaucii/zed-editor-flake#zed-editor-bin

nix run github:HPsaucii/zed-editor-flake#zed-editor-fhs
```

### Adding to Your Configuration

In your `flake.nix`:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    zed-editor.url = "github:HPsaucii/zed-editor-flake";
  };
  
  outputs = { self, nixpkgs, zed-editor, ... }:
  {
    nixosConfigurations.hostname = nixpkgs.lib.nixosSystem {
      modules = [
        ({ pkgs, ... }: {
          environment.systemPackages = [
            zed-editor.packages.${pkgs.system}.zed-editor
          ];
        })
      ];
    };

    homeConfigurations.HPsaucii = home-manager.lib.homeManagerConfiguration {
      modules = [
        {
          home.packages = [
            zed-editor.packages.${pkgs.system}.zed-editor
          ];
        }
      ];
    };
  };
}
```

## Automated Updates

This repository uses GitHub Actions to automatically check for new Zed Editor releases and update the packages.

### Update Workflow

The automated update workflow:

1. Checks for new Zed Editor releases on a schedule (Monday and Thursday)
2. Updates package versions in both packages
3. Updates the source hash for `zed-editor`
4. Updates binary hashes for `zed-editor-bin`
5. Updates the cargoHash for `zed-editor`
6. Updates the flake lock file
7. Creates a pull request with all changes

### Manual Trigger

You can manually trigger the update workflow through the GitHub Actions interface:

1. Navigate to the "Actions" tab in your repository
2. Select the "Update Zed Editor Packages" workflow
3. Click "Run workflow"
4. Optionally specify a specific version to update to

## Contributing

Contributions are welcome! Please feel free to submit a pull request.
