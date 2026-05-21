import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// 用户协议 - 对应小程序 orderNotice.wxml
class OrderNoticePage extends StatelessWidget {
  const OrderNoticePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(title: const Text('用户协议')),
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
              '用户协议\n\n'
              '1. 服务条款\n'
              '欢迎使用SAA救援技师服务。在使用本服务前，请仔细阅读以下条款。\n\n'
              '2. 用户责任\n'
              '技师应确保提供的信息真实、准确、完整。因提供虚假信息导致的后果由技师自行承担。\n\n'
              '3. 服务流程\n'
              '技师接单后应按时到达救援地点，按规范完成救援任务，并如实记录任务执行情况。\n\n'
              '4. 隐私保护\n'
              '我们重视您的隐私保护，详见隐私政策。\n\n'
              '5. 免责声明\n'
              '因不可抗力因素导致的服务中断，本平台不承担责任。',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
          ),
        ),
      ),
    );
  }
}
