import 'package:flutter/material.dart';

class SportKit {
  final String name;
  final String imageUrl;
  final String location;
  final double price;
  final double rating;
  final bool isAvailable;
  final String owner;
  final String condition;
  final String game;

  SportKit({
    required this.name,
    required this.imageUrl,
    required this.location,
    required this.price,
    required this.rating,
    required this.isAvailable,
    required this.owner,
    required this.condition,
    required this.game,
  });
}

class SportsKitPage extends StatefulWidget {
  const SportsKitPage({super.key});

  @override
  _SportsKitPageState createState() => _SportsKitPageState();
}

class _SportsKitPageState extends State<SportsKitPage> {
  String searchQuery = '';
  String selectedCondition = 'All';
  String selectedGame = 'All';
  String selectedLocation = 'All';
  bool showOnlyAvailable = false;
  double minPrice = 0;
  double maxPrice = 1000;

  final List<String> availableGames = [
    'All',
    'Cricket',
    'Football',
    'Basketball',
    'Badminton',
    'Tennis',
    'Hockey',
  ];
  final List<String> availableLocations = [
    'All',
    'Mumbai',
    'Delhi',
    'Bangalore',
    'Hyderabad',
    'Pune',
    'Chennai',
  ];

  final List<SportKit> sportKits = [
    SportKit(
      name: 'Cricket Bat (MRF)',
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSr4ZGjh76MIuVXoz5gZ0lEPQmS71AvwyE2pg&s',
      location: 'Mumbai',
      price: 100,
      rating: 4.5,
      isAvailable: true,
      owner: 'Rohit Sharma',
      condition: 'Excellent',
      game: 'Cricket',
    ),
    SportKit(
      name: 'Football Shoes (Nike)',
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRFg3KKb7QPsze5O4z-w1YeadSvLSR3tom2yQ&s',
      location: 'Delhi',
      price: 150,
      rating: 4.8,
      isAvailable: false,
      owner: 'Sunil Chhetri',
      condition: 'Good',
      game: 'Football',
    ),
    SportKit(
      name: 'Basketball (Spalding)',
      imageUrl:
          'https://m.media-amazon.com/images/I/61n14-+AqoL._AC_UF1000,1000_QL80_.jpg',
      location: 'Bangalore',
      price: 50,
      rating: 4.3,
      isAvailable: true,
      owner: 'Kobe Fan',
      condition: 'Excellent',
      game: 'Basketball',
    ),
    SportKit(
      name: 'Badminton Racket (Yonex)',
      imageUrl:
          'https://m.media-amazon.com/images/I/71YHhOZJN5L._AC_UF1000,1000_QL80_.jpg',
      location: 'Hyderabad',
      price: 70,
      rating: 4.6,
      isAvailable: true,
      owner: 'P.V. Sindhu',
      condition: 'Good',
      game: 'Badminton',
    ),
    SportKit(
      name: 'Tennis Racket (Wilson)',
      imageUrl:
          'https://m.media-amazon.com/images/I/71z6HrQY3BL._AC_UF1000,1000_QL80_.jpg',
      location: 'Pune',
      price: 120,
      rating: 4.7,
      isAvailable: true,
      owner: 'Roger Fan',
      condition: 'Excellent',
      game: 'Tennis',
    ),
    SportKit(
      name: 'Hockey Stick (Adidas)',
      imageUrl:
          'https://m.media-amazon.com/images/I/61XZQXFQ8RL._AC_UF1000,1000_QL80_.jpg',
      location: 'Chennai',
      price: 90,
      rating: 4.5,
      isAvailable: true,
      owner: 'Sandeep Singh',
      condition: 'Good',
      game: 'Hockey',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    List<SportKit> filteredKits =
        sportKits.where((kit) {
          return (searchQuery.isEmpty ||
                  kit.name.toLowerCase().contains(searchQuery.toLowerCase())) &&
              (selectedCondition == 'All' ||
                  kit.condition == selectedCondition) &&
              (selectedGame == 'All' || kit.game == selectedGame) &&
              (selectedLocation == 'All' || kit.location == selectedLocation) &&
              (kit.price >= minPrice && kit.price <= maxPrice) &&
              (!showOnlyAvailable || kit.isAvailable);
        }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gear Marketplace',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[800],
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search sports equipment...',
                    prefixIcon: Icon(Icons.search, color: Colors.blue[800]),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                ),
                SizedBox(height: 12),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilterChip(
                        label: Text('Available Only'),
                        selected: showOnlyAvailable,
                        onSelected: (bool value) {
                          setState(() {
                            showOnlyAvailable = value;
                          });
                        },
                        selectedColor: Colors.blue[100],
                        checkmarkColor: Colors.blue[800],
                        backgroundColor: Colors.grey[200],
                        labelStyle: TextStyle(
                          color:
                              showOnlyAvailable
                                  ? Colors.blue[800]
                                  : Colors.grey[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      FilterDropdown(
                        value: selectedGame,
                        items: availableGames,
                        label: 'Game',
                        onChanged:
                            (value) => setState(() => selectedGame = value!),
                      ),
                      SizedBox(width: 8),
                      FilterDropdown(
                        value: selectedLocation,
                        items: availableLocations,
                        label: 'Location',
                        onChanged:
                            (value) =>
                                setState(() => selectedLocation = value!),
                      ),
                      SizedBox(width: 8),
                      FilterDropdown(
                        value: selectedCondition,
                        items: ['All', 'Excellent', 'Good'],
                        label: 'Condition',
                        onChanged:
                            (value) =>
                                setState(() => selectedCondition = value!),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),

                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Price Range',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            '₹${minPrice.toInt()}',
                            style: TextStyle(color: Colors.blue[800]),
                          ),
                          Spacer(),
                          Text(
                            '₹${maxPrice.toInt()}',
                            style: TextStyle(color: Colors.blue[800]),
                          ),
                        ],
                      ),
                      RangeSlider(
                        values: RangeValues(minPrice, maxPrice),
                        min: 0,
                        max: 1000,
                        divisions: 20,
                        labels: RangeLabels(
                          '₹${minPrice.toInt()}',
                          '₹${maxPrice.toInt()}',
                        ),
                        activeColor: Colors.blue[800],
                        inactiveColor: Colors.grey[300],
                        onChanged: (RangeValues values) {
                          setState(() {
                            minPrice = values.start;
                            maxPrice = values.end;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child:
                filteredKits.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 60,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No items found',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            'Try adjusting your filters',
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    )
                    : GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: filteredKits.length,
                      itemBuilder: (context, index) {
                        return SportKitCard(sportKit: filteredKits[index]);
                      },
                    ),
          ),
        ],
      ),
    );
  }
}

