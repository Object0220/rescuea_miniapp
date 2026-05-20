import 'package:dio/dio.dart';
import '../config/app_config.dart';

/// API 请求封装 - 对应 miniRescuea 后端接口
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late final Dio _dio;
  String? _token;

  ApiService._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: const Duration(milliseconds: AppConfig.requestTimeout),
      receiveTimeout: const Duration(milliseconds: AppConfig.requestTimeout),
      headers: {'Content-Type': 'application/json'},
    ));

    // 请求拦截器 - 自动添加 token
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (_token != null) {
          options.headers['access-token'] = _token;
        }
        handler.next(options);
      },
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          // Token 过期，触发重新登录
          _onTokenExpired?.call();
        }
        handler.next(error);
      },
    ));
  }

  /// Token 过期回调
  VoidCallback? _onTokenExpired;
  set onTokenExpired(VoidCallback? callback) => _onTokenExpired = callback;

  /// 设置 Token
  void setToken(String? token) => _token = token;

  // ═══════════════════ 登录相关 ═══════════════════

  /// 微信小程序登录
  Future<Response> login(String code) => _dio.post(
    '/miniapp/login/weixin-mini-app-login',
    data: {'code': code},
  );

  /// 刷新 Token
  Future<Response> refreshToken() => _dio.post('/miniapp/login/reflush-token');

  /// 获取用户信息
  Future<Response> getUserInfo() => _dio.post('/miniapp/user/info');

  /// 更新用户信息
  Future<Response> editUserInfo(Map<String, dynamic> data) =>
      _dio.post('/miniapp/user/edit', data: data);

  // ═══════════════════ 任务相关 ═══════════════════

  /// 获取任务列表
  Future<Response> getTaskList() =>
      _dio.post('/miniapp/order/task/list', data: {});

  /// 获取任务详情
  Future<Response> getTaskInfo(String taskId) =>
      _dio.post('/miniapp/order/task/info', data: {'taskId': taskId});

  /// 接单
  Future<Response> acceptTask(Map<String, dynamic> data) =>
      _dio.post('/miniapp/order/wait-accept/accept-task', data: data);

  /// 获取接单任务详情
  Future<Response> getAcceptTaskInfo(Map<String, dynamic> data) =>
      _dio.post('/miniapp/order/wait-accept/task-info', data: data);

  /// 更新救援节点状态
  Future<Response> updateRescue(Map<String, dynamic> data) =>
      _dio.post('/miniapp/order/task/update-rescue', data: data);

  /// 获取订单模板详情
  Future<Response> getByOrderTemplate(String taskId, String orderId) =>
      _dio.post('/miniapp/order/get-by-order-template',
          data: {'taskId': taskId, 'orderId': orderId});

  // ═══════════════════ 媒体相关 ═══════════════════

  /// 上传图片（OSS 回调）
  Future<Response> uploadOssImage(Map<String, dynamic> data) =>
      _dio.post('/miniapp/order/oss', data: data);

  /// 获取订单所有照片
  Future<Response> getAllPic(String taskId) =>
      _dio.post('/miniapp/order/get-all-pic?taskId=$taskId');

  /// 保存签名
  Future<Response> saveSignPic(Map<String, dynamic> data) =>
      _dio.post('/miniapp/order/sign-pic/save', data: data);

  /// 获取签名照片
  Future<Response> getSignPic(Map<String, dynamic> data) =>
      _dio.post('/miniapp/order/sign-pic/get', data: data);

  // ═══════════════════ 订单完成 ═══════════════════

  /// 获取完成信息
  Future<Response> getCompleteInfo(Map<String, dynamic> data) =>
      _dio.post('/miniapp/order/get-complete-info', data: data);

  /// 完成任务
  Future<Response> completeTask(Map<String, dynamic> data) =>
      _dio.post('/miniapp/order/update-complete', data: data);

  /// 终止任务
  Future<Response> failedRescue(String taskId, String reason, String taskStatus,
      {Map<String, dynamic>? data}) =>
      _dio.post(
          '/miniapp/order/failed-rescue?taskId=$taskId&reason=$reason&taskStatus=$taskStatus',
          data: data ?? {});

  // ═══════════════════ 历史任务 ═══════════════════

  /// 获取历史任务
  Future<Response> getHistoryTask(Map<String, dynamic> data) =>
      _dio.post('/miniapp/order/task/history-task', data: data);

  // ═══════════════════ 通话记录 ═══════════════════

  /// 记录拨打客户电话
  Future<Response> recordCallCustomer(String taskId) =>
      _dio.post('/miniapp/order/call-customer?taskId=$taskId');

  // ═══════════════════ 即时消息 ═══════════════════

  /// 获取即时消息通道
  Future<Response> getInstantMessengerChannel(String orderId) =>
      _dio.post('/miniapp/order/get-instant-messenger-channel?orderId=$orderId');

  // ═══════════════════ 定位 ═══════════════════

  /// 上传位置
  Future<Response> addLocation(Map<String, dynamic> data) =>
      _dio.post('/miniapp/user/add-location', data: data);

  // ═══════════════════ 客户终止审核 ═══════════════════

  /// 获取终止审核配置列表
  Future<Response> getTechnicianEndConfig(String orderId) =>
      _dio.post('/miniapp/order/get-technician-end-config?orderId=$orderId');

  /// 获取终止审核详情
  Future<Response> getDetailByReview(String orderId, String detailId) =>
      _dio.post(
          '/miniapp/order/get-technician-end-review-detail?orderId=$orderId&detailId=$detailId');
}

typedef VoidCallback = void Function();
