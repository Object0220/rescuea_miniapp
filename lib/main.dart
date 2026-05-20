import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'pages/home/home_page.dart';
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
      title: 'SAA吉诺道路救援',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF446A96),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF446A96),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 1,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF446A96),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        useMaterial3: false,
      ),
      initialRoute: '/',
      routes: {
        // 后续页面路由在此扩展
        // '/taskDetail': (context) => const TaskDetailPage(),
        // '/taskExecute': (context) => const TaskExecutePage(),
        // '/history': (context) => const HistoryListPage(),
        // '/about': (context) => const AboutPage(),
      },
      home: Consumer<AuthService>(
        builder: (context, auth, _) {
          if (auth.isLoggedIn) {
            return const HomePage();
          }
          return const LoginPage();
        },
      ),
    );
  }
}
