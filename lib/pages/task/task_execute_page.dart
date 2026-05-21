import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/template_model.dart';
import '../../models/task_model.dart';

/// 任务执行页面 — 按模板拍照/签名
class TaskExecutePage extends StatefulWidget {
  final TaskModel task;

  const TaskExecutePage({super.key, required this.task});

  @override
  State<TaskExecutePage> createState() => _TaskExecutePageState();
}

class _TaskExecutePageState extends State<TaskExecutePage> {
  List<TemplateNode> _nodes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTemplate();
  }

  Future<void> _loadTemplate() async {
    // 模拟加载模板数据
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _nodes = [
        TemplateNode(name: '到达现场拍照', eventType: TemplateEventType.photo, isOptional: false),
        TemplateNode(name: '车辆故障照片', eventType: TemplateEventType.photo, isOptional: false),
        TemplateNode(name: '车架号照片', eventType: TemplateEventType.photo, isOptional: false),
        TemplateNode(name: '客户签字确认', eventType: TemplateEventType.sign, isOptional: false),
        TemplateNode(name: '拖车照片', eventType: TemplateEventType.photo, isOptional: true),
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('执行任务')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // 任务摘要
                Container(
                  width: double.infinity,
                  color: const Color(0xFF446A96).withOpacity(0.05),
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    '${widget.task.caseNo ?? ''} · ${widget.task.customerName ?? ''}',
                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                ),

                // 模板节点列表
                Expanded(child: _buildNodeList()),

                // 底部操作栏
                _buildBottomBar(),
              ],
            ),
    );
  }

  Widget _buildNodeList() {
    final allValid = _nodes.every((n) => n.isValid);
    final completedCount = _nodes.where((n) => n.isCompleted).length;

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _nodes.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              '执行进度: $completedCount/${_nodes.length}',
              style: TextStyle(
                fontSize: 13,
                color: allValid ? Colors.green : Colors.orange,
              ),
            ),
          );
        }
        final node = _nodes[index - 1];
        return _buildNodeCard(node, index - 1);
      },
    );
  }

  Widget _buildNodeCard(TemplateNode node, int index) {
    final isRequired = !node.isOptional;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => _handleNodeTap(node),
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // 状态图标
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: node.isCompleted
                      ? Colors.green.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  node.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: node.isCompleted ? Colors.green : Colors.grey,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),

              // 节点信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          node.name,
                          style: const TextStyle(fontSize: 15),
                        ),
                        if (isRequired) ...[
                          const SizedBox(width: 4),
                          const Text('*必传', style: TextStyle(
                            fontSize: 11, color: Colors.red,
                          )),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      node.eventType.label,
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),

              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    final allValid = _nodes.every((n) => n.isValid);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: allValid ? _submitTask : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: allValid ? Colors.green : Colors.grey,
              disabledBackgroundColor: Colors.grey[300],
            ),
            child: Text(
              allValid ? '提交任务' : '请完成所有必填项',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  void _handleNodeTap(TemplateNode node) {
    if (node.isCompleted) {
      // 已完成的可以查看
      _previewNode(node);
      return;
    }

    switch (node.eventType) {
      case TemplateEventType.photo:
        _showImagePicker(node);
        break;
      case TemplateEventType.sign:
        _showSignaturePad(node);
        break;
      case TemplateEventType.form:
        _showFormDialog(node);
        break;
    }
  }

  Future<void> _showImagePicker(TemplateNode node) async {
    final picker = ImagePicker();
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('选择图片'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('拍照'),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('相册选取'),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    try {
      final file = await picker.pickImage(source: source, maxWidth: 1920);
      if (file != null) {
        setState(() {
          node.uploadedImage = file.path;
          node.isCompleted = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('拍照失败: $e')),
        );
      }
    }
  }

  void _showSignaturePad(TemplateNode node) {
    // 简化版签名预览
    setState(() {
      node.signData = 'mock_signature_base64';
      node.isCompleted = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('签名完成（完整签名组件待接入）')),
    );
  }

  void _showFormDialog(TemplateNode node) {
    final controller = TextEditingController(text: node.formValue);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(node.name),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: '请输入...',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                node.formValue = controller.text;
                node.isCompleted = controller.text.isNotEmpty;
              });
              Navigator.pop(ctx);
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _previewNode(TemplateNode node) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('预览: ${node.name}）')),
    );
  }

  void _submitTask() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop(); // 关 loading
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('提交成功'),
            content: const Text('任务已提交，感谢您的服务！'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.of(context).popUntil((r) => r.isFirst);
                },
                child: const Text('返回首页'),
              ),
            ],
          ),
        );
      }
    });
  }
}
