import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SponsorshipsPage extends StatelessWidget {
  final List<Sponsorship> sponsorships = [
    Sponsorship(
      brand: 'Nike Athletics',
      value: 1200000,
      startDate: DateTime(2023, 1, 1),
      endDate: DateTime(2023, 12, 31),
      type: 'Apparel Sponsor',
      benefits: ['Free equipment', 'Discount codes', 'Appearance fees'],
      contractUrl: 'https://contracts.example.com/nike-2023',
      payments: [
        Payment(DateTime(2023, 1, 1), 100000, true),
        Payment(DateTime(2023, 4, 1), 100000, true),
        Payment(DateTime(2023, 7, 1), 100000, false),
        Payment(DateTime(2023, 10, 1), 100000, false),
      ],
    ),
    Sponsorship(
      brand: 'Gatorade',
      value: 800000,
      startDate: DateTime(2023, 3, 1),
      endDate: DateTime(2024, 3, 1),
      type: 'Nutrition Sponsor',
      benefits: ['Product supply', 'Performance bonuses'],
      contractUrl: 'https://contracts.example.com/gatorade-2023',
      payments: [
        Payment(DateTime(2023, 3, 1), 200000, true),
        Payment(DateTime(2023, 6, 1), 200000, true),
        Payment(DateTime(2023, 9, 1), 200000, false),
        Payment(DateTime(2023, 12, 1), 200000, false),
      ],
    ),
  ];

  SponsorshipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final totalValue = sponsorships.fold<double>(0, (sum, s) => sum + s.value);
    final paidAmount = sponsorships.fold<double>(0, (sum, s) => sum + 
      s.payments.where((p) => p.paid).fold<double>(0, (sum, p) => sum + p.amount));
    final remainingAmount = totalValue - paidAmount;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildSummaryCards(totalValue, paidAmount, remainingAmount),
            const SizedBox(height: 20),
            ...sponsorships.map((sponsor) => _buildSponsorshipCard(context, sponsor)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.blue[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.verified_user_rounded, color: Colors.white),
          const SizedBox(width: 12),
          const Text(
            'Sponsorship Agreements',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              sponsorships.length.toString(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(double total, double paid, double remaining) {
    return Row(
      children: [
        Expanded(child: _buildSummaryCard(
          title: 'Total Value',
          value: total,
          icon: Icons.attach_money_rounded,
        )),
        const SizedBox(width: 12),
        Expanded(child: _buildSummaryCard(
          title: 'Paid',
          value: paid,
          icon: Icons.check_circle_rounded,
        )),
        const SizedBox(width: 12),
        Expanded(child: _buildSummaryCard(
          title: 'Pending',
          value: remaining,
          icon: Icons.pending_rounded,
        )),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required double value,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 20, color: Colors.blue[800]),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0).format(value),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSponsorshipCard(BuildContext context, Sponsorship sponsor) {
    final progress = _calculateProgress(sponsor);
    final paidAmount = sponsor.payments.where((p) => p.paid).fold<double>(0, (sum, p) => sum + p.amount);
    final remainingAmount = sponsor.value - paidAmount;
    final nextPayment = sponsor.payments.firstWhere(
      (p) => !p.paid,
      orElse: () => Payment(DateTime.now(), 0, true) // Default paid payment if none found
    );

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Text(
                      sponsor.brand[0],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sponsor.brand,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        sponsor.type,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[800],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0).format(sponsor.value),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                    Text(
                      '${_monthsRemaining(sponsor.endDate)} months left',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildProgressBar(progress),
            const SizedBox(height: 16),
            _buildPaymentInfo(paidAmount, remainingAmount, nextPayment),
            const SizedBox(height: 16),
            _buildBenefits(sponsor.benefits),
            const SizedBox(height: 16),
            _buildContractButton(context, sponsor.contractUrl),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contract Progress',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              progress > 0.75 ? Colors.orange : Colors.blue,
            ),
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${(progress * 100).toStringAsFixed(1)}% complete',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentInfo(double paid, double remaining, Payment nextPayment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Status',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildPaymentMetric(
              'Paid',
              NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(paid),
              Colors.green,
            ),
            _buildPaymentMetric(
              'Pending',
              NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(remaining),
              Colors.orange,
            ),
            _buildPaymentMetric(
              'Next Payment',
              nextPayment.amount > 0 && !nextPayment.paid
                  ? NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(nextPayment.amount)
                  : 'Completed',
              Colors.blue,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentMetric(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildBenefits(List<String> benefits) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Benefits',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        const SizedBox(height: 8),
        Column(
          children: benefits.map((benefit) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle, size: 16, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    benefit,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildContractButton(BuildContext context, String contractUrl) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        icon: const Icon(Icons.article, size: 20),
        label: const Text('View E-Contract'),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.blue[800],
          side: BorderSide(color: Colors.blue[800]!),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () => _viewContract(context, contractUrl),
      ),
    );
  }

  void _viewContract(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('E-Contract'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Contract available at:'),
            const SizedBox(height: 8),
            SelectableText(
              url,
              style: const TextStyle(color: Colors.blue),
            ),
          ],
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

  double _calculateProgress(Sponsorship sponsor) {
    final totalDays = sponsor.endDate.difference(sponsor.startDate).inDays;
    final daysPassed = DateTime.now().difference(sponsor.startDate).inDays;
    return (daysPassed / totalDays).clamp(0.0, 1.0);
  }

  int _monthsRemaining(DateTime endDate) {
    return endDate.difference(DateTime.now()).inDays ~/ 30;
  }
}

class Sponsorship {
  final String brand;
  final double value;
  final DateTime startDate;
  final DateTime endDate;
  final String type;
  final List<String> benefits;
  final String contractUrl;
  final List<Payment> payments;

  Sponsorship({
    required this.brand,
    required this.value,
    required this.startDate,
    required this.endDate,
    required this.type,
    required this.benefits,
    required this.contractUrl,
    required this.payments,
  });
}

class Payment {
  final DateTime dueDate;
  final double amount;
  final bool paid;

  Payment(this.dueDate, this.amount, this.paid);
}