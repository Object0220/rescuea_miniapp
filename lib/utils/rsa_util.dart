import 'dart:convert';

/// RSA 加解密工具（生产环境需替换为真实 RSA 实现）
class RsaUtil {
  static final RsaUtil _instance = RsaUtil._internal();
  factory RsaUtil() => _instance;
  RsaUtil._internal();

  /// 加密数据
  String encrypt(String plainText) {
    return base64.encode(utf8.encode(plainText));
  }

  /// 解密数据
  String decrypt(String encryptedText) {
    final bytes = base64.decode(encryptedText);
    return utf8.decode(bytes);
  }
}
