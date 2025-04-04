import 'package:flutter/material.dart';
import 'recycling_centers.dart';

class DisposalGuideScreen extends StatelessWidget {
  const DisposalGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disposal Guide'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Disposal Guide',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
              ),
              const SizedBox(height: 16),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.2,
                children: [
                  _categoryCard(
                    context,
                    Icons.phone_android,
                    'Smartphones',
                    'Phones & Tablets',
                    Colors.red.shade100,
                    const SmartphoneDisposalScreen(),
                  ),
                  _categoryCard(
                    context,
                    Icons.computer,
                    'Computers',
                    'Laptops & Desktops',
                    Colors.blue.shade100,
                    const ComputerDisposalScreen(),
                  ),
                  _categoryCard(
                    context,
                    Icons.battery_full,
                    'Batteries',
                    'All Types',
                    Colors.yellow.shade100,
                    const BatteryDisposalScreen(),
                  ),
                  _categoryCard(
                    context,
                    Icons.tv,
                    'Appliances',
                    'Home Electronics',
                    Colors.purple.shade100,
                    const ApplianceDisposalScreen(),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              const Text('Popular Guidelines', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),

              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _guideCard(context, 'Battery Disposal', 'Learn how to safely dispose of different types of batteries', Colors.green, 'Easy'),
                  _guideCard(context, 'Smartphone Recycling', 'Steps to properly recycle your old smartphone', Colors.orange, 'Medium'),
                  _guideCard(context, 'Computer Parts', 'Detailed guide for computer components disposal', Colors.red, 'Advanced'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _categoryCard(BuildContext context, IconData icon, String title, String subtitle, Color color, Widget screen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
      },
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.black54),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _guideCard(BuildContext context, String title, String description, Color color, String difficulty) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Text(description),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(difficulty),
                  backgroundColor: color.withOpacity(0.2),
                  labelStyle: TextStyle(color: color, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PlaceholderGuideScreen(title: title)),
                    );
                  },
                  child: const Text('Read Guide', style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder pages
class PlaceholderGuideScreen extends StatelessWidget {
  final String title;
  const PlaceholderGuideScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text('Guide Content for $title (To be developed)', style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}

// Smartphone Disposal Guide
class SmartphoneDisposalScreen extends StatelessWidget {
  const SmartphoneDisposalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _guideScreen(context, 'Smartphone Disposal', [
      'Backup your data before disposal.',
      'Perform a factory reset to erase personal information.',
      'Remove and recycle the battery separately.',
      'Find an authorized e-waste recycler.',
      'Donate if the phone is still functional.',
    ]);
  }
}

// Computer Disposal Guide
class ComputerDisposalScreen extends StatelessWidget {
  const ComputerDisposalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _guideScreen(context, 'Computer Disposal', [
      'Back up important data.',
      'Wipe the hard drive to remove personal files.',
      'Remove and recycle components like RAM, HDD, and battery.',
      'Check for manufacturer take-back programs.',
      'Donate if the device is still working.',
    ]);
  }
}

// Battery Disposal Guide
class BatteryDisposalScreen extends StatelessWidget {
  const BatteryDisposalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _guideScreen(context, 'Battery Disposal', [
      'Check battery type (Lithium-ion, Alkaline, etc.).',
      'Never throw batteries in regular trash.',
      'Drop off at battery recycling bins.',
      'Store used batteries in a cool, dry place before disposal.',
      'Follow local e-waste disposal laws.',
    ]);
  }
}

// Appliance Disposal Guide
class ApplianceDisposalScreen extends StatelessWidget {
  const ApplianceDisposalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _guideScreen(context, 'Appliance Disposal', [
      'Unplug and clean the appliance.',
      'Remove batteries and hazardous materials.',
      'Contact local e-waste collection services.',
      'Check trade-in programs for old appliances.',
      'Sell or donate if the appliance still works.',
    ]);
  }
}

Widget _guideScreen(BuildContext context, String title, List<String> steps) {
  return Scaffold(
    appBar: AppBar(title: Text(title)),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
          ),
          const SizedBox(height: 16),

          // Interactive Steps
          ...steps.map((step) => _expandableStep(step)).toList(),
          const SizedBox(height: 20),

          // Find Recycling Center Button
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecyclingCentersMap(),
                  ),
                );
              },
              icon: const Icon(Icons.location_on),
              label: const Text('Find Recycling Center'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
          ),
        ],
      ),
    ),
  );
}

// Define a map for step details
final Map<String, String> stepDetails = {
  'Backup your data before disposal.': 'Ensure you save all your important files and settings before discarding your device.',
  'Perform a factory reset to erase personal information.': 'A factory reset wipes all data and accounts from the phone, making it safer to dispose.',
  'Remove and recycle the battery separately.': 'Batteries contain harmful chemicals. It is best to recycle them through an authorized e-waste center.',
  'Find an authorized e-waste recycler.': 'Check online directories or government websites for certified recycling centers.',
  'Donate if the phone is still functional.': 'Many organizations accept old phones for refurbishment and reuse.',

  'Back up important data.': 'Save important files to an external hard drive or cloud storage before disposing of the computer.',
  'Wipe the hard drive to remove personal files.': 'Use disk-wiping software to permanently erase data from your hard drive.',
  'Remove and recycle components like RAM, HDD, and battery.': 'Certain parts can be reused or recycled separately for environmental benefits.',
  'Check for manufacturer take-back programs.': 'Some brands offer recycling programs where they take back old devices responsibly.',
  'Donate if the device is still working.': 'Consider donating to schools, NGOs, or charities that accept second-hand electronics.',

  'Check battery type (Lithium-ion, Alkaline, etc.).': 'Different batteries require different disposal methods. Identify the type before discarding.',
  'Never throw batteries in regular trash.': 'Batteries contain toxic materials that can pollute landfills and water sources.',
  'Drop off at battery recycling bins.': 'Find a local store or recycling center that accepts used batteries.',
  'Store used batteries in a cool, dry place before disposal.': 'Avoid keeping old batteries in hot places to prevent leaks or explosions.',
  'Follow local e-waste disposal laws.': 'Check with your city’s waste management services for proper disposal rules.',

  'Unplug and clean the appliance.': 'Remove dust, grime, and any remaining food from old appliances before recycling.',
  'Remove batteries and hazardous materials.': 'Some appliances contain harmful substances that need special handling.',
  'Contact local e-waste collection services.': 'Many cities have programs that collect old appliances for recycling.',
  'Check trade-in programs for old appliances.': 'Retailers may offer discounts on new purchases in exchange for old appliances.',
  'Sell or donate if the appliance still works.': 'Consider selling on platforms like eBay or donating to those in need.',
};

// Modify the `_expandableStep` function to show detailed information
Widget _expandableStep(String step) {
  return Card(
    child: ExpansionTile(
      title: Text(step, style: const TextStyle(fontWeight: FontWeight.bold)),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(stepDetails[step] ?? 'No details available for this step.'),
        ),
      ],
    ),
  );
}





