import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'services/auth_service.dart';
import 'pages/task/task_list_page.dart';
import 'pages/home/home_page.dart';
import 'pages/mine/mine_page.dart';
import 'pages/login/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: const RescueaApp(),
    ),
  );
}

class RescueaApp extends StatelessWidget {
  const RescueaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SAA救援技师',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: Consumer<AuthService>(
        builder: (context, auth, _) {
          if (auth.isLoggedIn) {
            return const MainScaffold();
          }
          return const LoginPage();
        },
      ),
    );
  }
}

/// 底部主框架 - 对应小程序的 custom-tab-bar
class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    TaskListPage(),
    HomePage(),
    MinePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.tabBarBg,
          border: Border(
            top: BorderSide(color: Color(0xFFDADADA), width: 0.5),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              _buildTabItem(0, '我的任务', 'assets/images/taskbar.png', 'assets/images/taskbar_on.png'),
              _buildTabItem(1, '我的查询', 'assets/images/mine.png', 'assets/images/mine_on.png'),
              _buildTabItem(2, '我的', 'assets/images/accept.png', 'assets/images/accept_on.png'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(int index, String label, String icon, String activeIcon) {
    final isSelected = _currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                isSelected ? activeIcon : icon,
                width: 26,
                height: 26,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: isSelected ? AppColors.primary : const Color(0xFF999999),
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
