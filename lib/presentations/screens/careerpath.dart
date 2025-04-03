import 'package:flutter/material.dart';

class MyCareerPathScreen extends StatelessWidget {
  const MyCareerPathScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        title: const Text(
          'My Career Path',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeaderCard(),
            const SizedBox(height: 24),
            
            // Career Timeline
            _buildTimelineHeader(),
            const SizedBox(height: 16),
            _buildCareerTimeline(),
            const SizedBox(height: 24),
            
            // Next Steps
            _buildNextStepsHeader(),
            const SizedBox(height: 16),
            _buildNextStepItem(
              1,
              'Register for State Championship',
              'This tournament will help you gain valuable ranking points and experience',
              'Registration closes in 15 days',
              'Register Now',
            ),
            const SizedBox(height: 12),
            _buildNextStepItem(
              2,
              'Complete Skills Assessment',
              'Get evaluated by certified coaches to identify areas for improvement',
              'Available at training centers nationwide',
              'Find Assessment Center',
            ),
            const SizedBox(height: 12),
            _buildNextStepItem(
              3,
              'Join Advanced Training Camp',
              'Intensive training with professional coaches and elite athletes',
              'Next camp starts in 30 days',
              'Apply for Camp',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.timeline, color: Colors.blue.shade800, size: 28),
                const SizedBox(width: 12),
                Text(
                  'ATHLETE PROGRESSION TRACKER',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Your journey from local competitions to professional circuits',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        'YOUR CAREER PATH',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.blue.shade800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildCareerTimeline() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Current Level
            _buildTimelineItem(
              'Current Level',
              'Beginner Level',
              'Local & District Competitions',
              [
                'Local club tournaments',
                'District championships',
                'School/college competitions',
              ],
              'View Details',
              isCurrent: true,
            ),
            const SizedBox(height: 24),
            
            // Next Goal
            _buildTimelineItem(
              'Next Goal',
              'Intermediate Level',
              'State & National Competitions',
              [
                'State championships',
                'Regional qualifiers',
                'National junior circuits',
              ],
              'Find Tournaments',
            ),
            const SizedBox(height: 24),
            
            // Future Goal
            _buildTimelineItem(
              'Future Goal',
              'Advanced Level',
              'National & International Competitions',
              [
                'National ranking in top 100',
                'Minimum 5 state-level wins',
                'International qualifier participation',
              ],
              'View Requirements',
            ),
            const SizedBox(height: 24),
            
            // Ultimate Goal
            _buildTimelineItem(
              'Ultimate Goal',
              'Elite Level',
              'Professional Circuits & Championships',
              [
                'Professional league participation',
                'International championships',
                'Olympic qualification',
              ],
              'Explore Pro Circuits',
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(
    String title,
    String level,
    String description,
    List<String> milestones,
    String buttonText, {
    bool isCurrent = false,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isCurrent ? Colors.blue.shade800 : Colors.blue.shade100,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.blue.shade800,
                  width: 2,
                ),
              ),
              child: isCurrent
                  ? Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 80,
                color: Colors.blue.shade200,
              ),
          ],
        ),
        const SizedBox(width: 16),
        
        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                level,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 12),
              
              // Milestones
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: milestones
                    .map((milestone) => Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.circle,
                                size: 8,
                                color: Colors.blue.shade800,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  milestone,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 12),
              
              // Button
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
                    buttonText.toUpperCase(),
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
      ],
    );
  }

  Widget _buildNextStepsHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        'NEXT STEPS FOR YOUR CAREER',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.blue.shade800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildNextStepItem(
    int number,
    String title,
    String description,
    String deadline,
    String buttonText,
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade800,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      number.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
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
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        deadline,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade800,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                ),
                child: Text(
                  buttonText.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}