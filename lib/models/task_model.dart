/// 任务状态枚举
enum TaskStatus {
  pendingAccept,    // 待接单
  accepted,         // 已接单
  enRoute,          // 前往途中
  arrived,          // 已到达
  inProgress,       // 执行中
  completed,        // 已完成
  cancelled,        // 已取消
}

/// 任务状态值映射
extension TaskStatusExtension on TaskStatus {
  String get label {
    switch (this) {
      case TaskStatus.pendingAccept: return '待接单';
      case TaskStatus.accepted: return '已接单';
      case TaskStatus.enRoute: return '前往途中';
      case TaskStatus.arrived: return '已到达';
      case TaskStatus.inProgress: return '执行中';
      case TaskStatus.completed: return '已完成';
      case TaskStatus.cancelled: return '已取消';
    }
  }
}

/// 救援任务模型
class TaskModel {
  final String? taskId;
  final String? caseNo;           // 案件编号
  final String? caseTypeName;      // 案件类型
  final String? serviceTypeName;   // 服务类型
  final String? taskStatusName;    // 任务状态名称
  final TaskStatus? taskStatus;    // 任务状态
  final String? orderChargeModeName; // 收费模式
  final String? customerName;      // 客户名称
  final String? orderTypeName;     // 订单类型
  final String? bookTime;          // 预约时间
  final String? faultPlateNumber;  // 车牌号
  final String? vinCode;           // 车架号
  final String? roadFeeName;       // 背车路桥费
  final int? smallWheelNum;        // 小轮数
  final String? freeTrailerMileage; // 免拖里程
  final String? beyondKilometerPrice; // 超公里价格
  final String? rescueAddress;     // 救援地址
  final String? desAddress;        // 目的地地址
  final String? agentLine;         // 客服电话
  final String? customerPhone;     // 客户电话
  final double? rescueLat;         // 救援纬度
  final double? rescueLng;         // 救援经度

  TaskModel({
    this.taskId,
    this.caseNo,
    this.caseTypeName,
    this.serviceTypeName,
    this.taskStatusName,
    this.taskStatus,
    this.orderChargeModeName,
    this.customerName,
    this.orderTypeName,
    this.bookTime,
    this.faultPlateNumber,
    this.vinCode,
    this.roadFeeName,
    this.smallWheelNum,
    this.freeTrailerMileage,
    this.beyondKilometerPrice,
    this.rescueAddress,
    this.desAddress,
    this.agentLine,
    this.customerPhone,
    this.rescueLat,
    this.rescueLng,
  });

  /// 从 JSON 构造
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      taskId: json['taskId']?.toString(),
      caseNo: json['caseNo']?.toString(),
      caseTypeName: json['caseTypeName']?.toString(),
      serviceTypeName: json['serviceTypeName']?.toString(),
      taskStatusName: json['taskStatusName']?.toString(),
      orderChargeModeName: json['orderChargeModeName']?.toString(),
      customerName: json['customerName']?.toString(),
      orderTypeName: json['orderTypeName']?.toString(),
      bookTime: json['bookTime']?.toString(),
      faultPlateNumber: json['faultPlateNumber']?.toString(),
      vinCode: json['vinCode']?.toString(),
      roadFeeName: json['roadFeeName']?.toString(),
      smallWheelNum: json['smallWheelNum'],
      freeTrailerMileage: json['freeTrailerMileage']?.toString(),
      beyondKilometerPrice: json['beyondKilometerPrice']?.toString(),
      rescueAddress: json['rescueAddress']?.toString(),
      desAddress: json['desAddress']?.toString(),
      agentLine: json['agentLine']?.toString(),
      customerPhone: json['customerPhone']?.toString(),
      rescueLat: (json['rescueLat'] as num?)?.toDouble(),
      rescueLng: (json['rescueLng'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'taskId': taskId,
    'caseNo': caseNo,
    'caseTypeName': caseTypeName,
    'serviceTypeName': serviceTypeName,
    'taskStatusName': taskStatusName,
    'orderChargeModeName': orderChargeModeName,
    'customerName': customerName,
    'orderTypeName': orderTypeName,
    'bookTime': bookTime,
    'faultPlateNumber': faultPlateNumber,
    'vinCode': vinCode,
    'roadFeeName': roadFeeName,
    'smallWheelNum': smallWheelNum,
    'freeTrailerMileage': freeTrailerMileage,
    'beyondKilometerPrice': beyondKilometerPrice,
    'rescueAddress': rescueAddress,
    'desAddress': desAddress,
    'agentLine': agentLine,
    'customerPhone': customerPhone,
    'rescueLat': rescueLat,
    'rescueLng': rescueLng,
  };
}
