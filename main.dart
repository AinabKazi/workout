import 'package:flutter/material.dart';

void main() {
  runApp(const LogWorkoutApp());
}

class LogWorkoutApp extends StatelessWidget {
  const LogWorkoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LogWorkoutForm(),
    );
  }
}

class LogWorkoutForm extends StatefulWidget {
  const LogWorkoutForm({super.key});

  @override
  _LogWorkoutFormState createState() => _LogWorkoutFormState();
}

class _LogWorkoutFormState extends State<LogWorkoutForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers to handle input
  final TextEditingController _repsController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  String? _exerciseType; // It's nullable, so we need to handle this carefully

  // Validation logic
  String? _validateReps(String? value) {
    if (value == null ||
        value.isEmpty ||
        int.tryParse(value) == null ||
        int.parse(value) <= 0) {
      return 'Please enter valid reps';
    }
    return null;
  }

  String? _validateDuration(String? value) {
    if (value == null ||
        value.isEmpty ||
        int.tryParse(value) == null ||
        int.parse(value) <= 0) {
      return 'Please enter valid duration';
    }
    return null;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // If the form is valid, display a summary
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Workout Summary'),
          content: Text(
            'Exercise Type: ${_exerciseType ?? 'Not Selected'}\n'
            'Reps: ${_repsController.text}\n'
            'Duration: ${_durationController.text} minutes',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log Workout')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Exercise Type'),
                items: ['Weightlifting', 'Cardio', 'Yoga']
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _exerciseType = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select an exercise type' : null,
              ),
              TextFormField(
                controller: _repsController,
                decoration: const InputDecoration(labelText: 'Number of Reps'),
                keyboardType: TextInputType.number,
                validator: _validateReps,
              ),
              TextFormField(
                controller: _durationController,
                decoration:
                    const InputDecoration(labelText: 'Duration (minutes)'),
                keyboardType: TextInputType.number,
                validator: _validateDuration,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
