import 'package:flutter/material.dart';

class ExpertAdviceScreen extends StatefulWidget {
  const ExpertAdviceScreen({super.key});

  @override
  State<ExpertAdviceScreen> createState() => _ExpertAdviceScreenState();
}

class _ExpertAdviceScreenState extends State<ExpertAdviceScreen> {
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        title: const Text(
          'Expert Advice',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Tab Buttons
            _buildTabButtons(),
            const SizedBox(height: 20),
            
            // Content based on selected tab
            _buildCurrentTabContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButtons() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildTabButton(0, 'Articles & Guides'),
          _buildTabButton(1, 'Live Q&A'),
          _buildTabButton(2, 'Mentorship'),
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, String label) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              _currentTabIndex = index;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _currentTabIndex == index 
                ? Colors.blue.shade800 
                : Colors.transparent,
            foregroundColor: _currentTabIndex == index 
                ? Colors.white 
                : Colors.blue.shade800,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentTabContent() {
    switch (_currentTabIndex) {
      case 0:
        return _buildArticlesAndGuides();
      case 1:
        return _buildLiveQAForums();
      case 2:
        return _buildMentorship();
      default:
        return Container();
    }
  }

  Widget _buildArticlesAndGuides() {
    return Column(
      children: [
        _buildArticleCard(
          'Strategy',
          'Strategic Tournament Selection for Rising Athletes',
          'July 15, 2023',
          'Coach Sarah Johnson',
          'Former Olympic Coach',
          '8 min read',
        ),
        const SizedBox(height: 16),
        _buildArticleCard(
          'Training',
          'Peak Performance Preparation for Key Tournaments',
          'July 10, 2023',
          'Dr. Michael Chen',
          'Sports Scientist',
          '10 min read',
        ),
        const SizedBox(height: 16),
        _buildArticleCard(
          'Mental Game',
          'Overcoming Competition Anxiety',
          'July 5, 2023',
          'Dr. Lisa Rodriguez',
          'Sports Psychologist',
          '6 min read',
        ),
        const SizedBox(height: 16),
        _buildArticleCard(
          'Recovery',
          'Optimizing Recovery Between Tournaments',
          'June 28, 2023',
          'James Wilson',
          'Performance Coach',
          '7 min read',
        ),
      ],
    );
  }

