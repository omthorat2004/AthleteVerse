import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

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
  final TextEditingController _locationController = TextEditingController();
  String? selectedCategory;
  String? selectedUrgency;
  String? attachedFile;
  bool isSubmitting = false;

  final List<String> categories = [
    'Harassment',
    'Unfair Selection',
    'Medical Negligence',
    'Mental Health Issue',
    'Corruption',
    'Other'
  ];

  final List<String> urgencyLevels = ['Low', 'Medium', 'High'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF004D40),
        title: const Text(
          'Anonymous Reporting',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[600],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "Courage Wins, Silence Ends!\n"
                    "Report. Rise. Reclaim.\n"
                    "Silence Ends, Change Begins!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

             
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDropdownField(
                        label: "Issue Category",
                        hint: "Select an issue category",
                        value: selectedCategory,
                        items: categories,
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                      ),
                      const SizedBox(height: 15),
                      _buildDropdownField(
                        label: "Urgency Level",
                        hint: "Select urgency level",
                        value: selectedUrgency,
                        items: urgencyLevels,
                        onChanged: (value) {
                          setState(() {
                            selectedUrgency = value;
                          });
                        },
                      ),
                      const SizedBox(height: 15),
                      _buildTextField(
                        controller: _reportController,
                        label: "Describe the issue",
                        hint: "Provide detailed information",
                        maxLines: 5,
                      ),
                      const SizedBox(height: 15),
                      _buildTextField(
                        controller: _locationController,
                        label: "Location (Optional)",
                        hint: "Enter location if relevant",
                      ),
                      const SizedBox(height: 15),
                      _buildFilePicker(),
                      const SizedBox(height: 25),
                      Center(
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isSubmitting ? null : _submitReport,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              backgroundColor: isSubmitting ? Colors.grey : const Color(0xFF00796B),
                              elevation: 5,
                            ),
                            child: isSubmitting
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text(
                                    'Submit Report',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.grey.shade300, blurRadius: 5, offset: const Offset(0, 2))
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            hint: Text(hint),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
            validator: (value) => value == null ? 'Please select a value' : null,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(14),
          ),
          validator: (value) => value!.isEmpty ? 'This field cannot be empty' : null,
        ),
      ],
    );
  }

  Widget _buildFilePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Attach Proof (Optional) (Images, PDFs, etc.)",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: _pickFile,
              icon: const Icon(Icons.upload_file),
              label: const Text("Upload File"),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF26A69A)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                attachedFile ?? "No file selected",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: attachedFile != null ? Colors.green : Colors.grey),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf', 'doc', 'jpeg'],
    );

    if (result != null) {
      setState(() {
        attachedFile = result.files.single.name;
      });
    }
  }

  void _submitReport() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isSubmitting = true;
      });

      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          isSubmitting = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Report Submitted Successfully!"), backgroundColor: const Color(0xFF2E7D32)),
        );

        Navigator.pop(context);
      });
    }
  }
}
