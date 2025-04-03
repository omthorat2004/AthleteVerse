import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class AthleteExerciseInsightsPage extends StatefulWidget {
  const AthleteExerciseInsightsPage({super.key});

  @override
  _AthleteExerciseInsightsPageState createState() =>
      _AthleteExerciseInsightsPageState();
}

class _AthleteExerciseInsightsPageState
    extends State<AthleteExerciseInsightsPage> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  final ExerciseVideo _exerciseVideo = ExerciseVideo(
    id: '1',
    title: 'Advanced Plyometric Training',
    description:
        'High-intensity plyometric exercises to improve explosive power and vertical jump',
    thumbnailUrl:
        'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b',
    videoUrl: 'https://www.shutterstock.com/shutterstock/videos/3728391083/preview/stock-footage-muscular-man-in-sportswear-performing-powerful-box-jumps-in-spacious-gym-during-functional-training.webm',
    duration: '25 min',
    intensity: 'High',
    caloriesBurned: 320,
    recommendedFor: 'Basketball, Volleyball',
    aiInsights: AIInsights(
      performanceImprovement: '15% increase in vertical jump possible',
      injuryRisk: 'Moderate - proper form required',
      metabolicImpact: 'High EPOC effect for 24-48 hours post-workout',
      similarAthletes: '87% of similar athletes improved with this routine',
    ),
  );

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  void _initializeVideoPlayer() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();

    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(_exerciseVideo.videoUrl),
    )
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController?.play();
      });

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      autoPlay: true,
      looping: true,
      aspectRatio: 16 / 9,
      placeholder: CachedNetworkImage(
        imageUrl: _exerciseVideo.thumbnailUrl,
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise Insights'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue[800],
      ),
      body: _buildInsightsView(),
    );
  }

  Widget _buildInsightsView() {
    if (_chewieController == null ||
        !(_chewieController!.videoPlayerController.value.isInitialized)) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Chewie(controller: _chewieController!),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _exerciseVideo.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _exerciseVideo.description,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                const SizedBox(height: 16),
                _buildDetailRow(Icons.timer, 'Duration', _exerciseVideo.duration),
                _buildDetailRow(Icons.local_fire_department, 'Calories Burned',
                    '${_exerciseVideo.caloriesBurned} kcal'),
                _buildDetailRow(Icons.sports, 'Recommended For',
                    _exerciseVideo.recommendedFor),
                const SizedBox(height: 24),
                const Text(
                  'AI Performance Insights',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(),
                _buildInsightCard(
                  'Performance Improvement',
                  _exerciseVideo.aiInsights.performanceImprovement,
                  Icons.trending_up,
                  Colors.green,
                ),
                _buildInsightCard(
                  'Injury Risk Assessment',
                  _exerciseVideo.aiInsights.injuryRisk,
                  Icons.health_and_safety,
                  Colors.orange,
                ),
                _buildInsightCard(
                  'Metabolic Impact',
                  _exerciseVideo.aiInsights.metabolicImpact,
                  Icons.monitor_heart,
                  Colors.purple,
                ),
                _buildInsightCard(
                  'Similar Athletes',
                  _exerciseVideo.aiInsights.similarAthletes,
                  Icons.people,
                  Colors.blue,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Add to training plan functionality
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    'Add to My Training Plan',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue[800]),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(color: Colors.grey[600]),
              ),
              Text(
                value,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(String title, String content, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(content),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExerciseVideo {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String videoUrl;
  final String duration;
  final String intensity;
  final int caloriesBurned;
  final String recommendedFor;
  final AIInsights aiInsights;

  ExerciseVideo({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.duration,
    required this.intensity,
    required this.caloriesBurned,
    required this.recommendedFor,
    required this.aiInsights,
  });
}

class AIInsights {
  final String performanceImprovement;
  final String injuryRisk;
  final String metabolicImpact;
  final String similarAthletes;

  AIInsights({
    required this.performanceImprovement,
    required this.injuryRisk,
    required this.metabolicImpact,
    required this.similarAthletes,
  });
}