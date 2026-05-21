import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_modal.dart';
import 'package:provider/provider.dart';
import '../../utils/signature_pad.dart';

/// 任务执行页 - 对应小程序 taskPhoto.wxml
class TaskExecutePage extends StatefulWidget {
  final String taskId;
  final String orderId;
  final int? status;

  const TaskExecutePage({
    super.key,
    required this.taskId,
    required this.orderId,
    this.status,
  });

  @override
  State<TaskExecutePage> createState() => _TaskExecutePageState();
}

class _TaskExecutePageState extends State<TaskExecutePage> {
  int _processIndex = 1;
  bool _showSecondLabel = false;
  List<Map<String, dynamic>> _newNodeStatusList = [];
  List<Map<String, dynamic>> _infoList = [];
  int _selectedResultIndex = -1;
  List<Map<String, dynamic>> _resultData = [
    {'id': 1, 'name': '救援成功'},
    {'id': 2, 'name': '救援不成功'},
    {'id': 3, 'name': '取消'},
  ];
  Map<String, dynamic> _completeInfo = {'arriveMileage': '', 'trailerMileage': ''};
  String? _customerSign;
  String? _recipientSign;
  String? _dirverSign;
  bool _disabledArriveMil = false;
  bool _isTC = false;
  int _destinationFactoryIndex = -1;
  List<Map<String, dynamic>> _destinationFactoryData = [];
  String _desAddressFactoryName = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final auth = context.read<AuthService>();
    final res = await auth.ajax('/miniapp/order/execute/list', {
      'orderId': widget.orderId,
    });
    if (mounted && res['status'] == 200) {
      final data = res['data'] as Map<String, dynamic>? ?? {};
      setState(() {
        _newNodeStatusList = ((data['newNodeStatusList'] as List<dynamic>?)
                ?.map((e) => e as Map<String, dynamic>)
                .toList() ??
            []);
        _infoList = ((data['infoList'] as List<dynamic>?)
                ?.map((e) => e as Map<String, dynamic>)
                .toList() ??
            []);
        _showSecondLabel = _newNodeStatusList.length > 1;
        _isTC = data['isTC'] == true;
        _destinationFactoryData = ((data['destinationFactoryData'] as List<dynamic>?)
                ?.map((e) => e as Map<String, dynamic>)
                .toList() ??
            []);
      });
    }
  }

  void _handleSubmit(int status) {
    if (_processIndex < 3) {
      setState(() => _processIndex++);
    }
  }

  void _handleOverOrder() async {
    // 提交流程
    final auth = context.read<AuthService>();
    await auth.ajax('/miniapp/order/off/operate-info', {
      'orderId': widget.orderId,
      'arriveMileage': _completeInfo['arriveMileage'],
      'trailerMileage': _completeInfo['trailerMileage'],
      'resultId': _resultData[_selectedResultIndex]['id'],
      'customerSign': _customerSign ?? '',
      'recipientSign': _recipientSign ?? '',
      'dirverSign': _dirverSign ?? '',
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('提交成功')),
      );
      Navigator.pop(context);
    }
  }

  void _showRescueResultOptions() {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('救援结果'),
        children: _resultData.asMap().entries.map((e) {
          return SimpleDialogOption(
            onPressed: () {
              setState(() => _selectedResultIndex = e.key);
              Navigator.pop(ctx);
            },
            child: Text(e.value['name'] as String? ?? ''),
          );
        }).toList(),
      ),
    );
  }

  void _showCameraOptions(int sindex, Map<String, dynamic> childItem) {
    // 拍照/选择图片
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('选择图片方式'),
        children: [
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(ctx);
              _takePhoto(sindex, childItem);
            },
            child: const Text('拍照'),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(ctx);
              _pickGallery(sindex, childItem);
            },
            child: const Text('从相册选择'),
          ),
        ],
      ),
    );
  }

  void _takePhoto(int sindex, Map<String, dynamic> childItem) {
    // 调用相机（需集成 image_picker）
  }

  void _pickGallery(int sindex, Map<String, dynamic> childItem) {
    // 调用相册
  }

  void _handleSignature(int type) async {
    // 跳转到签名页面
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text('签名')),
          body: SignaturePad(
            onSave: (bytes) {
              // 保存签名
              Navigator.pop(context);
              setState(() {
                if (type == 0) _customerSign = 'signed';
                if (type == 1) _recipientSign = 'signed';
                if (type == 2) _dirverSign = 'signed';
              });
            },
          ),
        ),
      ),
    );
  }

  void _showDestinationOptions() {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('选择卸车目的地'),
        children: _destinationFactoryData.asMap().entries.map((e) {
          return SimpleDialogOption(
            onPressed: () {
              setState(() => _destinationFactoryIndex = e.key);
              Navigator.pop(ctx);
            },
            child: Text(e.value['name'] as String? ?? ''),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(title: const Text('任务执行')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 80),
              child: Column(
                children: [
                  _buildProgressBar(),
                  if (_processIndex != 3) _buildExecuteContent(),
                  if (_processIndex == 3) _buildCompleteContent(),
                ],
              ),
            ),
          ),
          _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Row(
        children: [
          _processDot('1', _processIndex >= 1),
          Container(
            height: 1,
            width: _showSecondLabel ? 100 : 180,
            color: AppColors.primary,
          ),
          if (_showSecondLabel) ...[
            _processDot('2', _processIndex >= 2),
            Container(height: 1, width: 100, color: AppColors.primary),
          ],
          _processDot(
            _showSecondLabel ? '3' : '2',
            _processIndex >= 3,
          ),
        ],
      ),
    );
  }

  Widget _processDot(String label, bool active) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? AppColors.primary : Colors.white,
        border: Border.all(color: AppColors.primary),
      ),
      alignment: Alignment.center,
      child: Text(label,
          style: TextStyle(
            fontSize: 12,
            color: active ? Colors.white : AppColors.primary,
          )),
    );
  }

  Widget _buildExecuteContent() {
    // 拍照上传区（简化版，匹配 taskPhoto.wxml）
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: _newNodeStatusList.map((node) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (node['showDiv'] == true)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      node['nodeStatusName'] as String? ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ...(_infoList.where((child) =>
                    child['nodeStatus'] == node['nodeStatus'] &&
                    child['templateItemId'] != null &&
                    child['eventType'] != 1))
                    .map((child) => _buildPhotoItem(child)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPhotoItem(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item['name'] != null)
            Row(
              children: [
                Container(
                  width: 3,
                  height: 14,
                  color: AppColors.primary,
                  margin: const EdgeInsets.only(right: 5),
                ),
                Text(item['name'] as String? ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    )),
              ],
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              // 示例图
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  width: 160,
                  height: 100,
                  color: const Color(0xFFE0E0E0),
                  child: item['imgUrl'] != null && (item['imgUrl'] as String).isNotEmpty
                      ? Image.network(item['imgUrl'] as String, fit: BoxFit.cover)
                      : const Icon(Icons.image, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 12),
              // 上传图
              GestureDetector(
                onTap: () => _showCameraOptions(0, item),
                child: Container(
                  width: 160,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F9F9),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: item['picUrl'] != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(item['picUrl'] as String, fit: BoxFit.cover),
                        )
                      : Center(
                          child: Image.asset('assets/images/defaultImg.png',
                              width: 60, height: 51),
                        ),
                ),
              ),
            ],
          ),
          // 输入字段
          if (item['inputType'] == 1)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: '请输入',
                  border: UnderlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCompleteContent() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 救援结果
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('救援结果', style: TextStyle(fontSize: 15)),
                GestureDetector(
                  onTap: _showRescueResultOptions,
                  child: Row(
                    children: [
                      Text(
                        _selectedResultIndex >= 0
                            ? _resultData[_selectedResultIndex]['name'] as String
                            : '请选择',
                        style: TextStyle(
                          fontSize: 15,
                          color: _selectedResultIndex >= 0
                              ? Colors.black
                              : Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey[400]),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 目的地厂名
          if (_selectedResultIndex >= 0 && _resultData[_selectedResultIndex]['id'] != 3) ...[
            if (_resultData[_selectedResultIndex]['id'] == 1 &&
                _destinationFactoryData.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFactorySelector(),
                    if (_destinationFactoryIndex >= 0 &&
                        _destinationFactoryData[_destinationFactoryIndex]['id'] == 2)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: TextField(
                          controller: TextEditingController(text: _desAddressFactoryName),
                          decoration: const InputDecoration(
                            hintText: '请输入厂名',
                            border: UnderlineInputBorder(),
                          ),
                          onChanged: (v) => _desAddressFactoryName = v,
                        ),
                      ),
                  ],
                ),
              ),
            const SizedBox(height: 24),

            // 里程输入
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                children: [
                  _mileageField('到达里程', 'arriveMileage'),
                  if (_selectedResultIndex >= 0 &&
                      _resultData[_selectedResultIndex]['id'] == 1 &&
                      _isTC)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: _mileageField('背车里程', 'trailerMileage'),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 签字
            _buildSignatures(),
          ],
        ],
      ),
    );
  }

  Widget _buildFactorySelector() {
    return GestureDetector(
      onTap: _showDestinationOptions,
      child: Row(
        children: [
          const Expanded(
            child: Text('请确认卸车目的地是否正确：',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
          ),
          Text(
            _destinationFactoryIndex >= 0
                ? _destinationFactoryData[_destinationFactoryIndex]['name'] as String
                : '请选择',
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(width: 5),
          Transform.rotate(
            angle: 1.57,
            child: const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _mileageField(String label, String key) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(label, style: const TextStyle(fontSize: 15)),
        ),
        const Spacer(),
        SizedBox(
          width: 100,
          child: TextField(
            controller: TextEditingController(text: _completeInfo[key] as String? ?? ''),
            keyboardType: TextInputType.number,
            textAlign: TextAlign.right,
            decoration: const InputDecoration(
              hintText: '请输入',
              border: UnderlineInputBorder(),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 8),
            ),
            onChanged: (v) => _completeInfo[key] = v,
          ),
        ),
        const SizedBox(width: 5),
        const Text('KM', style: TextStyle(color: AppColors.primary, fontSize: 13)),
      ],
    );
  }

  Widget _buildSignatures() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('工单签字',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 15),
          Row(
            children: [
              _signItem('客户签字', _customerSign, 0),
              _signItem('接车人签字', _recipientSign, 1),
              _signItem('技师签字', _dirverSign, 2),
            ],
          ),
        ],
      ),
    );
  }

  Widget _signItem(String label, String? signed, int type) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _handleSignature(type),
        child: Column(
          children: [
            Container(
              height: 80,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(4),
              ),
              child: signed != null
                  ? Image.asset('assets/images/icon1.png', fit: BoxFit.contain)
                  : null,
            ),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.textSecondary),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(label,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(15),
      child: SizedBox(
        width: double.infinity,
        height: 44,
        child: ElevatedButton(
          onPressed: _processIndex == 3
              ? _handleOverOrder
              : () => _handleSubmit(_processIndex == 1 ? 3 : 5),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          ),
          child: Text(
            _processIndex == 1
                ? '继续执行任务'
                : _processIndex == 2
                    ? '提交完工'
                    : '提交',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
