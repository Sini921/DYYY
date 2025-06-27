#!/bin/bash

echo "删除旧版插件"
rm -rf packages
echo "已删除旧版插件，准备开始重新构建..."

echo "开始构建 rootless 版本..."
sed -i.bak 's/^Name: \(.*\)$/Name: \1(rootless)/' control
THEOS_PACKAGE_SCHEME=rootless make clean package
mv control.bak control
echo "rootless构建完成..."

echo "开始构建 roothide 版本..."
sed -i.bak 's/^Name: \(.*\)$/Name: \1(roothide)/' control
THEOS_PACKAGE_SCHEME=roothide make clean package
mv control.bak control
echo "roothide构建完成..."

echo "全部构建完成"