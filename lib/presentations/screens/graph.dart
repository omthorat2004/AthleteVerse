import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AthleteProgressScreen extends StatefulWidget {
  @override
  _AthleteProgressScreenState createState() => _AthleteProgressScreenState();
}

class _AthleteProgressScreenState extends State<AthleteProgressScreen> with SingleTickerProviderStateMixin {
  int _selectedSection = 0;
  bool _compareWithIdeal = false;

  // Sample data
  final Map<String, double> yearlyMetrics = {
    'Overall Score': 92,
    'Strength Index': 95,
    'Cardio Fitness': 88,
    'Calories Burned': 12450,
  };

  final Map<String, double> monthlyMetrics = {
    'Overall Score': 92,
    'Strength Index': 95,
    'Cardio Fitness': 88,
    'Calories Burned': 12450,
  };

  final Map<String, double> lastYearMetrics = {
    'Overall Score': 80,
    'Strength Index': 88,
    'Cardio Fitness': 78,
    'Calories Burned': 11800,
  };

  final Map<String, double> lastMonthMetrics = {
    'Overall Score': 90,
    'Strength Index': 92,
    'Cardio Fitness': 85,
    'Calories Burned': 12000,
  };

  final Map<String, double> goals = {
    'Overall Score': 95,
    'Strength Index': 98,
    'Cardio Fitness': 92,
    'Calories Burned': 13000,
  };

  // AI Suggestions
  final List<String> aiSuggestions = [
    'Your cardio fitness is improving steadily. Consider adding interval training to boost endurance.',
    'Strength training is on track. Focus on recovery to avoid injuries.',
    'Nutrition adherence is below target. Try meal prepping to stay consistent.',
    'Sleep quality needs improvement. Aim for 7-8 hours of sleep per night.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Athlete Progress Tracker'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavButton('Yearly Progress', 0),
                _buildNavButton('Monthly Progress', 1),
                _buildNavButton('Highlights', 2),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text('Compare with Ideal Athlete'),
                Switch(
                  value: _compareWithIdeal,
                  onChanged: (value) {
                    setState(() {
                      _compareWithIdeal = value;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              child: _selectedSection == 0
                  ? _buildYearlyProgress()
                  : _selectedSection == 1
                      ? _buildMonthlyProgress()
                      : _buildHighlights(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(String title, int index) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedSection = index;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedSection == index ? Colors.blue : Colors.grey[300],
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: _selectedSection == index ? Colors.white : Colors.black,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildYearlyProgress() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Yearly Progress',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Container(
            height: 300,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        String text = '';
                        switch (value.toInt()) {
                          case 0:
                            text = '2020';
                            break;
                          case 1:
                            text = '2021';
                            break;
                          case 2:
                            text = '2022';
                            break;
                          case 3:
                            text = '2023';
                            break;
                        }
                        return Text(text);
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text('${value.toInt()}');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: _compareWithIdeal
                        ? [
                            FlSpot(0, 85),
                            FlSpot(1, 88),
                            FlSpot(2, 90),
                            FlSpot(3, 92),
                          ]
                        : [
                            FlSpot(0, 80),
                            FlSpot(1, 85),
                            FlSpot(2, 88),
                            FlSpot(3, 92),
                          ],
                    isCurved: true,
                    color: _compareWithIdeal ? Colors.blue : Colors.green,
                    dotData: FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          ...yearlyMetrics.entries.map((entry) {
            String metric = entry.key;
            double currentValue = entry.value;
            double lastYearValue = lastYearMetrics[metric] ?? 0;
            double change = ((currentValue - lastYearValue) / lastYearValue * 100);
            String progress = change >= 0 ? '+${change.toStringAsFixed(1)}%' : '${change.toStringAsFixed(1)}%';
            return _buildMetricTile(
              metric,
              '$currentValue',
              progress,
              _compareWithIdeal ? '${goals[metric]}' : null,
            );
          }).toList(),
          SizedBox(height: 20),
          _buildSuggestionTile(
            'You\'re on track to meet your yearly goals. Keep up the good work!',
          ),
          SizedBox(height: 10),
          Text(
            '*Suggestions are based on video analysis.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          SizedBox(height: 20),
          _buildAIInsights(),
        ],
      ),
    );
  }

  Widget _buildMonthlyProgress() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Monthly Progress',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Container(
            height: 300,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        String text = '';
                        switch (value.toInt()) {
                          case 0:
                            text = 'Jan';
                            break;
                          case 1:
                            text = 'Feb';
                            break;
                          case 2:
                            text = 'Mar';
                            break;
                          case 3:
                            text = 'Apr';
                            break;
                        }
                        return Text(text);
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text('${value.toInt()}');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: _compareWithIdeal
                        ? [
                            FlSpot(0, 80),
                            FlSpot(1, 85),
                            FlSpot(2, 88),
                            FlSpot(3, 90),
                          ]
                        : [
                            FlSpot(0, 85),
                            FlSpot(1, 88),
                            FlSpot(2, 90),
                            FlSpot(3, 92),
                          ],
                    isCurved: true,
                    color: _compareWithIdeal ? Colors.blue : Colors.green,
                    dotData: FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          ...monthlyMetrics.entries.map((entry) {
            String metric = entry.key;
            double currentValue = entry.value;
            double lastMonthValue = lastMonthMetrics[metric] ?? 0;
            double change = ((currentValue - lastMonthValue) / lastMonthValue * 100);
            String progress = change >= 0 ? '+${change.toStringAsFixed(1)}%' : '${change.toStringAsFixed(1)}%';
            return _buildMetricTile(
              metric,
              '$currentValue',
              progress,
              _compareWithIdeal ? '${goals[metric]}' : null,
            );
          }).toList(),
          SizedBox(height: 20),
          _buildSuggestionTile(
            'You\'re improving steadily. Focus on cardio to meet your monthly goals.',
          ),
          SizedBox(height: 10),
          Text(
            '*Suggestions are based on video analysis.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          SizedBox(height: 20),
          _buildAIInsights(),
        ],
      ),
    );
  }

