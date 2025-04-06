import 'package:flutter/material.dart';

class ParaAthleteVenuePage extends StatelessWidget {
  const ParaAthleteVenuePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Jawaharlal Nehru Stadium - Accessibility',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[800],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Venue Overview'),
            _buildInfoCard(
              'Main Stadium',
              'Capacity: 60,000\nSurface: Synthetic track (World Athletics certified)\nLighting: 2000 lux (adjustable)\nField Dimensions: 400m standard track with 8 lanes\nCoverage: 70% sheltered seating\nLocation: Lodhi Road, New Delhi',
              Icons.stadium,
            ),
            _buildInfoCard(
              'Training Facilities',
              '• 4 accessible training grounds\n• Adjustable equipment for various disabilities\n• Hydrotherapy pool (32°C constant)\n• Open daily 5:30 AM - 10:30 PM\n• Dedicated physiotherapy center\n• Yoga and meditation zone',
              Icons.fitness_center,
            ),
            
            _buildSectionHeader('Accessibility Features'),
            _buildFeatureItem('Wheelchair Access', '• Ramps with 1:10 slope at all entries\n• 10 automatic doors with sensors\n• 8 elevators with braille buttons\n• 2m wide pathways throughout venue', Icons.accessible),
            _buildFeatureItem('Accessible Seating', '• 300 wheelchair spaces with companion seats\n• 40 power wheelchair charging points\n• Elevated viewing platforms\n• 15% reserved accessible seating', Icons.event_seat),
            _buildFeatureItem('Tactile Pathways', '• 3km of tactile guidance paths\n• Braille signage in Hindi and English\n• Audio navigation beacons\n• High-contrast visual markers', Icons.directions_walk),
            _buildFeatureItem('Accessible Restrooms', '• 25 disability-friendly toilets\n• 10 with adult changing tables\n• Emergency alarm systems\n• Western-style facilities with grab bars', Icons.wc),
            _buildFeatureItem('Sensory Support', '• 3 quiet rooms with dimmable lights\n• Sensory kits available\n• Visual alert systems\n• Noise-reduced zones', Icons.hearing),
            
            _buildSectionHeader('Athlete Support Services'),
            _buildServiceCard(
              'Medical Support',
              '• 20 disability-specialized doctors\n• 24/7 emergency care unit\n• Prosthetic/orthotic repair\n• Ayurveda therapy options\n• Mental health counselors\n• Heat stroke prevention units',
              Icons.medical_services,
            ),
            _buildServiceCard(
              'Equipment Services',
              '• Wheelchair repair workshop\n• 50 charging stations\n• 30 loaner wheelchairs\n• Daily equipment checks\n• Spare parts for Indian-made chairs\n• Cleaning and maintenance',
              Icons.build,
            ),
            _buildServiceCard(
              'Personal Assistance',
              '• 100 trained volunteers\n• Guide runners and assistants\n• Sign language interpreters (Hindi/English)\n• Personal care attendants\n• Mobility aid providers',
              Icons.accessible_forward,
            ),
            
            _buildSectionHeader('Transportation'),
            _buildTransportItem('Drop-off Points', '• 4 accessible gates (Gates 2, 5, 7, 9)\n• Covered drop-off areas\n• Priority parking near entrances\n• 2-hour free parking for disabled'),
            _buildTransportItem('Public Transport', '• Nearest Metro: JLN Stadium (500m)\n• 10 low-floor DTC buses stop nearby\n• Auto-rickshaw stand with accessible vehicles\n• Dedicated taxi pickup zone'),
            _buildTransportItem('Shuttle Service', '• Electric buggies every 10 minutes\n• Wheelchair-accessible vans\n• Route to nearby hotels\n• Operates 6AM-midnight'),
            
            _buildSectionHeader('Competition Facilities'),
            _buildInfoCard(
              'Competition Areas',
              '• All fields wheelchair-accessible\n• Shock-absorbent surfaces\n• Adjustable equipment heights\n• 10 camera review stations\n• Indian-standard measurements',
              Icons.sports,
            ),
            _buildInfoCard(
              'Classification Center',
              '• Open 15 days before events\n• 8 assessment rooms\n• Hindi/English speaking classifiers\n• Temporary classification available\n• Privacy ensured',
              Icons.assignment_ind,
            ),
            
            _buildSectionHeader('Emergency Services'),
            _buildInfoCard(
              'Evacuation Plan',
              '• 150 trained evacuation staff\n• 20 refuge areas\n• Evacuation chairs at staircases\n• Priority for wheelchair users\n• Monthly safety drills',
              Icons.emergency,
            ),
            _buildInfoCard(
              'Medical Emergency',
              '• 10 AED stations\n• 5-minute response guarantee\n• Tie-ups with AIIMS and Safdarjung\n• Blood bank on standby\n• Heat illness protocols',
              Icons.local_hospital,
            ),
            
            _buildSectionHeader('Indian Special Features'),
            _buildFeatureItem('Cultural Accessibility', '• Prayer rooms for all faiths\n• Vegetarian dining options\n• Traditional healing services\n• Multilingual support (10 Indian languages)', Icons.language),
            _buildFeatureItem('Local Adaptations', '• Jugaad repair solutions\n• Indian wheelchair models supported\n• Heat mitigation strategies\n• Monsoon preparedness', Icons.engineering),
            
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  Text('For assistance in Delhi venue:',
                      style: TextStyle(color: Colors.blue[800], fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('Helpline: +91 11 2337 1234',
                      style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Email: access.delhi@sportsindia.org',
                      style: TextStyle(color: Colors.blue[800])),
                  const SizedBox(height: 8),
                  Text('SMS: ACCESS to 56767',
                      style: TextStyle(color: Colors.blue[800])),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.blue[800],
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String details, IconData icon) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue[800]),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.blue[800],
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              details,
              style: const TextStyle(color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String title, String description, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue[800]),
      title: Text(title, style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.bold)),
      subtitle: Text(description, style: const TextStyle(color: Colors.black87)),
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
    );
  }

  Widget _buildServiceCard(String title, String bulletPoints, IconData icon) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.blue[800]!, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue[800]),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.blue[800],
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              bulletPoints,
              style: const TextStyle(color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransportItem(String title, String details) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.directions_bus, color: Colors.blue[800], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.bold)),
                Text(details, style: const TextStyle(color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}