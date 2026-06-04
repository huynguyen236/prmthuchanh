import 'package:flutter/material.dart';

class AppStructureDemo extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const AppStructureDemo({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 4 - App Structure'),
        actions: [
          Row(
            children: [
              const Text('Dark'),
              Switch(
                value: isDarkMode,
                onChanged: onThemeChanged,
              ),
            ],
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: const Center(
        child: Text('This is a simple screen with theme toggle.'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}