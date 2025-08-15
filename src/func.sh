#!/bin/bash

# Regular Colors
Black='\033[0;30m'      # Black
Red='\033[0;31m'        # Red
Green='\033[0;32m'      # Green
Yellow='\033[0;33m'     # Yellow
Blue='\033[0;34m'       # Blue
Purple='\033[0;35m'     # Purple
Cyan='\033[0;36m'       # Cyan
White='\033[0;97m'      # White
Blink='\033[5m'         # Blink
Color_Off='\033[0m'     # Text Reset

# Light
LRed='\033[0;91m'       # Ligth Red
LGreen='\033[0;92m'     # Ligth Green
LYellow='\033[0;93m'    # Ligth Yellow
LBlue='\033[0;94m'      # Ligth Blue
LPurple='\033[0;95m'    # Light Purple
LCyan='\033[0;96m'      # Ligth Cyan
LWhite='\033[0;90m'     # Ligth White

# Dark
DGray='\033[2;37m'      # Dark Gray
DRed='\033[2;91m'       # Dark Red
DGreen='\033[2;92m'     # Dark Green
DYellow='\033[2;93m'    # Dark Yellow
DBlue='\033[2;94m'      # Dark Blue
DPurple='\033[2;95m'    # Dark Purple
DCyan='\033[2;96m'      # Dark Cyan
DWhite='\033[2;90m'     # Dark White

# Bold
BBlack='\033[1;30m'     # Bold Black
BRed='\033[1;31m'       # Bold Red
BGreen='\033[1;32m'     # Bold Green
BYellow='\033[1;33m'    # Bold Yellow
BBlue='\033[1;34m'      # Bold Blue
BPurple='\033[1;35m'    # Bold Purple
BCyan='\033[1;36m'      # Bold Cyan
BWhite='\033[1;37m'     # Bold White

# Italics
IBlack='\033[3;30m'     # Italic Black
IGray='\033[3;90m'      # Italic Gray
IRed='\033[3;31m'       # Italic Red
IGreen='\033[3;32m'     # Italic Green
IYellow='\033[3;33m'    # Italic Yellow
IBlue='\033[3;34m'      # Italic Blue
IPurple='\033[3;35m'    # Italic Purple
ICyan='\033[3;36m'      # Italic Cyan
IWhite='\033[3;37m'     # Italic White

# Underline
UBlack='\033[4;30m'     # Underline Black
URed='\033[4;31m'       # Underline Red
UGreen='\033[4;32m'     # Underline Green
UYellow='\033[4;33m'    # Underline Yellow
UBlue='\033[4;34m'      # Underline Blue
UPurple='\033[4;35m'    # Underline Purple
UCyan='\033[4;36m'      # Underline Cyan
UWhite='\033[4;37m'     # Underline White

# Background
On_Black='\033[40m'     # Background Black
On_Red='\033[41m'       # Background Red
On_Green='\033[42m'     # Background Green
On_Yellow='\033[43m'    # Background Yellow
On_Blue='\033[44m'      # Background Blue
On_Purple='\033[45m'    # Background Purple
On_Cyan='\033[46m'      # Background Cyan
On_White='\033[47m'     # Background White

trap ctrl_c INT

function ctrl_c(){
    echo -e "\n\n${Cyan}[${BYellow}⚠${Cyan}] ${BRed}Exiting the application...${Color_Off}"
    tput cnorm
    exit 1
}

