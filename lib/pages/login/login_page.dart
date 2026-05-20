import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../config/app_config.dart';

/// 登录页面
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoggingIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Logo & 标题
              Image.asset(
                'assets/images/ic_title_logo.svg',
                height: 60,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.local_car_wash,
                  size: 60,
                  color: Color(0xFF446A96),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'SAA 吉诺道路救援',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF446A96),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '技师端 v${AppConfig.version}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),

              const Spacer(flex: 1),

              // 登录按钮
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoggingIn ? null : () => _handleLogin(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF446A96),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 2,
                  ),
                  child: _isLoggingIn
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          '微信一键登录',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                ),
              ),
              const SizedBox(height: 12),

              // 用户协议
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '登录即表示同意',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                  GestureDetector(
                    onTap: () => _openUrl(AppConfig.userAgreement),
                    child: const Text(
                      '《用户协议》',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF446A96),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  Text(
                    '和',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                  GestureDetector(
                    onTap: () => _openUrl(AppConfig.privacyPolicy),
                    child: const Text(
                      '《隐私政策》',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF446A96),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }

  void _handleLogin() async {
    setState(() => _isLoggingIn = true);

    // Consumer<AuthService> 监听到 isLoggedIn 变化后自动切换到首页
    await context.read<AuthService>().login('mock_code_dev');

    if (mounted) {
      setState(() => _isLoggingIn = false);
    }
  }

  void _openUrl(String url) {
    // 通常用 url_launcher
    // launchUrl(Uri.parse(url));
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('外部链接'),
        content: Text(url),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }
}
