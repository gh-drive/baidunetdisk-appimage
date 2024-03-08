#!/bin/bash
# This script is modified from https://github.com/ivan-hc/Chrome-appimage/raw/fe079615eb4a4960af6440fc5961a66c953b0e2d/chrome-builder.sh


APP=baidunetdisk
VER="${VERSION:-4.17.7}"
mkdir ./tmp
cd ./tmp
wget "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-$(uname -m).AppImage" -O appimagetool
chmod a+x ./appimagetool
wget "https://issuepcdn.baidupcs.com/issue/netdisk/LinuxGuanjia/${VER}/baidunetdisk_${VER}_amd64.deb"
ar x ./*.deb
tar xf ./data.tar.xz
mkdir $APP.AppDir
mv ./opt/baidunetdisk/* ./$APP.AppDir/
sed -i 's#/opt/baidunetdisk/baidunetdisk#baidunetdisk#g' ./$APP.AppDir/*.desktop

cat >> ./$APP.AppDir/AppRun << 'EOF'
#!/bin/sh
APP=baidunetdisk
HERE="$(dirname "$(readlink -f "${0}")")"
exec "${HERE}"/$APP --no-sandbox "$@"
EOF
chmod a+x ./$APP.AppDir/AppRun

echo "Create a tarball"
cd ./$APP.AppDir
tar cJvf ../$APP-$VER-x86_64.tar.xz .
cd ..
mv ./$APP-$VER-x86_64.tar.xz ..

# echo "Create an AppImage"
ARCH=x86_64 ./appimagetool -n --verbose ./$APP.AppDir ../$APP-$VER-x86_64.AppImage
cd ..
rm -rf ./tmp
