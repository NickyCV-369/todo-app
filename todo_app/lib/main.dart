import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'providers/todo_provider.dart';
import 'screens/home_screen.dart';
import 'screens/add_edit_todo_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _requestNotificationPermission();

  // await _requestExactAlarmPermission();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => TodoProvider()..bootstrap()),
    ],
    child: const MyApp(),
  ));
}

/// 🔔 Xin quyền thông báo
Future<void> _requestNotificationPermission() async {
  final status = await Permission.notification.status;
  if (status.isDenied) {
    final result = await Permission.notification.request();
    debugPrint("🔔 Notification permission: $result");
  }
}

Future<void> _requestExactAlarmPermission() async {
  if (await Permission.scheduleExactAlarm.isDenied) {
    await openAppSettings();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final color = const Color(0xFF6C5CE7);
    final scheme = ColorScheme.fromSeed(
      seedColor: color,
      brightness: Brightness.light,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo Realtime',
      theme: ThemeData(
        colorScheme: scheme,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F7FB),
      ),
      home: const HomeScreen(),
      routes: {
        "/add": (_) => const AddEditTodoScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == "/edit" && settings.arguments != null) {
          return MaterialPageRoute(
            builder: (_) =>
                AddEditTodoScreen(todoArg: settings.arguments),
          );
        }
        return null;
      },
    );
  }
}
