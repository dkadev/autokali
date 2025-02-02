#!/usr/bin/env bash

### Terminal customization
function customDesktop(){
	section "STARTING SYSTEM CUSTOMIZATION"
	checkInternet
	info "Updating repositories"
	apt update > /dev/null 2>&1

    # Packages
    info "Installing necessary packages for customization"
    apt install terminator -y > /dev/null 2>&1
    check "Installing Terminator"

    apt install fzf -y > /dev/null 2>&1
    check "Installing fzf"

    if [ "$(uname -m)" = "x86_64" ]; then
        wget "https://github.com/lsd-rs/lsd/releases/download/v1.1.2/lsd-musl_1.1.2_amd64.deb" -O /tmp/lsd.deb > /dev/null 2>&1
    elif [ "$(uname -m)" = "aarch64" ]; then
        wget "https://github.com/lsd-rs/lsd/releases/download/v1.1.2/lsd-musl_1.1.2_arm64.deb" -O /tmp/lsd.deb > /dev/null 2>&1
    fi
	dpkg -i /tmp/lsd.deb > /dev/null 2>&1
	check "Installing lsd"

    if [ "$(uname -m)" = "x86_64" ]; then
	    wget "https://github.com/sharkdp/bat/releases/download/v0.24.0/bat_0.24.0_amd64.deb" -O /tmp/bat.deb > /dev/null 2>&1
    elif [ "$(uname -m)" = "aarch64" ]; then
	    wget "https://github.com/sharkdp/bat/releases/download/v0.24.0/bat_0.24.0_arm64.deb" -O /tmp/bat.deb > /dev/null 2>&1
    fi
	dpkg -i /tmp/bat.deb > /dev/null 2>&1
	check "Installing bat"

    # Install Oh My Zsh
    info "Installing Oh My Zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" > /dev/null 2>&1
    check "Installing Oh My Zsh"

    # Set zsh as default shell if not already set
    info "Setting zsh as default shell"
    if [ "$SHELL" != "/bin/zsh" ]; then
        chsh -s /bin/zsh
        check "Setting zsh as default shell"
    else
        info "zsh is already the default shell"
    fi

    # Fonts
	info "Installing font (Hack Nerd Font)"
	cd /usr/local/share/fonts/ 2>/dev/null
    cp $FILES_PATH/fonts/Hack.zip /usr/local/share/fonts/ > /dev/null 2>&1
	unzip -o Hack.zip > /dev/null 2>&1
	rm Hack.zip 2>/dev/null
	check "Hack Nerd Font installed"

    cd $HOME_PATH

    # Dotfiles
    info "Downloading dotfiles"
    git clone https://github.com/dkadev/dotfiles $HOME_PATH/.dotfiles  > /dev/null 2>&1
    chown -R $USERNAME:$USERNAME $HOME_PATH/.dotfiles 2>/dev/null
    check "Cloning dotfiles repository"
    apt install stow -y > /dev/null 2>&1
    check "Installing stow"
    rm -rf .zshrc > /dev/null 2>&1
    cd $HOME_PATH/.dotfiles > /dev/null 2>&1
    stow zsh > /dev/null 2>&1
    stow oh-my-zsh > /dev/null 2>&1
    stow terminator > /dev/null 2>&1
    check "Applying dotfiles"

    cd $HOME_PATH

    # Powerlevel10k
    info "Installing powerlevel10k"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME_PATH/.oh-my-zsh/custom}/themes/powerlevel10k > /dev/null 2>&1
    check "Cloning powerlevel10k repository"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME_PATH/.oh-my-zsh/custom}/plugins/zsh-autosuggestions > /dev/null 2>&1
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME_PATH/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting > /dev/null 2>&1
    check "Installing Oh My Zsh plugins"
	cp $FILES_PATH/.p10k.zsh $HOME_PATH/.p10k.zsh 2>/dev/null
    chown $USERNAME:$USERNAME $HOME_PATH/.p10k.zsh 2>/dev/null
	check "Adding p10k.zsh"

	cd $HOME_PATH

    # Catapult
	info "Installing catapult"
    apt install -y gettext \
                 gir1.2-glib-2.0 \
                 gir1.2-gtk-4.0 \
                 gir1.2-pango-1.0 \
                 libglib2.0-bin \
                 python3 \
                 python3-dev \
                 python3-gi \
                 qalc  > /dev/null 2>&1
    git clone https://github.com/otsaloma/catapult > /dev/null 2>&1
    cd catapult
    make PREFIX=/usr/local build > /dev/null 2>&1
    make PREFIX=/usr/local install > /dev/null 2>&1
	check "Configuring catapult"

    cd $HOME_PATH

    # Desktop
	info "Configuring desktop"
    cp $FILES_PATH/xfce4/kali-*.jpg /usr/share/backgrounds/ > /dev/null 2>&1
	check "Downloading kali backgrounds"

	unlink /usr/share/desktop-base/kali-theme/login/background > /dev/null 2>&1
	ln -s /usr/share/backgrounds/kali-login-ascii.jpg /usr/share/desktop-base/kali-theme/login/background > /dev/null 2>&1
	check "Configuring login background"

    mv $FILES_PATH/xfce4/lightdm-gtk-greeter.conf /etc/lightdm/lightdm-gtk-greeter.conf > /dev/null 2>&1
    check "Configuring lightdm"

	cp $FILES_PATH/xfce4/xfce4-desktop.xml $HOME_PATH/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml > /dev/null 2>&1
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml 2>/dev/null
	check "Configuring desktop"

	cp $FILES_PATH/xfce4/xfce4-keyboard-shortcuts.xml $HOME_PATH/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml > /dev/null 2>&1
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml 2>/dev/null
	check "Configuring keyboard shortcuts"

	cp $FILES_PATH/xfce4/thunar.xml $HOME_PATH/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml > /dev/null 2>&1
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml 2>/dev/null
	check "Configuring file explorer"

	cp $FILES_PATH/xfce4/xfce4-panel.xml $HOME_PATH/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml > /dev/null 2>&1
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml 2>/dev/null
	check "Configuring taskbar"

	cp $FILES_PATH/xfce4/xfwm4.xml $HOME_PATH/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml > /dev/null 2>&1
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml 2>/dev/null
	check "Configuring windows"

	cp $FILES_PATH/xfce4/xfce4-power-manager.xml $HOME_PATH/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-power-manager.xml > /dev/null 2>&1
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-power-manager.xml 2>/dev/null
	check "Configuring power manager"

    # Icons
    info "Configuring icons"
	cd $FILES_PATH/xfce4 2>/dev/null
	tar -xJf 05-Flat-Remix-Black-20240201.tar.xz > /dev/null 2>&1
	mkdir $HOME_PATH/.local/share/icons && cp $FILES_PATH/xfce4/Flat-Remix-Black-Dark $HOME_PATH/.local/share/icons -r > /dev/null 2>&1
	chown -R $USERNAME:$USERNAME $HOME_PATH/.local/share/icons 2>/dev/null
	check "Extracting icons ($USERNAME)"

	mkdir -p /root/.local/share && ln -s $HOME_PATH/.local/share/icons /root/.local/share/icons 2>/dev/null
    cp $FILES_PATH/xfce4/Flat-Remix-Black-Dark /usr/share/icons/Flat-Remix-Black-Dark -r > /dev/null 2>&1
	check "Extracting icons (root)"

	cp $FILES_PATH/xfce4/xsettings.xml $HOME_PATH/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml > /dev/null 2>&1
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml 2>/dev/null
	check "Configuring icons in the system"

	gtk-update-icon-cache $HOME_PATH/.local/share/icons/Flat-Remix-Black-Dark > /dev/null 2>&1
	check "Updating icons"

    # Taskbar configuration
    info "Configuring taskbar"
	mkdir $HOME_PATH/.config/scripts && chown -R $USERNAME:$USERNAME $HOME_PATH/.config/scripts/ 2>/dev/null
	check "Configuring scripts directory for taskbar"

	cp $FILES_PATH/scripts/ethstatus.sh $HOME_PATH/.config/scripts/ethstatus.sh > /dev/null 2>&1
	chmod 774 $HOME_PATH/.config/scripts/ethstatus.sh 2>/dev/null
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/scripts/ethstatus.sh 2>/dev/null
	check "Copying eth script"

	cp $FILES_PATH/panel/genmon-4.rc $HOME_PATH/.config/xfce4/panel/genmon-4.rc > /dev/null 2>&1
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/xfce4/panel/genmon-4.rc 2>/dev/null
	check "Configuring network info in taskbar"

	cp $FILES_PATH/scripts/vpnstatus.sh $HOME_PATH/.config/scripts/vpnstatus.sh > /dev/null 2>&1
	chmod 774 $HOME_PATH/.config/scripts/vpnstatus.sh 2>/dev/null
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/scripts/vpnstatus.sh 2>/dev/null
	check "Copying vpn script"

	cp $FILES_PATH/panel/genmon-5.rc $HOME_PATH/.config/xfce4/panel/genmon-5.rc > /dev/null 2>&1
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/xfce4/panel/genmon-5.rc 2>/dev/null
	check "Configuring VPN info in taskbar"

	cp $FILES_PATH/scripts/wifistatus.sh $HOME_PATH/.config/scripts/wifistatus.sh > /dev/null 2>&1
	chmod 774 $HOME_PATH/.config/scripts/wifistatus.sh 2>/dev/null
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/scripts/wifistatus.sh 2>/dev/null
	check "Copying wifi script"

	cp $FILES_PATH/panel/genmon-24.rc $HOME_PATH/.config/xfce4/panel/genmon-24.rc > /dev/null 2>&1
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/xfce4/panel/genmon-24.rc 2>/dev/null
	check "Configuring Wifi info in taskbar"

	cp $FILES_PATH/panel/genmon-35.rc $HOME_PATH/.config/xfce4/panel/genmon-35.rc > /dev/null 2>&1
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/xfce4/panel/genmon-35.rc 2>/dev/null
	check "Configuring RAM usage info"

	cp $FILES_PATH/scripts/ramstatus.sh $HOME_PATH/.config/scripts/ramstatus.sh > /dev/null 2>&1
	chmod 774 $HOME_PATH/.config/scripts/ramstatus.sh 2>/dev/null
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/scripts/ramstatus.sh 2>/dev/null
	check "Copying RAM usage script"

	cp $FILES_PATH/panel/genmon-37.rc $HOME_PATH/.config/xfce4/panel/genmon-37.rc > /dev/null 2>&1
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/xfce4/panel/genmon-37.rc 2>/dev/null
	check "Configuring CPU usage info"

	cp $FILES_PATH/scripts/cpustatus.sh $HOME_PATH/.config/scripts/cpustatus.sh > /dev/null 2>&1
	chmod 774 $HOME_PATH/.config/scripts/cpustatus.sh 2>/dev/null
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/scripts/cpustatus.sh 2>/dev/null
	check "Copying CPU usage script"

	cp $FILES_PATH/scripts/whichSystem /usr/local/bin/whichSystem > /dev/null 2>&1
	chmod +x /usr/local/bin/whichSystem 2>/dev/null
	check "Copying whichSystem script"

	cd $HOME_PATH/.config/scripts 2>/dev/null
	echo "#!/bin/bash" > user.sh 2>/dev/null
	echo "VAR=$USERNAME" >> user.sh 2>/dev/null
	echo "ICON=" >> user.sh 2>/dev/null
	echo 'echo -n ${ICON} ${VAR:0:1} | tr "[:lower:]" "[:upper:]"; echo -n ${VAR:1} " " | tr "[:upper:]" "[:lower:]"' >> user.sh 2>/dev/null
	chown $USERNAME:$USERNAME user.sh && chmod 774 user.sh 2>/dev/null
	check "Configuring user script in taskbar"

	cp $FILES_PATH/panel/genmon-29.rc $HOME_PATH/.config/xfce4/panel/genmon-29.rc > /dev/null 2>&1
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/xfce4/panel/genmon-29.rc 2>/dev/null
	check "Configuring user in taskbar"

	cp $FILES_PATH/scripts/targetstatus.sh $HOME_PATH/.config/scripts/targetstatus.sh > /dev/null 2>&1
	chmod 774 $HOME_PATH/.config/scripts/targetstatus.sh 2>/dev/null
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/scripts/targetstatus.sh 2>/dev/null
	touch $HOME_PATH/.config/scripts/.targets && chown $USERNAME:$USERNAME $HOME_PATH/.config/scripts/.targets 2>/dev/null
	check "Copying targets script"

	cp $FILES_PATH/panel/genmon-31.rc $HOME_PATH/.config/xfce4/panel/genmon-31.rc > /dev/null 2>&1
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/xfce4/panel/genmon-31.rc 2>/dev/null
	check "Configuring Target info in taskbar"

	cp $FILES_PATH/panel/battery-19.rc $HOME_PATH/.config/xfce4/panel/battery-19.rc > /dev/null 2>&1
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/xfce4/panel/battery-19.rc 2>/dev/null
	check "Configuring battery icon in taskbar"

    # Start menu configuration
    info "Configuring start menu"
	cp $FILES_PATH/panel/whiskermenu-1.rc $HOME_PATH/.config/xfce4/panel/whiskermenu-1.rc > /dev/null 2>&1
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/xfce4/panel/whiskermenu-1.rc 2>/dev/null
	check "Configuring start menu options"

    # Default applications configuration
    info "Configuring default applications"
	cp $FILES_PATH/xfce4/helpers.rc $HOME_PATH/.config/xfce4/helpers.rc > /dev/null 2>&1
	chown $USERNAME:$USERNAME $HOME_PATH/.config/xfce4/helpers.rc 2>/dev/null
	check "Configuring default applications"
}
