#!/usr/bin/env bash

### Installation of extra packages
function installPackages(){
	section "STARTING TO UPDATE REPOSITORIES"
	checkInternet
	info "Downloading other packages"
	apt install -y $PACKAGES_LIST > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		apt update > /dev/null 2>&1
		apt install -y $PACKAGES_LIST > /dev/null 2>&1
	fi
	apt --fix-broken install -y > /dev/null 2>&1
	check "Installing additional packages"
    ## Install pipx and git
    apt install pipx git -y > /dev/null 2>&1
    ## Install rust
    info "Installing Rust"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y > /dev/null 2>&1
	## Update packages
	info "Updating packages"
	apt update > /dev/null 2>&1
	check "Updating packages"
	## Remove obsolete packages
	info "Removing unused packages (apt autoremove)"
	apt autoremove -y > /dev/null 2>&1
	check "Removing unused packages"
}

### Installation of Golang tools
function installGoTools(){
	section "STARTING INSTALLATION OF GOLANG TOOLS"
	checkInternet

	## Installation of packages with go
	for ap in $(cat $GO_TOOLS_LIST); do
		info "Installing $(echo $ap | cut -d ':' -f 1)"
		go install $(echo $ap | cut -d ':' -f 2) > /dev/null 2>&1
		check "Installing $(echo $ap | cut -d ':' -f 1) (root)"
	done
}

