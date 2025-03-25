import 'package:flutter/material.dart';

class RecommendedAthletesScreen extends StatefulWidget {
  const RecommendedAthletesScreen({super.key});

  @override
  State<RecommendedAthletesScreen> createState() => _RecommendedAthletesScreenState();
}

class _RecommendedAthletesScreenState extends State<RecommendedAthletesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedSport;
  String? _selectedLocation;
  String? _selectedAgeGroup;
  String? _selectedGender;

  final List<Map<String, dynamic>> recommendedAthletes = [
    {
      'name': 'Aman Singh',
      'position': 'Forward',
      'sport': 'Soccer',
      'location': 'Delhi',
      'age': '22',
      'matches_played': 45,
      'matches_won': 32,
      'stats': {'Speed': 92, 'Agility': 88, 'Strength': 75, 'Endurance': 85},
      'ai_insights': {
        'match_percentage': 87,
        'improvement_potential': 'High',
        'comparable_players': ['Player X', 'Player Y'],
        'recommendation_reasons': [
          'Exceptional speed matches our team playstyle',
          'Shows 25% higher agility than league average',
          'Projected to grow 15% in next 2 years'
        ],
        'training_suggestions': [
          'Strength training program (current weakness)',
          'Advanced dribbling drills',
          'Position-specific tactical sessions'
        ]
      },
      'performance_trend': '25% improvement over last season',
      'scout_notes': 'Top performer in recent tournaments with consistent stats'
    },
    {
      'name': 'Priya Patel',
      'position': 'Defender',
      'sport': 'Soccer',
      'location': 'Mumbai',
      'age': '21',
      'matches_played': 38,
      'matches_won': 25,
      'stats': {'Speed': 78, 'Agility': 85, 'Strength': 92, 'Endurance': 80},
      'ai_insights': {
        'match_percentage': 92,
        'improvement_potential': 'Very High',
        'comparable_players': ['Player A', 'Player B'],
        'recommendation_reasons': [
          'Top 5% in defensive strength metrics',
          'Perfect fit for our defensive strategy',
          'Young age with high growth potential'
        ],
        'training_suggestions': [
          'Speed and acceleration training',
          'Defensive positioning workshops',
          'Leadership development program'
        ]
      },
      'performance_trend': '30% improvement in defensive stats',
      'scout_notes': 'Emerging talent with excellent game sense'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
         
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildSearchBar(),
                const SizedBox(height: 8),
                _buildFilterRow(),
              ],
            ),
          ),
          
          // Athletes List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: recommendedAthletes.length,
              itemBuilder: (context, index) => _buildCompactCard(recommendedAthletes[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[100],
        hintText: 'Search recommended athletes...',
        prefixIcon: const Icon(Icons.search, color: Colors.blue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      ),
      onChanged: (value) => setState(() {}),
    );
  }
