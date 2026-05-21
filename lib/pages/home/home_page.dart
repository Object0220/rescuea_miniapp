import 'package:flutter/material.dart';
import '../../models/task_model.dart';
import '../../widgets/order_card.dart';
import '../mine/mine_page.dart';

/// 首页 - 任务列表页
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TaskModel> _tasks = [];
  bool _isLoading = false;


  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() => _isLoading = true);
    // TODO: 调用 API 获取任务列表
    // 模拟数据
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _isLoading = false;
      _tasks = [
        TaskModel(
          caseNo: 'SAA20260521001',
          caseTypeName: '道路救援',
          serviceTypeName: '拖车服务',
          taskStatusName: '待接单',
          customerName: '张三',
          bookTime: '2026-05-21 09:00',
          faultPlateNumber: '京A·88888',
          vinCode: 'LSVXZ...1234',
          rescueAddress: '北京市朝阳区建国路88号',
          desAddress: '北京市海淀区中关村大街1号',
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      // 自定义导航栏
      appBar: AppBar(
        title: Image.asset(
          'assets/images/ic_title_logo.svg',
          height: 28,
          errorBuilder: (_, __, ___) => const Text(
            'SAA 吉诺道路救援',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MinePage()),
              );
            },
          ),
        ],
      ),

      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              '暂无任务',
              style: TextStyle(fontSize: 16, color: Colors.grey[500]),
            ),
            const SizedBox(height: 8),
            Text(
              '请通过短链或二维码进入查询订单',
              style: TextStyle(fontSize: 13, color: Colors.grey[400]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
  await _loadTasks();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          return OrderCard(
            task: _tasks[index],
            onTap: () {
              // TODO: 跳转任务详情
            },
            onAccept: () {
              // TODO: 接单
            },
          );
        },
      ),
    );
  }
}
