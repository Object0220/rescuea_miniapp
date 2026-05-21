import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../../widgets/task_card.dart';
import 'history_detail_page.dart';

/// 历史任务列表 - 对应小程序 historyTask.wxml
class HistoryListPage extends StatefulWidget {
  const HistoryListPage({super.key});

  @override
  State<HistoryListPage> createState() => _HistoryListPageState();
}

class _HistoryListPageState extends State<HistoryListPage> {
  List<Map<String, dynamic>> _historyList = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    final auth = context.read<AuthService>();
    final res = await auth.ajax('/miniapp/order/task/list', {});
    if (mounted) {
      setState(() {
        _historyList = ((res['data'] as List<dynamic>?)
                ?.map((e) => e as Map<String, dynamic>)
                .toList() ??
            []);
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(title: const Text('历史任务')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchHistory,
              child: ListView.builder(
                padding: const EdgeInsets.all(15),
                itemCount: _historyList.length,
                itemBuilder: (_, i) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HistoryDetailPage(
                          task: _historyList[i],
                        ),
                      ),
                    );
                  },
                  child: TaskCard(
                    task: _historyList[i],
                    showFullInfo: false,
                  ),
                ),
              ),
            ),
    );
  }
}
