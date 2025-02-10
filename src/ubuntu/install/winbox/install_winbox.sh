#!/usr/bin/env bash
set -ex

## https://github.com/edyatl/winbox4-install-helper/blob/master/winbox4_install.sh ##
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

# Step 0: Check if download URL is changed
if [ "$DOWNLOAD_URL" != "$NEW_DOWNLOAD_URL" ]; then
    echo "Download URL has changed from $DOWNLOAD_URL to $NEW_DOWNLOAD_URL. Updating..."
    DOWNLOAD_URL="$NEW_DOWNLOAD_URL"
fi

# Step 1: Download the official archive
echo "Downloading WinBox4 archive..."
wget "$DOWNLOAD_URL" -O WinBox_Linux.zip

# Step 2: Unpack archive to 'winbox4'
echo "Unpacking WinBox4 archive..."
unzip WinBox_Linux.zip -d winbox4
rm WinBox_Linux.zip

# Step 3: Move 'winbox4' to /opt/
echo "Moving WinBox4 to /opt/..."
mv winbox4 /opt/


# Step 4: Create symlink to /usr/local/bin (skip if already exists)
echo "Creating symlink for WinBox..."
ln -s "/opt/winbox4/WinBox" "$SYMLINK_PATH" || exit 1


# Step 5: Create desktop file
echo "Creating desktop entry for WinBox4..."
cat > "$DESKTOP_FILE_PATH" <<EOL
[Desktop Entry]
Type=Application
Name=WinBox4
Icon=/opt/winbox4/assets/img/winbox.png
Exec=/opt/winbox4/WinBox
Comment=Mikrotik WinBox GUI for Router Management
Categories=Network;System;
EOL


cp /usr/share/applications/winbox4.desktop $HOME/Desktop/
chmod +x $HOME/Desktop/winbox4.desktop
chown 1000:1000 $HOME/Desktop/winbox4.desktop

# Step 6: Notify about successful installation
echo "Installation completed successfully. WinBox4 has been installed."
echo "Now attempting to locate and migrate previous WinBox data..."


# Step 8: Notify about result
echo "WinBox4 is ready to use."



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