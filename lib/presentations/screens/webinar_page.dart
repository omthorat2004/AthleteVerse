import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class WebinarsPage extends StatefulWidget {
  const WebinarsPage({super.key});

  @override
  State<WebinarsPage> createState() => _WebinarsPageState();
}

class _WebinarsPageState extends State<WebinarsPage> {
 final List<Webinar> webinars = [
  Webinar(
    title: 'Injury Prevention and Recovery Strategies',
    description: 'Learn the best practices for injury prevention and rehabilitation to maintain peak athletic performance.',
    dateTime: DateTime(2024, 7, 10, 15, 0),
    duration: const Duration(hours: 2),
    speaker: 'Dr. Ramesh Kumar',
    speakerBio: 'Sports Physiotherapist with 10+ years of experience',
    meetLink: 'https://meet.google.com/xyz-abc-123',
    category: 'Sports Medicine',
    imageUrl: 'https://i.imgur.com/athlete1.png',
    attendees: 150,
  ),
  Webinar(
    title: 'Athlete Nutrition and Performance',
    description: 'A complete guide to optimizing athletic performance through proper nutrition and diet planning.',
    dateTime: DateTime(2024, 7, 15, 10, 0),
    duration: const Duration(hours: 1, minutes: 30),
    speaker: 'Dr. Anjali Mehta',
    speakerBio: 'Sports Nutritionist and Consultant for elite athletes',
    meetLink: 'https://meet.google.com/uvw-def-456',
    category: 'Nutrition',
    imageUrl: 'https://i.imgur.com/athlete2.png',
    attendees: 120,
  ),
  Webinar(
    title: 'Mental Resilience for Athletes',
    description: 'Techniques to build mental toughness and resilience for peak sports performance.',
    dateTime: DateTime(2024, 7, 20, 16, 0),
    duration: const Duration(hours: 1),
    speaker: 'Rajesh Nair',
    speakerBio: 'Certified Sports Psychologist with experience in Olympic coaching',
    meetLink: 'https://meet.google.com/rst-ghi-789',
    category: 'Psychology',
    imageUrl: 'https://i.imgur.com/athlete3.png',
    attendees: 200,
  ),
  Webinar(
    title: 'Financial Planning for Athletes',
    description: 'Understand financial management, sponsorship deals, and securing your future as an athlete.',
    dateTime: DateTime(2024, 7, 25, 11, 0),
    duration: const Duration(hours: 2, minutes: 15),
    speaker: 'Amit Verma',
    speakerBio: 'Financial Advisor specializing in sports industry investments',
    meetLink: 'https://meet.google.com/mno-jkl-012',
    category: 'Finance',
    imageUrl: 'https://i.imgur.com/athlete4.png',
    attendees: 90,
  ),
];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming Webinars'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
             
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildStatsRow(),
            const SizedBox(height: 20),
            ...webinars.map((webinar) => _buildWebinarCard(context, webinar)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    final upcomingCount = webinars.where((w) => w.dateTime.isAfter(DateTime.now())).length;
    final pastCount = webinars.length - upcomingCount;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.upcoming,
            value: upcomingCount.toString(),
            label: 'Upcoming',
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.history,
            value: pastCount.toString(),
            label: 'Past',
            color: Colors.grey,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.people,
            value: webinars.fold(0, (sum, w) => sum + w.attendees).toString(),
            label: 'Total Attendees',
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, size: 28, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWebinarCard(BuildContext context, Webinar webinar) {
    final isUpcoming = webinar.dateTime.isAfter(DateTime.now());
    final formattedDate = DateFormat('MMM d, y').format(webinar.dateTime);
    final formattedTime = DateFormat('h:mm a').format(webinar.dateTime);
    final durationHours = webinar.duration.inHours;
    final durationMinutes = webinar.duration.inMinutes.remainder(60);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showWebinarDetails(context, webinar),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      webinar.imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[200],
                        child: const Icon(Icons.videocam),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          webinar.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          webinar.category,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.person, size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              webinar.speaker,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildDetailChip(
                    icon: Icons.calendar_today,
                    text: formattedDate,
                  ),
                  const SizedBox(width: 8),
                  _buildDetailChip(
                    icon: Icons.access_time,
                    text: formattedTime,
                  ),
                  const SizedBox(width: 8),
                  _buildDetailChip(
                    icon: Icons.timer,
                    text: '${durationHours}h ${durationMinutes}m',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildDetailChip(
                    icon: Icons.people,
                    text: '${webinar.attendees} attending',
                  ),
                  const Spacer(),
                  if (isUpcoming)
                    ElevatedButton.icon(
                      icon: Image.asset(
                        'assets/google_meet.png',
                        width: 20,
                        height: 20,
                      ),
                      label: const Text('Join'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Colors.blue[700]!),
                        ),
                      ),
                      onPressed: () => _launchMeetUrl(webinar.meetLink),
                    )
                  else
                    OutlinedButton(
                      child: const Text('View Recording'),
                      onPressed: () {
                        // Handle view recording
                      },
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailChip({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchMeetUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch Google Meet')),
      );
    }
  }

  void _showWebinarDetails(BuildContext context, Webinar webinar) {
    final isUpcoming = webinar.dateTime.isAfter(DateTime.now());
    final formattedDate = DateFormat('EEEE, MMMM d, y').format(webinar.dateTime);
    final formattedTime = DateFormat('h:mm a').format(webinar.dateTime);
    final durationHours = webinar.duration.inHours;
    final durationMinutes = webinar.duration.inMinutes.remainder(60);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  webinar.imageUrl,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: double.infinity,
                    height: 180,
                    color: Colors.grey[200],
                    child: const Icon(Icons.videocam, size: 50),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                webinar.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                webinar.category,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(Icons.person, size: 20, color: Colors.grey),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        webinar.speaker,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        webinar.speakerBio,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                webinar.description,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _buildDetailRow(Icons.calendar_today, formattedDate),
              _buildDetailRow(Icons.access_time, formattedTime),
              _buildDetailRow(
                Icons.timer,
                'Duration: ${durationHours}h ${durationMinutes}m',
              ),
              _buildDetailRow(
                Icons.people,
                'Attendees: ${webinar.attendees}',
              ),
              const SizedBox(height: 30),
              if (isUpcoming)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: Image.asset(
                      'assets/google_meet.png',
                      width: 24,
                      height: 24,
                    ),
                    label: const Text('Join Google Meet'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => _launchMeetUrl(webinar.meetLink),
                  ),
                )
              else
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text('View Recording'),
                    ),
                    onPressed: () {
                      // Handle view recording
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class Webinar {
  final String title;
  final String description;
  final DateTime dateTime;
  final Duration duration;
  final String speaker;
  final String speakerBio;
  final String meetLink;
  final String category;
  final String imageUrl;
  final int attendees;

  Webinar({
    required this.title,
    required this.description,
    required this.dateTime,
    required this.duration,
    required this.speaker,
    required this.speakerBio,
    required this.meetLink,
    required this.category,
    required this.imageUrl,
    required this.attendees,
  });
}