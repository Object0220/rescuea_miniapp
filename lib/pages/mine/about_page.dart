import 'package:flutter/material.dart';
import '../../config/app_config.dart';

/// 关于页面
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('关于')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 30),

          // Logo 区域
          Center(
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF446A96),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.local_car_wash, size: 40, color: Colors.white),
                ),
                const SizedBox(height: 16),
                const Text(
                  'SAA 吉诺道路救援',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '技师端 v${AppConfig.version}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // 信息列表
          Card(
            child: Column(
              children: [
                _aboutItem('应用名称', 'SAA吉诺道路救援 - 技师端'),
                const Divider(height: 1),
                _aboutItem('版本号', 'v${AppConfig.version}'),
                const Divider(height: 1),
                _aboutItem('开发环境', AppConfig.isDev ? '测试环境' : '生产环境'),
                const Divider(height: 1),
                _aboutItem('技术支持', 'SAA'),
              ],
            ),
          ),

          const SizedBox(height: 30),

          Center(
            child: Column(
              children: [
                Text(
                  'Copyright © 2026 SAA',
                  style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                ),
                const SizedBox(height: 4),
                Text(
                  'All Rights Reserved',
                  style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _aboutItem(String label, String value) {
    return ListTile(
      title: Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      trailing: Text(value, style: const TextStyle(fontSize: 14)),
    );
  }
}
