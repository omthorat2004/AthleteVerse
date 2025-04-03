import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AthleteSponsorshipPage extends StatefulWidget {
  const AthleteSponsorshipPage({super.key});

  @override
  _AthleteSponsorshipPageState createState() => _AthleteSponsorshipPageState();
}

class _AthleteSponsorshipPageState extends State<AthleteSponsorshipPage> {
  int _selectedTabIndex = 0; // 0 for All, 1 for Recommended

  final List<Sponsorship> _allSponsorships = [
    Sponsorship(
      id: '1',
      company: 'Nike',
      title: 'Elite Performance Sponsorship',
      description: '3-year contract for professional athletes in basketball',
      logoUrl: 'https://logo.clearbit.com/nike.com',
      value: '\$120,000/year',
      duration: '3 years',
      category: 'Apparel',
      requirements: 'Minimum 100K social media followers\nProfessional status',
      benefits: 'Free gear\nPerformance bonuses\nGlobal exposure',
      matchScore: 92,
      matchReasons: [
        'High alignment with your basketball career',
        'Your social media engagement matches their target',
        'Your values align with their "Just Do It" philosophy'
      ],
      contact: Contact(
        name: 'Michael Johnson',
        email: 'm.johnson@nike.com',
        phone: '+1 (555) 123-4567',
      ),
    ),
    Sponsorship(
      id: '2',
      company: 'Gatorade',
      title: 'Sports Nutrition Partnership',
      description: 'Hydration and nutrition sponsorship for endurance athletes',
      logoUrl: 'https://logo.clearbit.com/gatorade.com',
      value: '\$75,000/year',
      duration: '2 years',
      category: 'Nutrition',
      requirements: 'Competitive athlete\nActive on social media',
      benefits: 'Product supply\nResearch opportunities\nAppearance fees',
      matchScore: 85,
      matchReasons: [
        'Your training regimen matches their hydration needs',
        'Your public persona fits their "Fuel Your Performance" campaign',
        'Demographics match their target audience'
      ],
      contact: Contact(
        name: 'Sarah Williams',
        email: 's.williams@pepsico.com',
        phone: '+1 (555) 987-6543',
      ),
    ),
    Sponsorship(
      id: '3',
      company: 'Rolex',
      title: 'Brand Ambassador Program',
      description: 'Luxury brand partnership for elite athletes',
      logoUrl: 'https://logo.clearbit.com/rolex.com',
      value: '\$250,000/year',
      duration: '4 years',
      category: 'Luxury',
      requirements: 'World-class athlete\nExceptional public image',
      benefits: 'Global campaigns\nExclusive events\nCustom timepieces',
      matchScore: 78,
      matchReasons: [
        'Your achievements align with their excellence standards',
        'Your international appeal matches their global brand',
        'Your career trajectory shows long-term potential'
      ],
      contact: Contact(
        name: 'David Chen',
        email: 'd.chen@rolex.com',
        phone: '+41 22 302 2200',
      ),
    ),
  ];

