#!/bin/bash

GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
RED='\033[1;31m'
CYAN='\033[1;36m'
RESET='\033[0m'

echo -e "${CYAN}--------------------------------------------------${RESET}"

echo -e "${PURPLE}==>${RESET} 获取时间戳"
timestamp=$(date +%s)
echo -e "${PURPLE}==>${RESET} 当前时间戳: $timestamp"

echo -e "${CYAN}--------------------------------------------------${RESET}"

echo -e "${RED}==>${RESET} 删除旧文件"
[ -d packages ] && rm -rf packages && echo -e "${RED}==>${RESET} packages 已删除" || echo -e "${YELLOW}==>${RESET} packages不存在"

echo -e "${CYAN}--------------------------------------------------${RESET}"

cp control control.orig

echo -e "${BLUE}==>${RESET} 开始编译rootless版本..."
cp control.orig control
sed -i \
    -e "s/^Name: \(.*\)$/Name: \1(rootless)/" \
    -e "s/^Version: \(.*\)$/Version: \1-${timestamp}/" control
THEOS_PACKAGE_SCHEME=rootless make clean package
echo -e "${GREEN}==>${RESET} rootless编译完成..."

echo -e "${CYAN}--------------------------------------------------${RESET}"

echo -e "${BLUE}==>${RESET} 开始编译roothide版本..."
cp control.orig control
sed -i \
    -e "s/^Name: \(.*\)$/Name: \1(roothide)/" \
    -e "s/^Version: \(.*\)$/Version: \1-${timestamp}/" control
THEOS_PACKAGE_SCHEME=roothide make clean package
echo -e "${GREEN}==>${RESET} roothide编译完成..."

echo -e "${CYAN}--------------------------------------------------${RESET}"

mv control.orig control

deb_arm64=$(basename $(find ./packages -name "*.deb" | grep arm64.deb | grep -v arm64e | head -n1))
deb_arm64e=$(basename $(find ./packages -name "*.deb" | grep arm64e.deb | head -n1))

echo -e "${YELLOW}==>${RESET} rootless: ${deb_arm64}"
echo -e "${YELLOW}==>${RESET} roothide: ${deb_arm64e}"
echo -e "${GREEN}==>${RESET} 全部编译完成"

echo -e "${CYAN}--------------------------------------------------${RESET}"