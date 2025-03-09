import 'package:flutter/material.dart';

class SportKit {
  final String name;
  final String imageUrl;
  final String location;
  final double price;
  final double rating;
  final bool isAvailable;

  SportKit({
    required this.name,
    required this.imageUrl,
    required this.location,
    required this.price,
    required this.rating,
    required this.isAvailable,
  });
}

class SportsKitPage extends StatelessWidget {
  // Dummy list of sports kits
  final List<SportKit> sportKits = [
    SportKit(
      name: 'Cricket Bat (MRF)',
      imageUrl: 'https://via.placeholder.com/150',
      location: 'Mumbai',
      price: 100,
      rating: 4.5,
      isAvailable: true,
    ),
    SportKit(
      name: 'Football Shoes (Nike)',
      imageUrl: 'https://via.placeholder.com/150',
      location: 'Delhi',
      price: 150,
      rating: 4.8,
      isAvailable: false,
    ),
    SportKit(
      name: 'Tennis Racket (Yonex)',
      imageUrl: 'https://via.placeholder.com/150',
      location: 'Bangalore',
      price: 200,
      rating: 4.9,
      isAvailable: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sports Kits for Rent'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, 
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.75, 
          ),
          itemCount: sportKits.length,
          itemBuilder: (context, index) {
            return SportKitCard(sportKit: sportKits[index]);
          },
        ),
      ),
    );
  }
}

class SportKitCard extends StatelessWidget {
  final SportKit sportKit;

  const SportKitCard({Key? key, required this.sportKit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              sportKit.imageUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sportKit.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '📍 ${sportKit.location}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  '💰 ₹${sportKit.price.toStringAsFixed(2)}/day',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '⭐ ${sportKit.rating}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      sportKit.isAvailable ? 'Available ✅' : 'Rented ❌',
                      style: TextStyle(
                        color: sportKit.isAvailable ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
