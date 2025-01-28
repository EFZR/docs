# NixOS

NixOS is a Linux distribution built on the Nix package manager, known for its **declarative configuration** model and functional package management. The core principle of NixOS is **reproducibility**, making it an ideal choice for developers and system administrators who require precise and reliable system management.

## Creating a Shell Environment

A **shell environment** in NixOS allows you to install and run software without modifying your system globally. This is especially useful when you want to experiment with different package versions.

For example, to create a shell environment with a specific package:

```bash
nix-shell -p <package>
```

This command opens a shell where the specified package is available. After you're done, you can exit the environment by pressing `CTRL-D` or running `exit`.

### Key Points

- Shell environments are **ephemeral** and will be discarded once exited.
- The available package versions depend on the specific NixOS channel you're using, so versions may vary between users.

## Running Programs Once

If you need to run a program once without installing it permanently, you can use the following command:

```bash
nix-shell -p <package> --run "<command>"
```

This will temporarily make the package available, execute the command, and then exit the shell.

## Installing Packages Globally

To install a package globally so that it's always available on your system, add it to your configuration file:

1. Open the configuration file:

    ```bash
    sudo nano /etc/nixos/configuration.nix
    ```

2. Add the desired package under the `environment.systemPackages` attribute:

    ```nix
    environment.systemPackages = with pkgs; [
      <package>
    ];
    ```

3. Apply the changes:

    ```bash
    sudo nixos-rebuild switch
    ```

This ensures that the package is installed globally and will persist across reboots.

## Searching for Packages

To search for available packages in NixOS, use the `nix search` command:

```bash
nix search <package-name>
```

This will display a list of available packages related to the search term.

## Removing Unused Packages

Over time, you might accumulate packages or dependencies that are no longer needed. To remove unused packages and free up disk space, you can run:

```bash
nix-collect-garbage
```

For a more thorough cleanup, including removing old generations (system rollbacks):

```bash
nix-collect-garbage -d
```

## Rolling Back System Changes

If a recent system change caused issues, NixOS allows you to roll back to a previous working generation. To view available generations, use:

```bash
sudo nix-env --list-generations
```

Then, to roll back to a specific generation:

```bash
sudo nix-env --rollback
```

Alternatively, reboot and select the desired generation from the GRUB menu.

## Updating NixOS Configuration

To apply changes to the NixOS system configuration, you need to edit the system’s **configuration.nix** file. After making the changes, reapply them using:

```bash
sudo nixos-rebuild switch
```

This command ensures that the system is updated according to the latest configuration. One of the core features of NixOS is its **declarative configuration** model, which allows you to easily replicate your environment on multiple machines by transferring the configuration file.

## Upgrading NixOS

To update all packages and your system to the latest available versions, first update the Nix channels:

```bash
sudo nix-channel --update
```

Then rebuild your system with the latest updates:

```bash
sudo nixos-rebuild switch --upgrade
```

This ensures that both the system and the packages are kept up to date.

## Viewing Current System Configuration

If you want to view the current system configuration, you can use:

```bash
nixos-option
```

This will provide details on the current configuration and its values.

## Nix Flakes

Nix Flakes provide a standardized way to manage and share NixOS configurations across different systems and NixOS versions. Since packages and configurations can change between NixOS versions, Flakes offer a way to ensure consistency and reproducibility. By using Flakes, you can lock dependencies to specific versions, making it easier to maintain and deploy consistent environments across machines.

## Nix Flakes Commands

### **`nix flake init`**

Initializes a new flake in the current directory. This creates a basic `flake.nix` file with a template configuration.

```bash
nix flake init
```

### **`nix flake new`**

Creates a new flake from a specified template or repo. You can use predefined templates or a custom one from a repository.

```bash
nix flake new ./my-flake --template nixos#minimal
```

### **`nix flake update`**

Updates the inputs of a flake (e.g., dependencies) to their latest versions. This is useful when you want to ensure your project is using the latest packages or configurations.

```bash
nix flake update
```

### **`nix flake show`**

Shows detailed information about a flake, including its outputs, dependencies, and configuration. This helps you inspect the contents of any flake.

```bash
nix flake show
```

### **`nix flake lock`**

Locks the current versions of all inputs in the flake. This ensures that you always use the exact same versions of dependencies in future builds.

```bash
nix flake lock
```

### **`nix flake check`**

Verifies that a flake is valid and that it builds correctly. It also checks that the inputs are valid and available.

```bash
nix flake check
```

### **`nix flake info`**

Displays summary information about a flake without fetching or building it.

```bash
nix flake info
```

### **`nix flake list-inputs`**

Lists the input dependencies (other flakes) that are required by the current flake.

```bash
nix flake list-inputs
```

### **`nix flake rebuild`**

Rebuilds a NixOS system using the current flake configuration. This is particularly useful for reapplying system configurations.

```bash
sudo nixos-rebuild switch --flake .#hostname
```

### **`nix flake archive`**

Generates an archive (tarball) of the current flake, allowing it to be shared or saved.

```bash
nix flake archive
```