### Help Panel
function helpPanel(){
    echo -e "\n${Cyan}[${BYellow}!${Cyan}]${BWhite} Usage:${Color_Off}"
    echo -e "\n\t${LGreen}./autoDeploy.sh ${LRed}[OPTION]${Color_Off}"
    echo -e "\n${BWhite}OPTIONS:${Color_Off}"
    echo -e "\t${Cyan}[${Red}-i, --install${Cyan}]${Purple} \tComplete installation of the customization layer.${Color_Off}"
    echo -e "\t\t${Yellow}terminal: ${Purple}\tInstallation of terminal and desktop customization only.${Color_Off}"
    echo -e "\t\t${Yellow}apps: ${Purple}\t\tInstallation of third-party programs only.${Color_Off}"
    echo -e "\t${Cyan}[${Red}-d, --delete${Cyan}]${Purple} \t\tRemove Desktop configuration and third-party application directories.${Color_Off}"
    echo -e "\t${Cyan}[${Red}-h, --help${Cyan}]${Purple} \t\tShow this help panel.${Color_Off}"
    echo -e "\n${BWhite}EXAMPLES:${Color_Off}"
    echo -e "\t${LWhite}Complete Installation (root)${Color_Off}${Green}\n\t# ./autoDeploy.sh ${Red}--install\n${Color_Off}"
    echo -e "\t${LWhite}Installation with terminal and desktop customization only (root)${Color_Off}${Green}\n\t# ./autoDeploy.sh ${Red}--install ${Yellow}terminal\n${Color_Off}"
    echo -e "\t${LWhite}Installation with third-party applications only (root)${Color_Off}${Green}\n\t# ./autoDeploy.sh ${Red}--install ${Yellow}apps\n${Color_Off}"
    echo -e "\t${LWhite}Remove desktop configuration and application directories${Color_Off}${Green}\n\t# ./autoDeploy.sh ${Red}-d\n${Color_Off}"
    tput cnorm; exit 1
}

### Banner
function banner(){
    echo -e "${BRed}"
    sleep 0.15 && echo -e "\t                        █████             █████                ████   ███ "
    sleep 0.15 && echo -e "\t                       ░░███             ░░███                ░░███  ░░░  "
    sleep 0.15 && echo -e "\t   ██████   █████ ████ ███████    ██████  ░███ █████  ██████   ░███  ████ "
    sleep 0.15 && echo -e "\t  ░░░░░███ ░░███ ░███ ░░░███░    ███░░███ ░███░░███  ░░░░░███  ░███ ░░███ "
    sleep 0.15 && echo -e "\t   ███████  ░███ ░███   ░███    ░███ ░███ ░██████░    ███████  ░███  ░███ "
    sleep 0.15 && echo -e "\t  ███░░███  ░███ ░███   ░███ ███░███ ░███ ░███░░███  ███░░███  ░███  ░███ "
    sleep 0.15 && echo -e "\t ░░████████ ░░████████  ░░█████ ░░██████  ████ █████░░████████ █████ █████"
    sleep 0.15 && echo -e "\t  ░░░░░░░░   ░░░░░░░░    ░░░░░   ░░░░░░  ░░░░ ░░░░░  ░░░░░░░░ ░░░░░ ░░░░░ "
    sleep 0.15 && echo -e "\t                                                                          "
    echo -e "${Color_Off}"
	tput civis
}

### Informative functions
function info(){
	echo -e "${Cyan}[${BYellow}!${Cyan}] ${BWhite}$1${Color_Off}"
}

function question(){
	input=""
	while [ "$input" == "" ]; do
		#echo -ne "${Cyan}[${BPurple}?${Cyan}] ${BWhite}$1: ${Color_Off}" && read input
		echo -e "${BBlue}┌─[${BWhite}$1${BBlue}]${Color_Off}"
		echo -en "${BBlue}└──╼${BGreen} " && read input
		echo -e "${Color_Off}"
	done
}

function yes_or_no(){
	#echo -ne "${Cyan}[${BPurple}?${Cyan}] ${BWhite}$1 ${Cyan}(${BGreen}Y${BWhite}/${BRed}n${Cyan})${BWhite}: ${Color_Off}" && read input
	echo -e "${BBlue}┌─[${BWhite}$1 ${Cyan}(${BGreen}Y${BWhite}/${BRed}n${Cyan})${BBlue}]${Color_Off}"
	echo -en "${BBlue}└──╼${BGreen} " && read input
	echo -e "${Color_Off}"
	case "$input" in
		n|N) input=0;;
		*) input=1;;
	esac
}

