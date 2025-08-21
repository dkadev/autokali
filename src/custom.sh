#!/usr/bin/env bash

### Desktop customization
function customDesktop(){
	section "STARTING SYSTEM CUSTOMIZATION"
	checkInternet
	info "Updating repositories"
	apt update > /dev/null 2>&1

    # Packages
    info "Installing necessary packages for customization"

    # Catapult
	info "Installing catapult"
    apt install -y gettext \
                 make \
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

    # Theme
    git clone https://github.com/rtlewis1/GTK.git > /dev/null 2>&1
    cd GTK
    git checkout Material-Black-Colors-Desktop > /dev/null 2>&1
    check "Cloning Material-Black-Colors-Desktop repository"
    mkdir -p $HOME_PATH/.themes && cp Material-Black-* $HOME_PATH/.themes -r > /dev/null 2>&1
    chown -R $USERNAME:$USERNAME $HOME_PATH/.themes 2>/dev/null
    check "Copying GTK theme ($USERNAME)"
    mkdir -p /root/.themes && cp Material-Black-* /root/.themes -r > /dev/null 2>&1
    chown -R root:root /root/.themes 2>/dev/null
    check "Copying GTK theme (root)"
    cd $HOME_PATH
    rm -rf GTK > /dev/null 2>&1

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

    # XFCE
	info "Configuring desktop"
    cp $FILES_PATH/xfce4/*.svg /usr/share/backgrounds/ > /dev/null 2>&1
	check "Configuring backgrounds"

    mv $FILES_PATH/xfce4/lightdm-gtk-greeter.conf /etc/lightdm/lightdm-gtk-greeter.conf > /dev/null 2>&1
    check "Configuring lightdm"

	cp $FILES_PATH/xfce4/xfce4-desktop.xml $HOME_PATH/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml > /dev/null 2>&1
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml 2>/dev/null
	check "Configuring xfce4 desktop"

	cp $FILES_PATH/xfce4/xfce4-keyboard-shortcuts.xml $HOME_PATH/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml > /dev/null 2>&1
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml 2>/dev/null
	check "Configuring xfce4 keyboard shortcuts"

	cp $FILES_PATH/xfce4/thunar.xml $HOME_PATH/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml > /dev/null 2>&1
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml 2>/dev/null
	check "Configuring Thunar file explorer"

	cp $FILES_PATH/xfce4/xfce4-panel.xml $HOME_PATH/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml > /dev/null 2>&1
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml 2>/dev/null
	check "Configuring xfce4 taskbar"

	cp $FILES_PATH/xfce4/xfwm4.xml $HOME_PATH/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml > /dev/null 2>&1
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml 2>/dev/null
	check "Configuring xfwm4 windows"

	cp $FILES_PATH/xfce4/xfce4-power-manager.xml $HOME_PATH/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-power-manager.xml > /dev/null 2>&1
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-power-manager.xml 2>/dev/null
	check "Configuring xfce4 power manager"

    cp $FILES_PATH/xfce4/xfce4-screensaver.xml $HOME_PATH/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-screensaver.xml > /dev/null 2>&1
    chown -R $USERNAME:$USERNAME $HOME_PATH/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-screensaver.xml 2>/dev/null
	check "Configuring xfce4 screensaver"

    cp $FILES_PATH/xfce4/xfce4-terminal.xml $HOME_PATH/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-terminal.xml > /dev/null 2>&1
    chown -R $USERNAME:$USERNAME $HOME_PATH/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-terminal.xml 2>/dev/null
	check "Configuring xfce4 terminal"

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
