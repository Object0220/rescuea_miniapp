/// 任务执行模板模型
/// 对应 miniRescuea 的模板节点：拍照/签名/表单 等

/// 模板节点的事件类型
enum TemplateEventType {
  photo,    // 拍照
  sign,     // 签名
  form,     // 表单
}

extension TemplateEventTypeExt on TemplateEventType {
  String get label {
    switch (this) {
      case TemplateEventType.photo: return '拍照';
      case TemplateEventType.sign: return '签名';
      case TemplateEventType.form: return '表单';
    }
  }
}

/// 模板节点 — 一个执行步骤
class TemplateNode {
  final String name;
  final bool isOptional;
  final TemplateEventType eventType;
  String? imageUrl;       // 示例/参考图片
  String? uploadedImage;  // 已上传图片
  String? signData;       // 签名 base64 数据
  String? formValue;      // 表单填写值
  bool isCompleted;       // 是否已完成

  TemplateNode({
    required this.name,
    this.isOptional = false,
    this.eventType = TemplateEventType.photo,
    this.imageUrl,
    this.uploadedImage,
    this.signData,
    this.formValue,
    this.isCompleted = false,
  });

  /// 从后端 JSON 构造
  factory TemplateNode.fromJson(Map<String, dynamic> json) {
    return TemplateNode(
      name: json['name'] as String? ?? '',
      isOptional: json['optional'] == true || json['optional'] == 1,
      eventType: _parseEventType(json['eventType']),
      imageUrl: json['imgUrl']?.toString(),
      uploadedImage: json['uploadedImg']?.toString(),
    );
  }

  static TemplateEventType _parseEventType(dynamic value) {
    final int v = (value is int) ? value : int.tryParse('$value') ?? 0;
    switch (v) {
      case 0: return TemplateEventType.photo;
      case 1: return TemplateEventType.sign;
      case 2: return TemplateEventType.form;
      default: return TemplateEventType.photo;
    }
  }

  /// 检查是否已满足必填条件
  bool get isValid {
    if (isCompleted) return true;
    if (isOptional) return true;
    switch (eventType) {
      case TemplateEventType.photo:
        return uploadedImage != null && uploadedImage!.isNotEmpty;
      case TemplateEventType.sign:
        return signData != null && signData!.isNotEmpty;
      case TemplateEventType.form:
        return formValue != null && formValue!.isNotEmpty;
    }
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'optional': isOptional,
    'eventType': eventType.index,
    'imgUrl': imageUrl,
    'uploadedImg': uploadedImage,
    'signData': signData,
    'formValue': formValue,
  };
}
