import 'dart:async';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:myapp/providers/user_provider.dart';
import 'package:provider/provider.dart' show Provider, ReadContext;

class ChecklistScreen extends StatefulWidget {
  const ChecklistScreen({super.key});

  @override
  ChecklistScreenState createState() => ChecklistScreenState();
}

class ChecklistScreenState extends State<ChecklistScreen> {
  String _selectedExercise = "";
  int _sets = 1;
  int _reps = 10;
  double _weight = 0.0;
  final List<Map<String, dynamic>> _exercises = [];
  bool _isWorkoutStarted = false;
  final List<Map<String, dynamic>> _workoutHistory = [];
  int _dailyGoal = 5;
  final TextEditingController _exerciseController = TextEditingController();
  int _completedExercisesToday = 0;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadExercises();
  }

  @override
  void dispose() {
    _exerciseController.dispose();
    super.dispose();
  }

  double _calculateProgress() {
    int totalSets = _exercises.fold(
      0,
      (int sum, item) => sum + (item['sets'] as int),
    );
    int completedSets = _exercises.fold(0, (int sum, item) {
      List<bool> completed = (item['completedSets'] as List).cast<bool>();
      return sum + completed.where((c) => c).length;
    });
    return totalSets == 0
        ? 0.0
        : completedSets.toDouble() / totalSets.toDouble();
  }

  void _addExercise() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _exercises.add({
          'name': _selectedExercise,
          'sets': _sets,
          'reps': _reps,
          'weight': _weight,
          'completedSets': List<bool>.filled(_sets, false),
        });
        _saveExercises();
      });
    }
  }

  void _toggleSet(int exerciseIndex, int setIndex) {
    setState(() {
      _exercises[exerciseIndex]['completedSets'][setIndex] =
          !_exercises[exerciseIndex]['completedSets'][setIndex];
    });
  }

  void _deleteExercise(int index) {
    setState(() {
      _exercises.removeAt(index);
    });
  }

  void _startChecklist() {
    if (_exercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please add exercises before starting.")),
      );
      return;
    }
    setState(() {
      _isWorkoutStarted = true;
    });
  }

  void _finishChecklist() {
    if (!_isWorkoutStarted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please start the workout first.")),
      );
      return;
    }
    bool allCompleted = _exercises.every(
      (exercise) => (exercise['completedSets'] as List<bool>).every(
        (completed) => completed,
      ),
    );
    if (allCompleted) {
      _saveWorkoutData();
      setState(() {
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

  void _setDailyGoal(int goal) {
    setState(() {
      _dailyGoal = goal;
    });
  }

  void _editDailyGoal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Set Daily Goal'),
          content: TextFormField(
            keyboardType: TextInputType.number,
            initialValue: _dailyGoal.toString(),
            onChanged: (value) {
              setState(() {
                _setDailyGoal(int.tryParse(value) ?? 5);
              });
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                _saveDailyGoal();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
                _getTodaySuggestion(),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _completedExercisesToday >= _dailyGoal
                    ? "Congratulations you have completed your daily goal"
                    : "You have not completed your daily goal",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
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
      return "You've reached your daily goal! Keep up the great work!";
    } else {
      return '$_completedExercisesToday / $_dailyGoal exercises completed today';
    }
  }

  String _getRecommendation() {
    if (_exercises.isEmpty) {
      return 'Add some exercises to get personalized recommendations!';
    }
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
        title: const Text(
          '🏋️ Workout Checklist',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _editDailyGoal(),
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          WorkoutHistoryScreen(workoutHistory: _workoutHistory),
                ),
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
                decoration: _inputDecoration('Daily Goal', Icons.flag),
                value: _dailyGoal.toString(),
                items:
                    <String>[
                      '1',
                      '2',
                      '3',
                      '4',
                      '5',
                      '6',
                      '7',
                      '8',
                      '9',
                      '10',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _dailyGoal = int.parse(newValue!);
                  });
                },
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text('Sets:', style: TextStyle(fontSize: 16)),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.remove_circle,
                          color: Colors.red,
                        ),
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
              Form(
                key: _formKey,
                child: TextFormField(
                  decoration: _inputDecoration(
                    'Exercise Name',
                    Icons.fitness_center,
                  ),
                  controller: _exerciseController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter exercise name';
                    }
                    _selectedExercise = value;
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Reps:', style: TextStyle(fontSize: 16)),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.remove_circle,
                          color: Colors.red,
                        ),
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
              if (_selectedExercise.isNotEmpty)
                TextFormField(
                  decoration: _inputDecoration(
                    'Weight (kg)',
                    Icons.fitness_center,
                  ),
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
              child:
                  _exercises.isEmpty
                      ? _emptyState()
                      : Column(
                        children: [
                          const SizedBox(height: 16),
                          LinearProgressIndicator(
                            value:
                                _completedExercisesToday.toDouble() /
                                _dailyGoal.toDouble(),
                            backgroundColor: Colors.grey[300],
                            minHeight: 10,
                            color: Colors.blue,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _getTodaySuggestion(),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
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
            if (_isWorkoutStarted &&
                _exercises.every(
                  (exercise) => (exercise['completedSets'] as List<bool>).every(
                    (completed) => completed,
                  ),
                ))
              _buildPrimaryButton('✅ Complete Workout', _finishChecklist),
            if (!_isWorkoutStarted && _exercises.isNotEmpty)
              _buildPrimaryButton('🚀 Start Workout', _startChecklist),
            const SizedBox(height: 10),
            if (_exercises.isNotEmpty)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
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
          '${exercise['weight'] != null ? ', ${exercise['weight']} kg' : ''}',
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
                          value:
                              (exercise['completedSets']
                                  as List<bool>)[setIndex],
                          onChanged: (bool? value) {
                            setState(() {
                              _toggleSet(index, setIndex);
                            });
                            Navigator.pop(context);
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

  Future<void> _loadUserData() async {
    String userEmail = getCurrentUserEmail(context);
    try {
      DocumentSnapshot goalSnapshot =
          await FirebaseFirestore.instance
              .collection('goals')
              .doc(userEmail)
              .get();
      if (goalSnapshot.exists) {
        setState(() {
          _dailyGoal = goalSnapshot.get('dailyGoal');
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<void> _loadExercises() async {
    String userEmail = getCurrentUserEmail(context);
    try {
      DocumentSnapshot exerciseSnapshot =
          await FirebaseFirestore.instance
              .collection('exercises')
              .doc(userEmail)
              .get();
      if (exerciseSnapshot.exists) {
        List<dynamic> exerciseList = exerciseSnapshot.get('exercises');
        setState(() {
          _exercises.addAll(
            exerciseList.map((exerciseName) {
              return {
                'name': exerciseName,
                'sets': 1,
                'reps': 10,
                'weight': 0.0,
                'completedSets': List<bool>.filled(1, false),
              };
            }),
          );
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading exercises: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveExercises() async {
    String userEmail = getCurrentUserEmail(context);
    try {
      List<String> exerciseNames =
          _exercises.map((e) => e['name'] as String).toList();
      await FirebaseFirestore.instance
          .collection('exercises')
          .doc(userEmail)
          .set({'exercises': exerciseNames});
    } catch (e) {
      print('Error saving exercises: $e');
    }
  }

  Future<void> _saveDailyGoal() async {
    String userEmail = getCurrentUserEmail(context);
    try {
      await FirebaseFirestore.instance.collection('goals').doc(userEmail).set({
        'dailyGoal': _dailyGoal,
      });
    } catch (e) {
      print('Error saving daily goal: $e');
    }
  }

  Future<void> _saveWorkoutData() async {
    String userEmail = getCurrentUserEmail(context);
    try {
      await FirebaseFirestore.instance.collection('workouts').add({
        'userId': userEmail,
        'date': Timestamp.now(),
        'exercises': _exercises,
        'completed': true,
      });
      _completedExercisesToday = 0;
    } catch (e) {
      print('Error saving workout data: $e');
    }
  }
}

String getCurrentUserEmail(BuildContext context) {
  try {
    final userProvider = context.read<UserProvider>();
    if (userProvider.user == null || userProvider.user?.email == null) {
      throw Exception('User not logged in');
    }
    return userProvider.user!.email!;
  } catch (e) {
    print('Error getting user email: $e');

    return '';
  }
}

class WorkoutHistoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> workoutHistory;

  const WorkoutHistoryScreen({super.key, required this.workoutHistory});

  String getCurrentUserEmail(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return userProvider.user?.email ?? "demo@gmail.com";
  }

  Stream<List<Map<String, dynamic>>> _getWorkoutHistory(BuildContext context) {
    String userEmail = getCurrentUserEmail(context);
    return FirebaseFirestore.instance
        .collection('workouts')
        .where('userId', isEqualTo: userEmail)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout History'),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _getWorkoutHistory(context),
        builder: (
          BuildContext context,
          AsyncSnapshot<List<Map<String, dynamic>>> snapshot,
        ) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No workout history yet!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          List<Map<String, dynamic>> workouts = snapshot.data!;
          return ListView.builder(
            itemCount: workouts.length,
            itemBuilder: (context, index) {
              final workout = workouts[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ExpansionTile(
                  title: Text(
                    'Workout on ${DateFormat('MMM dd, yyyy - hh:mm a').format(workout['date'].toDate())}',
                  ),
                  children: List<Widget>.from(
                    workout['exercises'].map((exercise) {
                      return ListTile(
                        title: Text(exercise['name']),
                        subtitle: Text(
                          '${exercise['sets']} Sets, ${exercise['reps']} Reps'
                          '${exercise['weight'] != null ? ', ${exercise['weight']} kg' : ''}',
                        ),
                      );
                    }),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
