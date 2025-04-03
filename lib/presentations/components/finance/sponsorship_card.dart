import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SponsorshipCard extends StatelessWidget {
  final String brand;
  final double value;
  final DateTime startDate;
  final DateTime endDate;
  final String type;
  final List<String> benefits;
  final String contractUrl;
  final List<Payment> payments;

  const SponsorshipCard({
    super.key,
    required this.brand,
    required this.value,
    required this.startDate,
    required this.endDate,
    required this.type,
    required this.benefits,
    required this.contractUrl,
    required this.payments,
  });

  @override
  Widget build(BuildContext context) {
    final progress = _calculateProgress();
    final paidAmount = payments.fold<double>(0, (sum, payment) => sum + payment.amount);
    final remainingAmount = value - paidAmount;
    final nextPayment = payments.firstWhere((p) => !p.paid, orElse: () => Payment(DateTime.now(), 0, false));

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 12),
            _buildProgressBar(progress),
            const SizedBox(height: 12),
            _buildPaymentInfo(paidAmount, remainingAmount, nextPayment),
            const SizedBox(height: 12),
            _buildBenefits(),
            const SizedBox(height: 12),
            _buildContractButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
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
              brand[0],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
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
                brand,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$type • ${DateFormat('MMM y').format(startDate)} - ${DateFormat('MMM y').format(endDate)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(value),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${_monthsRemaining()} months left',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressBar(double progress) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              progress > 0.75 ? Colors.red : 
              progress > 0.5 ? Colors.orange : Colors.blue,
            ),
            minHeight: 6,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${(progress * 100).toStringAsFixed(1)}% complete',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
            Text(
              'Until ${DateFormat('d MMM y').format(endDate)}',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentInfo(double paidAmount, double remainingAmount, Payment nextPayment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Status:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildPaymentMetric('Paid', NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(paidAmount)),
            _buildPaymentMetric('Remaining', NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(remainingAmount)),
            _buildPaymentMetric(
              'Next Payment', 
              nextPayment.amount > 0 
                ? NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(nextPayment.amount)
                : 'Completed',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentMetric(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
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

  Widget _buildBenefits() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Benefits:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Column(
          children: benefits.map((benefit) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                const Icon(Icons.check_circle, size: 16, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(child: Text(benefit)),
              ],
            ),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildContractButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        icon: const Icon(Icons.article),
        label: const Text('View E-Contract'),
        onPressed: () => _viewContract(context),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  void _viewContract(BuildContext context) {
    // Implement contract viewing logic
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('E-Contract'),
        content: Text('Contract URL: $contractUrl'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  double _calculateProgress() {
    final totalDays = endDate.difference(startDate).inDays;
    final daysPassed = DateTime.now().difference(startDate).inDays;
    return daysPassed / totalDays;
  }

  int _monthsRemaining() {
    return endDate.difference(DateTime.now()).inDays ~/ 30;
  }
}

class Payment {
  final DateTime dueDate;
  final double amount;
  final bool paid;

  Payment(this.dueDate, this.amount, this.paid);
}