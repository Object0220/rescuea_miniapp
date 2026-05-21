/// 工具函数集合 - 对应 miniRescuea utils/util.js

class Helpers {
  /// 数字补零
  static String formatNumber(int n) => n.toString().padLeft(2, '0');

  /// 格式化日期时间 YYYY-MM-DD HH:mm:ss
  static String formatDateTime(DateTime date) {
    return '${date.year}-${formatNumber(date.month)}-${formatNumber(date.day)} '
        '${formatNumber(date.hour)}:${formatNumber(date.minute)}:${formatNumber(date.second)}';
  }

  /// 时间戳转日期 YYYY-MM-DD
  static String timestampToDate(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${date.year}-${formatNumber(date.month)}-${formatNumber(date.day)}';
  }

  /// 格式化时间 HH:mm
  static String formatTime(DateTime date) {
    return '${formatNumber(date.hour)}:${formatNumber(date.minute)}';
  }

  /// 当前时间戳
  static int get now => DateTime.now().millisecondsSinceEpoch;

  /// 格式化手机号 xxx****xxxx
  static String maskPhone(String phone) {
    if (phone.length != 11) return phone;
    return '${phone.substring(0, 3)}****${phone.substring(7)}';
  }
}