  Widget _buildArticleCard(
    String category,
    String title,
    String date,
    String author,
    String authorTitle,
    String readTime,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                category,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              date,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage('https://randomuser.me/api/portraits/women/44.jpg'),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      author,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                    Text(
                      authorTitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  readTime,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  backgroundColor: Colors.blue.shade50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'READ ARTICLE',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveQAForums() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upcoming Live Q&A Sessions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Join live discussions with sports experts',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 16),
        _buildQASessionCard(
          'Navigating International Tournaments',
          'Maria Gonzalez',
          'International Tennis Coach',
          'July 25, 2023',
          '3:00 PM EST',
          '156 registered',
        ),
        const SizedBox(height: 16),
        _buildQASessionCard(
          'Mental Preparation for High-Stakes Competitions',
          'Dr. Robert Kim',
          'Sports Psychologist',
          'July 28, 2023',
          '1:00 PM EST',
          '203 registered',
        ),
        const SizedBox(height: 16),
        _buildQASessionCard(
          'Building Your Athletic Brand Through Tournaments',
          'Jennifer Taylor',
          'Sports Marketing Specialist',
          'August 2, 2023',
          '4:00 PM EST',
          '124 registered',
        ),
        const SizedBox(height: 24),
        Text(
          'Recent Q&A Recordings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Watch previous expert sessions',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 16),
        _buildQARecordingCard(
          'Tournament Selection Strategy for Junior Athletes',
          'Thomas Wilson',
          'Youth Development Coach',
          'July 10, 2023',
          '45 minutes',
          '1245 views',
        ),
        const SizedBox(height: 16),
        _buildQARecordingCard(
          'Qualifying for National Championships',
          'Sarah Johnson',
          'National Team Coach',
          'July 5, 2023',
          '52 minutes',
          '1876 views',
        ),
      ],
    );
  }

  Widget _buildQASessionCard(
    String title,
    String expert,
    String expertTitle,
    String date,
    String time,
    String registered,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage('https://randomuser.me/api/portraits/women/68.jpg'),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      expert,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                    Text(
                      expertTitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.blue.shade800),
                const SizedBox(width: 4),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(width: 12),
                Icon(Icons.access_time, size: 16, color: Colors.blue.shade800),
                const SizedBox(width: 4),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.people, size: 16, color: Colors.blue.shade800),
                const SizedBox(width: 4),
                Text(
                  registered,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade800,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                minimumSize: const Size(double.infinity, 40),
              ),
              child: const Text(
                'REGISTER',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQARecordingCard(
    String title,
    String expert,
    String expertTitle,
    String date,
    String duration,
    String views,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage('https://randomuser.me/api/portraits/men/32.jpg'),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      expert,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                    Text(
                      expertTitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.blue.shade800),
                const SizedBox(width: 4),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(width: 12),
                Icon(Icons.timer, size: 16, color: Colors.blue.shade800),
                const SizedBox(width: 4),
                Text(
                  duration,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.visibility, size: 16, color: Colors.blue.shade800),
                const SizedBox(width: 4),
                Text(
                  views,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                minimumSize: const Size(double.infinity, 40),
              ),
              child: Text(
                'WATCH',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMentorship() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Find a Mentor',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Connect with experienced athletes and coaches',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _buildMentorCard(
              'Michael Chen',
              'Professional Tennis Player',
              '15+ years experience',
              'Specialties: Tournament Strategy, Career Planning',
              'Available for 1:1 sessions',
              'https://randomuser.me/api/portraits/men/22.jpg',
            ),
            _buildMentorCard(
              'Lisa Rodriguez',
              'Former Olympic Athlete',
              '20+ years experience',
              'Specialties: International Competitions, Elite Performance',
              'Available for group sessions',
              'https://randomuser.me/api/portraits/women/33.jpg',
            ),
            _buildMentorCard(
              'James Wilson',
              'Sports Psychologist',
              '12+ years experience',
              'Specialties: Mental Preparation, Competition Anxiety',
              'Available for 1:1 sessions',
              'https://randomuser.me/api/portraits/men/44.jpg',
            ),
            _buildMentorCard(
              'Sarah Johnson',
              'National Team Coach',
              '18+ years experience',
              'Specialties: Talent Development, Advanced Techniques',
              'Limited availability',
              'https://randomuser.me/api/portraits/women/45.jpg',
            ),
            _buildMentorCard(
              'David Thompson',
              'Performance Coach',
              '10+ years experience',
              'Specialties: Tournament Preparation, Recovery Strategies',
              'Available for 1:1 sessions',
              'https://randomuser.me/api/portraits/men/55.jpg',
            ),
            _buildMentorCard(
              'Emma Williams',
              'Sports Agent',
              '8+ years experience',
              'Specialties: Career Management, Sponsorship Opportunities',
              'Available for consultations',
              'https://randomuser.me/api/portraits/women/66.jpg',
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'Success Stories',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Learn from athletes who progressed through the tournament system',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 16),
        _buildSuccessStoryCard(
          'From Local Tournaments to Grand Slam',
          'Emma Richardson',
          'Tennis',
          'Emma shares her journey from competing in local tournaments to qualifying for Grand Slam events, with insights on tournament selection and progression strategy.',
        ),
        const SizedBox(height: 16),
        _buildSuccessStoryCard(
          'Building a Professional Career Through Strategic Competition',
          'Marcus Johnson',
          'Swimming',
          'Marcus explains how he carefully selected competitions to maximize ranking points and visibility, eventually securing sponsorships and professional status.',
        ),
        const SizedBox(height: 24),
        Text(
          'Resources & Guides',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Comprehensive guides on tournament progression',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 16),
        _buildResourceCard(
          'The Complete Guide to Tournament Progression',
          'E-Book',
          '85 pages',
        ),
        const SizedBox(height: 12),
        _buildResourceCard(
          'Tournament Selection Masterclass',
          'Video Course',
          '4 hours',
        ),
        const SizedBox(height: 12),
        _buildResourceCard(
          'Ranking Point Optimization Strategy',
          'Interactive Guide',
          '12 modules',
        ),
        const SizedBox(height: 12),
        _buildResourceCard(
          'From Amateur to Professional: A Roadmap',
          'Workbook',
          '120 pages',
        ),
      ],
    );
  }

  Widget _buildMentorCard(
    String name,
    String title,
    String experience,
    String specialties,
    String availability,
    String imageUrl,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(imageUrl),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              experience,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              specialties,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              availability,
              style: TextStyle(
                fontSize: 10,
                color: Colors.green.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade800,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                minimumSize: const Size(0, 30),
              ),
              child: Text(
                'CONNECT',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessStoryCard(
    String title,
    String author,
    String sport,
    String description,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  author,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue.shade800,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    sport,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue.shade800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  backgroundColor: Colors.blue.shade50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'READ FULL STORY',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceCard(
    String title,
    String type,
    String details,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              Icons.article,
              size: 40,
              color: Colors.blue.shade800,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        type,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '•',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        details,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade800,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: const Text(
                'ACCESS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}