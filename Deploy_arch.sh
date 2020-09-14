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
         6 "SDDM Theme"
         7 "Loginizer")

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
            
          7)
            echo "You chose Option 6"
            wget https://github.com/juhaku/loginized/releases/download/1.4.0/loginized-1.4.0.pacman
            sudo pacman -S glib2 xdg-utils
            sudo pacman -Udd loginized-1.4.0.pacman 
            ;;
            
          8)
            echo "You chose Option 6"
            wget https://dllb2.pling.com/api/files/download/j/eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6IjE1NTYxOTA4ODYiLCJ1IjpudWxsLCJsdCI6ImRvd25sb2FkIiwicyI6IjAzZDMwNGZiYzdjYzc5YmZjN2YyNGM3MTUxODUyYTQ5OGI1ZGJjNjc2N2EwMGU5MGU4YTBhNjA2ODc0NzFhMmRkNWUyMjg2OGEwOWE2OGUyZmNmZmU2NjJmNjU2YzRiYjc1MzRiZWFhOGQ1ZDQ3MTMyYWIwZGJlNjBiYmNiNGExIiwidCI6MTYwMDEyNzgzNywic3RmcCI6IjAwODdlNjJkODVlYjkyM2RjM2RhYjNlNzYyNTBkOWJlIiwic3RpcCI6IjEyMC4xNTIuMTMyLjI0NSJ9.0CPwGTUb2kXhDFqkiXqd3pPaCSB54dbn_LLbTV5Ysx8/sddm-zune.tar.gz
            pacman -S qt5-quickcontrols2 qt5-graphicaleffects qt5-svg
            sudo tar -xzvf sddm-zune.tar.gz -C /usr/share/sddm/themes
            sddm-greeter --test-mode --theme /usr/share/sddm/themes/zune
            
            ;;
esac














