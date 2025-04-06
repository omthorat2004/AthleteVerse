import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:myapp/providers/user_provider.dart';

class AthleteProfilePage extends StatefulWidget {
  const AthleteProfilePage({super.key});

  @override
  State<AthleteProfilePage> createState() => _AthleteProfilePageState();
}

class _AthleteProfilePageState extends State<AthleteProfilePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');

  
  final Map<String, dynamic> _athleteData = {
    'email': '', 
    'name': 'Alex Morgan',
    'photoUrl': 'https://example.com/athlete.jpg',
    'sport': 'Soccer',
    'team': 'US Women\'s National Team',
    'age': 34,
    'height': 170,
    'weight': 65,
    'currentSeason': '2023-24',
    'gamesPlayed': 24,
    'pointsPerGame': 1.2,
    'contractValue': 2500000,
    'fitnessLevel': 88,
    'injuryRisk': 12,
    'achievements': [
      {'title': 'World Cup Champion', 'date': '2023-07-10', 'competition': 'FIFA Women\'s World Cup'},
      {'title': 'Golden Boot Winner', 'date': '2022-11-20', 'competition': 'NWSL'},
      {'title': 'Team MVP', 'date': '2022-09-15', 'competition': 'Club Season'},
    ],
    'upcomingEvents': [
      {'title': 'Friendly Match vs Sweden', 'date': '2023-10-22', 'location': 'Stockholm'},
      {'title': 'League Championship', 'date': '2023-11-05', 'location': 'Los Angeles'},
      {'title': 'Sponsor Event', 'date': '2023-11-15', 'location': 'New York'},
    ],
    'performanceData': [
      {'month': 'Jan', 'goals': 3, 'assists': 2},
      {'month': 'Feb', 'goals': 2, 'assists': 3},
      {'month': 'Mar', 'goals': 4, 'assists': 1},
      {'month': 'Apr', 'goals': 3, 'assists': 2},
      {'month': 'May', 'goals': 5, 'assists': 0},
      {'month': 'Jun', 'goals': 2, 'assists': 4},
    ],
    'injuryHistory': [
      {'type': 'Ankle Sprain', 'date': '2023-02-15', 'recoveryDays': 21, 'status': 'Recovered'},
      {'type': 'Hamstring Strain', 'date': '2022-08-10', 'recoveryDays': 42, 'status': 'Recovered'},
    ],
    'careerMilestones': [
      {'title': 'First Professional Contract', 'date': '2010-01-15'},
      {'title': 'National Team Debut', 'date': '2011-03-22'},
      {'title': 'Olympic Gold Medal', 'date': '2012-08-09'},
    ],
    'financialData': {
      'salary': 2000000,
      'endorsements': 500000,
      'investments': 750000,
      'transactions': [
        {'description': 'Salary Payment', 'amount': 166666, 'date': '2023-09-01', 'type': 'income'},
        {'description': 'Nike Sponsorship', 'amount': 125000, 'date': '2023-09-15', 'type': 'income'},
        {'description': 'Real Estate Investment', 'amount': -300000, 'date': '2023-08-20', 'type': 'expense'},
      ],
    },
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        // Get email from Firebase
        final email = userProvider.user?.email;
        _athleteData['email'] = email ?? 'athlete@example.com';
        
        return Scaffold(
          appBar: AppBar(
            title: const Text('Athlete Profile'),
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Performance'),
                Tab(text: 'Health'),
                Tab(text: 'Career'),
                Tab(text: 'Finance'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildOverviewTab(),
              _buildPerformanceTab(),
              _buildHealthTab(),
              _buildCareerTab(),
              _buildFinanceTab(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 30),
          _buildKeyMetrics(),
          const SizedBox(height: 30),
          _buildRecentAchievements(),
          const SizedBox(height: 30),
          _buildUpcomingEvents(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(_athleteData['photoUrl']),
          child: const Icon(Icons.person, size: 50),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _athleteData['name'],
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                '${_athleteData['sport']} | ${_athleteData['team']}',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildInfoChip(Icons.email, _athleteData['email']),
                  const SizedBox(width: 10),
                  _buildInfoChip(Icons.calendar_today, '${_athleteData['age']} yrs'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(text),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildKeyMetrics() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Key Metrics',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 2.5,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                _buildMetricTile('Current Season', _athleteData['currentSeason']),
                _buildMetricTile('Games Played', _athleteData['gamesPlayed'].toString()),
                _buildMetricTile('Points/Game', _athleteData['pointsPerGame'].toStringAsFixed(1)),
                _buildMetricTile('Contract Value', _formatCurrency(_athleteData['contractValue'])),
                _buildMetricTile('Fitness Level', '${_athleteData['fitnessLevel']}%'),
                _buildMetricTile('Injury Risk', '${_athleteData['injuryRisk']}%'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile(String title, String value) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentAchievements() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Achievements',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            ...List.generate(3, (index) {
              final achievement = _athleteData['achievements'][index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: const Icon(Icons.emoji_events, color: Colors.amber),
                  title: Text(achievement['title']),
                  subtitle: Text(_dateFormat.format(DateTime.parse(achievement['date']))),
                  trailing: Text(achievement['competition']),
                ),
              );
            }),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text('View All'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingEvents() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Upcoming Events',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            ...List.generate(3, (index) {
              final event = _athleteData['upcomingEvents'][index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: const Icon(Icons.event, color: Colors.blue),
                  title: Text(event['title']),
                  subtitle: Text('${_dateFormat.format(DateTime.parse(event['date']))} • ${event['location']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.notifications),
                    onPressed: () {},
                  ),
                ),
              );
            }),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text('View All'),
              ),
            ),
          ],
        ),
      ),
    );
  }
