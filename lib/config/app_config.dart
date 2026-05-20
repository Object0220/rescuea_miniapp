/// 应用配置
class AppConfig {
  // 环境配置 - 开发/生产
  static const bool isDev = bool.fromEnvironment('DEV_MODE', defaultValue: true);

  /// 接口地址
  static String get baseUrl => isDev
      ? 'https://beta-wti.saa.com.cn'
      : 'https://dw-gateway.saa.com.cn/wti';

  /// 上传地址
  static String get uploadUrl => isDev
      ? 'https://beta-ssr.saa.com.cn'
      : 'https://ssr.saa.com.cn';

  /// 用户协议
  static const String userAgreement =
      'https://quark-api.saa.com.cn/privacyPolicy/SAA吉诺道路救援用户协议';

  /// 隐私政策
  static const String privacyPolicy =
      'https://quark-api.saa.com.cn/privacyPolicy/SAA吉诺道路救援隐私协议';

  /// 在线客服（HTTPS 网页端，无需原生适配）
  static const String customerServiceUrl =
      'https://quark-api.saa.com.cn/customer-service';

  /// 版本号
  static const String version = '1.0.0';

  /// 超时配置（毫秒）
  static const int requestTimeout = 10000;
  static const int uploadTimeout = 30000;
  static const int downloadTimeout = 30000;

  /// 高德地图 Key
  static const String amapKey = ''; // 需替换为实际 Key
}
