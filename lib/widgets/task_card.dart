import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// 任务卡片 - 对应小程序 index.wxml / home.wxml 中的 listBox
class TaskCard extends StatelessWidget {
  final Map<String, dynamic> task;
  final void Function(String)? onNoticeTap;
  final VoidCallback? onExecute;
  final bool showFullInfo;
  final bool showAcceptButton;

  const TaskCard({
    super.key,
    required this.task,
    this.onNoticeTap,
    this.onExecute,
    this.showFullInfo = true,
    this.showAcceptButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final nodeStatus = task['nodeStatus'] as int? ?? 0;
    final isAbnormal = nodeStatus == 19;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题栏
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 46,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              task['customerName'] as String? ?? '',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: AppColors.textWhite,
              ),
            ),
          ),

          // 异常状态
          if (isAbnormal)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 5),
              color: AppColors.errorBg,
              child: const Text(
                '技师终止-异常反馈待平台审核',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.accentRed, fontSize: 13),
              ),
            ),

          // 信息行
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoRow('订单类型：', task['orderTypeName'] as String? ?? ''),
                _infoRow('预约时间：', task['bookTime'] as String? ?? ''),
                _infoRow('案件编号：', task['caseNo'] as String? ?? ''),
                _infoRow('车牌号：', task['faultPlateNumber'] as String? ?? ''),
                if (showFullInfo) ...[
                  _infoRow('车架号：', task['vinCode'] as String? ?? ''),
                  _infoRow('背车路桥费：', task['roadFeeName'] as String? ?? ''),
                  _infoRow('小轮数：', '${task['smallWheelNum'] ?? ''}'),
                  _infoRow('免拖里程：', '${task['freeTrailerMileage'] ?? ''}'),
                  _infoRow('超公里价格：', '${task['beyondKilometerPrice'] ?? ''}'),
                ],
                if (!showFullInfo) ...[
                  if (task['caseTypeName'] != null)
                    _infoRow('案件类型：', task['caseTypeName'] as String? ?? ''),
                  if (task['serviceTypeName'] != null)
                    _infoRow('业务类型：', task['serviceTypeName'] as String? ?? ''),
                ],
              ],
            ),
          ),

          // 技师须知
          if (onNoticeTap != null && task['noticeTech'] != null)
            GestureDetector(
              onTap: () => onNoticeTap?.call(task['noticeTech'] as String? ?? ''),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                child: Row(
                  children: [
                    Text('技师须知',
                        style: TextStyle(color: AppColors.accentRed, fontSize: 14)),
                    SizedBox(width: 5),
                    Image(
                      image: AssetImage('assets/images/tecNotice.png'),
                      width: 22,
                      height: 22,
                    ),
                  ],
                ),
              ),
            ),

          // 地址卡片
          Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: AppColors.addressCardBg,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                children: [
                  _addressRow('assets/images/addIcon.png', task['rescueAddress'] as String? ?? ''),
                  if (task['desAddress'] != null &&
                      (task['desAddress'] as String).isNotEmpty)
                    const SizedBox(height: 25),
                  if (task['desAddress'] != null &&
                      (task['desAddress'] as String).isNotEmpty)
                    _addressRow('assets/images/desIcon.png', task['desAddress'] as String? ?? ''),
                ],
              ),
            ),
          ),

          // 按钮
          if (onExecute != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
              child: SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: onExecute,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 0,
                  ),
                  child: const Text('开始执行',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
                ),
              ),
            ),

          // 接单按钮 (home页面)
          if (showAcceptButton && onExecute != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
              child: SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: onExecute,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 0,
                  ),
                  child: const Text('实际去执行的师傅接单',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 105,
            child: Text(label,
                style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }

  Widget _addressRow(String icon, String address) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(icon, width: 27, height: 27),
        const SizedBox(width: 10),
        Expanded(
          child: Text(address,
              style: const TextStyle(fontSize: 15, color: AppColors.textPrimary)),
        ),
      ],
    );
  }
}
