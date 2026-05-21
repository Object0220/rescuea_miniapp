import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_modal.dart';
import '../../widgets/task_card.dart';
import '../task/task_execute_page.dart';
import '../map/rescure_map_page.dart';

/// 我的任务页 - 对应小程序 index.wxml
class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  List<Map<String, dynamic>> _taskList = [];
  bool _loading = true;
  String? _noticeTech;
  String _techRemark = '';
  String _dialogTitle = '';

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    final auth = context.read<AuthService>();
    final res = await auth.ajax('/miniapp/order/task/list', {});
    if (mounted) {
      setState(() {
        _taskList = (res['data'] as List<dynamic>?)
                ?.map((e) => e as Map<String, dynamic>)
                .toList() ??
            [];
        _loading = false;
      });
    }
  }

  void _goOperate(int index) {
    final task = _taskList[index];
    final nodeStatus = task['nodeStatus'] as int? ?? 0;
    final hasDes = task['desAddress'] != null &&
        (task['desAddress'] as String).isNotEmpty;

    List<int> statusBeforeExecute = hasDes ? [1, 2, 3, 4, 23] : [1, 2, 23];

    if (statusBeforeExecute.contains(nodeStatus)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RescureMapPage(taskId: task['taskId'] as String? ?? ''),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TaskExecutePage(
            taskId: task['taskId'] as String? ?? '',
            orderId: task['orderId'] as String? ?? '',
          ),
        ),
      );
    }
  }

  void _showTecDialog(String notice) {
    showDialog(
      context: context,
      builder: (_) => CustomModal(
        title: '技师须知',
        topImg: 'assets/images/tips.png',
        child: Column(
          children: [
            Container(
              constraints: const BoxConstraints(maxHeight: 200),
              child: SingleChildScrollView(
                child: Text(notice, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                child: const Text('我知道了', style: TextStyle(fontSize: 13)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(title: const Text('SAA救援技师')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _taskList.isEmpty
              ? _buildEmpty()
              : RefreshIndicator(
                  onRefresh: _fetchTasks,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: _taskList.length,
                    itemBuilder: (_, i) => TaskCard(
                      task: _taskList[i],
                      onNoticeTap: (notice) => _showTecDialog(notice),
                      onExecute: () => _goOperate(i),
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
          Image.asset('assets/images/hbg.png', width: 250),
          const SizedBox(height: 20),
          const Text('暂无数据', style: TextStyle(fontSize: 15, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
