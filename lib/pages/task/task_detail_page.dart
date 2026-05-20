import 'package:flutter/material.dart';
import '../../models/task_model.dart';

/// 任务详情页
class TaskDetailPage extends StatelessWidget {
  final TaskModel task;

  const TaskDetailPage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('任务详情')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCard(context),
                  const SizedBox(height: 16),
                  _buildAddressCard(),
                  if (task.desAddress != null) const SizedBox(height: 12),
                  if (task.desAddress != null) _buildDesAddressCard(),
                  const SizedBox(height: 16),
                  _buildBottomActions(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题 + 状态
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${task.caseTypeName ?? ''}-${task.serviceTypeName ?? ''}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _statusBadge(task.taskStatusName ?? ''),
              ],
            ),
            const Divider(height: 24),

            // 信息列表
            _infoRow('案件编号', task.caseNo),
            _infoRow('订单类型', task.orderTypeName),
            _infoRow('客户', task.customerName),
            _infoRow('预约时间', task.bookTime),
            _infoRow('车牌号', task.faultPlateNumber),
            _infoRow('车架号', task.vinCode),
            _infoRow('背车路桥费', task.roadFeeName),
            if (task.smallWheelNum != null)
              _infoRow('小轮数', '${task.smallWheelNum}'),
            _infoRow('免拖里程', task.freeTrailerMileage),
            _infoRow('超公里价格', task.beyondKilometerPrice),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 2),
              child: const Icon(Icons.location_on, color: Colors.red, size: 20),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('救援地址', style: TextStyle(
                    fontSize: 12, color: Colors.grey,
                  )),
                  const SizedBox(height: 4),
                  Text(
                    task.rescueAddress ?? '暂无',
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesAddressCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 2),
              child: const Icon(Icons.flag, color: Colors.blue, size: 20),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('目的地', style: TextStyle(
                    fontSize: 12, color: Colors.grey,
                  )),
                  const SizedBox(height: 4),
                  Text(
                    task.desAddress ?? '暂无',
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _callClient(context),
            icon: const Icon(Icons.phone, size: 18),
            label: const Text('联系客户'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _navigateToRescue(context),
            icon: const Icon(Icons.navigation, size: 18),
            label: const Text('导航到救援地点'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _startTask(context),
            icon: const Icon(Icons.play_arrow, size: 18),
            label: const Text('开始执行任务'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: Colors.green,
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: const TextStyle(
              fontSize: 14, color: Colors.grey,
            )),
          ),
          Expanded(
            child: Text(
              value ?? '-',
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color bgColor;
    switch (status) {
      case '待接单': bgColor = Colors.orange; break;
      case '已完成': bgColor = Colors.green; break;
      case '执行中': bgColor = Colors.blue; break;
      default: bgColor = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(status, style: TextStyle(
        fontSize: 12, color: bgColor, fontWeight: FontWeight.w500,
      )),
    );
  }

  void _callClient(BuildContext context) {
    if (task.customerPhone != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('拨打客户电话: ${task.customerPhone}')),
      );
    }
  }

  void _navigateToRescue(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('打开导航功能（需接入地图 SDK）')),
    );
  }

  void _startTask(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('跳转到任务执行页面（下一阶段实现）')),
    );
  }
}
