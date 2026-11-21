#!/usr/bin/env bash
# 把繁體中文（台灣）語系套用到 NuvioMobile 工作區
# 用法：./apply.sh /path/to/NuvioMobile
set -euo pipefail
REPO="${1:?用法: ./apply.sh /path/to/NuvioMobile}"
HERE="$(cd "$(dirname "$0")" && pwd)"
DEST="$REPO/composeApp/src/commonMain/composeResources"

[ -d "$DEST" ] || { echo "找不到 $DEST，這不是 NuvioMobile 工作區"; exit 1; }

cp -r "$HERE/composeApp/src/commonMain/composeResources/values-zh-rTW" "$DEST/"
patch -p1 -d "$REPO" < "$HERE/patches/0001-add-traditional-chinese-language.patch"

echo "完成。接著執行："
echo "  cd $REPO && echo \"sdk.dir=\$ANDROID_HOME\" > local.properties && ./gradlew :composeApp:assembleDebug"
