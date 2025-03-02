import 'package:flutter/material.dart';

class ChecklistScreen extends StatefulWidget {
  const ChecklistScreen({Key? key}) : super(key: key);

  @override
  _ChecklistScreenState createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  final List<String> _exerciseOptions = [
    "Push-ups", "Squats", "Pull-ups", "Deadlifts", "Bench Press", "Lunges", "Planks"
  ];

  String? _selectedExercise;
  int _sets = 1;

  List<Map<String, dynamic>> exercises = [];
  bool started = false;

  void _addExercise() {
    if (_selectedExercise != null) {
      setState(() {
        exercises.add({
          'name': _selectedExercise!,
          'sets': _sets,
          'completedSets': List<bool>.filled(_sets, false),
        });

        _selectedExercise = null;
        _sets = 1;
      });
    }
  }

  void _toggleSet(int exerciseIndex, int setIndex) {
    setState(() {
      exercises[exerciseIndex]['completedSets'][setIndex] =
          !exercises[exerciseIndex]['completedSets'][setIndex];
    });
  }

  void _deleteExercise(int index) {
    setState(() {
      exercises.removeAt(index);
    });
  }

  void _startChecklist() {
    setState(() {
      started = true;
    });
  }

  void _finishChecklist() {
    bool allCompleted = exercises.every((exercise) =>
        exercise['completedSets'].every((completed) => completed));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          allCompleted ? '🎉 Workout Completed!' : '⚠️ Complete all exercises first.',
          style: const TextStyle(fontSize: 16),
        ),
        backgroundColor: allCompleted ? Colors.green : Colors.red,
      ),
    );

    if (allCompleted) {
      setState(() {
        started = false;
        exercises.clear();
      });
    }
  }

double _calculateProgress() {
  int totalSets = exercises.fold(0, (sum, item) => sum + (item['sets'] as int));
  int completedSets = exercises.fold(
      0, (sum, item) => sum + (item['completedSets'] as List<bool>).where((c) => c).length);
  
  return totalSets == 0 ? 0.0 : completedSets.toDouble() / totalSets.toDouble();
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text(
          '🏋️ Workout Checklist',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!started) ...[
              DropdownButtonFormField<String>(
                value: _selectedExercise,
                decoration: _inputDecoration('Select Exercise', Icons.fitness_center),
                items: _exerciseOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedExercise = newValue;
                  });
                },
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Number of Sets:', style: TextStyle(fontSize: 16)),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () {
                          if (_sets > 1) {
                            setState(() => _sets--);
                          }
                        },
                      ),
                      Text('$_sets', style: const TextStyle(fontSize: 18)),
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.green),
                        onPressed: () {
                          setState(() => _sets++);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 15),
              _buildPrimaryButton('➕ Add Exercise', _addExercise),
            ],
            const SizedBox(height: 20),
            Expanded(
              child: exercises.isEmpty
                  ? _emptyState()
                  : Column(
                      children: [
                        LinearProgressIndicator(
                          value: _calculateProgress(),
                          minHeight: 8,
                          backgroundColor: Colors.grey.shade300,
                          color: Colors.blue,
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                            itemCount: exercises.length,
                            itemBuilder: (context, index) {
                              return _buildExerciseCard(index);
                            },
                          ),
                        ),
                      ],
                    ),
            ),
            if (!started && exercises.isNotEmpty)
              _buildPrimaryButton('🚀 Start Workout', _startChecklist),
            if (started)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildOutlinedButton('✅ Finish Workout', _finishChecklist, Colors.blue),
                ],
              ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black54),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      prefixIcon: Icon(icon, color: Colors.blue),
      filled: true,
      fillColor: Colors.white,
    );
  }

  Widget _buildPrimaryButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 12),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 5,
          shadowColor: Colors.black26,
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildOutlinedButton(String text, VoidCallback onPressed, Color color) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color, width: 2),
        foregroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildExerciseCard(int index) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: ListTile(
        title: Text(exercises[index]['name'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text('${exercises[index]['sets']} Sets'),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _deleteExercise(index),
        ),
      ),
    );
  }

  Widget _emptyState() {
    return const Center(
      child: Text('No exercises added 🏋️\nStart building your workout!', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54, fontSize: 16)),
    );
  }
}
