import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

/// 登录/鉴权服务 - 对应小程序 app.js 中的 login/refreshToken/userInfo
class AuthService extends ChangeNotifier {
  final ApiService _api = ApiService();
  Map<String, dynamic>? _userInfo;
  Map<String, dynamic>? _tokenInfo;
  bool _isLoggedIn = false;

  Map<String, dynamic>? get userInfo => _userInfo;
  Map<String, dynamic>? get tokenInfo => _tokenInfo;
  bool get isLoggedIn => _isLoggedIn;

  AuthService() {
    _loadLocalToken();
  }

  Future<void> _loadLocalToken() async {
    final prefs = await SharedPreferences.getInstance();
    final tokenStr = prefs.getString('tokenInfo');
    if (tokenStr != null) {
      _tokenInfo = jsonDecode(tokenStr) as Map<String, dynamic>?;
      final token = _tokenInfo?['accessToken'] as String?;
      if (token != null) {
        _api.setToken(token);
        _isLoggedIn = true;
        notifyListeners();
        // 刷新token
        _refreshToken();
      }
    }
  }

  /// 登录 - 对应小程序的toLogin
  Future<bool> login(String phone, String password) async {
    final res = await _api.ajax('/miniapp/login/weixin-mini-app-login', {
      'phone': phone,
      'password': password,
    });
    if (res['status'] == 200 && res['data'] != null) {
      _tokenInfo = res['data'] as Map<String, dynamic>?;
      final token = _tokenInfo?['accessToken'] as String?;
      if (token != null) {
        _api.setToken(token);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('tokenInfo', jsonEncode(_tokenInfo));
        _isLoggedIn = true;
        notifyListeners();
        _getUserInfo();
        return true;
      }
    }
    return false;
  }

  /// 获取用户信息
  Future<void> _getUserInfo() async {
    final res = await _api.ajax('/miniapp/user/info', {});
    if (res['status'] == 200) {
      _userInfo = res['data'] as Map<String, dynamic>?;
      notifyListeners();
    }
  }

  /// 刷新token
  Future<void> _refreshToken() async {
    final res = await _api.ajax('/miniapp/login/reflush-token', {});
    if (res['status'] == 200) {
      _getUserInfo();
    }
  }

  /// 快捷请求 - 供页面调用
  Future<Map<String, dynamic>> ajax(String url, Map<String, dynamic> data,
      {String method = 'POST'}) {
    return _api.ajax(url, data, method: method);
  }

  /// 退出登录
  Future<void> logout() async {
    _userInfo = null;
    _tokenInfo = null;
    _isLoggedIn = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('tokenInfo');
    notifyListeners();
  }
}
