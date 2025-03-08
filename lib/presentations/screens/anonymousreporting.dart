import 'package:flutter/material.dart';

class AnonymousReportScreen extends StatefulWidget {
  const AnonymousReportScreen({super.key});

  static String routeName = 'AnonymousReport';
  static String routePath = '/anonymous_report';

  @override
  State<AnonymousReportScreen> createState() => _AnonymousReportScreenState();
}

class _AnonymousReportScreenState extends State<AnonymousReportScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _reportController = TextEditingController();
  String? selectedCategory;
  bool isSubmitting = false;

  final List<String> categories = [
    'Harassment',
    'Unfair Selection',
    'Medical Negligence',
    'Mental Health Issue',
    'Corruption',
    'Other'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'Anonymous Reporting',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category Dropdown
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  hint: const Text("Select Issue Category"),
                  items: categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                  ),
                  validator: (value) => value == null ? 'Please select a category' : null,
                ),
                const SizedBox(height: 15),

                // Report Input Field
                TextFormField(
                  controller: _reportController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Describe the issue',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                  validator: (value) => value!.isEmpty ? 'Please enter details' : null,
                ),
                const SizedBox(height: 15),

                // Submit Button
                Center(
                  child: ElevatedButton(
                    onPressed: isSubmitting ? null : _submitReport,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    ),
                    child: isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Submit Report',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitReport() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isSubmitting = true;
      });

      // Simulate sending data
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          isSubmitting = false;
        });

        // Generate an anonymous report ID (For tracking purpose)
        String reportID = DateTime.now().millisecondsSinceEpoch.toString();

        // Show Success Message
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Report Submitted"),
            content: Text("Your report has been submitted successfully.\nReport ID: $reportID"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context); // Close the screen
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
      });
    }
  }
}
