# HarmonyOS 工程

## 版本信息

| 组件 | 版本 |
|------|------|
| Flutter 正式版 | **3.22.1**（iOS/Android/鸿蒙 三端统一） |
| Flutter-OHOS | **3.22.1-ohos-0.1.0**（基于相同基线） |
| HarmonyOS SDK | API 16+ |
| DevEco Studio | 5.0+ |

## 快速开始

### 1. 安装 DevEco Studio

从华为官网下载安装：
https://developer.harmonyos.com/cn/develop/deveco-studio

### 2. 配置 flutter-ohos SDK

```bash
# 只需执行一次
cd ~/development
git clone --depth 1 --branch 3.22.1-ohos-0.1.0 \
  https://gitee.com/openharmony-sig/flutter_flutter.git flutter-ohos

# 构建时切换
export PATH="$HOME/development/flutter-ohos/bin:$PATH"
flutter --version  # 应显示 3.22.1-ohos
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
# DevEco Studio 安装后 ohpm 会自动可用
ohpm init
ohpm install @ohos/flutter_ohos
flutter build ohos --release
```

### 4. 构建运行

```bash
# 1. 确保使用 flutter-ohos
export PATH="$HOME/development/flutter-ohos/bin:$PATH"

# 2. 获取依赖
flutter pub get

# 3. 构建鸿蒙包
flutter build ohos --release

# 4. 用 DevEco Studio 打开本目录
#    配置签名 → 运行到鸿蒙设备
```

## 注意事项

- **Flutter 版本统一为 3.22.1**，三端保持同一个基线
- 部分插件（amap_flutter_map / permission_handler 等）需鸿蒙原生适配
- 地图功能需替换为华为 Map Kit
- 定位功能需替换为华为 Location Kit
- 微信登录需接入微信鸿蒙 SDK + 华为账号服务

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
