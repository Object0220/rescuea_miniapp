import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../services/auth_service.dart';

/// 登录页 - 对应小程序 mine.wxml 中的 getPhoneNumber 登录
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneController = TextEditingController();
  final _pwdController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _pwdController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_phoneController.text.isEmpty) {
      _showToast('请输入手机号');
      return;
    }
    if (_pwdController.text.isEmpty) {
      _showToast('请输入密码');
      return;
    }
    setState(() => _loading = true);
    final auth = context.read<AuthService>();
    final success = await auth.login(
      _phoneController.text,
      _pwdController.text,
    );
    if (mounted) {
      setState(() => _loading = false);
      if (!success) {
        _showToast('登录失败，请检查账号密码');
      }
    }
  }

  void _showToast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // 头部图标
              Image.asset('assets/images/head.png', width: 80, height: 80),
              const SizedBox(height: 20),
              const Text(
                'SAA救援技师',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '请登录以使用服务',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const Spacer(flex: 1),
              // 手机号输入
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.border),
                ),
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  maxLength: 11,
                  decoration: const InputDecoration(
                    hintText: '请输入手机号',
                    prefixIcon: Icon(Icons.phone_android, color: AppColors.primary),
                    border: InputBorder.none,
                    counterText: '',
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // 密码输入
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.border),
                ),
                child: TextField(
                  controller: _pwdController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: '请输入密码',
                    prefixIcon: Icon(Icons.lock_outline, color: AppColors.primary),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // 登录按钮
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _loading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 0,
                  ),
                  child: _loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('登录', style: TextStyle(fontSize: 16)),
                ),
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}
