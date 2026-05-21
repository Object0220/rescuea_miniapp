import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_modal.dart';
import '../../widgets/task_card.dart';
import '../task/task_list_page.dart';

/// 我的查询页 - 对应小程序 home.wxml
/// 通过短链或二维码查询订单，接单
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showImgTips = true;
  Map<String, dynamic>? _taskInfo;
  String _taskId = '';
  bool _loading = false;
  String _noticeTech = '';
  bool _dialogVisible = false;
  bool _phoneVisible = false;
  Map<String, String> _formData = {
    'name': '',
    'phone': '',
    'idcard': '',
    'idcardPic': '',
    'trailerPlate': '',
  };

  @override
  void initState() {
    super.initState();
    // 模拟从外部传入taskId
  }

  Future<void> _fetchTaskInfo() async {
    if (_taskId.isEmpty) return;
    setState(() => _loading = true);
    final auth = context.read<AuthService>();
    final res = await auth.ajax('/miniapp/order/wait-accept/task-info', {
      'taskId': _taskId,
    });
    if (mounted) {
      setState(() {
        if (res['data'] != null) {
          _taskInfo = res['data'] as Map<String, dynamic>;
          _showImgTips = false;
        } else {
          _taskInfo = null;
          _showImgTips = true;
        }
        _loading = false;
      });
    }
  }

  void _acceptOrder() async {
    final auth = context.read<AuthService>();
    final res = await auth.ajax('/miniapp/user/info', {});
    if (mounted && res['status'] == 200) {
      final data = res['data'] as Map<String, dynamic>?;
      setState(() {
        _formData = {
          'name': data?['name'] as String? ?? '',
          'phone': data?['phone'] as String? ?? '',
          'idcard': data?['idcard'] as String? ?? '',
          'idcardPic': data?['idcardPic'] as String? ?? '',
          'trailerPlate': data?['trailerPlate'] as String? ?? '',
        };
        _dialogVisible = true;
      });
    }
  }

  void _handleSure() async {
    if (_formData['name']?.isEmpty ?? true) {
      _showToast('技师姓名格式错误，请检查');
      return;
    }
    if (_formData['phone']?.isEmpty ?? true) {
      _showToast('技师手机号格式错误，请检查');
      return;
    }
    if (!RegExp(r'^1[3-9]\d{9}$').hasMatch(_formData['phone'] ?? '')) {
      _showToast('技师手机号格式错误，请检查');
      return;
    }
    if ((_formData['idcard']?.length ?? 0) > 0 && _formData['idcard']?.length != 18) {
      _showToast('身份证号格式错误，请检查');
      return;
    }
    if (_formData['trailerPlate']?.isEmpty ?? true) {
      _showToast('拖车车牌格式错误，请检查');
      return;
    }

    final auth = context.read<AuthService>();
    // 先更新用户信息
    await auth.ajax('/miniapp/user/edit', _formData);
    // 再接单
    final res = await auth.ajax('/miniapp/order/wait-accept/accept-task', {
      'taskId': _taskId,
      'nodeStatus': 1,
      'operateUserId': _formData['id'],
      'longitude': '',
      'latitude': '',
    });
    if (mounted && res['status'] == 200) {
      _showToast('接单成功');
      setState(() => _dialogVisible = false);
      _fetchTaskInfo();
      // 跳转到我的任务tab
      // 通过 Navigator.pop 到主框架
    }
  }

  void _showToast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(title: const Text('SAA救援技师')),
      body: _showImgTips ? _buildImgTips() : _buildTaskInfo(),
    );
  }

  Widget _buildImgTips() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/hbg.png', width: 250),
          const SizedBox(height: 20),
          const Text('请通过短链或二维码进入查询订单',
              style: TextStyle(fontSize: 15, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildTaskInfo() {
    if (_taskInfo == null) return const SizedBox.shrink();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: TaskCard(
        task: _taskInfo!,
        showFullInfo: false,
        showAcceptButton: true,
        onNoticeTap: (notice) {
          showDialog(
            context: context,
            builder: (_) => CustomModal(
              title: '技师须知',
              topImg: 'assets/images/tips.png',
              child: Column(
                children: [
                  Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: SingleChildScrollView(
                      child: Text(notice ?? '',
                          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('我知道了'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        onExecute: _acceptOrder,
      ),
    );
  }

  // 弹窗：技师信息编辑
  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => CustomModal(
          title: '实际去执行的师傅信息',
          topImg: 'assets/images/edit.png',
          child: Column(
            children: [
              _editField('技师姓名', _formData['name'] ?? '', true, (v) {
                _formData['name'] = v;
              }),
              _editField('技师手机号', _formData['phone'] ?? '', true, (v) {
                _formData['phone'] = v;
              }, isNumber: true),
              _editField('拖车车牌', _formData['trailerPlate'] ?? '', true, (v) {
                _formData['trailerPlate'] = v;
              }),
              _editField('身份证号', _formData['idcard'] ?? '', false, (v) {
                _formData['idcard'] = v;
              }),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('取消', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _handleSure();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('确认', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _editField(String label, String value, bool required, Function(String) onChange,
      {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Row(
              children: [
                if (required)
                  const Text('*', style: TextStyle(color: AppColors.accentRed, fontSize: 14)),
                Text(label, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 33,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(6),
              ),
              child: TextField(
                controller: TextEditingController(text: value),
                keyboardType: isNumber ? TextInputType.phone : TextInputType.text,
                inputFormatters: isNumber ? [LengthLimitingTextInputFormatter(11)] : null,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                  border: InputBorder.none,
                ),
                onChanged: onChange,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