Widget _buildPerformanceTab() {
  // Safely cast performance data with proper types
  final List<Map<String, dynamic>> performanceData = 
      (_athleteData['performanceData'] as List?)?.cast<Map<String, dynamic>>() ?? [];

  // Calculate totals with explicit type handling
  final int totalGoals = performanceData.fold<int>(
    0, 
    (int sum, Map<String, dynamic> item) => sum + ((item['goals'] as int?) ?? 0)
  );
  
  final int totalAssists = performanceData.fold<int>(
    0, 
    (int sum, Map<String, dynamic> item) => sum + ((item['assists'] as int?) ?? 0)
  );

  final int gamesPlayed = (_athleteData['gamesPlayed'] as int?) ?? 0;
  final int minutesPlayed = gamesPlayed * 90;

  return SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Performance Analytics',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        
        // Performance Chart
        SizedBox(
          height: 300,
          child: performanceData.isNotEmpty
              ? SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  series: <CartesianSeries<Map<String, dynamic>, String>>[
                    ColumnSeries<Map<String, dynamic>, String>(
                      dataSource: performanceData,
                      xValueMapper: (Map<String, dynamic> data, _) => 
                          data['month']?.toString() ?? '',
                      yValueMapper: (Map<String, dynamic> data, _) => 
                          (data['goals'] as int?) ?? 0,
                      name: 'Goals',
                      color: Colors.blue,
                    ),
                    ColumnSeries<Map<String, dynamic>, String>(
                      dataSource: performanceData,
                      xValueMapper: (Map<String, dynamic> data, _) => 
                          data['month']?.toString() ?? '',
                      yValueMapper: (Map<String, dynamic> data, _) => 
                          (data['assists'] as int?) ?? 0,
                      name: 'Assists',
                      color: Colors.green,
                    ),
                  ],
                )
              : const Center(
                  child: Text('No performance data available'),
                ),
        ),
        const SizedBox(height: 30),
        
        // Season Statistics
        const Text(
          'Season Statistics',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        
        DataTable(
          columns: const [
            DataColumn(label: Text('Metric')),
            DataColumn(label: Text('Value'), numeric: true),
          ],
          rows: [
            DataRow(cells: [
              const DataCell(Text('Games Played')),
              DataCell(Text(gamesPlayed.toString())),
            ]),
            DataRow(cells: [
              const DataCell(Text('Goals')),
              DataCell(Text(totalGoals.toString())),
            ]),
            DataRow(cells: [
              const DataCell(Text('Assists')),
              DataCell(Text(totalAssists.toString())),
            ]),
            DataRow(cells: [
              const DataCell(Text('Minutes Played')),
              DataCell(Text('$minutesPlayed min')),
            ]),
          ],
        ),
      ],
    ),
  );
}

  Widget _buildHealthTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Health & Fitness',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Fitness Status',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  LinearProgressIndicator(
                    value: _athleteData['fitnessLevel'] / 100,
                    backgroundColor: Colors.grey[200],
                    color: _athleteData['fitnessLevel'] > 75 ? Colors.green : 
                           _athleteData['fitnessLevel'] > 50 ? Colors.amber : Colors.red,
                    minHeight: 20,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Fitness Level: ${_athleteData['fitnessLevel']}%',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Injury Risk: ${_athleteData['injuryRisk']}%',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Injury History',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          ..._athleteData['injuryHistory'].map<Widget>((injury) => Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              title: Text(injury['type']),
              subtitle: Text('${_dateFormat.format(DateTime.parse(injury['date']))} • ${injury['recoveryDays']} days recovery'),
              trailing: Chip(
                label: Text(injury['status']),
                backgroundColor: injury['status'] == 'Recovered' ? Colors.green[100] : Colors.orange[100],
              ),
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildCareerTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Career Overview',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const Text(
            'Career Milestones',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          ..._athleteData['careerMilestones'].map<Widget>((milestone) => Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: const Icon(Icons.star, color: Colors.amber),
              title: Text(milestone['title']),
              subtitle: Text(_dateFormat.format(DateTime.parse(milestone['date']))),
            ),
          )).toList(),
          const SizedBox(height: 30),
          const Text(
            'Career Statistics',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          DataTable(
            columns: const [
              DataColumn(label: Text('Statistic')),
              DataColumn(label: Text('Value'), numeric: true),
            ],
            rows: [
              DataRow(cells: [
                const DataCell(Text('Professional Debut')),
                DataCell(Text('2010')),
              ]),
              DataRow(cells: [
                const DataCell(Text('International Caps')),
                DataCell(Text('206')),
              ]),
              DataRow(cells: [
                const DataCell(Text('International Goals')),
                DataCell(Text('123')),
              ]),
              DataRow(cells: [
                const DataCell(Text('Club Appearances')),
                DataCell(Text('320')),
              ]),
              DataRow(cells: [
                const DataCell(Text('Club Goals')),
                DataCell(Text('198')),
              ]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinanceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Financial Overview',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Annual Income',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildFinancePieChart(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFinanceLegendItem('Salary', Colors.blue, _formatCurrency(_athleteData['financialData']['salary'])),
                          _buildFinanceLegendItem('Endorsements', Colors.green, _formatCurrency(_athleteData['financialData']['endorsements'])),
                          _buildFinanceLegendItem('Investments', Colors.amber, _formatCurrency(_athleteData['financialData']['investments'])),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Recent Transactions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          ..._athleteData['financialData']['transactions'].map<Widget>((transaction) => Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: Icon(
                transaction['type'] == 'income' ? Icons.arrow_circle_up : Icons.arrow_circle_down,
                color: transaction['type'] == 'income' ? Colors.green : Colors.red,
              ),
              title: Text(transaction['description']),
              subtitle: Text(_dateFormat.format(DateTime.parse(transaction['date']))),
              trailing: Text(
                _formatCurrency(transaction['amount']),
                style: TextStyle(
                  color: transaction['type'] == 'income' ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildFinancePieChart() {
    return SizedBox(
      width: 150,
      height: 150,
      child: SfCircularChart(
        series: <CircularSeries>[
          PieSeries<Map<String, dynamic>, String>(
            dataSource: [
              {'category': 'Salary', 'value': _athleteData['financialData']['salary'], 'color': Colors.blue},
              {'category': 'Endorsements', 'value': _athleteData['financialData']['endorsements'], 'color': Colors.green},
              {'category': 'Investments', 'value': _athleteData['financialData']['investments'], 'color': Colors.amber},
            ],
            xValueMapper: (data, _) => data['category'],
            yValueMapper: (data, _) => data['value'],
            pointColorMapper: (data, _) => data['color'],
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    );
  }

  Widget _buildFinanceLegendItem(String label, Color color, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            color: color,
          ),
          const SizedBox(width: 8),
          Text(label),
          const SizedBox(width: 8),
          Text(value),
        ],
      ),
    );
  }

  String _formatCurrency(double amount) {
    final format = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
    return format.format(amount);
  }
}