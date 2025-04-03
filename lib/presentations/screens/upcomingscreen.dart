import 'package:flutter/material.dart';

class UpcomingTournamentsScreen extends StatelessWidget {
  const UpcomingTournamentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        title: const Text(
          'Upcoming Tournaments',
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
            const SizedBox(height: 20),
            
         
            _buildSearchCard(),
            const SizedBox(height: 16),
            
           
            SizedBox(
              height: 190,
              child: _buildFiltersSection(),
            ),
            const SizedBox(height: 20),
            
           
            SizedBox(
              height: 40,
              child: _buildTournamentTabs(),
            ),
            const SizedBox(height: 16),
            
            // Tournament Cards
            _buildTournamentCard(
              'State Championship',
              'Aug 15-20, 2023',
              'Chicago, IL',
              'Intermediate',
              '250',
              '\$5,000',
              'Jul 30, 2023',
              isRecommended: true,
            ),
            const SizedBox(height: 16),
            _buildTournamentCard(
              'Regional Elite Series',
              'Sep 5-10, 2023',
              'Atlanta, GA',
              'Advanced',
              '500',
              '\$10,000',
              'Aug 15, 2023',
              isRecommended: true,
            ),
            const SizedBox(height: 16),
            _buildTournamentCard(
              'National Junior Open',
              'Sep 18-24, 2023',
              'Miami, FL',
              'Intermediate',
              '350',
              '\$7,500',
              'Aug 25, 2023',
            ),
            const SizedBox(height: 16),
            _buildTournamentCard(
              'City Championship',
              'Oct 1-3, 2023',
              'Denver, CO',
              'Beginner',
              '100',
              '\$2,000',
              'Sep 15, 2023',
            ),
            const SizedBox(height: 16),
            _buildTournamentCard(
              'International Open',
              'Oct 15-22, 2023',
              'Toronto, Canada',
              'Elite',
              '750',
              '\$25,000',
              'Sep 20, 2023',
            ),
            const SizedBox(height: 16),
            _buildTournamentCard(
              'University Invitational',
              'Nov 5-7, 2023',
              'Boston, MA',
              'Intermediate',
              '200',
              '\$3,000',
              'Oct 15, 2023',
              isRecommended: true,
            ),
            const SizedBox(height: 24),
            
            // Bookmark & Notification Settings
            _buildSectionTitle('BOOKMARK & NOTIFICATION SETTINGS'),
            Text(
              'Manage your saved tournaments and notification preferences',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 16),
            
            // Horizontal scroll for notification settings
            SizedBox(
              height: 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildNotificationCard(
                    Icons.calendar_today,
                    'Registration Deadlines',
                    'Receive notifications 7 days before registration closes',
                    Colors.blue.shade800,
                  ),
                  const SizedBox(width: 12),
                  _buildNotificationCard(
                    Icons.notifications_active,
                    'New Recommendations',
                    'Get alerts when new tournaments match your profile',
                    Colors.green.shade600,
                  ),
                  const SizedBox(width: 12),
                  _buildNotificationCard(
                    Icons.info_outline,
                    'Tournament Changes',
                    'Be notified of date, venue, or rule changes',
                    Colors.orange.shade600,
                  ),
                  const SizedBox(width: 12),
                  _buildNotificationCard(
                    Icons.leaderboard,
                    'Results & Rankings',
                    'Get updates when results affect your ranking',
                    Colors.purple.shade600,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Export Calendar
            _buildSectionTitle('EXPORT CALENDAR'),
            Text(
              'Add your saved tournaments to your calendar',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 12),
            
            // Horizontal scroll for export options
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildExportOption(Icons.calendar_view_month, 'Google Calendar'),
                  const SizedBox(width: 12),
                  _buildExportOption(Icons.calendar_today, 'Apple Calendar'),
                  const SizedBox(width: 12),
                  _buildExportOption(Icons.email, 'Email Export'),
                  const SizedBox(width: 12),
                  _buildExportOption(Icons.file_download, 'CSV Download'),
                ],
              ),
            ),
            const SizedBox(height: 16),
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
                Icon(Icons.event, color: Colors.blue.shade800, size: 28),
                const SizedBox(width: 12),
                Text(
                  'UPCOMING TOURNAMENTS',
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
              'Find and filter tournaments that match your skill level and goals',
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

  Widget _buildSearchCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TOURNAMENT FINDER',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Search for tournaments, leagues, and championships',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search tournaments...',
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersSection() {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        Card(
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
                  'SPORT TYPE',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                _buildFilterChip('Tennis', true),
                _buildFilterChip('Badminton', false),
                _buildFilterChip('Squash', false),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Card(
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
                  'COMPETITION LEVEL',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                _buildFilterChip('All Levels', true),
                _buildFilterChip('Beginner', false),
                _buildFilterChip('Intermediate', false),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Card(
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
                  'LOCATION',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                _buildFilterChip('All Locations', true),
                _buildFilterChip('North Region', false),
                _buildFilterChip('South Region', false),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Card(
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
                  'FEATURES',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                _buildFilterChip('Ranking Points', true),
                _buildFilterChip('Prize Money', false),
                _buildFilterChip('Sponsorships', false),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool selected) {},
        selectedColor: Colors.blue.shade800,
        backgroundColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.blue.shade800,
          fontSize: 12,
        ),
        shape: StadiumBorder(
          side: BorderSide(color: Colors.blue.shade200),
        ),
      ),
    );
  }

  Widget _buildTournamentTabs() {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        _buildTournamentTab('All Tournaments', isSelected: false),
        const SizedBox(width: 8),
        _buildTournamentTab('Recommended', isSelected: true),
        const SizedBox(width: 8),
        _buildTournamentTab('Saved', isSelected: false),
        const SizedBox(width: 8),
        _buildTournamentTab('Near Me', isSelected: false),
        const SizedBox(width: 8),
        _buildTournamentTab('International', isSelected: false),
      ],
    );
  }

  Widget _buildTournamentTab(String label, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.shade800 : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? Colors.blue.shade800 : Colors.blue.shade200,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: isSelected ? Colors.white : Colors.blue.shade800,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.blue.shade800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildTournamentCard(
    String name,
    String date,
    String location,
    String level,
    String points,
    String prizePool,
    String deadline, {
    bool isRecommended = false,
  }) {
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Date (Soonest)',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                Row(
                  children: [
                    if (isRecommended)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Recommended',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade800,
                          ),
                        ),
                      ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        Icons.bookmark_border,
                        color: Colors.blue.shade800,
                      ),
                      onPressed: () {},
                      tooltip: 'Save tournament',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.blue.shade800),
                const SizedBox(width: 4),
                Text(
                  location,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildTournamentDetailChip('Level: $level'),
                _buildTournamentDetailChip('Points: $points'),
                _buildTournamentDetailChip('Prize: $prizePool'),
                _buildTournamentDetailChip('Deadline: $deadline'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    backgroundColor: Colors.blue.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'DETAILS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  ),
                  child: const Text(
                    'REGISTER',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTournamentDetailChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: Colors.blue.shade800,
        ),
      ),
    );
  }

  Widget _buildNotificationCard(IconData icon, String title, String description, Color color) {
    return SizedBox(
      width: 180,
      child: Card(
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
              Icon(icon, size: 28, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
              ),
              const Spacer(),
              Switch(
                value: true,
                onChanged: (bool value) {},
                activeColor: color,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExportOption(IconData icon, String label) {
    return SizedBox(
      width: 120,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: Colors.blue.shade800),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}