import 'package:flutter/material.dart';
import '../../models/task_model.dart';
import '../../widgets/order_card.dart';

/// 历史任务列表页
class HistoryListPage extends StatefulWidget {
  const HistoryListPage({super.key});

  @override
  State<HistoryListPage> createState() => _HistoryListPageState();
}

class _HistoryListPageState extends State<HistoryListPage> {
  List<TaskModel> _historyTasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    // 模拟加载历史数据
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _isLoading = false;
      _historyTasks = List.generate(8, (i) => TaskModel(
        caseNo: 'SAA2026052${100 + i}',
        caseTypeName: '道路救援',
        serviceTypeName: i % 2 == 0 ? '拖车服务' : '搭电服务',
        taskStatusName: '已完成',
        customerName: ['张伟', '李娜', '王强', '刘洋', '陈明', '赵丽', '孙杰', '周婷'][i],
        bookTime: '2026-05-${15 + i ~/ 2} ${8 + i}:00',
        faultPlateNumber: ['京A·12345', '沪B·67890', '粤C·11111', '浙D·22222',
                          '苏E·33333', '鲁F·44444', '川G·55555', '闽H·66666'][i],
        rescueAddress: '北京市朝阳区道路救援点${i + 1}号',
        desAddress: i % 2 == 0 ? '北京市海淀区维修厂${i + 1}' : null,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('历史任务')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _historyTasks.isEmpty
              ? _buildEmpty()
              : RefreshIndicator(
                  onRefresh: _loadHistory,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _historyTasks.length,
                    itemBuilder: (_, i) => OrderCard(
                      task: _historyTasks[i],
                      onTap: () {
                        // Navigator.push 跳转详情
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('查看: ${_historyTasks[i].caseNo}')),
                        );
                      },
                    ),
                  ),
                ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text('暂无历史任务', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
        ],
      ),
    );
  }
}
