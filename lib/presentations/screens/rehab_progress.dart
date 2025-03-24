import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RehabProgressPage extends StatelessWidget {
  const RehabProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Rehabilitation Progress Tracker'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Overall Progress Card
            _buildOverallProgressCard(),
            const SizedBox(height: 20),
            
            // Therapy Sessions Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Therapy Sessions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            
            // Therapy Session Cards
            _buildTherapySessionCard(
              icon: Icons.fitness_center,
              title: 'Physical Therapy',
              compliance: 100,
              completed: 12,
              total: 16,
              lastSession: DateTime(2025, 3, 13),
            ),
            const SizedBox(height: 16),
            
            _buildTherapySessionCard(
              icon: Icons.directions_run,
              title: 'Strength Training',
              compliance: 80,
              completed: 8,
              total: 12,
              lastSession: DateTime(2025, 3, 13),
            ),
            const SizedBox(height: 16),
            
            _buildTherapySessionCard(
              icon: Icons.directions_walk,
              title: 'Mobility Work',
              compliance: 100,
              completed: 14,
              total: 14,
              lastSession: DateTime(2025, 3, 13),
            ),
            const SizedBox(height: 16),
            
            _buildTherapySessionCard(
              icon: Icons.medical_services,
              title: 'Pain Management',
              compliance: 75,
              completed: 6,
              total: 8,
              lastSession: DateTime(2025, 3, 13),
            ),
          ],
        ),
      ),
    );
  }

  Card _buildOverallProgressCard() {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(Icons.assessment, size: 24, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Overall Recovery Progress',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 120,
                  width: 120,
                  child: CircularProgressIndicator(
                    value: 0.78,
                    strokeWidth: 12,
                    backgroundColor: Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                ),
                const Text(
                  '78%',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Great progress! Keep it up!',
              style: TextStyle(
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Card _buildTherapySessionCard({
    required IconData icon,
    required String title,
    required int compliance,
    required int completed,
    required int total,
    required DateTime lastSession,
  }) {
    final dateFormat = DateFormat('MMMM d, y');
    final complianceColor = compliance >= 90
        ? Colors.green
        : compliance >= 75
            ? Colors.orange
            : Colors.red;

    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 24, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  '$compliance% Compliance',
                  style: TextStyle(
                    color: complianceColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  'Sessions Completed: $completed of $total',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: LinearProgressIndicator(
                value: completed / total,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  compliance >= 90
                      ? Colors.green
                      : compliance >= 75
                          ? Colors.orange
                          : Colors.red,
                ),
                minHeight: 10,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Last session: ${dateFormat.format(lastSession)}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}