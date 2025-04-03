import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:video_player/video_player.dart';

class InjuryRiskPredictionPage extends StatefulWidget {
  final AthleteProfile athlete;

  const InjuryRiskPredictionPage({super.key, required this.athlete});

  @override
  _InjuryRiskPredictionPageState createState() => _InjuryRiskPredictionPageState();
}

class _InjuryRiskPredictionPageState extends State<InjuryRiskPredictionPage> {
  late VideoPlayerController _videoController;
  int _selectedBodyPart = -1;
  final bool _showDetails = false;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset('assets/prevention_exercise.mp4')
      ..initialize().then((_) => setState(() {}));
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Injury Risk Prediction'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareReport(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Athlete Profile Header
            _buildProfileHeader(),
            const SizedBox(height: 20),

            // 2. Risk Score Summary
            _buildRiskScoreCard(),
            const SizedBox(height: 20),

            // 3. Body Heatmap
            _buildBodyHeatmap(),
            const SizedBox(height: 20),

            // 4. Key Metrics
            _buildKeyMetrics(),
            const SizedBox(height: 20),

            // 5. Injury Predictions
            _buildInjuryPredictions(),
            const SizedBox(height: 20),

            // 6. Prevention Recommendations
            _buildPreventionRecommendations(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(widget.athlete.photoUrl),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.athlete.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              '${widget.athlete.sport} • ${widget.athlete.position}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            Text(
              'Last assessed: ${widget.athlete.lastAssessment}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRiskScoreCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'INJURY RISK SCORE',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    value: widget.athlete.riskScore / 100,
                    strokeWidth: 12,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getRiskColor(widget.athlete.riskScore),
                    ),
                )),
                Column(
                  children: [
                    Text(
                      '${widget.athlete.riskScore}%',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _getRiskLevel(widget.athlete.riskScore),
                      style: TextStyle(
                        color: _getRiskColor(widget.athlete.riskScore),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _getRiskMessage(widget.athlete.riskScore),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyHeatmap() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'HIGH RISK AREAS',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Center(
              child: Stack(
                children: [
                  Image.asset('body_outline.png', width: 200),
                  ..._buildRiskOverlays(),
                ],
              ),
            ),
            if (_selectedBodyPart != -1) ...[
              const SizedBox(height: 16),
              Text(
                '${widget.athlete.highRiskAreas[_selectedBodyPart].area}: '
                '${widget.athlete.highRiskAreas[_selectedBodyPart].risk}% risk',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                widget.athlete.highRiskAreas[_selectedBodyPart].details,
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _buildRiskOverlays() {
    return widget.athlete.highRiskAreas.asMap().entries.map((entry) {
      final index = entry.key;
      final area = entry.value;
      return Positioned(
        top: area.yPosition,
        left: area.xPosition,
        child: GestureDetector(
          onTap: () => setState(() => _selectedBodyPart = index),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getRiskColor(area.risk).withOpacity(0.6),
              shape: BoxShape.circle,
              border: Border.all(
                color: _selectedBodyPart == index ? Colors.blue : Colors.transparent,
                width: 2,
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildKeyMetrics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'KEY RISK FACTORS',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildMetricCard('Fatigue Level', widget.athlete.fatigueLevel, 80, '%'),
              _buildMetricCard('Muscle Imbalance', widget.athlete.muscleImbalance, 15, '% diff'),
              _buildMetricCard('Movement Quality', widget.athlete.movementQuality, 10, '/10'),
              _buildMetricCard('Workload Ratio', widget.athlete.workloadRatio, 1.4, 'ACWR'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard(String title, dynamic value, dynamic threshold, String unit) {
    bool isHighRisk = (title == 'Fatigue Level' && value > threshold) ||
                     (title == 'Muscle Imbalance' && value > threshold) ||
                     (title == 'Movement Quality' && value < threshold) ||
                     (title == 'Workload Ratio' && (value < 0.8 || value > 1.5));

    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        color: isHighRisk ? Colors.red[50] : Colors.green[50],
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const Spacer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '$value',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    unit,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                isHighRisk ? 'High Risk' : 'Normal',
                style: TextStyle(
                  color: isHighRisk ? Colors.red : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
Widget _buildInjuryPredictions() {
  return Card(
    elevation: 4,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TOP PREDICTED INJURIES',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Handle empty list
          if (widget.athlete.topInjuryRisks.isEmpty)
            const Text('No predicted injuries', style: TextStyle(color: Colors.red))
          else
            ...widget.athlete.topInjuryRisks.map(_buildInjuryTile),

          const SizedBox(height: 16),
          _buildInjuryChart(), // Extracted method
        ],
      ),
    ),
  );
}

Widget _buildInjuryChart() {
  return SizedBox(
    height: 200,
    child: widget.athlete.riskHistory.isEmpty
        ? const Center(child: Text('No injury risk history available'))
        : SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            series: <CartesianSeries<RiskData, String>>[  
              LineSeries<RiskData, String>(
                dataSource: widget.athlete.riskHistory,
                xValueMapper: (RiskData data, _) => data.date,
                yValueMapper: (RiskData data, _) => data.value,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
              ),
            ],
          ),
  );
}


  Widget _buildInjuryTile(InjuryRisk injury) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _getRiskColor(injury.risk).withOpacity(0.2),
        child: Text(
          '${injury.risk}%',
          style: TextStyle(
            color: _getRiskColor(injury.risk),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(injury.type),
      subtitle: Text(injury.description),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showInjuryDetails(injury),
    );
  }

  Widget _buildPreventionRecommendations() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'PREVENTION RECOMMENDATIONS',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            const Text(
              'Training Modifications',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...widget.athlete.trainingModifications.map((mod) => ListTile(
              leading: const Icon(Icons.timer, size: 20),
              title: Text(mod),
              dense: true,
            )),
            const SizedBox(height: 16),
            const Text(
              'Recommended Exercises',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 200,
              child: PageView(
                children: [
                  _buildExerciseCard('Hamstring Eccentrics', '3 sets x 8 reps'),
                  _buildExerciseCard('Single-leg Balance', '30 sec x 3 each side'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _generatePreventionPlan(),
              child: const Text('Generate Full Prevention Plan'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseCard(String name, String sets) {
    return Card(
      child: Column(
        children: [
          Expanded(
            child: _videoController.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _videoController.value.aspectRatio,
                    child: VideoPlayer(_videoController),
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(sets, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper Methods
  Color _getRiskColor(int risk) {
    if (risk > 70) return Colors.red;
    if (risk > 40) return Colors.orange;
    return Colors.green;
  }

  String _getRiskLevel(int risk) {
    if (risk > 70) return 'HIGH RISK';
    if (risk > 40) return 'MODERATE RISK';
    return 'LOW RISK';
  }

  String _getRiskMessage(int risk) {
    if (risk > 70) return 'Immediate intervention recommended';
    if (risk > 40) return 'Monitor closely and modify training';
    return 'Maintain current prevention strategies';
  }

  // Action Methods
  void _shareReport() {
    // Implement share functionality
  }

  void _showInjuryDetails(InjuryRisk injury) {
    // Show injury details dialog
  }

  void _generatePreventionPlan() {
    // Generate full prevention plan
  }
}

// Data Models
class AthleteProfile {
  final String name;
  final String photoUrl;
  final String sport;
  final String position;
  final String lastAssessment;
  final int riskScore;
  final List<BodyAreaRisk> highRiskAreas;
  final double fatigueLevel;
  final double muscleImbalance;
  final double movementQuality;
  final double workloadRatio;
  final List<InjuryRisk> topInjuryRisks;
  final List<RiskData> riskHistory;
  final List<String> trainingModifications;

  AthleteProfile({
    required this.name,
    required this.photoUrl,
    required this.sport,
    required this.position,
    required this.lastAssessment,
    required this.riskScore,
    required this.highRiskAreas,
    required this.fatigueLevel,
    required this.muscleImbalance,
    required this.movementQuality,
    required this.workloadRatio,
    required this.topInjuryRisks,
    required this.riskHistory,
    required this.trainingModifications,
  });
}

class BodyAreaRisk {
  final String area;
  final int risk;
  final String details;
  final double xPosition;
  final double yPosition;

  BodyAreaRisk({
    required this.area,
    required this.risk,
    required this.details,
    required this.xPosition,
    required this.yPosition,
  });
}

class InjuryRisk {
  final String type;
  final int risk;
  final String description;

  InjuryRisk({
    required this.type,
    required this.risk,
    required this.description,
  });
}

class RiskData {
  final String date;
  final double value;

  RiskData({
    required this.date,
    required this.value,
  });
}