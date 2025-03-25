import 'package:flutter/material.dart';

class AllAthletesScreen extends StatefulWidget {
  const AllAthletesScreen({super.key});

  @override
  State<AllAthletesScreen> createState() => _AllAthletesScreenState();
}

class _AllAthletesScreenState extends State<AllAthletesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedSport;
  String? _selectedLocation;
  String? _selectedAgeGroup;
  String? _selectedGender;

  final List<Map<String, dynamic>> athletes = [
    {
      'name': 'Aman Singh',
      'position': 'Forward',
      'sport': 'Soccer',
      'age': '22 years',
      'stats': {'Speed': 92, 'Agility': 88, 'Strength': 75, 'Endurance': 85},
      'tags': ['Top Performer', 'Recent Improvement'],
      'isWatchlisted': false,
    },
    {
      'name': 'Rahul Sharma',
      'position': 'Midfielder',
      'sport': 'Soccer',
      'age': '24 years',
      'stats': {'Speed': 85, 'Agility': 82, 'Strength': 88, 'Endurance': 90},
      'tags': ['Consistent Player'],
      'isWatchlisted': true,
    },
    {
      'name': 'Priya Patel',
      'position': 'Defender',
      'sport': 'Soccer',
      'age': '21 years',
      'stats': {'Speed': 78, 'Agility': 85, 'Strength': 92, 'Endurance': 80},
      'tags': ['Emerging Talent'],
      'isWatchlisted': false,
    },
    {
      'name': 'Vikram Joshi',
      'position': 'Goalkeeper',
      'sport': 'Soccer',
      'age': '25 years',
      'stats': {'Speed': 82, 'Agility': 90, 'Strength': 85, 'Endurance': 88},
      'tags': ['Best Reflexes'],
      'isWatchlisted': false,
    },
  ];

  final List<String> sports = ['Soccer', 'Basketball', 'Tennis', 'Cricket'];
  final List<String> locations = ['Delhi', 'Mumbai', 'Bangalore', 'Hyderabad'];
  final List<String> ageGroups = ['18-21', '22-25', '26-30', '30+'];
  final List<String> genders = ['Male', 'Female', 'Other'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Search and Advanced Filters
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintText: 'Search athletes...',
                    prefixIcon: const Icon(Icons.search, color: Colors.blue),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  ),
                  onChanged: (value) => setState(() {}),
                ),
                const SizedBox(height: 16),
                
                // Advanced Filters
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdownFilter(
                        value: _selectedSport,
                        hint: 'Sport',
                        items: sports,
                        onChanged: (value) => setState(() => _selectedSport = value),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildDropdownFilter(
                        value: _selectedLocation,
                        hint: 'Location',
                        items: locations,
                        onChanged: (value) => setState(() => _selectedLocation = value),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdownFilter(
                        value: _selectedAgeGroup,
                        hint: 'Age Group',
                        items: ageGroups,
                        onChanged: (value) => setState(() => _selectedAgeGroup = value),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildDropdownFilter(
                        value: _selectedGender,
                        hint: 'Gender',
                        items: genders,
                        onChanged: (value) => setState(() => _selectedGender = value),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Athletes List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: athletes.length,
              itemBuilder: (context, index) => _buildAthleteCard(athletes[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownFilter({
    required String? value,
    required String hint,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButton<String>(
        value: value,
        hint: Text(hint),
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
      ),
    );
  }

  Widget _buildAthleteCard(Map<String, dynamic> athlete) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.blue[50],
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Text(
                        athlete['name'].split(' ').map((e) => e[0]).join(),
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              athlete['name'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                athlete['isWatchlisted'] 
                                    ? Icons.bookmark 
                                    : Icons.bookmark_border,
                                color: Colors.blue,
                              ),
                              onPressed: () => _toggleWatchlist(athlete),
                            ),
                          ],
                        ),
                        Text(
                          '${athlete['position']} • ${athlete['sport']} • ${athlete['age']}',
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          children: (athlete['tags'] as List<String>).map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                tag,
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 12,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Stats
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 3,
                children: [
                  _buildStatItem('Speed', athlete['stats']['Speed']),
                  _buildStatItem('Agility', athlete['stats']['Agility']),
                  _buildStatItem('Strength', athlete['stats']['Strength']),
                  _buildStatItem('Endurance', athlete['stats']['Endurance']),
                ],
              ),
              const SizedBox(height: 16),
              
              // View Profile Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'VIEW PROFILE',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleWatchlist(Map<String, dynamic> athlete) {
    setState(() {
      athlete['isWatchlisted'] = !athlete['isWatchlisted'];
    });
  }

  Widget _buildStatItem(String statName, int value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          statName,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: value / 100,
          backgroundColor: Colors.grey[300],
          color: Colors.blue,
          minHeight: 6,
          borderRadius: BorderRadius.circular(3),
        ),
        const SizedBox(height: 4),
        Text(
          '$value/100',
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}