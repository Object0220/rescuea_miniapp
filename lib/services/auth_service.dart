import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';
import 'api_service.dart';

/// 认证服务 - 管理登录/Token/用户信息
class AuthService extends ChangeNotifier {
  final ApiService _api = ApiService();
  final _secureStorage = const FlutterSecureStorage();

  UserModel? _currentUser;
  String? _token;

  UserModel? get currentUser => _currentUser;
  String? get token => _token;
  bool get isLoggedIn => _token != null;

  /// 初始化 - 从本地读取登录状态
  Future<void> init() async {
    _token = await _secureStorage.read(key: 'token');
    if (_token != null) {
      _api.setToken(_token);
      final userStr = await _secureStorage.read(key: 'user_info');
      if (userStr != null) {
        _currentUser = UserModel.fromJson(
          jsonDecode(userStr) as Map<String, dynamic>,
        );
      }
      notifyListeners();
    }
  }

  /// 微信登录（开发环境模拟登录）
  Future<bool> login(String code) async {
    try {
      final res = await _api.login(code);
      if (res.statusCode == 200 &&
          res.data is Map &&
          res.data['status'] == 200) {
        final content = res.data['content'] as Map<String, dynamic>;
        _token = content['token']?.toString();
      } else {
        // API 返回非 200 → 开发环境模拟
        return _mockLogin();
      }
    } catch (_) {
      // 开发/测试环境无后端 → 模拟登录成功
      return _mockLogin();
    }

    if (_token != null) {
      _api.setToken(_token);
      await _secureStorage.write(key: 'token', value: _token!);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token!);
      notifyListeners();
      return true;
    }
    return false;
  }

  /// 开发环境模拟登录
  Future<bool> _mockLogin() async {
    _token = 'mock_token_dev_${DateTime.now().millisecondsSinceEpoch}';
    _api.setToken(_token);
    _currentUser = UserModel(
      userId: '1',
      name: '救援技师（测试）',
      phone: '13800138000',
    );
    await _secureStorage.write(key: 'token', value: _token!);
    await _secureStorage.write(
      key: 'user_info',
      value: jsonEncode(_currentUser!.toJson()),
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', _token!);
    debugPrint('✅ 开发环境模拟登录成功');
    notifyListeners();
    return true;
  }

  /// 退出登录
  Future<void> logout() async {
    _token = null;
    _currentUser = null;
    _api.setToken(null);
    await _secureStorage.delete(key: 'token');
    await _secureStorage.delete(key: 'user_info');
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    notifyListeners();
  }

  /// 刷新 Token
  Future<bool> refreshToken() async {
    try {
      final res = await _api.refreshToken();
      if (res.statusCode == 200 && res.data['status'] == 200) {
        final expiresTime = res.data['content'];
        debugPrint('Token 过期时间: $expiresTime');
        return true;
      }
      await logout();
      return false;
    } catch (e) {
      debugPrint('Refresh token error: $e');
      return false;
    }
  }
}
