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

  final List<String> availableGames = ['All', 'Cricket', 'Football', 'Basketball', 'Badminton', 'Tennis', 'Hockey'];
  final List<String> availableLocations = ['All', 'Mumbai', 'Delhi', 'Bangalore', 'Hyderabad', 'Pune', 'Chennai'];

  final List<SportKit> sportKits = [
    SportKit(
      name: 'Cricket Bat (MRF)',
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRRJGOqINzTa3GeJaCc7Bvr0-KebEIPlmgIlA&s',
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
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRRJGOqINzTa3GeJaCc7Bvr0-KebEIPlmgIlA&s',
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
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRRJGOqINzTa3GeJaCc7Bvr0-KebEIPlmgIlA&s',
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
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRRJGOqINzTa3GeJaCc7Bvr0-KebEIPlmgIlA&s',
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
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRRJGOqINzTa3GeJaCc7Bvr0-KebEIPlmgIlA&s',
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
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRRJGOqINzTa3GeJaCc7Bvr0-KebEIPlmgIlA&s',
      location: 'Chennai',
      price: 90,
      rating: 4.5,
      isAvailable: true,
      owner: 'Sandeep Singh',
      condition: 'Good',
      game: 'Hockey',
    ),
        SportKit(
      name: 'Cricket Ball (Kookaburra)',
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRRJGOqINzTa3GeJaCc7Bvr0-KebEIPlmgIlA&s',
      location: 'Mumbai',
      price: 30,
      rating: 4.6,
      isAvailable: true,
      owner: 'Sachin Tendulkar',
      condition: 'Excellent',
      game: 'Cricket',
    ),
    SportKit(
      name: 'Football (Adidas)',
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRRJGOqINzTa3GeJaCc7Bvr0-KebEIPlmgIlA&s',
      location: 'Delhi',
      price: 45,
      rating: 4.7,
      isAvailable: true,
      owner: 'Lionel Messi Fan',
      condition: 'Good',
      game: 'Football',
    ),
    SportKit(
      name: 'Basketball Hoop (Lifetime)',
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRRJGOqINzTa3GeJaCc7Bvr0-KebEIPlmgIlA&s',
      location: 'Bangalore',
      price: 250,
      rating: 4.4,
      isAvailable: false,
      owner: 'LeBron James Fan',
      condition: 'Excellent',
      game: 'Basketball',
    ),
    SportKit(
      name: 'Badminton Shuttlecocks (Mavis)',
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRRJGOqINzTa3GeJaCc7Bvr0-KebEIPlmgIlA&s',
      location: 'Hyderabad',
      price: 15,
      rating: 4.5,
      isAvailable: true,
      owner: 'Carolina Marin Fan',
      condition: 'Good',
      game: 'Badminton',
    ),
    SportKit(
      name: 'Tennis Balls (Dunlop)',
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRRJGOqINzTa3GeJaCc7Bvr0-KebEIPlmgIlA&s',
      location: 'Pune',
      price: 20,
      rating: 4.8,
      isAvailable: true,
      owner: 'Rafael Nadal Fan',
      condition: 'Excellent',
      game: 'Tennis',
    ),
    SportKit(
      name: 'Hockey Ball (Kookaburra)',
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRRJGOqINzTa3GeJaCc7Bvr0-KebEIPlmgIlA&s',
      location: 'Chennai',
      price: 10,
      rating: 4.6,
      isAvailable: true,
      owner: 'Harmanpreet Singh Fan',
      condition: 'Good',
      game: 'Hockey',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    List<SportKit> filteredKits = sportKits.where((kit) {
      return (searchQuery.isEmpty || kit.name.toLowerCase().contains(searchQuery.toLowerCase())) &&
          (selectedCondition == 'All' || kit.condition == selectedCondition) &&
          (selectedGame == 'All' || kit.game == selectedGame) &&
          (selectedLocation == 'All' || kit.location == selectedLocation) &&
          (kit.price >= minPrice && kit.price <= maxPrice) &&
          (!showOnlyAvailable || kit.isAvailable);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Gear Marketplace', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.blueAccent,
      ),
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search Equipment...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent),
                      borderRadius: BorderRadius.circular(10)
                    )
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 8.0,
                  children: [
                    FilterDropdown(
                      value: selectedGame,
                      items: availableGames,
                      label: 'Game',
                      onChanged: (value) => setState(() => selectedGame = value),
                    ),
                    FilterDropdown(
                      value: selectedLocation,
                      items: availableLocations,
                      label: 'Location',
                      onChanged: (value) => setState(() => selectedLocation = value),
                    ),
                    FilterDropdown(
                      value: selectedCondition,
                      items: ['All', 'Excellent', 'Good'],
                      label: 'Condition',
                      onChanged: (value) => setState(() => selectedCondition = value),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Text('Min Price: ${minPrice.toStringAsFixed(0)}', style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black87),),
                            Slider(
                              value: minPrice,
                              min: 0,
                              max: maxPrice,
                              divisions: 1000,
                              label: minPrice.round().toString(),
                              activeColor: Colors.blueAccent,
                              onChanged: (value) => setState(() => minPrice = value),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                       child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Text('Max Price: ${maxPrice.toStringAsFixed(0)}', style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black87),),
                            Slider(
                              value: maxPrice,
                              min: minPrice,
                              max: 1000,
                              divisions: 1000,
                              label: maxPrice.round().toString(),
                              activeColor: Colors.blueAccent,
                              onChanged: (value) => setState(() => maxPrice = value),
                            ),
                        ],
                       ),
                    ),
                    
                  ],
                ),
                 SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: showOnlyAvailable,
                      onChanged: (value) => setState(() => showOnlyAvailable = value!),
                      activeColor: Colors.blueAccent,
                    ),
                    Text('Show Only Available',style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold),),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredKits.isEmpty
                ? Center(child: Text('No kits available'))
                : GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.75
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

  const SportKitCard({Key? key, required this.sportKit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 4,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                  child: Image.network(
                    sportKit.imageUrl,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          height: 100,
                          width: double.infinity,
                          child: Icon(Icons.error),
                        );
                      },
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      sportKit.game,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sportKit.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.black54, size: 16),
                      SizedBox(width: 4),
                      Text(
                        sportKit.location,
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.currency_rupee_sharp, color: Colors.black54, size: 16),
                      SizedBox(width: 4),
                      Text(
                        sportKit.price.toString(),
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Owner: ${sportKit.owner}',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Condition: ${sportKit.condition}',
                    style: TextStyle(fontSize: 14, color: Colors.green),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange, size: 18),
                      Text(
                        ' ${sportKit.rating}',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(8),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  'Rent Now',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FilterDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final String label;
  final ValueChanged<String> onChanged;

  const FilterDropdown({
    Key? key,
    required this.value,
    required this.items,
    required this.label,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: value,
      items: items
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item,style: TextStyle(color: Colors.black87)),
              ))
          .toList(),
      onChanged: (newValue) => onChanged(newValue!),
      hint: Text(label),
      underline: Container(
          height: 1.0,
          decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey, width: 1.0)))),
    );
  }
}