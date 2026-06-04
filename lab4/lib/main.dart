import 'package:flutter/material.dart';
import 'core_widgets_demo.dart';
import 'input_controls_demo.dart';
import 'layout_demo.dart';
import 'app_structure_demo.dart';
import 'ui_fixes_demo.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void _toggleTheme(bool value) {
    setState(() {
      _isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 4',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      
      // Pixel: Đã comment lại phần khởi chạy của các Bài 1, 2, 3 và 4
      // home: const CoreWidgetsDemo(),
      // home: const InputControlsDemo(),
      // home: const LayoutDemo(),
      // home: AppStructureDemo(
      //   isDarkMode: _isDarkMode,
      //   onThemeChanged: _toggleTheme,
      // ),

      // Pixel: Gọi màn hình của Bài 5 ra để chạy chính
      home: const UiFixesDemo(),
    );
  }
}