class SportKitCard extends StatelessWidget {
  final SportKit sportKit;

  const SportKitCard({super.key, required this.sportKit});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 120,
                  width: double.infinity,
                  child: Image.network(
                    sportKit.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          color: Colors.grey[200],
                          child: Center(
                            child: Icon(
                              Icons.sports,
                              size: 40,
                              color: Colors.blue[800],
                            ),
                          ),
                        ),
                  ),
                ),
                // Availability ribbon
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color:
                          sportKit.isAvailable
                              ? Colors.blue[800]
                              : Colors.grey[600],
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          sportKit.isAvailable
                              ? Icons.check_circle
                              : Icons.cancel,
                          size: 14,
                          color: Colors.white,
                        ),
                        SizedBox(width: 4),
                        Text(
                          sportKit.isAvailable ? 'AVAILABLE' : 'UNAVAILABLE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[800],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          sportKit.game.toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          sportKit.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[900],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),

                  Row(
                    children: [
                      Icon(
                        Icons.currency_rupee,
                        size: 18,
                        color: Colors.blue[800],
                      ),
                      Text(
                        '${sportKit.price.toStringAsFixed(0)}/day',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.star, size: 16, color: Colors.amber),
                            SizedBox(width: 4),
                            Text(
                              sportKit.rating.toStringAsFixed(1),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[900],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 12),

                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      _buildDetailItem(
                        icon: Icons.location_on_outlined,
                        text: sportKit.location,
                      ),
                      _buildDetailItem(
                        icon: Icons.person_outline,
                        text: sportKit.owner,
                      ),
                      _buildDetailItem(
                        icon:
                            sportKit.condition == 'Excellent'
                                ? Icons.verified
                                : Icons.thumb_up,
                        text: sportKit.condition,
                        color:
                            sportKit.condition == 'Excellent'
                                ? Colors.green
                                : Colors.blue,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: sportKit.isAvailable ? () {} : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: Icon(Icons.shopping_basket_outlined),
                  label: Text(
                    'RENT NOW',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
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

  Widget _buildDetailItem({
    required IconData icon,
    required String text,
    Color? color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color ?? Colors.blue[800]),
        SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 12, color: Colors.blue[900])),
      ],
    );
  }
}

class FilterDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final String label;
  final ValueChanged<String?> onChanged;

  const FilterDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButton<String>(
        value: value,
        items:
            items.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item, style: TextStyle(fontSize: 14)),
              );
            }).toList(),
        onChanged: onChanged,
        underline: Container(),
        icon: Icon(Icons.arrow_drop_down, color: Colors.blue[800]),
        hint: Text(label),
        borderRadius: BorderRadius.circular(12),
        dropdownColor: Colors.white,
        style: TextStyle(color: Colors.black87),
      ),
    );
  }
}
