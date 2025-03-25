import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MedicalRecordsAccessScreen extends StatefulWidget {
  const MedicalRecordsAccessScreen({super.key});

  @override
  State<MedicalRecordsAccessScreen> createState() => _MedicalRecordsAccessScreenState();
}

class _MedicalRecordsAccessScreenState extends State<MedicalRecordsAccessScreen> {
  bool _coachAccess = true;
  bool _physioAccess = true;
  bool _teamDoctorAccess = false;
  bool _familyAccess = false;

  void _showSharingDialog(String reportName) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text("Share $reportName"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildShareOption("Team Coach", _coachAccess, (v) => setState(() => _coachAccess = v)),
              _buildShareOption("Physiotherapist", _physioAccess, (v) => setState(() => _physioAccess = v)),
              _buildShareOption("Team Doctor", _teamDoctorAccess, (v) => setState(() => _teamDoctorAccess = v)),
              _buildShareOption("Family Member", _familyAccess, (v) => setState(() => _familyAccess = v)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Updated sharing for $reportName")),
                );
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption(String role, bool value, Function(bool) onChanged) {
    return ListTile(
      leading: Icon(_getRoleIcon(role), color: Colors.blue[800]),
      title: Text(role),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.blue[800],
      ),
    );
  }

  IconData _getRoleIcon(String role) {
    switch (role) {
      case "Team Coach": return Icons.sports;
      case "Physiotherapist": return Icons.medical_services;
      case "Team Doctor": return Icons.local_hospital;
      case "Family Member": return Icons.family_restroom;
      default: return Icons.person;
    }
  }

  void _downloadReport(String reportName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Downloading $reportName...")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Medical Records Access', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[800],
        iconTheme: const IconThemeData(color: Colors.white),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAccessStats(),
            const SizedBox(height: 24),
            _buildRecentAccessHeader(),
            const SizedBox(height: 12),
            _buildReportCard(
              "MRI Report - Right Knee",
              "Dr. Hansraj Hathi",
              "Sports Medicine Center",
              "Imaging",
              "Feb 15, 2025",
              ["Coach", "Physiotherapist"],
            ),
            _buildReportCard(
              "Blood Test Results",
              "Dr. Naresh Trehan",
              "Health Diagnostics Lab",
              "Lab",
              "Jan 28, 2025",
              ["Team Doctor"],
            ),
            const SizedBox(height: 24),
            _buildAccessControlHeader(),
            const SizedBox(height: 12),
            _buildAccessControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildAccessStats() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(Icons.description, "12", "Reports"),
            _buildStatItem(Icons.share, "8", "Shared"),
            _buildStatItem(Icons.visibility, "24", "Views"),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.blue[800], size: 24),
        ),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildRecentAccessHeader() {
    return const Row(
      children: [
        Icon(Icons.history, color: Colors.blue),
        SizedBox(width: 8),
        Text("Recently Accessed", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildReportCard(String title, String doctor, String clinic, String type, String date, List<String> sharedWith) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_getReportIcon(type), color: Colors.blue[800]),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(type, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.person_outline, size: 18, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(doctor, style: TextStyle(fontSize: 15, color: Colors.grey[800])),
                const SizedBox(width: 12),
                Icon(Icons.medical_services_outlined, size: 18, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(clinic, style: TextStyle(fontSize: 15, color: Colors.grey[800])),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today_outlined, size: 18, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(date, style: TextStyle(fontSize: 15, color: Colors.grey[800])),
              ],
            ),
            const SizedBox(height: 16),
            const Text("Shared with:", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: sharedWith.map((role) => Chip(
                label: Text(role),
                backgroundColor: Colors.blue[50],
                labelStyle: const TextStyle(color: Colors.blue),
                avatar: Icon(_getRoleIcon(role), size: 18),
              )).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.download_outlined),
                    label: const Text("Download"),
                    onPressed: () => _downloadReport(title),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      side: const BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.share_outlined),
                    label: const Text("Share"),
                    onPressed: () => _showSharingDialog(title),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue[800],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getReportIcon(String type) {
    switch (type.toLowerCase()) {
      case "imaging": return Icons.photo_library_outlined;
      case "lab": return Icons.science_outlined;
      default: return Icons.description_outlined;
    }
  }

  Widget _buildAccessControlHeader() {
    return const Row(
      children: [
        Icon(Icons.security, color: Colors.blue),
        SizedBox(width: 8),
        Text("Access Controls", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildAccessControls() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildAccessItem("Team Coach", "View injury reports", _coachAccess, (v) => setState(() => _coachAccess = v)),
            const Divider(),
            _buildAccessItem("Physiotherapist", "View all medical reports", _physioAccess, (v) => setState(() => _physioAccess = v)),
            const Divider(),
            _buildAccessItem("Team Doctor", "Full access to records", _teamDoctorAccess, (v) => setState(() => _teamDoctorAccess = v)),
            const Divider(),
            _buildAccessItem("Family Member", "Basic health information", _familyAccess, (v) => setState(() => _familyAccess = v)),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Access settings saved")),
                  );
                },
                child: const Text("Save Changes"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue[800],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccessItem(String role, String description, bool value, Function(bool) onChanged) {
    return ListTile(
      leading: Icon(_getRoleIcon(role), color: Colors.blue[800]),
      title: Text(role),
      subtitle: Text(description, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.blue[800],
      ),
    );
  }
}