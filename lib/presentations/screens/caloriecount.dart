import 'package:flutter/material.dart';

class CalorieTrackerScreen extends StatefulWidget {
  const CalorieTrackerScreen({super.key});

  @override
  State<CalorieTrackerScreen> createState() => _CalorieTrackerScreenState();
}

class _CalorieTrackerScreenState extends State<CalorieTrackerScreen> {
  final TextEditingController _ingredientController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  List<Map<String, dynamic>> _ingredients = [];
  double _totalCalories = 0.0;
  bool _isSubmitted = false;
  double _dailyGoal = 2000.0; // Default daily calorie goal

  final Map<String, double> _ingredientCalories = {
    'apple': 0.52,
    'banana': 0.89,
    'chicken': 1.65,
    'rice': 1.3,
    'bread': 2.65,
    'egg': 1.43,
    'milk': 0.42,
    'potato': 0.77,
  };

  void _addIngredient() {
    if (_ingredientController.text.isNotEmpty && _quantityController.text.isNotEmpty) {
      String ingredient = _ingredientController.text.toLowerCase();
      double quantity = double.parse(_quantityController.text);

      if (_ingredientCalories.containsKey(ingredient)) {
        double calories = _ingredientCalories[ingredient]! * quantity;
        setState(() {
          _ingredients.add({
            'name': ingredient,
            'quantity': quantity,
            'calories': calories,
          });
          _totalCalories += calories;
          _ingredientController.clear();
          _quantityController.clear();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ingredient not found in database!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _removeIngredient(int index) {
    setState(() {
      _totalCalories -= _ingredients[index]['calories'];
      _ingredients.removeAt(index);
    });
  }

  void _submitCalories() {
    setState(() {
      _isSubmitted = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Submitted ${_totalCalories.toStringAsFixed(2)} kcal for today!'),
        backgroundColor: Colors.green,
      ),
    );

    // Reset all values
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _ingredients.clear();
        _totalCalories = 0.0;
        _isSubmitted = false;
      });
    });
  }

  // AI-Based Recommendations
  String _getRecommendation() {
    if (_totalCalories > _dailyGoal) {
      return 'You\'ve exceeded your daily calorie goal. Consider lighter options like salads or grilled chicken.';
    } else if (_totalCalories == _dailyGoal) {
      return 'Great job! You\'ve met your daily calorie goal.';
    } else {
      return 'You\'re on track! Add a healthy snack like a banana or yogurt to meet your goal.';
    }
  }

  // Nutritional Insights
  Map<String, double> _getMacronutrients() {
    double carbs = 0.0, proteins = 0.0, fats = 0.0;
    for (var ingredient in _ingredients) {
      switch (ingredient['name']) {
        case 'apple':
        case 'banana':
        case 'potato':
          carbs += ingredient['calories'] * 0.8; // 80% carbs
          break;
        case 'chicken':
        case 'egg':
          proteins += ingredient['calories'] * 0.7; // 70% proteins
          break;
        case 'bread':
        case 'milk':
          fats += ingredient['calories'] * 0.5; // 50% fats
          break;
      }
    }
    return {'carbs': carbs, 'proteins': proteins, 'fats': fats};
  }

  @override
  Widget build(BuildContext context) {
    final macronutrients = _getMacronutrients();
    final recommendation = _getRecommendation();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calorie Tracker'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Add Ingredient',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _ingredientController,
                      decoration: InputDecoration(
                        labelText: 'Ingredient Name',
                        hintText: 'e.g., Apple, Chicken Breast',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.blueAccent),
                        ),
                        enabled: !_isSubmitted,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _quantityController,
                      decoration: InputDecoration(
                        labelText: 'Quantity (grams)',
                        hintText: 'e.g., 100, 200',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.blueAccent),
                        ),
                        enabled: !_isSubmitted,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isSubmitted ? null : _addIngredient,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Add Ingredient',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: [
                  if (_ingredients.isNotEmpty)
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Nutritional Insights',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Carbs: ${macronutrients['carbs']?.toStringAsFixed(2)} kcal',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Proteins: ${macronutrients['proteins']?.toStringAsFixed(2)} kcal',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Fats: ${macronutrients['fats']?.toStringAsFixed(2)} kcal',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  if (_ingredients.isNotEmpty)
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'AI Recommendations',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              recommendation,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  ..._ingredients.map((ingredient) {
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        title: Text(
                          ingredient['name'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '${ingredient['quantity']}g - ${ingredient['calories'].toStringAsFixed(2)} kcal',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.blueAccent,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: _isSubmitted ? null : () => _removeIngredient(_ingredients.indexOf(ingredient)),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Total Calories Today',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${_totalCalories.toStringAsFixed(2)} kcal / $_dailyGoal kcal',
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: _totalCalories / _dailyGoal,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_ingredients.isNotEmpty && !_isSubmitted)
              ElevatedButton(
                onPressed: _submitCalories,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Submit Today\'s Calories',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            if (_isSubmitted)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Today\'s calories are recorded. You can\'t add now.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}