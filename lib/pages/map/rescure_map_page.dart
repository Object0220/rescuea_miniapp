import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../task/task_execute_page.dart';

/// 救援地图/导航页 - 对应小程序 rescureMap.wxml
/// 技师出发去执行任务前的导航页面
class RescureMapPage extends StatefulWidget {
  final String taskId;

  const RescureMapPage({super.key, required this.taskId});

  @override
  State<RescureMapPage> createState() => _RescureMapPageState();
}

class _RescureMapPageState extends State<RescureMapPage> {
  Map<String, dynamic>? _taskInfo;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchTaskInfo();
  }

  Future<void> _fetchTaskInfo() async {
    final auth = context.read<AuthService>();
    final res = await auth.ajax('/miniapp/order/task/list', {});
    if (mounted) {
      final tasks = (res['data'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          [];
      setState(() {
        _taskInfo = tasks.cast<Map<String, dynamic>?>().firstWhere(
          (t) => t?['taskId'].toString() == widget.taskId,
          orElse: () => null,
        );
        _loading = false;
      });
    }
  }

  void _goExecute() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => TaskExecutePage(
          taskId: widget.taskId,
          orderId: _taskInfo?['orderId'] as String? ?? '',
          status: 3,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(title: const Text('救援导航')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // 地图区域（占位，高德地图集成）
                Container(
                  height: 300,
                  color: const Color(0xFFE8E8E8),
                  child: const Center(
                    child: Text('地图区域\n(集成高德地图SDK)',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textSecondary)),
                  ),
                ),
                // 任务信息
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _infoBlock(),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 44,
                          child: ElevatedButton(
                            onPressed: _goExecute,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22),
                              ),
                            ),
                            child: const Text('开始执行任务',
                                style: TextStyle(fontSize: 16)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _infoBlock() {
    if (_taskInfo == null) return const SizedBox.shrink();
    final t = _taskInfo!;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t['customerName'] as String? ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 8),
          _row('订单类型', t['orderTypeName'] as String? ?? ''),
          _row('救援地址', t['rescueAddress'] as String? ?? ''),
          if (t['desAddress'] != null)
            _row('目的地', t['desAddress'] as String? ?? ''),
          _row('车牌号', t['faultPlateNumber'] as String? ?? ''),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 65,
            child: Text('$label：',
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
