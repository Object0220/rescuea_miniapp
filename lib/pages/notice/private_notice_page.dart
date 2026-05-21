import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// 隐私政策 - 对应小程序 privateNotice.wxml
class PrivateNoticePage extends StatelessWidget {
  const PrivateNoticePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(title: const Text('隐私政策')),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const SingleChildScrollView(
            child: Text(
              '隐私政策\n\n'
              '1. 信息收集\n'
              '我们收集您的个人信息包括：姓名、手机号、身份证号、位置信息、照片等。\n\n'
              '2. 信息使用\n'
              '收集的信息仅用于救援任务分配、执行和结算。\n\n'
              '3. 位置权限\n'
              '为提供救援导航服务，我们需要获取您的位置信息（包括后台定位）。\n\n'
              '4. 存储权限\n'
              '为保存任务照片和签名，我们需要访问您的存储空间。\n\n'
              '5. 信息保护\n'
              '我们采用业内标准的安全措施保护您的个人信息。\n\n'
              '6. 联系我们\n'
              '如有隐私相关问题，请联系我们的客服。',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
          ),
        ),
      ),
    );
  }
}
