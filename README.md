# AutoKali

AutoKali is a tool designed to automate the deployment of a custom environment on Kali Linux. It simplifies the installation process by executing some bash scripts that installs a set of tools and customizes the desktop and terminal.

Also automates some config by downloading a dotfiles repository.

## Download

Clone this repository to your local machine and give the installation script execution permissions.

```bash
git clone https://github.com/dkadev/autokali && cd autokali && chmod +x autokali.sh
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

If any installation step fails, an error log file **error.log** is stored so that these errors can be manually resolved later.

## Browser extensions

I prefer installing the following extensions manually (not much of a hassle):

- [uBlock Origin](https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/)
- [Wappalyzer](https://addons.mozilla.org/en-US/firefox/addon/wappalyzer/)
- [Cookie Editor](https://addons.mozilla.org/en-US/firefox/addon/cookie-editor/)
- [PwnFox](https://addons.mozilla.org/en-US/firefox/addon/pwnfox/)

## Credits

This project was heavily inspired (with few modifications) on [AutoDeploy](https://github.com/m4lal0/autoDeploy) project by m4lal0
