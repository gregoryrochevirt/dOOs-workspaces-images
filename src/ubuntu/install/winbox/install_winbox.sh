#!/usr/bin/env bash
set -ex

## Base script :
## https://github.com/edyatl/winbox4-install-helper/blob/master/winbox4_install.sh ##
#
# Mikrotik WinBox4 Install Helper
# This script downloads and installs Mikrotik WinBox4, sets up a symlink, 
# creates a desktop entry, and migrates previous WinBox data.

# Function to print error message and exit
handle_error() {
    echo "An error occurred during the installation process. Exiting."
    exit 1
}

HOME=/home/kasm-default-profile
DOWNLOAD_URL="https://download.mikrotik.com/routeros/winbox/4.0beta4/WinBox_Linux.zip"
SYMLINK_PATH="/usr/local/bin/winbox"
DESKTOP_FILE_PATH="/usr/share/applications/winbox4.desktop"
NEW_DOWNLOAD_URL=$(wget --https-only -qO- https://mikrotik.com/download | grep -oP '<li><a href="\K[^"]+(?=.*Linux)')

# Check if download URL is changed
if [ "$DOWNLOAD_URL" != "$NEW_DOWNLOAD_URL" ]; then
    echo "Download URL has changed from $DOWNLOAD_URL to $NEW_DOWNLOAD_URL. Updating..."
    DOWNLOAD_URL="$NEW_DOWNLOAD_URL"
fi

# Download the official archive
echo "Downloading WinBox4 archive..."
wget "$DOWNLOAD_URL" -O WinBox_Linux.zip

# Unpack archive to 'winbox4'
echo "Unpacking WinBox4 archive..."
unzip WinBox_Linux.zip -d winbox4
rm WinBox_Linux.zip

# Move 'winbox4' to /opt/
echo "Moving WinBox4 to /opt/..."
mv winbox4 /opt/


# Create symlink to /usr/local/bin (skip if already exists)
echo "Creating symlink for WinBox..."
ln -s "/opt/winbox4/WinBox" "$SYMLINK_PATH" || exit 1


# Create desktop file
echo "Creating desktop entry for WinBox4..."
cat > "$DESKTOP_FILE_PATH" <<EOL
[Desktop Entry]
Type=Application
Name=WinBox4
GenericName=Mikrotik RouterOS management
Icon=/opt/winbox4/assets/img/winbox.png
Exec=/opt/winbox4/WinBox
Comment=Graphical configuration tool for Mikrotik RouterOS.
Categories=Network;System;
StartupNotify=false
StartupWMClass=winbox
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
EOL


cp /usr/share/applications/winbox4.desktop $HOME/Desktop/
chmod +x $HOME/Desktop/winbox4.desktop
chown 1000:1000 $HOME/Desktop/winbox4.desktop

# Notify about successful installation
echo "Installation completed successfully. WinBox4 has been installed."
echo "Now attempting to locate and migrate previous WinBox data..."



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