Widget _buildFilterRow() {
  return Column(
    children: [
      Row(
        children: [
          Expanded(
            child: _buildFilterDropdown(
              value: _selectedSport,
              hint: 'Sport',
              items: const ['Soccer', 'Basketball', 'Tennis', 'Cricket'],
              onChanged: (value) => setState(() => _selectedSport = value),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildFilterDropdown(
              value: _selectedLocation,
              hint: 'Location',
              items: const ['Delhi', 'Mumbai', 'Bangalore', 'Hyderabad'],
              onChanged: (value) => setState(() => _selectedLocation = value),
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      Row(
        children: [
          Expanded(
            child: _buildFilterDropdown(
              value: _selectedAgeGroup,
              hint: 'Age Group',
              items: const ['18-21', '22-25', '26-30', '30+'],
              onChanged: (value) => setState(() => _selectedAgeGroup = value),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildFilterDropdown(
              value: _selectedGender,
              hint: 'Gender',
              items: const ['Male', 'Female', 'Other'],
              onChanged: (value) => setState(() => _selectedGender = value),
            ),
          ),
        ],
      ),
      if (_selectedSport != null || _selectedLocation != null || 
          _selectedAgeGroup != null || _selectedGender != null)
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => setState(() {
                _selectedSport = null;
                _selectedLocation = null;
                _selectedAgeGroup = null;
                _selectedGender = null;
              }),
              child: const Text(
                'Clear Filters',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ),
        ),
    ],
  );
}

Widget _buildFilterDropdown({
  required String? value,
  required String hint,
  required List<String> items,
  required Function(String?) onChanged,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.blue.withOpacity(0.5)),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: DropdownButton<String>(
      value: value,
      hint: Text(hint, style: TextStyle(color: Colors.grey[600])),
      isExpanded: true,
      underline: const SizedBox(),
      icon: const Icon(Icons.arrow_drop_down, color: Colors.blue),
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
      dropdownColor: Colors.white,
      style: const TextStyle(color: Colors.black),
    ),
  );
}

  Widget _buildFilterChip(String label, String? value) {
    return FilterChip(
      label: Text(value ?? label),
      selected: value != null,
      onSelected: (selected) {
        setState(() {
          if (selected) {
            switch (label) {
              case 'Sport':
                _selectedSport = 'Soccer';
                break;
              case 'Location':
                _selectedLocation = 'Delhi';
                break;
              case 'Age':
                _selectedAgeGroup = '18-25';
                break;
              case 'Gender':
                _selectedGender = 'Male';
                break;
            }
          } else {
            switch (label) {
              case 'Sport':
                _selectedSport = null;
                break;
              case 'Location':
                _selectedLocation = null;
                break;
              case 'Age':
                _selectedAgeGroup = null;
                break;
              case 'Gender':
                _selectedGender = null;
                break;
            }
          }
        });
      },
      selectedColor: Colors.blue[100],
      backgroundColor: Colors.grey[200],
      labelStyle: TextStyle(
        color: value != null ? Colors.blue[800] : Colors.black87,
      ),
    );
  }

  Widget _buildCompactCard(Map<String, dynamic> athlete) {
    return GestureDetector(
      onTap: () => _showAthleteDetails(athlete, context),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.blue.withOpacity(0.2),
        )),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar with blue accent
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Colors.blue, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    athlete['name'].split(' ').map((e) => e[0]).join(),
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      athlete['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '${athlete['position']} • ${athlete['sport']} • ${athlete['age']} yrs',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              _buildMatchPercentage(athlete['ai_insights']['match_percentage']),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.visibility, color: Colors.blue),
                onPressed: () => _showAthleteDetails(athlete, context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAthleteDetails(Map<String, dynamic> athlete, BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Draggable handle
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Close button
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.blue),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildDetailedCard(athlete),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedCard(Map<String, dynamic> athlete) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with basic info
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar with blue accent
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: Colors.blue, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  athlete['name'].split(' ').map((e) => e[0]).join(),
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    athlete['name'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '${athlete['position']} • ${athlete['sport']} • ${athlete['age']} yrs',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildMatchPercentage(athlete['ai_insights']['match_percentage']),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Match Performance
        _buildSectionHeader('Match Performance'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatCircle(athlete['matches_played'].toString(), 'Played'),
            _buildStatCircle(athlete['matches_won'].toString(), 'Won'),
            _buildStatCircle(
              '${((athlete['matches_won'] / athlete['matches_played']) * 100).toStringAsFixed(1)}%', 
              'Win Rate'
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Divider with blue accent
        Divider(color: Colors.blue.withOpacity(0.2), height: 1),
        const SizedBox(height: 16),

        // AI Insights Section
        _buildSectionHeader('AI Recommendation Insights'),
        ...athlete['ai_insights']['recommendation_reasons']
            .map<Widget>((reason) => _buildInsightItem(reason))
            .toList(),
        const SizedBox(height: 16),

        // Performance Analytics
        _buildSectionHeader('Performance Analytics'),
        _buildStatsGrid(athlete['stats']),
        const SizedBox(height: 8),
        _buildTrendIndicator(athlete['performance_trend']),
        const SizedBox(height: 16),

        // Training Suggestions
        _buildSectionHeader('AI Training Suggestions'),
        ...athlete['ai_insights']['training_suggestions']
            .map<Widget>((suggestion) => _buildTrainingSuggestion(suggestion))
            .toList(),
        const SizedBox(height: 16),

        // Comparable Players
        _buildSectionHeader('Comparable Players'),
        Wrap(
          spacing: 8,
          children: athlete['ai_insights']['comparable_players']
              .map<Widget>((player) => _buildPlayerChip(player))
              .toList(),
        ),
        const SizedBox(height: 16),

        // Scout Notes
        _buildSectionHeader('Scout Notes'),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            athlete['scout_notes'],
            style: const TextStyle(color: Colors.black87),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildStatCircle(String value, String label) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue[50],
            border: Border.all(color: Colors.blue, width: 2),
          ),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
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
    );
  }

  Widget _buildMatchPercentage(int percentage) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue[400]!,
            Colors.blue[600]!,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$percentage% Match',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildInsightItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue[100],
            ),
            child: const Icon(
              Icons.check,
              color: Colors.blue,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(Map<String, dynamic> stats) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 3,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: stats.entries.map((entry) {
        return _buildStatItem(entry.key, entry.value);
      }).toList(),
    );
  }

  Widget _buildStatItem(String statName, int value) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            statName.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: value / 100,
            backgroundColor: Colors.blue[100],
            color: Colors.blue,
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
          const SizedBox(height: 4),
          Text(
            '$value/100',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendIndicator(String trend) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.trending_up,
            color: Colors.green[800],
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            trend,
            style: TextStyle(
              color: Colors.green[800],
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainingSuggestion(String suggestion) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[100]!),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.auto_awesome,
            color: Colors.blue,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              suggestion,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerChip(String playerName) {
    return Chip(
      label: Text(playerName),
      backgroundColor: Colors.blue[50],
      labelStyle: const TextStyle(color: Colors.blue),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.blue[100]!),
      ),
    );
  }
}