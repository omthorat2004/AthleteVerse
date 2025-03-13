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
  ];

  @override
  Widget build(BuildContext context) {
    List<SportKit> filteredKits = sportKits.where((kit) {
      return (searchQuery.isEmpty || kit.name.toLowerCase().contains(searchQuery.toLowerCase())) &&
          (selectedCondition == 'All' || kit.condition == selectedCondition);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Gear Marketplace',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.white),),
        backgroundColor: Colors.blueAccent,
      ),
      backgroundColor: Colors.white,
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
                DropdownButton<String>(
                  value: selectedCondition,
                  items: ['All', 'Excellent', 'Good']
                      .map((condition) => DropdownMenuItem(
                            value: condition,
                            child: Text(condition),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCondition = value!;
                    });
                  },
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
                      childAspectRatio: 0.64
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
      height: 500, 
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        shadowColor: Colors.grey.withOpacity(0.5),
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
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6),
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}