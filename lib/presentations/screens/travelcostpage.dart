import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TravelCostPage extends StatefulWidget {
  const TravelCostPage({super.key});

  @override
  _TravelCostPageState createState() => _TravelCostPageState();
}

class _TravelCostPageState extends State<TravelCostPage> {
  List<Map<String, dynamic>> events = [
    {
      "name": "National Athletics Meet",
      "location": "New Delhi",
      "travelMode": "Flight",
      "travelCost": 5000,
      "stayCostPerDay": 1500,
      "foodCostPerDay": 800,
      "days": 3,
      "suggestions": {
        "hotels": [
          {
            "name": "Hotel Sunrise", 
            "map": "https://www.google.com/maps/dir/?api=1&destination=28.6139,77.2090&travelmode=driving"
          },
          {
            "name": "Elite Residency", 
            "map": "https://www.google.com/maps/dir/?api=1&destination=28.6280,77.2069&travelmode=driving"
          }
        ],
        "food": [
          {"name": "High Protein Diet", "tip": "Reduce dining out by 2x/week saves ₹1000/month"},
          {"name": "Balanced Carbs & Protein", "tip": "Meal prep saves ₹800/month"}
        ],
        "travelWays": [
          {
            "name": "Flight from Mumbai", 
            "map": "https://www.google.com/maps/dir/?api=1&origin=19.0760,72.8777&destination=28.6139,77.2090&travelmode=driving"
          },
          {
            "name": "Train from Pune", 
            "map": "https://www.google.com/maps/dir/?api=1&origin=18.5204,73.8567&destination=28.6139,77.2090&travelmode=driving"
          }
        ],
      },
    },
    {
      "name": "State Championship",
      "location": "Mumbai",
      "travelMode": "Train",
      "travelCost": 2000,
      "stayCostPerDay": 1000,
      "foodCostPerDay": 600,
      "days": 2,
      "suggestions": {
        "hotels": [
          {
            "name": "Comfort Inn", 
            "map": "https://www.google.com/maps/dir/?api=1&destination=19.0760,72.8777&travelmode=driving"
          },
          {
            "name": "Budget Stay", 
            "map": "https://www.google.com/maps/dir/?api=1&destination=19.0176,72.8561&travelmode=driving"
          }
        ],
        "food": [
          {"name": "Local Veg Meals", "tip": "Cutting snacks saves ₹500/month"},
          {"name": "Fruits & Nuts", "tip": "Bulk buying saves ₹300/month"}
        ],
        "travelWays": [
          {
            "name": "Train from Bangalore", 
            "map": "https://www.google.com/maps/dir/?api=1&origin=12.9716,77.5946&destination=19.0760,72.8777&travelmode=driving"
          },
          {
            "name": "Bus from Goa", 
            "map": "https://www.google.com/maps/dir/?api=1&origin=15.2993,74.1240&destination=19.0760,72.8777&travelmode=driving"
          }
        ],
      },
    },
  ];

