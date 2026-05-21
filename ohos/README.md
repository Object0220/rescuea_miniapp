# HarmonyOS 工程

## 版本信息

| 组件 | 版本 |
|------|------|
| Flutter (iOS/Android) | **3.44.0**（最新稳定版） |
| Flutter (鸿蒙) | **3.27.5-ohos-1.0.5**（flutter_flutter 分支） |
| Dart | 3.6.2（鸿蒙）/ 3.12.0（iOS/Android） |
| AGP | 8.11.1 |
| Gradle | 8.13 |
| Kotlin | 2.2.20 |
| HarmonyOS SDK | API 16+ |
| DevEco Studio | 5.0+ |

> **注意：** iOS/Android 和鸿蒙的 Flutter SDK 版本号不同（鸿蒙社区分支尚未追上 3.44），但 pubspec.yaml 的 SDK 约束 (`^3.22.0`) 兼容两者。构建时使用各自的 Flutter SDK 即可。

## 快速开始

### 1. 安装 DevEco Studio

从华为官网下载安装：
https://developer.harmonyos.com/cn/develop/deveco-studio

### 2. 配置 flutter_flutter SDK (鸿蒙版)

项目已内置在 `~/developmet/flutter_flutter`，版本 3.27.5-ohos-1.0.5。

如果需要重新拉取：

```bash
cd ~/developmet
git clone --depth 1 --branch 3.27.5-ohos-1.0.5 \
  https://gitcode.com/openharmony-sig/flutter_flutter.git flutter_flutter

# 构建时切换
export PATH="$HOME/developmet/flutter_flutter/bin:$PATH"
flutter --version  # 应显示 3.27.5-ohos-1.0.5
```

### 3. 生成 ohos 工程

**在 DevEco Studio 中操作：**

1. 打开 DevEco Studio → **File → New → Create Project from Existing Files**
2. 选择本项目目录 `~/FlutterProjects/rescuea_miniapp`
3. 选择 **Flutter** 模板
4. DevEco Studio 自动生成 `ohos/` 目录及原生工程文件

**或在终端生成：**

```bash
cd ~/FlutterProjects/rescuea_miniapp
export PATH="$HOME/developmet/flutter_flutter/bin:$PATH"
flutter pub get
flutter build ohos --release
```

### 4. 构建运行

```bash
# 1. 确保使用 flutter_flutter（鸿蒙版）
export PATH="$HOME/developmet/flutter_flutter/bin:$PATH"

# 2. 获取依赖
flutter pub get

# 3. 构建鸿蒙包
flutter build ohos --release

# 4. 用 DevEco Studio 打开本目录
#    配置签名 → 运行到鸿蒙设备
```

## Android 构建（iOS/Android 端）

```bash
# 使用主 Flutter SDK
export PATH="$HOME/development/flutter/bin:$PATH"
flutter build apk --release
```

## 注意事项

- **iOS/Android** 使用 Flutter 3.44.0（`~/development/flutter`）
- **鸿蒙** 使用 Flutter 3.27.5-ohos（`~/developmet/flutter_flutter`）
- Dart 语法约束以最低版本 (3.4.0) 为准，避免使用高版本特有语法
- 部分插件（amap_flutter_map / permission_handler 等）需鸿蒙原生适配
- 地图功能需替换为华为 Map Kit
- 定位功能需替换为华为 Location Kit

## 目录结构（生成后）

```
ohos/
├── entry/
│   ├── src/main/
│   │   ├── ets/          ← 原生 ArkTS 代码
│   │   ├── resources/    ← 资源文件
│   │   └── module.json5  ← 模块配置
│   └── build-profile.json5
├── oh-package.json5      ← ohpm 依赖管理
├── build-profile.json5   ← 构建配置
└── hvigorfile.ts         ← 构建脚本
```
