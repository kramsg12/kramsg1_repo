sudo pacman -Sy
sudo pacman -S --noconfirm wget dialog  

#!/bin/bash

HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=4
BACKTITLE="Backtitle here"
TITLE="Os Deployment Tools"
MENU="Choose one of the following options:"

OPTIONS=(1 "Arch Pc - GPT Systemd"
         2 "Arch Pc - GPT Systemd Full Disk Encription"
         3 "Update Pacman.conf File"
         4 "Custom desktop theme"
         5 "Install Arch SDDM"
         6 "SDDM Theme)

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            echo "You chose Option 1"
            curl -sL https://raw.githubusercontent.com/kramsg12/kramsg1_repo/master/ArchInstall.sh | bash
            ;;
        2)
            echo "You chose Option 2"
            

            ;;
        3)
            echo "You chose Option 3"
            wget https://raw.githubusercontent.com/kramsg12/kramsg1_repo/master/pacman.conf
            sudo mv -f pacman.conf /etc/pacman.conf
            sudo pacman -Sy
            ;;
            
         4)
            echo "You chose Option 4"
            curl -sL https://raw.githubusercontent.com/kramsg12/kramsg1_repo/master/desktop.sh | bash
            ;;
            
         5)
            echo "You chose Option 5"
            curl -sL https://raw.githubusercontent.com/kramsg12/kramsg1_repo/master/archinstallsddm.sh | bash
            ;;
            
         6)
            echo "You chose Option 6"
            wget https://raw.githubusercontent.com/kramsg12/kramsg1_repo/master/desktop/Inverse-dark.tar.gz
            ;;
esac



https://raw.githubusercontent.com/kramsg12/kramsg1_repo/master/desktop/Inverse-dark.tar.gz
















