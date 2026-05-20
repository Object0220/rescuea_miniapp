# RescueA MiniApp 🚗

**SAA 吉诺道路救援 — 跨平台救援技师 APP**

基于 Flutter 开发，支持 **鸿蒙（HarmonyOS NEXT）** / **iOS** / **Android** 三端。

## 功能

- 🔐 登录鉴权
- 🗺️ 高德地图定位与导航
- 📋 救援任务查看与执行
- ✍️ 电子签名
- 📷 现场拍照上传
- 📜 历史记录查询
- 🧭 WebView 内嵌页面

## 技术栈

| 类别 | 技术 |
|------|------|
| 框架 | Flutter 3.22+ / Dart 3.4+ |
| 状态管理 | Provider |
| 网络请求 | Dio |
| 地图 & 定位 | 高德地图 SDK |
| 本地存储 | SharedPreferences + FlutterSecureStorage |
| 加密 | RSA (pointycastle + asn1lib) |
| 权限 | permission_handler |
| 跨端 | 鸿蒙 (flutter-ohos), iOS, Android |

## 项目结构

```
lib/
├── main.dart
├── config/          # 应用配置
├── models/          # 数据模型
├── pages/           # 页面
│   ├── home/
│   ├── login/
│   ├── task/
│   ├── history/
│   ├── mine/
│   └── webview/
├── services/        # API & Auth 服务
├── utils/           # 工具类
└── widgets/         # 公共组件
```

## 开始

```bash
# 获取依赖
flutter pub get

# 运行
flutter run

# 鸿蒙构建 (需 flutter-ohos)
cd ohos && bash setup_ohos.sh
```

## 环境要求

- Flutter SDK >= 3.22
- Dart SDK >= 3.4
- 鸿蒙构建：flutter-ohos 3.22.1-ohos
- iOS: Xcode 15+
- Android: Android Studio (AGP 8+)

## 许可证

MIT
