import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class CalorieTrackerScreen extends StatefulWidget {
  const CalorieTrackerScreen({super.key});

  @override
  State<CalorieTrackerScreen> createState() => _CalorieTrackerScreenState();
}

class _CalorieTrackerScreenState extends State<CalorieTrackerScreen> {
  static const String _apiKey = 'AIzaSyBYNdVzAC6412yfRCH-Huxr5Vuqjm6UV90';
  late GenerativeModel _model;

  final TextEditingController _foodController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final List<Map<String, dynamic>> _foodItems = [];
  double _totalCalories = 0.0;
  bool _isSubmitted = false;
  final double _dailyGoal = 2000.0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
      generationConfig: GenerationConfig(temperature: 0.4, topK: 20),
    );
  }

  Future<void> _addFoodItem() async {
    if (_foodController.text.isEmpty || _quantityController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final food = _foodController.text.toLowerCase();
      final quantity = double.parse(_quantityController.text);

      final prompt = '''
For $quantity grams of $food, provide nutrition data in this exact JSON format:
{
  "name": "$food",
  "quantity": $quantity,
  "calories_per_100g": X,
  "total_calories": Y,
  "carbs_g": Z,
  "protein_g": W,
  "fat_g": V
}

Where X,Y,Z,W,V are numbers. Return ONLY the JSON object.''';

      final response = await _model.generateContent([Content.text(prompt)]);
      final jsonString = response.text
              ?.replaceAll('```json', '')
              .replaceAll('```', '')
              .trim() ??
          '';
      final foodData = json.decode(jsonString) as Map<String, dynamic>;

      setState(() {
        _foodItems.add(foodData);
        _totalCalories += (foodData['total_calories'] as num).toDouble();
        _foodController.clear();
        _quantityController.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _removeFoodItem(int index) {
    setState(() {
      _totalCalories -= _foodItems[index]['total_calories'];
      _foodItems.removeAt(index);
    });
  }

  void _submitCalories() {
    setState(() => _isSubmitted = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Daily log submitted'),
        backgroundColor: Colors.green,
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _foodItems.clear();
        _totalCalories = 0;
        _isSubmitted = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition Tracker'),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Input Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _foodController,
                              decoration: const InputDecoration(
                                labelText: 'Food Name',
                                border: OutlineInputBorder(),
                              ),
                              enabled: !_isSubmitted,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _quantityController,
                              decoration: const InputDecoration(
                                labelText: 'Grams',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              enabled: !_isSubmitted,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _isSubmitted || _isLoading
                                  ? null
                                  : _addFoodItem,
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              child: const Text('Add Food Item'),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Food Items List
                    if (_foodItems.isNotEmpty)
                      Expanded(
                        child: Card(
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  'Today\'s Foods',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _foodItems.length,
                                  itemBuilder: (context, index) {
                                    final item = _foodItems[index];
                                    return ListTile(
                                      title: Text(
                                        item['name'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        '${item['quantity']}g • ${item['total_calories']} kcal\n'
                                        'Carbs: ${item['carbs_g']}g • Protein: ${item['protein_g']}g • Fat: ${item['fat_g']}g',
                                      ),
                                      trailing: IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: _isSubmitted
                                            ? null
                                            : () => _removeFoodItem(index),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    const SizedBox(height: 16),

                    // Progress Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Text(
                              'Daily Progress',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            LinearProgressIndicator(
                              value: _totalCalories / _dailyGoal,
                              backgroundColor: Colors.grey[300],
                              color: _totalCalories > _dailyGoal
                                  ? Colors.red
                                  : Colors.green,
                              minHeight: 12,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${_totalCalories.toStringAsFixed(2)} / $_dailyGoal kcal',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            if (_foodItems.isNotEmpty && !_isSubmitted)
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _submitCalories,
                                  child: const Text('Submit Daily Log'),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}