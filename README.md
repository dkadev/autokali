# AutoKali

AutoKali is a tool designed to automate the deployment of a custom environment on Kali Linux. It simplifies the installation process by executing some bash scripts that installs a set of tools and customizes the desktop and terminal.

Also automates some config by downloading a dotfiles repository.

## Pre-installation steps

0. Install Oh My Zsh (if not already installed):

    ```bash
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    ```

1. Create a new sudo user:

    ```bash
    sudo adduser <username>
    sudo usermod -aG sudo <username>
    ```

2. Change hostname:

    ```bash
    sudo hostnamectl set-hostname <new-hostname>
    ```

3. Reboot the system:

    ```bash
    sudo reboot
    ```

## Download

1. Clone this repository to your local machine.

    ```bash
    git clone https://github.com/dkadev/autokali
    ```

2. Open a terminal and navigate to the project directory and give the installation script execution permissions.

    ```bash
    cd autokali; chmod +x autokali.sh
    ```

## Usage

### Full installation

```sh
sudo ./autokali.sh --install
```

### Only customize the desktop

```sh
sudo ./autokali.sh --install desktop
```

### Only install the tools

```sh
sudo ./autokali.sh --install tools
```

At the beginning, it will prompt for some data for the installation process, the rest of the execution should be performed automatically without requiring user interaction. If any installation step fails, an error log file **error.log** is stored so that these errors can be manually resolved later.

## Credits

This project was heavily inspired (with few modifications) on [AutoDeploy](https://github.com/m4lal0/autoDeploy) project by m4lal0
