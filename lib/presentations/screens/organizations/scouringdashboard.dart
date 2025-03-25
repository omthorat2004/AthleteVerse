import 'package:flutter/material.dart';
import 'package:myapp/presentations/screens/organizations/scouting/recommendedscreen.dart';
import 'scouting/allathletescreen.dart';

class ScoutingDashboard extends StatefulWidget {
  const ScoutingDashboard({super.key});

  @override
  State<ScoutingDashboard> createState() => _ScoutingDashboardState();
}

class _ScoutingDashboardState extends State<ScoutingDashboard> {
  int _currentSectionIndex = 0;
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> _sections = [
    {'title': 'All Athletes', 'icon': Icons.group, 'metric': '1,248'},
    {'title': 'Watchlist', 'icon': Icons.star, 'metric': '84'},
    {'title': 'Recommended', 'icon': Icons.thumb_up, 'metric': '42'},
    {'title': 'Contacted', 'icon': Icons.mail, 'metric': '56'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: const Text('Scouting Dashboard'),
              centerTitle: true,
              backgroundColor: Colors.white,
              pinned: true,
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.only(top: 70, left: 16, right: 16),
                  child: GridView.count(
                    crossAxisCount: 4,
                    childAspectRatio: 0.8,
                    physics: const NeverScrollableScrollPhysics(),
                    children: _sections.map((section) {
                      return _buildMetricCard(
                        section['icon'],
                        section['metric'],
                        section['title'],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ];
        },
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentSectionIndex = index);
          },
          children: [
            const AllAthletesScreen(),
            _buildPlaceholderContent(_sections[1]),
            RecommendedAthletesScreen(),
            _buildPlaceholderContent(_sections[3]),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildMetricCard(IconData icon, String metric, String title) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Colors.blueAccent,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          metric,
          style: const TextStyle(
            color: Colors.blueAccent,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            color: Colors.blueAccent,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderContent(Map<String, dynamic> section) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(section['icon'], size: 60, color: Colors.blue[100]),
          const SizedBox(height: 16),
          Text(
            '${section['title']} Content',
            style: const TextStyle(
              color: Colors.blue,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: List.generate(_sections.length, (index) {
          final section = _sections[index];
          final isSelected = _currentSectionIndex == index;
          return Expanded(
            child: InkWell(
              onTap: () {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                color: isSelected ? Colors.blue[50] : Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      section['icon'],
                      color: isSelected ? Colors.blue[800] : Colors.grey[600],
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      section['title'],
                      style: TextStyle(
                        color: isSelected ? Colors.blue[800] : Colors.grey[600],
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    if (isSelected)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        height: 2,
                        width: 24,
                        color: Colors.blue[800],
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}