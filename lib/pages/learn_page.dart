import 'package:flutter/material.dart';
import 'video_player_screen.dart';

class LearnPage extends StatefulWidget {
  @override
  _LearnPageState createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  int _selectedCategoryIndex = 0;
  final List<String> categories = ["All", "Articles", "Videos", "Tips"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Learn", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // Add search functionality
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Filter
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(categories[index]),
                      selected: _selectedCategoryIndex == index,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategoryIndex = index;
                        });
                      },
                      selectedColor: Colors.green,
                      backgroundColor: Colors.grey[200],
                      labelStyle: TextStyle(
                          color: _selectedCategoryIndex == index
                              ? Colors.white
                              : Colors.black),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 20),

            // Featured Article
            Text("Featured", style: TextStyle(color: Colors.green)),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[200],
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[300], // Background color (optional)
                      image: DecorationImage(
                        image: AssetImage('assets/images/ewaste.png'), // Path to your image
                        fit: BoxFit.cover, // Adjust to fit the container
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Understanding E-Waste Impact",
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Learn about the environmental impact of electronic waste and why proper disposal matters.",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Video Tutorials
            Text("Video Tutorials",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  videoCard("Battery Recycling Guide", "4:32 mins", "https://www.youtube.com/watch?v=ClEp_ubHEYk"),
                  videoCard("Safe Phone Disposal", "1:48 mins", "https://www.youtube.com/watch?v=ClEp_ubHEYk"),
                  videoCard("Laptop E-Waste Management", "5:45 mins", "https://www.example.com/video3.mp4"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget videoCard(String title, String duration, String videoUrl) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerScreen(videoUrl: videoUrl),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[200],
          ),
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[300],
                ),
                child: Icon(Icons.play_circle_fill, color: Colors.grey[600]),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(duration, style: TextStyle(color: Colors.grey[700])),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
