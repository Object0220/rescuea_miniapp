import 'package:flutter/material.dart';

/// 通用 WebView 页面
/// 用途：在线客服 / 用户协议 / 隐私政策 等 HTTPS 网页
class WebviewPage extends StatelessWidget {
  final String url;
  final String title;

  const WebviewPage({
    super.key,
    required this.url,
    this.title = '',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title.isEmpty ? '加载中...' : title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.public, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              '网页加载',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                url,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey[400]),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _openInBrowser,
              icon: const Icon(Icons.open_in_browser, size: 16),
              label: const Text('在浏览器中打开'),
            ),
          ],
        ),
      ),
    );
  }

  void _openInBrowser() {
    // 正式版用 url_launcher
    // await launchUrl(Uri.parse(url));
  }
}

/// 在线客服页面（HTTPS 网页客服）
class CustomerServicePage extends WebviewPage {
  CustomerServicePage({super.key, String? url})
      : super(
          url: url ?? 'https://quark-api.saa.com.cn/customer-service',
          title: '在线客服',
        );
}
