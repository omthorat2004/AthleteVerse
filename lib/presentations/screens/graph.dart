import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class AthleteProgressScreen extends StatefulWidget {
  const AthleteProgressScreen({Key? key}) : super(key: key);

  @override
  _AthleteProgressScreenState createState() => _AthleteProgressScreenState();
}

class _AthleteProgressScreenState extends State<AthleteProgressScreen> {
  String selectedGraphType = "Daily";
  String selectedExercise = "Squats"; 

  final List<String> graphTypes = ["Daily", "Weekly", "Monthly", "Yearly"];
  final List<String> exerciseTypes = ["Squats", "Bench Press", "Deadlifts", "Pull-ups"];

  final Map<String, List<int>> athleteData = {
    'Squats': [200, 220, 180, 260, 280, 300, 320],
    'Bench Press': [160, 140, 200, 220, 240, 260, 280],
    'Deadlifts': [220, 240, 260, 280, 300, 320, 340],
    'Pull-ups': [50, 55, 40, 60, 70, 75, 80],
  };

  final Map<String, List<int>> idealPerformance = {
    'Squats': [250, 270, 230, 300, 320, 340, 360],
    'Bench Press': [180, 160, 220, 240, 260, 280, 300],
    'Deadlifts': [250, 270, 290, 310, 330, 350, 370],
    'Pull-ups': [60, 65, 50, 70, 80, 85, 90],
  };

  List<String> getXAxisLabels() {
    switch (selectedGraphType) {
      case "Daily":
        return ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
      case "Weekly":
        return ["Week 1", "Week 2", "Week 3", "Week 4"];
      case "Monthly":
        return ["Jan", "Feb", "Mar", "Apr", "May", "Jun"];
      case "Yearly":
        return ["2020", "2021", "2022", "2023", "2024"];
      default:
        return [];
    }
  }

  List<int> getFilteredData(String exercise) {
    switch (selectedGraphType) {
      case "Daily":
        return athleteData[exercise]!.sublist(0, 7);
      case "Weekly":
        return athleteData[exercise]!.sublist(0, 4);
      case "Monthly":
        return athleteData[exercise]!.sublist(0, 6);
      case "Yearly":
        return athleteData[exercise]!.sublist(0, 5);
      default:
        return [];
    }
  }

  String getRecommendation() {
    int avgPerformance = getFilteredData(selectedExercise).reduce((a, b) => a + b) ~/
        getFilteredData(selectedExercise).length;
    int idealAvg = idealPerformance[selectedExercise]!.reduce((a, b) => a + b) ~/
        idealPerformance[selectedExercise]!.length;

    if (avgPerformance >= idealAvg * 0.9) {
      return "🔥 Great job! You're close to the ideal performance.";
    } else if (avgPerformance >= idealAvg * 0.7) {
      return "👍 You're improving, keep pushing!";
    } else {
      return "⚠️ Try to increase strength and endurance.";
    }
  }

  Widget _buildGraph(String exercise, List<int> values, List<int> idealValues) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "$exercise Performance",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  barGroups: List.generate(values.length, (index) {
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: values[index].toDouble(),
                          color: Colors.blue, 
                          width: 12,
                        ),
                        BarChartRodData(
                          toY: idealValues[index].toDouble(),
                          color: Colors.green, 
                          width: 12,
                        ),
                      ],
                    );
                  }),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(getXAxisLabels()[value.toInt()],
                              style: const TextStyle(fontSize: 12));
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _changeGraphType(String type) {
    setState(() {
      selectedGraphType = type;
    });
  }

  void _changeExercise(String exercise) {
    setState(() {
      selectedExercise = exercise;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Athlete Performance"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DropdownButton<String>(
                  value: selectedGraphType,
                  items: graphTypes
                      .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) _changeGraphType(value);
                  },
                ),
                DropdownButton<String>(
                  value: selectedExercise,
                  items: exerciseTypes
                      .map((exercise) => DropdownMenuItem(value: exercise, child: Text(exercise)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) _changeExercise(value);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildGraph(
                  selectedExercise,
                  getFilteredData(selectedExercise),
                  idealPerformance[selectedExercise]!,
                ),
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          "🏋️ Performance Recommendation",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          getRecommendation(),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
