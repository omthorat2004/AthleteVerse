import 'package:flutter/material.dart';

class TravelCostPage extends StatefulWidget {
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
        "hotels": ["Hotel Sunrise", "Elite Residency"],
        "food": ["High Protein Diet", "Balanced Carbs & Protein"],
        "travelWays": ["Flight from Mumbai", "Train from Pune"],
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
        "hotels": ["Comfort Inn", "Budget Stay"],
        "food": ["Local Veg Meals", "Fruits & Nuts"],
        "travelWays": ["Train from Bangalore", "Bus from Goa"],
      },
    },
  ];

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

            void _updateTotalCost() {
              setModalState(() {
                days = int.tryParse(daysController.text) ?? days;
                travelCost = int.tryParse(travelCostController.text) ?? travelCost;
                stayCost = int.tryParse(stayCostController.text) ?? stayCost;
                foodCost = int.tryParse(foodCostController.text) ?? foodCost;
              });
            }

            double totalCost = (travelCost + (stayCost * days) + (foodCost * days)).toDouble();
            double monthlySavings = totalCost / 6;

            // Calculate overspending
            String overspendMessage = "";
            if (foodCost * days > stayCost * days) {
              overspendMessage = "Consider reducing food expenses to save more.";
            } else if (travelCost > (stayCost * days)) {
              overspendMessage = "Consider cheaper travel options like trains or buses.";
            }

            return Padding(
              padding: EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(event["name"], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Text("Location: ${event["location"]}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    SizedBox(height: 15),
                    
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          setModalState(() {
                            isEditing = !isEditing;
                          });
                        },
                        child: Text(isEditing ? "Save" : "Edit"),
                      ),
                    ),
                    
                    Divider(),
                    Text("Expense Breakdown", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    
                    _buildCostRow("Travel Cost:", "₹$travelCost", travelCostController, isEditing, _updateTotalCost),
                    _buildCostRow("Number of Days:", "$days", daysController, isEditing, _updateTotalCost),
                    _buildCostRow("Stay Cost per Day:", "₹$stayCost", stayCostController, isEditing, _updateTotalCost),
                    _buildCostRow("Food Cost per Day:", "₹$foodCost", foodCostController, isEditing, _updateTotalCost),
                    
                    Divider(),
                    Text("Total Estimated Cost: ₹${totalCost.toStringAsFixed(2)}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("Monthly Savings Required: ₹${monthlySavings.toStringAsFixed(2)}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.red)),
                    SizedBox(height: 20),
                    
                    Divider(),
                    Text("Overspend Suggestion: $overspendMessage", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.orange)),
                    SizedBox(height: 20),
                    
                    Divider(),
                    _buildSuggestionSection("Recommended Hotels", event["suggestions"]["hotels"], Icons.hotel),
                    _buildSuggestionSection("Food Suggestions", event["suggestions"]["food"], Icons.fastfood),
                    _buildSuggestionSection("Travel Suggestions", event["suggestions"]["travelWays"], Icons.directions_transit),
                    
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Close"),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCostRow(String label, String value, TextEditingController controller, bool isEditing, Function onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          isEditing
              ? SizedBox(
                  width: 100,
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    ),
                    onChanged: (val) => onChanged(),
                  ),
                )
              : Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }

  Widget _buildSuggestionSection(String title, List<dynamic> items, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(),
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ...items.map<Widget>((item) => ListTile(leading: Icon(icon), title: Text(item))).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Travel Cost Estimator",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          int days = events[index]["days"];
          int travelCost = events[index]["travelCost"];
          int stayCost = events[index]["stayCostPerDay"] * days;
          int foodCost = events[index]["foodCostPerDay"] * days;
          double totalCost = (travelCost + stayCost + foodCost).toDouble();

          return Card(
            margin: EdgeInsets.all(10),
            elevation: 3,
            child: ListTile(
              title: Text(
                events[index]["name"],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Location: ${events[index]["location"]}",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "Total Estimated Cost: ₹${totalCost.toStringAsFixed(2)}",
                  ),
                ],
              ),
              trailing: TextButton(
                onPressed: () => _showCostBreakdown(context, events[index]),
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blueAccent)),
                child: Text("View More", style: TextStyle(color: Colors.white)),
              ),
            ),
          );
        },
      ),
    );
  }
}