function error(){
	echo -e "${Cyan}[${BRed}✖${Cyan}] ${BRed}Error - $1${Color_Off}"
	echo -e "[$(date +%T)] $1" 2>/dev/null >> $SCRIPT_PATH/error.log
}

function good(){
	echo -e "${Cyan}[${BGreen}✔${Cyan}] ${BGreen}Successful - $1${Color_Off}"
}

function check(){
	if [ $? -ne 0 ]; then 
		error "$1"
	else
		good "$1"
	fi
}

function section(){
	echo -e "\n${Cyan}[${BBlue}+${Cyan}] ${BBlue}$1${Color_Off}"
}

### Removing directories of applications downloaded from Github
function deleteApp(){
	validations
	info "Removing application directories."
	if [[ -d $PRIVESCLIN_PATH || -d $PRIVESCWIN_PATH || -d $OSINT_PATH || -d $UTILITIES_PATH || -d $WEB_PATH || -d $WIFI_PATH  || -d $WORDPRESS_PATH || -d $AD_PATH ]]; then
		rm -rf {$PRIVESCLIN_PATH,$PRIVESCWIN_PATH,$OSINT_PATH,$UTILITIES_PATH,$WEB_PATH,$WIFI_PATH,$WORDPRESS_PATH,$AD_PATH} 2>&1
		check "Directories removed."
	else
		error "No application directories installed."
	fi
	info "Removing Desktop configuration."
	rm -rf $HOME_PATH/.config/xfce4 2>/dev/null
	check "Removing desktop configuration."
	sleep 2
	tput cnorm && reboot
}

### Checking Internet connection
function checkInternet(){
	info "Checking DNS resolution"
	host www.google.com > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		error "In DNS resolution - could not resolve www.google.com"
		exit 1
	fi
}

function validations(){
### Validation of execution with root
	if [[ ! -d tools || ! -d files ]]; then
		echo -e "\n${Cyan}[${BYellow}!${Cyan}] ${BRed}Run this script from the autoDeploy folder to avoid errors${Color_Off}\n"
		exit 1
	fi
	rm -f $SCRIPT_PATH/error.log 2>/dev/null
	if [ "$EUID" -ne 0 ]; then
		error "This script must be run as root!\n"
		exit 1
	fi

### System data
	tput cnorm
	question "Username ($(ls /home | xargs | tr ' ' '|'))"
	USERNAME=$input
	HOME_PATH="/home/$USERNAME"
	tput civis
	if [ ! -d "$HOME_PATH" ]; then
		error "The user's home directory does not exist (/home/$USERNAME)"
		exit 1
	fi
}

### Main installation
function install(){
	echo -e "\n ${BYellow}⚠ Complete Installation.${Color_Off}\n"
	validations
    installUtils
	installPackages
	installGoTools
	customDesktop
	gitTools
	endInstall
}

function installDesktop(){
	echo -e "\n ${BYellow}⚠ Installation of the Terminal and Desktop customization layer.${Color_Off}\n"
	validations
    installUtils
	customDesktop
	endInstall
}

function installTools(){
	echo -e "\n ${BYellow}⚠ Installation of third-party applications.${Color_Off}\n"
	validations
    installUtils
	installPackages
	installGoTools
	gitTools
	endInstall
}

### End of script
function endInstall(){
	info "Updating updatedb"
	sudo updatedb > /dev/null 2>&1
	check "Running updatedb"
	section "INSTALLATION COMPLETED"
	tput cnorm
	info "You must restart the computer to complete the installation"
	yes_or_no "Do you want to do it now?"

	section "Happy Hacking! =)" && sleep 2
	if [ $input -eq 1 ]; then
		reboot
	else
		echo -e "\n ${BGreen}Installation completed. You need to restart your system manually.${Color_Off}\n"
		tput cnorm; exit 1
	fi
}