### Installation of third-party applications in /opt/
function gitTools(){
	section "STARTING INSTALLATION OF THIRD-PARTY APPLICATIONS"
	checkInternet
	info "Configuring netcat 64bits"
	wget https://eternallybored.org/misc/netcat/netcat-win32-1.11.zip -O /tmp/netcat.zip > /dev/null 2>&1
	check "Downloading netcat"
	cd /tmp/ ; unzip /tmp/netcat.zip > /dev/null 2>&1
	check "Unzipping netcat"
	sudo cp /tmp/netcat-1.11/nc64.exe /usr/share/windows-resources/binaries/nc64.exe > /dev/null 2>&1
	check "Copying netcat to /usr/share/windows-resources/binaries"
	chmod 755 /usr/share/windows-resources/binaries/nc64.exe 2>/dev/null
	check "Assigning permissions to nc64.exe"
	### WORDLISTS
	## Unzip rockyou wordlist
    info "Unzipping rockyou wordlist"
    cd /usr/share/wordlists 2>/dev/null
    gunzip rockyou.txt.gz > /dev/null 2>&1
    check "Unzipping rockyou file in /usr/share/wordlist/"
    cd 2>/dev/null
	## fuzzdb
	info "Downloading fuzzdb wordlists"
	cd /usr/share 2>/dev/null
	git clone --depth 1 https://github.com/fuzzdb-project/fuzzdb > /dev/null 2>&1
	ln -s `pwd`/fuzzdb /usr/share/wordlists > /dev/null 2>&1
	check "Adding wordlist in /usr/share/wordlist/"
	## OneListForAll
	info "Downloading OneListForAll wordlists"
	cd /usr/share 2>/dev/null
	git clone --depth 1 https://github.com/six2dez/OneListForAll > /dev/null 2>&1
	ln -s `pwd`/OneListForAll /usr/share/wordlists > /dev/null 2>&1
	check "Adding wordlist in /usr/share/wordlist/"
	## Kerberos-Enum-userlists
	info "Downloading Kerberos-Username-Enumeration wordlists"
	cd /usr/share 2>/dev/null
	git clone https://github.com/attackdebris/kerberos_enum_userlists > /dev/null 2>&1
	ln -s `pwd`/kerberos_enum_userlists /usr/share/wordlists > /dev/null 2>&1
	check "Adding wordlist in /usr/share/wordlist/"
	## Others Wordlists
	info "Downloading other wordlists"
	cd /usr/share 2>/dev/null
	mkdir trickest; cd trickest; git clone https://github.com/trickest/wordlists > /dev/null 2>&1
	cd wordlists; mv inventory robots technologies technology-repositories.json ../ && rm -rf wordlists 2>&1
	ln -s /usr/share/trickest /usr/share/wordlists > /dev/null 2>&1
	check "Adding wordlist in /usr/share/wordlist/trickest"
	## WordPress Exploit Framework
	info "Installing WordPress Exploit Framework"
	cd /
	gem install wpxf > /dev/null 2>&1
	check "Adding WordPress Exploit Framework"


## Git clone with separate installation
	info "Application directories"
	mkdir {$PRIVESCLIN_PATH,$PRIVESCWIN_PATH,$OSINT_PATH,$UTILITIES_PATH,$WEB_PATH,$WIFI_PATH,$WORDPRESS_PATH,$AD_PATH} 2>/dev/null
	check "Creating directories"
	## GTFOBLookup
	info "Downloading GTFOBLookup"
	cd $UTILITIES_PATH 2>/dev/null
	git clone --depth 1 https://github.com/nccgroup/GTFOBLookup > /dev/null 2>&1
	cd GTFOBLookup 2>/dev/null
	pip install -r requirements.txt --break-system-packages > /dev/null 2>&1
	python3 gtfoblookup.py update > /dev/null 2>&1
	check "Adding GTFOBLookup"
	## brutemap
	info "Downloading brutemap"
	cd $WEB_PATH 2>/dev/null
	git clone --depth 1 https://github.com/brutemap-dev/brutemap > /dev/null 2>&1
	cd brutemap 2>/dev/null
	pip install -r requirements.txt --break-system-packages > /dev/null 2>&1
	check "Adding brutemap"
	## CWFF
	info "Downloading CWFF"
	cd $UTILITIES_PATH 2>/dev/null
	git clone --depth 1 https://github.com/D4Vinci/CWFF > /dev/null 2>&1
	cd CWFF 2>/dev/null
	pip install -r requirements.txt --break-system-packages > /dev/null 2>&1
	check "Adding CWFF"
	## Vulnx
	info "Downloading Vulnx"
	cd $WORDPRESS_PATH 2>/dev/null
	git clone --depth 1 https://github.com/anouarbensaad/vulnx > /dev/null 2>&1
	cd vulnx && ./install.sh > /dev/null 2>&1
	check "Adding Vulnx"
	## Drupwn
	info "Downloading Drupwn"
	cd $WEB_PATH 2>/dev/null
	git clone --depth 1 https://github.com/immunIT/drupwn > /dev/null 2>&1
	cd drupwn && pip install -r requirements.txt --break-system-packages > /dev/null 2>&1
	check "Adding Drupwn"
	## Typo3Scan
	info "Downloading Typo3Scan"
	cd $WEB_PATH 2>/dev/null
	git clone --depth 1 https://github.com/whoot/Typo3Scan.git > /dev/null 2>&1
	cd Typo3Scan && pip install -r requirements.txt --break-system-packages > /dev/null 2>&1
	check "Adding Typo3Scan"
	## Reverse Shell Generator
	info "Downloading Reverse Shell Generator"
	cd $UTILITIES_PATH 2>/dev/null
	git clone https://github.com/mthbernardes/rsg.git > /dev/null 2>&1
	cd rsg && ln -s $(pwd)/rsg /usr/local/bin > /dev/null 2>&1
	check "Adding Reverse Shell Generator"
	## Next Generation version of Enum4Linux
	#info "Downloading Enum4Linux-ng"
	#cd $UTILITIES_PATH 2>/dev/null
	#git clone https://github.com/cddmp/enum4linux-ng.git >/dev/null 2>&1
	#cd enum4linux-ng && pip install -r requirements.txt --break-system-packages >/dev/null 2>&1
	#ln -s $UTILITIES_PATH/enum4linux-ng/enum4linux-ng.py /usr/local/bin/enum4linux-ng  >/dev/null 2>&1
	#check "Adding Enum4Linux-ng"
	## ASN Lookup Tool and Traceroute Server
	info "Downloading asn"
	cd $UTILITIES_PATH 2>/dev/null
	git clone https://github.com/nitefood/asn >/dev/null 2>&1
	ln -sf $UTILITIES_PATH/asn/asn /usr/local/bin/asn >/dev/null 2>&1
	check "Adding asn"
	## PyShell
	info "Downloading PyShell"
	cd $WEB_PATH 2>/dev/null
	git clone https://github.com/JoelGMSec/PyShell >/dev/null 2>&1
	cd PyShell ; pip install -r requirements.txt --break-system-packages >/dev/null 2>&1
	check "Adding PyShell"
	## Ghauri
	info "Downloading ghauri"
	cd $UTILITIES_PATH 2>/dev/null
	git clone https://github.com/r0oth3x49/ghauri >/dev/null 2>&1
	cd ghauri ; pip install -r requirements.txt --break-system-packages >/dev/null 2>&1
	python3 setup.py install >/dev/null 2>&1
	check "Adding ghauri"
	## WhatWeb-Next-Generation
	#info "Downloading WhatWeb-Next-Generation"
	#cd $WEB_PATH 2>/dev/null
	#git clone https://github.com/urbanadventurer/WhatWeb &>/dev/null
	#cd WhatWeb; bundle install &>/dev/null
	#check "Adding WhatWeb-Next-Generation"
	## Nuclei-Fuzzing-Templates
	info "Downloading Nuclei-Fuzzing-Templates"
	cd /root/.local/nuclei-templates/ 2>/dev/null
	git clone https://github.com/projectdiscovery/fuzzing-templates > /dev/null 2>&1
	check "Adding Nuclei-Fuzzing-Templates application"
	## MobSF
	#info "Downloading MobSF"
	#git clone https://github.com/MobSF/Mobile-Security-Framework-MobSF.git > /dev/null 2>&1
	#cd Mobile-Security-Framework-MobSF; ./setup.sh > /dev/null 2>&1
	#check "Adding MobFS application"
	## BloodHound.py
	info "Downloading BloodHound.py"
	cd $AD_PATH 2>/dev/null
	git clone https://github.com/fox-it/BloodHound.py >/dev/null 2>&1
	cd BloodHound.py && python3 setup.py install >/dev/null 2>&1
	check "Adding BloodHound.py"
	## wwwtree.py
	info "Downloading wwwtree"
	cd /tmp 2>/dev/null
	git clone https://github.com/t3l3machus/wwwtree > /dev/null 2>&1
	cd wwwtree && cp wwwtree.py /usr/local/bin/wwwtree 2>/dev/null
	check "Adding wwwtree"
	## ligolo-ng
	info "Downloading ligolo-ng"
	cd $UTILITIES_PATH 2>/dev/null
	git clone https://github.com/nicocha30/ligolo-ng >/dev/null 2>&1
	cd ligolo-ng
	go build -o bin/ligolo-agent cmd/agent/main.go >/dev/null 2>&1
	go build -o bin/ligolo-proxy cmd/proxy/main.go >/dev/null 2>&1
	GOOS=windows go build -o bin/ligolo-agent.exe cmd/agent/main.go >/dev/null 2>&1
	GOOS=windows go build -o bin/ligolo-proxy.exe cmd/proxy/main.go >/dev/null 2>&1
	mv $UTILITIES_PATH/ligolo-ng/bin/ligolo-proxy /usr/local/bin > /dev/null 2>&1
	check "Adding ligolo-ng"
	## wifi_db
	info "Installing wifi_db"
	cd $WIFI_PATH && git clone https://github.com/r4ulcl/wifi_db > /dev/null 2>&1
	cd wifi_db && pip3 install -r requirements.txt --break-system-packages > /dev/null 2>&1
	check "Adding wifi_db"
	## UploadBypass
	info "Installing Upload_Bypass"
	cd $WEB_PATH && wget https://github.com/sAjibuu/Upload_Bypass/releases/download/v2.0.8-offical/Upload_Bypass_v2.0.8-offical.zip > /dev/null 2>&1
	unzip Upload_Bypass_v2.0.8-offical.zip > /dev/null 2>&1
	rm Upload_Bypass_v2.0.8-offical.zip 2>/dev/null
	check "Adding Upload_Bypass"
	## Decodify
	info "Installing Decodify"
	cd /tmp && git clone https://github.com/s0md3v/Decodify >/dev/null 2>&1
	cd Decodify && chmod +x dcode 2>/dev/null
	mv dcode /usr/local/bin 2>/dev/null
	check "Adding dcode"
	## KillCast
	info "Installing KillCast"
	cd /tmp && git clone https://github.com/thewhiteh4t/killcast >/dev/null 2>&1
	cd killcast && chmod +x killcast.py 2>/dev/null
	mv killcast.py /usr/local/bin/killcast 2>/dev/null
	check "Adding killCast"

	## Eternalblue-Doublepulsar-Metasploit
	info "Downloading Eternalblue-Doublepulsar module for Metasploit"
	cd $UTILITIES_PATH 2>/dev/null
	git clone https://github.com/ElevenPaths/Eternalblue-Doublepulsar-Metasploit >/dev/null 2>&1
	cd Eternalblue-Doublepulsar-Metasploit 2>/dev/null
	perl -pi -e "s[/root/Eternalblue-Doublepulsar-Metasploit/deps/][/opt/Utilities/Eternalblue-Doublepulsar-Metasploit/deps/]g" eternalblue_doublepulsar.rb
	cp eternalblue_doublepulsar.rb /usr/share/metasploit-framework/modules/exploits/windows/smb > /dev/null 2>&1
	mkdir -p /root/.wine/drive_c/ > /dev/null 2>&1
	check "Adding Eternalblue-Doublepulsar module in Metasploit"



## Download using wget
	## psPY
	info "Downloading pspy"
	cd $PRIVESCLIN_PATH 2>/dev/null
	mkdir pspy > /dev/null 2>&1
	cd pspy 2>/dev/null
	wget https://github.com/DominicBreuker/pspy/releases/latest/download/pspy32 > /dev/null 2>&1
	check "Adding pspy32"
	wget https://github.com/DominicBreuker/pspy/releases/latest/download/pspy64 > /dev/null 2>&1
	check "Adding pspy64"
	## Unix-Privesc-Check-PentestMonkey
	info "Downloading unix-privesc-check"
	cd $PRIVESCLIN_PATH 2>/dev/null
	wget http://pentestmonkey.net/tools/unix-privesc-check/unix-privesc-check-1.4.tar.gz > /dev/null 2>&1
	tar -xzf unix-privesc-check-1.4.tar.gz && rm unix-privesc-check-1.4.tar.gz > /dev/null 2>&1
	check "Adding unix-privesc-check"
	## Pandoc
	info "Downloading pandoc"
	wget "https://github.com/jgm/pandoc/releases/download/2.19.2/pandoc-2.19.2-1-amd64.deb" -O /tmp/pandoc-2.19.2-1-amd64.deb > /dev/null 2>&1
	dpkg -i /tmp/pandoc-2.19.2-1-amd64.deb > /dev/null 2>&1
	check "Adding pandoc"
	## Eisvogel
	info "Downloading Eisvogel"
	cd /tmp && wget "https://github.com/Wandmalfarbe/pandoc-latex-template/releases/download/v2.1.0/Eisvogel-2.1.0.zip" > /dev/null 2>&1
	echo -e "A" | unzip Eisvogel-2.1.0.zip > /dev/null 2>&1
	mkdir -p /root/.local/share/pandoc/templates > /dev/null 2>&1
	check "Creating Eisvogel directory"
	mv /tmp/eisvogel.latex /root/.local/share/pandoc/templates > /dev/null 2>&1
	check "Adding Eisvogel"
	## duf
	info "Downloading duf"
	wget "https://github.com/muesli/duf/releases/latest/download/duf_0.8.1_linux_amd64.deb" -O /tmp/duf_0.8.1_linux_amd64.deb > /dev/null 2>&1
	dpkg -i /tmp/duf_0.8.1_linux_amd64.deb > /dev/null 2>&1
	check "Adding duf"
	## md2pdf
	info "Downloading md2pdf"
	cd /tmp && wget https://raw.githubusercontent.com/m4lal0/md2pdf/main/md2pdf.sh > /dev/null 2>&1
	mv /tmp/md2pdf.sh /usr/local/bin/md2pdf && chmod +x /usr/local/bin/md2pdf > /dev/null 2>&1
	check "Adding md2pdf"
	## RPCRecon
	info "Downloading RPCRecon"
	cd /tmp && wget https://raw.githubusercontent.com/m4lal0/RPCrecon/main/rpcrecon.sh -O /tmp/rpcrecon > /dev/null 2>&1
	chmod +x /tmp/rpcrecon && mv /tmp/rpcrecon /usr/local/bin/rpcrecon > /dev/null 2>&1
	check "Adding RPCRecon"
	## RustScan
	info "Downloading RustScan"
	wget "https://github.com/RustScan/RustScan/releases/download/2.0.1/rustscan_2.0.1_amd64.deb" -O /tmp/rustscan_2.0.1_amd64.deb > /dev/null 2>&1
	dpkg -i /tmp/rustscan_2.0.1_amd64.deb > /dev/null 2>&1
	check "Adding RustScan"
	## tempomail
	info "Downloading tempomail"
	cd /tmp/ 2>/dev/null
	wget https://github.com/kavishgr/tempomail/releases/latest/download/linux-amd64-tempomail.tgz > /dev/null 2>&1
	tar -xf linux-amd64-tempomail.tgz > /dev/null 2>&1
	mv tempomail /usr/local/bin/ > /dev/null 2>&1
	check "Adding tempomail"
	## ABE (Android-Backup-Extractor)
	info "Downloading Android-Backup-Extractor"
	mkdir $UTILITIES_PATH/Android-Backup-Extractor && wget "https://github.com/nelenkov/android-backup-extractor/releases/download/master-20221109063121-8fdfc5e/abe.jar" -O $UTILITIES_PATH/Android-Backup-Extractor/abe.jar > /dev/null 2>&1
	check "Adding Android-Backup-Extractor"
	## Venom
	info "Downloading venom"
	curl https://github.com/ovh/venom/releases/download/v1.1.0/venom.linux-amd64 -L -o /usr/local/bin/venom > /dev/null 2>&1
	chmod +x /usr/local/bin/venom
	check "Adding venom"
	## CORS
	info "Downloading CORS"
	mkdir $WEB_PATH/CORS &&	wget https://raw.githubusercontent.com/gwen001/pentest-tools/master/cors.py -O $WEB_PATH/CORS/cors.py > /dev/null 2>&1
	check "Adding cors.py"
	## Rustcat
	info "Downloading rustcat"
	wget "https://github.com/robiot/rustcat/releases/latest/download/rcat-v3.0.0-linux-x86_64.deb" -O /tmp/rcat-v3.0.0-linux-x86_64.deb > /dev/null 2>&1
	cd /tmp && sudo apt install ./rcat-v3.0.0-linux-x86_64.deb  > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		apt --fix-broken install -y > /dev/null 2>&1
		sudo apt install ./rcat-v3.0.0-linux-x86_64.deb > /dev/null 2>&1
	fi
	check "Adding rustcat"
	## BloodHound
	info "Downloading BloodHound"
	cd $AD_PATH 2>/dev/null
	wget https://github.com/BloodHoundAD/BloodHound/releases/download/4.0.3/BloodHound-linux-x64.zip > /dev/null 2>&1
	unzip BloodHound-linux-x64.zip > /dev/null 2>&1
	rm BloodHound-linux-x64.zip > /dev/null 2>&1
	mv BloodHound-linux-x64 BloodHound 2>/dev/null
	check "Adding BloodHound 4.0.3"
	## Kill-Port
	info "Downloading KillPort"
	cd /tmp && wget https://github.com/jkfran/killport/releases/latest/download/killport-x86_64-linux-gnu.tar.gz > /dev/null 2>&1
	tar -xzf killport-x86_64-linux-gnu.tar.gz > /dev/null 2>&1
	mv killport /usr/local/bin
	check "Adding KillPort"
	## PHP_Reverse_Shell
	info "Downloading php_reverse_shell.php"
	wget https://raw.githubusercontent.com/ivan-sincek/php-reverse-shell/master/src/reverse/php_reverse_shell.php -O /usr/share/webshells/php/php_reverse_shell.php > /dev/null 2>&1
	check "Adding php_reverse_shell.php"
	## Rubeus.exe
	info "Downloading Rubeus.exe"
	cd $AD_PATH && mkdir Rubeus 2>/dev/null
	wget https://github.com/r3motecontrol/Ghostpack-CompiledBinaries/raw/master/Rubeus.exe -O $AD_PATH/Rubeus/Rubeus.exe > /dev/null 2>&1
	check "Adding Rubeus.exe"
	## SharpHound
	info "Downloading SharpHound.ps1"
	cd $AD_PATH && mkdir SharpHound 2>/dev/null
	wget https://raw.githubusercontent.com/puckiestyle/powershell/master/SharpHound.ps1 -O $AD_PATH/SharpHound/SharpHound.ps1 > /dev/null 2>&1
	check "Adding SharpHound.ps1"
	## SafetyKatz.exe
	info "Downloading SafetyKatz.exe"
	cd $AD_PATH && mkdir SafetyKatz 2>/dev/null
	wget https://github.com/r3motecontrol/Ghostpack-CompiledBinaries/raw/master/SafetyKatz.exe -O $AD_PATH/SafetyKatz/SafetyKatz.exe > /dev/null 2>&1
	check "Adding SafetyKatz.exe"
	## JuicyPotatoNG
	info "Downloading JuicyPotatoNG"
	cd $PRIVESCWIN_PATH && mkdir JuicyPotato 2>/dev/null
	wget https://github.com/antonioCoco/JuicyPotatoNG/releases/latest/download/JuicyPotatoNG.zip -O $PRIVESCWIN_PATH/JuicyPotato/JuicyPotatoNG.zip > /dev/null 2>&1
	cd $PRIVESCWIN_PATH/JuicyPotato/ && unzip JuicyPotatoNG.zip > /dev/null 2>&1
	rm -f $PRIVESCWIN_PATH/JuicyPotato/JuicyPotatoNG.zip > /dev/null 2>&1
	check "Adding JuicyPotatoNG"
	## JuicyPotato.exe
	info "Downloading JuicyPotato.exe"
	wget https://github.com/ohpe/juicy-potato/releases/latest/download/JuicyPotato.exe -O $PRIVESCWIN_PATH/JuicyPotato/JuicyPotato.exe > /dev/null 2>&1
	check "Adding JuicyPotato.exe"
	## Churrasco.exe
	info "Downloading churrasco.exe"
	cd $PRIVESCWIN_PATH && mkdir churrasco 2>/dev/null
	wget https://github.com/Re4son/Churrasco/raw/master/churrasco.exe -O $PRIVESCWIN_PATH/churrasco/churrasco.exe > /dev/null 2>&1
	check "Adding churrasco.exe"
	## PrintSpoofer.exe
	info "Downloading PrintSpoofer.exe"
	cd $PRIVESCWIN_PATH && mkdir PrintSpoofer 2>/dev/null
	wget https://github.com/k4sth4/PrintSpoofer/raw/main/PrintSpoofer.exe -O $PRIVESCWIN_PATH/PrintSpoofer/PrintSpoofer.exe > /dev/null 2>&1
	wget https://github.com/itm4n/PrintSpoofer/releases/latest/download/PrintSpoofer64.exe -O $PRIVESCWIN_PATH/PrintSpoofer/PrintSpoofer64.exe > /dev/null 2>&1
	check "Adding PrintSpoofer.exe"
	## WinPEAS.exe
	info "Downloading winPEAS.exe"
	cd $PRIVESCWIN_PATH && mkdir winPEAS 2>/dev/null
	wget https://github.com/carlospolop/PEASS-ng/releases/latest/download/winPEASx64.exe -O $PRIVESCWIN_PATH/winPEAS/winPEASx64.exe > /dev/null 2>&1
	wget https://github.com/carlospolop/PEASS-ng/releases/latest/download/winPEASx86.exe -O $PRIVESCWIN_PATH/winPEAS/winPEASx86.exe > /dev/null 2>&1
	wget https://github.com/carlospolop/PEASS-ng/releases/latest/download/winPEASany.exe -O $PRIVESCWIN_PATH/winPEAS/winPEASany.exe > /dev/null 2>&1
	## LinPEAS
	info "Downloading LinPEAS"
	cd $PRIVESCLIN_PATH && mkdir linpeas 2>/dev/null
	wget https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh -O $PRIVESCLIN_PATH/linpeas/linpeas.sh > /dev/null 2>&1
	check "Adding LinPEAS"
	## Arachni
	info "Downloading Arachni"
	cd $WEB_PATH 2>/dev/null
	wget https://github.com/Arachni/arachni/releases/download/v1.6.1.3/arachni-1.6.1.3-0.6.1.1-linux-x86_64.tar.gz > /dev/null 2>&1
	tar -xzf arachni-1.6.1.3-0.6.1.1-linux-x86_64.tar.gz > /dev/null 2>&1
	rm -rf arachni-1.6.1.3-0.6.1.1-linux-x86_64.tar.gz > /dev/null 2>&1
	check "Adding Arachni"
	## CAPA
	info "Downloading CAPA"
	wget https://github.com/mandiant/capa/releases/download/v7.0.1/capa-v7.0.1-linux.zip -O /tmp/capa-v7.0.1-linux.zip > /dev/null 2>&1
	cd /tmp && unzip /tmp/capa-v7.0.1-linux.zip > /dev/null 2>&1
	mv /tmp/capa /usr/local/bin
	check "Adding CAPA"
	## IPATool
	info "Downloading IPAtool"
	wget https://github.com/majd/ipatool/releases/download/v2.1.4/ipatool-2.1.4-linux-amd64.tar.gz -O /tmp/ipatool-2.1.4-linux-amd64.tar.gz > /dev/null 2>&1
	cd /tmp && tar -xzf /tmp/ipatool-2.1.4-linux-amd64.tar.gz > /dev/null 2>&1
	chmod +x /tmp/bin/ipatool-2.1.4-linux-amd64
	mv /tmp/bin/ipatool-2.1.4-linux-amd64 /usr/local/bin/ipatool
	check "Adding IPAtool"
	## Govenom
	info "Downloading Govenom"
	wget https://github.com/arch3rPro/Govenom/releases/latest/download/darwin_amd64.tar.gz -O /tmp/darwin_amd64.tar.gz > /dev/null 2>&1
	cd /tmp && tar -xzf /tmp/darwin_amd64.tar.gz > /dev/null 2>&1
	mv /tmp/Govenom /usr/local/bin
	check "Installing Govenom"
	## NetExec
    info "Downloading NetExec"
    pipx install git+https://github.com/Pennyw0rth/NetExec
    check "Installing NetExec"
	## RunasCs
	info "Downloading RunasCs"
	cd $PRIVESCWIN_PATH && mkdir RunasCs 2>/dev/null
	wget https://github.com/antonioCoco/RunasCs/releases/download/v1.5/RunasCs.zip -O $PRIVESCWIN_PATH/RunasCs/RunasCs.zip > /dev/null 2>&1
	cd $PRIVESCWIN_PATH/RunasCs && unzip RunasCs.zip > /dev/null 2>&1
	rm -f $PRIVESCWIN_PATH/RunasCs/RunasCs.zip > /dev/null 2>&1
	check "Adding RunasCs"
	## Seatbelt.exe
	info "Downloading Seatbelt.exe"
	cd $PRIVESCWIN_PATH && mkdir Seatbelt 2>/dev/null
	wget https://github.com/r3motecontrol/Ghostpack-CompiledBinaries/raw/master/Seatbelt.exe -O $PRIVESCWIN_PATH/Seatbelt/Seatbelt.exe > /dev/null 2>&1
	check "Adding Seatbelt.exe"
	## NSE Scripts
	info "Downloading additional NSE Scripts"
	wget https://raw.githubusercontent.com/mmpx12/NSE-web-techno/master/web_techno.nse -O /usr/share/nmap/scripts/web_techno.nse > /dev/null 2>&1
	check "Adding web_techno.nse"
	wget https://raw.githubusercontent.com/GossiTheDog/scanning/main/http-vuln-exchange.nse -O /usr/share/nmap/scripts/http-vuln-exchange.nse > /dev/null 2>&1
	check "Adding http-vuln-exchange.nse"
	wget https://raw.githubusercontent.com/s4n7h0/NSE/master/http-lfi.nse -O /usr/share/nmap/scripts/http-lfi.nse > /dev/null 2>&1
	check "Adding http-lfi.nse"
	wget https://raw.githubusercontent.com/psc4re/NSE-scripts/master/CVE-2021-21972.nse -O /usr/share/nmap/scripts/cve-2021-21972.nse > /dev/null 2>&1
	check "Adding CVE-2021-21972.nse"
	wget https://raw.githubusercontent.com/psc4re/NSE-scripts/master/cve-2020-0796.nse -O /usr/share/nmap/scripts/smb3-smbghost.nse > /dev/null 2>&1
	check "Adding cve-2020-0796.nse"
	wget https://raw.githubusercontent.com/psc4re/NSE-scripts/master/cve-2020-1350.nse -O /usr/share/nmap/scripts/cve-2020-1350.nse > /dev/null 2>&1
	check "Adding cve-2020-1350.nse"
	wget https://raw.githubusercontent.com/psc4re/NSE-scripts/master/proxyshell.nse -O /usr/share/nmap/scripts/proxyshell.nse > /dev/null 2>&1
	check "Adding proxyshell.nse"
	wget https://raw.githubusercontent.com/vulnersCom/nmap-vulners/master/http-vulners-regex.nse -O /usr/share/nmap/scripts/http-vulners-regex.nse > /dev/null 2>&1
	check "Adding http-vulners-regex.nse"
	wget https://raw.githubusercontent.com/vulnersCom/nmap-vulners/master/http-vulners-regex.json -O /usr/share/nmap/nselib/data/http-vulners-regex.json > /dev/null 2>&1
	check "Adding http-vulners-regex.json"
	wget https://raw.githubusercontent.com/vulnersCom/nmap-vulners/master/http-vulners-paths.txt -O /usr/share/nmap/nselib/data/http-vulners-paths.txt > /dev/null 2>&1
	check "Adding http-vulners-paths.txt"
	wget https://raw.githubusercontent.com/hackertarget/nmap-nse-scripts/master/http-wordpress-info.nse -O /usr/share/nmap/scripts/http-wordpress-info.nse > /dev/null 2>&1
	check "Adding http-wordpress-info.nse"
	wget https://raw.githubusercontent.com/hackertarget/nmap-nse-scripts/master/wp-themes.lst -O /usr/share/nmap/nselib/data/wp-themes.lst > /dev/null 2>&1
	check "Adding wp-themes.lst"
	wget https://raw.githubusercontent.com/hackertarget/nmap-nse-scripts/master/wp-plugins.lst -O /usr/share/nmap/nselib/data/wp-plugins.lst > /dev/null 2>&1
	check "Adding wp-plugins.lst"
	wget https://svn.nmap.org/nmap/scripts/clamav-exec.nse -O /usr/share/nmap/scripts/clamav-exec.nse >/dev/null 2>&1
	check "Adding clamav-exec.nse"
	wget https://raw.githubusercontent.com/giterlizzi/nmap-log4shell/main/log4shell.nse -O /usr/share/nmap/scripts/log4shell.nse > /dev/null 2>&1
	check "Adding log4shell.nse"
	wget https://raw.githubusercontent.com/claroty/CVE2020-0796/master/nse_script/smb2-capabilities_patched.nse -O /usr/share/nmap/smb2-capabilities_patched.nse >/dev/null 2>&1
	check "Adding smb2-capabilities_patched.nse"
	wget https://raw.githubusercontent.com/GossiTheDog/scanning/main/http-vuln-exchange-proxyshell.nse -O /usr/share/nmap/scripts/http-vuln-exchange-proxyshell.nse >/dev/null 2>&1
	check "Adding http-vuln-exchange-proxyshell.nse"
	wget https://raw.githubusercontent.com/CronUp/Vulnerabilidades/main/proxynotshell_checker.nse -O /usr/share/nmap/scripts/proxynotshell_checker.nse >/dev/null 2>&1
	check "Adding proxynotshell_checker.nse"
	wget https://raw.githubusercontent.com/Diverto/nse-exchange/main/http-vuln-cve2022-41082.nse -O /usr/share/nmap/scripts/http-vuln-cve2022-41082.nse >/dev/null 2>&1
	check "Adding http-vuln-cve2022-41082.nse"
	wget https://raw.githubusercontent.com/RootUp/PersonalStuff/master/http-vuln-cve-2021-41773.nse -O /usr/share/nmap/scripts/http-vuln-cve-2021-41773.nse >/dev/null 2>&1
	check "Adding http-vuln-cve-2021-41773.nse"
	## Vulscan
	info "Downloading Vulscan NSE"
	cd $UTILITIES_PATH 2>/dev/null
	git clone https://github.com/scipag/vulscan scipag_vulscan > /dev/null 2>&1
	ln -s `pwd`/scipag_vulscan /usr/share/nmap/scripts/vulscan > /dev/null 2>&1
	check "Adding Vulscan NSE"
	nmap --script-updatedb > /dev/null 2>&1
	check "Updating additional NSE scripts"

## Download other tools from GitHub without installation
	for gitap in $(cat $GIT_TOOLS_LIST); do
		url=$(echo $gitap | cut -d '|' -f2)
		dir=$(echo $gitap | cut -d '|' -f1)
		name=$(echo $url | tr '/' ' ' | cut -d ' ' -f5)
		cd $GIT_TOOLS_PATH/$dir 2>/dev/null
		info "Downloading $name"
		git clone --depth 1 $url > /dev/null 2>&1
		check "Adding the application $name"
	done
}