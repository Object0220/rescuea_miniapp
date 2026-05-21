/// 用户模型 - 救援技师信息
class UserModel {
  final String? userId;
  final String? name;
  final String? phone;
  final String? avatar;
  final String? token;

  UserModel({
    this.userId,
    this.name,
    this.phone,
    this.avatar,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId']?.toString(),
      name: json['name']?.toString(),
      phone: json['phone']?.toString(),
      avatar: json['avatar']?.toString(),
      token: json['token']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'name': name,
    'phone': phone,
    'avatar': avatar,
    'token': token,
  };
}

/// 登录请求
class LoginRequest {
  final String code;       // 微信登录 code
  final String? nickName;
  final String? avatar;

  LoginRequest({
    required this.code,
    this.nickName,
    this.avatar,
  });

  Map<String, dynamic> toJson() => {
    'code': code,
    'nickName': nickName,
    'avatar': avatar,
  };
}

/// 登录响应
class LoginResponse {
  final String? token;
  final String? expiresTime;
  final UserModel? userInfo;

  LoginResponse({this.token, this.expiresTime, this.userInfo});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token']?.toString(),
      expiresTime: json['expiresTime']?.toString(),
      userInfo: json['userInfo'] != null
          ? UserModel.fromJson(json['userInfo'])
          : null,
    );
  }
}
