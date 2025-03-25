import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WearableDataPage extends StatelessWidget {
  const WearableDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Wearable Health Data'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Today's Summary Card
            _buildSummaryCard(),
            const SizedBox(height: 20),
            
            // Health Metrics Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Health Metrics',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            
            // Metrics Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildMetricCard(
                  icon: Icons.favorite,
                  value: '72',
                  unit: 'bpm',
                  label: 'Heart Rate',
                  trend: Icons.trending_up,
                  trendColor: Colors.red,
                ),
                _buildMetricCard(
                  icon: Icons.nights_stay,
                  value: '7.5',
                  unit: 'hrs',
                  label: 'Sleep',
                  trend: Icons.trending_flat,
                  trendColor: Colors.blue,
                ),
                _buildMetricCard(
                  icon: Icons.directions_walk,
                  value: '8,742',
                  unit: 'steps',
                  label: 'Activity',
                  trend: Icons.trending_up,
                  trendColor: Colors.green,
                ),
                _buildMetricCard(
                  icon: Icons.whatshot,
                  value: '1,850',
                  unit: 'cal',
                  label: 'Calories',
                  trend: Icons.trending_down,
                  trendColor: Colors.orange,
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Detailed Metrics',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            
            _buildDetailCard(
              icon: Icons.monitor_heart,
              title: 'Heart Rate History',
              data: const {
                'Current': '72 bpm',
                'Resting': '65 bpm',
                'Max Today': '120 bpm',
                'Avg Today': '78 bpm',
              },
            ),
            const SizedBox(height: 16),
            
            _buildDetailCard(
              icon: Icons.nightlight_round,
              title: 'Sleep Analysis',
              data: const {
                'Deep Sleep': '2h 15m',
                'Light Sleep': '4h 30m',
                'REM': '45m',
                'Awake': '15m',
              },
            ),
            const SizedBox(height: 16),
            
            _buildDetailCard(
              icon: Icons.directions_run,
              title: 'Activity Breakdown',
              data: const {
                'Steps': '8,742',
                'Distance': '6.2 km',
                'Active Time': '1h 45m',
                'Exercise': '35 min',
              },
            ),
          ],
        ),
      ),
    );
  }

  Card _buildSummaryCard() {
    return Card(
      color: Colors.blue[50],
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.today, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  "Today's Summary",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSummaryItem(Icons.favorite, '72', 'bpm'),
                _buildSummaryItem(Icons.nights_stay, '7.5', 'hrs'),
                _buildSummaryItem(Icons.directions_walk, '8,742', 'steps'),
              ],
            ),
            const SizedBox(height: 8),
             Text(
      'Last synced: ${DateFormat('h:mm a').format(DateTime.now())}',
      style: TextStyle(
        color: Colors.blue,
        fontSize: 12,
      ),
    ),
          ],
        ),
      ),
    );
  }

  Column _buildSummaryItem(IconData icon, String value, String unit) {
    return Column(
      children: [
        Icon(icon, size: 28, color: Colors.blue),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        Text(
          unit,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  Card _buildMetricCard({
    required IconData icon,
    required String value,
    required String unit,
    required String label,
    required IconData trend,
    required Color trendColor,
  }) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.blue.shade100, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, size: 24, color: Colors.blue),
                Icon(trend, size: 24, color: trendColor),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            Text(
              unit,
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue.shade400,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Card _buildDetailCard({
    required IconData icon,
    required String title,
    required Map<String, String> data,
  }) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.blue.shade100, width: 1),
      ),
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
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...data.entries.map((entry) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    entry.key,
                    style: TextStyle(
                      color: Colors.blue.shade800,
                    ),
                  ),
                  Text(
                    entry.value,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }
}