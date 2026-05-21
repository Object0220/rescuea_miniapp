import 'package:flutter/material.dart';
import '../models/task_model.dart';

/// 任务卡片组件
class OrderCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onTap;
  final VoidCallback? onAccept;

  const OrderCard({
    super.key,
    required this.task,
    this.onTap,
    this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题行
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${task.caseTypeName ?? ''}-${task.serviceTypeName ?? ''}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildStatusBadge(task.taskStatusName),
                ],
              ),
              const SizedBox(height: 8),

              // 客户信息
              if (task.customerName != null)
                _infoRow('客户', task.customerName!),
              if (task.caseNo != null)
                _infoRow('案件编号', task.caseNo!),
              if (task.bookTime != null)
                _infoRow('预约时间', task.bookTime!),
              if (task.faultPlateNumber != null)
                _infoRow('车牌号', task.faultPlateNumber!),

              const Divider(height: 20),

              // 地址
              if (task.rescueAddress != null)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.red),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        task.rescueAddress!,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              if (task.desAddress != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.flag, size: 16, color: Colors.blue),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          task.desAddress!,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),

              // 接单按钮
              if (onAccept != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onAccept,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF446A96),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('接单'),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String? status) {
    Color bgColor;
    switch (status) {
      case '待接单':
        bgColor = Colors.orange;
        break;
      case '已完成':
        bgColor = Colors.green;
        break;
      default:
        bgColor = Colors.blue;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status ?? '',
        style: TextStyle(
          fontSize: 12,
          color: bgColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(
            '$label：',
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
