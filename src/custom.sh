#!/usr/bin/env bash

### Personalización de la terminal
function customTerminal(){
	section "COMENZANDO PERSONALIZACIÓN DEL SISTEMA"
	checkInternet
	info "Actualizando repositorios"
	apt update > /dev/null 2>&1

	info "Descargando fuente (Hack Nerd Font)"
	cd /usr/local/share/fonts/ 2>/dev/null
	wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/Hack.zip > /dev/null 2>&1
	check "Descargando la fuente - https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/Hack.zip"
	unzip Hack.zip > /dev/null 2>&1
	check "Instalando la fuente Hack Nerd Font"
	rm Hack.zip 2>/dev/null

	info "Configurando shell predeterminada"
	usermod --shell /usr/bin/zsh root > /dev/null 2>&1
	check "Aplicando shell predeterminada para root"
	usermod --shell /usr/bin/zsh $USERNAME > /dev/null 2>&1
	check "Aplicando shell predeterminada para $USERNAME"

	info "Instalando powerlevel10k"
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME_PATH/powerlevel10k > /dev/null 2>&1
	check "Clonando el repositorio de powerlevel10k"
	cp -r $HOME_PATH/powerlevel10k /root/ 2>/dev/null
	cp $FILES_PATH/.p10k.zsh $HOME_PATH/.p10k.zsh 2>/dev/null
	check "Al encontrar y colocar el $FILES_PATH/.p10k.zsh"
	ln -sf $HOME_PATH/.p10k.zsh /root/.p10k.zsh 2>/dev/null
	check "Agregando el p10k.zsh en root"

	info "Instalando lsd"
    if [ "$(uname -m)" = "x86_64" ]; then
        wget "https://github.com/lsd-rs/lsd/releases/download/v1.1.2/lsd-musl_1.1.2_amd64.deb" -O /tmp/lsd.deb > /dev/null 2>&1
    elif [ "$(uname -m)" = "aarch64" ]; then
        wget "https://github.com/lsd-rs/lsd/releases/download/v1.1.2/lsd-musl_1.1.2_arm64.deb" -O /tmp/lsd.deb > /dev/null 2>&1
    fi
	check "Descargando lsd"
	dpkg -i /tmp/lsd.deb > /dev/null 2>&1
	check "Instalación de lsd"

	info "Instalando bat"
    if [ "$(uname -m)" = "x86_64" ]; then
	    wget "https://github.com/sharkdp/bat/releases/download/v0.24.0/bat_0.24.0_amd64.deb" -O /tmp/bat.deb > /dev/null 2>&1
    elif [ "$(uname -m)" = "aarch64" ]; then
	    wget "https://github.com/sharkdp/bat/releases/download/v0.24.0/bat_0.24.0_arm64.deb" -O /tmp/bat.deb > /dev/null 2>&1
    fi
	check "Descargando bat"
	dpkg -i /tmp/bat.deb > /dev/null 2>&1
	check "Instalación de bat"

	info "Instalando comando fd"
	ln -s $(which fdfind) /usr/local/bin/fd > /dev/null 2>&1
	check "Configurar comando fd"

	cd

	info "Instalando FZF"
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf > /dev/null 2>&1
	check "Clonando el repositorio de FZF (root)"
	echo -e "y\ny\nn" | ~/.fzf/install > /dev/null 2>&1
	check "Instalar FZF (root)"
	git clone --depth 1 https://github.com/junegunn/fzf.git $HOME_PATH/.fzf > /dev/null 2>&1
	check "Clonando el repositorio de FZF ($USERNAME)"
	chown -R $USERNAME:$USERNAME $HOME_PATH/.fzf 2>/dev/null
	sudo -u $USERNAME $HOME_PATH/.fzf/install < <(echo -e "y\ny\nn") > /dev/null 2>&1
	check "Instalar FZF ($USERNAME)"

	info "Configurando rofi"
	mkdir $HOME_PATH/.config/rofi && cd $HOME_PATH/.config/rofi
	wget https://raw.githubusercontent.com/VaughnValle/blue-sky/master/nord.rasi -O /usr/share/rofi/themes/nord.rasi > /dev/null 2>&1
	check "Descargando tema para rofi"
	echo "rofi.theme: /usr/share/rofi/themes/nord.rasi" > config 2>/dev/null
	check "Configurando tema para rofi"
	chmod 644 config > /dev/null 2>&1
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/rofi 2>/dev/null
	check "Configurando rofi ($USERNAME)"
	cd
	if [ -d .config ]; then
		ln -sf $HOME_PATH/.config/rofi /root/.config/rofi 2>/dev/null
		check "Configurando rofi (root)"
	else
		mkdir .config && ln -sf $HOME_PATH/.config/rofi /root/.config/rofi 2>/dev/null
		check "Configurando rofi (root)"
	fi

	info "Configurando findex"
	wget https://github.com/mdgaziur/findex/releases/download/v0.8.1/findex-0.8.1-x86_64.tar.gz -O /tmp/findex-0.8.1-x86_64.tar.gz > /dev/null 2>&1
	tar -xzf /tmp/findex-0.8.1-x86_64.tar.gz -C /tmp/ > /dev/null 2>&1
	mv /tmp/findex-0.8.1-x86_64/findex /usr/bin 2>/dev/null
	chown root:$USERNAME /usr/bin/findex 2>/dev/null
	check "Configurando findex"

	info "Configurando escritorio"
	check "Descargando fondos kali"
    git clone https://github.com/owerdogan/wallpapers-for-kali /usr/share/backgrounds/wallpapers-for-kali > /dev/null 2>&1
	check "Configurando fondos"
	unlink /usr/share/desktop-base/kali-theme/login/background > /dev/null 2>&1
	ln -s /usr/share/backgrounds/wallpapers-for-kali/kali-red/red-kali-dark-16x9.png /usr/share/desktop-base/kali-theme/login/background > /dev/null 2>&1
	check "Configurando fondo de inicio de sesión"
	cp $FILES_PATH/xfce4/xfce4-desktop.xml $HOME_PATH/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml > /dev/null 2>&1
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml 2>/dev/null
	check "Configurando fondo de escritorio"
	cp $FILES_PATH/xfce4/xfce4-keyboard-shortcuts.xml $HOME_PATH/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml > /dev/null 2>&1
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml 2>/dev/null
	check "Configurando atajos de teclado"
	cp $FILES_PATH/xfce4/thunar.xml $HOME_PATH/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml > /dev/null 2>&1
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml 2>/dev/null
	check "Configurando ventanas"
	cp $FILES_PATH/xfce4/xfce4-panel.xml $HOME_PATH/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml > /dev/null 2>&1
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml 2>/dev/null
	check "Configurando barra de tarea"
	cp $FILES_PATH/xfce4/xfwm4.xml $HOME_PATH/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml > /dev/null 2>&1
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml 2>/dev/null
	check "Configurando paneles de trabajo"
	cp $FILES_PATH/xfce4/xfce4-power-manager.xml $HOME_PATH/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-power-manager.xml > /dev/null 2>&1
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-power-manager.xml 2>/dev/null
	check "Configurando administrador de energia"
	cd $FILES_PATH/xfce4 2>/dev/null
	tar -xJf Sweet-Rainbow.tar.xz && tar -xJf candy-icons.tar.xz > /dev/null 2>&1
	mkdir $HOME_PATH/.local/share/icons && mv $FILES_PATH/xfce4/Sweet-Rainbow $FILES_PATH/xfce4/candy-icons $HOME_PATH/.local/share/icons > /dev/null 2>&1
	chown -R $USERNAME:$USERNAME $HOME_PATH/.local/share/icons 2>/dev/null
	check  "Configurando iconos ($USERNAME)"
	mkdir -p /root/.local/share && ln -s $HOME_PATH/.local/share/icons /root/.local/share/icons 2>/dev/null
	check "Configurando iconos (root)"
	cp $FILES_PATH/xfce4/xsettings.xml $HOME_PATH/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml > /dev/null 2>&1
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml 2>/dev/null
	check "Configurando iconos en el sistema"
	gtk-update-icon-cache $HOME_PATH/.local/share/icons/Sweet-Rainbow > /dev/null 2>&1 && gtk-update-icon-cache $HOME_PATH/.local/share/icons/candy-icons > /dev/null 2>&1
	check "Actualizando iconos"
	cp $FILES_PATH/xfce4/xfwm4.xml $HOME_PATH/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml > /dev/null 2>&1
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml 2>/dev/null
	check "Configurando paneles de trabajo"
	mkdir $HOME_PATH/.config/scripts && chown -R $USERNAME:$USERNAME $HOME_PATH/.config/scripts/ 2>/dev/null
	check "Configurando directorio de scripts para la barra de tarea"
	cp $FILES_PATH/scripts/ethstatus.sh $HOME_PATH/.config/scripts/ethstatus.sh > /dev/null 2>&1
	chmod 774 $HOME_PATH/.config/scripts/ethstatus.sh 2>/dev/null
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/scripts/ethstatus.sh 2>/dev/null
	check "Copiando script eth"
	cp $FILES_PATH/panel/genmon-4.rc $HOME_PATH/.config/xfce4/panel/genmon-4.rc > /dev/null 2>&1
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/xfce4/panel/genmon-4.rc 2>/dev/null
	check "Configurando info red en barra de tarea"
	cp $FILES_PATH/scripts/vpnstatus.sh $HOME_PATH/.config/scripts/vpnstatus.sh > /dev/null 2>&1
	chmod 774 $HOME_PATH/.config/scripts/vpnstatus.sh 2>/dev/null
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/scripts/vpnstatus.sh 2>/dev/null
	check "Copiando script vpn"
	cp $FILES_PATH/panel/genmon-5.rc $HOME_PATH/.config/xfce4/panel/genmon-5.rc > /dev/null 2>&1
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/xfce4/panel/genmon-5.rc 2>/dev/null
	check "Configurando info VPN en barra de tarea"
	cp $FILES_PATH/scripts/wifistatus.sh $HOME_PATH/.config/scripts/wifistatus.sh > /dev/null 2>&1
	chmod 774 $HOME_PATH/.config/scripts/wifistatus.sh 2>/dev/null
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/scripts/wifistatus.sh 2>/dev/null
	check "Copiando script wifi"
	cp $FILES_PATH/panel/genmon-24.rc $HOME_PATH/.config/xfce4/panel/genmon-24.rc > /dev/null 2>&1
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/xfce4/panel/genmon-24.rc 2>/dev/null
	check "Configurando info Wifi en barra de tarea"
	cp $FILES_PATH/panel/genmon-35.rc $HOME_PATH/.config/xfce4/panel/genmon-35.rc > /dev/null 2>&1
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/xfce4/panel/genmon-35.rc 2>/dev/null
	check "Configurando info de uso de memoria ram"
	cp $FILES_PATH/scripts/ramstatus.sh $HOME_PATH/.config/scripts/ramstatus.sh > /dev/null 2>&1
	chmod 774 $HOME_PATH/.config/scripts/ramstatus.sh 2>/dev/null
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/scripts/ramstatus.sh 2>/dev/null
	check "Copiando script de uso de memoria ram"
	cp $FILES_PATH/panel/genmon-37.rc $HOME_PATH/.config/xfce4/panel/genmon-37.rc > /dev/null 2>&1
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/xfce4/panel/genmon-37.rc 2>/dev/null
	check "Configurando info de uso de cpu"
	cp $FILES_PATH/scripts/cpustatus.sh $HOME_PATH/.config/scripts/cpustatus.sh > /dev/null 2>&1
	chmod 774 $HOME_PATH/.config/scripts/cpustatus.sh 2>/dev/null
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/scripts/cpustatus.sh 2>/dev/null
	check "Copiando script de uso de cpu"
	cp $FILES_PATH/scripts/whichSystem /usr/local/bin/whichSystem > /dev/null 2>&1
	chmod +x /usr/local/bin/whichSystem 2>/dev/null
	check "Copiando script whichSystem"
	cd $HOME_PATH/.config/scripts 2>/dev/null
	echo "#!/bin/bash" > user.sh 2>/dev/null
	echo "VAR=$USERNAME" >> user.sh 2>/dev/null
	echo "ICON=(   )" >> user.sh 2>/dev/null
	echo 'ELEC=$(( $RANDOM % 4 ))' >> user.sh 2>/dev/null
	echo 'echo -n ${ICON[$ELEC]} ${VAR:0:1} | tr "[:lower:]" "[:upper:]"; echo ${VAR:1} | tr "[:upper:]" "[:lower:]"' >> user.sh 2>/dev/null
	chown $USERNAME:$USERNAME user.sh && chmod 774 user.sh 2>/dev/null
	check "Configurando script de usuario en barra de tarea"
	cp $FILES_PATH/panel/genmon-29.rc $HOME_PATH/.config/xfce4/panel/genmon-29.rc > /dev/null 2>&1
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/xfce4/panel/genmon-29.rc 2>/dev/null
	check "Configurando usuario en barra de tarea"
	cp $FILES_PATH/scripts/targetstatus.sh $HOME_PATH/.config/scripts/targetstatus.sh > /dev/null 2>&1
	chmod 774 $HOME_PATH/.config/scripts/targetstatus.sh 2>/dev/null
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/scripts/targetstatus.sh 2>/dev/null
	touch $HOME_PATH/.config/scripts/.targets && chown $USERNAME:$USERNAME $HOME_PATH/.config/scripts/.targets 2>/dev/null
	check "Copiando script targets"
	cp $FILES_PATH/panel/genmon-31.rc $HOME_PATH/.config/xfce4/panel/genmon-31.rc > /dev/null 2>&1
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/xfce4/panel/genmon-31.rc 2>/dev/null
	check "Configurando info Target en barra de tarea"
	cp $FILES_PATH/panel/battery-19.rc $HOME_PATH/.config/xfce4/panel/battery-19.rc > /dev/null 2>&1
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/xfce4/panel/battery-19.rc 2>/dev/null
	check "Configurando icono bateria en barra de tarea"
	cp $FILES_PATH/panel/whiskermenu-1.rc $HOME_PATH/.config/xfce4/panel/whiskermenu-1.rc > /dev/null 2>&1
	chown -R $USERNAME:$USERNAME $HOME_PATH/.config/xfce4/panel/whiskermenu-1.rc 2>/dev/null
	check "Configurando opciones en menu de inicio"
	cp $FILES_PATH/xfce4/helpers.rc $HOME_PATH/.config/xfce4/helpers.rc > /dev/null 2>&1
	chown $USERNAME:$USERNAME $HOME_PATH/.config/xfce4/helpers.rc 2>/dev/null
	check "Configurando aplicativos por default"

    info "Instalando Oh-My-Zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    info "Instalando Terminator"
    apt install terminator -y > /dev/null 2>&1

    info "Descargando dotfiles"
    git clone https://github.com/dkadev/dotfiles $HOME_PATH/.dotfiles
    info "Instalando stow"
    apt install stow -y > /dev/null 2>&1
    check "Aplicando dotfiles"
    cd $HOME_PATH/.dotfiles
    stow zsh
    stow oh-my-zsh
    stow terminator
}