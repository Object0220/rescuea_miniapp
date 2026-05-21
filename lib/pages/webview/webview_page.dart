import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// WebView页 - 对应小程序 webview.wxml
class WebviewPage extends StatefulWidget {
  final String url;
  final String? title;

  const WebviewPage({super.key, required this.url, this.title});

  @override
  State<WebviewPage> createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title ?? '')),
      body: WebViewWidget(controller: _controller),
    );
  }
}
