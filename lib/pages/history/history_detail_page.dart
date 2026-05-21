import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// 历史任务详情 - 对应小程序 historyDetail.wxml
class HistoryDetailPage extends StatelessWidget {
  final Map<String, dynamic> task;

  const HistoryDetailPage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(title: const Text('任务详情')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            _buildInfoCard('基本信息', [
              MapEntry('客户名称', task['customerName'] as String? ?? ''),
              MapEntry('订单类型', task['orderTypeName'] as String? ?? ''),
              MapEntry('案件编号', task['caseNo'] as String? ?? ''),
              MapEntry('车牌号', task['faultPlateNumber'] as String? ?? ''),
              MapEntry('车架号', task['vinCode'] as String? ?? ''),
            ]),
            const SizedBox(height: 10),
            _buildInfoCard('地址信息', [
              MapEntry('救援地址', task['rescueAddress'] as String? ?? ''),
              if (task['desAddress'] != null)
                MapEntry('目的地', task['desAddress'] as String? ?? ''),
            ]),
            const SizedBox(height: 10),
            _buildInfoCard('时间信息', [
              MapEntry('预约时间', task['bookTime'] as String? ?? ''),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, List<MapEntry<String, String>> items) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: AppColors.primary,
              )),
          const SizedBox(height: 10),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text('${item.key}：',
                          style: const TextStyle(
                              fontSize: 14, color: AppColors.textSecondary)),
                    ),
                    Expanded(
                      child: Text(item.value,
                          style: const TextStyle(fontSize: 14)),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
