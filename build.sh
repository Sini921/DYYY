#!/bin/bash

echo "删除旧版插件"
rm -rf packages
echo "已删除旧版插件，准备开始重新构建..."

echo "获取时间戳"
timestamp=$(date +%s)
echo "当前Unix时间戳: $timestamp"

cp control control.orig

echo "开始构建 rootless 版本..."
cp control.orig control
sed -i \
    -e "s/^Name: \(.*\)$/Name: \1(rootless)/" \
    -e "s/^Version: \(.*\)$/Version: \1-${timestamp}/" control
THEOS_PACKAGE_SCHEME=rootless make clean package
echo "rootless构建完成..."

echo "开始构建 roothide 版本..."
cp control.orig control
sed -i \
    -e "s/^Name: \(.*\)$/Name: \1(roothide)/" \
    -e "s/^Version: \(.*\)$/Version: \1-${timestamp}/" control
THEOS_PACKAGE_SCHEME=roothide make clean package
echo "roothide构建完成..."

mv control.orig control

echo "全部构建完成"