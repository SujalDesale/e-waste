import 'package:flutter/material.dart';
import 'recycling_centers.dart'; // Import the Recycling Centers page
import 'disposal_guide.dart';
import 'profile_page.dart'; // Import the ProfileScreen
import 'scanner_page.dart';
import 'learn_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 1) { // When "Guide" is tapped
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DisposalGuideScreen()), // Navigate to Disposal Guide
      );
    }
    else if (index == 2) { // When "Scanning" is tapped
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EwasteDetectionPage()), // Navigate to Recycling Centers
      );
    }

    else if(index==3)
      {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LearnPage()), // Navigate to Recycling Centers
        );
      }
    else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Waste Guide', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          GestureDetector(
            onTap: () {
              // Navigate to ProfileScreen when the icon is tapped
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
            child: CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: Icon(Icons.person, color: Colors.blue),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.blue.shade100,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: const [
                    Text('Welcome Back!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('Ready to make a positive impact?'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _featureCard(
                  icon: Icons.qr_code,
                  title: 'Scan Item',
                  subtitle: 'Identify disposal method',
                  onTap: () {
                    // Handle "Scan Item" tap here
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EwasteDetectionPage()), // Navigate to the Recycling Centers page
                    );
                  },
                ),
                _featureCard(
                  icon: Icons.location_on,
                  title: 'Find Centers',
                  subtitle: 'Nearby recycling locations',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RecyclingCentersMap()), // Navigate to the Recycling Centers page
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Your Impact', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Items Recycled', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 4),
                    const Text('12', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: 0.4,
                      backgroundColor: Colors.grey.shade300,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 8),
                    const Text('CO₂ Saved', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 4),
                    const Text('24kg', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Recent Activity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: Icon(Icons.check_circle, color: Colors.green),
                title: const Text('Recycled Old Phone'),
                subtitle: const Text('2 days ago'),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Guide'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner), label: 'Scan'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Impact'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _featureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap, // Handle tap event
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Icon(icon, size: 40, color: Colors.green),
                const SizedBox(height: 8),
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
