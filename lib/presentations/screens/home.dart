import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'features.dart';
import 'profileathlete.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static String routeName = 'HomePage';
  static String routePath = '/homePage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TextEditingController _textController;
  late FocusNode _textFieldFocusNode;
  bool _showSpendingAlert = true;
  bool isHovered = false;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _textFieldFocusNode = FocusNode();
    Future.delayed(const Duration(seconds: 3), () {
      if (_showSpendingAlert) {
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Spending Alert'),
              content: const Text(
                  'You are currently spending excessively on dining. Consider setting a budget to manage your finances more effectively.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Set Budget'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _showSpendingAlert = false;
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('Dismiss'),
                ),
              ],
            );
          },
        );
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _textFieldFocusNode.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FeaturesScreen()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  final List<Widget> _pages = [
    HomeContent(),
    FeaturesScreen(),
    AthleteProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          backgroundColor: const Color(0xFF2979FF),
          title: Text(
            'AthleteVerse',
            style: GoogleFonts.openSans(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          elevation: 3,
        ),
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: const Color(0xFF2979FF),
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Features'),
            BottomNavigationBarItem(
              icon: CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://images.pexels.com/photos/1239288/pexels-photo-1239288.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                ),
                radius: 12,
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Search...',
              prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Tooltip(
            message: "Report any issue anonymously",
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/anonymousreporting');
              },
              icon: Icon(Icons.privacy_tip, size: 24, color: Colors.white),
              label: Text(
                'Anonymous Reporting',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                fixedSize: Size.fromHeight(50),
                padding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 16.0,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1,
            children: [
              _buildGridItem(
                context: context,
                title: 'Webinars',
                description: 'Join Live Sessions & Workshops',
                imageUrl:
                    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/athlete-verse-duco0h/assets/rtn68wbgkpyc/webinar_(3).png',
                routeName: '/webinars',
              ),
              _buildGridItem(
                context: context,
                title: 'Career Planning',
                description: 'Shape Your Athletic Future',
                imageUrl:
                    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/athlete-verse-duco0h/assets/14s2iu3z58uq/career-path.png',
                routeName: '/careerplanning',
              ),
              _buildGridItem(
                context: context,
                title: 'Organizations',
                description: 'Connect with sports bodies',
                imageUrl:
                    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/athlete-verse-duco0h/assets/ckfcuipvqru9/partners.png',
                routeName: '/organizations',
              ),
              _buildGridItem(
                context: context,
                title: 'Finances',
                description: 'Manage your resources',
                imageUrl:
                    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/athlete-verse-duco0h/assets/5z2y7rn2b554/budget.png',
                routeName: '/finance',
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Top Organizations',
            style: GoogleFonts.openSans(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 162,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildOrganizationItem(
                  'Khelo India',
                  'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/athlete-verse-duco0h/assets/2olhg2krgo32/kheloindia.jpeg',
                ),
                _buildOrganizationItem(
                  'SAI',
                  'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/athlete-verse-duco0h/assets/jbbozm17zuki/sai.jpeg',
                ),
                _buildOrganizationItem(
                  'IOA',
                  'https://upload.wikimedia.org/wikipedia/en/thumb/e/e0/IOA-Logo.svg/1200px-IOA-Logo.svg.png',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildGridItem({
    required BuildContext context,
    required String title,
    required String description,
    required String imageUrl,
    required String routeName,
  }) {
    bool isHovered = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, routeName);
            },
            borderRadius: BorderRadius.circular(18),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2979FF), Color(0xFF0091EA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: Image.network(
                      imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      loadingBuilder: (
                        BuildContext context,
                        Widget child,
                        ImageChunkEvent? loadingProgress,
                      ) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.openSans(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: isHovered ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrganizationItem(String name, String logoUrl) {
    bool isHovered = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                    child: Image.network(
                      logoUrl,
                      width: 180,
                      height: 130,
                      fit: BoxFit.cover,
                      loadingBuilder: (
                        BuildContext context,
                        Widget child,
                        ImageChunkEvent? loadingProgress,
                      ) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  AnimatedOpacity(
                    opacity: isHovered ? 1.0 : 0.5,
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      name,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF333333),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Profile Page',
        style: GoogleFonts.openSans(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF333333),
        ),
      ),
    );
  }
}