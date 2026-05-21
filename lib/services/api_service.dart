import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// API 服务 - 对应小程序 app.js 中的 ajax 方法
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // 测试环境
  String baseUrl = 'https://beta-wti.saa.com.cn';
  String uploadUrl = 'https://beta-ssr.saa.com.cn';
  String h5Url =
      'https://beta-rescue-card-h5.saa.com.cn/redirect-request/client/';

  // 正式环境
  // String baseUrl = 'https://dw-gateway.saa.com.cn/wti';
  // String uploadUrl = 'https://ssr.saa.com.cn';
  // String h5Url = 'https://rescue-card-h5.saa.com.cn/redirect-request/client/';

  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    headers: {'Content-Type': 'application/json'},
  ));

  String? _token;

  Future<String?> get token async {
    if (_token != null) return _token;
    final prefs = await SharedPreferences.getInstance();
    final tokenInfoStr = prefs.getString('tokenInfo');
    if (tokenInfoStr != null) {
      final tokenInfo = jsonDecode(tokenInfoStr) as Map<String, dynamic>;
      _token = tokenInfo['accessToken'] as String?;
    }
    return _token;
  }

  Future<void> setToken(String token) async {
    _token = token;
  }

  /// 发起请求 - 对应小程序 app.ajax()
  Future<Map<String, dynamic>> ajax(String url, Map<String, dynamic> data,
      {String method = 'POST'}) async {
    try {
      final t = await token;
      final response = await _dio.request(
        '$baseUrl$url',
        data: data,
        options: Options(
          method: method,
          headers: {
            'Content-Type': 'application/json',
            'access-token': t ?? '',
          },
        ),
      );

      final jsondata = response.data as Map<String, dynamic>;

      // 处理返回格式
      Map<String, dynamic> result = Map.from(jsondata);
      result['data'] = jsondata['content'] ?? jsondata['data'] ?? null;

      return result;
    } on DioException catch (e) {
      return {'status': 500, 'msg': '网络错误: ${e.message}', 'data': null};
    }
  }

  /// 上传文件 - 对应小程序 wx.uploadFile
  Future<Map<String, dynamic>> uploadFile(
    String filePath, {
    String environment = 'dev',
    String project = 'technicianrescue',
    String module = 'userinfo',
  }) async {
    try {
      final t = await token;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
        'environment': environment,
        'project': project,
        'module': module,
      });
      final response = await _dio.post(
        '$uploadUrl/redirect-request/public_path/obs/upload',
        data: formData,
        options: Options(
          headers: {'access-token': t ?? ''},
        ),
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      return {'status': 500, 'msg': '上传失败', 'data': null};
    }
  }
}
