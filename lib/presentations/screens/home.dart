import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'features.dart';

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
  bool isHovered = false;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _textFieldFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _textController.dispose();
    _textFieldFocusNode.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _pages = [HomeContent(), FeaturesScreen(), ProfileContent()];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            'AthleteVerse',
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
          centerTitle: true,
          elevation: 3,
        ),
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Features'),
            BottomNavigationBarItem(
              icon: CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://www.w3schools.com/w3images/avatar2.png',
                ), // Example Profile Image
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

// Home Page Content
class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Search...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1,
            children: [
              _buildGridItem(
                title: 'Webinars',
                description: 'Join Live Sessions & Workshops',
                imageUrl:
                    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/athlete-verse-duco0h/assets/rtn68wbgkpyc/webinar_(3).png',
              ),
              _buildGridItem(
                title: 'Career Planning',
                description: 'Shape Your Athletic Future',
                imageUrl:
                    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/athlete-verse-duco0h/assets/14s2iu3z58uq/career-path.png',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Features Page Content
class FeaturesContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Features Page',
        style: GoogleFonts.openSans(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// Profile Page Content
class ProfileContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
              'https://www.w3schools.com/w3images/avatar2.png', // Example Profile Image
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'John Doe',
            style: GoogleFonts.openSans(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Athlete & Mentor',
            style: GoogleFonts.openSans(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// Grid Item Widget
Widget _buildGridItem({
  required String title,
  required String description,
  required String imageUrl,
}) {
  return Container(
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Colors.blue, Color(0xFF3996DC)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      borderRadius: BorderRadius.circular(18),
      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
    ),
    padding: const EdgeInsets.all(10),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            imageUrl,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: GoogleFonts.openSans(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          description,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(fontSize: 12, color: Colors.white70),
        ),
      ],
    ),
  );
}