  void _showLocationOnMap(BuildContext context, String url) {
    final latLngMatch = RegExp(r'destination=([\d.]+),([\d.]+)').firstMatch(url);
    if (latLngMatch == null) return;

    final lat = double.parse(latLngMatch.group(1)!);
    final lng = double.parse(latLngMatch.group(2)!);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(lat, lng),
              zoom: 15,
            ),
            markers: {
              Marker(
                markerId: const MarkerId('location'),
                position: LatLng(lat, lng),
              ),
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showCostBreakdown(BuildContext context, Map<String, dynamic> event) {
    TextEditingController daysController = TextEditingController(text: event["days"].toString());
    TextEditingController travelCostController = TextEditingController(text: event["travelCost"].toString());
    TextEditingController stayCostController = TextEditingController(text: event["stayCostPerDay"].toString());
    TextEditingController foodCostController = TextEditingController(text: event["foodCostPerDay"].toString());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            bool isEditing = false;
            int days = int.parse(daysController.text);
            int travelCost = int.parse(travelCostController.text);
            int stayCost = int.parse(stayCostController.text);
            int foodCost = int.parse(foodCostController.text);

            void updateTotalCost() {
              setModalState(() {
                days = int.tryParse(daysController.text) ?? days;
                travelCost = int.tryParse(travelCostController.text) ?? travelCost;
                stayCost = int.tryParse(stayCostController.text) ?? stayCost;
                foodCost = int.tryParse(foodCostController.text) ?? foodCost;
              });
            }

            double totalCost = (travelCost + (stayCost * days) + (foodCost * days)).toDouble();
            double monthlySavings = totalCost / 6;

            String overspendMessage = "";
            List<String> savingTips = [];

            if (foodCost * days > stayCost * days) {
              overspendMessage = "Food expenses are higher than accommodation.";
              savingTips.add("Reduce dining out by 2x/week to save ₹1000/month");
              savingTips.add("Meal prep can save ₹800/month");
            }
            if (travelCost > (stayCost * days)) {
              overspendMessage += " Travel is costlier than stay.";
              savingTips.add("Book tickets 2-3 months early to save 30%");
              savingTips.add("Consider trains/buses instead of flights");
            }
            if (stayCost > 1200) {
              savingTips.add("Hostels/Airbnb can save ₹300-500/day");
            }

            return Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.sports_score, size: 30, color: Colors.blue),
                        const SizedBox(width: 10),
                        Text(event["name"], 
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 20, color: Colors.blue),
                        const SizedBox(width: 5),
                        Text("Location: ${event["location"]}", 
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(height: 15),
                    
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          setModalState(() {
                            isEditing = !isEditing;
                          });
                        },
                        child: Text(isEditing ? "Save" : "Edit", style: const TextStyle(color: Colors.white)),
                      ),
                    ),
                    
                    const Divider(color: Colors.blue),
                    const Text("Expense Breakdown", 
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
                    const SizedBox(height: 10),
                    
                    _buildCostRow(Icons.flight, "Travel Cost:", "₹$travelCost", 
                        travelCostController, isEditing, updateTotalCost),
                    _buildCostRow(Icons.calendar_today, "Number of Days:", "$days", 
                        daysController, isEditing, updateTotalCost),
                    _buildCostRow(Icons.hotel, "Stay Cost per Day:", "₹$stayCost", 
                        stayCostController, isEditing, updateTotalCost),
                    _buildCostRow(Icons.fastfood, "Food Cost per Day:", "₹$foodCost", 
                        foodCostController, isEditing, updateTotalCost),
                    
                    const Divider(color: Colors.blue),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Text("Total Estimated Cost: ₹${totalCost.toStringAsFixed(2)}", 
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5),
                          Text("Monthly Savings Required: ₹${monthlySavings.toStringAsFixed(2)}", 
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.red)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    if (overspendMessage.isNotEmpty)
                      Column(
                        children: [
                          const Divider(color: Colors.orange),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.orange[50],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Spending Alert!", 
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange)),
                                Text(overspendMessage),
                                const SizedBox(height: 10),
                                const Text("Savings Tips:", 
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                                ...savingTips.map((tip) => Text("• $tip")),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    
                    const Divider(color: Colors.blue),
                    _buildSuggestionSection("Recommended Hotels", event["suggestions"]["hotels"], Icons.hotel),
                    _buildSuggestionSection("Food Suggestions", event["suggestions"]["food"], Icons.fastfood),
                    _buildSuggestionSection("Travel Suggestions", event["suggestions"]["travelWays"], Icons.directions_transit),
                    
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Close", style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCostRow(IconData icon, String label, String value, 
      TextEditingController controller, bool isEditing, Function onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Colors.blue),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          ),
          isEditing
              ? SizedBox(
                  width: 100,
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    ),
                    onChanged: (val) => onChanged(),
                  ),
                )
              : Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }

  Widget _buildSuggestionSection(String title, List<dynamic> items, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(color: Colors.blue),
        Row(
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        ...items.map<Widget>((item) => ListTile(
          leading: Icon(icon, color: Colors.blue),
          title: Text(item["name"]),
          subtitle: item["tip"] != null ? Text(item["tip"]) : null,
          trailing: item["map"] != null 
              ? IconButton(
                  icon: const Icon(Icons.map, color: Colors.blue),
                  onPressed: () => _showLocationOnMap(context, item["map"]),
                )
              : null,
        )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.airplane_ticket, size: 30),
            SizedBox(width: 10),
            Text(
              "Travel Cost Estimator",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 10,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.blue[50]!],
          ),
        ),
        child: ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            int days = events[index]["days"];
            int travelCost = events[index]["travelCost"];
            int stayCost = events[index]["stayCostPerDay"] * days;
            int foodCost = events[index]["foodCostPerDay"] * days;
            double totalCost = (travelCost + stayCost + foodCost).toDouble();

            return Card(
              margin: const EdgeInsets.all(10),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(left: BorderSide(color: Colors.blue, width: 5)),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: const Icon(Icons.event, size: 40, color: Colors.blue),
                  title: Text(
                    events[index]["name"],
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children:  [
                          Icon(Icons.location_on, size: 16),
                          Text(" ${events[index]["location"]}"),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Total Estimated Cost: ₹${totalCost.toStringAsFixed(2)}",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: () => _showCostBreakdown(context, events[index]),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text("Details", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}