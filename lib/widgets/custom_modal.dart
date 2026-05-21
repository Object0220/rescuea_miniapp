import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// 通用弹窗 - 对应小程序 custom-modal 组件
class CustomModal extends StatelessWidget {
  final String title;
  final String? topImg;
  final Widget child;

  const CustomModal({
    super.key,
    required this.title,
    this.topImg,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 30),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (topImg != null)
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: Image.asset(topImg!, width: 50, height: 50),
              ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 15),
            child,
          ],
        ),
      ),
    );
  }
}
