import 'package:flutter/material.dart';

class InputControlsDemo extends StatefulWidget {
  const InputControlsDemo({super.key});

  @override
  State<InputControlsDemo> createState() => _InputControlsDemoState();
}

class _InputControlsDemoState extends State<InputControlsDemo> {
  double _sliderValue = 50;
  bool _isActive = false;
  String _selectedGenre = 'None';
  DateTime? _selectedDate;

  void _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 2 - Input Controls'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rating (Slider)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Slider(
              value: _sliderValue,
              min: 0,
              max: 100,
              onChanged: (value) {
                setState(() {
                  _sliderValue = value;
                });
              },
            ),
            Text('Current value: ${_sliderValue.toInt()}'),
            const SizedBox(height: 24),
            const Text(
              'Active (Switch)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: const Text('Is movie active?'),
              value: _isActive,
              contentPadding: EdgeInsets.zero,
              onChanged: (value) {
                setState(() {
                  _isActive = value;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Genre (RadioListTile)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            RadioListTile<String>(
              title: const Text('Action'),
              value: 'Action',
              groupValue: _selectedGenre,
              contentPadding: EdgeInsets.zero,
              onChanged: (value) {
                setState(() {
                  _selectedGenre = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Comedy'),
              value: 'Comedy',
              groupValue: _selectedGenre,
              contentPadding: EdgeInsets.zero,
              onChanged: (value) {
                setState(() {
                  _selectedGenre = value!;
                });
              },
            ),
            Text('Selected genre: $_selectedGenre'),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _pickDate,
                child: const Text('Open Date Picker'),
              ),
            ),
            if (_selectedDate != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text('Selected date: ${_selectedDate.toString().split(' ')[0]}'),
              ),
          ],
        ),
      ),
    );
  }
}