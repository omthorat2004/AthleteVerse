import 'package:flutter/material.dart';
class SportOrganizationHomePage extends StatelessWidget {
  const SportOrganizationHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _buildBody(context),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.blue[800],
      title: const Text(
        'BHARTIYA SPORTS',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16),
          _buildWelcomeHeader(),
          const SizedBox(height: 24),
          _buildDashboardSection(),
          const SizedBox(height: 16),
          _buildMainGridSections(context),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black54,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Sports Management Portal',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color:Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.blue[800],
        borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(
              Icons.dashboard,
              size: 56,
              color: Colors.white,
            ),
            const SizedBox(height: 12),
            const Text(
              'Organization Dashboard',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            _buildStatsRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _StatItem(
          value: '24',
          label: 'Athletes',
          icon: Icons.people,
        ),
        _StatItem(
          value: '5',
          label: 'Events',
          icon: Icons.event,
        ),
        _StatItem(
          value: '3',
          label: 'Tasks',
          icon: Icons.task,
        ),
      ],
    );
  }

  Widget _buildMainGridSections(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _GridCard(
            title: 'Athletes',
            icon: Icons.people,
            subtitle: '24 active',
            onTap: () => Navigator.pushNamed(context, '/athletes'),
          ),
          _GridCard(
            title: 'Scouting',
            icon: Icons.search,
            onTap: () => Navigator.pushNamed(context, '/organization/scouting'),
          ),
          _GridCard(
            title: 'Events',
            icon: Icons.event,
            subtitle: '5 upcoming',
            onTap: () => Navigator.pushNamed(context, '/events'),
          ),
          _GridCard(
            title: 'Sponsorships',
            icon: Icons.attach_money,
            onTap: () => Navigator.pushNamed(context, '/sponsorships'),
          ),
          _GridCard(
            title: 'Compliance',
            icon: Icons.gavel,
            onTap: () => Navigator.pushNamed(context, '/compliance'),
          ),
          _GridCard(
            title: 'Wellbeing',
            icon: Icons.favorite,
            onTap: () => Navigator.pushNamed(context, '/wellbeing'),
          ),
          _GridCard(
            title: 'Contracts',
            icon: Icons.description,
            onTap: () => Navigator.pushNamed(context, '/contracts'),
          ),
          _GridCard(
            title: 'Reports',
            icon: Icons.bar_chart,
            onTap: () => Navigator.pushNamed(context, '/reports'),
          ),
          _GridCard(
            title: 'Chat',
            icon: Icons.chat,
            subtitle: '3 unread',
            onTap: () => Navigator.pushNamed(context, '/chat'),
          ),
          _GridCard(
            title: 'Training',
            icon: Icons.fitness_center,
            onTap: () => Navigator.pushNamed(context, '/training'),
          ),
        ],
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 0,
      onTap: (index) {},
      selectedItemColor: Colors.blue[800],
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _StatItem({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 32,
          color: Colors.white,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _GridCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? subtitle;
  final VoidCallback onTap;

  const _GridCard({
    required this.title,
    required this.icon,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      shadowColor: Colors.blue.withOpacity(0.2),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 36,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 8),
                Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text(
          '$title Screen Content',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}