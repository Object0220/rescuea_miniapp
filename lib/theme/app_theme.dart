import 'package:flutter/material.dart';

/// 小程序 wx-technicianrescue 的完整主题配色
class AppColors {
  // 主色
  static const Color primary = Color(0xFF446A96);

  // 强调色
  static const Color accentRed = Color(0xFFFF4419);

  // 背景色
  static const Color scaffoldBg = Color(0xFFF6F7F9);
  static const Color contentBg = Color(0xFFF7F8FA);

  // 卡片色
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color addressCardBg = Color(0xFFEEF1FD);

  // 文字色
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textWhite = Color(0xFFFFFFFF);

  // 边框
  static const Color border = Color(0xFFA9B5C4);

  // 异常背景
  static const Color errorBg = Color(0xFFFFDFE3);

  // 禁用按钮背景
  static const Color disabledBtn = Color(0xFFA9B5C4);

  // TabBar 相关
  static const Color tabBarBg = Color(0xFFF2F2F2);
}

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: false,
      scaffoldBackgroundColor: AppColors.scaffoldBg,
      primaryColor: AppColors.primary,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textWhite,
        centerTitle: true,
        elevation: 0,
      ),
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.primary,
      ),
    );
  }
}