  Widget _buildHighlights() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Highlights',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.emoji_events, color: Colors.amber),
                      SizedBox(width: 10),
                      Text(
                        'Strengths & Achievements',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  _buildHighlightPoint(Icons.fitness_center, 'Bench Press', 'Increased by 35% this year, reaching a new personal best of 315 lbs', _compareWithIdeal ? '330 lbs' : null),
                  _buildHighlightPoint(Icons.directions_run, '5K Run Time', 'Improved by 2 minutes and 15 seconds, now at 18:45', _compareWithIdeal ? '18:00' : null),
                  _buildHighlightPoint(Icons.favorite, 'Recovery Rate', 'Heart rate recovery improved by 22%, now returning to resting rate in 2.5 minutes', _compareWithIdeal ? '2.0 mins' : null),
                  _buildHighlightPoint(Icons.emoji_events, 'Competition Results', 'Gold medal in regional championship, qualifying for nationals', _compareWithIdeal ? 'National Champion' : null),
                ],
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning, color: Colors.red),
                      SizedBox(width: 10),
                      Text(
                        'Areas for Improvement',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  _buildHighlightPoint(Icons.self_improvement, 'Flexibility', 'Below target by 15%, hamstring flexibility particularly limited', _compareWithIdeal ? 'On Target' : null),
                  _buildHighlightPoint(Icons.restaurant, 'Nutrition Adherence', 'Only following nutrition plan 65% of the time, protein intake consistently low', _compareWithIdeal ? '90% Adherence' : null),
                  _buildHighlightPoint(Icons.bedtime, 'Sleep Quality', 'Averaging only 6.2 hours per night, deep sleep phase reduced by 18%', _compareWithIdeal ? '7.5 hours' : null),
                  _buildHighlightPoint(Icons.healing, 'Injury Prevention', 'Recurring shoulder strain, preventative exercises only performed 40% of scheduled times', _compareWithIdeal ? '80% Compliance' : null),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          _buildAIInsights(),
        ],
      ),
    );
  }

  Widget _buildHighlightPoint(IconData icon, String title, String description, String? idealValue) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                if (idealValue != null && _compareWithIdeal)
                  Text(
                    'Ideal: $idealValue',
                    style: TextStyle(fontSize: 14, color: Colors.green),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile(String title, String value, String progress, String? idealValue) {
    bool isPositive = progress.contains('+');
    IconData icon = isPositive ? Icons.arrow_upward : Icons.arrow_downward;
    Color backgroundColor = isPositive ? Colors.green[50]! : Colors.red[50]!;
    Color iconColor = isPositive ? Colors.green : Colors.red;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      color: backgroundColor,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 30),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  if (idealValue != null && _compareWithIdeal)
                    Text(
                      'Ideal: $idealValue',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                      ),
                    ),
                ],
              ),
            ),
            Text(
              progress,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: iconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionTile(String suggestion) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      color: Colors.blue[50],
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          suggestion,
          style: TextStyle(fontSize: 16, color: Colors.blue[900]),
        ),
      ),
    );
  }

  Widget _buildAIInsights() {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.auto_awesome, color: Colors.purple),
                SizedBox(width: 10),
                Text(
                  'AI Insights',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10),
            ...aiSuggestions.map((suggestion) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.lightbulb_outline, color: Colors.orange),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        suggestion,
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}