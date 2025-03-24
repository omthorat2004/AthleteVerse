import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AnonymousReportScreen extends StatefulWidget {
  const AnonymousReportScreen({Key? key}) : super(key: key);
  @override
  State<AnonymousReportScreen> createState() => _AnonymousReportScreenState();
}

class _AnonymousReportScreenState extends State<AnonymousReportScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _issueDescriptionController = TextEditingController();
  String? _selectedCategory;
  String? _selectedResolutionType;
  String? _selectedFrequency;
  String? _selectedConfidentiality;
  String? _attachedFileName;
  LatLng? _selectedLocation;
  bool _isSubmitting = false;

  final List<String> _issueCategories = [
    'Harassment',
    'Unfair Selection',
    'Medical Negligence',
    'Corruption',
    'Other'
  ];

  final List<String> _issueFrequencies = ['First time', 'Occasionally', 'Frequently', 'Ongoing issue'];
  final List<String> _confidentialityPreferences = ['Fully anonymous', 'Share details with only trusted officials', 'Open for further discussion'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          'Anonymous Reporting',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 4,

      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue[700],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "Report. Rise. Reclaim.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  _buildDropdownField("Issue Category", "Select an issue category",
                      _selectedCategory, _issueCategories, (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },),
                  const SizedBox(height: 15),
                    _buildDropdownField("Type of Resolution Needed", "Select type of resolution needed", _selectedResolutionType, ['Awareness (Just informing)', 'Investigation (Need action)', 'Immediate intervention (Urgent action required)'], (value) {
                    setState(() {_selectedResolutionType = value;});
                  },),
                    const SizedBox(height: 15),
                  _buildDropdownField(
                      "Frequency of the Issue", "Select frequency of the issue",_selectedFrequency,
                      _issueFrequencies, (value) {
                    setState(() {
                      _selectedFrequency = value;
                    });
                  }),
                  const SizedBox(height: 15),
                  _buildDropdownField(
                      "Confidentiality Preference",
                      "Select your confidentiality preference",
                      _selectedConfidentiality,
                      _confidentialityPreferences, (value) {
                    setState(() {
                      _selectedConfidentiality = value;
                    });
                  }),
                  const SizedBox(height: 15),
                  _buildTextField(_issueDescriptionController, "Describe the issue","Provide detailed information",maxLines: 5),
                  const SizedBox(height: 15),
                  _buildLocationPicker(),
                  const SizedBox(height: 15),
                  _buildFilePicker(),
                  const SizedBox(height: 25),
                  _submitButton(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                ],

              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField(
      String label,
      String hint,
      String? value,
      List<String> items,
      void Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),

        DropdownButtonFormField<String>(
          isExpanded: true,

          value: value,
          hint: Text(hint),
          items: items.map((String item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
          validator: (value) =>
              value == null ? 'Please select a value' : null,
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      String hint, {int maxLines = 1}) {
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
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: const EdgeInsets.all(14),
          ),
          validator: (value) =>
              value!.isEmpty ? 'This field cannot be empty' : null,
        ),
      ],
    );
  }

  Widget _buildLocationPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Location", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: _selectLocationOnMap,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Row(
              children: [
               
                const SizedBox(
                  width: 30,
                  height: 30,
                  child: Image(
                    image: AssetImage('location.jpg'),
                  ),
                ),
                Expanded(
                  child: Text(
                    _selectedLocation == null
                        ? "Select location on map"
                        : "Lat: ${_selectedLocation!.latitude}, Lng: ${_selectedLocation!.longitude}",
                    style: const TextStyle(fontSize: 16), 
                  ),
                ), 
              ],
            ),
          ),
        ),
      ], 
    );
  }

  Future<void> _selectLocationOnMap() async {
    final LatLng? result = await Navigator.push<LatLng>(
      context,
      MaterialPageRoute(builder: (context) => const LocationPickerScreen()),
    );
    if (result != null) {
      setState(() => _selectedLocation = result);
    }
  }

  Widget _buildFilePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Attach Proof (Images, PDFs, etc.)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: () => _pickFile(),
              icon: const Icon(Icons.device_hub, color: Colors.white),
              label: const Text("My Device", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[700]),
            ),
            const SizedBox(width: 10),
             OutlinedButton.icon(
              onPressed: () => _pickFile(fromDevice: false),
              icon: Image.asset("drive.png", width: 24, height: 24),
              label: const Text("Drive", style: TextStyle(color: Colors.blue)),
              style: OutlinedButton.styleFrom(
                 side: const BorderSide(color: Colors.blue, width: 1.5),
              ),
            ),
          ],
        ),
        if (_attachedFileName != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text('Attached: $_attachedFileName', style: const TextStyle(color: Colors.blue),),
            )
      ],
    );
  }

  Future<void> _pickFile({bool fromDevice = true}) async {
    if (fromDevice) {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        setState(() => _attachedFileName = result.files.single.name);
      }
    } else {
      try {
        GoogleSignIn googleSignIn = GoogleSignIn(scopes: [drive.DriveApi.driveFileScope]);
        GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
        if (googleSignInAccount == null) return;
        final authHeaders = await googleSignInAccount.authHeaders;
        final authenticateClient = GoogleAuthClient(authHeaders);
        final driveApi = drive.DriveApi(authenticateClient);
        FilePickerResult? result = await FilePicker.platform.pickFiles();
        if (result != null) setState(() => _attachedFileName = result.files.single.name);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Drive Error: $e")));
      }
    }
  }

  Widget _submitButton() {
    return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _isSubmitting ? null : _submitReport,
          style: ElevatedButton.styleFrom(
            backgroundColor: _isSubmitting ? Colors.grey : Colors.blue[800],
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 5,
          ),
          child: _isSubmitting ? const CircularProgressIndicator(color: Colors.white) : const Text('Submit Report',style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
        ));
  }

  void _submitReport() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
      Future.delayed(const Duration(seconds: 2), () {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Report Submitted Successfully!")));
        Navigator.pop(context);
      });
    }
  }
}

class GoogleAuthClient extends http.BaseClient {

  final Map<String, String> _headers;
  final http.Client _client = http.Client();
  GoogleAuthClient(this._headers);


  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }

  @override
  void close() {
    _client.close();
    super.close();
  }
}

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({Key? key}) : super(key: key);
  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}
class _LocationPickerScreenState extends State<LocationPickerScreen> {
  GoogleMapController? mapController;
  LatLng _currentLocation = const LatLng(37.42796133580664, -122.085749655962);
  Set<Marker> markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
   
      markers.add(
        Marker(
          markerId: const MarkerId("selected_location"),
          position: _currentLocation,
        ),
      );
  }

  void _onMapTap(LatLng location) {
    setState(() {
      _currentLocation = location;
      markers.clear(); 
      markers.add(
        Marker(
          markerId: const MarkerId("selected_location"),
          position: _currentLocation,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Location"),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _currentLocation,
          zoom: 11.0,
        ),
        markers: markers,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context, _currentLocation),
        child: const Icon(Icons.check),
      ),
    );
  }
}
