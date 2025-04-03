import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChecklistScreen extends StatefulWidget {
  const ChecklistScreen({super.key});

  @override
  _ChecklistScreenState createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  final List<String> _exerciseOptions = [
    "Push-ups", "Squats", "Pull-ups", "Deadlifts", "Bench Press", "Lunges", "Planks",
  ];
  String? _selectedExercise;
  int _sets = 1;
  int _reps = 10;
  double _weight = 0.0;
  final List<Map<String, dynamic>> _exercises = [];
  bool _isWorkoutStarted = false;
  final List<Map<String, dynamic>> _workoutHistory = [];
  final int _dailyGoal = 5; // Example daily goal: 5 exercises
  int _completedExercisesToday = 0;

  double _calculateProgress() {
    int totalSets = _exercises.fold(0, (int sum, item) => sum + (item['sets'] as int));
    int completedSets = _exercises.fold(0, (int sum, item) {
      List<bool> completed = (item['completedSets'] as List).cast<bool>();
      return sum + completed.where((c) => c).length;
    });
    return totalSets == 0 ? 0.0 : completedSets.toDouble() / totalSets.toDouble();
  }

  void _addExercise() {
    if (_selectedExercise != null) {
      setState(() {
        _exercises.add({
          'name': _selectedExercise!,
          'sets': _sets,
          'reps': _reps,
          'weight': _selectedExercise!.toLowerCase().contains('squat') || _selectedExercise!.toLowerCase().contains('plank') ? null : _weight,
          'completedSets': List<bool>.filled(_sets, false),
        });
        _selectedExercise = null;
        _sets = 1;
        _reps = 10;
        _weight = 0.0;
      });
    }
  }

  void _toggleSet(int exerciseIndex, int setIndex) {
    setState(() {
      _exercises[exerciseIndex]['completedSets'][setIndex] = !_exercises[exerciseIndex]['completedSets'][setIndex];
    });
  }

  void _deleteExercise(int index) {
    setState(() {
      _exercises.removeAt(index);
    });
  }

  void _startChecklist() {
    if (_exercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please add exercises before starting.")));
      return;
    }
    setState(() {
      _isWorkoutStarted = true;
    });
  }

  void _finishChecklist() {
    if (!_isWorkoutStarted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please start the workout first.")));
      return;
    }
    bool allCompleted = _exercises.every((exercise) => 
      (exercise['completedSets'] as List<bool>).every((completed) => completed));
    if (allCompleted) {
      setState(() {
        _workoutHistory.add({
          'date': DateTime.now(),
          'exercises': List<Map<String, dynamic>>.from(_exercises),
        });
        _completedExercisesToday += _exercises.length;
        _isWorkoutStarted = false;
        _exercises.clear();
      });
      _showWorkoutCompletionDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Complete all exercises first.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showWorkoutCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('🎉 Workout Completed!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Great job! You've completed your workout."),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: _completedExercisesToday / _dailyGoal,
                backgroundColor: Colors.grey[300],
                color: Colors.blue,
              ),
              const SizedBox(height: 8),
              Text(
                '$_completedExercisesToday / $_dailyGoal exercises completed today',
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 16),
              Text(
                _getTodaySuggestion(),
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Navigator.pop(context); // Close the current screen
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String _getTodaySuggestion() {
    if (_completedExercisesToday >= _dailyGoal) {
      return "💡 You've reached your daily goal! Keep up the great work!";
    } else {
      return "💡 You're making progress! Aim to complete your daily goal of $_dailyGoal exercises.";
    }
  }

  String _getRecommendation() {
    if (_exercises.isEmpty) return 'Add some exercises to get personalized recommendations!';
    final exercise = _exercises.last;
    if (exercise['name'].toLowerCase().contains('push-up')) {
      return '💡 Try increasing the number of reps or adding a weighted vest for more intensity!';
    } else if (exercise['name'].toLowerCase().contains('squat')) {
      return '💡 Focus on form and depth. Consider adding more sets for endurance!';
    } else if (exercise['name'].toLowerCase().contains('plank')) {
      return '💡 Increase the duration of your plank or try side planks for variety!';
    } else {
      return '💡 Try adding more sets or increasing the weight for better results!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('🏋️ Workout Checklist', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WorkoutHistoryScreen(workoutHistory: _workoutHistory)),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!_isWorkoutStarted) ...[
              DropdownButtonFormField<String>(
                value: _selectedExercise,
                decoration: _inputDecoration('Select Exercise', Icons.fitness_center),
                items: _exerciseOptions.map((String value) {
                  return DropdownMenuItem<String>(value: value, child: Text(value));
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
                  const Text('Sets:', style: TextStyle(fontSize: 16)),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () {
                          if (_sets > 1) setState(() => _sets--);
                        },
                      ),
                      Text('$_sets', style: const TextStyle(fontSize: 18)),
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.green),
                        onPressed: () => setState(() => _sets++),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Reps:', style: TextStyle(fontSize: 16)),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () {
                          if (_reps > 1) setState(() => _reps--);
                        },
                      ),
                      Text('$_reps', style: const TextStyle(fontSize: 18)),
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.green),
                        onPressed: () => setState(() => _reps++),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (_selectedExercise != null && !_selectedExercise!.toLowerCase().contains('squat') && !_selectedExercise!.toLowerCase().contains('plank'))
                TextFormField(
                  decoration: _inputDecoration('Weight (kg)', Icons.fitness_center),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      _weight = double.tryParse(value) ?? 0.0;
                    });
                  },
                ),
              const SizedBox(height: 15),
              _buildPrimaryButton('➕ Add Exercise', _addExercise),
            ],
            const SizedBox(height: 20),
            Expanded(
              child: _exercises.isEmpty
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
                            itemCount: _exercises.length,
                            itemBuilder: (context, index) {
                              return _buildExerciseCard(index);
                            },
                          ),
                        ),
                      ],
                    ),
            ),
            if (_isWorkoutStarted && _exercises.every((exercise) => 
                (exercise['completedSets'] as List<bool>).every((completed) => completed)))
              _buildPrimaryButton('✅ Finish Workout', _finishChecklist),
            if (!_isWorkoutStarted && _exercises.isNotEmpty)
              _buildPrimaryButton('🚀 Start Workout', _startChecklist),
            const SizedBox(height: 10),
            if (_exercises.isNotEmpty)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _getRecommendation(),
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ),
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
        child: Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildExerciseCard(int index) {
    final exercise = _exercises[index];
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: ListTile(
        title: Text(
          exercise['name'], 
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${exercise['sets']} Sets, ${exercise['reps']} Reps'
          '${exercise['weight'] != null ? ', ${exercise['weight']} kg' : ''}'
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _deleteExercise(index),
        ),
        onTap: () {
          if (_isWorkoutStarted) {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Mark sets as completed',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 16),
                      ...List.generate(exercise['sets'], (setIndex) {
                        return CheckboxListTile(
                          title: Text('Set ${setIndex + 1}'),
                          value: (exercise['completedSets'] as List<bool>)[setIndex],
                          onChanged: (bool? value) {
                            setState(() {
                              _toggleSet(index, setIndex);
                            });
                            Navigator.pop(context); // Close the bottom sheet
                          },
                        );
                      }),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _emptyState() {
    return const Center(
      child: Text(
        'No exercises added 🏋️\nStart building your workout!',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black54, fontSize: 16),
      ),
    );
  }
}

class WorkoutHistoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> workoutHistory;

  const WorkoutHistoryScreen({super.key, required this.workoutHistory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout History'),
        backgroundColor: Colors.blue,
      ),
      body: workoutHistory.isEmpty
          ? const Center(
              child: Text(
                'No workout history yet!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: workoutHistory.length,
              itemBuilder: (context, index) {
                final workout = workoutHistory[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ExpansionTile(
                    title: Text('Workout on ${DateFormat('MMM dd, yyyy - hh:mm a').format(workout['date'])}'),
                    children: workout['exercises'].map<Widget>((exercise) {
                      return ListTile(
                        title: Text(exercise['name']),
                        subtitle: Text(
                          '${exercise['sets']} Sets, ${exercise['reps']} Reps'
                          '${exercise['weight'] != null ? ', ${exercise['weight']} kg' : ''}'
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
    );
  }
}