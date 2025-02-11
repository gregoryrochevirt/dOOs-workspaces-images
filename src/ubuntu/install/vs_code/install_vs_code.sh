#!/usr/bin/env bash
set -ex

# Install vsCode
ARCH=$(arch | sed 's/aarch64/arm64/g' | sed 's/x86_64/x64/g')
wget -q https://update.code.visualstudio.com/latest/linux-deb-${ARCH}/stable -O vs_code.deb
apt-get update
apt-get install -y ./vs_code.deb

# Install extentions
apt-get update \
rm -rf /var/lib/apt/list/* \
code --install-extension ms-azuretools.vscode-docker --no-sandbox --user-data-dir /home/kasm-user/.vscode/extensions/ \
code --install-extension ms-ceintl.vscode-language-pack-fr --no-sandbox --user-data-dir /home/kasm-user/.vscode/extensions/ \
code --install-extension ms-vscode-remote.remote-containers --no-sandbox --user-data-dir /home/kasm-user/.vscode/extensions/ \
code --install-extension ms-vscode-remote.remote-ssh --no-sandbox --user-data-dir /home/kasm-user/.vscode/extensions/ \
code --install-extension ms-vscode-remote.remote-ssh-edit --no-sandbox --user-data-dir /home/kasm-user/.vscode/extensions/ \
code --install-extension ms-vscode.remote-explorer --no-sandbox --user-data-dir /home/kasm-user/.vscode/extensions/ \
code --install-extension ms-vscode.remote-repositories --no-sandbox --user-data-dir /home/kasm-user/.vscode/extensions/ \
code --install-extension github.remotehub --no-sandbox --user-data-dir /home/kasm-user/.vscode/extensions/ \
code --install-extension mhutchie.git-graph --no-sandbox --user-data-dir /home/kasm-user/.vscode/extensions/ \
code --install-extension ms-vscode.live-server --no-sandbox --user-data-dir /home/kasm-user/.vscode/extensions/


# Desktop icon
mkdir -p /usr/share/icons/hicolor/apps
wget -O /usr/share/icons/hicolor/apps/vscode.svg https://kasm-static-content.s3.amazonaws.com/icons/vscode.svg
sed -i '/Icon=/c\Icon=/usr/share/icons/hicolor/apps/vscode.svg' /usr/share/applications/code.desktop
sed -i 's#/usr/share/code/code#/usr/share/code/code --no-sandbox##' /usr/share/applications/code.desktop
cp /usr/share/applications/code.desktop $HOME/Desktop
chmod +x $HOME/Desktop/code.desktop
chown 1000:1000 $HOME/Desktop/code.desktop
rm vs_code.deb

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