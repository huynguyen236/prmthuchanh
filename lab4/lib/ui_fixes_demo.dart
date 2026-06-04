import 'package:flutter/material.dart';

class UiFixesDemo extends StatefulWidget {
  const UiFixesDemo({super.key});

  @override
  State<UiFixesDemo> createState() => _UiFixesDemoState();
}

class _UiFixesDemoState extends State<UiFixesDemo> {
  String _selectedDate = 'Open Date Picker';
  bool _isActive = false;

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked.toString().split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exercise 5 - UI Fixes')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Correct ListView inside Column using Expanded',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            SizedBox(
              height: 300,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        final letters = ['A', 'B', 'C', 'D'];
                        return ListTile(
                          leading: const Icon(Icons.movie, color: Colors.blueGrey),
                          title: Text('Movie ${letters[index]}'),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            SwitchListTile(
              title: const Text('Toggle State'),
              value: _isActive,
              onChanged: (val) {
                setState(() {
                  _isActive = val;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () => _selectDate(context),
                child: Text(_selectedDate),
              ),
            ),
            const SizedBox(height: 400),
          ],
        ),
      ),
    );
  }
}