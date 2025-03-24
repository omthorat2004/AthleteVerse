import 'package:flutter/material.dart';

class RehabExercisesScreen extends StatelessWidget {
  const RehabExercisesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Rehab Exercises',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue[800],
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Doctor & Physiotherapist Recommendations',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'AI-powered suggestion tool that provides rehab plans and specialist referrals.',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  height: 1.4),
            ),
            const SizedBox(height: 24),
            const Divider(height: 1, thickness: 1),
            const SizedBox(height: 16),
            const Text(
              'Recommendations',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: _recommendations
                  .map((rec) => _buildRecommendationCard(
                        rec['title']!,
                        rec['description']!,
                        rec['priority']!,
                        rec['doctorName']!,
                        rec['specialty']!,
                        rec['date']!,
                      ))
                  .toList(),
            ),
            const SizedBox(height: 24),
            const Divider(height: 1, thickness: 1),
            const SizedBox(height: 16),
            const Text(
              'Recovery Exercises',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: _exercises
                  .map((exercise) => _buildRecoveryExerciseCard(
                        exercise['name']!,
                        exercise['target']!,
                        exercise['sets']!,
                        exercise['reps']!,
                        exercise['frequency']!,
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationCard(
    String title,
    String description,
    String priority,
    String doctorName,
    String specialty,
    String date,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      shadowColor: Colors.blue.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.medical_services, 
                      color: Colors.blueAccent, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                            fontSize: 18, 
                            fontWeight: FontWeight.bold,
                            height: 1.3),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'By $doctorName',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: priority == 'High'
                        ? Colors.red[50]
                        : Colors.green[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    priority,
                    style: TextStyle(
                        color: priority == 'High'
                            ? Colors.red[800]
                            : Colors.green[800],
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[800],
                  height: 1.5),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Specialty',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600])),
                      Text(specialty,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600])),
                      Text(date,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.chat_outlined, size: 18),
                    label: const Text('Message'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blueAccent,
                      side: const BorderSide(color: Colors.blueAccent),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                )),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.call_outlined, size: 18),
                    label: const Text('Call'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green,
                      side: const BorderSide(color: Colors.green),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                )),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.article_outlined, size: 18),
                    label: const Text('Report'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.purple,
                      side: const BorderSide(color: Colors.purple),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                 ) ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecoveryExerciseCard(
    String exerciseName,
    String target,
    String sets,
    String reps,
    String frequency,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      shadowColor: Colors.blue.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.fitness_center,
                      color: Colors.orangeAccent, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exerciseName,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            height: 1.3),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Target: $target',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Sets',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600])),
                      Text(sets,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Reps',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600])),
                      Text(reps,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Frequency',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600])),
                      Text(frequency,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.play_circle_outline, size: 20),
                label: const Text('Watch Demonstration',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
            )),
          ],
        ),
      ),
    );
  }
}

final List<Map<String, String>> _recommendations = [
  {
    'title': 'Modify shoulder exercises',
    'description':
        'Replace overhead presses with lateral raises to reduce strain on rotator cuff. This modification will help prevent further injury while maintaining muscle engagement.',
    'priority': 'High',
    'doctorName': 'Dr. Sarah Johnson',
    'specialty': 'Sports Medicine',
    'date': 'Mar 12, 2025'
  },
  {
    'title': 'Reduce knee stress',
    'description': 'Switch from deep squats to partial squats (45-60 degree knee flexion) for knee safety. This modification reduces patellofemoral joint stress while maintaining quadriceps activation.',
    'priority': 'Medium',
    'doctorName': 'Dr. Amit Verma',
    'specialty': 'Orthopedic Specialist',
    'date': 'Mar 15, 2025'
  }
];

final List<Map<String, String>> _exercises = [
  {
    'name': 'Rotator Cuff External Rotation',
    'target': 'Shoulder stabilization',
    'sets': '3',
    'reps': '12-15',
    'frequency': 'Daily'
  },
  {
    'name': 'Quad Strengthening',
    'target': 'Knee rehabilitation',
    'sets': '3',
    'reps': '15',
    'frequency': 'Alternate Days'
  }
];