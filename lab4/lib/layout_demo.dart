import 'package:flutter/material.dart';

class LayoutDemo extends StatelessWidget {
  const LayoutDemo({super.key});

  final List<Map<String, String>> movies = const [
    {'title': 'Avatar', 'initial': 'A'},
    {'title': 'Inception', 'initial': 'I'},
    {'title': 'Interstellar', 'initial': 'I'},
    {'title': 'Joker', 'initial': 'J'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 3 - Layout Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Now Playing',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return Card(
                    elevation: 0,
                    color: Colors.grey.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    margin: const EdgeInsets.only(bottom: 12.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.indigo.shade50,
                        child: Text(
                          movie['initial']!,
                          style: TextStyle(color: Colors.indigo.shade900),
                        ),
                      ),
                      title: Text(movie['title']!),
                      subtitle: const Text('Sample description'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}