import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_modal.dart';
import '../history/history_list_page.dart';
import '../notice/order_notice_page.dart';
import '../notice/private_notice_page.dart';

/// 我的页 - 对应小程序 mine.wxml
class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  Map<String, dynamic>? _userInfo;
  bool _dialogVisible = false;
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
    _getUserInfo();
  }

  Future<void> _getUserInfo() async {
    final auth = context.read<AuthService>();
    if (auth.tokenInfo == null) return;
    final res = await auth.ajax('/miniapp/user/info', {});
    if (mounted && res['status'] == 200) {
      setState(() => _userInfo = res['data'] as Map<String, dynamic>?);
    }
  }

  void _updateInfo() {
    if (_userInfo == null) return;
    setState(() {
      _formData = {
        'name': _userInfo?['name'] as String? ?? '',
        'phone': _userInfo?['phone'] as String? ?? '',
        'idcard': _userInfo?['idcard'] as String? ?? '',
        'idcardPic': _userInfo?['idcardPic'] as String? ?? '',
        'trailerPlate': _userInfo?['trailerPlate'] as String? ?? '',
      };
      _dialogVisible = true;
    });
  }

  void _submitInfo() async {
    if (_formData['name']?.isEmpty ?? true) {
      _showToast('技师姓名格式错误，请检查');
      return;
    }
    if (!RegExp(r'^1[3-9]\d{9}$').hasMatch(_formData['phone'] ?? '')) {
      _showToast('技师手机号格式错误，请检查');
      return;
    }
    final auth = context.read<AuthService>();
    final res = await auth.ajax('/miniapp/user/edit', _formData);
    if (mounted && res['status'] == 200) {
      setState(() => _dialogVisible = false);
      _getUserInfo();
      _showToast('修改信息成功');
    }
  }

  void _unLogin() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('提示'),
        content: const Text('确认退出登录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthService>().logout();
            },
            child: const Text('确认'),
          ),
        ],
      ),
    );
  }

  void _login() {
    // 微信小程序使用 getPhoneNumber, Flutter app 走手机号登录或页面跳转
    Navigator.pushNamed(context, '/login');
  }

  void _showToast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(title: const Text('SAA救援技师')),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            _buildHeadCard(),
            const SizedBox(height: 18),
            _buildMenuItems(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeadCard() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const SizedBox(width: 15),
          ClipRRect(
            borderRadius: BorderRadius.circular(27),
            child: Image.asset(
              'assets/images/head.png',
              width: 54,
              height: 54,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: _userInfo == null
                ? TextButton(
                    onPressed: _login,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                    ),
                    child: const Text('登录/注册',
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_userInfo?['name'] as String? ?? '',
                          style: const TextStyle(fontSize: 18, color: Colors.white)),
                      const SizedBox(height: 5),
                      Text(_userInfo?['phone'] as String? ?? '',
                          style: const TextStyle(fontSize: 14, color: Colors.white)),
                    ],
                  ),
          ),
          if (_userInfo != null)
            GestureDetector(
              onTap: _updateInfo,
              child: Container(
                width: 74,
                height: 26,
                margin: const EdgeInsets.only(right: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(13),
                ),
                alignment: Alignment.center,
                child: const Text('修改信息',
                    style: TextStyle(fontSize: 13, color: AppColors.primary)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMenuItems() {
    return Column(
      children: [
        _menuItem('assets/images/task.png', '历史任务', () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const HistoryListPage()));
        }),
        _menuItem('assets/images/proxy.png', '用户协议', () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const OrderNoticePage()));
        }),
        _menuItem('assets/images/pwd.png', '隐私政策', () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const PrivateNoticePage()));
        }),
        if (_userInfo != null)
          _menuItem('assets/images/back.png', '退出登录', _unLogin),
        _menuItem('assets/images/proxy.png', '启动后台定位', () {
          _showToast('后台定位已启动');
        }),
      ],
    );
  }

  Widget _menuItem(String icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: ListTile(
        leading: Image.asset(icon, width: 26, height: 26),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        trailing: null,
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18),
      ),
    );
  }

  // 弹窗：编辑信息（对应小程序弹窗）
  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => CustomModal(
          title: '技师信息',
          topImg: 'assets/images/edit.png',
          child: Column(
            children: [
              _buildEditField('技师姓名', true),
              _buildEditField('技师手机号', true),
              _buildEditField('拖车车牌', false),
              _buildEditField('身份证号', false),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _submitInfo();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('确认'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditField(String label, bool required) {
    final key = <String, String>{
      '技师姓名': 'name',
      '技师手机号': 'phone',
      '拖车车牌': 'trailerPlate',
      '身份证号': 'idcard',
    }[label]!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Row(
              children: [
                if (required)
                  const Text('*', style: TextStyle(color: AppColors.accentRed)),
                Text(label, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
          Expanded(
            child: Container(
              height: 33,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(6),
              ),
              child: TextField(
                controller: TextEditingController(text: _formData[key] ?? ''),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                  border: InputBorder.none,
                ),
                onChanged: (v) => _formData[key] = v,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