  List<Sponsorship> get _recommendedSponsorships {
    return _allSponsorships.where((sponsor) => sponsor.matchScore > 80).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sponsorship Opportunities'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue[900],
      ),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: _selectedTabIndex == 0
                ? _buildSponsorshipList(_allSponsorships)
                : _buildSponsorshipList(_recommendedSponsorships),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.blue[900],
      child: Row(
        children: [
          Expanded(
            child: _buildTabButton(0, 'All Sponsorships'),
          ),
          Expanded(
            child: _buildTabButton(1, 'AI Recommended'),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, String label) {
    return TextButton(
      onPressed: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      style: TextButton.styleFrom(
        foregroundColor:
            _selectedTabIndex == index ? Colors.white : Colors.white70,
        backgroundColor:
            _selectedTabIndex == index ? Colors.blue[700] : Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildSponsorshipList(List<Sponsorship> sponsorships) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sponsorships.length,
      itemBuilder: (context, index) {
        final sponsorship = sponsorships[index];
        return _buildSponsorshipCard(sponsorship);
      },
    );
  }

  Widget _buildSponsorshipCard(Sponsorship sponsorship) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showSponsorshipDetails(sponsorship),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[100],
                    ),
                    child: CachedNetworkImage(
                      imageUrl: sponsorship.logoUrl,
                      placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.business, size: 30),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sponsorship.company,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          sponsorship.title,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_selectedTabIndex == 1)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getMatchScoreColor(sponsorship.matchScore),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${sponsorship.matchScore}% Match',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                sponsorship.description,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDetailChip(
                      Icons.attach_money, sponsorship.value),
                  _buildDetailChip(
                      Icons.calendar_today, sponsorship.duration),
                  _buildDetailChip(
                      Icons.category, sponsorship.category),
                ],
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _showSponsorshipDetails(sponsorship),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue[800],
                  ),
                  child: const Text('View Details >'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailChip(IconData icon, String text) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Text(text),
      backgroundColor: Colors.grey[100],
      visualDensity: VisualDensity.compact,
    );
  }

  Color _getMatchScoreColor(int score) {
    if (score >= 90) return Colors.green;
    if (score >= 80) return Colors.lightGreen;
    if (score >= 70) return Colors.orange;
    return Colors.red;
  }

  void _showSponsorshipDetails(Sponsorship sponsorship) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 60,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[100],
                      ),
                      child: CachedNetworkImage(
                        imageUrl: sponsorship.logoUrl,
                        placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.business, size: 40),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sponsorship.company,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            sponsorship.title,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Sponsorship Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(),
                const SizedBox(height: 8),
                _buildDetailItem('Description', sponsorship.description),
                _buildDetailItem('Contract Value', sponsorship.value),
                _buildDetailItem('Duration', sponsorship.duration),
                _buildDetailItem('Category', sponsorship.category),
                _buildDetailItem('Requirements', sponsorship.requirements),
                _buildDetailItem('Benefits', sponsorship.benefits),
                if (_selectedTabIndex == 1) ...[
                  const SizedBox(height: 24),
                  const Text(
                    'Why This Matches You',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 8),
                  Column(
                    children: sponsorship.matchReasons
                        .map((reason) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.check_circle,
                                      color: Colors.green[400], size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(reason)),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ],
                const SizedBox(height: 24),
                const Text(
                  'Contact Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(),
                const SizedBox(height: 8),
                _buildContactItem(Icons.person, sponsorship.contact.name),
                _buildContactItem(Icons.email, sponsorship.contact.email),
                _buildContactItem(Icons.phone, sponsorship.contact.phone),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: Colors.blue[800]!),
                        ),
                        child: Text(
                          'Close',
                          style: TextStyle(color: Colors.blue[800]),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _contactSponsor(sponsorship.contact),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[800],
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Contact Sponsor'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue[800]),
          const SizedBox(width: 12),
          Text(text),
        ],
      ),
    );
  }

  void _contactSponsor(Contact contact) {
    // Implement contact functionality (email, phone call, etc.)
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Contact Sponsor'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${contact.name}'),
              Text('Email: ${contact.email}'),
              Text('Phone: ${contact.phone}'),
              const SizedBox(height: 16),
              const Text('How would you like to contact them?'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Implement email functionality
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                      content: Text('Email client opened for ${contact.email}')),
                );
              },
              child: const Text('Email'),
            ),
            TextButton(
              onPressed: () {
                // Implement phone call functionality
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                      content: Text('Phone dialer opened for ${contact.phone}')),
                );
              },
              child: const Text('Call'),
            ),
          ],
        );
      },
    );
  }
}

class Sponsorship {
  final String id;
  final String company;
  final String title;
  final String description;
  final String logoUrl;
  final String value;
  final String duration;
  final String category;
  final String requirements;
  final String benefits;
  final int matchScore;
  final List<String> matchReasons;
  final Contact contact;

  Sponsorship({
    required this.id,
    required this.company,
    required this.title,
    required this.description,
    required this.logoUrl,
    required this.value,
    required this.duration,
    required this.category,
    required this.requirements,
    required this.benefits,
    required this.matchScore,
    required this.matchReasons,
    required this.contact,
  });
}

class Contact {
  final String name;
  final String email;
  final String phone;

  Contact({
    required this.name,
    required this.email,
    required this.phone,
  });
}