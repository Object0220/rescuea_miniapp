#!/bin/bash
# ══════════════════════════════════════════════
#  rescuea_miniapp — 鸿蒙工程自动生成脚本
# ══════════════════════════════════════════════
# 用法: bash ohos/setup_ohos.sh
# 前置条件: DevEco Studio 5.0+ 已安装

set -e

echo "🚀 开始生成鸿蒙工程..."

# 1. 检查 DevEco Studio
DEVECO="/Applications/DevEco-Studio.app"
if [ ! -d "$DEVECO" ]; then
  echo "❌ 未检测到 DevEco Studio，请先安装"
  echo "   下载: https://developer.harmonyos.com/cn/develop/deveco-studio"
  exit 1
fi

# 2. 设置 ohpm 环境
export OHPM_HOME="$DEVECO/Contents/tools/ohpm/bin"
export HVIAGOR_HOME="$DEVECO/Contents/tools/hvigor/bin"
export PATH="$OHPM_HOME:$HVIAGOR_HOME:$PATH"

# 3. 配置 flutter-ohos 环境
FLUTTER_OHOS="$HOME/development/flutter-ohos"
if [ ! -d "$FLUTTER_OHOS" ]; then
  echo "📥 克隆 flutter-ohos SDK..."
  git clone --depth 1 --branch 3.22.1-ohos-0.1.0 \
    https://gitee.com/openharmony-sig/flutter_flutter.git "$FLUTTER_OHOS"
fi
export PATH="$FLUTTER_OHOS/bin:$PATH"

echo "✅ Flutter-OHOS: $(flutter --version | head -1)"

# 4. 创建鸿蒙工程
cd "$(dirname "$0")/.."
PROJECT_DIR=$(pwd)

echo "📁 项目目录: $PROJECT_DIR"
echo "🔄 请用 DevEco Studio 打开本目录 ($PROJECT_DIR)"
echo ""
echo "   然后在 DevEco Studio 中:"
echo "   1. File → New → Create Project from Existing Files"
echo "   2. 选择 Flutter 项目目录"
echo "   3. DevEco Studio 自动检测并生成 ohos 工程"
echo "   4. 配置签名 → 运行到鸿蒙设备"
echo ""
echo "   或者手动创建 ohos 项目后，用以下命令构建:"
echo "   cd $PROJECT_DIR"
echo "   flutter build ohos --release"
