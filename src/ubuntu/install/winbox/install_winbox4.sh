#!/usr/bin/env bash
set -ex

# Install winbox
mkdir /usr/share/winbox
cd /usr/share/winbox
wget https://download.mikrotik.com/routeros/winbox/4.0beta17/WinBox_Linux.zip
unzip WinBox_Linux.zip
rm WinBox_Linux.zip

# Desktop icon
mkdir -p /usr/share/icons/hicolor/apps
wget -O /usr/share/icons/hicolor/apps/Winbox.png https://github.com/gregoryrochevirt/dOOs-kasm-registry/blob/1.1/workspaces/WinBox/Winbox.png
touch /usr/share/applications/WinBox.desktop
cat <<EOF > /usr/share/applications/WinBox.desktop
[Desktop Entry]
Name=WinBox
Comment=Graphical configuration tool for Mikrotik RouterOS.
GenericName=Mikrotik RouterOS management
Exec=/usr/share/winbox/WinBox %F
Icon=/usr/share/icons/hicolor/apps/Winbox.png
Type=Application
StartupNotify=false
StartupWMClass=WinBox
Categories=Network;RemoteAccess;
Actions=new-empty-window;
Keywords=Router;

[Desktop Action new-empty-window]
Name=New Empty Window
Name[de]=Neues leeres Fenster
Name[es]=Nueva ventana vacía
Name[fr]=Nouvelle fenêtre vide
Name[it]=Nuova finestra vuota
Name[ja]=新しい空のウィンドウ
Name[ko]=새 빈 창
Name[ru]=Новое пустое окно
Name[zh_CN]=新建空窗口
Name[zh_TW]=開新空視窗
EOF
#MimeType=application/x-code-workspace;
cp /usr/share/applications/WinBox.desktop $HOME/Desktop
chmod +x $HOME/Desktop/WinBox.desktop
chown 1000:1000 $HOME/Desktop/WinBox.desktop

# Conveniences for python development
apt-get update
apt-get install -y python3-setuptools \
                   python3-venv \
                   python3-virtualenv

# Cleanup for app layer
chown -R 1000:0 $HOME
find /usr/share/ -name "icon-theme.cache" -exec rm -f {} \;
if [ -z ${SKIP_CLEAN+x} ]; then
  apt-get autoclean
  rm -rf \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*
fi